library ieee;
use ieee.std_logic_1164.all;

entity xor1b is
	port(
		a,b: in std_logic;
		o: out std_logic
	);
end xor1b;

architecture xor1b_arch of xor1b is
begin
o <= a XOR b;
end xor1b_arch;