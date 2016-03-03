`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:18:14 12/20/2015 
// Design Name: 
// Module Name:    TC 
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
module timer_dubug(
	input clk,
	input reset,
	input [3:2] addr,
	input [31:0] Din,
	input we,
	output [31:0] Dout,
	output  IntReq
    );
	reg [31:0] ctrl,preset,count;
	
	reg [2:1] state;				/*状态机状态*/
	
	reg Intreg;					/*中断信号*/
	
	reg presetwritten;				/*preset改变标志*/
	
	reg IntReq;
	
	parameter IDLE     =2'b00,		/*状态机的可能的状态*/
					  LOAD    =2'b01,
					  CNTING=2'b10,
					  INT        =2'b11;
	
	always @(*)
		begin
		IntReq=(ctrl[2:1]==2'b00&&ctrl[3]==1&&Intreg==1)?1:0;
		end
	//assign IntReq=(ctrl[2:1]==2'b00&&ctrl[3]==1&&Intreg==1)?1:0;
	
	assign Dout=(addr==2'b00)?ctrl:
						(addr==2'b01)?preset:
						(addr==2'b10)?count:0;
						
	always @(posedge clk or posedge reset)  	/*ctrl寄存器和preset寄存器*/
	begin
		if(reset)
		begin
			ctrl=0;
			preset=0;
			presetwritten=0;
		end
		else if(we==1)
		begin
			if(addr==2'b00)
				ctrl[3:0]=Din[3:0];
			else if(addr==2'b01)
			begin
				preset=Din;
				presetwritten=1;
			end
		end		
	end
		
	always @(posedge clk or posedge reset)		/*count寄存器*/
	begin
		if(reset)
		begin
			count<=0;
		end
	
		
	end
	
	
	
	
	always @(posedge clk or posedge reset)		/*状态机*/
	begin
		if(reset)
		begin
			Intreg<=0;
			state<=IDLE;
		end
		else 
		begin
			if(ctrl[2:1]==2'b00)					/*0模式*/
			begin
				case(state)
					IDLE: 
					begin	
						if(presetwritten)
							state<=LOAD;
						else
							state<=IDLE;
					end
					LOAD:
					begin
						if(ctrl[0]==0)
							state<=LOAD;
						else
						begin
							count=preset;
							state=CNTING;
							Intreg=0;								
						end
					end
					CNTING:
					begin
						presetwritten=0;
						if(ctrl[0]==0)
							state<=IDLE;
						else
						begin
							count<=count-1;
							if(count==1)
								state<=INT;
							else 
								state<=CNTING;
						end
					end
					INT:
					begin
						Intreg=1;
						state=IDLE;
					end
				endcase
			end
			else if(ctrl[2:1]==2'b01)				/*1模式*/
			begin
				case(state)
					IDLE: 
					begin
						if(ctrl[0]==0)
							state<=IDLE;
						else
							state<=LOAD;
					end
					LOAD:
					begin
						count=preset;
						Intreg=0;
						state=CNTING;
					end
					CNTING:
					begin
						if(ctrl[0]==0)
							state<=IDLE;
						else
						begin
							count<=count-1;
							if(count==1)
								state<=INT;
							else 
								state<=CNTING;
						end
					end
					INT:
					begin
						Intreg=1;
						state=IDLE;
					end
				endcase
			end
		end
		
		
	end
	
endmodule
