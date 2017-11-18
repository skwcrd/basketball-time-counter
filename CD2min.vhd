Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity CD2min is
Port(
	CLK,Rstb : in std_logic;
	i1s : in std_logic;
	I2,iRe : in std_logic;
	o2Digit1,o2Digit2,o2Digit3,o2Digit4 : out std_logic_vector(3 downto 0)
);
End CD2min;

Architecture Behavioral of CD2min is
	signal w2Digit2 : std_logic_vector(3 downto 0) := "0010";
	signal w2Digit1,w2Digit3,w2Digit4 : std_logic_vector(3 downto 0);
Begin

	o2Digit1 <= w2Digit1;
	o2Digit2 <= w2Digit2;
	o2Digit3 <= w2Digit3;
	o2Digit4 <= w2Digit4;
	
	u_2min : Process(CLK,Rstb,I2,iRe)
	Begin
		if(Rstb='0' or iRe='0') then
			w2Digit1 <= (others => '0');
			w2Digit2 <= "0010";
			w2Digit3 <= (others => '0');
			w2Digit4 <= (others => '0');
		elsif(rising_edge(CLK) and I2='0') then
			
			-- Digit1 2 min Time Out Time --
			w2Digit1 <= (others => '0');
			
			-- Digit2 2 min --
			if(i1s='1' and w2Digit1=0 and w2Digit2=0) then
				w2Digit2 <= (others => '0');
			elsif(i1s='1' and w2Digit3=0 and w2Digit4=0) then
				w2Digit2 <= w2Digit2 - 1;
			else
				w2Digit2 <= w2Digit2;
			end if;
			
			-- Digit3 2 min --
			if(i1s='1' and w2Digit1=0 and w2Digit2=0 and w2Digit3=0) then
				w2Digit3 <= (others => '0');
			elsif(i1s='1' and w2Digit3=0 and w2Digit4=0) then
				w2Digit3 <= "0101";
			elsif(i1s='1' and w2Digit4=0) then
				w2Digit3 <= w2Digit3 - 1;
			else
				w2Digit3 <= w2Digit3;
			end if;
			
			-- Digit4 2 min --
			if(i1s='1' and w2Digit1=0 and w2Digit2=0 and w2Digit3=0 and w2Digit4=0) then
				w2Digit4 <= (others => '0');
			elsif(i1s='1' and w2Digit4=0) then
				w2Digit4 <= "1001";
			elsif(i1s='1') then
				w2Digit4 <= w2Digit4 - 1;
			else
				w2Digit4 <= w2Digit4;
			end if;
		else
			w2Digit1 <= w2Digit1;
			w2Digit2 <= w2Digit2;
			w2Digit3 <= w2Digit3;
			w2Digit4 <= w2Digit4;
		end if;
	end Process;

End Behavioral;

