`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:28:05 11/22/2015 
// Design Name: 
// Module Name:    WREG 
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
module WREG(clk,IR_M,pcadd1_M,IR_W,pcadd1_W,ALU_out_M,ALU_out_W,Memdata_M,Memdata_W,WriteReg_M,WriteReg_W,jump_flush,Iferet_M,
					RegWrite_M,MemToReg_M,IfJal_M,IfBgezal_M,IfJalr_M,
					RegWrite_W,MemToReg_W,IfJal_W,IfBgezal_W,IfJalr_W);
	input clk;
	input RegWrite_M,MemToReg_M,IfJal_M,IfBgezal_M,IfJalr_M,jump_flush,Iferet_M;
	output reg RegWrite_W,MemToReg_W,IfJal_W,IfBgezal_W,IfJalr_W;
	input [31:0] IR_M,ALU_out_M,Memdata_M;
	output reg [31:0] IR_W,ALU_out_W,Memdata_W;
	input [31:0] pcadd1_M;
	output reg [31:0] pcadd1_W;
	input [4:0] WriteReg_M;
	output reg [4:0] WriteReg_W;
	initial
		begin
			IR_W=0;
			pcadd1_W=0;
			ALU_out_W=0;
			WriteReg_W=0;
			MemToReg_W=0;
			RegWrite_W=0;
			IfJal_W=0;
			Memdata_W=0;
			IfBgezal_W=0;
			IfJalr_W=0;
		end
		
	always @(posedge clk)
		begin
		if(jump_flush|Iferet_M)
		begin
			IR_W=0;
			//pcadd1_W=0;
			ALU_out_W=0;
			WriteReg_W=0;
			MemToReg_W=0;
			RegWrite_W=0;
			IfJal_W=0;
			Memdata_W=0;
			IfBgezal_W=0;
			IfJalr_W=0;
		end
		
		else
		begin
			IR_W=IR_M;
			
			ALU_out_W=ALU_out_M;
			WriteReg_W=WriteReg_M;
			MemToReg_W=MemToReg_M;
			RegWrite_W=RegWrite_M;
			IfJal_W=IfJal_M;
			Memdata_W=Memdata_M;
			IfBgezal_W=IfBgezal_M;
			IfJalr_W=IfJalr_M;
		end
		pcadd1_W=pcadd1_M;
		end
endmodule

