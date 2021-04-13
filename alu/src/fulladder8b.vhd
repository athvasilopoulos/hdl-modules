library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fulladder8b is
    port(
		a,b: in std_logic_vector(7 downto 0);
		cin: in std_logic;
		s: out std_logic_vector(7 downto 0);
		cout: out std_logic
	);
end fulladder8b;

architecture fulladder8b_arch of fulladder8b is
component fulladder1b
	port(
		a,b,cin: in std_logic;
		s,cout: out std_logic
	);
end component;
signal temp : std_logic_vector(8 downto 0);
begin
temp(0) <= cin;
generate_label:
for i in 0 to 7 generate
	fulladd_i : fulladder1b port map(a(i),b(i),temp(i),s(i),temp(i+1));
end generate;
cout <= temp(8);
end fulladder8b_arch;
