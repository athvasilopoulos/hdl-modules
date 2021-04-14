module tb;
  ham_if tbi();	    // create interface
  test tst(tbi);    // connect test with interface
  hamming_distance ham (tbi.a, tbi.b, tbi.distance);
endmodule