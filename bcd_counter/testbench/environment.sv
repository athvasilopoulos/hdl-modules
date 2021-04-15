
class transaction;
  logic [3:0] ones, tens, hundreds;
endclass

class monitor;
  mailbox mbx;
  transaction trans;
  virtual bcd_if mif;
  int count;

  function new(mailbox mbx, virtual bcd_if mif);
    this.mbx = mbx;
    this.mif = mif;
  endfunction

  task run();
    repeat(count) begin
      @(posedge mif.clk);
      #1; // to avoid race condition
      trans = new();
      trans.ones = mif.ones;
      trans.tens = mif.tens;
      trans.hundreds = mif.hundreds;
      this.mbx.put(trans);
    end
  endtask
endclass

class scoreboard;
  mailbox mbx;
  transaction trans;
  int err;
  virtual bcd_if sif;
  logic [3:0] exp_ones, exp_tens, exp_hundreds;

  function new(mailbox mbx, virtual bcd_if sif);
    this.mbx = mbx;
    this.sif = sif;
    this.err = 0;
    this.exp_ones = 4'b0001;
    this.exp_tens = 4'b0;
    this.exp_hundreds = 4'b0;
  endfunction

  task run();
    forever begin
      @(posedge this.sif.clk);
      #2;
      trans = new();
      mbx.get(trans);
      if(trans.ones != exp_ones || trans.tens != exp_tens || trans.hundreds != exp_hundreds) begin
        $display("Error at %t. Expected %d%d%d and got %d%d%d", $time, exp_hundreds, exp_tens, exp_ones, trans.hundreds, trans.tens, trans.ones);
        err++;
      end
      exp_ones = exp_ones + 1;
      if(exp_ones > 9) begin
        exp_ones = 0;
        exp_tens = exp_tens + 1;
      end
      if(exp_tens > 9) begin
        exp_tens = 0;
        exp_hundreds = exp_hundreds + 1;
      end
      if(exp_hundreds > 9)
        exp_hundreds = 0;
    end
  endtask

  function void report();
    $display("---------------------------");
    $display("Tests ended with %0d errors", this.err);
    $display("---------------------------");
  endfunction
endclass

class environment;
  mailbox mboxs;
  monitor mon;
  virtual bcd_if eif;
  scoreboard sc;
  
  function new(virtual bcd_if eif);
    this.eif = eif;
    mboxs = new();
    mon = new(mboxs, eif);
    sc = new(mboxs, eif);
  endfunction
  
  task test();
    fork
      mon.run();
      sc.run();
    join_any
  endtask
  
  task posttest();
    sc.report();
  endtask
  
  task run();
    test();
    posttest();
    $finish;
  endtask
endclass