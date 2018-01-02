Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity CLK1s is
Port(
	CLK : in std_logic;
	Rstb : in std_logic;
	i1ms : in std_logic;
	o1s : out std_logic
);
End CLK1s;

Architecture Behavioral of CLK1s is
	signal rCnt : std_logic_vector(9 downto 0);
	signal r1s : std_logic;
Begin

	o1s <= r1s;
	
	u_rCnt : Process(CLK,Rstb)
	begin
		if(Rstb = '0') then
			rCnt <= (others => '0');
			r1s <= '0';
		elsif(rising_edge(CLK)) then
			if(rCnt = 999 and i1ms = '1') then
				rCnt <= (others => '0');
				r1s <= '1';
			elsif(i1ms = '1') then
				rCnt <= rCnt + 1;
				r1s <= '0';
			else
				rCnt <= rCnt;
				r1s <= '0';
			end if;
		end if;
	end Process;

End Behavioral;
