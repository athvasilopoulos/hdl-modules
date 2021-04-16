# Universal Binary Counter
This folder contains a Universal Binary Counter(UBC) implementation using sequential VHDL.

## UBC I/O
clk: input (1-bit) - clock <br>
rst: input (1-bit) - reset <br>
synch_clr: input (1-bit) - synchronous clear <br>
load: input (1-bit) - parallel load signal <br>
en: input (1-bit) - enable <br>
up: input (1-bit) - count direction <br>
d: input (4-bit) - parallel input <br>
Q: output (4-bit) - counter value <br>
max: output (1-bit) - max value signal <br>
min: output (1-bit) - min value signal


## UBC behaviour

| Synch_clr | Load | En | Up | Q(t+1) | Operation |
|:---------:|:----:|:--:|:--:|:------:|:---------:|
| 1  | - | - | - | 0000 | Synchronous clear |
| 0  | 1 | - | - | d    | Parallel load |
| 0  | 0 | 1 | 1 | Q+1  | Count up |
| 0  | 0 | 1 | 0 | Q-1  | Count down |
| 0  | 0 | 0 | - | Q    | Pause |

## Testbench structure
The testbench follows the classic generator-driver and monitor-scoreboard structure with the following distinctions. The control signals of this module are controlled directly from the testbench, so the generator-driver pair generate just the parallel input. Since the scoreboard would need access to the whole interface to create the expected outcome of the next cycle, it has been merged with the monitor in a single class.