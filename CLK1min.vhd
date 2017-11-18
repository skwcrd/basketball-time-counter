Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity CLK1min is
Port(
	CLK : in std_logic;
	Rstb : in std_logic;
	i1s : in std_logic;
	o1min : out std_logic
);
End CLK1min;

Architecture Behavioral of CLK1min is
	signal rCnt : std_logic_vector(5 downto 0);
	signal r1min : std_logic;
Begin

	o1min <= r1min;
	
	u_rCnt : Process(CLK,Rstb)
	begin
		if(Rstb = '0') then
			rCnt <= (others => '0');
			r1min <= '0';
		elsif(rising_edge(CLK)) then
			if(rCnt = 59 and i1s = '1') then
				rCnt <= (others => '0');
				r1min <= '1';
			elsif(i1s = '1') then
				rCnt <= rCnt + 1;
				r1min <= '0';
			else
				rCnt <= rCnt;
				r1min <= '0';
			end if;
		end if;
	end Process;

End Behavioral;
