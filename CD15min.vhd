Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity CD15min is
Port(
	CLK,Rstb : in std_logic;
	i1s : in std_logic;
	I15,iRe : in std_logic;
	o15Digit1,o15Digit2,o15Digit3,o15Digit4 : out std_logic_vector(3 downto 0)
);
End CD15min;

Architecture Behavioral of CD15min is
	signal rCnt : std_logic := '0';
	signal w15Digit1 : std_logic_vector(3 downto 0) := "0001";
	signal w15Digit2 : std_logic_vector(3 downto 0) := "0101";
	signal w15Digit3,w15Digit4 : std_logic_vector(3 downto 0);
Begin

	o15Digit1 <= w15Digit1;
	o15Digit2 <= w15Digit2;
	o15Digit3 <= w15Digit3;
	o15Digit4 <= w15Digit4;
	
	u_15min : Process(CLK,Rstb,I15,iRe)
	Begin
		if(Rstb='0' or iRe='0') then
			w15Digit1 <= "0001";
			w15Digit2 <= "0101";
			w15Digit3 <= (others => '0');
			w15Digit4 <= (others => '0');
			rCnt <= '0';
		elsif(rising_edge(CLK) and I15='0') then
			
			-- Digit1 15 min Halftime --
			if(i1s='1' and w15Digit1=0) then
				w15Digit1 <= (others => '0');
			elsif(i1s='1' and w15Digit2=0 and w15Digit3=0 and w15Digit4=0) then
				w15Digit1 <= w15Digit1 - 1;
			else
				w15Digit1 <= w15Digit1;
			end if;
			
			-- Digit2 15 min --
			if(i1s='1' and w15Digit1=0 and w15Digit2=0 and rCnt='1') then
				w15Digit2 <= (others => '0');
			elsif(i1s='1' and w15Digit2=0 and w15Digit3=0 and w15Digit4=0) then
				w15Digit2 <= "1001";
				rCnt <= '1';
			elsif(i1s='1' and w15Digit3=0 and w15Digit4=0) then
				w15Digit2 <= w15Digit2 - 1;
			else
				w15Digit2 <= w15Digit2;
			end if;
			
			-- Digit3 15 min --
			if(i1s='1' and w15Digit1=0 and w15Digit2=0 and w15Digit3=0) then
				w15Digit3 <= (others => '0');
			elsif(i1s='1' and w15Digit3=0 and w15Digit4=0) then
				w15Digit3 <= "0101";
			elsif(i1s='1' and w15Digit4=0) then
				w15Digit3 <= w15Digit3 - 1;
			else
				w15Digit3 <= w15Digit3;
			end if;
			
			-- Digit4 15 min --
			if(i1s='1' and w15Digit1=0 and w15Digit2=0 and w15Digit3=0 and w15Digit4=0) then
				w15Digit4 <= (others => '0');
			elsif(i1s='1' and w15Digit4=0) then
				w15Digit4 <= "1001";
			elsif(i1s='1') then
				w15Digit4 <= w15Digit4 - 1;
			else
				w15Digit4 <= w15Digit4;
			end if;
		else
			w15Digit1 <= w15Digit1;
			w15Digit2 <= w15Digit2;
			w15Digit3 <= w15Digit3;
			w15Digit4 <= w15Digit4;
		end if;
	end Process;

End Behavioral;

