`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:46 12/13/2015 
// Design Name: 
// Module Name:    microsystem 
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
module microsystem(clk,reset);
	input clk,reset;
	wire [31:0]PrRD,PrWD,HardWD,Hard0RD,Hard1RD;
	wire [7:2] HWInt;
	wire [31:2] PrAddr;
	wire [3:0] PrBE;
	wire PrWe;
	wire [3:2]HardAddr;
	wire WeHard0,Wehard1;
	wire IntReq0,IntReq1;
	wire [3:0] HardBE;
	
	mips MIPS(clk,reset,PrRD,HWInt,PrAddr,PrBE,PrWD,PrWe);
//cpu side:  			   ^    ^     |       |   |    |
//								|    |     v       v   v    v
	bridge BRIDGE(      PrRD,HWInt,PrAddr,PrBE,PrWD,PrWe,HardAddr,HardWD,WeHard0,Hard0RD,IntReq0,HardBE,WeHard1,Hard1RD,IntReq1);
//Hardwire side:															|			|		|		^			^             |        ^       ^
//device0:																	v        v     v     |        |             |        |       |   
	timer timer0(clk,reset,                              HardAddr,HardWD,WeHard0,Hard0RD,IntReq0);//     |        |       |
//device1:                                                  v        v                                  v        |       |         
	timer timer1(clk,reset,                              HardAddr,HardWD,                               WeHard1,Hard1RD,IntReq1);
//devicen:

endmodule
