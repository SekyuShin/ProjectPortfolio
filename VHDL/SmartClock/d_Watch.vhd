
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_Watch is
	port(
		clk1k		: in std_logic;
		--sw_push : in std_logic;
		uart_presentTime : in std_logic_vector(23 downto 0);
		disp_val		: OUT STD_LOGIC_VECTOR(23 DOWNTO 0) := (others => '0'));
		
end d_Watch;


architecture c_Clock of d_Watch is
	signal cnt1k	: integer range 0 to 999;
	signal cntsec : integer range 0 to 30; 
	signal clk_min : std_logic; 
	signal clk_sec	: std_logic;
	signal sec, min, hour : integer range 0 to 99;
	signal toggle : std_logic; --++++
	

	
	begin
	
	present_checking : process(clk_sec)
	variable pre_presentTime : std_logic_vector(23 downto 0);--+++
	
	begin
		if( clk_sec'event and clk_sec ='1') then
			if(pre_presentTime /= uart_presentTime and toggle ='0') then--+++
				pre_presentTime := uart_presentTime;
				toggle <='1';
				
			elsif(toggle ='1') then--+++
		
				toggle <='0';
				
			end if;
		
		end if;
	end process;
	
	

	P1 : process( clk1k)	
	begin
		if( clk1k'event and clk1k ='1') then
			if( cnt1k = 249 ) then				
					cnt1k <= 0;
					clk_sec <= not clk_sec;										
			else
					cnt1k <= cnt1k + 1;
				
			end if;
		
		end if;
	end process;
	PSEC : process( clk_sec,toggle)
	begin
		if( clk_sec'event and clk_sec ='1' ) then
			if(toggle ='1') then
				sec <= to_integer(unsigned(uart_presentTime(19 downto 16)))*10 + to_integer(unsigned(uart_presentTime(23 downto 20))); --test 
				
			elsif( sec /= 59 ) then
				sec <= sec + 1; ----1
			else
				sec <= 0;
			end if;
		end if;
	end process;

	PMIN : process(clk_sec,toggle)									
	begin
		if( clk_sec'event and clk_sec ='1' ) then
			if(toggle ='1') then
				min <= to_integer(unsigned(uart_presentTime(11 downto 8)))*10 + to_integer(unsigned(uart_presentTime(15 downto 12)));

			elsif( sec = 59 ) then											
				if( min /= 59 ) then											
					min <= min + 1;
				else
					min <= 0;
				end if;
			end if;
			
			
		end if;
	end process;
	
	PHOUR : process( clk_sec,toggle)
	begin
		if(clk_sec'event and clk_sec = '1') then
			if(toggle ='1') then
				hour <= to_integer(unsigned(uart_presentTime(3 downto 0)))*10 + to_integer(unsigned(uart_presentTime(7 downto 4)));

			elsif( min = 59 and sec =59) then --
				if( hour /=23) then 
					hour <=hour + 1;
				else 
					hour <=0;
				end if;
			end if;
			
			
		end if;
	end process;

	P_OUT : process(sec, min, hour)
		variable sec_base, sec_10, min_base, min_10, hour_base,hour_10 : INTEGER range 0 to 9;
	begin
			sec_10 := sec / 10;
			sec_base := sec - sec_10 * 10;								
			min_10 := min / 10;
			min_base := min - min_10 * 10;							
			hour_10 := hour / 10;
			hour_base := hour - hour_10 * 10;
			
			disp_val(3 downto 0) <= std_logic_vector(to_unsigned(hour_10, 4));
			disp_val(7 downto 4) <= std_logic_vector(to_unsigned(hour_base, 4));
			disp_val(11 downto 8) <= std_logic_vector(to_unsigned(min_10, 4));
			disp_val(15 downto 12) <= std_logic_vector(to_unsigned(min_base, 4));
			disp_val(19 downto 16)<= std_logic_vector(to_unsigned(sec_10, 4));
			disp_val(23 downto 20) <= std_logic_vector(to_unsigned(sec_base, 4));
			
			
			
	end process;
	
	
end c_Clock;
