Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

Entity Debouce is
Port(
	CLK : in std_logic;
	Rstb : in std_logic;
	i1ms : in std_logic;
	I : in std_logic;
	O : out std_logic
);
End Debouce;

Architecture Behavioral of Debouce is
	signal rCnt : std_logic_vector(2 downto 0);
	signal rDebouce : std_logic_vector(3 downto 0);
	signal rTick : std_logic;
Begin

	-- out zone --
	-- O <= '1' when rDebouce = "1100" else '0';
	--------------
	
	-- register zone --
	u_rTick : Process(CLK,Rstb)
	Begin
		if(Rstb = '0') then
			rTick <= '0';
			O <= '0';
		elsif(rising_edge(CLK)) then
			if(rTick = '1' and rDebouce = "1100") then
				rTick <= '1';
				O <= '0';
			elsif(rTick = '0' and rDebouce = "1100") then
				rTick <= '1';
				O <= '1';
			else
				rTick <= '0';
				O <= '0';
			end if;
		end if;
	End Process;
	
	u_rCnt : Process(CLK,Rstb)
	Begin
		if(Rstb = '0') then
			rCnt <= (others => '0');
			rDebouce <= (others => '0');
		elsif(rising_edge(CLK)) then
			if(i1ms = '1' and rCnt = 4) then
				rCnt <= (others => '0');
				rDebouce <= rDebouce(2 downto 0) & I;
			elsif(i1ms = '1') then
				rCnt <= rCnt + 1;
				rDebouce <= rDebouce;
			else
				rCnt <= rCnt;
				rDebouce <= rDebouce;
			end if;
		end if;
	End Process;
	--------------------

end Behavioral;

