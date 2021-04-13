library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
	port(
		in1, in2, sel: in std_logic;
		output: out std_logic
	);
end mux2;

architecture mux2_arch of mux2 is
begin
output <= in1 when sel='0' else
		  in2;
end mux2_arch;