// Мультизнаковый умножитель до 32 бит

module mul2x2
#(parameter W = 2)
(
	input logic[W-1:0] a, b,
	output logic[2*W-1:0] y
);
	logic[3:0] m;
	always_comb
	  case ({a,b})
			'b0101: m <= 1;
			'b0110: m <= 2;
			'b0111: m <= 3;
			'b1001: m <= 2;
			'b1010: m <= 4;
			'b1011: m <= 6;
			'b1101: m <= 3;
			'b1110: m <= 6;
			'b1111: m <= 9;
			default: m <= 0;
	  endcase
	assign y = m;
endmodule

module mul2x4
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
	/*
		genvar i;
		generate
			for (i=0; i<2; i=i+1) begin: forloop

			end	
		endgenerate	
	*/
	mul2x2 m1(a1, b1, a1b1); // умножение столбиком
	mul2x2 m2(a2, b2, a2b2);
	mul2x2 m3(a1, b2, cross1);
	mul2x2 m4(a2, b1, cross2);
	assign y = a1b1 + {cross1+cross2,2'b00} + {a2b2,4'b0000}; // y =  n*2^0 + n*2^1 + n*2^2 ...
endmodule

module mul2x8
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
	mul2x4 m1(a1, b1, a1b1); // умножение столбиком
	mul2x4 m2(a2, b2, a2b2);
	mul2x4 m3(a1, b2, cross1);
	mul2x4 m4(a2, b1, cross2);
	assign y = a1b1 + {cross1+cross2,2'b00} + {a2b2,4'b0000};
endmodule

module mul2x16
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
	mul2x8 m1(a1, b1, a1b1); // умножение столбиком
	mul2x8 m2(a2, b2, a2b2);
	mul2x8 m3(a1, b2, cross1);
	mul2x8 m4(a2, b1, cross2);
	assign y = a1b1 + {cross1+cross2,2'b00} + {a2b2,4'b0000};
endmodule

module mul2x32
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
	mul2x16 m1(a1, b1, a1b1); // умножение столбиком
	mul2x16 m2(a2, b2, a2b2);
	mul2x16 m3(a1, b2, cross1);
	mul2x16 m4(a2, b1, cross2);
	assign y = a1b1 + {cross1+cross2,2'b00} + {a2b2,4'b0000};
endmodule
