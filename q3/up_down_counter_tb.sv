module up_down_counter_tb;

localparam N = 4;
localparam loops = 1000;

logic clk;
logic rst_n;
logic up_down;
logic load;
logic [N-1:0] input_load;
logic [N-1:0] count_out;
logic carry_out;

up_down_counter #(N) dut (
    .clk(clk),
    .rst_n(rst_n),
    .up_down(up_down),
    .load(load),
    .input_load(input_load),
    .count_out(count_out),
    .carry_out(carry_out)
);

initial begin
    clk = 0;
    rst_n = 1;
    forever #5ns clk = ~clk;
end

initial begin
    up_down = 0;
    load = 1;

    #1ns rst_n = 0;
    #1ns rst_n = 1;
    repeat(loops) begin
        load = 0;
        repeat($urandom_range(10, 100)) begin
            #10ns;
        end
        up_down = ~up_down;
        input_load = $random;
        load = 1;
        #10ns;
    end
    $stop;
end

assert property (@(posedge clk) load |=> count_out == $past(input_load))
    else $error("Load failed, is %b, should be %b", count_out, $past(input_load));

assert property (@(posedge clk) !load && up_down |=> count_out == $past(count_out) + 1'b1)
    else $error("Upcount failed, is %b, but should have been %b", count_out, $past(count_out) + 1'b1);

assert property (@(posedge clk) !load && !up_down |=> count_out + 1'b1 == $past(count_out))
    else $error("Downcount failed, is %b, but should have been %b", count_out, $past(count_out));

assert property (@(posedge clk) !load && up_down && &count_out |=> carry_out)
    else $error("Carry out failed while counting up");

assert property (@(posedge clk) !load && !up_down && ~|count_out |=> carry_out)
    else $error("Carry out failed while counting down");

assert property (@(posedge clk) carry_out |-> ~|$past(count_out) && !$past(up_down) || &$past(count_out) && $past(up_down))
    else $error("Carry out set when it should be unset");


endmodule