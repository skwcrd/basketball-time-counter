Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity TimeTop is
Port(
	CLK,Rstb : in std_logic;
	iPushS,iPushO,iPush10,iPush5 : in std_logic;
	-- iPushS is change state
	-- iPushO is change state to overtime
	-- iPush10 is start/stop time counts 10 min
	-- iPush5 is start/stop time counts 5 min
	Sw15,Sw2 : in std_logic;
	-- Sw15 is start/stop time counts 15 min
	-- Sw2 is start/stop time counts 2 min
	SwRe15,SwRe2 : in std_logic;
	-- SwRe15 is reset time counts 15 min
	-- SwRe2 is reset time counts 2 min
	oLED : out std_logic_vector(4 downto 0);
	oBuzz : out std_logic;
	oBCD : out std_logic_vector(6 downto 0);
	dp : out std_logic;
	com : out std_logic_vector(3 downto 0)
);
End TimeTop;

Architecture Structural of TimeTop is
	
	Component CLK1ms is
	Port(
		CLK : in std_logic;
		Rstb : in std_logic;
		o1ms : out std_logic
	);
	End Component CLK1ms;
	
	Component CLK1s is
	Port(
		CLK : in std_logic;
		Rstb : in std_logic;
		i1ms : in std_logic;
		o1s : out std_logic
	);
	End Component CLK1s;
	
	Component ScanDigit is
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
	End Component ScanDigit;
	
	Component BCD is
	Port(
		I : in std_logic_vector(3 downto 0);
		O : out std_logic_vector(6 downto 0)
	);
	End Component BCD;
	
	Component Debouce is
	Port(
		CLK : in std_logic;
		Rstb : in std_logic;
		i1ms : in std_logic;
		I : in std_logic;
		O : out std_logic
	);
	End Component Debouce;
	
	Component FSM is
	Port(
		CLK,Rstb : in std_logic;
		iState,iOver : in std_logic;
		i10Digit1,i10Digit2,i10Digit3,i10Digit4 : in std_logic_vector(3 downto 0);
		i15Digit1,i15Digit2,i15Digit3,i15Digit4 : in std_logic_vector(3 downto 0);
		i5Digit1,i5Digit2,i5Digit3,i5Digit4 : in std_logic_vector(3 downto 0);
		i2Digit1,i2Digit2,i2Digit3,i2Digit4 : in std_logic_vector(3 downto 0);
		oDigit1,oDigit2,oDigit3,oDigit4 : out std_logic_vector(3 downto 0)
	);
	End Component FSM;
	
	Component CD10min is
	Port(
		CLK,Rstb : in std_logic;
		i1ms,i1s : in std_logic;
		I10,iRe : in std_logic;
		o10Digit1,o10Digit2,o10Digit3,o10Digit4 : out std_logic_vector(3 downto 0);
		oStart,oFinish : out std_logic
	);
	End Component CD10min;

	Component CD15min is
	Port(
		CLK,Rstb : in std_logic;
		i1s : in std_logic;
		I15,iRe : in std_logic;
		o15Digit1,o15Digit2,o15Digit3,o15Digit4 : out std_logic_vector(3 downto 0)
	);
	End Component CD15min;
	
	Component CD2min is
	Port(
		CLK,Rstb : in std_logic;
		i1s : in std_logic;
		I2,iRe : in std_logic;
		o2Digit1,o2Digit2,o2Digit3,o2Digit4 : out std_logic_vector(3 downto 0)
	);
	End Component CD2min;
	
	Component Overtime5min is
	Port(
		CLK,Rstb : in std_logic;
		i1ms,i1s : in std_logic;
		I5 : in std_logic;
		o5Digit1,o5Digit2,o5Digit3,o5Digit4 : out std_logic_vector(3 downto 0);
		oStart,oFinish : out std_logic
	);
	End Component Overtime5min;
	
	Component Counts_Quarter is
	Port(
		CLK,Rstb : in std_logic;
		i1ms,i1s : in std_logic;
		iStart,iFinish : in std_logic;
		sOverC,fOverC : in std_logic;
		O_LED : out std_logic_vector(4 downto 0);
		oRe : out std_logic
	);
	End Component Counts_Quarter;
	
	Component Buzzer is
	Port(
		CLK,Rstb : in std_logic;
		i1ms,i1s : in std_logic;
		iS10,iF10,iS5,iF5 : in std_logic;
		oBuz : out std_logic
	);
	End Component Buzzer;
	
	signal w1ms,w1s : std_logic;
	signal wData : std_logic_vector(3 downto 0);
	signal w10Digit1,w10Digit2,w10Digit3,w10Digit4 : std_logic_vector(3 downto 0);
	signal w15Digit1,w15Digit2,w15Digit3,w15Digit4 : std_logic_vector(3 downto 0);
	signal w5Digit1,w5Digit2,w5Digit3,w5Digit4 : std_logic_vector(3 downto 0);
	signal w2Digit1,w2Digit2,w2Digit3,w2Digit4 : std_logic_vector(3 downto 0);
	signal wDigit1,wDigit2,wDigit3,wDigit4 : std_logic_vector(3 downto 0);
	signal wIS,wIO,wI10,wI5 : std_logic;
	signal wRe : std_logic;
	signal wStart,wFinish : std_logic;
	signal wOverS,wOverF : std_logic;
Begin

	u_CLK1ms : CLK1ms
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		o1ms	=> w1ms
	);
	
	u_CLK1s : CLK1s
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1ms	=> w1ms,
		o1s	=> w1s
	);
	
	u_PushState : Debouce
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1ms	=> w1ms,
		I		=> iPushS,
		O		=> wIS
	);
	
	u_PushOver : Debouce
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1ms	=> w1ms,
		I		=> iPushO,
		O		=> wIO
	);
	
	u_Push10 : Debouce
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1ms	=> w1ms,
		I		=> iPush10,
		O		=> wI10
	);
	
	u_Push5 : Debouce
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1ms	=> w1ms,
		I		=> iPush5,
		O		=> wI5
	);
	
	u_Counts : Counts_Quarter
	Port Map(
		CLK		=> CLK,
		Rstb		=> Rstb,
		i1ms		=> w1ms,
		i1s		=> w1s,
		iStart	=> wStart,
		iFinish	=> wFinish,
		sOverC	=> wOverS,
		fOverC	=> wOverF,
		O_LED		=> oLED,
		oRe		=> wRe
	);
	
	u_FSM : FSM
	Port Map(
		CLK			=> CLK,
		Rstb			=> Rstb,
		iState		=> wIS,
		iOver			=> wIO,
		
		i10Digit1	=> w10Digit1,
		i10Digit2	=> w10Digit2,
		i10Digit3	=> w10Digit3,
		i10Digit4	=> w10Digit4,
		
		i15Digit1	=> w15Digit1,
		i15Digit2	=> w15Digit2,
		i15Digit3	=> w15Digit3,
		i15Digit4	=> w15Digit4,
		
		i5Digit1		=> w5Digit1,
		i5Digit2		=> w5Digit2,
		i5Digit3		=> w5Digit3,
		i5Digit4		=> w5Digit4,
		
		i2Digit1		=> w2Digit1,
		i2Digit2		=> w2Digit2,
		i2Digit3		=> w2Digit3,
		i2Digit4		=> w2Digit4,
		
		oDigit1		=> wDigit1,
		oDigit2		=> wDigit2,
		oDigit3		=> wDigit3,
		oDigit4		=> wDigit4
	);
	
	u_10min : CD10min
	Port Map(
		CLK			=> CLK,
		Rstb			=> Rstb,
		i1s			=> w1s,
		i1ms			=> w1ms,
		I10			=> wI10,
		iRe			=> wRe,
		o10Digit1	=> w10Digit1,
		o10Digit2	=> w10Digit2,
		o10Digit3	=> w10Digit3,
		o10Digit4	=> w10Digit4,
		oStart		=> wStart,
		oFinish		=> wFinish
	);
	
	u_15min : CD15min
	Port Map(
		CLK			=> CLK,
		Rstb			=> Rstb,
		i1s			=> w1s,
		I15			=> Sw15,
		iRe			=> SwRe15,
		o15Digit1	=> w15Digit1,
		o15Digit2	=> w15Digit2,
		o15Digit3	=> w15Digit3,
		o15Digit4	=> w15Digit4
	);
	
	u_2min : CD2min
	Port Map(
		CLK		=> CLK,
		Rstb		=> Rstb,
		i1s		=> w1s,
		I2			=> Sw2,
		iRe		=> SwRe2,
		o2Digit1	=> w2Digit1,
		o2Digit2	=> w2Digit2,
		o2Digit3	=> w2Digit3,
		o2Digit4	=> w2Digit4
	);
	
	u_5min : Overtime5min
	Port Map(
		CLK		=> CLK,
		Rstb		=> Rstb,
		i1s		=> w1s,
		i1ms		=> w1ms,
		I5			=> wI5,
		o5Digit1	=> w5Digit1,
		o5Digit2	=> w5Digit2,
		o5Digit3	=> w5Digit3,
		o5Digit4	=> w5Digit4,
		oStart	=> wOverS,
		oFinish	=> wOverF
	);
	
	u_Buz : Buzzer
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1ms	=> w1ms,
		i1s	=> w1s,
		iS10	=> wStart,
		iF10	=> wFinish,
		iS5	=> wOverS,
		iF5	=> wOverF,
		oBuz	=> oBuzz
	);
	
	u_ScanDigit : ScanDigit
	Port Map(
		CLK		=> CLK,
		Rstb		=> Rstb,
		i1ms		=> w1ms,
		iDigit1	=> wDigit1,
		iDigit2	=> wDigit2,
		iDigit3	=> wDigit3,
		iDigit4	=> wDigit4,
		oDigit	=> com,
		oData		=> wData,
		dp			=> dp
	);
	
	u_BCD : BCD
	Port Map(
		I	=> wData,
		O	=> oBCD
	);

End Structural;

