library ieee;
use ieee.std_logic_1164.all;

entity LU is
	port(
		a, b : in std_logic_vector(7 downto 0);
		opcode: in std_logic_vector(1 downto 0);
		o: out std_logic_vector(7 downto 0)
	);
end LU;

architecture LU_arch of LU is
component xor8b
	port(
		a,b: in std_logic_vector(7 downto 0);
		o: out std_logic_vector(7 downto 0)
	);
end component;
component or8b
	port(
		a,b: in std_logic_vector(7 downto 0);
		o: out std_logic_vector(7 downto 0)
	);
end component;
component and8b
	port(
		a,b: in std_logic_vector(7 downto 0);
		o: out std_logic_vector(7 downto 0)
	);
end component;
component not8b
	port(
		a: in std_logic_vector(7 downto 0);
		o: out std_logic_vector(7 downto 0)
	);
end component;
component mux4
	port(
		in1, in2, in3, in4: in std_logic;
		s: in std_logic_vector(1 downto 0);
		o: out std_logic
	);
end component;
signal out_xor: std_logic_vector(7 downto 0);
signal out_and: std_logic_vector(7 downto 0);
signal out_or: std_logic_vector(7 downto 0);
signal out_not: std_logic_vector(7 downto 0);
begin

xor8: xor8b port map(a,b,out_xor);
and8: and8b port map(a,b,out_and);
or8: or8b port map(a,b,out_or);
not8: not8b port map(a,out_not);

generate_label:
for i in 0 to 7 generate
	o_i: mux4 port map(out_and(i),out_not(i),out_or(i),out_xor(i),opcode,o(i));
end generate;
end LU_arch;