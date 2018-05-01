`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:25:20 12/04/2017 
// Design Name: 
// Module Name:    karat 
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
module karat(input [15:0]A,B, output [31:0]C
    );
wire [7:0]var_1[3:0];   //4 variables, each 8-bits for storing the part wise binary data.
wire [4:0]var_2[11:0];  //12 variables, each 5-bits for storing the part wise binary data.
wire [8:0]temp_1[1:0];  //2 variables, each 9-bits for storing the sum and doing the subtractions.
wire [4:0]temp_2[5:0];  //6 variables, each 5-bits for storing the sum and doing the subtractions.
wire [17:0]p_l[2:0];		//3 variables, each 18-bits for storing the shifted terms.
wire [31:0]p_f[1:0];
wire [31:0]final;
wire [9:0]mul1[11:0];

assign var_1[0] = A[7:0];    //a
assign var_1[1] = A[15:8];   //b
assign var_1[2] = B[7:0];    //c
assign var_1[3] = B[15:8];   //d
assign temp_1[0] = var_1[0][7:0] + var_1[1][7:0];    // the middle addition part, (a+b)
assign temp_1[1] = var_1[2][7:0] + var_1[3][7:0];    //same  (c+d)

genvar i;
generate for(i=1; i<9; i = i+2)   //the variables var_2[0] & var_2[], total 4 iterations
begin: bit1
assign var_2[i-1] = var_1[i>>1][3:0];    //a' 
assign var_2[i] = var_1[i>>1][7:4];       //b'
end
endgenerate

assign var_2[8] =  temp_1[0][3:0];
assign var_2[9] =  temp_1[0][8:4];
assign var_2[10] = temp_1[1][3:0];
assign var_2[11] = temp_1[1][8:4];

genvar j;
generate for(j=1;j<12;j=j+2)				//6 iterations
begin: bit4
assign temp_2[j>>1] = var_2[j-1][3:0] + var_2[j][3:0];
end
endgenerate

genvar k; 
generate for(k=0; k<11; k=k+4)
begin: bit2
assign mul1[k][7:0] = mult(var_2[k][3:0], var_2[k+2][3:0]);    //var[0] and var[2] are multiplied and so on, 8-bits
assign mul1[k+1][7:0] = mult(var_2[k+1][3:0], var_2[k+3][3:0]);   //var[1] and var[3] are multiplied and so on, 8-bits
end                            
endgenerate
//now mul1[][2,3,6,7,10,11] are not used, they are being used in the next multiplication.
assign mul1[2][9:0] = mult(temp_2[0], temp_2[1]);				//10-bits
assign mul1[3][9:0] = mult(temp_2[2], temp_2[3]);
assign mul1[6][9:0] = mult(temp_2[4], temp_2[5]);
/*now, mul1[][0 to 11] have the normal 4 bit multiplication values.
and mul1[][2,3,6] have the added multiplication values, hence they have 2-bits extra. */
assign mul1[7][9:0] = mul1[2]- (mul1[0] + mul1[1]);    //this is for (a+b)(c+d) - ac -bd 
assign mul1[10][9:0] = mul1[3]-(mul1[4] + mul1[5]);	 //10-bits
assign mul1[11][9:0] = mul1[6]-(mul1[8] + mul1[9]);

//now we will do the final karatsuba ritual.

assign p_l[0] = shifter_8(mul1[0]) + shifter_4(mul1[7]) + mul1[1];  
assign p_l[1] = shifter_8(mul1[4]) + shifter_4(mul1[10]) + mul1[5];
assign p_l[2] = shifter_8(mul1[8]) + shifter_4(mul1[11]) + mul1[9];

assign p_f[0][31:0] = shifter_16(p_l[1]);
assign p_f[1][31:0] = shifter_8(p_l[1] - p_l[0] - p_l[2]);

assign final[31:0] = p_f[0][31:0] + p_f[1][31:0] + p_l[2][13:0];

function [8:0] mult(input [4:0]M, input [3:0]N);
mult  = M*N[0] + (M<<1)*N[1] + (M<<2)*N[2] +(M<<3)*N[3];
endfunction

function [8:0] shifter_4(input [9:0]Q);     
shifter_4 = (Q<<4);  
endfunction

function [15:0] shifter_8(input [9:0]Q);    
shifter_8 = (Q<<8);  
endfunction

function [31:0] shifter_16(input [9:0]Q);  
shifter_16 = (Q<<16);  
endfunction

endmodule
