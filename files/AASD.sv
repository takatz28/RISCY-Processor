/***************************************************************************
 *** Filename: AASD.sv 				 Created by: Louis Tacata 11-09-2017 ***
 ***************************************************************************
 *** This module is a design of the asynchronous assert, synchronous de- ***
 *** assert function (AASD). 											 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module AASD(RESET_OUT, CLOCK, RESET_IN);
	// port declarations
	input CLOCK, RESET_IN;
	output reg RESET_OUT;

	reg R_TEMP;

	always_ff @ (posedge CLOCK, negedge RESET_IN) begin
		if (!RESET_IN) begin
			R_TEMP <= 1'b0;
			RESET_OUT <= 1'b0;
		end
		else begin
			R_TEMP <= 1'b1;
			RESET_OUT <= R_TEMP;
		end
	end
endmodule