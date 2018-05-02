`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:18 04/20/2018 
// Design Name: 
// Module Name:    test_1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module karat_16(input [15:0]D,
			input [15:0] E,
			output [31:0] F);
	
	//variables for 16-bits karatsuba
	 wire [7:0]lev_1[3:0];					//4 variables, each 8-bits for storing the partial bits.
	 wire [15:0]lev_2[1:0];					//2-variables, each 16-bits for storing the 8-bit product.
	 wire [8:0]temporary_1[1:0];				//2 variable, 9-bit for storing the sum.
	 wire [17:0]temporary_2;						//1 variable for storing the product term, 18-bits
	 wire [17:0]temporary_3;						//1 variable for storing the mid-term, 18-bits
	 wire [31:0]shifted16_16;					//32-bits
	 wire [25:0]shifted16_8;					//26-bits 
	//end
	
	
	//Variables for 8-bit karatsuba
	 reg [3:0]l_1[3:0];					//4 variables, each 4-bits for storing the partial bits.
	 reg [7:0]l_2[1:0];					//2-varibales, each 8-bits for storing the 8-bit product.
	 reg [4:0]temp_1[1:0];				//2 variable, 9-bit for storing the 5-bit sum.
	 reg [9:0]temp_2;					//1 variable for storing the product term, 10-bits
	 reg [9:0]temp_3;					//1 variable for storing the mid-term, 10-bits
	 reg [15:0]shift8_8;				//16-bits
	 reg [13:0]shift8_4;				//14-bits 
	 //end
	 
	 	
	//Variables for 9-bit karatsuba
	 reg [3:0]l9_1[3:0];					//4 variables, each 4-bits for storing the partial bits.
	 reg [7:0]l9_2[1:0];					//2-varibales, each 8-bits for storing the 8-bit product.
	 reg [4:0]temp9_1[1:0];				//2 variable, 9-bit for storing the 5-bit sum.
	 reg [9:0]temp9_2;					//1 variable for storing the product term, 10-bits
	 reg [9:0]temp9_3;					//1 variable for storing the mid-term, 10-bits
	 reg [15:0]shift9_8;				//16-bits
	 reg [13:0]shift9_4;				//14-bits 
	 //end
	 
	 //Variables for 4-bits karatsuba
	 reg [3:0] ac, bd;					//a*c and b*d, 4-bits
	 reg [2:0] add_aPb, add_cPd;		//(a+b) and (c+d), 3-bits
	 reg [4:0] add_ac_bd;				//ac+bd, 5-bits
	 reg [5:0] mul_p;					//(a+b)*(c+d), 6-bits
	 reg [7:0] shift_4;					//shift ab left by 4, 8-bits
	 reg [7:0] shift_2;					//shift ((a+b)*(c+d) - (ac + bd)), 6-bits and shifted 2 bits, so 8-bits
	 //end
	 
	 //Variables for 5-bits karatsuba
	 reg [5:0] ac5;					//6-bits, as ac5 is 3-bits*3-bits multiplication
	 reg [3:0] bd5;					//4-bits
	 reg [3:0] add_aPb5, add_cPd5;		//(a+b) and (c+d), 4-bits.
	 reg [7:0] mul_p5;					   //(a+b)*(c+d), 8-bits
	 reg [8:0] shift_4_5;					//shift ac left by 4, 9-bits
	 reg [9:0] shift_2_5;					//shift ((a+b)*(c+d) - (ac + bd)), 10-bits
	 //end
	 
	 //*************Main body of the multiplier*************//
	 assign lev_1[0] = D[15:8];
	 assign lev_1[1] = D[7:0];
	 assign lev_1[2] = E[15:8];
	 assign lev_1[3] = E[7:0];
	 assign lev_2[0] = karat8(lev_1[0], lev_1[2]);		   //multiplying lev_1[0] and lev_1[1] and storing in lev_2[0]
	 assign lev_2[1] = karat8(lev_1[1], lev_1[3]);		   //multiplying lev_1[1] and lev_1[3] and storing in lev_2[1]
    assign temporary_1[0] = lev_1[0] + lev_1[1];		//9-bits
	 assign temporary_1[1] = lev_1[2] + lev_1[3];		//9-bits
	 assign temporary_2 = karat9(temporary_1[0], temporary_1[1]);				//10-bits
	 assign temporary_3 = temporary_2 - (lev_2[0] + lev_2[1]); 
	 assign shifted16_16 = lev_2[0]<<16;
	 assign shifted16_8 = temporary_3<<8;
	 assign F = shifted16_16 + shifted16_8 + lev_2[1];			//OUTPUT	

	 //*********************************************************//
	 function [15:0]karat8(input [7:0]P,
								input [7:0] Q);
	  begin
	  l_1[0] = P[7:4];
	  l_1[1] = P[3:0];
	  l_1[2] = Q[7:4];
	  l_1[3] = Q[3:0];
	  l_2[0] = karat4(l_1[0], l_1[2]);		//multiplying l_1[0] and l_1[1] and storing in l_2[0]
	  l_2[1] = karat4(l_1[1], l_1[3]);		//multiplying l_1[1] and l_1[3] and storing in l_2[1]
	  temp_1[0] = l_1[0] + l_1[1];		//5-bits
	  temp_1[1] = l_1[2] + l_1[3];		//5-bits
	  temp_2 = karat5(temp_1[0], temp_1[1]);				//10-bits
	  temp_3 = temp_2 - (l_2[0] + l_2[1]); 
	  shift8_8 = l_2[0]<<8;
	  shift8_4 = temp_3<<4;
	  karat8 = shift8_8 + shift8_4 + l_2[1];			//OUTPUT
	  end
	endfunction
	 
	function [17:0]karat9(input [8:0]P,
								input [8:0] Q);
	  begin
	  l9_1[0] = P[8:4];
	  l9_1[1] = P[3:0];
	  l9_1[2] = Q[8:4];
	  l9_1[3] = Q[3:0];
	  l9_2[0] = karat5(l9_1[0], l9_1[2]);		//multiplying l_1[0] and l_1[1] and storing in l_2[0]
	  l9_2[1] = karat5(l9_1[1], l9_1[3]);		//multiplying l_1[1] and l_1[3] and storing in l_2[1]
	  temp9_1[0] = l9_1[0] + l9_1[1];		//5-bits
	  temp9_1[1] = l9_1[2] + l9_1[3];		//5-bits
	  temp9_2 = karat5(temp9_1[0], temp9_1[1]);				//-bits
	  temp9_3 = temp9_2 - (l9_2[0] + l9_2[1]); 
	  shift9_8 = l9_2[0]<<8;
	  shift9_4 = temp9_3<<4;
	  karat9 = shift9_8 + shift9_4 + l9_2[1];			//OUTPUT
	  end
	endfunction
	
	function [7:0] karat4;
	input [3:0]X, Y;
		//output [7:0]Z;
		begin
		 ac = mult2(X[3:2], Y[3:2]);
		 bd = mult2(X[1:0], Y[1:0]);
		 add_aPb = X[1:0] + X[3:2];
		 add_cPd = Y[1:0] + Y[3:2];
		 mul_p = mult3(add_aPb, add_cPd);
		 shift_4 = ac<<4;
		 shift_2 = (mul_p - ac - bd)<<2;
		 karat4 = shift_4 + shift_2 + bd;
		end
	 endfunction
	
	function [9:0] karat5;
		input [4:0]A, B;
		//output [9:0]product;
		begin
		 ac5 = mult3(A[4:2], B[4:2]);			//6-bits
		 bd5 = mult2(A[1:0], B[1:0]);				//4-bits
		 add_aPb5 = A[1:0] + A[4:2];				//4-bits
		 add_cPd5 = B[1:0] + B[4:2];				//4-bits
		 mul_p5 = mult4_5(add_aPb5, add_cPd5);		//8-bits
		 shift_4_5 = ac5<<4;								//9-bits
		 shift_2_5 = (mul_p5 - (ac5 + bd5))<<2;			//8-bits
		 karat5 = shift_4_5 + shift_2_5 + bd5;
		end
	endfunction
	 
	function [3:0] mult2(input [1:0]M, input [1:0]N);		//booth multiplier
	mult2 = M*N[0] + (M<<1)*N[1];
	endfunction
	 
	function [5:0] mult3(input [2:0]M, input [2:0]N);		//booth multiplier
	mult3 = M*N[0] + (M<<1)*N[1] + (M<<2)*N[2];
	endfunction
	 
	function [5:0] mult4_5(input [3:0]M_5, input [3:0]N_5);		//booth multiplier
	mult4_5 = M_5*N_5[0] + (M_5<<1)*N_5[1] + (M_5<<2)*N_5[2] + (M_5<<3)*N_5[3];
	endfunction

endmodule

