LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;


ENTITY uart_test IS
    PORT (	clk_50m			:	IN		std_logic;
				resetn			:  IN		std_logic;
				rx					:	IN		std_logic;
				tx					:	OUT	std_logic;
				--led : out std_logic_vector(7 downto 0); 
				uart_presentTime : out std_logic_vector(23 downto 0); -- recieve presenttime from bluetooth
				uart_alarmTime : out std_logic_vector(23 downto 0); --recieve alartime from blutooth
				uart_msg : out std_logic_vector(127 downto 0)	--recieve msg from bluetooth
				
				
				);
END uart_test;

ARCHITECTURE sample OF uart_test IS
	----------------------------------------------------------------------------
	-- UART constants
	----------------------------------------------------------------------------
	CONSTANT BAUD_RATE              : POSITIVE := 9600;
	CONSTANT CLOCK_FREQUENCY        : POSITIVE := 50000000;
    
	----------------------------------------------------------------------------
	-- Component declarations
	----------------------------------------------------------------------------
	COMPONENT UART IS
		GENERIC (	BAUD_RATE           : POSITIVE;
						CLOCK_FREQUENCY     : POSITIVE );
						
		PORT (	CLOCK               :   IN      std_logic;
					RESET               :   IN      std_logic;    
					DATA_STREAM_IN      :   IN      std_logic_vector(7 downto 0);
					DATA_STREAM_IN_STB  :   IN      std_logic;
					DATA_STREAM_IN_ACK  :   OUT     std_logic;
					DATA_STREAM_OUT     :   OUT     std_logic_vector(7 downto 0);
					DATA_STREAM_OUT_STB :   OUT     std_logic;
					DATA_STREAM_OUT_ACK :   IN      std_logic;
					TX                  :   OUT     std_logic;
					RX                  :   IN      std_logic );
		END COMPONENT UART;
	
	
	----------------------------------------------------------------------------
	-- UART signals
	----------------------------------------------------------------------------
   SIGNAL clk_1k : std_logic;
	
	SIGNAL uart_data_in				: std_logic_vector(7 downto 0);
	SIGNAL uart_data_out				: std_logic_vector(7 downto 0);
	SIGNAL uart_data_in_stb			: std_logic;
	SIGNAL uart_data_in_ack			: std_logic;
	SIGNAL uart_data_out_stb		: std_logic;
	SIGNAL uart_data_out_ack		: std_logic;
	
	--signal uart_val : std_logic_vector(63 downto 0):= ( others => '1');
	
begin

    ----------------------------------------------------------------------------
    -- UART instantiation
    ----------------------------------------------------------------------------

	UART_inst : UART
		GENERIC map (	BAUD_RATE           => BAUD_RATE,
							CLOCK_FREQUENCY     => CLOCK_FREQUENCY )
		PORT map	(	CLOCK               => clk_50m,
						RESET               => resetn,
						DATA_STREAM_IN      => uart_data_in,
						DATA_STREAM_IN_STB  => uart_data_in_stb,
						DATA_STREAM_IN_ACK  => uart_data_in_ack,
						DATA_STREAM_OUT     => uart_data_out,
						DATA_STREAM_OUT_STB => uart_data_out_stb,
						DATA_STREAM_OUT_ACK => uart_data_out_ack,
						TX                  => tx,
						RX                  => rx );
	
	
   
	
	P_RECEIVE : process (clk_50m)
	
	variable cnt : integer range 0 to 300 :=0;
	variable sel : integer range 0 to 2 :=0;
	variable save : std_logic; -- 
	
	begin
		IF rising_edge(clk_50m) THEN
			IF resetn = '0' THEN
				uart_data_out_ack <= '0';
				uart_alarmTime <= (others => '0');
				uart_msg <= (others => '0');
				uart_presentTime <= (others => '0');
			ELSE
				uart_data_out_ack <= '0';
				IF uart_data_out_stb = '1' THEN
					uart_data_out_ack   <= '1'; --recieve
					save := not save; -- interence twice execute
					if(save = '1') then
						if(uart_data_out = x"21") then -- choice to presentTime
							cnt :=0;
							sel := 0;
							uart_presentTime<=(others=>'0');
						elsif(uart_data_out = x"22")then -- choice to alarmTime
							cnt :=0;
							sel := 1;
							uart_alarmTime<=(others =>'0');
						elsif (uart_data_out = x"23")then -- choice to msg
							cnt :=0;
							sel := 2;
							uart_msg<=(x"20"&x"20"&x"20"&x"20"&x"20"&x"20"&x"20"&x"20"&x"20"&x"20"&x"20"&x"20"&x"20"&x"20"&x"20"&x"20");
						else
							if(sel = 0 ) then -- time is 4byte
								uart_presentTime(cnt+3 downto cnt) <=  uart_data_out(3 downto 0);
								cnt := cnt+4;
							
							elsif(sel = 1 ) then
								uart_alarmTime(cnt+3 downto cnt) <=  uart_data_out(3 downto 0);
								cnt := cnt+4;
							elsif(sel = 2 ) then
								uart_msg(cnt+7 downto cnt) <= uart_data_out;
								cnt := cnt+8;
						
							end if;
						end if;
					end if;					
				END IF;
			END IF;
		END IF;
	END process;
	
END sample;
