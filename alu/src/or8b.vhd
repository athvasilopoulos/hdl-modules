library ieee;
use ieee.std_logic_1164.all;

entity or8b is
	port(
		a,b: in std_logic_vector(7 downto 0);
		o: out std_logic_vector(7 downto 0)
	);
end or8b;

architecture or8b_arch of or8b is
component or1b
	port(
		a,b: in std_logic;
		o: out std_logic
	);
end component;
begin
generate_label:
for i in 0 to 7 generate
	or_i : or1b port map(a(i),b(i),o(i));
end generate;
end or8b_arch;