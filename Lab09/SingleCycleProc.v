
module singlecycle(
		   input 	     resetl,
		   input [63:0]      startpc,
		   output reg [63:0] currentpc,
		   output [63:0]     MemtoRegOut,  // this should be
						   // attached to the
						   // output of the
						   // MemtoReg Mux
		   input 	     CLK
		   );

   // Next PC connections
   wire [63:0] 			     nextpc;       // The next PC, to be updated on clock cycle

   // Instruction Memory connections
   wire [31:0] 			     instruction;  // The current instruction

   // Parts of instruction
   wire [4:0] 			     rd;            // The destination register
   wire [4:0] 			     rm;            // Operand 1
   wire [4:0] 			     rn;            // Operand 2
   wire [10:0] 			     opcode;
   
   //Added wires for MUXes
   wire [63:0]				 MuxToAlu;

   // Control wires
   wire 			     reg2loc;
   wire 			     alusrc;
   wire 			     mem2reg;
   wire 			     regwrite;
   wire 			     memread;
   wire 			     memwrite;
   wire 			     branch;
   wire 			     uncond_branch;
   wire [3:0] 			     aluctrl;
   wire [1:0] 			     signop;

   // Register file connections
   wire [63:0] 			     regoutA;     // Output A
   wire [63:0] 			     regoutB;     // Output B
   // ALU connections
   wire [63:0] 			     aluout;
   wire 			     zero;
   //2nd ALU
   wire [63:0]               Mux2Alu;

   // Sign Extender connections
   wire [63:0] 			     extimm;
   
   //Data Memory connection
   wire [63:0]				extmem;
   
   //Wire
   wire 					andout;
   wire						orout;
   wire[63:0]				ALUout2;
		

   // PC update logic




   InstructionMemory imem(
			  .Data(instruction),
			  .Address(currentpc)
			  );
			  
			  
	NextPClogic NPC(
		.NextPC(nextpc),
		.CurrentPC(currentpc),
		.SignExtImm64(extimm),
		.Branch(branch),
		.ALUZero(zero),
		.Uncondbranch(uncond_branch)
	);
	   always @(negedge CLK)
     begin
        if (resetl)
          currentpc <= #3 nextpc;
        else
          currentpc <= #3 startpc;
     end


   control control(
		   .reg2loc(reg2loc),
		   .alusrc(alusrc),
		   .mem2reg(mem2reg),
		   .regwrite(regwrite),
		   .memread(memread),
		   .memwrite(memwrite),
		   .branch(branch),
		   .uncond_branch(uncond_branch),
		   .aluop(aluctrl),
		   .signop(signop),
		   .opcode(opcode)
		   );
		   
   // Parts of instruction
   assign #2 rd = instruction[4:0];
   assign #2 rm = instruction[9:5];
   assign #2 rn = reg2loc ? instruction[4:0] : instruction[20:16];
   assign #2 opcode = instruction[31:21];
		   
	RegisterFile regFile(
			.RA(rm),
			.RB(rn),
			.RW(rd),
			.BusW(MemtoRegOut),
			.RegWr(regwrite),
			.Clk(CLK),
			.BusA(regoutA),
			.BusB(regoutB)
			);
			
			
	SignExtender SignExtend(
			.Imm26(instruction[25:0]),
			.BusImm(extimm),
			.Ctrl(signop)
			);
			
	//MuxToALU wire
	assign #2 MuxToAlu = alusrc ? extimm : regoutB;
			
	ALU ArithmeticUnit(
			.BusA(regoutA),
			.BusB(Mux2Alu),
			.BusW(aluout),
			.ALUCtrl(aluctrl),
			.Zero(zero)
			);
			
	DataMemory dmem(
		.ReadData(extmem),
		.Address(aluout),
		.WriteData(regoutB),
		.MemoryRead(memread),
		.MemoryWrite(memwrite),
		.Clock(CLK)
		);
			
   //Mux
   assign #2 MemtoRegOut = mem2reg ?  extmem : aluout; //Added
	
	


   /*
    * Connect the remaining datapath elements below.
    * Do not forget any additional multiplexers that may be required.
    */



endmodule

