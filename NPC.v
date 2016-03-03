`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:08:23 11/22/2015 
// Design Name: 
// Module Name:    NPC 
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
module NPC(pc4,imm,npc,ifbeq,ifjal,ifjr,ifj,instr_index,RData1,ifbne,ifbgtz,ifbgezal,ifjalr,IfBlez_D,IfBltz_D,IfBgez_D,IR_D);
	input[31:0] pc4;
	input[15:0] imm;
	input[31:0] IR_D;
	input ifbeq,ifjal,ifjr,ifj,ifbne,ifbgtz,ifbgezal,ifjalr,IfBlez_D,IfBltz_D,IfBgez_D;
	input[25:0] instr_index;
	input[31:0] RData1;
	output[31:0] npc;
	reg[31:0] pc;
	reg[31:0] npc;
	reg[31:0] imm_;
	integer i;
	initial
		begin
			npc ='h00003000;
			imm_='h00000000;
		end
	always @ (*)
		begin
			imm_[1:0]=2'b0;
			imm_[17:2]=imm[15:0];
			for(i=18;i<=31;i=i+1)
				begin
					imm_[i]=imm[15];	//sign_extend imm to  [31:2]
				end
			if(ifbeq|ifbne|ifbgtz|ifbgezal|IfBlez_D|IfBltz_D|IfBgez_D)		//branch
				begin
					npc=pc4+imm_;	//pc+4+offset
				end
			else if(ifjal|ifj)		//j
				begin
					pc=pc4-32'b100;
					npc={pc[31:28],instr_index,2'b0};	//30bit npc	
				end
			else if(ifjr|(ifjalr&(IR_D[25:21]!=IR_D[15:11])))
				begin
					npc=RData1;		
				end
			else		//not jump or branch instr
				begin
					npc=pc4;
				end		
		end
endmodule
