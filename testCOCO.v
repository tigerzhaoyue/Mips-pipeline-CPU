`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:31:14 12/14/2015
// Design Name:   timer
// Module Name:   C:/Users/Tiger/Desktop/mipsp7/testCOCO.v
// Project Name:  mips_pro
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: timer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testCOCO;

	// Inputs
	reg clk;
	reg reset;
	reg [3:2] addr;
	reg [31:0] Din;
	reg we;

	// Outputs
	wire [31:0] Dout;
	wire IntReq;

	// Instantiate the Unit Under Test (UUT)
	timer uut (
		.clk(clk), 
		.reset(reset), 
		.addr(addr), 
		.Din(Din), 
		.we(we), 
		.Dout(Dout), 
		.IntReq(IntReq)
	);
	always #5 clk=~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		addr = 0;
		Din = 0;
		we = 0;
	#5;
	we=1;
	addr=2'b00;
	Din=32'b1000;
	#20;
	we=1;
	addr=2'b01;
	Din=15;
	#10;
	we=0;
	#500;
	we=1;
	addr=2'b00;
	Din=32'b1011;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

