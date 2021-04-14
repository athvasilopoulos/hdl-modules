library ieee;
use ieee.std_logic_1164.all;

entity arbiter is
	port(
		clk, rst: in std_logic;
		r: in std_logic_vector(1 downto 0);
		g: out std_logic_vector(1 downto 0)
	);
end arbiter;

architecture arbiter_priority of arbiter is
type state_type is (waitr, grant0, grant1);
signal state: state_type;
begin
states: process(clk, rst)
begin
if rst = '1' then
	state <= waitr;
elsif rising_edge(clk) then
	case state is
		when waitr =>
			if r(1) = '1' then
				state <= grant1;
			elsif r(0) = '1' then
				state <= grant0;
			end if;
		when grant1 =>
			if r(1) = '0' then
				state <= waitr;
			end if;
		when grant0 =>
			if r(0) = '0' then
				state <= waitr;
			end if;
	end case;
end if;
end process states;

outp: process(state)
begin
if state = waitr then
	g <= "00";
elsif state = grant1 then
	g <= "10";
else
	g <= "01";
end if;
end process outp;
end arbiter_priority;