/***************************************************************************
 *** Filename: MEMORY_SUB.sv 		 Created by: Louis Tacata 11-16-2017 ***
 ***************************************************************************
 *** The memory subsystem consists of the following modules:			 ***
 *** - program counter - 32-bit memory instruction register (IR)		 ***
 *** - 32 x 32 ROM - 8-bit RAM data register (RDR) 						 ***
 *** - 32 x 8 RAM														 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module MEMORY_SUB(ADDR, ROM_CS, ROM_OE, LOAD_EN, PC_EN, RST, IR_EN,
				  RAM_CS, RAM_OE, CLK, ALU_DATA, PORT_READ_DATA, RDR_EN,
				  OPCODE, I_FLAG, ADDR_OUT, ROM_DATA, RAM_DATA);
	// parameter declarations
	parameter ROM_WIDTH = 32;
	parameter RAM_WIDTH = 8;
	parameter DEPTH = 5;

	// ROM, counter, and IR ports
	input ROM_CS, ROM_OE, LOAD_EN, PC_EN, RST, IR_EN;
	input [DEPTH-1:0] ADDR;
	output reg [3:0] OPCODE;
	output reg I_FLAG;
	output reg [6:0] ADDR_OUT;
	output reg [7:0] ROM_DATA;
	
	// RAM and RDR ports
	input RAM_CS, RAM_OE, CLK, RDR_EN;
	input [RAM_WIDTH-1:0] ALU_DATA, PORT_READ_DATA;
	output [RAM_WIDTH-1:0] RAM_DATA;
	
	// internal signal declarations
	reg [DEPTH-1:0] CNT_OUT;
	reg [ROM_WIDTH-1:0] ROM_TEMP, IR_OUT;
	reg [RAM_WIDTH-1:0] RAM_WRITE, RDR_IN;
	wire [RAM_WIDTH-1:0] RAM_TEMP;
	
	// ROM, counter, and IR instantiation
	PROG_CNTR #(.WIDTH(DEPTH)) ADDR_CNTR(.DATA(ADDR), .CLOCK(CLK), 
				.RESET(RST), .ENABLE(PC_EN), .LOAD(LOAD_EN), 
				.COUNT(CNT_OUT));
	
	ROM #(.WIDTH(ROM_WIDTH), .DEPTH(DEPTH)) ROM_32x32(.ADDR(CNT_OUT), 
		  .OE(ROM_OE), .CS(ROM_CS), .DATA(ROM_TEMP));
	
	REGISTER #(.WIDTH(ROM_WIDTH)) MIR(.CLK(CLK), .DIN(ROM_TEMP), 
			   .EN(IR_EN), .DOUT(IR_OUT));
	
	// RAM and RDR instantiations
	RAM #(.WIDTH(RAM_WIDTH), .DEPTH(DEPTH)) RAM_32x8(.ADDR(ROM_TEMP[4:0]), 
		  .OE(RAM_OE), .WS(CLK), .CS(RAM_CS), .DATA(RAM_TEMP));
	
	REGISTER #(.WIDTH(RAM_WIDTH)) RDR(.CLK(CLK), .DIN(RAM_TEMP), 
			   .EN(RDR_EN), .DOUT(RAM_DATA));
	
	// store operation data selection
	assign RAM_TEMP = (!RAM_CS && !RAM_OE) ? RAM_WRITE : 'bz;
	always_ff @ (posedge CLK) begin
		if(OPCODE == 1) begin
			if(IR_OUT[26:20] == 67)
				RAM_WRITE <= PORT_READ_DATA;
			else
				RAM_WRITE <= ALU_DATA;
			end
		else
			RAM_WRITE <= ALU_DATA;
	end
	
	// instruction address output mapping
	always_comb begin
		RDR_IN = RAM_TEMP;
		OPCODE = IR_OUT[31:28];
		I_FLAG = IR_OUT[27];
		ADDR_OUT = IR_OUT[26:20];
		ROM_DATA = IR_OUT[7:0];
	end
endmodule