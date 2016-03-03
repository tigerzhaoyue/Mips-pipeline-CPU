`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:24 12/12/2015 
// Design Name: 
// Module Name:    bridge 
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
module bridge(PrRD,HWInt,PrAddr,PrBE,PrWD,PrWE,HardAddr,HardWD,WeHard0,Hard0RD,IntReq0,HardBE,WeHard1,Hard1RD,IntReq1);
//cpu side:
	input [31:2]PrAddr;
	input [31:0]PrWD;
	input [3:0]PrBE;
	input PrWE;	
	output [31:0] PrRD;
	output [7:2] HWInt;
	
//Device side:	
	output [3:2] HardAddr;
	output [3:0] HardBE;
	output [31:0] HardWD;
	input [31:0] Hard0RD,Hard1RD;	//n=2
	output WeHard0,WeHard1;	
	input IntReq0,IntReq1;
	
	wire Hit0,Hit1;
	assign HardBE=PrBE;
	assign HardAddr=PrAddr[3:2];	//2 bits addr in hardware
	assign HardWD=PrWD;
	assign Hit0=PrAddr[31:4]=='b11111110000 ? 1:0;	//0x0000_7F00-0x0000_7F0B
	assign Hit1=PrAddr[31:4]=='b11111110001 ? 1:0;	//0x0000_7F10-0x0000_7F1B
	assign PrRD=Hit0 ? Hard0RD:
					Hit1 ? Hard1RD:
					32'b0;	
	assign WeHard0=Hit0&PrWE;
	assign WeHard1=Hit1&PrWE;
	assign HWInt[2]=IntReq0;
	assign HWInt[3]=IntReq1;
	assign HWInt[7:4]=4'b0;	//reserve for other devices
	


endmodule
