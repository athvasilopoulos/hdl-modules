# BCD Counter
This folder contains a Binary Coded Decimal(BCD) counter, built with sequential VHDL.

## BCD Counter Behaviour
The counter has a range from 0 to 999 and increments itself on each cycle. The only inputs are a clock and a reset signal and the outputs are three 4-bit signals depicting the binary coded decimal value for each position (ones, tens and hundreds).

## Testbench structure
Since the module doesn't have any inputs besides the clock and reset signals, the testbench lacks the generator-driver pair. The monitor-scoreboard pair samples the output and verifies the functionality of the DUT.