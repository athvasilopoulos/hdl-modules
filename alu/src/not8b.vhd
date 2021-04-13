library ieee;
use ieee.std_logic_1164.all;

entity not8b is
	port(
		a: in std_logic_vector(7 downto 0);
		o: out std_logic_vector(7 downto 0)
	);
end not8b;

architecture not8b_arch of not8b is
component not1b
	port(
		a: in std_logic;
		o: out std_logic
	);
end component;
begin
generate_label:
for i in 0 to 7 generate
	not_i : not1b port map(a(i),o(i));
end generate;
end not8b_arch;