module mul2x2_v5
(
	input logic[1:0] a, b,
	output logic[3:0] y
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

module mul2x8_v5
(
	input logic[7:0] a, b,
	output logic[15:0] y
);
	/*
		genvar i;
		generate
			for (i=0; i<2; i=i+1) begin: forloop

			end	
		endgenerate	
	*/
	logic[1:0] a11, a12, a21, a22, 
				  b11, b12, b21, b22;
	logic[3:0] a11b11, a11b12, a11b21, a11b22,
				  a12b11, a12b12, a12b21, a12b22,
				  a21b11, a21b12, a21b21, a21b22,
				  a22b11, a22b12, a22b21, a22b22;
	assign a11 = a[1:0];
	assign a12 = a[3:2];
	assign a21 = a[5:4];
	assign a22 = a[7:6];	
	assign b11 = b[1:0];
	assign b12 = b[3:2];
	assign b21 = b[5:4];
	assign b22 = b[7:6];	
	mul2x2_v5 m1(a11, b11, a11b11); // умножение столбиком
	mul2x2_v5 m2(a11, b12, a11b12);
	mul2x2_v5 m3(a11, b21, a11b21);
	mul2x2_v5 m4(a11, b22, a11b22);
	mul2x2_v5 m5(a12, b11, a12b11);
	mul2x2_v5 m6(a12, b12, a12b12);
	mul2x2_v5 m7(a12, b21, a12b21);
	mul2x2_v5 m8(a12, b22, a12b22); // cross
	mul2x2_v5 m9(a21, b11, a21b11);
	mul2x2_v5 m10(a21, b12, a21b12);
	mul2x2_v5 m11(a21, b21, a21b21);
	mul2x2_v5 m12(a21, b22, a21b22);
	mul2x2_v5 m13(a22, b11, a22b11);
	mul2x2_v5 m14(a22, b12, a22b12);
	mul2x2_v5 m15(a22, b21, a22b21);
	mul2x2_v5 m16(a22, b22, a22b22);		  
	assign y = a11b11 
				+ {a11b12+a12b11,2'b00} // складываем и смещаем на 2 бита влево
				+ {a11b21+a12b12+a21b11,4'b0000} 
				+ {a11b22+a12b21+a21b12+a22b11,6'b000000} 
				+ {a12b22+a21b21+a22b12,8'b00000000} 
				+ {a21b22+a22b21,10'b0000000000} 
				+ {a22b22,12'b000000000000}; // y =  n*2^0 + n*2^1 + n*2^2 ...
endmodule

module mul2x32_v5
#(parameter W = 32) // в этом случае делим 32 бита на 4 значения
(
	input logic[W-1:0] a, b,
	output logic[W-1:0] y
);
	logic[7:0] a11, a12, a21, a22, 
				  b11, b12, b21, b22;
	logic[15:0] a11b11, a11b12, a11b21, a11b22,
				  a12b11, a12b12, a12b21, a12b22,
				  a21b11, a21b12, a21b21, a21b22,
				  a22b11, a22b12, a22b21, a22b22;
	assign a11 = a[7:0];
	assign a12 = a[15:8];
	assign a21 = a[23:16];
	assign a22 = a[31:24];	
	assign b11 = b[7:0];
	assign b12 = b[15:8];
	assign b21 = b[23:16];
	assign b22 = b[31:24];	
	mul2x8_v5 m01(a11, b11, a11b11); // умножение столбиком
	mul2x8_v5 m02(a11, b12, a11b12);
	mul2x8_v5 m03(a11, b21, a11b21);
	mul2x8_v5 m04(a11, b22, a11b22);
	mul2x8_v5 m05(a12, b11, a12b11);
	mul2x8_v5 m06(a12, b12, a12b12);
	mul2x8_v5 m07(a12, b21, a12b21);
	mul2x8_v5 m08(a12, b22, a12b22); // cross
	mul2x8_v5 m09(a21, b11, a21b11);
	mul2x8_v5 m010(a21, b12, a21b12);
	mul2x8_v5 m011(a21, b21, a21b21);
	mul2x8_v5 m012(a21, b22, a21b22);
	mul2x8_v5 m013(a22, b11, a22b11);
	mul2x8_v5 m014(a22, b12, a22b12);
	mul2x8_v5 m015(a22, b21, a22b21);
	mul2x8_v5 m016(a22, b22, a22b22);
	assign y = a11b11 
				+ {a21b22+a22b21,2'b00} // складываем и смещаем на 2 бита влево
				+ {a12b22+a21b21+a22b12,4'b0000} 
				+ {a11b22+a12b21+a21b12+a22b11,6'b000000} 
				+ {a11b21+a12b12+a21b11,8'b00000000} 
				+ {a11b12+a12b11,10'b0000000000} 
				+ {a22b22,12'b000000000000}; // y =  n*2^0 + n*2^1 + n*2^2 ...
endmodule
