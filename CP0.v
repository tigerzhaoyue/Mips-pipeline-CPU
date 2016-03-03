`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:42:17 12/12/2015 
// Design Name: 
// Module Name:    CP0 
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
module CP0(clk,reset,IR_M,IR_W,Din,PC4,ExcCode,HWInt,we,EXLset,IntReq,EPC,Dout,Iferet,jump_flush);
	input clk,reset,we,EXLset;
	input [31:0] Din,PC4,IR_M,IR_W;
	input [6:2] ExcCode;
	input [7:2] HWInt;
	output reg IntReq;
	output jump_flush,Iferet;
	output [31:0] EPC,Dout;
	integer i;
	wire Ifdelay_M;
	integer k;
	reg [31:0] Mem[31:0];	//12SR 13Cause 14EPC 15PrID
	
	assign Dout = Mem[IR_M[15:11]];
	assign EPC =Mem[14];
	assign Iferet=(IR_M==32'b0100_0010_0000_0000_0000_0000_0001_1000)? 1:0;
	assign Ifdelay_M=(IR_W[31:26]==6'b000100)? 1 : 	//beq
						  (IR_W[31:26]==6'b000101)? 1 :	//bne
				        (IR_W[31:26]==6'b000111)? 1 :	//bgtz
				        (IR_W[31:26]==6'b000001)? 1 :	//bgezal
				        (IR_W[31:26]==6'b000110)? 1 :	//blez
				        (IR_W[31:26]==6'b000001)? 1 :	//bltz and bgez
						  ((IR_W[31:26]==6'b000000)&(IR_W[5:0]==6'b001000))?1://jr_W
					     ((IR_W[31:26]==6'b000000)&(IR_W[5:0]==6'b001001))?1://jalr_W
						  (IR_W[31:26]==6'b000010)? 1 :	//J
						  (IR_W[31:26]==6'b000011)? 1 :	//JAL
						  0;
	
	initial
		begin
			for(i=0;i<=31;i=i+1)
				Mem[i]=Mem[i]<<32;	// all 0
			Mem[12]='h0000_ff11;	//keep with Mars
			Mem[15]='h1423_1027;	//My own number
			k=0;
		end
	always @(*)
		begin
		IntReq =((HWInt[7]&Mem[12][15])|(HWInt[6]&Mem[12][14])|(HWInt[5]&Mem[12][13])|(HWInt[4]&Mem[12][12])|(HWInt[3]&Mem[12][11])|(HWInt[2]&Mem[12][10])) & Mem[12][0] & (~Mem[12][1]);	// IM[7:2] & HWINt & IE & EXL			
		Mem[13][15:10]=HWInt[7:2];	//IP
		Mem[13][6:2]=ExcCode;	//cause
		if(IntReq)
			begin
			//Mem[12][1]=1'b1;	//exl=1 kernal mode
			Mem[14]=Ifdelay_M?(PC4-8):
					  (PC4-4);	//set EPC
			end
		end
	assign jump_flush=IntReq;
	always @(posedge clk or posedge reset)
		begin
		if(reset)
		begin
		for(i=0;i<=31;i=i+1)
				Mem[i]=Mem[i]<<32;	// all 0
			Mem[12]='h0000_ff11;	//keep with Mars
			Mem[15]='h1423_1027;	//My own number
			k=0;
		end
		
		k=k-1;
		
		if(we)
			begin
			if(IR_M[15:11]==5'b01100)//write SR
				begin
				Mem[12][15:10]=Din[15:10];	//im
				Mem[12][1]  =Din[1];			//EXL
				Mem[12][0]  =Din[0];			//IE
				end
			else if(IR_M[15:11]==5'b01101)	//write cause
				begin
				Mem[13][6:2]  =Din[6:2];	//ExcCode[6:2]	(0:Int  10:illegal-IR	12:overflow)
				end
			else if(IR_M[15:11]==5'b01111)	//PrID
				;										//Read only
			else
				Mem[IR_M[15:11]]=Din;			
			end
		
		if(EXLset|IntReq)				//M stage or Int from devices
			begin
			Mem[12][1]=1'b1; 
			end
		if(Iferet)				//from eret
			k=5;	//exl=0
		if(k==1)
			Mem[12][1]=1'b0;
		end

endmodule
