`include "environment.sv"

program test(ham_if tif);
  environment env;
  initial begin
    env = new(tif);
    // number of random samples
    env.gen.count = 100;
    env.run();
  end
endprogram