`include "global.vh"

// пямять данных
module datamem (
input clk,
input we,
input [`H:0] addr, 
input [`H:0] wd, 
output [`H:0] rd);

	reg [`H:0] RAM [0:255];
	 
	always @(posedge clk)
		if (we)
			RAM[addr] <= wd;

	assign rd = RAM[addr];

endmodule
