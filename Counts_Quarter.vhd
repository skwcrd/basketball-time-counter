Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Counts_Quarter is
Port(
	CLK,Rstb : in std_logic;
	i1ms,i1s : in std_logic;
	iStart,iFinish : in std_logic;
	sOverC,fOverC : in std_logic;
	O_LED : out std_logic_vector(4 downto 0);
	oRe : out std_logic
);
End Counts_Quarter;

Architecture Behavioral of Counts_Quarter is
	type State_Type is (S1,S2,S3,S4);
	signal state : State_Type;
	signal wO : std_logic_vector(3 downto 0);
	signal wS,wF,wRe : std_logic := '0';
	signal wOver : std_logic;
	signal wSO,wSOv : std_logic := '0';
Begin

	O_LED <= wOver & wO;
	oRe <= wRe;
	
	u_Count1 : Process(CLK,Rstb,wRe)
	Begin
		if(Rstb='0' or wRe='1') then
			wS <= '0';
			wF <= '0';
		elsif(rising_edge(CLK)) then
			if(iStart='1') then
				wS <= '1';
				wF <= '0';
			elsif(iFinish='1') then
				wF <= '1';
				wS <= '0';
			else
				wS <= wS;
				wF <= wF;
			end if;
		end if;
	end Process;
	
	u_Count2 : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			wO <= (others => '0');
			state <= S1;
		elsif(rising_edge(CLK)) then
			case state is
				when S1 => 	if(i1s='1' and wS='1') then
									wO(0) <= not wO(0);
									wRe <= '0';
								elsif(i1ms='1' and wF='1') then
									wO(0) <= '1';
									wRe <= '1';
									state <= S2;
								else
									wO(0) <= wO(0);
									wRe <= '0';
								end if;
								
				when S2 => 	if(i1s='1' and wS='1') then
									wO(1) <= not wO(1);
									wRe <= '0';
								elsif(i1ms='1' and wF='1') then
									wO(1) <= '1';
									wRe <= '1';
									state <= S3;
								else
									wO(1) <= wO(1);
									wRe <= '0';
								end if;
								
				when S3 => 	if(i1s='1' and wS='1') then
									wO(2) <= not wO(2);
									wRe <= '0';
								elsif(i1ms='1' and wF='1') then
									wO(2) <= '1';
									wRe <= '1';
									state <= S4;
								else
									wO(2) <= wO(2);
									wRe <= '0';
								end if;
								
				when S4 => 	if(i1s='1' and wS='1') then
									wO(3) <= not wO(3);
									wRe <= '0';
								elsif(i1ms='1' and wF='1') then
									wO(3) <= '1';
									wRe <= '0';
								else
									wO(3) <= wO(3);
									wRe <= '0';
								end if;
								
				when others => state <= S1;
			end case;
		end if;
	end Process;
	
	u_CountO1 : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			wSO <= '0';
			wSOv <= '0';
		elsif(rising_edge(CLK)) then
			if(sOverC='1') then
				wSO <= '1';
				wSOv <= '0';
			elsif(fOverC='1') then
				wSOv <= '1';
				wSO <= '0';
			else
				wSO <= wSO;
				wSOv <= wSOv;
			end if;
		end if;
	end Process;
	
	u_CountO2 : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			wOver <= '0';
		elsif(rising_edge(CLK)) then
			if(i1s='1' and wSO='1') then
				wOver <= not wOver;
			elsif(i1ms='1' and wSOv='1') then
				wOver <= '1';
			else
				wOver <= wOver;
			end if;
		end if;
	end Process;

End Behavioral;

