`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:54 11/22/2015 
// Design Name: 
// Module Name:    PCADD 
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
module PCADD(PC,NPC);
	input [31:0] PC;
	output [31:0] NPC;
	assign NPC=PC+32'b0000_0000_0000_0000_0000_0000_0000_0100;
endmodule
