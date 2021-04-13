// Interface of ALU
interface alu_if();
  logic [7:0] a, b;
  logic [2:0] opcode;
  logic [7:0] o;
  logic z, cout;
endinterface