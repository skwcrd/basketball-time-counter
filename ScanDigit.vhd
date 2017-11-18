Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity ScanDigit is
Port(
	CLK : in std_logic;
	Rstb : in std_logic;
	i1ms : in std_logic;
	iDigit1 : in std_logic_vector(3 downto 0);
	iDigit2 : in std_logic_vector(3 downto 0);
	iDigit3 : in std_logic_vector(3 downto 0);
	iDigit4 : in std_logic_vector(3 downto 0);
	oDigit : out std_logic_vector(3 downto 0);
	oData : out std_logic_vector(3 downto 0);
	dp : out std_logic
);
End ScanDigit;

Architecture Behavioral of ScanDigit is
	signal rCnt : std_logic_vector(3 downto 0);
	signal rCnt500ms : std_logic_vector(8 downto 0);
	signal rShift : std_logic_vector(3 downto 0);
	signal rCnP : std_logic;
Begin

	oDigit <= rShift;
	
	dp <= rCnP when rShift="1011" or rShift="1101" else '0';
	
	u_rCnt : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			rCnP <= '0';
		elsif(rising_edge(CLK)) then
			if(rCnt500ms = 499 and i1ms = '1') then
				rCnt500ms <= (others => '0');
				rCnP <= not rCnP;
			elsif(i1ms = '1') then
				rCnt500ms <= rCnt500ms + 1;
			else
				rCnt500ms <= rCnt500ms;
				rCnP <= rCnP;
			end if;
		end if;
	end Process;
	
	oData <= iDigit4 when rShift="0111" else
				iDigit3 when rShift="1011" else
				iDigit2 when rShift="1101" else
				iDigit1;
	
	u_rCnP : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			rCnt <= (others => '0');
			rShift <= "0111";
		elsif(rising_edge(CLK)) then
			if(rCnt=4 and i1ms='1') then
				rCnt <= (others => '0');
				rShift <= rShift(0) & rShift(3 downto 1);
			elsif(i1ms = '1') then
				rCnt <= rCnt + 1;
				rShift <= rShift;
			else
				rCnt <= rCnt;
				rShift <= rShift;
			end if;
		end if;
	end Process;

End Behavioral;

