Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity CLK1ms is
Port(
	CLK : in std_logic;
	Rstb : in std_logic;
	o1ms : out std_logic
);
End CLK1ms;

Architecture Behavioral of CLK1ms is
	signal rCnt : std_logic_vector(14 downto 0);
	signal r1ms : std_logic;
Begin

	o1ms <= r1ms;
	
	u_rClk : Process(CLK,Rstb)
	begin
		if(Rstb = '0') then
			rCnt <= (others => '0');
			r1ms <= '0';
		elsif(rising_edge(CLK)) then
			if(rCnt = 24999) then
				rCnt <= (others => '0');
				r1ms <= '1';
			else
				rCnt <= rCnt + 1;
				r1ms <= '0';
			end if;
		end if;
	end Process;

End Behavioral;
