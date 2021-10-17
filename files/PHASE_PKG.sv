/***************************************************************************
 *** Filename: PHASE_PKG.sv 		 Created by: Louis Tacata 11-16-2017 ***
 ***************************************************************************
 *** This module enables the CYCLES enumerated type to be outputs. 		 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
package PHASE_PKG;
	// enumerated type definition
	typedef enum reg [1:0] {FETCH = 2'b00, DECODE, EXECUTE, UPDATE} CYCLES;
endpackage