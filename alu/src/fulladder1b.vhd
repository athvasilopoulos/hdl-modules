library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fulladder1b is
    port(
		a,b,cin: in std_logic;
		s,cout: out std_logic
	);
end fulladder1b;

architecture fulladder1b_arch of fulladder1b is
begin
s <= a XOR b XOR cin;
cout <= (a AND b) OR (cin AND (a XOR b));
end fulladder1b_arch;
