# Arbiter

This repository contains two implementations of an arbiter. The first one is a priority arbiter and the second one is a fair arbiter. The testbench, which is written in SystemVerilog, is common for the two modules with the exception of the scoreboard. 

## Arbiter Behaviour

This module models an arbiter which regulates a common resource between two processes. The processes request the resource by activating a request bit and hold it  until they finish with the resource. In the first implementation, in the case of simultaneous requests by the processes, the process 1 has priority over the process 0, whereas in the second implementation the arbiter remembers which process used the resource last and gives priority to the other one.

## Testbench structure

The testbench follows the classic SystemVerilog structure. It consists of a generator-driver pair that feeds stimuli to the DUT and a monitor-scoreboard pair that verifies the functionality of the DUT.<br>
The default testbench verifies the unfair arbiter. To change to the fair arbiter, two changes need to happen in the environment class and in the testbench module, as indicated by the comments inside the files.