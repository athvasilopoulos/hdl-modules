library ieee;
use ieee.std_logic_1164.all;

entity arbiter_fair is
	port(
		clk, rst: in std_logic;
		r: in std_logic_vector(1 downto 0);
		g: out std_logic_vector(1 downto 0)
	);
end arbiter_fair;

architecture arbiter_fair_arch of arbiter_fair is
type state_type is (wait0, wait1, grant0, grant1);
signal state: state_type;
begin
states: process(clk, rst)
begin
if rst = '1' then
	state <= wait0;
elsif rising_edge(clk) then
	case state is
		when wait0 =>
			if r(0) = '1' then
				state <= grant0;
			elsif r(1) = '1' then
				state <= grant1;
			end if;
		
		when wait1 =>
			if r(1) = '1' then
				state <= grant1;
			elsif r(0) = '1' then
				state <= grant0;
			end if;
		
		when grant0 =>
			if r(0) = '0' then
				state <= wait1;
			end if;
		
		when grant1 => 
			if r(1) = '0' then
				state <= wait0;
			end if;
	end case;
end if;
end process states;

outp: process(state)
begin
if state = grant1 then
	g <= "10";
elsif state = grant0 then
	g <= "01";
else
	g <= "00";
end if;
end process outp;
end arbiter_fair_arch;