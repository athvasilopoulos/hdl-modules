// This is the scoreboard class for the priority arbiter
class scoreboard;
  mailbox mbx;
  transaction trans;
  int err;
  virtual arb_if sif;
  logic [1:0] expected_outcome;

  function new(mailbox mbx, virtual arb_if sif);
    this.mbx = mbx;
    this.sif = sif;
    this.err = 0;
    this.expected_outcome = 2'b00;
  endfunction

  task run();
    forever begin
      @(posedge this.sif.clk);
      #3;
      trans = new();
      mbx.get(trans);
      if(trans.g != expected_outcome) begin
        $display("Error at %0t. Expected g = %b and the result was g = %b", $time, expected_outcome, trans.g);
        err++;
      end
      case(trans.g)
      2'b00: begin
        if(trans.r[1] == 1'b1)
          expected_outcome = 2'b10;
        else if(trans.r[0] == 1'b1)
          expected_outcome = 2'b01;
        else
          expected_outcome = 2'b00;
      end
      2'b01: begin
        if(trans.r[0] == 1'b0)
          expected_outcome = 2'b00;
        else
          expected_outcome = 2'b01;
      end
      2'b10: begin
        if(trans.r[1] == 1'b0)
          expected_outcome = 2'b00;
        else
          expected_outcome = 2'b10;
      end
      endcase
      $display("Created expected_outcome = %b", expected_outcome);
    end
  endtask

  function void report();
    $display("---------------------------");
    $display("Tests ended with %0d errors", this.err);
    $display("---------------------------");
  endfunction
endclass