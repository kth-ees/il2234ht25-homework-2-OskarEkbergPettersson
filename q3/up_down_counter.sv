module up_down_counter #(parameter N = 4)(
    input  logic clk,
    input  logic rst_n,
    input  logic up_down,
    input  logic load,
    input  logic [N-1:0] input_load,
    output logic [N-1:0] count_out,
    output logic carry_out
);
  
logic c_out, carry;
logic [N-1:0] a, b;
logic [N-1:0] sum, count;

assign a = count_out;
assign b = up_down ? 1 : '1;
assign {c_out, sum} = a + b;
assign count = load ? input_load : sum;

assign carry = (c_out && up_down) | (~|count_out && ~up_down);


always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        count_out <= '0;
        carry_out <= '0;
    end else begin
        count_out <= count;
        carry_out <= carry;
    end
end

endmodule