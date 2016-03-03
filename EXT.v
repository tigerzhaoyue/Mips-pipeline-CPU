`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:25:49 11/22/2015 
// Design Name: 
// Module Name:    EXT 
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
module EXT(in,ext_op,out);
	input[15:0] in;
	input[1:0] ext_op;
	output reg [31:0] out;
	integer i;
	always @(*)
	begin
		case(ext_op)
		2'b00:	//zero ext
			begin
				out[15:0]=in;
				out[31:16]=16'b0;
			end
		2'b01:	//sign ext
			begin
				out[15:0]=in;
				for(i=16;i<=31;i=i+1)
						out[i]=in[15];
			end
		2'b10:	//lui ext
			begin
				out=in<<16;
			end
		default:begin out=32'b0; end	//all 0
		endcase
	end
endmodule 
