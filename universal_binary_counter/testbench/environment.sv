
class transaction;
  rand logic [3:0] d;
  logic min, max;
  logic [3:0] Q;
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
  virtual ubc_if dif;
  int drv_count;

  function new(mailbox mbx, virtual ubc_if dif);
    this.mbx = mbx;
    this.dif = dif;
  endfunction

  task reset();
    wait(dif.rst);
    dif.d = 4'b0;
    wait(!dif.rst);
  endtask;

  task run();
    forever begin
      trans = new();
      mbx.get(trans);
      @(posedge dif.clk);
      dif.d = trans.d;
      drv_count++;
    end
  endtask
endclass

class scoreboard;
  int err;
  virtual ubc_if sif;
  logic [3:0] exp_value;
  logic exp_min, exp_max;

  function new(virtual ubc_if sif);
    this.sif = sif;
    this.err = 0;
    this.exp_value = 4'b0001;
    this.exp_min = 1'b0;
    this.exp_max = 1'b0;
  endfunction

  task run();
    forever begin
      @(posedge this.sif.clk);
      #2;
      if(this.sif.Q != exp_value) begin
        $display("Error at %t. Expected Q = %0d and the result was Q = %0d", $time, exp_value, this.sif.Q);
        err++;
      end
      if(this.sif.min != exp_min || this.sif.max != exp_max) begin
        $display("Error at %t. Expected min = %b, max = %b and the result was min = %b, max = %b", $time, exp_min, exp_max, this.sif.min, this.sif.max);
        err++;
      end
      
      // Expected outcome creation
      if(sif.synch_clr == 1'b1)
        exp_value = 4'b0;
      else if(sif.load == 1'b1)
        exp_value = sif.d;
      else if(sif.en == 1'b1) begin
        if(sif.up == 1'b1)
          exp_value++;
        else
          exp_value--;
      end

      if(exp_value == 4'b1111) begin
          exp_max = 1'b1;
          exp_min = 1'b0;
      end
      else if(exp_value == 4'b0) begin
        exp_max = 1'b0;
        exp_min = 1'b1;
      end
      else begin
        exp_max = 1'b0;
        exp_min = 1'b0;
      end
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
  mailbox mbox;
  virtual ubc_if eif;
  scoreboard sc;
  
  function new(virtual ubc_if eif);
    this.eif = eif;
    mbox = new();
    gen = new(mbox);
    drv = new(mbox, eif);
    sc = new(eif);
  endfunction
  
  task pretest();
    drv.reset();
  endtask
  
  task test();
    fork
      gen.run();
      drv.run();
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