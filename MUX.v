`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:31:45 11/22/2015 
// Design Name: 
// Module Name:    MUX 
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
module MUX_2_32(A,B,Op,out);
	input[31:0] A,B;
	input Op;
	output[31:0] out;
	reg[31:0] out;
	always @(*)
		begin
			if(Op)
				begin
					out=B;
				end
			else
				begin
					out=A;
				end
		end
endmodule



module MUX_2_5(A,B,Op,out);
	input[4:0] A,B;
	input Op;
	output[4:0] out;
	reg[4:0] out;
	always @(*)
		begin
			if(Op)
				begin
					out=B;
				end
			else
				begin
					out=A;
				end
		end		
endmodule 



module MUX_2_30(A,B,Op,out);
	input[29:0] A,B;
	input Op;
	output[29:0] out;
	reg[29:0] out;
	always @(*)
		begin
			if(Op)
				begin
					out=B;
				end
			else
				begin
					out=A;
				end
		end
endmodule 

module MUX_4_32(A,B,C,D,Op,out);
	input[31:0] A,B,C,D;
	input [1:0]Op;
	output[31:0] out;
	reg[31:0] out;
	always @(*)
		begin
			case(Op)
			2'b00:begin out=A;end
			2'b01:begin out=B;end
			2'b10:begin out=C;end
			2'b11:begin out=D;end
			endcase
		end
endmodule 