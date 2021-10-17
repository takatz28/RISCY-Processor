/***************************************************************************
 *** Filename: ALU_SUB.sv 			 Created by: Louis Tacata 11-16-2017 ***
 ***************************************************************************
 *** The ALU subsystem consists of the following modules: 				 ***
 *** - 8-bit A and B registers											 ***
 *** - ALU module														 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module ALU_SUB(DATA, A_EN, B_EN, CLK, ALU_EN, ALU_OE, 
			   OPCODE, OF, SF, ZF, CF, ALU_DATA);
	// parameter definition
	parameter WIDTH = 8;
	// port declarations
	input [WIDTH-1:0] DATA;
	input [3:0] OPCODE;
	input A_EN, B_EN, CLK, ALU_EN, ALU_OE;
	output reg OF, SF, ZF, CF;
	output reg [WIDTH-1:0] ALU_DATA;

	// internal signal declaration
	reg [WIDTH-1:0] A_OUT, B_OUT;

	// module instantiations
	REGISTER #(.WIDTH(WIDTH)) A_REG(.CLK(CLK), .DIN(DATA), .EN(A_EN), 
			   .DOUT(A_OUT));

	REGISTER #(.WIDTH(WIDTH)) B_REG(.CLK(CLK), .DIN(DATA), .EN(B_EN), 
			   .DOUT(B_OUT));

	ALU #(.WIDTH(WIDTH)) ALU_MOD(.CLK(CLK), .EN(ALU_EN), .OE(ALU_OE), 
		  .OPCODE(OPCODE), .A(A_OUT), .B(B_OUT), .ALU_OUT(ALU_DATA), 
		  .CF(CF), .OF(OF), .SF(SF), .ZF(ZF));
endmodule