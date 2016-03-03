`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:51:08 12/06/2015 
// Design Name: 
// Module Name:    DataEXT 
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
module DataEXT(Din,IR_W,OFFSET,Dout);
	input [31:0] IR_W,Din;
	input [1:0] OFFSET;
	output reg [31:0] Dout;
	integer i;
	always @(*)
		begin
		if(IR_W[31:26]==6'b100000)	 //lb
			begin
			if(OFFSET==2'b00)
				begin 
				Dout[7:0]=Din[7:0];
				for(i=8;i<=31;i=i+1) Dout[i]=Din[7];
				end
			else if(OFFSET==2'b01)
				begin 
				Dout[7:0]=Din[15:8];
				for(i=8;i<=31;i=i+1) Dout[i]=Din[15];
				end
			else if(OFFSET==2'b10)
				begin 
				Dout[7:0]=Din[23:16];
				for(i=8;i<=31;i=i+1) Dout[i]=Din[23];
				end
			else if(OFFSET==2'b11)
				begin 
				Dout[7:0]=Din[31:24];
				for(i=8;i<=31;i=i+1) Dout[i]=Din[31];
				end
			end
		else if(IR_W[31:26]==6'b100100)	//lbu
			begin
			if(OFFSET==2'b00)
				begin 
				Dout[7:0]=Din[7:0];
				for(i=8;i<=31;i=i+1) Dout[i]=0;
				end
			else if(OFFSET==2'b01)
				begin 
				Dout[7:0]=Din[15:8];
				for(i=8;i<=31;i=i+1) Dout[i]=0;
				end
			else if(OFFSET==2'b10)
				begin 
				Dout[7:0]=Din[23:16];
				for(i=8;i<=31;i=i+1) Dout[i]=0;
				end
			else if(OFFSET==2'b11)
				begin 
				Dout[7:0]=Din[31:24];
				for(i=8;i<=31;i=i+1) Dout[i]=0;
				end
			end
		else if(IR_W[31:26]==6'b100001)	//lh
			begin
			if(OFFSET==2'b00)
				begin
				Dout[15:0]=Din[15:0];
				for(i=16;i<=31;i=i+1) Dout[i]=Din[15];
				end
			if(OFFSET==2'b10)
				begin
				Dout[15:0]=Din[31:16];
				for(i=16;i<=31;i=i+1) Dout[i]=Din[31];
				end
			end
		else if(IR_W[31:26]==6'b100101)	//lhu
			begin
			if(OFFSET==2'b00)
				begin
				Dout[15:0]=Din[15:0];
				for(i=16;i<=31;i=i+1) Dout[i]=0;
				end
			if(OFFSET==2'b10)
				begin
				Dout[15:0]=Din[31:16];
				for(i=16;i<=31;i=i+1) Dout[i]=0;
				end
			end
		else	//lw or other op
			begin
			Dout=Din;
			end
		end

endmodule

