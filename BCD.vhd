Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity BCD is
Port(
	I : in std_logic_vector(3 downto 0);
	O : out std_logic_vector(6 downto 0)
);
End BCD;

Architecture Behavioral of BCD is

Begin
	O <=  B"111_1110" when I = X"0" else
			B"011_0000" when I = X"1" else
			B"110_1101" when I = X"2" else
			B"111_1001" when I = X"3" else
			B"011_0011" when I = X"4" else
			B"101_1011" when I = X"5" else
			B"101_1111" when I = X"6" else
			B"111_0000" when I = X"7" else
			B"111_1111" when I = X"8" else
			B"111_1011" when I = X"9" else
			B"111_0111" when I = X"A" else
			B"001_1111" when I = X"B" else
			B"100_1110" when I = X"C" else
			B"011_1101" when I = X"D" else
			B"100_1111" when I = X"E" else
			B"100_0111";

End Behavioral;

