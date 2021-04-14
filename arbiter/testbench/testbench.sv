
module tb;
  logic clk, rst;
  arb_if tbi(clk, rst);	// create interface
  test tst(tbi);        // connect test with interface
  
  // To choose which arbiter to test, uncomment the 
  // correct one and comment the other one.
  // A similar change needs to happen in the 
  // environment class as well.
  arbiter arb (clk, rst, tbi.r, tbi.g);
  // arbiter_fair arb (clk, rst, tbi.r, tbi.g);

  always #5 clk = ~clk;
  initial begin
      clk = 0;
      rst = 1;
      #5 rst = 0;
  end

  initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
  end
endmodule