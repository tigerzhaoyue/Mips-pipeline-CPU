`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:01:14 12/13/2015
// Design Name:   mips
// Module Name:   C:/Users/Tiger/Desktop/mipsp7/testmips.v
// Project Name:  mips_pro
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testmips;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] PrRD;
	reg [7:2] HWInt;

	// Outputs
	wire [31:2] PrAddr;
	wire [3:0] PrBE;
	wire [31:0] PrWD;
	wire PrWe;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset), 
		.PrRD(PrRD), 
		.HWInt(HWInt), 
		.PrAddr(PrAddr), 
		.PrBE(PrBE), 
		.PrWD(PrWD), 
		.PrWe(PrWe)
	);
	always #5 clk=~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		PrRD = 0;
		HWInt = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

