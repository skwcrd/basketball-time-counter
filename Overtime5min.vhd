Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Overtime5min is
Port(
	CLK,Rstb : in std_logic;
	i1ms,i1s : in std_logic;
	I5 : in std_logic;
	o5Digit1,o5Digit2,o5Digit3,o5Digit4 : out std_logic_vector(3 downto 0);
	oStart,oFinish : out std_logic
);
End Overtime5min;

Architecture Behavioral of Overtime5min is
	signal wS5,rCnt : std_logic := '0';
	signal w5Digit2 : std_logic_vector(3 downto 0) := "0101";
	signal w5Digit1,w5Digit3,w5Digit4 : std_logic_vector(3 downto 0);
	signal wStart,wFinish : std_logic := '0';
Begin

	o5Digit1 <= w5Digit1;
	o5Digit2 <= w5Digit2;
	o5Digit3 <= w5Digit3;
	o5Digit4 <= w5Digit4;
	
	oStart <= wStart;
	oFinish <= wFinish;
	
	u_Push : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			wS5 <= '0';
			wFinish <= '0';
			rCnt <= '0';
		elsif(rising_edge(CLK)) then
			if(I5='1') then
				wS5 <= not wS5;
				wFinish <= '0';
				rCnt <= '1';
			elsif(i1s='1' and rCnt='0') then
				wFinish <= '0';
				rCnt <= '0';
			elsif(i1ms='1' and w5Digit1=0 and w5Digit2=0 and w5Digit3=0 and w5Digit4=0 and rCnt='1') then
				wS5 <= '0';
				wFinish <= '1';
				rCnt <= '0';
			else
				wS5 <= wS5;
				wFinish <= wFinish;
				rCnt <= rCnt;
			end if;
		end if;
	end Process;
	
	u_5min : Process(CLK,Rstb,wS5)
	Begin
		if(Rstb='0') then
			w5Digit1 <= (others => '0');
			w5Digit2 <= "0101";
			w5Digit3 <= (others => '0');
			w5Digit4 <= (others => '0');
			wStart <= '0';
		elsif(rising_edge(CLK) and wS5='1') then
			
			-- Digit1 5 min Overtime --
			w5Digit1 <= (others => '0');
			
			-- Digit2 5 min --
			if(i1s='1' and w5Digit1=0 and w5Digit2=0) then
				w5Digit2 <= (others => '0');
				wStart <= '0';
			elsif(i1ms='1' and w5Digit2>=5) then
				wStart <= '1';
			elsif(i1s='1' and w5Digit2>=5) then
				w5Digit2 <= w5Digit2 - 1;
				wStart <= '0';
			elsif(i1s='1' and w5Digit3=0 and w5Digit4=0) then
				w5Digit2 <= w5Digit2 - 1;
				wStart <= '0';
			else
				w5Digit2 <= w5Digit2;
				wStart <= wStart;
			end if;
			
			-- Digit3 5 min --
			if(i1s='1' and w5Digit1=0 and w5Digit2=0 and w5Digit3=0) then
				w5Digit3 <= (others => '0');
			elsif(i1s='1' and w5Digit3=0 and w5Digit4=0) then
				w5Digit3 <= "0101";
			elsif(i1s='1' and w5Digit4=0) then
				w5Digit3 <= w5Digit3 - 1;
			else
				w5Digit3 <= w5Digit3;
			end if;
			
			-- Digit4 5 min --
			if(i1s='1' and w5Digit1=0 and w5Digit2=0 and w5Digit3=0 and w5Digit4=0) then
				w5Digit4 <= (others => '0');
			elsif(i1s='1' and w5Digit4=0) then
				w5Digit4 <= "1001";
			elsif(i1s='1') then
				w5Digit4 <= w5Digit4 - 1;
			else
				w5Digit4 <= w5Digit4;
			end if;
		else
			w5Digit1 <= w5Digit1;
			w5Digit2 <= w5Digit2;
			w5Digit3 <= w5Digit3;
			w5Digit4 <= w5Digit4;
			wStart <= wStart;
		end if;
	end Process;

End Behavioral;

