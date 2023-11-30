module SignExtender(BusImm, Imm26, Ctrl); 
   output reg [63:0] BusImm; 
   input [25:0]  Imm26;
   input [1:0]	Ctrl; 
   
   reg extBit; 
   always @(Ctrl, Imm26)
   begin
		case(Ctrl)
			2'b00: /* I-Type instructions */
				begin
				extBit = 0;
			    BusImm = {{52{extBit}}, Imm26[21:10]};
			    end
			2'b01: /* D-Type instructions */
				begin
				extBit = Imm26[20];
				BusImm = {{55{extBit}}, Imm26[20:12]};
				end
			2'b10: /* B instructions */
				begin
				extBit = Imm26[25];
				BusImm = {{38{extBit}}, Imm26[25:0]};
				end
			2'b11: /* CBZ instructions */
				begin
				extBit = Imm26[23]; 
				BusImm = {{45{extBit}}, Imm26[23:5]};
				end
		endcase
	end
endmodule
