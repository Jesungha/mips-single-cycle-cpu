  `timescale 1ns / 1ps
/*
 * Module: InstructionMemory
 *
 * Implements read-only instruction memory
 * 
 */
module InstructionMemory (
    Data,
    Address
);
  parameter T_rd = 20;
  parameter MemSize = 40;

  output [31:0] Data;
  input [63:0] Address;
  reg [31:0] Data;

  /*
    * ECEN 350 Processor Test Functions
    * Texas A&M University
    */

  always @(Address) begin

    case (Address)

      /* Test Program 1:
	 * Program loads constants from the data memory. Uses these constants to test
	 * the following instructions: LDUR, ORR, AND, CBZ, ADD, SUB, STUR and B.
	 * 
	 * Assembly code for test:
	 * 
	 * 0: LDUR X9, [XZR, 0x0]    //Load 1 into x9
	 * 4: LDUR X10, [XZR, 0x8]   //Load a into x10
	 * 8: LDUR X11, [XZR, 0x10]  //Load 5 into x11
	 * C: LDUR X12, [XZR, 0x18]  //Load big constant into x12
	 * 10: LDUR X13, [XZR, 0x20]  //load a 0 into X13
	 * 
	 * 14: ORR X10, X10, X11  //Create mask of 0xf
	 * 18: AND X12, X12, X10  //Mask off low order bits of big constant
	 * 
	 * loop:
	 * 1C: CBZ X12, end  //while X12 is not 0
	 * 20: ADD X13, X13, X9  //Increment counter in X13
	 * 24: SUB X12, X12, X9  //Decrement remainder of big constant in X12
	 * 28: B loop  //Repeat till X12 is 0
	 * 2C: STUR X13, [XZR, 0x20]  //store back the counter value into the memory location 0x20
	 */


      /*63'h000: Data = 32'hF84003E9;
      63'h004: Data = 32'hF84083EA;
      63'h008: Data = 32'hF84103EB;
      63'h00c: Data = 32'hF84183EC;
      63'h010: Data = 32'hF84203ED;
      63'h014: Data = 32'hAA0B014A;
      63'h018: Data = 32'h8A0A018C;
      63'h01c: Data = 32'hB400008C;
      63'h020: Data = 32'h8B0901AD;
      63'h024: Data = 32'hCB09018C;
      63'h028: Data = 32'h17FFFFFD;
      63'h02c: Data = 32'hF80203ED;
      63'h030:
      Data = 32'hF84203ED;  //One last load to place stored value on memdbus for test checking.
      */
      /* Add code for your tests here */

      /*
      Movz Test
      1. Movz 1234 into register x9
      1-2. set X11 to 12* 16
      2. LSL x9 by 12 * 16
      3. Movz 5678 into register x10
      3-2 set X11 to 8 * 16
      4. LSL x10 by 8
      5. add X9 and X10
      6. Movz 9ABC into register x10
      6-2 set X11 to 4
      7. LSL x10 by 4
      8. add X9 and X10
      9. Movz DEF0 into register x10
      10. add X9 and X10
      */

      63'h000: Data = {11'b11010010111, 16'h1234, 5'b01001};//Movz 1234 into register x9  + lsl by 12*16
      //63'h004: Data = {11'b110100101xx, 16'h00C0, 5'b01011};//Movz X11 to 12* 16
      //63'h008: Data = {11'b11010011011, 5'b01001,6'b000000, 5'b01011, 5'b01001};//LSL x9 by 12 * 16
      63'h004: Data = {11'b11010010110, 16'h5678, 5'b01010};//Movz 5678 into register x10 + lsl by 8*16
      //63'h004: Data = {11'b110100101xx, 16'h0080, 5'b01011};//Movz X11 to 8
      //63'h010: Data = {11'b110100101xx, 5'b01010, 6'b000000, 5'b01011, 5'b01010};//LSL x10 by 8 * 16
      63'h008: Data = {11'bx0x01011xxx, 5'b01010, 6'b000000, 5'b01001, 5'b01001};//add X9 and X10
      63'h00c: Data = {11'b11010010101, 16'h9ABC, 5'b01010};//Movz 9ABC into register x10 + lsl by 4
      //63'h01C: Data = {11'b110100101xx, 16'h0040, 5'b01011};//Movz X11 to 4
      //63'h020: Data = {11'b110100101xx, 5'b01010, 6'b000000, 5'b01011, 5'b01010};//LSL x10 by 4
      63'h010: Data = {11'bx0x01011xxx, 5'b01010,6'b000000, 5'b01001, 5'b01001};//add X9 and X10
      63'h014: Data = {11'b11010010100, 16'hDEF0, 5'b01010};//Movz DEF0 into register x10
      63'h018: Data = {11'bx0x01011xxx, 5'b01010,6'b000000, 5'b01001, 5'b01001};//add X9 and X10

      default: Data = 32'hXXXXXXXX;
    endcase

  end
endmodule
