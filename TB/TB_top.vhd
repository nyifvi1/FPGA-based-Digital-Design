LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY TB_top IS
  constant n : integer := 16; 
END TB_top;
-----------------------------------------------
ARCHITECTURE TB_top OF TB_top IS 
signal	   x,y : std_logic_vector(n-1 downto 0);
signal	   en,rst,clk : std_logic;
signal	   ALUFN : std_logic_vector(4 downto 0);
signal	   PWM_out : std_logic;
signal	   ALUout_o : std_logic_vector(n/2-1 downto 0);
signal	   Nflag_o,Cflag_o,Zflag_o,Vflag_o : std_logic;

begin
TB_Top : top generic map(n) port map(x=>x,y=>y,en=>en,rst=>rst,clk=>clk,ALUFN=>ALUFN,PWM_out=>PWM_out,ALUout_o=>ALUout_o,Nflag_o=>Nflag_o,Cflag_o=>Cflag_o,Zflag_o=>Zflag_o,Vflag_o=>Vflag_o);

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

gen_ALUFN : process
begin 
	y <= "0000000000010000"; --16
	ALUFN <= "00000";     --PWM, Mode 0
	wait for 5000 ns;
	ALUFN <= "00001";     --PWM, Mode 1
	wait for 5000 ns;
	ALUFN <= "00010";     --PWM, Mode 2
	wait for 5000 ns;
	y <= "0000000011111111"; 
	ALUFN <= "01101";	  --Swap
	wait;
end process;

END TB_top;

