
module tb;
  // Control signals are controlled directly from the testbench
  logic clk, rst, synch_clr, load, en, up;
  ubc_if tbi(clk, rst, synch_clr, load, en, up);	// create interface
  test tst(tbi);        // connect test with interface
  
  universal_binary_counter ubc (
    clk, rst,
    synch_clr,
    load,
    en,
    up,
    tbi.d,
    tbi.min,
    tbi.max,
    tbi.Q
    );

  always #5 clk = ~clk;
  initial begin
      clk = 0;
      rst = 1;
      synch_clr = 0;
      load = 0;
      up = 1;
      en = 1;
      #4 rst = 0;
  end
  
  // Control signals testing
  initial begin
    #86 load = 1;
    up = 0;
    en = 0;
    #10 load = 0;
    #20; en = 1;
    #100 synch_clr = 1;
    #110 synch_clr = 0;
    #400 up = 1;
  end

  initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
  end
endmodule