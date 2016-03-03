`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:08:16 11/22/2015 
// Design Name: 
// Module Name:    PC 
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
module PC(clk,rst,NPC,PC,en,jump_flush,Iferet_M);
	input clk,rst,en,jump_flush,Iferet_M;
	input[31:0] NPC;
	output reg [31:0] PC;
	initial
		begin
			PC='h00003000;
		end
	always @(posedge clk or posedge rst)
		begin
			if(rst)
				begin
					PC='h00003000;
					end
			else
				begin
					if(en|jump_flush|Iferet_M)
						begin
						PC=NPC;
						$display("PC <- %x",  PC);
						end
				end
		end
endmodule
