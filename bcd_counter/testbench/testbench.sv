
module tb;
  logic clk, rst;
  bcd_if tbi(clk, rst);	// create interface
  test tst(tbi);        // connect test with interface
  
  bcd_counter bcd (clk, rst, tbi.hundreds, tbi.tens, tbi.ones);

  always #3 clk = ~clk;
  initial begin
      clk = 0;
      rst = 1;
      #2 rst = 0;
  end

  initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
  end
endmodule