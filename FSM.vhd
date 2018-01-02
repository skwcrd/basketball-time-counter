Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity FSM is
Port(
	CLK,Rstb : in std_logic;
	iState,iOver : in std_logic;
	i10Digit1,i10Digit2,i10Digit3,i10Digit4 : in std_logic_vector(3 downto 0);
	i15Digit1,i15Digit2,i15Digit3,i15Digit4 : in std_logic_vector(3 downto 0);
	i5Digit1,i5Digit2,i5Digit3,i5Digit4 : in std_logic_vector(3 downto 0);
	i2Digit1,i2Digit2,i2Digit3,i2Digit4 : in std_logic_vector(3 downto 0);
	oDigit1,oDigit2,oDigit3,oDigit4 : out std_logic_vector(3 downto 0)
);
End FSM;

Architecture Behavioral of FSM is
	type State_Type is (S0,S1,S2,S3);
	signal curr_state,next_state : State_Type;
	signal wDigit1,wDigit2,wDigit3,wDigit4 : std_logic_vector(3 downto 0);
Begin

	oDigit1 <= wDigit1;
	oDigit2 <= wDigit2;
	oDigit3 <= wDigit3;
	oDigit4 <= wDigit4;
	
	---------- REGISTOR STATE ----------
	u_rState : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			curr_state <= S0;
		elsif(rising_edge(CLK)) then
			curr_state <= next_state;
		else
			curr_state <= curr_state;
		end if;
	End Process;
	
	---------- CHANGE STATE ----------
	u_State : Process(curr_state,iState,iOver)
	Begin
		case curr_state is
			when S0 => 	if(iState='1') then
								next_state <= S1;
							elsif(iOver='1') then
								next_state <= S3;
							else
								next_state <= S0;
							end if;
				
			when S1 => 	if(iState='1') then
								next_state <= S2;
							elsif(iOver='1') then
								next_state <= S3;
							else
								next_state <= S1;
							end if;
				
			when S2 => 	if(iState='1') then
								next_state <= S0;
							elsif(iOver='1') then
								next_state <= S3;
							else
								next_state <= S2;
							end if;
				
			when S3 => 	if(iOver='1') then
								next_state <= S0;
							elsif(iState='1') then
								next_state <= S0;
							else
								next_state <= S3;
							end if;
				
			when others => next_state <= S0;
		end case;
	End Process;
	
	---------- OUTPUT STATE DIGIT ----------
	u_oState : Process(CLK)
	Begin
		if(rising_edge(CLK)) then
			case curr_state is
				when S0 =>	wDigit1 <= i10Digit1;
								wDigit2 <= i10Digit2;
								wDigit3 <= i10Digit3;
								wDigit4 <= i10Digit4;
								
				when S1 =>	wDigit1 <= i15Digit1;
								wDigit2 <= i15Digit2;
								wDigit3 <= i15Digit3;
								wDigit4 <= i15Digit4;
								
				when S2 =>	wDigit1 <= i2Digit1;
								wDigit2 <= i2Digit2;
								wDigit3 <= i2Digit3;
								wDigit4 <= i2Digit4;
								
				when S3 =>	wDigit1 <= i5Digit1;
								wDigit2 <= i5Digit2;
								wDigit3 <= i5Digit3;
								wDigit4 <= i5Digit4;
			end case;
		else
			wDigit1 <= wDigit1;
			wDigit2 <= wDigit2;
			wDigit3 <= wDigit3;
			wDigit4 <= wDigit4;
		end if;
	End Process;

End Behavioral;

