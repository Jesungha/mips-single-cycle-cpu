module SignExtender(BusImm, Imm26, Ctrl); 
   output reg [63:0] BusImm; 
   input [25:0]  Imm26;
   input [2:0]	Ctrl; 
   
   reg extBit; 
   always @(Ctrl, Imm26)
   begin
		case(Ctrl)
			3'b000: /* I-Type instructions */
				begin
				extBit = 0;
			    BusImm = {{52{extBit}}, Imm26[21:10]};
			    end
			3'b001: /* D-Type instructions */
				begin
				extBit = Imm26[20];
				BusImm = {{55{extBit}}, Imm26[20:12]};
				end
			3'b010: /* B instructions */
				begin
				extBit = Imm26[25];
				BusImm = {{38{extBit}}, Imm26[25:0]};
				end
			3'b011: /* CBZ instructions */
				begin
				BusImm = {6'b0,Imm26[20:5]};
				end
			3'b100: // starting here for MOVZ
			// for no ext
				begin
				extBit = 1'b0;
			    BusImm = {{48{extBit}}, {Imm26[20:5]}};
			    end
			3'b101: 
			// for ext by 4 hex
				begin
					extBit = 1'b0;
					BusImm = {{32{extBit}}, {Imm26[20:5]}, {16{extBit}}};
				end
			3'b110:
			// for ext by 8 hex
				begin
				extBit = 1'b0;
				BusImm = {{16{extBit}}, {Imm26[20:5]}, {32{extBit}}};
				end
			3'b111:
			// for ext by 12 hex
				begin
				extBit = 1'b0; 
				BusImm = {{Imm26[20:5]}, {48{extBit}}};
				end
			
		endcase
	end
endmodule



