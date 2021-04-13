library ieee;
use ieee.std_logic_1164.all;

entity AU is
	port(
		a, b : in std_logic_vector(7 downto 0);
		opcode: in std_logic;
		o: out std_logic_vector(7 downto 0);
		cout: out std_logic
	);
end  AU;

architecture AU_arch of AU is
component fulladder8b
	port(
		a,b: in std_logic_vector(7 downto 0);
		cin: in std_logic;
		s: out std_logic_vector(7 downto 0);
		cout: out std_logic
	);
end component;
component xor1b
	port(
		a,b: in std_logic;
		o: out std_logic
	);
end component;
signal temp_b: std_logic_vector(7 downto 0);

begin
gen_label:
for i in 0 to 7 generate
	xor_i: xor1b port map(b(i),opcode,temp_b(i));
end generate;

output: fulladder8b port map(a,temp_b,opcode,o,cout);
end AU_arch;
