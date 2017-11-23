Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Buzzer is
Port(
	CLK,Rstb : in std_logic;
	i1ms,i1s : in std_logic;
	iS10,iF10,iS5,iF5 : in std_logic;
	oBuz : out std_logic
);
End Buzzer;

Architecture Behavioral of Buzzer is
	signal wBuz1,wBuz2 : std_logic := '0';
	signal wI1,wI2 : std_logic := '0';
	signal wO1,wO2 : std_logic := '0';
	signal rCnt1,rCnt2 : std_logic := '0';
	signal wRe : std_logic := '0';
	signal num : std_logic_vector(1 downto 0) := "00";
Begin

	oBuz <= 	wBuz1 when wI1='1' else
				wBuz2 when wI2='1' else
				'0';
	
	u_BuzSF : Process(CLK,Rstb,wRe)
	Begin
		if(Rstb='0' or wRe='1') then
			wI1 <= '0';
			wI2 <= '0';
		elsif(rising_edge(CLK)) then
			if(iS10='1' or iS5='1') then
				wI1 <= '1';
				wI2 <= '0';
			elsif(iF10='1' or iF5='1') then
				wI2 <= '1';
				wI1 <= '0';
			else
				wI1 <= wO1;
				wI2 <= wO2;
			end if;
		end if;
	end Process;
	
	u_BuzStart : Process(CLK,Rstb,wI1,wRe)
	Begin
		if(Rstb='0' or wRe='1') then
			wBuz1 <= '0';
			rCnt1 <= '1';
			wO1 <= '0';
		elsif(rising_edge(CLK) and wI1='1') then
			if(i1ms='1' and rCnt1='1' and wBuz1='0') then
				wBuz1 <= not wBuz1;
				rCnt1 <= '0';
				wO1 <= '1';
			elsif(i1s='1' and rCnt1='0') then
				wBuz1 <= '0';
				wO1 <= '0';
			else
				wBuz1 <= wBuz1;
				wO1 <= wO1;
			end if;
		else
			wBuz1 <= wBuz1;
			wO1 <= wO1;
		end if;
	end Process;
	
	u_BuzFinish : Process(CLK,Rstb,wI2,wRe)
	Begin
		if(Rstb='0' or wRe='1') then
			wBuz2 <= '0';
			rCnt2 <= '1';
			wO2 <= '0';
			num <= (others => '0');
			wRe <= '0';
		elsif(rising_edge(CLK) and wI2='1') then
			if(i1ms='1' and rCnt2='1' and wBuz2='0') then
				wBuz2 <= not wBuz2;
				rCnt2 <= '0';
				wO2 <= '1';
			elsif(i1s='1' and rCnt2='0') then
				num <= num + 1;
				if(num>2) then
					wBuz2 <= '0';
					wO2 <= '0';
					wRe <= '1';
				else
					wBuz2 <= '1';
					wO2 <= '1';
					wRe <= '0';
				end if;
			else
				wBuz2 <= wBuz2;
				wO2 <= wO2;
				wRe <= wRe;
			end if;
		else
			wBuz2 <= wBuz2;
			wO2 <= wO2;
			wRe <= wRe;
		end if;
	end Process;

End Behavioral;

