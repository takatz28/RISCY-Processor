/***************************************************************************
 *** Filename: RISCY_TB.sv			 Created by: Louis Tacata 12-05-2017 ***
 ***************************************************************************
 *** This module applies test stimuli to the RISC processor module. 	 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module RISCY_TB();
	parameter OUT_WIDTH = 8;
	reg CLK, RST;
	wire [OUT_WIDTH-1:0] IO;
	reg [OUT_WIDTH-1:0] DIN;
	integer i = 0;
	
	RISCY #(OUT_WIDTH) UUT(CLK, RST, IO);
	
	initial CLK = 1'b0;
	always #5 CLK = ~CLK;
	
	initial begin
	// $vcdpluson;
		$readmemh("MEMFILE.txt", UUT.MEM_SUBSYSTEM.ROM_32x32.MEM_ARRAY);
	end

	assign IO = UUT.PORT_RD ? DIN : 'bz;
	initial begin
		$display("\nThis is a testbench for the RISC processor module.");
		RST = 1'b0; DIN = 8'hAA;
		#20 RST = 1'b1;
		#1215
			$display("\nRAM contents after 32 instructions: ");
			$display("\t RAM Address | Contents ");
			$display("\t-------------+----------");
			for(i = 0; i < 4*OUT_WIDTH; i++)
				#10 $display("\t %2h | %h ", i, UUT.MEM_SUBSYSTEM.RAM_32x8.MEM_ARRAY[i]);
		$finish;
	end
endmodule