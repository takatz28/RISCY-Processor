/***************************************************************************
 *** Filename: PROG_CNTR.sv 		 Created by: Louis Tacata 11-09-2017 ***
 ***************************************************************************
 *** This module is a design of a scalable counter. 					 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module PROG_CNTR(DATA, CLOCK, RESET, ENABLE, LOAD, COUNT);
	// port declarations
	parameter WIDTH = 5;
	input [WIDTH-1:0] DATA;
	input CLOCK, RESET, ENABLE, LOAD;
	output reg [WIDTH-1:0] COUNT;

	// behavioral description
	always_ff @ (posedge CLOCK, negedge RESET)
		// reset is asserted
		if(!RESET)
			COUNT <= 'b0;
		else if(ENABLE) begin
			// define load function
			if (LOAD)
				COUNT <= DATA;
			// if load = 0, start counting
			else
				COUNT <= COUNT + 1;
		end
endmodule