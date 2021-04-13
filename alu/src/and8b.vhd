library ieee;
use ieee.std_logic_1164.all;

entity and8b is
	port(
		a,b: in std_logic_vector(7 downto 0);
		o: out std_logic_vector(7 downto 0)
	);
end and8b;

architecture and8b_arch of and8b is
component and1b
	port(
		a,b: in std_logic;
		o: out std_logic
	);
end component;
begin
generate_label:
for i in 0 to 7 generate
	and_i: and1b port map(a(i),b(i),o(i));
end generate;

end and8b_arch;