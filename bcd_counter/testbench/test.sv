`include "environment.sv"

program test(bcd_if tif);
  environment env;
  initial begin
    env = new(tif);
    env.mon.count = 1100;
    env.run();
  end
endprogram