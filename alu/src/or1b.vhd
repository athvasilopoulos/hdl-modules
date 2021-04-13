library ieee;
use ieee.std_logic_1164.all;

entity or1b is
	port(
		a,b: in std_logic;
		o: out std_logic
	);
end or1b;

architecture or1b_arch of or1b is
begin
o <= a OR b;
end or1b_arch;