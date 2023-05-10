module mul12x1_v4
(
	input logic a, b,
	output logic[1:0] y
);
	logic[1:0] m;
	always_comb
	  case ({a,b})
			'b11: m <= 1;
			default: m <= 0;
	  endcase
	assign y = m;
endmodule

module mul2x2_v4
(
	input logic[1:0] a, b,
	output logic[3:0] y
);
	logic a1,a2,b1,b2;
	logic[1:0] a1b1, a2b2, cross1, cross2;
	assign a1 = a[0];
	assign a2 = a[1];
	assign b1 = b[0];
	assign b2 = b[1];	
	mul12x1_v4 m1(a2, b2, a2b2); 
	mul12x1_v4 m2(a1, b2, cross1);
	mul12x1_v4 m3(a2, b1, cross2);
	mul12x1_v4 m4(a1, b1, a1b1);
	assign y = a1b1 + {cross1+cross2,1'b0} + {a2b2,2'b00};
endmodule

module mul2x4_v4
#(parameter W = 4)
(
	input logic[W-1:0] a, b,
	output logic[2*W-1:0] y
);
	logic[W/2-1:0] a1,a2,b1,b2;
	logic[W-1:0] a1b1, a2b2, cross1, cross2;
	assign a1 = a[W/2-1:0];
	assign a2 = a[W-1:W/2];
	assign b1 = b[W/2-1:0];
	assign b2 = b[W-1:W/2];	
	mul2x2_v4 m1(a1, b1, a1b1); // умножение столбиком
	mul2x2_v4 m2(a2, b2, a2b2);
	mul2x2_v4 m3(a1, b2, cross1);
	mul2x2_v4 m4(a2, b1, cross2);
	assign y = a1b1 + {cross1+cross2,1'b0} + {a2b2,2'b00}; // y =  n*2^0 + n*2^1 + n*2^2 ...
endmodule

module mul2x8_v4
#(parameter W = 8)
(
	input logic[W-1:0] a, b,
	output logic[2*W-1:0] y
);
	logic[W/2-1:0] a1,a2,b1,b2;
	logic[W-1:0] a1b1, a2b2, cross1, cross2;
	assign a1 = a[W/2-1:0];
	assign a2 = a[W-1:W/2];
	assign b1 = b[W/2-1:0];
	assign b2 = b[W-1:W/2];	
	mul2x4_v4 m1(a1, b1, a1b1); // умножение столбиком
	mul2x4_v4 m2(a2, b2, a2b2);
	mul2x4_v4 m3(a1, b2, cross1);
	mul2x4_v4 m4(a2, b1, cross2);
	assign y = a1b1 + {cross1+cross2,1'b0} + {a2b2,2'b00};
endmodule

module mul2x16_v4
#(parameter W = 16)
(
	input logic[W-1:0] a, b,
	output logic[2*W-1:0] y
);
	logic[W/2-1:0] a1,a2,b1,b2;
	logic[W-1:0] a1b1, a2b2, cross1, cross2;
	assign a1 = a[W/2-1:0];
	assign a2 = a[W-1:W/2];
	assign b1 = b[W/2-1:0];
	assign b2 = b[W-1:W/2];		
	mul2x8_v4 m1(a1, b1, a1b1); // умножение столбиком
	mul2x8_v4 m2(a2, b2, a2b2);
	mul2x8_v4 m3(a1, b2, cross1);
	mul2x8_v4 m4(a2, b1, cross2);
	assign y = a1b1 + {cross1+cross2,1'b0} + {a2b2,2'b00};
endmodule

module mul2x32_v4
#(parameter W = 32)
(
	input logic[W-1:0] a, b,
	output logic[W-1:0] y
);
	logic[W/2-1:0] a1,a2,b1,b2;
	logic[W-1:0] a1b1, a2b2, cross1, cross2;
	assign a1 = a[W/2-1:0];
	assign a2 = a[W-1:W/2];
	assign b1 = b[W/2-1:0];
	assign b2 = b[W-1:W/2];		
	mul2x16_v4 m1(a1, b1, a1b1); // умножение столбиком
	mul2x16_v4 m2(a2, b2, a2b2);
	mul2x16_v4 m3(a1, b2, cross1);
	mul2x16_v4 m4(a2, b1, cross2);
	assign y = a1b1 + {cross1+cross2,1'b0} + {a2b2,2'b00};
endmodule
