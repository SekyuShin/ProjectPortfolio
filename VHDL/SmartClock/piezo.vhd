
--
--	CLK : 100kHz
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY piezo IS
	PORT( 
		clk_100k		: IN STD_LOGIC;
		decision		: IN STD_LOGIC;
		key			: IN STD_LOGIC;
		bell			: BUFFER STD_LOGIC );
END piezo;

ARCHITECTURE sample OF piezo IS 
	CONSTANT LDO : INTEGER RANGE 0 TO 255 := 190;		-- 100000/261.6256/2-1
	CONSTANT RE : INTEGER RANGE 0 TO 255 := 169;		-- 100000/293.6648/2-1
	CONSTANT MI : INTEGER RANGE 0 TO 255 := 151;
	CONSTANT FA : INTEGER RANGE 0 TO 255 := 142;
	CONSTANT SO : INTEGER RANGE 0 TO 255 := 127;
	CONSTANT RA : INTEGER RANGE 0 TO 255 := 113;
	CONSTANT SI : INTEGER RANGE 0 TO 255 := 100;
	CONSTANT HDO : INTEGER RANGE 0 TO 255 := 95;		-- 100000/523.2511/2-1

	SIGNAL cnt	: INTEGER RANGE 0 TO 255;
	SIGNAL freq	: INTEGER RANGE 0 TO 255;

BEGIN
PROCESS(decision,key)
	variable pre_decision : std_logic;
	BEGIN
		if pre_decision/=decision then
			if(decision='1' and pre_decision ='0') then
				freq<=HDO;
			end if;
			
			pre_decision:=decision;
			
		elsif key='1' then
			freq<=0;
		end if;
end process;

PROCESS( clk_100k)
	BEGIN
		IF clk_100k'EVENT AND clk_100k = '1' THEN
			IF cnt >= freq THEN 
				cnt <= 0;
				bell <= NOT bell;
			ELSE
				cnt <= cnt + 1;
			END IF;
		END IF;
	END PROCESS;
END sample;