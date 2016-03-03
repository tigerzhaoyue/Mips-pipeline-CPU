`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:41:31 11/22/2015 
// Design Name: 
// Module Name:    ctrl 
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
module ctrl(Op,Func,Rsfunc,Rtfunc,RegDst,AluSrc,MemToReg,RegWrite,MemWrite,IfBeq,IfJal,IfJr,ExtOp,Alu_Op,IfJ,IfBne,IfBgtz,IfBgezal,IfJalr,IfBlez,IfBltz,IfBgez,C0Write);
	input[31:26] Op;
	input[5:0] Func;
	input[20:16] Rtfunc;
	input [25:21] Rsfunc;
	output reg RegDst,AluSrc,MemToReg,RegWrite,MemWrite,IfBeq,IfJal,IfJr,IfJ,IfBne,IfBgtz,IfBgezal,IfJalr,IfBlez,IfBltz,IfBgez,C0Write;
	output reg [1:0] ExtOp;
	output reg [3:0] Alu_Op;
	always @ (*)
	begin 
		case(Op)		
		6'b000000:
			begin
				if(Func==6'b001000)			//jr
					begin
						Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0;
						MemWrite=1'b0; IfBeq=1'b0;IfJal=1'b0; IfJr=1'b1; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
						IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
					end
				else if(Func==6'b001001)			//jalr
					begin
						Alu_Op=4'b1111; RegDst=1'b1; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b1;	//Regdst=1 write to rd
						MemWrite=1'b0; IfBeq=1'b0;IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
						IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b1;C0Write=1'b0;
					end
				else							//R 
					begin
						case(Func)		//R func
						6'b100001:begin Alu_Op=4'b0010; RegWrite=1'b1; end		//addu
						6'b100011:begin Alu_Op=4'b0110; RegWrite=1'b1; end		//subu
						6'b100000:begin Alu_Op=4'b0010; RegWrite=1'b1; end		//add
						6'b100010:begin Alu_Op=4'b0110; RegWrite=1'b1; end		//sub
						6'b000100:begin Alu_Op=4'b0100; RegWrite=1'b1; end		//sllv
						6'b000110:begin Alu_Op=4'b0101; RegWrite=1'b1; end		//srlv
						6'b000111:begin Alu_Op=4'b1000; RegWrite=1'b1; end		//srav
						6'b100100:begin Alu_Op=4'b0000; RegWrite=1'b1; end		//and
						6'b100101:begin Alu_Op=4'b0001; RegWrite=1'b1; end		//or
						6'b100110:begin Alu_Op=4'b1001; RegWrite=1'b1; end		//^xor
						6'b100111:begin Alu_Op=4'b1010; RegWrite=1'b1; end		//~|nor
						6'b101010:begin Alu_Op=4'b1011; RegWrite=1'b1; end		//slt
						6'b101011:begin Alu_Op=4'b1100; RegWrite=1'b1; end		//sltu
						6'b000000:begin Alu_Op=4'b1101; RegWrite=1'b1; end		//sll
						6'b000010:begin Alu_Op=4'b1110; RegWrite=1'b1; end		//srl
						6'b000011:begin Alu_Op=4'b0111; RegWrite=1'b1; end		//sra
						6'b011000:begin Alu_Op=4'b1111; RegWrite=1'b0; end		//mult
						6'b011001:begin Alu_Op=4'b1111; RegWrite=1'b0; end		//multu
						6'b011010:begin Alu_Op=4'b1111; RegWrite=1'b0; end		//div
						6'b011011:begin Alu_Op=4'b1111; RegWrite=1'b0; end		//divu
						6'b010000:begin Alu_Op=4'b1111; RegWrite=1'b1; end		//mfhi
						6'b010010:begin Alu_Op=4'b1111; RegWrite=1'b1; end		//mflo
						6'b010001:begin Alu_Op=4'b1111; RegWrite=1'b0; end		//mthi
						6'b010011:begin Alu_Op=4'b1111; RegWrite=1'b0; end		//mtlo
						default:	 begin Alu_Op=4'b1111; RegWrite=1'b0; end		//not Rfunc 
						endcase
						RegDst=1'b1; AluSrc=1'b0; MemToReg=1'b0; 
						MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
						IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0;  IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
					end
			end
		6'b011100:	//msub
			begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0;ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b001100:	//andi
			begin
				Alu_Op=4'b0000; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b0; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0;ExtOp=2'b00; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b001101:	//ori
			begin
				Alu_Op=4'b0001; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b0; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0;ExtOp=2'b00; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b001110:	//xori
			begin
				Alu_Op=4'b1001; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b0; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0;ExtOp=2'b00; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b001001:	//addiu
			begin
				Alu_Op=4'b0010; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b0; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b001000:	//addi
			begin
				Alu_Op=4'b0010; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b0; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0;ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b001111:	//lui
			begin
				Alu_Op=4'b0011; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b0; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b10; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b001010:	//slti
			begin
				Alu_Op=4'b1011; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b0; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0;ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b001011:	//sltiu
			begin
				Alu_Op=4'b1100; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b0; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0;ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b000010:	//J
			begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b1;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b100011:	//lw
			begin
				Alu_Op=4'b0010; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b1; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b100000:	//lb
			begin
				Alu_Op=4'b0010; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b1; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b100100:	//lbu
			begin
				Alu_Op=4'b0010; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b1; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b100001:	//lh
			begin
				Alu_Op=4'b0010; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b1; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b100101:	//lhu
			begin
				Alu_Op=4'b0010; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b1; RegWrite=1'b1;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b101011:		//sw
			begin
				Alu_Op=4'b0010; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b0; RegWrite=1'b0;
				MemWrite=1'b1; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b101001:		//sh
			begin
				Alu_Op=4'b0010; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b0; RegWrite=1'b0;
				MemWrite=1'b1; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b101000:		//sb
			begin
				Alu_Op=4'b0010; RegDst=1'b0; AluSrc=1'b1; MemToReg=1'b0; RegWrite=1'b0;
				MemWrite=1'b1; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b01; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b000100:	//Beq
			begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0;
				MemWrite=1'b0; IfBeq=1'b1; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b000101:	//Bne
			begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b1; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b000111:	//Bgtz
			begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b1; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b000110:	//Blez
			begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=1;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b000001:	//Bltz and bgez andBgezal
			begin
				if(Rtfunc==5'b00000)//bltz
				begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=1;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
				end
				else if(Rtfunc==5'b000001)//bgez
				begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0;
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=1;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
				end
				else //Bgezal
				begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b1;		//write pc4 to $31
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b1;IfJalr=1'b0;C0Write=1'b0;
			   end
			end
		6'b000011:		//Jal
			begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b1;		 
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b1; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		6'b010000:		//CO
			begin
			if(Func==6'b011000)	//eret
			begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0; 
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
			if(Rsfunc==5'b00000)	//mfc0
			begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b1; 
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
			if(Rsfunc==5'b00100)	//mtc0
			begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0; 
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b1;
			end
			end
		default:
			begin
				Alu_Op=4'b1111; RegDst=1'b0; AluSrc=1'b0; MemToReg=1'b0; RegWrite=1'b0; 
				MemWrite=1'b0; IfBeq=1'b0; IfJal=1'b0; IfJr=1'b0; IfJ=1'b0;IfBlez=0;IfBltz=0;IfBgez=0;
				IfBne=1'b0; ExtOp=2'b11; IfBgtz=1'b0; IfBgezal=1'b0;IfJalr=1'b0;C0Write=1'b0;
			end
		endcase
	end
endmodule
