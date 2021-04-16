library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity universal_binary_counter is
	port(
		clk, rst, synch_clr, load, en, up: in std_logic;
		d: in std_logic_vector(3 downto 0);
		min, max: out std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
end universal_binary_counter;

architecture ubc_arch of universal_binary_counter is
signal counter: integer range 0 to 15;
begin

ubc: process(clk, rst)
begin
if rst = '1' then
	counter <= 0;
elsif rising_edge(clk) then
	if synch_clr = '1' then
		counter <= 0;
	elsif load = '1' then
		counter <= to_integer(unsigned(d));
	elsif en = '1' then
		if up = '1' then
			if counter < 15 then
				counter <= counter + 1;
			else
				counter <= 0;
			end if;
		else
			if counter > 0 then
				counter <= counter - 1;
			else
				counter <= 15;
			end if;
		end if;
	end if;
end if;
end process ubc;

outp: process(counter)
begin

if counter = 0 then
	min <= '1';
	max <= '0';
elsif counter = 15 then
	max <= '1';
	min <= '0';
else
	max <= '0';
	min <= '0';
end if;
Q <= std_logic_vector(to_unsigned(counter, Q'length));

end process outp;
end ubc_arch;