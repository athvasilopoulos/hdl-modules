// This is the scoreboard class for the fair arbiter
class scoreboard_fair;
  mailbox mbx;
  transaction trans;
  int err;
  virtual arb_if sif;
  logic [1:0] expected_outcome;
  logic [1:0] last_state;

  function new(mailbox mbx, virtual arb_if sif);
    this.mbx = mbx;
    this.sif = sif;
    this.err = 0;
    this.expected_outcome = 2'b00;
    this.last_state = 2'b10;
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
        case(trans.r)
        2'b00: expected_outcome = 2'b00;
        2'b01: expected_outcome = 2'b01;
        2'b10: expected_outcome = 2'b10;
        2'b11: begin
          if(last_state == 2'b01)
            expected_outcome = 2'b10;
          else
            expected_outcome = 2'b01;
        end
        endcase
      end
      2'b01: begin
        if(trans.r[0] == 1'b0) begin
            expected_outcome = 2'b00;
            last_state = 2'b01;
          end
        else
          expected_outcome = 2'b01;
      end
      2'b10: begin
        if(trans.r[1] == 1'b0) begin
            expected_outcome = 2'b00;
            last_state = 2'b10;
          end
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