LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; 

ENTITY lcd IS
	PORT( clk, strobe		:in std_logic;
				address		:in std_logic_vector(6 downto 0);
				data			:in std_logic_vector(7 downto 0);
				e,rs,rw,busy: out std_logic;
				lcd_data		:out std_logic_vector(7 downto 0));
END lcd;

 

ARCHITECTURE sample of lcd IS
	constant add_line_1			:std_logic_vector(7 downto 0) := "10000000";
	constant add_line_2			:std_logic_vector(7 downto 0) := "11000000";
	constant system_set			:std_logic_vector(7 downto 0) := "00111000";
	constant clear_display		:std_logic_vector(7 downto 0) := "00000001";
	constant entry_mode_set		:std_logic_vector(7 downto 0) := "00000110";
	constant display_onoff		:std_logic_vector(7 downto 0) := "00001100";
	SIGNAL	internal_count, max_count : std_logic_vector(3 downto 0);

	TYPE lcd_states IS (t0, t1, t2);
	SIGNAL	state : lcd_states;
	SIGNAL	addr: std_logic_vector(6 downto 0);
 
	BEGIN
		P_MKENB : PROCESS(clk, strobe)
		BEGIN
			IF strobe = '1' THEN
				state <= t0;
				addr <= address;
				e <='0';

			ELSIF (clk'event and clk = '1') THEN
				CASE state IS
					WHEN t0=> 
						state <= t1;
						e <= '1';
					WHEN t1 =>
						state <= t2;
						e <= '0';
					WHEN t2 =>
						IF internal_count /= max_count THEN
							state <= t0;
						END IF;
						e <= '0';
				END CASE;
			END IF;
		END PROCESS;

 

		P_MKBUSY : PROCESS(clk, strobe)
		BEGIN
			IF strobe = '1' THEN
				internal_count <= "0000";
				busy <= '1';
			ELSIF (clk'event and clk = '1') THEN
				IF state=t2 THEN
					IF internal_count = max_count THEN
						busy <= '0';
					ELSE 
						internal_count <= internal_count +1;
					END IF;
				END IF;
			END IF;
		END PROCESS;

		P_NOOP : PROCESS(addr, data)
		BEGIN
			IF addr = "0000000" THEN
				max_count <= "0101";
			ELSIF addr = "1000000" THEN
				max_count <= "0001";
			ELSE
				max_count <= "0000";
			END IF;
		END PROCESS;
		P_OUT : PROCESS(addr, internal_count, data)
		BEGIN
			CASE addr IS
				WHEN "0000000" =>
					CASE internal_count IS
						WHEN "0000" =>
							rs <='0';
							rw <='0';
							lcd_data <= system_set;
						WHEN "0001" =>
							rs <='0';
							rw <='0';
							lcd_data <= clear_display;
						WHEN "0010" =>
							rs <='0';
							rw <='0';
							lcd_data <= entry_mode_set;
						WHEN "0011" =>
							rs <='0';
							rw <='0';
							lcd_data <= display_onoff;
						WHEN "0100" =>
							rs <='0';
							rw <='0';
							lcd_data <= add_line_1;
						WHEN others =>
							rs <='1';
							rw <='0';
							lcd_data <= data;
					END CASE;
			WHEN "1000000" =>
					CASE internal_count IS
						WHEN "0000" =>
							rs <='0';
							rw <='0';
							lcd_data <= add_line_2;
						WHEN others =>
							rs <='1';
							rw <='0';
							lcd_data <= data;
					END CASE;
			WHEN others =>
					rs <='1';
					rw <='0';
					lcd_data <= data;
			END CASE;
			END PROCESS;
		END sample;