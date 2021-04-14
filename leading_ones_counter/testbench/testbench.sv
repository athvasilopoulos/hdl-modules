module tb;
  loc_if tbi();	    // create interface
  test tst(tbi);    // connect test with interface
  leading_ones_counter loc (tbi.x, tbi.y, tbi.ssd);
endmodule