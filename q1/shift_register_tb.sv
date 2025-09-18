module shift_register_tb;

// complete here
localparam N = 4;
localparam loops = 10000;

logic clk;
logic rst_n;
logic serial_parallel;
logic load_enable;
logic serial_in;
logic [N-1:0] parallel_in;
logic [N-1:0] parallel_out;
logic serial_out;

shift_register #(N) uut (
    .clk(clk),
    .rst_n(rst_n),
    .serial_parallel(serial_parallel),
    .load_enable(load_enable),
    .serial_in(serial_in),
    .parallel_in(parallel_in),
    .parallel_out(parallel_out),
    .serial_out(serial_out)
);

//Initial block to set the clocks
initial begin
    clk = 0;
    rst_n = 0;
    forever #5ns clk = ~clk;
end

//Main test
initial begin
    #5ns;
    rst_n = 1;
    for(int i = 0; i < 2; i++) begin
        load_enable = i;
        repeat(loops) begin
            serial_parallel = '1;
            parallel_in = $random;
            #10ns;

            serial_parallel = '0;
            serial_in = $random;
            #10ns;
        end
    end
    $stop;
end

//Assert to check if a parallel load loads correctly
assert property (@(posedge clk) serial_parallel && load_enable |=> parallel_out == $past(parallel_in)) 
    else $error("Parallel load failed, is %b, but should be %b", parallel_out, $past(parallel_in));

//Assert to check if a serial load loads correctly
assert property (@(posedge clk) !serial_parallel && load_enable |=> 
        parallel_out == {$past(parallel_out[N-2:0]), $past(serial_in)} &&
        serial_out == $past(parallel_out[N-2]))
    else $error("Serial load failed, is %b, but should be %b. Last clock had %b in parallel and got %b serial", parallel_out, {$past(parallel_out[N-2:0]), $past(serial_in)}, $past(parallel_out), $past(serial_in));

//Assert to check if disabling loading works
assert property (@(posedge clk) !load_enable |=> parallel_out == $past(parallel_out))
    else $error("Load happened even though load_enable was not active");

//Assert to check if the rst_n resets the register
assert property (@(negedge rst_n) 1 |=> parallel_out == '0);

endmodule