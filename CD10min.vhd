Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity CD10min is
Port(
	CLK,Rstb : in std_logic;
	i1ms,i1s : in std_logic;
	I10,iRe : in std_logic;
	o10Digit1,o10Digit2,o10Digit3,o10Digit4 : out std_logic_vector(3 downto 0);
	oStart,oFinish : out std_logic
);
End CD10min;

Architecture Behavioral of CD10min is
	signal wS10,rCnt : std_logic := '0';
	signal w10Digit1 : std_logic_vector(3 downto 0) := "0001";
	signal w10Digit2,w10Digit3,w10Digit4 : std_logic_vector(3 downto 0);
	signal wStart,wFinish : std_logic := '0';
Begin

	o10Digit1 <= w10Digit1;
	o10Digit2 <= w10Digit2;
	o10Digit3 <= w10Digit3;
	o10Digit4 <= w10Digit4;
	
	oStart <= wStart;
	oFinish <= wFinish;
	
	u_Push : Process(CLK,Rstb,iRe)
	Begin
		if(Rstb='0' or iRe='1') then
			wFinish <= '0';
			wS10 <= '0';
			rCnt <= '0';
		elsif(rising_edge(CLK)) then
			if(I10='1') then
				wS10 <= not wS10;
				wFinish <= '0';
				rCnt <= '1';
			elsif(i1s='1' and rCnt='0') then
				wFinish <= '0';
				rCnt <= '0';
			elsif(i1ms='1' and w10Digit1=0 and w10Digit2=0 and w10Digit3=0 and w10Digit4=0 and rCnt='1') then
				wS10 <= '0';
				wFinish <= '1';
				rCnt <= '0';
			else
				wS10 <= wS10;
				wFinish <= wFinish;
				rCnt <= rCnt;
			end if;
		end if;
	end Process;
	
	u_10min : Process(CLK,Rstb,wS10,iRe)
	Begin
		if(Rstb='0' or iRe='1') then
			w10Digit1 <= "0001";
			w10Digit2 <= (others => '0');
			w10Digit3 <= (others => '0');
			w10Digit4 <= (others => '0');
			wStart <= '0';
		elsif(rising_edge(CLK) and wS10='1') then
			
			-- Digit1 10 min time standard 4 quarter --
			if(i1s='1' and w10Digit1=0) then
				w10Digit1 <= w10Digit1;
				wStart <= '0';
			elsif(i1ms='1' and w10Digit1>=1) then
				wStart <= '1';
			elsif(i1s='1') then
				w10Digit1 <= w10Digit1 - 1;
				wStart <= '0';
			else
				w10Digit1 <= w10Digit1;
				wStart <= wStart;
			end if;
			
			-- Digit2 10 min --
			if(i1s='1' and w10Digit1=0 and w10Digit2=0) then
				w10Digit2 <= w10Digit2;
			elsif(i1s='1' and w10Digit2=0) then
				w10Digit2 <= "1001";
			elsif(i1s='1' and w10Digit3=0 and w10Digit4=0) then
				w10Digit2 <= w10Digit2 - 1;
			else
				w10Digit2 <= w10Digit2;
			end if;
			
			-- Digit3 10 min --
			if(i1s='1' and w10Digit1=0 and w10Digit2=0 and w10Digit3=0) then
				w10Digit3 <= w10Digit3;
			elsif(i1s='1' and w10Digit3=0 and w10Digit4=0) then
				w10Digit3 <= "0101";
			elsif(i1s='1' and w10Digit4=0) then
				w10Digit3 <= w10Digit3 - 1;
			else
				w10Digit3 <= w10Digit3;
			end if;
			
			-- Digit4 10 min --
			if(i1s='1' and w10Digit1=0 and w10Digit2=0 and w10Digit3=0 and w10Digit4=0) then
				w10Digit4 <= w10Digit4;
			elsif(i1s='1' and w10Digit4=0) then
				w10Digit4 <= "1001";
			elsif(i1s='1') then
				w10Digit4 <= w10Digit4 - 1;
			else
				w10Digit4 <= w10Digit4;
			end if;
		else
			w10Digit1 <= w10Digit1;
			w10Digit2 <= w10Digit2;
			w10Digit3 <= w10Digit3;
			w10Digit4 <= w10Digit4;
			wStart <= wStart;
		end if;
	end Process;

End Behavioral;

