`include "scoreboard.sv"
`include "scoreboard_fair.sv"

class transaction;
  rand logic [1:0] r;
  logic [1:0] g;
endclass

class generator;
  mailbox mbx;
  event complete;
  int count;

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction

  task run();
    repeat(count) begin
      transaction trans = new();
      assert(trans.randomize());
      mbx.put(trans);
    end
    -> complete;
  endtask
endclass

class driver;
  mailbox mbx;
  transaction trans;
  virtual arb_if dif;
  int drv_count;

  function new(mailbox mbx, virtual arb_if dif);
    this.mbx = mbx;
    this.dif = dif;
  endfunction

  task reset();
    wait(dif.rst);
    dif.r = 2'b00;
    wait(!dif.rst);
  endtask;

  task run();
    forever begin
      trans = new();
      mbx.get(trans);
      @(posedge dif.clk);
      dif.r = trans.r;
      drv_count++;
    end
  endtask
endclass

class monitor;
  mailbox mbx;
  transaction trans;
  virtual arb_if mif;

  function new(mailbox mbx, virtual arb_if mif);
    this.mbx = mbx;
    this.mif = mif;
  endfunction

  task run();
    forever begin
      @(posedge mif.clk);
      #2; // to avoid race condition
      $display("sampled at %0t, r = %b and g = %b", $time, mif.r, mif.g);
      trans = new();
      trans.r = mif.r;
      trans.g = mif.g;
      this.mbx.put(trans);
    end
  endtask
endclass


class environment;
  generator gen;
  driver drv;
  mailbox mbox, mboxs;
  monitor mon;
  virtual arb_if eif;
  // To choose which arbiter to test, uncomment the 
  // correct one and comment the other one.
  scoreboard sc;
  //scoreboard_fair sc;
  
  function new(virtual arb_if eif);
    this.eif = eif;
    mbox = new();
    gen = new(mbox);
    drv = new(mbox, eif);
    mboxs = new();
    mon = new(mboxs, eif);
    sc = new(mboxs, eif);
  endfunction
  
  task pretest();
    drv.reset();
  endtask
  
  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      sc.run();
    join_any
  endtask
  
  task posttest();
    wait(gen.complete.triggered);
    wait(drv.drv_count == gen.count);
    sc.report();
  endtask
  
  task run();
    pretest();
    test();
    posttest();
    $finish;
  endtask
endclass