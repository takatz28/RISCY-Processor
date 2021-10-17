/***************************************************************************
 *** Filename: ROM.sv 				 Created by: Louis Tacata 11-06-2017 ***
 ***************************************************************************
 *** This module is a parameterized model of a read-only memory. 		 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module ROM(ADDR, OE, CS, DATA);
	// port declarations
	parameter WIDTH = 8;
	parameter DEPTH = 5;
	input OE, CS;
	input [DEPTH-1:0] ADDR;
	output reg [WIDTH-1:0] DATA;
	
	// memory array declaration
	reg [WIDTH-1:0] MEM_ARRAY [0:2**DEPTH-1];
	
	// ROM initialization
	always_comb DATA = (OE && !CS) ? MEM_ARRAY[ADDR] : 'bz;
	
endmodule