module shift_register #(
	parameter N=4
)(
	input logic clk,
	input logic rst_n,
	input logic serial_parallel,
	input logic load_enable,
	input logic serial_in,
	input logic [N-1:0] parallel_in,
	output logic [N-1:0] parallel_out,
	output logic serial_out
);

//complete here

logic [N-1:0] d;

always_comb begin

	d = !load_enable ? parallel_out :
		serial_parallel ? parallel_in : {parallel_out[N-2 : 0], serial_in};

	serial_out = parallel_out[N - 1];
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		parallel_out <= '0;
	else begin
		parallel_out <= d;
	end
end

endmodule
