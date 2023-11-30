`define AND   4'b0000
`define OR    4'b0001
`define ADD   4'b0010
`define SUB   4'b0110
`define PassB 4'b0111

module ALU(BusW, BusA, BusB, ALUCtrl, Zero);
    
    output  [63:0] BusW;
    input   [63:0] BusA, BusB;
    input   [3:0] ALUCtrl;
    output  Zero;
    
    reg     [63:0] BusW;
    
    always @(ALUCtrl or BusA or BusB) begin
        case(ALUCtrl)
            4'b0000: begin /* AND */
                BusW = BusA & BusB;
            end
            4'b0001: begin /* OR */
				BusW = BusA | BusB;
			end
			4'b0010: begin /*ADD */
				BusW = BusA + BusB;
			end
			4'b0110: begin /* SUB */
				BusW = BusA - BusB;
			end
			4'b0111: begin /*PassB */
				BusW = BusB;
			end
			
        endcase
        //$display("BusW:%h", BusW);
    end
	
    assign Zero = (BusW ? 0 : 1);
endmodule
