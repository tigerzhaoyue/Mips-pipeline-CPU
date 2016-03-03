`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// D:Branch Jr                  M(R,I,link)2D  
//	E:R I Sw Lw                  M(R,I,Link)2E W(lw,R,I,Link,Lw)2E
// M:sw(rt)                     W(lw)2M(sw)
//////////////////////////////////////////////////////////////////////////////////
module FORWARDctrl(IR_D,IR_E,IR_M,IR_W,forwardrsd,forwardrtd,forwardrse,forwardrte,forwardrtm,writesig_M,writesig_W,writenum_M,writenum_W);
	input [31:0] IR_D,IR_E,IR_M,IR_W;
	input writesig_M,writesig_W;
	input [4:0] writenum_M,writenum_W;
	output reg [1:0] forwardrsd,forwardrtd,forwardrse,forwardrte,forwardrtm;
   assign IfB=(IR_D[31:26]==6'b000100)? 1 : 	//beq
				  (IR_D[31:26]==6'b000101)? 1 :	//bne
				  (IR_D[31:26]==6'b000111)? 1 :	//bgtz
				  (IR_D[31:26]==6'b000001)? 1 :	//bgezal
				  (IR_D[31:26]==6'b000110)? 1 :	//blez
				  (IR_D[31:26]==6'b000001)? 1 :	//bltz and bgez
					0 ;
	assign IfJr=((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b001000))?1://jr
					((IR_D[31:26]==6'b000000)&(IR_D[5:0]==6'b001001))?1://jalr
					0;
//forward signal:
	initial
		begin
			forwardrsd=2'b00;
			forwardrtd=2'b00;
			forwardrse=2'b00;
			forwardrte=2'b00;
			forwardrtm=2'b00;
		end
	always @(*)
		begin
		    forwardrsd=(IfB|IfJr)&(IR_D[25:21]==writenum_M)&(writenum_M!=5'b00000)&writesig_M? 2'b01:			
							2'b00;
							
		    forwardrtd=IfB    &   (IR_D[20:16]==writenum_M)&(writenum_M!=5'b00000)&writesig_M? 2'b01:			
							2'b00;
							
		   // forwardrse=(cal_r_E | cal_i_E | lw_E | sw_E )&cal_r_M&(IR_E[25:21]==IR_M[15:11])&(IR_M[15:11]!=5'b00000)?2'b01:
			//				(cal_r_E | cal_i_E | lw_E | sw_E )&cal_i_M&(IR_E[25:21]==IR_M[20:16])&(IR_M[20:16]!=5'b00000)?2'b01:
				//			(cal_r_E | cal_i_E | lw_E | sw_E )&(Jal_M|Bgezal_M|Jalr_M)  &(IR_E[25:21]==5'b11111)?     		 2'b11:
				//			(cal_r_E | cal_i_E | lw_E | sw_E )&cal_r_W&(IR_E[25:21]==IR_W[15:11])&(IR_W[15:11]!=5'b00000)?2'b10:
					//		(cal_r_E | cal_i_E | lw_E | sw_E )&cal_i_W&(IR_E[25:21]==IR_W[20:16])&(IR_W[20:16]!=5'b00000)?2'b10:
					//		(cal_r_E | cal_i_E | lw_E | sw_E )&lw_W   &(IR_E[25:21]==IR_W[20:16])&(IR_W[20:16]!=5'b00000)?2'b10:
				//			(cal_r_E | cal_i_E | lw_E | sw_E )&(Jal_M|Bgezal_M|Jalr_M)  &(IR_E[25:21]==5'b11111)?             2'b10:
					//		2'b00;
			 forwardrse=(IR_E[25:21]==writenum_M)&(writenum_M!=5'b00000)&writesig_M?2'b01:
							(IR_E[25:21]==writenum_W)&(writenum_W!=5'b00000)&writesig_W?2'b10:
							2'b00;
		  //  forwardrte=(cal_r_E|sw_E)&cal_r_M&(IR_E[20:16]==IR_M[15:11])&(IR_M[15:11]!=5'b00000)?2'b01:
			//				(cal_r_E|sw_E)&cal_i_M&(IR_E[20:16]==IR_M[20:16])&(IR_M[20:16]!=5'b00000)?2'b01:
			//				(cal_r_E|sw_E)&(Jal_M|Bgezal_M|Jalr_M)  &(IR_E[20:16]==5'b11111)?                           2'b11:
			//				(cal_r_E|sw_E)&cal_r_W&(IR_E[20:16]==IR_W[15:11])&(IR_W[15:11]!=5'b00000)?2'b10:		
				//			(cal_r_E|sw_E)&cal_i_W&(IR_E[20:16]==IR_W[20:16])&(IR_W[20:16]!=5'b00000)?2'b10:
				//			(cal_r_E|sw_E)&lw_W   &(IR_E[20:16]==IR_W[20:16])&(IR_W[20:16]!=5'b00000)?2'b10:
				//			(cal_r_E|sw_E)&(Jal_M|Bgezal_M|Jalr_M)  &(IR_E[20:16]==5'b11111)?                           2'b10:		
				//			2'b00;
			 forwardrte=(IR_E[20:16]==writenum_M)&(writenum_M!=5'b00000)&writesig_M?2'b01:
							(IR_E[20:16]==writenum_W)&(writenum_W!=5'b00000)&writesig_W?2'b10:
							2'b00;			
			 //forwardrtm=sw_M   &lw_W	&(IR_M[20:16]==IR_W[20:16])&(IR_W[20:16]!=5'b00000)?2'b01:         
				//			2'b00;
			 forwardrtm=(IR_M[20:16]==writenum_W)&(writenum_W!=5'b00000)&writesig_W?2'b01:
							2'b00;
	end
endmodule

