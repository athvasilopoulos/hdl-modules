`include "environment.sv"

program test(alu_if tif);
  environment env;
  initial begin
  	// Connect environment with interface
    env = new(tif);
    // number of random samples
    env.gen.count = 100;
    env.run();
  end
endprogram