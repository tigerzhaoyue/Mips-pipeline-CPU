	`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// R:addu subu sub add and or sarv sllv srlv slt sltu xor nor
// I:ori lui addiu addi(no overflow)
// J:j jal jr jalr
// B:beq bgtz bne bgezal bgez bltz blez
// S:sw
// L:lw
//
//////////////////////////////////////////////////////////////////////////////////
module mips(clk,reset,PrRD,HWInt,PrAddr,PrBE,PrWD,PrWe);
	input clk,reset;
	input [31:0] PrRD;
	input [7:2] HWInt;
	output [31:2]PrAddr;
	output [3:0]PrBE;
	output [31:0] PrWD;
	output PrWe;
	wire RegDst_D,AluSrc_D,MemToReg_D,RegWrite_D,MemWrite_D,IfBeq_D,IfJal_D,IfJr_D,IfJ_D,Equal_D,IfBne_D,IfBgtz_D,Bgtz_D,IfBgezal_D,Bgez_D,IfJalr_D,IfBlez_D,IfBltz_D,IfBgez_D,C0Write_D;
	wire RegDst_E,AluSrc_E,MemToReg_E,RegWrite_E,MemWrite_E,IfBeq_E,IfJal_E,IfJr_E,IfJ_E,Equal_E,IfBgezal_E,IfLink_E,IfJalr_E,mfhi_E,C0Write_E;
	wire [1:0] ExtOp_D,forwardrsd,forwardrtd,forwardrse,forwardrte,forwardrtm;
	wire [3:0] Alu_Op_D,Alu_Op_E;
	wire MemToReg_M,RegWrite_M,MemWrite_M,IfBeq_M,IfJal_M,IfJr_M,IfJ_M,Equal_M,IfBgezal_M,IfJalr_M,IfLink_M,Ifmfhilo_M,C0Write_M;
	wire RegWrite_W,MemToReg_W,IfJal_W,IfBgezal_W,IfLink_W,IfJalr_W;
	wire pcen,flush_E,Pcsrc,D_en,Busy,Exlset,IntReq,Iferet_M;	////exlset IntReq Iferet
	wire [31:0]IR_F,IR_D,Result_W,RData1_D,RData2_D,ext_out_D,IR_E,ext_out_E,RData1_E,RData2_E,B_E,ALU_out_E,HI,LO,Multdata_E,IR_M;
	wire [31:0]ALU_out_M,Multdata_M,ALU_Multresult_M,RData2_M,Memdata_M,DMdata_M,IR_W,Memdata_W,Memdataext_W,ALU_out_W,dataResult_W, pcadd2ext_W,pcadd2ext_M,RSD,RTD,RSE,RTE,RTM,CP0out_M,Result_M,PCALUresult_M;
	wire [31:0] pc_F,npc,pcadd1_F,pcadd1_D,pcadd1_E,pcadd1_M,pcadd1_W,realnpc,pcadd2_W,pcadd2_M,EPC,finalpc,lastpc;	////	EPC
	wire [4:0] WriteReg_W,dataWriteReg_E,WriteReg_E,WriteReg_M;
	wire [12:2] im_addr;
	wire [12:2] dm_addr;
	wire dmaddr_error,jump_flush;
	wire [6:2] ExcCode;	////exccode
//F:
	MUX_2_32 mpc(pcadd1_F,npc,Pcsrc,realnpc);		//Branch npc
	MUX_2_32 epcsrc(realnpc,EPC,Iferet_M,finalpc);	//if ERET return PC4
	MUX_2_32 Intpcsrc(finalpc,'h00004180,jump_flush,lastpc);	//ifInt to exception handler
	PC pc1(clk,reset,lastpc,pc_F,pcen,jump_flush,Iferet_M);
	assign im_addr=pc_F[12:2];
	PCADD pcadd1(pc_F,pcadd1_F);
	IM im1(pc_F,IR_F);
	
//D:
	DREG dreg1(clk,D_en,1'b0,IR_F,pcadd1_F,IR_D,pcadd1_D,jump_flush,Iferet_M);
	ctrl ctrl(IR_D[31:26],IR_D[5:0],IR_D[25:21],IR_D[20:16],RegDst_D,AluSrc_D,MemToReg_D,RegWrite_D,MemWrite_D,IfBeq_D,IfJal_D,IfJr_D,ExtOp_D,Alu_Op_D,IfJ_D,IfBne_D,IfBgtz_D,IfBgezal_D,IfJalr_D,IfBlez_D,IfBltz_D,IfBgez_D,C0Write_D);
	RF rf1(clk,reset,IR_D[25:21],IR_D[20:16],WriteReg_W,RegWrite_W,Result_W,RSD,RTD);
	MUX_4_32 md1(RSD,Result_M,Result_W,pcadd2ext_M,forwardrsd, RData1_D);
	MUX_4_32 md2(RTD,Result_M,Result_W,pcadd2ext_M,forwardrtd, RData2_D);
	assign Equal_D = (RData1_D==RData2_D)? 1'b1 : 1'b0 ;
	assign Bgtz_D  = ((RData1_D[31]==0)&(RData1_D!=31'b0))?    1'b1 : 1'b0 ;
	assign Bgez_D  = (RData1_D[31]==1'b0)?                     1'b1 : 1'b0 ;
	EXT ext1(IR_D[15:0],ExtOp_D,ext_out_D);
	assign Pcsrc=IfJal_D|IfJ_D|
						((IfJr_D|IfJalr_D)&D_en)|(IfBeq_D&Equal_D&D_en)|
						(IfBne_D&(~Equal_D)&D_en)|(IfBgtz_D&Bgtz_D&D_en)|
						(IfBlez_D&(~Bgtz_D)&D_en)|(IfBltz_D&(~Bgez_D)&D_en)|
						(IfBgez_D&Bgez_D&D_en)|(IfBgezal_D&Bgez_D&D_en);			//branch  or  jump  signal
	NPC npc1(pcadd1_D,IR_D[15:0],npc,IfBeq_D,IfJal_D,IfJr_D,IfJ_D,IR_D[25:0],RData1_D,IfBne_D,IfBgtz_D,IfBgezal_D,IfJalr_D,IfBlez_D,IfBltz_D,IfBgez_D,IR_D);
	PAUSEctrl pausectrl1(IR_D,IR_E,IR_M,pcen,flush_E,D_en,Busy);

//E:
	EREG ereg1(clk,flush_E,IR_D,pcadd1_D,ext_out_D,RData1_D,RData2_D,IR_E,pcadd1_E,ext_out_E,RSE,RTE,jump_flush,Iferet_M,
					RegDst_D,AluSrc_D,MemToReg_D,RegWrite_D,MemWrite_D,IfBeq_D,IfJal_D,IfJr_D,Alu_Op_D,IfJ_D,Equal_D,IfBgezal_D,IfJalr_D,C0Write_D,
					RegDst_E,AluSrc_E,MemToReg_E,RegWrite_E,MemWrite_E,IfBeq_E,IfJal_E,IfJr_E,Alu_Op_E,IfJ_E,Equal_E,IfBgezal_E,IfJalr_E,C0Write_E);
	MUX_4_32 me1(RSE,Result_M,Result_W,32'b0,forwardrse,RData1_E);
	MUX_4_32 me2(RTE,Result_M,Result_W,32'b0,forwardrte,RData2_E);
	MUX_2_5  M1(IR_E[20:16],IR_E[15:11],RegDst_E,dataWriteReg_E);
	assign IfLink_E=IfJal_E|IfBgezal_E;	//no jalr  jalr write to $rd
	MUX_2_5  M5(dataWriteReg_E,5'b11111,IfLink_E,WriteReg_E);
	MUX_2_32 M2(RData2_E,ext_out_E,AluSrc_E,B_E);
	ALU alu1(RData1_E,B_E,Alu_Op_E,ALU_out_E,,IR_E[10:6]);
	Mult mlut1(clk,reset,RData1_E,RData2_E,IR_E,IR_D,Busy,HI,LO);
	assign mfhi_E=((IR_E[31:26]==6'b000000)&(IR_E[5:0]==6'b010000))?1:0;	//mfhi
	MUX_2_32 hilomux(LO,HI,mfhi_E,Multdata_E);
	FORWARDctrl forwardctrl1(IR_D,IR_E,IR_M,IR_W,forwardrsd,forwardrtd,forwardrse,forwardrte,forwardrtm,RegWrite_M,RegWrite_W,WriteReg_M,WriteReg_W);
	
//M:
	MREG mreg1(clk,IR_E,pcadd1_E,IR_M,pcadd1_M,ALU_out_E,ALU_out_M,Multdata_E,Multdata_M,RData2_E,RTM,WriteReg_E,WriteReg_M,jump_flush,Iferet_M,
					MemToReg_E,RegWrite_E,MemWrite_E,IfBeq_E,IfJal_E,IfJr_E,IfJ_E,Equal_E,IfBgezal_E,IfJalr_E,C0Write_E,
					MemToReg_M,RegWrite_M,MemWrite_M,IfBeq_M,IfJal_M,IfJr_M,IfJ_M,Equal_M,IfBgezal_M,IfJalr_M,C0Write_M);
	MUX_4_32 mm2(RTM,Result_W,0,0,forwardrtm,RData2_M);
	assign IfLink_M=IfJal_M|IfBgezal_M|IfJalr_M;
	assign Ifmfhilo_M=   ((IR_M[31:26]==6'b000000)&(IR_M[5:0]==6'b010000))?1:	//mfhi
								((IR_M[31:26]==6'b000000)&(IR_M[5:0]==6'b010010))?1:	//mflo
								0;
	assign dm_addr=ALU_out_M[12:2];
	assign dmaddr_error=(ALU_out_M[31:2]>2047)? 1: 0;
	assign pcadd2_M=pcadd1_M+32'b100;
	assign pcadd2ext_M=pcadd2_M;			// for  link hazard
	assign MFC0_M=(IR_M[31:21]==11'b01000000000)? 1:0;
	MUX_2_32 ALUoutandMult(ALU_out_M,Multdata_M,Ifmfhilo_M,ALU_Multresult_M);
	MUX_2_32 PC8andALUout(ALU_Multresult_M,pcadd2ext_M,IfLink_M,PCALUresult_M);
	MUX_2_32 PCALUandC0(PCALUresult_M,CP0out_M,MFC0_M,Result_M);
	DM dm1(dm_addr,RData2_M,PrWe,clk,DMdata_M,IR_M,ALU_out_M[1:0],PrBE,dmaddr_error);
	MUX_2_32 dmanddevice(DMdata_M,PrRD,dmaddr_error,Memdata_M);	//dmerror means read from hardware
	assign ExcCode=5'b00000;
	assign PrWe=MemWrite_M&(~jump_flush);
	assign PrAddr=ALU_out_M[31:2];
	assign PrWD=RData2_M;
	assign Exlset=0;	// Int is judged in CP0 
	CP0 cp0(clk,reset,IR_M,IR_W,RData2_M,pcadd1_M,ExcCode,HWInt,C0Write_M,Exlset,IntReq,EPC,CP0out_M,Iferet_M,jump_flush);
	
//W:
	WREG wreg1(clk,IR_M,pcadd1_M,IR_W,pcadd1_W,Result_M,ALU_out_W,Memdata_M,Memdata_W,WriteReg_M,WriteReg_W,jump_flush,Iferet_M,
					RegWrite_M,MemToReg_M,IfJal_M,IfBgezal_M,IfJalr_M,
					RegWrite_W,MemToReg_W,IfJal_W,IfBgezal_W,IfJalr_W);
	DataEXT dataext1(Memdata_W,IR_W,ALU_out_W[1:0],Memdataext_W);
	MUX_2_32 M3(ALU_out_W,Memdataext_W,MemToReg_W,dataResult_W);
	assign pcadd2_W=pcadd1_W+32'b100;
	assign pcadd2ext_W=pcadd2_W;
	assign IfLink_W=IfJal_W|IfBgezal_W|IfJalr_W;
	MUX_2_32 M4(dataResult_W, pcadd2ext_W,IfLink_W,Result_W);
	
endmodule

