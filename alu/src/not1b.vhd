library ieee;
use ieee.std_logic_1164.all;

entity not1b is
	port(
		a: in std_logic;
		o: out std_logic
	);
end not1b;

architecture not1b_arch of not1b is
begin
o <= NOT a;
end not1b_arch;