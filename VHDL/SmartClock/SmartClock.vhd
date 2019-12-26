library ieee;
use ieee.std_logic_1164.all;

entity SmartClock is
   
 port(
				clk_50m : in  STD_LOGIC;
				sw_restn : in std_logic;
				push : in std_logic;
				
				seg_com		: out std_logic_vector(7 downto 0); -- 7segment out
				seg_out		: out std_logic_vector(7 downto 0);
				
				e, rs, rw	: out std_logic; -- lcd transMission data out
				lcd_data   	: out std_logic_vector(7 downto 0);
				
				bell			: buffer std_logic; -- piezo out
				
				--send_req		: in std_logic; -- uart to bluetooth
				rx				: in std_logic;
				tx				: out std_logic
				);
				
end SmartClock;


architecture bigpicture of SmartClock is

--component

component clock is --clock
PORT(		clk1k		: in std_logic;
			--sw_push: in std_logic;
			uart_presentTime : in std_logic_vector(23 downto 0);
			clock_presentTime : out std_logic_vector(23 downto 0);
			seg_com : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			seg_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
end component;
component clk_50m_1k is
	port(
        clk_50m : in  STD_LOGIC;
        clk_1k : out  STD_LOGIC);
end component;


component clk_50m_100k is
	port(
        clk_50m : in  STD_LOGIC;
        clk_100k : out  STD_LOGIC);
end component;


component alarm is -- alram connect to lcd and piezo
port( from_clock_presentTime 	: in std_logic_vector(23 downto 0);
		from_uart_alarmTime 	  	: in std_logic_vector(23 downto 0);
		from_uart_msg				: in std_logic_vector(127 downto 0);--not yet decision
		to_lcd_alarmTime			: out std_logic_vector(23 downto 0);
		to_lcd_msg					: out std_logic_vector(127 downto 0);--not yet decision
		to_piezo_decision			: out std_logic --decision of comparing presentTime to alarmTime
		);
end component;


component lcd_display IS	
	PORT( 	clk, resetn	: in std_logic;
		alarmTime : in std_logic_vector(23 downto 0);
		a_msg	: in std_logic_vector(127 downto 0);
		e, rs, rw	: out std_logic;
		lcd_data   	: out std_logic_vector(7 downto 0) );
END component;
		
component piezo is --piezo
port( clk_100k		: IN STD_LOGIC;
		decision		: IN STD_LOGIC;
		key			: IN STD_LOGIC;
		bell			: BUFFER STD_LOGIC 
		);
end component;


component uart_test IS
    PORT (	clk_50m			:	IN		std_logic;
				resetn			:  IN		std_logic;
				rx					:	IN		std_logic;
				tx					:	OUT	std_logic;
				--led : out std_logic_vector(7 downto 0); 
				uart_presentTime : out std_logic_vector(23 downto 0); -- recieve presenttime from bluetooth
				uart_alarmTime : out std_logic_vector(23 downto 0); --recieve alartime from blutooth
				uart_msg : out std_logic_vector(127 downto 0)	--recieve msg from bluetooth
				
				
				);
END component;

--signal
signal clk_1k : std_logic;
signal clk_100k : std_logic;
signal uart_presentTime 	: std_logic_vector(23 downto 0); --from uart to clock
signal clock_presentTime 	: std_logic_vector(23 downto 0); --from clock to Alarm
signal uart_alarmTime		: std_logic_vector(23 downto 0); --from uart to Alarm
signal uart_msg				: std_logic_vector(127 downto 0); --not yet decision
signal alarm_alarmTime		: std_logic_vector(23 downto 0); --from alarm to lcd
signal alarm_msg				: std_logic_vector(127 downto 0); --from alarm to lcd
signal alarm_decision		: std_logic; -- form alarm to piezo


begin
-- portMap
count_clk  			: clock 				port map(clk_1k, uart_presentTime,clock_presentTime, seg_com, seg_out );
covert_50m_100k 	: clk_50m_100k		port map(clk_50m,clk_100k);
covert_50m_1k		: clk_50m_1k 		port map(clk_50m,clk_1k);
compare_time		: alarm				port map(clock_presentTime, uart_alarmTime, uart_msg, alarm_alarmTime, alarm_msg,alarm_decision);
display				: lcd_display		port map(clk_1k, sw_restn, alarm_alarmTime, alarm_msg, e,rs,rw,lcd_data);
shout_bell			: piezo				port map(clk_100k, alarm_decision,push,bell);
bluetooth_uart		: uart_test			port map(clk_50m,sw_restn, rx, tx,uart_presentTime, uart_alarmTime , uart_msg);
	
	
	
--process
 

end bigpicture;