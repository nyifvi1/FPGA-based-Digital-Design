LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY TB_PWMunit IS
  constant n : integer := 16; 
END TB_PWMunit;
-----------------------------------------------
ARCHITECTURE TB_PWMunit OF TB_PWMunit IS 
signal x,y : std_logic_vector(n-1 downto 0);
signal en,rst,clk : std_logic;
signal mode : std_logic_vector(1 downto 0);
signal PWM_o : std_logic;
begin
TB_PWMunit : PWMunit generic map(n) port map(x=>x,y=>y,en=>en,rst=>rst,clk=>clk,mode=>mode,PWM_o=>PWM_o);



gen_clk : process
begin
	clk <= '0';
	wait for 50 ns;
	clk <= not clk;
	wait for 50 ns;
end process;

gen_rst : process
begin
	rst <= '1';
	wait for 150 ns;
	rst <= not rst;
	wait;
end process;

gen_en : process
begin
	en <= '0';
	wait for 250 ns;
	en <= not en;
	wait;
end process;

x <= "0000000000001100"; --12
y <= "0000000000010000"; --16

mode <= "00";  --mode check 00,01,10,11



END TB_PWMunit;

