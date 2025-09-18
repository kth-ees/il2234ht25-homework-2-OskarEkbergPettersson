module LFSR_6bit_tb;

localparam loops = 100000;

logic clk, rst_n;
logic sel;
logic [5:0] parallel_in;
logic [5:0] parallel_out;

LFSR_6bit dut (
    .clk(clk),
    .rst_n(rst_n),
    .sel(sel),
    .parallel_in(parallel_in),
    .parallel_out(parallel_out)
);

initial begin
    clk = 0;
    rst_n = 1;
    forever #5 clk = ~clk;
end

initial begin
    #1ns rst_n = 0;
    #1ns rst_n = 1;
    #8ns;

    repeat(loops) begin
        sel = $random;
        parallel_in = $random;
        #10ns;
    end
    $stop;
end

assert property (@(posedge clk) sel |=> parallel_out == ($past(parallel_out) << 1 | ($past(parallel_out) >> 5)) ^ 6'b001010)
    else $error("Serial load failed, is %b, but should be %b", parallel_out, ($past(parallel_out) << 1 | ($past(parallel_out) >> 5)) ^ 6'b001010);

assert property (@(posedge clk) !sel |=> parallel_out == $past(parallel_in))
    else $error("Parallel load failed, is %b, but should be %b", parallel_out, $past(parallel_in));

assert property (@(negedge rst_n) 1 |=> parallel_out == '0)
    else $error("Reset did not occur");

endmodule