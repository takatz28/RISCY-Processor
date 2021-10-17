/***************************************************************************
 *** Filename: PHASER.sv 			 Created by: Louis Tacata 11-16-2017 ***
 ***************************************************************************
 *** This module is a phase generator block in which two periodic sig-	 ***
 *** nals are produced using enumerated types. 							 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns

// import package for enum outputs
import PHASE_PKG::*;

module PHASER(CLK, RST, EN, PHASE);
	// port declarations
	input CLK, RST, EN;
	output CYCLES PHASE;

	always_ff @ (posedge CLK, negedge RST, negedge EN) begin
		if (!RST)
			PHASE <= PHASE.first();
		else if(!EN)
			PHASE <= PHASE.next();
		else
			PHASE <= PHASE;
	end
endmodule