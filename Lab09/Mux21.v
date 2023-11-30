module Mux21(out, in, sel);
	input [1:0] in;
	input sel;
	output out;
	
	wire Wire1, Wire2, Wire3;
	
	nand Not1(Wire2, sel, sel); //Not gate using the NAND gate
	and And1(Wire1, in[0], Wire2); //First input for OR Gate
	and And2(Wire3, in[1], sel); //Second input for OR gate
	or Or1(out, Wire1, Wire3);
	
endmodule
