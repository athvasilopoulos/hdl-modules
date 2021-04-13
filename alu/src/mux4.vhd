library ieee;
use ieee.std_logic_1164.all;
entity mux4 is
	port(
		in1, in2, in3, in4: in std_logic;
		s: in std_logic_vector(1 downto 0);
		o: out std_logic
	);
end mux4;

architecture mux4_arch of mux4 is
component mux2
    port(
		in1, in2, sel: in std_logic;
		output: out std_logic
	);
end component;
signal temp1, temp2: std_logic;
begin
mux01 : mux2 port map(in1, in2, s(0), temp1);
mux02 : mux2 port map(in3, in4, s(0), temp2);
mux03 : mux2 port map(temp1, temp2, s(1), o);
end mux4_arch;