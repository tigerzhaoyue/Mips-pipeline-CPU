`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:57 11/22/2015 
// Design Name: 
// Module Name:    MREG 
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
module MREG(clk,IR_E,pcadd1_E,IR_M,pcadd1_M,ALU_out_E,ALU_out_M,Multdata_E,Multdata_M,RData2_E,RData2_M,WriteReg_E,WriteReg_M,jump_flush,Iferet_M,
    MemToReg_E,RegWrite_E,MemWrite_E,IfBeq_E,IfJal_E,IfJr_E,IfJ_E,Equal_E,IfBgezal_E,IfJalr_E,C0Write_E,
	 MemToReg_M,RegWrite_M,MemWrite_M,IfBeq_M,IfJal_M,IfJr_M,IfJ_M,Equal_M,IfBgezal_M,IfJalr_M,C0Write_M);
	input clk,jump_flush,Iferet_M;
	input MemToReg_E,RegWrite_E,MemWrite_E,IfBeq_E,IfJal_E,IfJr_E,IfJ_E,Equal_E,IfBgezal_E,IfJalr_E,C0Write_E;
	output reg MemToReg_M,RegWrite_M,MemWrite_M,IfBeq_M,IfJal_M,IfJr_M,IfJ_M,Equal_M,IfBgezal_M,IfJalr_M,C0Write_M; 
	input [31:0] IR_E,ALU_out_E,RData2_E,Multdata_E;
	input [31:0] pcadd1_E;
	input [4:0] WriteReg_E;
	output reg [4:0] WriteReg_M;
	output reg [31:0] IR_M,ALU_out_M,RData2_M,Multdata_M;
	output reg [31:0] pcadd1_M;
	initial
		begin
			IR_M=0;
			pcadd1_M=0;
			ALU_out_M=0;
			RData2_M=0;
			WriteReg_M=0;
			MemToReg_M=0;
			RegWrite_M=0;
			MemWrite_M=0;
			IfBeq_M=0;
			IfJal_M=0;
			IfJr_M=0;
			IfJ_M=0;
			Equal_M=0;
			IfBgezal_M=0;
			IfJalr_M=0;
			Multdata_M=0;
			C0Write_M=0;
		end
	always @(posedge clk)
		begin
		if(jump_flush|Iferet_M)
		begin
			IR_M=0;
			//pcadd1_M=0;
			ALU_out_M=0;
			RData2_M=0;
			WriteReg_M=0;
			MemToReg_M=0;
			RegWrite_M=0;
			MemWrite_M=0;
			IfBeq_M=0;
			IfJal_M=0;
			IfJr_M=0;
			IfJ_M=0;
			Equal_M=0;
			IfBgezal_M=0;
			IfJalr_M=0;
			Multdata_M=0;
			C0Write_M=0;
		end
		else
		begin
			IR_M=IR_E;
			
			ALU_out_M=ALU_out_E;
			RData2_M=RData2_E;
			WriteReg_M=WriteReg_E;
			MemToReg_M=MemToReg_E;
			RegWrite_M=RegWrite_E;
			MemWrite_M=MemWrite_E;
			IfBeq_M=IfBeq_E;
			IfJal_M=IfJal_E;
			IfJr_M=IfJr_E;
			IfJ_M=IfJ_E;
			Equal_M=Equal_E;
			IfBgezal_M=IfBgezal_E;
			IfJalr_M=IfJalr_E;
		   Multdata_M=Multdata_E;
			C0Write_M=C0Write_E;
		end
		pcadd1_M=pcadd1_E;
		end
endmodule

