`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:22:17 04/20/2018
// Design Name:   karat
// Module Name:   E:/Projects/Karatsuba_32-master/tb_karat_16.v
// Project Name:  karatsuba_new
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: karat
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_karat_16;

	// Inputs
	reg [15:0] A;
	reg [15:0] B;

	// Outputs
	wire [31:0] C;

	// Instantiate the Unit Under Test (UUT)
	karat uut (
		.A(A), 
		.B(B), 
		.C(C)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		#500;
       
		A = 16'd34;
		B = 16'd61;
		#800;
	
		$finish;
	end
      
endmodule

