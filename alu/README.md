# ALU
This folder contains an ALU implementation using structural VHDL, all the way to the bitwise operations. The testbench is written in SystemVerilog and includes a scoreboard.

## ALU I/O
a: input (8-bit) - first operand <br>
b: input (8-bit) - second operand <br>
op: input (3-bit) - operation code <br>
out: output (8-bit) - output of the operation <br>
zero: output (1-bit) - activated if the output is zero <br>
cout: output (1-bit) - activated if the operation produces a carry

## ALU behaviour

| Opcode        | Operation      | Cool         |
|:-------------:|:--------------:| :-----------:|
| op = 000      | addition       | out = a + b  |
| op = 001      | subtraction    | out = a - b  |
| op = 100      | logical AND    | out = a & b  |
| op = 101      | inversion of A | out = !a     |
| op = 110      | logical OR     | out = a \| b |
| op = 111      | logical XOR    | out = a ^ b  |

## Testbench structure

The testbench follows the classic SystemVerilog structure. It consists of a generator-driver pair that feeds stimuli to the DUT and a monitor-scoreboard pair that verifies the functionality of the DUT.