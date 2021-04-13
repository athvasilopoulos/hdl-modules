library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_8b is
    port(
		in1: in std_logic_vector(7 downto 0);
		in2: in std_logic_vector(7 downto 0);
		sel: in std_logic;
		o: out std_logic_vector(7 downto 0)
	);
end mux2_8b;

architecture mux2_8b_arch of mux2_8b is
component mux2
    port(
		in1, in2, sel: in std_logic;
		output: out std_logic
	);
end component;
begin
output:
for i in 0 to 7 generate
	out_i : mux2 port map (in1(i),in2(i), sel, o(i));
end generate;
end mux2_8b_arch;
