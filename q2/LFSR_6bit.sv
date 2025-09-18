module LFSR_6bit (
    input  logic clk, rst_n,
    input  logic sel,
    input  logic [5:0] parallel_in,
    output logic [5:0] parallel_out
);

logic [5:0] d;

always_comb begin
    if(!sel)
        d = parallel_in;
    else begin
        d[0] = parallel_out[5];
        d[2] = parallel_out[1];
        d[4] = parallel_out[3];
        d[5] = parallel_out[4];

        d[1] = parallel_out[0] ^ parallel_out[5];
        d[3] = parallel_out[2] ^ parallel_out[5];
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        parallel_out <= '0;
    else 
        parallel_out <= d;
end

endmodule
