`include "global.vh"

// пямять инструкций
module instrmem (
input [`H:0] addr, 
output [`H:0] instr);

	reg [`H:0] ROM [0:255];
	assign instr = ROM[addr];

endmodule
