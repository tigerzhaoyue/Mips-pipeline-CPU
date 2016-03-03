`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:47 11/22/2015 
// Design Name: 
// Module Name:    EREG 
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
module EREG(clk,flush_E,IR_D,PC4_D,ext_out_D,RD1_D,RD2_D,IR_E,PC4_E,ext_out_E,RD1_E,RD2_E,jump_flush,Iferet_M,
RegDst_D,AluSrc_D,MemToReg_D,RegWrite_D,MemWrite_D,IfBeq_D,IfJal_D,IfJr_D,Alu_Op_D,IfJ_D,Equal_D,IfBgezal_D,IfJalr_D,C0Write_D,
RegDst_E,AluSrc_E,MemToReg_E,RegWrite_E,MemWrite_E,IfBeq_E,IfJal_E,IfJr_E,Alu_Op_E,IfJ_E,Equal_E,IfBgezal_E,IfJalr_E,C0Write_E);
	input clk,flush_E,jump_flush,Iferet_M;
	input RegDst_D,AluSrc_D,MemToReg_D,RegWrite_D,MemWrite_D,IfBeq_D,IfJal_D,IfJr_D,IfJ_D,Equal_D,IfBgezal_D,IfJalr_D,C0Write_D;
	input [3:0] Alu_Op_D;
	output reg [3:0] Alu_Op_E;
	output reg RegDst_E,AluSrc_E,MemToReg_E,RegWrite_E,MemWrite_E,IfBeq_E,IfJal_E,IfJr_E,IfJ_E,Equal_E,IfBgezal_E,IfJalr_E,C0Write_E;
	input [31:0] IR_D,ext_out_D,RD1_D,RD2_D;
	input [31:0] PC4_D;
	output reg [31:0] IR_E,ext_out_E,RD1_E,RD2_E;
	output reg [31:0] PC4_E;
	initial
		begin
			IR_E=0;
			PC4_E=0;
			ext_out_E=0;
			RD1_E=0;
			RD2_E=0;
			RegDst_E=0;
			AluSrc_E=0;
			MemToReg_E=0;
			RegWrite_E=0;
			MemWrite_E=0;
			IfBeq_E=0;
			IfJal_E=0;
			IfJr_E=0;
			Alu_Op_E=0;
			IfJ_E=0;
			Equal_E=0;
			IfBgezal_E=0;
			IfJalr_E=0;
			C0Write_E=0;
		end
		
	always @(posedge clk)
		begin
		if(flush_E|jump_flush|Iferet_M)
			begin
			IR_E=0;
			//PC4_E=0;
			ext_out_E=0;
			RD1_E=0;
			RD2_E=0;
			RegDst_E=0;
			AluSrc_E=0;
			MemToReg_E=0;
			RegWrite_E=0;
			MemWrite_E=0;
			IfBeq_E=0;
			IfJal_E=0;
			IfJr_E=0;
			Alu_Op_E=0;
			IfJ_E=0;
			Equal_E=0;
			IfBgezal_E=0;
			IfJalr_E=0;
			C0Write_E=0;
			end
			
		else
			begin
			IR_E=IR_D;
			
			ext_out_E=ext_out_D;
			RD1_E=RD1_D;
			RD2_E=RD2_D;
			RegDst_E=RegDst_D;
			AluSrc_E=AluSrc_D;
			MemToReg_E=MemToReg_D;
			RegWrite_E=RegWrite_D;
			MemWrite_E=MemWrite_D;
			IfBeq_E=IfBeq_D;
			IfJal_E=IfJal_D;
			IfJr_E=IfJr_D;
			Alu_Op_E=Alu_Op_D;
			IfJ_E=IfJ_D;
			Equal_E=Equal_D;
			IfBgezal_E=IfBgezal_D;
			IfJalr_E=IfJalr_D;
			C0Write_E=C0Write_D;
			end
		PC4_E=PC4_D;
		end
endmodule

