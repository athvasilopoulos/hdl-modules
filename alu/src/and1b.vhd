library ieee;
use ieee.std_logic_1164.all;

entity and1b is
	port(
		a,b: in std_logic;
		o: out std_logic
	);
end and1b;

architecture and1b_arch of and1b is
begin
o <= a AND b;
end and1b_arch;