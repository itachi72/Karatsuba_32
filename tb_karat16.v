`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:16:33 04/21/2018
// Design Name:   karat_16
// Module Name:   E:/Projects/exp_with_task_2/new/tb_karat16.v
// Project Name:  new
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: karat_16
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_karat16;

	// Inputs
	reg [15:0] D;
	reg [15:0] E;

	// Outputs
	wire [31:0] F;

	// Instantiate the Unit Under Test (UUT)
	karat_16 uut (
		.D(D), 
		.E(E), 
		.F(F)
	);

	initial begin
		// Initialize Inputs
		D = 0;
		E = 0;
		#100;
		
		D = 16'd67;
		E = 16'd35;
		#800;
		
		$finish;
	end
      
endmodule

