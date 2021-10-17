/***************************************************************************
 *** Filename: IO_SUB.sv			 Created by: Louis Tacata 11-16-2017 ***
 ***************************************************************************
 *** The IO subsystem consists of the following modules: 				 ***
 *** - 1-bit port direction register									 ***
 *** - 8-bit port data register											 ***
 *** - 1-bit and 8-bit tri-state buffers								 ***
***************************************************************************/
`timescale 1 ns / 1 ns
module IO_SUB(DATA_0, PDR_EN, CLK, RST, DATA, PORT_EN, PORT_RD, 
			  PORT_READ_DATA, IO);
	// parameter definition
	parameter DATA_WIDTH = 1;
	parameter DIR_WIDTH = 8;
	
	// port declarations
	input DATA_0, PDR_EN, CLK, RST, PORT_EN, PORT_RD;
	input [DIR_WIDTH-1:0] DATA;
	output reg [DIR_WIDTH-1:0] PORT_READ_DATA;
	inout wire [DIR_WIDTH-1:0] IO;
	
	// internal signal declarations
	reg DIR_OUT;
	reg [DIR_WIDTH-1:0] DATA_OUT, TRI1_OUT, TRI2_IN;
	
	// module instantiations
	PORT_DIR_REG #(.WIDTH(DATA_WIDTH)) DIR_REG(.CLK(CLK), .RST(RST), 
				   .EN(PDR_EN), .DIN(DATA_0), .DOUT(DIR_OUT));
	
	REGISTER #(.WIDTH(DIR_WIDTH)) DATA_REG(.CLK(CLK), .DIN(DATA), 
			   .EN(PORT_EN), .DOUT(DATA_OUT));
	
	TRI_STATE #(.WIDTH(DIR_WIDTH)) TRI1(.A(DATA_OUT), .EN(DIR_OUT), 
				.X(TRI1_OUT));
	
	TRI_STATE #(.WIDTH(DIR_WIDTH)) TRI2(.A(TRI2_IN), .EN(PORT_RD), 
				.X(PORT_READ_DATA));
	
	// I/O assignments
	assign IO = (DIR_OUT && !PORT_RD) ? TRI1_OUT :
				 (!DIR_OUT && PORT_RD) ? TRI2_IN : 
				 'bz;
	always_comb TRI2_IN = IO;
endmodule