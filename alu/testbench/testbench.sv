
module tb;
  alu_if tbi();	    // create interface
  test tst(tbi);    // connect test with interface
  ALU alu (tbi.a, tbi.b, tbi.opcode, tbi.o, tbi.z, tbi.cout);	// connect DUT with interface
endmodule