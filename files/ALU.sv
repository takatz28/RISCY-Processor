/***************************************************************************
 *** Filename: ALU.sv 				 Created by: Louis Tacata 11-16-2017 ***
 ***************************************************************************
 *** The ALU performs six operations: ADD, SUB, AND, OR, XOR, and NOT. 	 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module ALU(CLK, EN, OE, OPCODE, A, B, ALU_OUT, CF, OF, SF, ZF);
	// port declarations
	parameter WIDTH = 8;
	input CLK, EN, OE;
	input [WIDTH-1:0] A, B;
	input [3:0] OPCODE; // operation select line
	output reg CF, OF, SF, ZF; // C V N Z flags
	output reg [WIDTH-1:0] ALU_OUT; // main output

	// internal signal declarations
	reg [WIDTH-1:0] ALU_TEMP; // temporary output holder
	reg [3:0] FLAGS; // flag vector [V N Z C]
	localparam OP_ADD = 4'b0010, // A + B
			   OP_SUB = 4'b0011, // A - B
			   OP_AND = 4'b0100, // A & B
			   OP_OR = 4'b0101, // A | B
			   OP_XOR = 4'b0110, // A ^ B
			   OP_NOT = 4'b0111; // ~A

	// ALU operations combinational process
	always_comb begin
		case (OPCODE)
			OP_ADD: begin
				{FLAGS[0], ALU_TEMP} = A + B; // carry flag
				FLAGS[3] = ((A[WIDTH-1] && B[WIDTH-1] && !ALU_TEMP[WIDTH-1]) || 
							(!A[WIDTH-1] && !B[WIDTH-1] && ALU_TEMP[WIDTH-1]));
				FLAGS[1] = !(|ALU_TEMP); // zero flag
				FLAGS[2] = ALU_TEMP[WIDTH-1]; // negative flag
			end
			OP_SUB: begin
				FLAGS[0] = A < B;
				ALU_TEMP = A + (~B + 1);
				FLAGS[3] = ((!A[WIDTH-1] && B[WIDTH-1] && ALU_TEMP[WIDTH-1]) || 
							(A[WIDTH-1] && !B[WIDTH-1] && !ALU_TEMP[WIDTH-1]));
				FLAGS[1] = !(|ALU_TEMP); // zero flag
				FLAGS[2] = ALU_TEMP[WIDTH-1]; // negative flag
			end
			OP_AND: begin
				ALU_TEMP = A & B;
				FLAGS[3] = OF;
				FLAGS[1] = !(|ALU_TEMP); // zero flag
				FLAGS[2] = ALU_TEMP[WIDTH-1]; // negative flag
				FLAGS[0] = CF;
			end
			OP_OR: begin
				ALU_TEMP = A | B;
				FLAGS[3] = OF;
				FLAGS[1] = !(|ALU_TEMP); // zero flag
				FLAGS[2] = ALU_TEMP[WIDTH-1]; // negative flag
				FLAGS[0] = CF;
			end
			OP_XOR: begin
				ALU_TEMP= A ^ B;
				FLAGS[3] = OF;
				FLAGS[1] = !(|ALU_TEMP); // zero flag
				FLAGS[2] = ALU_TEMP[WIDTH-1]; // negative flag
				FLAGS[0] = CF;
			end
			OP_NOT: begin
				ALU_TEMP = ~A;
				FLAGS[3] = OF;
				FLAGS[1] = !(|ALU_TEMP); // zero flag
				FLAGS[2] = ALU_TEMP[WIDTH-1]; // negative flag
				FLAGS[0] = CF;
			end
			default: begin
				ALU_TEMP = ALU_OUT;
				FLAGS = {OF, SF, ZF, CF};
			end
		endcase
	end
	
	// ALU registered output process
	always @ (posedge CLK, negedge OE) begin
		if(!EN)
			ALU_OUT <= ALU_OUT;
		else begin
			if(OE) begin
				ALU_OUT <= ALU_TEMP;
				OF <= FLAGS[3];
				SF <= FLAGS[2];
				ZF <= FLAGS[1];
				CF <= FLAGS[0];
			end
			else begin
				ALU_OUT <= 'bz;
				OF <= FLAGS[3];
				SF <= FLAGS[2];
				ZF <= FLAGS[1];
				CF <= FLAGS[0];
			end
		end
	end
endmodule