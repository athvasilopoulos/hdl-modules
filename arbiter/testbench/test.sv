`include "environment.sv"

program test(arb_if tif);
  environment env;
  initial begin
    env = new(tif);
    env.gen.count = 50;
    env.run();
  end
endprogram