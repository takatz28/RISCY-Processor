/***************************************************************************
 *** Filename: SEQ_CONTROLLER.sv 	 Created by: Louis Tacata 12-03-2017 ***
 ***************************************************************************
 *** This module is a design of a sequence controller. 					 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
// import CYCLES enumerated type
import PHASE_PKG::*;
module SEQ_CONTROLLER(ADDR, OPCODE, PHASE, OF, SF, ZF, CF, 
	I_FLAG, IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, 
	PC_EN, PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS);

	// port declarations
	input [6:0] ADDR;
	input [3:0] OPCODE;
	input CYCLES PHASE; // enumerated type input
	input I_FLAG, OF, SF, ZF, CF;
	output reg IR_EN, // enables instruction reg. write
			   A_EN, // enables ALU A reg. write
			   B_EN, // enables ALU B reg. write
			   PDR_EN, // port direction reg. write enable
			   PORT_EN, // port data reg. write enable
			   PORT_RD, // port input data read enable
			   PC_EN, // PC reg update enable
			   PC_LOAD, // PC parallel load enable, PC_EM must be 1
			   ALU_EN, // ALU master enable
			   ALU_OE, // ALU output enable
			   RAM_OE, // RAM output enable
			   RDR_EN, // RAM write enable
			   RAM_CS; // RAM chip select (active low)

	// instruction set paarameters
	localparam LOAD = 4'b0000, // load register
			   STORE = 4'b0001, // store ALU output
			   ADD = 4'b0010, // A + B
			   SUB = 4'b0011, // A + ~B + 1
			   AND = 4'b0100, // A & B
			   OR = 4'b0101, // A | B
			   XOR = 4'b0110, // A ^ B
			   NOT = 4'b0111, // ~A
			   B = 4'b1000, // unconditional branch
			   BZ = 4'b1001, // branch if Z = 1
			   BN = 4'b1010, // branch if N = 1
			   BV = 4'b1011, // branch if V = 1
			   BC = 4'b1100; // branch if C = 1
	
	// sequence controller process
	always_comb begin
		case(PHASE)
			/* Fetch cycle: Instruction register is enabled;
			memory is also enabled and its outputs enabled. */
			FETCH: begin
				// enabled signal
				IR_EN = 1'b1;
				// disabled signals
				A_EN = 1'b0; 
				B_EN = 1'b0; 
				PDR_EN = 1'b0;
				PORT_EN = 1'b0; 
				PORT_RD = 1'b0; 
				PC_EN = 1'b0;
				PC_LOAD = 1'b0; 
				ALU_EN = 1'b0; 
				ALU_OE = 1'b0;
				RAM_OE = 1'b0; 
				RDR_EN = 1'b0; 
				RAM_CS = 1'b1;
			end
			/* Decode cycle: Reads and decodes the values
			received from the memory instruction register. */
			DECODE: begin
				// load instruction
				if (OPCODE == LOAD) begin
					if(I_FLAG) begin
						// enabled signals
						if (ADDR == 64) // ALU A register
							A_EN = 1'b1;
						else
							A_EN = 1'b0;
						if (ADDR == 65) // ALU B register
							B_EN = 1'b1;
						else
							B_EN = 1'b0;
						if (ADDR == 66) // port direction register
							PDR_EN = 1'b1;
						else
							PDR_EN = 1'b0;
						if (ADDR == 67) // I/O port
							PORT_EN = 1'b1;
						else
							PORT_EN = 1'b0;
						// disabled signals
						IR_EN = 1'b0; 
						PORT_RD = 1'b0;
						PC_EN = 1'b0; 
						PC_LOAD = 1'b0; 
						ALU_EN = 1'b0; 
						ALU_OE = 1'b0;
						RAM_OE = 1'b0; 
						RDR_EN = 1'b0;
						RAM_CS = 1'b1;
					end
					else begin
						// enabled signals
						RAM_OE = 1'b1;
						RDR_EN = 1'b1;
						RAM_CS = 1'b0;
						if (ADDR == 64) // ALU A register
							A_EN = 1'b1;
						else
							A_EN = 1'b0;
						if (ADDR == 65) // ALU B register
						B_EN = 1'b1;
						else
						B_EN = 1'b0;
						if (ADDR == 66) // port direction register
							PDR_EN = 1'b1;
						else
							PDR_EN = 1'b0;
						if (ADDR == 67) // I/O port
							PORT_EN = 1'b1;
						else
							PORT_EN = 1'b0;
						// disabled signals
						IR_EN = 1'b0; 
						PORT_RD = 1'b0;
						PC_EN = 1'b0; 
						PC_LOAD = 1'b0; 
						ALU_EN = 1'b0; 
						ALU_OE = 1'b0;
					end
				end
				// store instruction
				else if (OPCODE == STORE) begin
					if (ADDR != 67) begin // store port read data
						// enabled signal
						ALU_OE = 1'b1;
						RAM_CS = 1'b0;
						// disabled signals
						IR_EN = 1'b0; 
						A_EN = 1'b0;
						B_EN = 1'b0; 
						PDR_EN = 1'b0; 
						PORT_EN = 1'b0; 
						PORT_RD = 1'b0;
						PC_EN = 1'b0; 
						PC_LOAD = 1'b0; 
						ALU_EN = 1'b0; 
						RAM_OE = 1'b0; 
						RDR_EN = 1'b0;
					end
					else begin // store ALU data
						// enabled signal
						PORT_RD = 1'b1;
						RAM_CS = 1'b0;
						// disabled signals
						IR_EN = 1'b0; 
						A_EN = 1'b0;
						B_EN = 1'b0; 
						PDR_EN = 1'b0; 
						PORT_EN = 1'b0; 
						PC_EN = 1'b0;
						PC_LOAD = 1'b0; 
						ALU_EN = 1'b0; 
						ALU_OE = 1'b0; 
						RAM_OE = 1'b0; 
						RDR_EN = 1'b0;
					end
				end
				else if ((OPCODE == ADD) || (OPCODE == SUB) ||
						 (OPCODE == AND) || (OPCODE == OR) || 
						 (OPCODE == XOR) || (OPCODE == NOT)) begin
					// enabled signal
					ALU_EN = 1'b1;
					ALU_OE = 1'b1;
					// disabled signals
					IR_EN = 1'b0; 
					A_EN = 1'b0;
					B_EN = 1'b0; 
					PDR_EN = 1'b0;
					PORT_EN = 1'b0; 
					PORT_RD = 1'b0;
					PC_EN = 1'b0;
					PC_LOAD = 1'b0;
					RAM_OE = 1'b0; 
					RDR_EN = 1'b0;
					RAM_CS = 1'b1;
				end
				// other instructions
				else begin
					IR_EN = 1'b0; 
					A_EN = 1'b0;
					B_EN = 1'b0;
					PDR_EN = 1'b0;
					PORT_EN = 1'b0; 
					PORT_RD = 1'b0;
					PC_EN = 1'b0; 
					PC_LOAD = 1'b0;
					ALU_EN = 1'b0; 
					ALU_OE = 1'b0;
					RAM_OE = 1'b0; 
					RDR_EN = 1'b0;
					RAM_CS = 1'b1;
				end
			end
			/* Execute cycle: Executes instructions based on opcode. */
			EXECUTE: begin
				// load instruction
				if (OPCODE == LOAD) begin
					if(I_FLAG) begin
						// enabled signals
						if (ADDR == 64) // ALU A register
							A_EN = 1'b1;
						else
							A_EN = 1'b0;
						if (ADDR == 65) // ALU B register
							B_EN = 1'b1;
						else
							B_EN = 1'b0;
						if (ADDR == 66) // port direction register
							PDR_EN = 1'b1;
						else
							PDR_EN = 1'b0;
						if (ADDR == 67) // I/O port
							PORT_EN = 1'b1;
						else
						PORT_EN = 1'b0;
						// disabled signals
						IR_EN = 1'b0; 
						PORT_RD = 1'b0;
						PC_EN = 1'b0; 
						PC_LOAD = 1'b0; 
						ALU_EN = 1'b0; 
						ALU_OE = 1'b0;
						RAM_OE = 1'b0; 
						RDR_EN = 1'b0;
						RAM_CS = 1'b1;
					end
					else begin
						// enabled signals
						RAM_OE = 1'b1;
						RDR_EN = 1'b1;
						RAM_CS = 1'b0;
						if (ADDR == 64) // ALU A register
							A_EN = 1'b1;
						else
							A_EN = 1'b0;
						if (ADDR == 65) // ALU B register
							B_EN = 1'b1;
						else
							B_EN = 1'b0;
						if (ADDR == 66) // port direction register
							PDR_EN = 1'b1;
						else
							PDR_EN = 1'b0;
						if (ADDR == 67) // I/O port
							PORT_EN = 1'b1;
						else
							PORT_EN = 1'b0;
							// disabled signals
							IR_EN = 1'b0; 
							PORT_RD = 1'b0;
							PC_EN = 1'b0; 
							PC_LOAD = 1'b0; 
							ALU_EN = 1'b0; 
							ALU_OE = 1'b0;
					end
				end
				// store instruction
				else if (OPCODE == STORE) begin
					if (ADDR != 67) begin // store port read data
						// enabled signal
						ALU_OE = 1'b1;
						RAM_CS = 1'b0;
						// disabled signals
						IR_EN = 1'b0;
						A_EN = 1'b0;
						B_EN = 1'b0; 
						PDR_EN = 1'b0;
						PORT_EN = 1'b0; 
						PORT_RD = 1'b0;
						PC_EN = 1'b0;
						PC_LOAD = 1'b0;
						ALU_EN = 1'b0; 
						RAM_OE = 1'b0;
						RDR_EN = 1'b0;
					end
					else begin // store ALU data
						// enabled signal
						PORT_RD = 1'b1;
						RAM_CS = 1'b0;
						// disabled signals
						IR_EN = 1'b0; 
						A_EN = 1'b0;
						B_EN = 1'b0; 
						PDR_EN = 1'b0;
						PORT_EN = 1'b0;
						PC_EN = 1'b0;
						PC_LOAD = 1'b0; 
						ALU_EN = 1'b0;
						ALU_OE = 1'b0; 
						RAM_OE = 1'b0;
						RDR_EN = 1'b0;
						end
					end
				else if ((OPCODE == ADD) || (OPCODE == SUB) ||
						 (OPCODE == AND) || (OPCODE == OR) || 
						 (OPCODE == XOR) || (OPCODE == NOT)) begin
					// enabled signal
					ALU_EN = 1'b1;
					ALU_OE = 1'b1;
					// disabled signals
					IR_EN = 1'b0; 
					A_EN = 1'b0;
					B_EN = 1'b0; 
					PDR_EN = 1'b0;
					PORT_EN = 1'b0; 
					PORT_RD = 1'b0;
					PC_EN = 1'b0; 
					PC_LOAD = 1'b0;
					RAM_OE = 1'b0; 
					RDR_EN = 1'b0;
					RAM_CS = 1'b1;
				end
				// unspecified instructions
				else begin
					IR_EN = 1'b0; 
					A_EN = 1'b0;
					B_EN = 1'b0; 
					PDR_EN = 1'b0;
					PORT_EN = 1'b0; 
					PORT_RD = 1'b0;
					PC_EN = 1'b0; 
					PC_LOAD = 1'b0;
					ALU_EN = 1'b0; 
					ALU_OE = 1'b0;
					RAM_OE = 1'b0; 
					RDR_EN = 1'b0;
					RAM_CS = 1'b1;
				end
			end
			/* Update cycle: Program counter is updated */
			UPDATE: begin
				// enabled signals
				PC_EN = 1'b1;
				if ((OPCODE == B) || ((OPCODE == BZ) && ZF) ||
					((OPCODE == BN) && SF) || ((OPCODE == BV) && OF) || 
					((OPCODE == BC) && CF))
					PC_LOAD = 1'b1;
				else
					PC_LOAD = 1'b0;
					// disabled signals
					IR_EN = 1'b0; 
					A_EN = 1'b0; 
					B_EN = 1'b0;
					PDR_EN = 1'b0; 
					PORT_EN = 1'b0; 
					PORT_RD = 1'b0;
					ALU_EN = 1'b0; 
					ALU_OE = 1'b0; 
					RAM_OE = 1'b0;
					RDR_EN = 1'b0; 
					RAM_CS = 1'b1;
			end
			/* Default case: Never reached, but prevents errors
			and latch generation. */
			default: begin
				IR_EN = 1'b0; 
				A_EN = 1'b0; 
				B_EN = 1'b0;
				PDR_EN = 1'b0; 
				PORT_EN = 1'b0; 
				PORT_RD = 1'b0;
				PC_EN = 1'b0; 
				PC_LOAD = 1'b0;
				ALU_EN = 1'b0;
				ALU_OE = 1'b0; 
				RAM_OE = 1'b0; 
				RDR_EN = 1'b0;
				RAM_CS = 1'b1;
			end
		endcase
	end
endmodule