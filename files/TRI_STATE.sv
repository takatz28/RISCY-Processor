/***************************************************************************
 *** Filename: TRI_STATE.sv 		 Created by: Louis Tacata 11-16-2017 ***
 ***************************************************************************
 *** This module is a design of a scalable tri-state buffer.			 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module TRI_STATE(A, EN, X);
	// parameter definition
	parameter WIDTH = 1;
	
	// port declarations
	input [WIDTH-1:0] A;
	input EN;
	output reg [WIDTH-1:0] X;

	always_comb	X = EN ? A : 'bz;
endmodule