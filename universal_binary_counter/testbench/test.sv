`include "environment.sv"

program test(ubc_if tif);
  environment env;
  initial begin
    env = new(tif);
    env.gen.count = 100;
    env.run();
  end
endprogram