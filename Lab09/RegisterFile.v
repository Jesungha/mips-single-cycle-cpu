`timescale 1ns / 1ps

module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
    output [63:0] BusA;
    output [63:0] BusB;
    input [63:0] BusW;
    input [4:0] RW;
    input [4:0] RA;
    input [4:0] RB;
    input RegWr;
    input Clk;
    reg [31:0] registers [63:0];
	
	
	assign #2 BusA = (RA==31) ? 0 : registers[RA];
	assign #2 BusB = (RB==31) ? 0 : registers[RB];
     
    always @ (negedge Clk) begin
        if(RegWr && (RW != 31))
            registers[RW] <= #3 BusW;
            registers[31] <= #3 0; 
        $display("Ra:%d", RA);    
        $display("Rb:%d", RB);
        $display("BusA:%h", BusA);
        $display("BusB:%h", BusB);
        $display("BusW:%h", BusW);
    end
    
    
	

    

endmodule

