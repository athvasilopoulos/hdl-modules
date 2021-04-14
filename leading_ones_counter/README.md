# Leading Ones Counter
This folder contains a leading ones counter (loc) module built with concurrent VHDL.

## LOC Behaviour
The module takes a parameterized sized input and gives as an output the number of the leading ones in two forms, a binary representation and a seven segment display representation.

## Testbench structure
The testbench follows the classic SystemVerilog structure. It consists of a generator-driver pair that feeds stimuli to the DUT and a monitor-scoreboard pair that verifies the functionality of the DUT.