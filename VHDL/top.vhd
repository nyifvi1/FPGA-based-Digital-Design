LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY top IS
  GENERIC (n : integer := 16); 
  PORT(x,y : in std_logic_vector(n-1 downto 0);
	   en,rst,clk : in std_logic;
	   ALUFN : in std_logic_vector(4 downto 0);
	   PWM_out : out std_logic;
	   ALUout_o: out std_logic_vector(n/2-1 downto 0);
	   Nflag_o,Cflag_o,Zflag_o,Vflag_o : out std_logic); 
END top;
-----------------------------------------------
ARCHITECTURE top OF top IS 

begin
Comb : CombDC generic map(n/2) port map(Y_i=>y(n/2-1 downto 0),X_i=>x(n/2-1 downto 0),ALUFN_i=>ALUFN,ALUout_o=>ALUout_o, Nflag_o=>Nflag_o,Cflag_o=>Cflag_o,Zflag_o=>Zflag_o, Vflag_o=>Vflag_o);
Sync : SyncDC generic map(n) port map(x=>x,y=>y,en=>en,rst=>rst,clk=>clk,ALUFN=>ALUFN,PWM_out=>PWM_out);

END top;

