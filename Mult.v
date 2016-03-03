`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:45:38 12/07/2015 
// Design Name: 
// Module Name:    Mult 
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
module Mult(clk,rst,D1,D2,IR_E,IR_D,Busy,HI,LO);
	input clk,rst;
	input signed [31:0] D1,D2,IR_E,IR_D;
	output reg Busy;
	output reg [31:0]HI,LO;
	wire [31:0] uD1,uD2;
	wire [3:0] op;
	reg [3:0] i;
	reg [63:0] result;
	assign uD1=D1;
	assign uD2=D2;
	assign op=((IR_E[31:26]==6'b000000)&(IR_E[5:0]==6'b011001))?4'b0000:	//multu
				 ((IR_E[31:26]==6'b000000)&(IR_E[5:0]==6'b011000))?4'b0001:	//mult
				 ((IR_E[31:26]==6'b000000)&(IR_E[5:0]==6'b011011))?4'b0010:	//divu
				 ((IR_E[31:26]==6'b000000)&(IR_E[5:0]==6'b011010))?4'b0011:	//div
				 ((IR_E[31:26]==6'b011100)&(IR_E[5:0]==6'b000100))?4'b0100:	//msub
				 4'b1111;
	initial		begin		    HI<=32'b0;			 LO<=32'b0;			 Busy<=1'b0;			 i<=4'b0;			 result<=64'b0;		end
	always @(*)
	begin
	if(op[3]!=1) Busy<=1;
	end
	always @ (posedge clk)
		begin
		   if(rst)
			 begin
		      HI<=32'b0;
			   LO<=32'b0;
			   Busy<=1'b0;
			   i<=4'b0;
			   result<=64'b0;
			 end
			 else
			 begin
			   if(op[3]!=1)
				 begin
				    case (op)
						4'b0000: //multu
						begin
							 result<=uD1*uD2;
							 i<=4'b0100;
							 Busy<=1'b1;
						end
						4'b0001: //mult
						begin
						    result<=D1*D2;
							 i<=4'b0100;
				          Busy<=1'b1;
						end
						4'b0100: //msub
						begin
							result=$signed(result)-D1*D2;
							 i<=4'b0100;
				          Busy<=1'b1;
						end
						4'b0010: //divu
						begin
							i<=4'b0100;
				         Busy<=1'b1;
						   if(D2!=32'b0)
							 begin
						       result[31: 0]<=uD1/uD2;
							    result[63:32]<=uD1%uD2;
							 end
						end
						4'b0011://div
						begin
							i<=4'b0100;
				         Busy<=1'b1;
						   if(D2!=32'b0)
							 begin
						      result[31:0]<=D1/D2;
							   result[63:32]<=D1%D2;
							   
								end
						end
						endcase
				 end
				 if(i==4'b0001)		//cal over   save the result
				 begin
				       HI<=result[63:32];
						 LO<=result[31:0];
						 i<=4'b0;
						 Busy<=0;
				 end
				 else if (i!=4'b0000)	//being cal
				 begin
				       i<=i-1;
						 Busy=1'b1;
				 end
				 if((IR_E[31:26]==6'b000000)&(IR_E[5:0]==6'b010001))
				    begin
				       HI<=D1;
						 result[63:32]<=D1;
				    end
				 if((IR_E[31:26]==6'b000000)&(IR_E[5:0]==6'b010011))
				    begin
				       LO<=D1;
						 result[31: 0]<=D1;
				    end
			 end
		end

	
endmodule
