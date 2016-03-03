`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:26:56 11/22/2015 
// Design Name: 
// Module Name:    ALU 
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
module ALU(A,B,Op,C,Over,s);
	input[31:0] A,B;
	input[3:0] Op;
	input[4:0] s;
	output reg [31:0] C;
	output reg Over;
	integer i;
	initial
		begin
			C<=32'b0;
		end
	always @(*)
		begin
			case(Op)
			4'b0000:C<=A&B;
			4'b0001:C<=A|B;
			4'b0010:C<=A+B;
			4'b0011:C<=B;		//lui
			4'b0100:C<=B<<A[4:0];	//sllv
			4'b0101:C<=B>>A[4:0];	//srlv
			4'b0110:C<=A-B;
			4'b0111:begin 
						C<=B>>s;
						for(i=31;i>31-s;i=i-1)
							begin
								C[i]<=B[31];
							end
					  end//sra
			4'b1000:begin 
						C<=B>>A[4:0];
						for(i=31;i>31-A[4:0];i=i-1)
							begin
								C[i]<=B[31];
							end
					  end				//srav
			4'b1001:C<=A^B;		//xor
			4'b1010:C<=~(A|B);	//nor
			4'b1011:C<= ((A[31]==1'b1&B[31]==1'b0)|(A[31]==1'b0&B[31]==1'b0&(A<B))|(A[31]==1'b1&B[31]==1'b1&(A<B)))?32'b1:32'b0;	//slt
			4'b1100:C<=  A<B? 32'b1:32'b0;		//sltu
			4'b1101:C<=B<<s;	//sll
			4'b1110:C<=B>>s;	//srl
			default:begin C<=B;end
			endcase
			Over<=0;
		end
endmodule
