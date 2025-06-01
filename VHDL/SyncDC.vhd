LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY SyncDC IS
  GENERIC (n : integer := 16); 
  PORT(x,y : in std_logic_vector(n-1 downto 0);
	   en,rst,clk : in std_logic;
	   ALUFN : in std_logic_vector(4 downto 0);
	   PWM_out : out std_logic); 
END SyncDC;
-----------------------------------------------
ARCHITECTURE SyncDC OF SyncDC IS 
signal PWMunit_Y,PWMunit_X : std_logic_vector(n-1 downto 0);
signal PWMunit_EN : std_logic; 	
	
begin
PWM_unit : PWMunit generic map(n) port map(x=>PWMunit_X,y=>PWMunit_Y,en=>PWMunit_EN,rst=>rst,clk=>clk,mode=>ALUFN(1 downto 0),PWM_o=>PWM_out);

L1 : for i in 0 to n-1 generate
	 PWMunit_Y(i) <= '1' when ((ALUFN(4 downto 3)="00") and (y(i)='1')) else '0';
	 PWMunit_X(i) <= '1' when ((ALUFN(4 downto 3)="00") and (x(i)='1')) else '0';
	 end generate;
	 
PWMunit_EN <= '1' when ((ALUFN(4 downto 3)="00") and (en='1')) else '0';

END SyncDC;

