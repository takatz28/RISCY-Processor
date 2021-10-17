/***************************************************************************
 *** Filename: RISCY.sv 			 Created by: Louis Tacata 11-20-2017 ***
 ***************************************************************************
 *** This module is a design of the RISC_Y central processing unit. 	 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
// import package
import PHASE_PKG::*;
module RISCY(CLK, RST, IO);
	// parameter declaration
	parameter OUT_WIDTH = 8;
	// port declarations
	input CLK, RST;
	inout wire [OUT_WIDTH-1:0] IO;

	// internal signal declarations
	reg AASD_RST;
	// sequence controller signals
	wire [6:0] ADDR;
	wire [3:0] OPCODE;
	wire CYCLES PHASE; // enumerated type input
	wire I_FLAG, OF, SF, ZF, CF;
	wire IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN, 
		 PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS;
	// Memory subsystem signals
	wire [OUT_WIDTH-1:0] ROM_DATA, RAM_DATA;
	// ALU subsystem signals
	wire [OUT_WIDTH-1:0] ALU_DATA;
	// I/O subsystem signals
	wire [OUT_WIDTH-1:0] PORT_READ_DATA;
	// Memory to data bus subsystem signals
	wire [OUT_WIDTH-1:0] DATA;

	// controller instantiation
	AASD MSTR_RST(.RESET_OUT(AASD_RST), .CLOCK(CLK), .RESET_IN(RST));
	
	PHASER PHASE_GEN(.CLK(CLK), .RST(AASD_RST), .EN(1'b0), .PHASE(PHASE));
	
	SEQ_CONTROLLER CTRL_UNIT(.ADDR(ADDR), .OPCODE(OPCODE), .PHASE(PHASE), 
							 .OF(OF), .SF(SF), .ZF(ZF), .CF(CF), 
							 .I_FLAG(I_FLAG), .IR_EN(IR_EN), .A_EN(A_EN), 
							 .B_EN(B_EN), .PDR_EN(PDR_EN), .PORT_EN(PORT_EN),
							 .PORT_RD(PORT_RD), .PC_EN(PC_EN), 
							 .PC_LOAD(PC_LOAD), .ALU_EN(ALU_EN), 
							 .ALU_OE(ALU_OE), .RAM_OE(RAM_OE),
							 .RDR_EN(RDR_EN), .RAM_CS(RAM_CS));

	// I/O instantiation
	IO_SUB IO_SUBSYSTEM(.DATA_0(DATA[0]), .PDR_EN(PDR_EN), .CLK(CLK), 
						.RST(AASD_RST), .DATA(DATA), .PORT_EN(PORT_EN), 
						.PORT_RD(PORT_RD), .PORT_READ_DATA(PORT_READ_DATA), 
						.IO(IO));

	// memory instantiation
	MEMORY_SUB MEM_SUBSYSTEM(.ADDR(ADDR[4:0]), .ROM_CS(1'b0), .ROM_OE(1'b1), 
							 .LOAD_EN(PC_LOAD), .PC_EN(PC_EN), .RST(AASD_RST), 
							 .IR_EN(IR_EN), .RAM_CS(RAM_CS), .RAM_OE(RAM_OE),
							 .CLK(CLK), .ALU_DATA(ALU_DATA), .RDR_EN(RDR_EN), 
							 .PORT_READ_DATA(PORT_READ_DATA), .OPCODE(OPCODE), 
							 .I_FLAG(I_FLAG), .ADDR_OUT(ADDR), 
							 .ROM_DATA(ROM_DATA), .RAM_DATA(RAM_DATA));

	// MUX instantiation
	MUX #(.SIZE(OUT_WIDTH)) MEM2DBUS_SUBSYSTEM(.A(ROM_DATA), .B(RAM_DATA), 
		  .SEL(RAM_OE), .OUT(DATA));

	// ALU instantiation
	ALU_SUB ALU_SUBSYSTEM(.DATA(DATA), .A_EN(A_EN), .B_EN(B_EN), 
						  .CLK(CLK), .ALU_EN(ALU_EN), .ALU_OE(ALU_OE), 
						  .OPCODE(OPCODE), .OF(OF), .SF(SF), .ZF(ZF), 
						  .CF(CF), .ALU_DATA(ALU_DATA));
endmodule