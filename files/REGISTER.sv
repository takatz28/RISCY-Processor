/***************************************************************************
 *** Filename: REGISTER.sv 			 Created by: Louis Tacata 11-09-2017 ***
 ***************************************************************************
 *** This module is a register design with no reset port. 				 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module REGISTER(CLK, DIN, EN, DOUT);
	// port declarations
	parameter WIDTH = 1;
	input CLK, EN;
	input [WIDTH-1:0] DIN;
	output reg [WIDTH-1:0] DOUT;
	
	// register behavioral model
	always_ff @ (posedge CLK or posedge EN) begin
	if(EN)
		DOUT <= DIN;
	else
		DOUT <= DOUT;
	end
endmodule