`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:07:36 11/22/2015 
// Design Name: 
// Module Name:    IM 
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
module IM(pc,dout);
	input[31:0] pc;
	wire [12:2]addr;
	output  reg [31:0] dout;
	reg[31:0] im[0:2047];
	assign addr=(pc-'h00003000)>>2;
	initial
		begin
			$readmemh("code.txt",im);
			$readmemh("code_handler.txt",im,'h460);
		end
	always @(pc)
		begin
			dout=im[addr];
		end
endmodule
