library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alarm is

   
 port(from_clock_presentTime 	: in std_logic_vector(23 downto 0);
		from_uart_alarmTime 	  	: in std_logic_vector(23 downto 0);
		from_uart_msg				: in std_logic_vector(127 downto 0);--not yet decision
		to_lcd_alarmTime			: out std_logic_vector(23 downto 0);
		to_lcd_msg					: out std_logic_vector(127 downto 0);--not yet decision
		to_piezo_decision			: out std_logic --decision of comparing presentTime to alarmTime
		
            );
end alarm;


architecture Behaviora1l of alarm is
signal toggle : std_logic; -- 0 : alarm, 1: complet msg
signal d_toggle : std_logic;
begin
	p_check : process(from_clock_presentTime)
	begin
		if(from_clock_presentTime = from_uart_alarmTime) then
			--if(from_clock_presentTime /= x"000000") then
				
				d_toggle <='1';
				
			--end if;
		else
			d_toggle <='0';
			
		end if;
	end process;
	
	AlarmChange_check : process(from_uart_alarmTime, d_toggle)
	variable pre_alarmTime : std_logic_vector(23 downto 0);
	begin
	
	if(pre_alarmTime /= from_uart_alarmTime) then
		pre_alarmTime := from_uart_alarmTime;
		toggle <='0';
	elsif (d_toggle='1') then
		toggle <='1';
	end if;
		to_piezo_decision <=d_toggle;
	end process;
	
	lcd_msg : process(toggle)
	begin
		if(toggle = '1') then
			to_lcd_alarmTime<=(x"d"&x"d"&x"d"&x"d"&x"d"&x"d");
			to_lcd_msg<= (X"2B"&X"2B"&X"2B"&X"2B"&X"2B"&X"2B"&X"2B"&X"2B"&X"2B"&X"2B"&X"2B"&X"2B"&X"2B"&X"2B"&X"2B"&X"2B") ;
		else
			to_lcd_alarmTime<=from_uart_alarmTime;
			to_lcd_msg<=from_uart_msg;
		end if;
			
	end process;

end Behaviora1l;