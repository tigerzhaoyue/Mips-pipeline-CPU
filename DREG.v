`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:38 11/22/2015 
// Design Name: 
// Module Name:    DREG 
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
module DREG(clk,en,flush,IR_F,PC4_F,IR_D,PC4_D,jump_flush,Iferet_M);
	input clk,flush,en,jump_flush,Iferet_M;
	input [31:0] IR_F;
	input [31:0] PC4_F;
	output reg [31:0] IR_D;
	output reg [31:0] PC4_D;
	initial
		begin
		IR_D=0;
		PC4_D=0;
		end
	always @(posedge clk)
		begin
		if(flush|jump_flush|Iferet_M)	//pause Int Eret
			begin
			IR_D=0;
			//PC4_D=0;
			end
		else if(en)
			begin
			IR_D=IR_F;
			PC4_D=PC4_F;
			end
		
		end
endmodule
