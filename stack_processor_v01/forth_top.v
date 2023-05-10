`include "global.vh"

module forth_top(
input clk,
input reset
);
	 wire [`H:0] pc;

	 // Instruction memory
	 wire [`H:0] instr;
	 instrmem instrmem(pc, instr);
	 
	 // Data memory
	 wire dmem_we;
	 wire [`H:0] dmem_addr;
	 wire [`H:0] dmem_wd;
	 wire [`H:0] dmem_rd;
	 datamem dmem(clk, dmem_we, dmem_addr, dmem_wd, dmem_rd);
	 
	 // Processor core
	 forth forth(clk, reset, pc, instr, dmem_we, dmem_addr, dmem_wd, dmem_rd);
endmodule
