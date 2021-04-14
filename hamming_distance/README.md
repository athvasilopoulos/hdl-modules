# Hamming distance calculator
This folder contains a hamming distance calculator (HDC) built with concurrent VHDL.

## HDC Behaviour
The module takes two 8-bit inputs and finds the hamming distance between them.

## Testbench structure
The testbench follows the classic SystemVerilog structure. It consists of a generator-driver pair that feeds stimuli to the DUT and a monitor-scoreboard pair that verifies the functionality of the DUT.