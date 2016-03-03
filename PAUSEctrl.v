`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:55:01 11/23/2015 
// Design Name: 
// Module Name:    PAUSEctrl 
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
module PAUSEctrl(IR_D,IR_E,IR_M,pcen,IR_Eclr,enD,Busy);
	input [31:0] IR_D,IR_E,IR_M;
	input Busy;
	output pcen,IR_Eclr,enD;
	wire IfB,IfJr,If_mult_cal;
	reg pause;
	wire lw_E,lw_M;
	assign IfB=(IR_D[31:26]==6'b000100)? 1 : 	//beq
				  (IR_D[31:26]==6'b000101)? 1 :	//bne
				  (IR_D[31:26]==6'b000111)? 1 :	//bgtz
				  (IR_D[31:26]==6'b000001)? 1 :	//bgezal
				  (IR_D[31:26]==6'b000110)? 1 :	//blez
				  (IR_D[31:26]==6'b000001)? 1 :	//bltz and bgez
					0 ;
	assign IfJr=((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b001000))?1://jr_D
					((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b001001))?1://jalr_D
					0;	
	assign If_mult_cal=  ((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b011000))?1:	//MULT
								((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b011001))?1:	//multu
								((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b011010))?1:	//div
								((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b011011))?1:	//divu
								((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b010001))?1:	//mthi
								((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b010011))?1:	//mtlo
								((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b010000))?1:	//mfhi
								((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b010010))?1:	//mflo
								((IR_D[31:26]==6'b011100)&(IR_D[5:0]==6'b000100))?1:	//msub
								0;
	assign lw_E= (IR_E[31:26]==6'b100011)?	1:	//lw
		          (IR_E[31:26]==6'b100000)? 1:	//lb
					 (IR_E[31:26]==6'b100100)? 1:	//lbu
					 (IR_E[31:26]==6'b100001)? 1:	//lh
					 (IR_E[31:26]==6'b100101)? 1:	//lhu
					  0;  
	assign lw_M= (IR_M[31:26]==6'b100011)?	1:	//lw
		          (IR_M[31:26]==6'b100000)? 1:	//lb
					 (IR_M[31:26]==6'b100100)? 1:	//lbu
					 (IR_M[31:26]==6'b100001)? 1:	//lh
					 (IR_M[31:26]==6'b100101)? 1:	//lhu
					  0;  
	initial
		begin
		pause=0;
		end
	always@(*)
	begin
	pause=((IfB|IfJr)&(IR_E!=32'b0)&((IR_D[25:21]==IR_E[20:16])|(IR_D[25:21]==IR_E[15:11])|(IR_D[20:16]==IR_E[20:16])|(IR_D[20:16]==IR_E[15:11])))?1:
			((IfB|IfJr)&lw_M&((IR_M[20:16]==IR_D[25:21])|(IR_M[20:16]==IR_D[20:16])))? 1:
			(lw_E&((IR_E[20:16]==IR_D[25:21])|(IR_E[20:16]==IR_D[20:16])))?       1:
			(Busy&If_mult_cal)  ?       1:
			0;
	end
	assign pcen=~pause;
	assign IR_Eclr=pause;
	assign enD=~pause;
endmodule
