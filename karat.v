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
wire [7:0]var_1[3:0];   //4 variables for storing the part wise binary data 
wire [3:0]var_2[11:0];  //4 variables for storing the part wise binary data 
wire [8:0]temp_1[1:0];  //2 temporary variables for storing the sum and doing the subtraction
wire [4:0]temp_2[5:0];  //12 temporary variables for storing the sum and doing the subtraction
wire [13:0]p_l[2:0];
wire [31:0]p_f[1:0];
wire [31:0]final;
wire [8:0]mul1[11:0];
wire clk;

initial clk=0;
always
#10 clk=~clk;
initial
#1000 $finish;

always@(posedge clk)
begin
var_1[0][7:0] = A[7:0];    //a
var_1[1][7:0] = A[15:8];   //b
avar_1[2][7:0] = B[7:0];    //c
var_1[3][7:0] = B[15:8];   //d
temp_1[0][8:0] = var_1[0][7:0] + var_1[1][7:0];    // the middle addition part, (a+b)
temp_1[1][8:0] = var_1[2][7:0] + var_1[3][7:0];    //same  (c+d)
end

genvar i;
generate for(i=1; i<9; i = i+2)   //the variables var_2[0] & var_2[]
begin: bit1
assign var_2[i-1][3:0] = var_1[i>>1][3:0];    //a' 
assign var_2[i][3:0] = var_1[i>>>1][7:4];       //b'
end
endgenerate

assign var_2[8][3:0] =  temp_1[0][3:0];
assign var_2[9][3:0] =  temp_1[0][8:4];
assign var_2[10][3:0] = temp_1[1][3:0];
assign var_2[11][3:0] = temp_1[1][8:4];

genvar j;
generate for(j=1;j<12;j=j+2)
begin: bit4
assign temp_2[j>>>1][4:0] = var_2[j-1][3:0] + var_2[j][3:0];
end
endgenerate

genvar k;
generate for(k=0; k<11; k=k+4)
begin: bit2
assign mul1[k][7:0] = mult(var_2[k][3:0], var_2[k+2][3:0]);    //0 and 2 are multiplied and so on
assign mul1[k+1][7:0]   = mult(var_2[k+1][3:0], var_2[k+3][3:0]);      //1 and 3 are multiplied and so on
end                            //now mul1[][2,3,6,7,10,11] are not used, they are being used in the next multiplication.
endgenerate

assign mul1[2][8:0] = mult(temp_2[0][4:0], temp_2[1][4:0]);
assign mul1[3][8:0] = mult(temp_2[2][4:0], temp_2[3][4:0]);
assign mul1[6][8:0] = mult(temp_2[4][4:0], temp_2[5][4:0]);
/*now, mul1[][0 to 11] have the normal 4 bit multiplication values.
and mul1[][2,3,6] have the added multiplication values. */
assign mul1[7][8:0] = mul1[2][8:0]- (mul1[0][8:0]+mul1[1][8:0]);    //this is for (a+b)(c+d) - ac -bd 
assign mul1[10][8:0] = mul1[3][8:0]-(mul1[4][8:0]+mul1[5][8:0]);
assign mul1[11][8:0] = mul1[6][8:0]-(mul1[8][8:0]+mul1[9][8:0]);

//now we will do the final karatsuba ritual

assign p_l[0][13:0] = shifter(mul1[0][4:0], 5'd8) + shifter(mul1[7][4:0], 5'd4) + mul1[1][4:0];
assign p_l[1][13:0] = shifter(mul1[4][4:0], 5'd8) + shifter(mul1[10][4:0], 5'd4) + mul1[5][4:0];
assign p_l[2][13:0] = shifter(mul1[8][4:0], 5'd8) + shifter(mul1[11][4:0], 5'd4) + mul1[9][4:0];

assign p_f[0][31:0] = shifter(p_l[1][13:0], 5'd16);
assign p_f[1][31:0] = shifter((p_l[1][13:0] - p_l[0][13:0] - p_l[2][13:0]), 5'd8);

assign final[31:0] = p_f[0][31:0] + p_f[1][31:0] + p_l[2][13:0];



function [8:0] mult(input [4:0]M, input [3:0]N);
case(N)
4'b0000: mult  = 0;
4'b0001: mult  = M;
4'b0010: mult = (M<<1);
4'b0011: mult  = M + (M<<1);
4'b0100: mult  = M<<2;
4'b0101: mult  = M + (M<<2);
4'b0110: mult  = (M<<1) + (M<<2);
4'b0111: mult  = M + (M<<1) +(M<<2);
4'b1000: mult  = M<<3;
4'b1001: mult  = M + (M<<3);
4'b1010: mult  = (M<<1) + (M<<3);
4'b1011: mult  = M + (M<<1) +(M<<3);
4'b1100: mult  = (M<<2) + (M<<3);
4'b1101: mult  = M + (M<<2) +(M<<3);
4'b1110: mult  = (M<<1) + (M<<2) +(M<<3);
4'b1111: mult  = M + (M<<1) + (M<<2) +(M<<3);
endcase
endfunction


function [63:0] shifter(input [7:0]Q, input [4:0]s);     //this function takes an input number and shifts it by the other input integer
shifter = (Q<<s);  
endfunction





endmodule
