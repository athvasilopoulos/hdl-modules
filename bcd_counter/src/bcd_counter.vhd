library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_counter is
	port(
		clk, rst: in std_logic;
		hundreds, tens, ones: out std_logic_vector(3 downto 0)
	);
end bcd_counter;

architecture bcd_counter_arch of bcd_counter is
begin
bcd: process(clk, rst)
variable ch, ct: integer range 0 to 10;
variable co: integer range 0 to 10;
begin
if rst = '1' then
	ch := 0;
	ct := 0;
	co := 0;
elsif rising_edge(clk) then
	co := co + 1;
	if co > 9 then
		co := 0;
		ct := ct + 1;
	end if;
	if ct > 9 then
		ct := 0;
		ch := ch + 1;
	end if;
	if ch > 9 then
		ch := 0;
	end if;
end if;
ones <= std_logic_vector(to_unsigned(co, ones'length));
tens <= std_logic_vector(to_unsigned(ct, tens'length));
hundreds <= std_logic_vector(to_unsigned(ch, hundreds'length));
end process bcd;
end bcd_counter_arch;