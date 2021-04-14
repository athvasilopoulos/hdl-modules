class transaction;
  rand logic [7:0] a, b;
  logic [3:0] distance;
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
  virtual ham_if dif;
  int drv_count;
  
  function new(mailbox mbox, virtual ham_if dif);
    this.mbox = mbox;
    this.dif = dif;
  endfunction
  
  task run();
    forever begin
      #10;
      trans = new();
      mbox.get(trans);
      dif.a = trans.a;
      dif.b = trans.b;
      #1;
      drv_count++;
    end
  endtask
endclass

class monitor;
  mailbox mbox;
  transaction trans;
  virtual ham_if mif;
  
  function new(mailbox mbox, virtual ham_if mif);
    this.mbox = mbox;
    this.mif = mif;
  endfunction
  
  task run();
    #11;    // Initial delay
    forever begin
      trans = new();
      trans.a = mif.a;
      trans.b = mif.b;
      trans.distance = mif.distance;
      this.mbox.put(trans);
      #11;
    end
  endtask
endclass

class scoreboard;
  mailbox mbox;
  transaction trans;
  int err;
  logic [7:0] temp;
  
  function new(mailbox mbox);
    this.mbox = mbox;
    this.err = 0;
  endfunction
  
  task run();
    int cntr;
    forever begin
      trans = new();
      this.mbox.get(trans);
      temp = trans.a ^ trans.b;
      cntr = 0;
      for(int i = 0; i < 8; i++) begin
        if(temp[i] == 1'b1)
          cntr++;
      end
      $display("Received a = %b, b = %b, dist = %0d. Correct result is dist = %0d", trans.a, trans.b, trans.distance, cntr);
      if(trans.distance != cntr) begin
        $display("Error at %0t, a = %b, b = %b, dist = %0d and expected dist is %0d", $time, trans.a, trans.b, trans.distance, cntr);
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
  virtual ham_if eif;
  
  function new(virtual ham_if eif);
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