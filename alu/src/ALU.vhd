library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    port(
		a, b : in std_logic_vector(7 downto 0);	
		opcode: in std_logic_vector(2 downto 0);
		o: out std_logic_vector(7 downto 0);
		z, cout: out std_logic
	);
end ALU;

architecture ALU_arch of ALU is
component AU
	port(
		a, b : in std_logic_vector(7 downto 0);
		opcode: in std_logic;
		o: out std_logic_vector(7 downto 0);
		cout: out std_logic
	);
end component;

component LU
	port(
		a, b : in std_logic_vector(7 downto 0);
		opcode: in std_logic_vector(1 downto 0);
		o: out std_logic_vector(7 downto 0)
	);
end component;

component mux2_8b
    port(
		in1: in std_logic_vector(7 downto 0);
		in2: in std_logic_vector(7 downto 0);
		sel: in std_logic;
		o: out std_logic_vector(7 downto 0)
	);
end component;

component mux2
    port(
		in1, in2, sel: in std_logic;
		output: out std_logic
	);
end component;

signal o_au: std_logic_vector(7 downto 0);
signal o_lu: std_logic_vector(7 downto 0);
signal temp_cout: std_logic;
begin
out_au: AU port map (a,b,opcode(0),o_au,temp_cout);
out_lu: LU port map (a,b,opcode(1 downto 0),o_lu);
cout_mux: mux2 port map (temp_cout, '0', opcode(2), cout);
out_mux: mux2_8b port map (o_au, o_lu, opcode(2), o);
z <= '1' when ((o_au = "00000000") AND opcode(2) = '0') or ((o_lu = "00000000") AND opcode(2) = '1') else
		'0';
end ALU_arch;
