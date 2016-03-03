`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:41 12/12/2015 
// Design Name: 
// Module Name:    timer0 
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
module timer(clk,reset,addr,Din,we,Dout,IntReq);
	input clk,reset;
	input [3:2] addr;
	input we;
	input [31:0] Din;
	output [31:0] Dout;
	output  reg IntReq;
	reg[31:0] ctrl,preset,count;
	reg[1:0] now,next;	//state
	reg presetwritten;
	
	assign Dout= (addr==2'b00)? ctrl:
					 (addr==2'b01)? preset:
					 (addr==2'b11)? count:
					 32'b0;
	initial
		begin
		now=2'b00;
		next=2'b00;
		ctrl=32'b0000;
		count=32'b0;
		preset=32'b0;
		IntReq= 0;
		presetwritten=0;
		end
	always @(*)
		begin
		case(now)
		2'b00: next= presetwritten? 2'b01:2'b00;	//IDLE
		2'b01:next=2'b10;												//LOAD
		2'b10:next= (count==1)? 2'b11:	//finish counting
						(ctrl[0]==1'b0)?2'b00:	//enable=0 goto IDLE
						 2'b10;						//COUNTING
		2'b11:next=2'b00;												//INT
		endcase
		end
	always @(posedge clk or posedge reset)
		begin
		if(reset)
			begin
			now=2'b00;
			next=2'b00;
			ctrl=32'b0;
			count=32'b0;
			preset=32'b0;
			IntReq= 0;
			presetwritten=0;
			end
		else
			begin
			
			if(we)
				begin
				case(addr)
				2'b00:ctrl[3:0]=Din[3:0];
				2'b01:begin preset=Din; presetwritten=1'b1; end       //start to load				
				endcase
				end
			
				now=next;
				case(now)
				2'b01: begin count=preset; IntReq= 0; end
				2'b10: begin presetwritten=1'b0;count=count-1; end
				2'b11: begin  
							     if(ctrl[2:1]==2'b00) ctrl[0]=1'b1; 
							else if(ctrl[2:1]==2'b01) ctrl[0]=1'b1;
						 end
				endcase				
			end
		end
	
	always @(*)
		begin
		if((now==2'b11)&&(ctrl[3]==1'b1)&&(ctrl[2:1]==2'b00))
		IntReq= 1;
		end
endmodule
