class transaction;
  parameter N = 8;
  rand logic [N-1:0] x;
  logic [$clog2(N):0] y;
  logic [6:0] ssd;
endclass

class generator;
  mailbox mbox;
  event complete;
  int count;
  
  function new(mailbox mbox);
    this.mbox = mbox;
  endfunction
  
  task run();
    repeat(count) begin
      transaction trans = new();
      assert(trans.randomize());
      mbox.put(trans);
    end
    -> complete;
  endtask
endclass

class driver;
  transaction trans;
  mailbox mbox;
  virtual loc_if dif;
  int drv_count;
  
  function new(mailbox mbox, virtual loc_if dif);
    this.mbox = mbox;
    this.dif = dif;
  endfunction
  
  task run();
    forever begin
      #10;
      trans = new();
      mbox.get(trans);
      dif.x <= trans.x;
      #1;
      drv_count++;
    end
  endtask
endclass

class monitor;
  mailbox mbox;
  transaction trans;
  virtual loc_if mif;
  
  function new(mailbox mbox, virtual loc_if mif);
    this.mbox = mbox;
    this.mif = mif;
  endfunction
  
  task run();
    #11;    // Initial delay
    forever begin
      trans = new();
      trans.x = mif.x;
      trans.y = mif.y;
      trans.ssd = mif.ssd;
      this.mbox.put(trans);
      #11;
    end
  endtask
endclass

class scoreboard;
  mailbox mbox;
  transaction trans;
  int err;
  
  function new(mailbox mbox);
    this.mbox = mbox;
    this.err = 0;
  endfunction
  
  task run();
    int i;
    forever begin
      trans = new();
      this.mbox.get(trans);

      for(i = 0; i < $size(trans.x); i++) begin
        if(trans.x[$size(trans.x)-1-i] == 1'b0)
          break;
      end
      $display("Received x = %b, y = %0d. Correct result is i = %0d", trans.x, trans.y, i);
      if(trans.y != i) begin
        $display("Error at %0t, input = %b, result = %0d and expected is %0d", $time, trans.x, trans.y, i);
        err++;
      end
      #10;
    end
  endtask
  
  function void report();
    $display("---------------------------");
    $display("Tests ended with %0d errors", this.err);
    $display("---------------------------");
  endfunction
endclass

class environment;
  generator gen;
  driver drv;
  mailbox mbox, mboxs;
  monitor mon;
  scoreboard sc;
  virtual loc_if eif;
  
  function new(virtual loc_if eif);
    this.eif = eif;
    mbox = new();
    gen = new(mbox);
    drv = new(mbox, eif);
    mboxs = new();
    mon = new(mboxs, eif);
    sc = new(mboxs);
  endfunction
  
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
    test();
    posttest();
    $finish;
  endtask
endclass