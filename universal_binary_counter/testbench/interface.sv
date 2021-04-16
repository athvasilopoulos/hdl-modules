interface ubc_if(input logic clk, rst, synch_clr, load, en, up);
	logic [3:0] d;
  logic min, max;
  logic [3:0] Q;
endinterface