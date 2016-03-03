`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:07:50 11/22/2015 
// Design Name: 
// Module Name:    DM 
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
module DM(addr,din,we,clk,dout,IR_M,offset,BE,dmaddr_error);
	input[12:2] addr;
	input[1:0] offset;
	input[31:0] din,IR_M;
	input we;
	input dmaddr_error;
	input clk;
	output [3:0] BE;
	output[31:0] dout;
	integer i;
	reg[31:0] dm[2047:0];
	initial
		begin
			for(i=0;i<=2047;i=i+1)
				begin
					dm[i]=dm[i]<<32;		//reset  to  0
				end
		end
	assign BE=( IR_M[31:26]==6'b101011) ?4'b1111:
				 ((IR_M[31:26]==6'b101001)&(offset==0))?4'b0011:
				 ((IR_M[31:26]==6'b101001)&(offset==2))?4'b1100:
				 ((IR_M[31:26]==6'b101000)&(offset==0))?4'b0001:
				 ((IR_M[31:26]==6'b101000)&(offset==1))?4'b0010:
				 ((IR_M[31:26]==6'b101000)&(offset==2))?4'b0100:
				 ((IR_M[31:26]==6'b101000)&(offset==3))?4'b1000:
				 4'b0000;
	assign dout=dm[addr];
	always @(posedge clk)
		begin
			if(we&(~dmaddr_error))
				begin
					if (BE==4'b1111)begin dm[addr]=din;                end
					if (BE==4'b0011)begin dm[addr][15: 0]=din[15: 0];  end
					if (BE==4'b1100)begin dm[addr][31:16]=din[15: 0];  end
					if (BE==4'b0001)begin dm[addr][7:0]  =din[7: 0];   end
					if (BE==4'b0010)begin dm[addr][15:8] =din[7: 0];   end
					if (BE==4'b0100)begin dm[addr][23:16]=din[7: 0];   end
					if (BE==4'b1000)begin dm[addr][31:24]=din[7: 0];   end
					$display("*%x <= %x", {addr,2'b00}, dm[addr]);					
				end
		end
endmodule
