/***************************************************************************
 *** Filename: MUX.sv				 Created by: Louis Tacata 11-09-2017 ***
 ***************************************************************************
 *** This module is a design of a scalable multiplexer. 				 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module MUX(A, B, SEL, OUT);
	parameter SIZE = 1;
	// port declarations
	input SEL;
	input [SIZE-1:0] A, B;
	output reg [SIZE-1:0] OUT;
	
	always_comb OUT = SEL ? B : A;
endmodule