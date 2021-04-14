library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hamming_distance is
    port(a, b: in std_logic_vector (7 downto 0);
         dist: out std_logic_vector (3 downto 0)
    );
end hamming_distance;

architecture hamming_arch of hamming_distance is
signal diff: unsigned(7 downto 0);
signal lev0_0, lev0_2, lev0_4, lev0_6:unsigned(1 downto 0);
signal lev1_0, lev1_4: unsigned(2 downto 0);
signal lev2: unsigned(3 downto 0);
begin
diff <= unsigned(a XOR b);
lev0_0 <= ('0' & diff(0)) + ('0' & diff(1));
lev0_2 <= ('0' & diff(2)) + ('0' & diff(3));
lev0_4 <= ('0' & diff(4)) + ('0' & diff(5));
lev0_6 <= ('0' & diff(6)) + ('0' & diff(7));
lev1_0 <= ('0' & lev0_0) + ('0' & lev0_2);
lev1_4 <= ('0' & lev0_4) + ('0' & lev0_6);
lev2 <= ('0' & lev1_0) + ('0' & lev1_4);
dist <= std_logic_vector(lev2);

end hamming_arch;
