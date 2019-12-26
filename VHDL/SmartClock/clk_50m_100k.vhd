
library ieee;
use ieee.std_logic_1164.all;

entity clk_50m_100k is
	port(
        clk_50m : in  STD_LOGIC;
        clk_100k : out  STD_LOGIC);
end clk_50m_100k;


architecture Behavioral of clk_50m_100k is

signal toggle : std_logic :='1'; --for transmission to clock_out 


begin

 process(clk_50m)
 variable count : integer range 0 to 50000000 := 500; --500, 100,000hz
 variable temp :integer range 0 to 50000000 := 0; 
 
 begin
  if(falling_edge(clk_50m)) then --when falling edge, temp add
   if(temp = count-1) then -- temp has width 0 to (count-1)
		if(toggle ='0') then -- when excute upper if, toggle switch change
			toggle <='1';
		else
			toggle <='0';
		end if;
		
		temp :=0;
		clk_100k <= toggle;
	else
    temp := temp + 1;       
   end if;
  end if;
 end process;
 

end Behavioral;