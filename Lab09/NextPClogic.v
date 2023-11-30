`timescale 1ns / 1ps
module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 
   input [63:0] CurrentPC, SignExtImm64; 
   input 	Branch, ALUZero, Uncondbranch; 
   output reg [63:0] NextPC; 
   wire [63:0] Tmpimm;
	assign Tmpimm = SignExtImm64 << 2;
   always @(*)
		begin
		if(Uncondbranch) begin
			NextPC <= CurrentPC + Tmpimm;
		end else if (Branch) begin
			if (ALUZero) begin
				NextPC <= CurrentPC + Tmpimm;
			end else begin
				NextPC <= CurrentPC + 4;
			end
		end else begin
			NextPC <= CurrentPC + 4;
		end
	end

endmodule
