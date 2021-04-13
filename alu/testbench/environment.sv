// Transaction packet
class transaction;
  rand logic [7:0] a, b;
  rand logic [2:0] opcode;
  constraint op {
    (opcode != 3'b010) & (opcode != 3'b011);
  };
  logic [7:0] o;
  logic z, cout;
endclass

// Generates random stimuli and passes
// to the driver via a mailbox
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

// Reads the stimuli from the generator
// and applies them to the DUT via the interface
// Since the DUT is asynchronous, an artificial
// delay has been added
class driver;
  transaction trans;
  mailbox mbox;
  virtual alu_if dif;
  int drv_count;
  
  function new(mailbox mbox, virtual alu_if dif);
    this.mbox = mbox;
    this.dif = dif;
  endfunction
  
  task run();
    forever begin
      #10;
      trans = new();
      mbox.get(trans);
      dif.a <= trans.a;
      dif.b <= trans.b;
      dif.opcode <= trans.opcode;
      drv_count++;
      #1;
    end
  endtask
endclass

// Samples the inputs and outputs of the
// DUT and passes them to the scoreboard
// for evaluation via a mailbox
class monitor;
  mailbox mbox;
  transaction trans;
  virtual alu_if mif;
  
  function new(mailbox mbox, virtual alu_if mif);
    this.mbox = mbox;
    this.mif = mif;
  endfunction
  
  task run();
    forever begin
      trans = new();
      trans.a <= mif.a;
      trans.b <= mif.b;
      trans.opcode <= mif.opcode;
      trans.o <= mif.o;
      trans.z <= mif.z;
      trans.cout <= mif.cout;
      this.mbox.put(trans);
      #10;
    end
  endtask
endclass

// Evaluates the outputs of the
// DUT based on the stimuli. 
class scoreboard;
  mailbox mbox;
  transaction trans;
  int err;
  logic [8:0] temp;
  
  function new(mailbox mbox);
    this.mbox = mbox;
    this.err = 0;
  endfunction
  
  task run();
    forever begin
      trans = new();
      this.mbox.get(trans);
      case(trans.opcode)
      0: begin
        temp = trans.a + trans.b;
        if(trans.o != temp[7:0] & trans.cout != temp[8]) begin
          $display("error at %0h + %0h = %0h.(Cout = %0b). Expected result %0h with Cout = %0b", trans.a, trans.b, trans.o, trans.cout, temp[7:0], temp[8]);
          err++;
        end
      end
      1: begin
        temp = trans.a + ~trans.b + 1;
        if(trans.o != temp[7:0] & trans.cout != temp[8]) begin
          $display("error at %0h - %0h = %0h (Cout = %0b). Expected result %0h with Cout = %0b", trans.a, trans.b, trans.o, trans.cout, temp[7:0], temp[8]);
          err++;
        end
      end
      4: begin
        temp[7:0] = trans.a & trans.b;
        if(trans.o != temp[7:0]) begin
          $display("error at %0h AND %0h = %0h. Expected result %0h", trans.a, trans.b, trans.o, temp[7:0]);
          err++;
        end
      end
      5: begin
        temp[7:0] = ~trans.a;
        if(trans.o != temp[7:0]) begin
          $display("error at NOT %0h = %0h. Expected result %0h", trans.a, trans.o, temp[7:0]);
          err++;
        end 
      end
      6: begin
        temp[7:0] = trans.a | trans.b;
        if(trans.o != temp[7:0]) begin
          $display("error at %0h OR %0h = %0h. Expected result %0h", trans.a, trans.b, trans.o, temp[7:0]);
          err++;
        end
      end
      7: begin
        temp[7:0] = trans.a ^ trans.b;
        if(trans.o != temp[7:0]) begin
          $display("error at %0h XOR %0h = %0h. Expected result %0h", trans.a, trans.b, trans.o, temp[7:0]);
          err++;
        end
      end
      endcase
      case(trans.z)
      0: begin
        temp[7:0] = trans.o;
        if(temp[7:0] == 8'h00) begin
          $display("error with the zero bit at %0t. It should be 1 but it is 0. Output is %0h", $time, trans.o);
          err++;
        end
      end
      1: begin
        temp[7:0] = trans.o;
        if(temp[7:0] != 8'h00) begin
          $display("error with the zero bit at %0t. It should be 0 but it is 1. Output is %0h", $time, trans.o);
          err++;
        end
      end
      endcase
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
  virtual alu_if eif;
  
  function new(virtual alu_if eif);
    this.eif = eif;
    mbox = new();
    gen = new(mbox);
    drv = new(mbox, eif);
    mboxs = new();
    mon = new(mboxs, eif);
    sc = new(mboxs);
    
  endfunction
  
  // Start all the processes in parallel
  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      sc.run();
    join_any
  endtask
  
  // Wait for all the stimuli to be applied to
  // call the evaluation report
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