/***************************************************************************
 *** Filename: RAM.sv				 Created by: Louis Tacata 11-06-2017 ***
 ***************************************************************************
 *** This module is a parameterized model of a register file-based RAM. ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module RAM(ADDR, OE, WS, CS, DATA);
	// port declarations
	parameter WIDTH = 8;
	parameter DEPTH = 5;
	input OE, CS, WS;
	input [DEPTH-1:0] ADDR;
	inout [WIDTH-1:0] DATA;

	// internal signal declarations
	reg [WIDTH-1:0] MEM_ARRAY [0:2**DEPTH-1];
	wire [WIDTH-1:0] DIN;
	wire [WIDTH-1:0] DATA;

	// read process
	assign DATA = (OE && !CS) ? MEM_ARRAY[ADDR] : 'bz;

	// write process
	assign DIN = (!OE && !CS) ? DATA : 'bz;
	always_ff @ (posedge WS) begin
		if(!CS)
			MEM_ARRAY[ADDR] <= DIN;
		else
			MEM_ARRAY[ADDR] <= MEM_ARRAY[ADDR];
	end
endmodule