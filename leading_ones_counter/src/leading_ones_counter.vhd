-- This is an implementation of a leading ones counter using concurrent VHDL.
-- The outputs of the module are a binary represantation of the number counted
-- and a signal driving a seven segment display to show the number counted.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real."ceil";
use ieee.math_real."log2";

entity leading_ones_counter is
	generic (N: integer := 8);
	port(
		x: in std_logic_vector(N-1 downto 0);
		y: out std_logic_vector(integer(ceil(log2(real(N)))) downto 0);
		ssd: out std_logic_vector(6 downto 0)
	);
end leading_ones_counter;

architecture concurrent of leading_ones_counter is
type int_array is array (N downto 0) of integer range 0 to N;
signal f: std_logic_vector(N-1 downto 0);
signal counters: int_array;
begin

-- Mask to hold just the leading ones
f(N-1) <= x(N-1);
lbl0 : for i in N-2 downto 0 generate
	f(i) <= f(i+1) and x(i);
end generate;

-- Counter for the leading ones, using an int array
counters(0) <= 0;
lbl : for i in 1 to N generate
	counters(i) <= counters(i-1) + 1 when f(N-i) = '1' else
				   counters(i-1);
end generate;

-- Output generators
y <= std_logic_vector(to_unsigned(counters(N), y'length));
-- Sevent Segment Display values are taken from an array
ssd <= "0000001" when counters(N) = 0 else
	   "1001111" when counters(N) = 1 else
	   "0010010" when counters(N) = 2 else
	   "0000110" when counters(N) = 3 else
	   "1001100" when counters(N) = 4 else
	   "0100100" when counters(N) = 5 else
	   "0100000" when counters(N) = 6 else
	   "0001111" when counters(N) = 7 else
	   "0000000" when counters(N) = 8 else
	   "0000100" when counters(N) = 9 else
	   "0001000" when counters(N) = 10 else
	   "1100000" when counters(N) = 11 else
	   "0110001" when counters(N) = 12 else
	   "1000010" when counters(N) = 13 else
	   "0110000" when counters(N) = 14 else
	   "0111000" when counters(N) = 15 else
	   "1111110";	--dash for error
	   
end concurrent;