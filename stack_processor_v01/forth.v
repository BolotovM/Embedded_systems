`include "global.vh"

module datapath_and_controller(
input clk,
input reset,

output [`H:0] pc,
input [`H:0] instr,
	 
output reg dmem_we, 
output reg [`H:0] dmem_addr, 
output reg [`H:0] dmem_wd, 
input [`H:0] dmem_rd);
	 
	reg [`H:0] pc_next;
	reg [`H:0] value;
	 
	// Program counter
	pc pcount(clk, reset, pc_next, pc);
	 	 
	// Data stack
	reg ds_pop, ds_pop2;
	wire [`H:0] ds_first, ds_second;
	 
	reg ds_push;
	reg [`H:0] ds_value;
	 
	stack data_stack(clk, reset, ds_pop, ds_pop2, ds_first, ds_second, ds_push, ds_value);
		  
	// Execution stack
	reg es_pop, es_pop2;
	wire [`H:0] es_first, es_second;

	reg es_push;
	reg [`H:0] es_value;
	 
	stack exec_stack(clk, reset, es_pop, es_pop2, es_first, es_second, es_push, es_value);
	 
	wire is_op;
	wire [2:0] instr_op;
	assign is_op = instr[`H];
	assign instr_op = instr[2:0];

	parameter INSTR_OP_PUSH   = 3'b000;
	parameter INSTR_OP_POP    = 3'b001;
	parameter INSTR_OP_ADD    = 3'b010;
	parameter INSTR_OP_JPUSH  = 3'b011;
	parameter INSTR_OP_IF     = 3'b100;
	parameter INSTR_OP_CALL   = 3'b101;	 
	parameter INSTR_OP_RET    = 3'b111;	 
	 
	always @(*)
	begin
		pc_next = pc + 1;
		ds_push = 0;
		es_push = 0;
		ds_pop = 0;
		ds_pop2 = 0;
		es_pop = 0;
		es_pop2 = 0;
		dmem_we = 0;
		dmem_addr = 0;
		dmem_wd = 0;

		if (is_op == 0)
		begin
			value = instr;
		end
		else
			case(instr_op)
			INSTR_OP_PUSH:
			begin
				ds_value = value;
				ds_push = 1;
			end
			INSTR_OP_POP:
			begin
				ds_pop = 1;
				value = ds_first;
			end
			INSTR_OP_ADD:
			begin
				ds_pop2 = 1;
				ds_value = ds_first + ds_second;
				ds_push = 1;
			end
			INSTR_OP_JPUSH:
			begin
				es_value = value;
				es_push = 1;
			end
			INSTR_OP_IF:
			begin
				ds_pop = 1;
				es_pop2 = 1;
				es_value = pc+1;
				es_push = 1;
		    		pc_next = ds_value == 0 ? es_second : es_first;
			end
			INSTR_OP_CALL:
			begin
				es_pop = 1;
				es_value = pc+1;
				es_push = 1;
				pc_next = es_first;
			end
			INSTR_OP_RET:
			begin
				es_pop = 1;
				pc_next = es_value;
			end
		endcase
	 end

endmodule


module forth(
input clk,
input reset,

output [`H:0] pc,
input [`H:0] instr,

output dmem_we,
output [`H:0] dmem_addr, 
output [`H:0] dmem_wd, 
input [`H:0] dmem_rd);
	 
	 datapath_and_controller dpctrl(clk, reset, pc, instr, dmem_we, dmem_addr, dmem_wd, dmem_rd);

endmodule
