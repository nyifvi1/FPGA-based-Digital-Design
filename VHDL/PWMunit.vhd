LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY PWMunit IS
  GENERIC (n : integer := 16); 
  PORT(x,y : in std_logic_vector(n-1 downto 0);
	   en,rst,clk : in std_logic;
	   mode : in std_logic_vector(1 downto 0);
       PWM_o : out std_logic); 
END PWMunit;
-----------------------------------------------
ARCHITECTURE PWMunit OF PWMunit IS 
signal Reg_Timer : std_logic_vector(n-1 downto 0);	
signal rst_timer,PWM_comb,PWM_sync : std_logic;	
begin
Timer : process(clk,rst_timer)
			begin
				if(rst_timer = '1') then 
					Reg_Timer <= (others => '0');
				elsif (rising_edge(clk)) then 
					if (en = '1') then
						Reg_Timer <= Reg_Timer+1;
					end if;
				end if;
		end process;

rst_timer <= '1' when (rst='1' or (Reg_Timer>=y+1)) else '0';        

DigCir : process(x,y,mode,Reg_Timer)
			begin 
			if en='1' then
				case mode is 
					when "00" =>
						if Reg_Timer < x then
							PWM_comb <= '0';
						else 
							PWM_comb <= '1';
						end if;
					when "01" =>
						if Reg_Timer < x then
							PWM_comb <= '1';
						else 
							PWM_comb <= '0';
						end if;										
					when others =>
							PWM_comb <= '0';
				end case;
			else 
							PWM_comb <= '0';
			end if;
		end process;
		
ToggleProc : process(clk)
begin
    if rising_edge(clk) then
        if en = '1' and mode = "10" then
            if Reg_Timer = x then
                PWM_sync <= not PWM_sync;
            end if;
        end if;
    end if;
end process;
				
PWM_o <= PWM_comb when mode /= "10" else PWM_sync;
									
END PWMunit;

