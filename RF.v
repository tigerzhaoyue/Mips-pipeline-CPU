`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:40:06 11/22/2015 
// Design Name: 
// Module Name:    RF 
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
module RF(clk,rst,RS1,RS2,RD,RegWrite,WData,RData1,RData2);
	input clk,rst,RegWrite;
	input[4:0] RS1,RS2,RD;
	input[31:0] WData;
	output reg [31:0] RData1,RData2;
	reg[31:0] Mem[31:0];
	integer i;
	initial
		begin
			for(i=0;i<=31;i=i+1)
				Mem[i]<=Mem[i]<<32;	// all 0
		end
	always @(*)
		begin
		if(RegWrite&&(RS1==RD)&&(RS1!=5'b00000))
			begin
			RData1<=WData;
			end
		else
			begin
			RData1<=Mem[RS1];
			end
		if(RegWrite&&(RS2==RD)&&(RS2!=5'b00000))
			begin
			RData2<=WData;
			end
		else
			begin
			RData2<=Mem[RS2];
			end
		end
	always @(posedge clk or posedge rst)
		begin
			if(rst)
				begin
					for(i=0;i<=31;i=i+1)
						Mem[i]<=Mem[i]<<32;		//all 0
				end
			else if(RegWrite)		
				begin
					
					if(RD!=5'b00000)				//if write Mem[0],don't write
						begin
						Mem[RD]<=WData;
						$display("$%d <= %x", RD, WData);
						end
				end
		end
			
endmodule 