LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY lcd_display IS	
	PORT( 	clk, resetn	: in std_logic;
		alarmTime : in std_logic_vector(23 downto 0);
		a_msg	: in std_logic_vector(127 downto 0);
		e, rs, rw	: out std_logic;
		lcd_data   	: out std_logic_vector(7 downto 0) );
END lcd_display;

ARCHITECTURE sample of lcd_display IS
	COMPONENT lcd
		 PORT( clk           : in std_logic;
			strobe         	: in std_logic;
			address        	: in std_logic_vector(6 downto 0); 
			data           	: in std_logic_vector(7 downto 0); 
			e, rs, rw, busy	: out std_logic;
			lcd_data       	: out std_logic_vector(7 downto 0) );
	 END COMPONENT;
	
	SIGNAL busy_pre, busy, strobe, update_flag	: std_logic;
	SIGNAL data		: std_logic_vector(7 downto 0);
	SIGNAL count	: std_logic_vector(6 downto 0);
	signal toggle : std_logic;
	SIGNAL cnt 		: integer RANGE 0 to 999;
	
	TYPE		lcd_disp IS ARRAY(0 to 1, 0 to 15) of std_logic_vector(7 downto 0);

	SIGNAL msg : lcd_disp := (  (X"3d", X"3d", X"3d", X"3d", X"20", X"20", X"3a", X"20", X"20", X"3a", X"20", X"20", X"3d", X"3d", X"3d", X"3d"),
										(X"20", X"20", X"20", X"20", X"20", X"20", X"20", X"20", X"20", X"20", X"20", X"20", X"20", X"20", X"20", X"20") ); 	--
	
		
		
begin
	lcd_control : lcd PORT MAP( clk, strobe, count, data, e, rs, rw, busy, lcd_data );

	change_checking : process( update_flag)
	variable pre_alarmTime : std_logic_vector(23 downto 0);--+++
	
	begin
		if( update_flag'event and update_flag ='1') then
			if(pre_alarmTime /= alarmTime and toggle ='0') then--+++
				pre_alarmTime := alarmTime;
				toggle <='1';
				
			elsif(toggle ='1') then--+++
		
				toggle <='0';
				
			end if;
		
		end if;
	end process;
	
	P_VAL : PROCESS(clk, resetn)
	BEGIN
		IF resetn = '0' then
			cnt <= 0;
		ELSIF clk'EVENT AND clk='1' THEN
			IF cnt /= 999 THEN
				cnt <= cnt + 1;
				update_flag <= '0';
			ELSE
				cnt <= 0;
				update_flag <= '1';
				
			END IF;
		END IF;
	END PROCESS;
	
	P_ADD : process(clk, resetn)
	BEGIN
		IF resetn = '0' THEN
			strobe <= '1';
			count <= "0000000";
		ELSIF clk'event and clk = '1' THEN
			busy_pre <= busy;
			
			 IF busy = '0' and busy_pre = '1' THEN
				IF count = "1001111" THEN
					strobe <= '0'; 
				ELSE
					strobe <= '1';
					count <= count + 1;
				 END IF;
			ELSE
				IF update_flag = '1' and toggle = '1' THEN
					strobe <= '1'; 
					count <= "0000000";
				ELSE
					strobe <= '0';
				END IF;
			 END IF;
		END IF;  
	END PROCESS; 
	
	P_MSG : PROCESS(update_flag)
	variable m_cnt : integer range 0 to 16 :=0;
	BEGIN
		
			
			
		IF update_flag = '1' THEN
			
			----show alarm Time----
			m_cnt:=0;
			msg(0,4) <= x"3"&alarmTime(3+m_cnt*4 downto m_cnt*4);
			m_cnt:=m_cnt+1;
			msg(0,5) <= x"3"&alarmTime(3+m_cnt*4 downto m_cnt*4);
			m_cnt:=m_cnt+1;
			msg(0,7) <= x"3"&alarmTime(3+m_cnt*4 downto m_cnt*4);
			m_cnt:=m_cnt+1;
			msg(0,8) <= x"3"&alarmTime(3+m_cnt*4 downto m_cnt*4);
			m_cnt:=m_cnt+1;
			msg(0,10) <= x"3"&alarmTime(3+m_cnt*4 downto m_cnt*4);
			m_cnt:=m_cnt+1;
			msg(0,11) <= x"3"&alarmTime(3+m_cnt*4 downto m_cnt*4);
			
			----show message----
			m_cnt:=0;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
			msg(1,m_cnt) <=a_msg(m_cnt*8+7 downto m_cnt*8);
			m_cnt:=m_cnt+1;
				
			
				
			
		
		END IF;
	END PROCESS;
	
	P_DATA : PROCESS (count)
		VARIABLE col_add : integer range 0 to 63;
		 VARIABLE row_add : integer range 0 to 1;
	begin
		col_add := conv_integer(count(5 downto 0));	-- convert std_logic_vector to integer
		row_add := conv_integer(count(6 downto 6));
		
		IF col_add > 15 THEN
			data <= X"20";
		ELSE
			data <= msg(row_add, col_add);
		END IF;
	 END PROCESS;
END SAMPLE;
