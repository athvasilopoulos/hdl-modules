library ieee;
use ieee.std_logic_1164.all;

entity xor8b is
	port(
		a,b: in std_logic_vector(7 downto 0);
		o: out std_logic_vector(7 downto 0)
	);
end xor8b;

architecture xor8b_arch of xor8b is
component xor1b
	port(
		a,b: in std_logic;
		o: out std_logic
	);
end component;
begin
generate_label:
for i in 0 to 7 generate
	xor_i : xor1b port map(a(i),b(i),o(i));
end generate;
end xor8b_arch;