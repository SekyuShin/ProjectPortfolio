library ieee; 
use ieee.std_logic_1164.all;

ENTITY clock IS
	PORT(	clk1k		: in std_logic;
			--sw_push: in std_logic;
			uart_presentTime : in std_logic_vector(23 downto 0);
			clock_presentTime : out std_logic_vector(23 downto 0);
			seg_com : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			seg_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			
			);
END clock;

ARCHITECTURE port_clock of Clock IS
	COMPONENT D_7SEG
	PORT(	
		CLK : IN STD_LOGIC;				-- 1kHz
		DIN : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		SEG_COM : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	-- 7-SEGMENT COMMON SELECT 
		SEG_DATA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)	);
	END COMPONENT;
	
	COMPONENT d_Watch
	port(
		clk1k		: in std_logic;
		--sw_push	: in std_logic;
		uart_presentTime : in std_logic_vector(23 downto 0);
		disp_val		: OUT STD_LOGIC_VECTOR(23 DOWNTO 0) := (others => '0'));	
	END COMPONENT;
	
	SIGNAL val : STD_LOGIC_VECTOR(23 DOWNTO 0);
BEGIN

	stw : d_Watch PORT MAP ( clk1k,uart_presentTime, val);
	seg : D_7SEG PORT MAP( clk1k,val,seg_com,seg_data );
	p_out : process (val)
	begin
		clock_presentTime <= val;
	end process;

END port_clock;
		
		

