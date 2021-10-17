/***************************************************************************
 *** Filename: PORT_DIR_REG.sv 		 Created by: Louis Tacata 11-09-2017 ***
 ***************************************************************************
 *** This module is a register design with a reset port. 				 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module PORT_DIR_REG(CLK, RST, EN, DIN, DOUT);
	// port declarations
	parameter WIDTH = 1;
	input CLK, RST, EN;
	input [WIDTH-1:0] DIN;
	output reg [WIDTH-1:0] DOUT;

	// register behavioral model
	always_ff @ (posedge CLK, posedge EN, negedge RST) begin
		if(!RST)
			DOUT <= 'b0;
		else
			if(EN)
				DOUT <= DIN;
			else
				DOUT <= DOUT;
	end
endmodule