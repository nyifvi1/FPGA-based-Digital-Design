library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------
entity Logic is
	generic(n : integer :=8);
	port(x,y : IN std_logic_vector(n-1 DOWNTO 0);
		 cntrl : IN std_logic_vector(2 DOWNTO 0);
		 res : OUT std_logic_vector(n-1 DOWNTO 0));
end Logic;

architecture Logic of Logic is
begin
L0: for i in 0 to n-1 generate --Logic output configuration
	res(i) <= not Y(i) when cntrl = "000" else
		  Y(i) or X(i) when cntrl = "001"  else
		  Y(i) and X(i) when cntrl = "010" else
	      Y(i) xor X(i) when cntrl = "011" else
	      Y(i) nor X(i) when cntrl = "100" else
	      Y(i) nand X(i) when cntrl = "101" else
	      Y(i) xnor X(i) when cntrl = "110" else
		  '0'            when cntrl ="111";  --if not inculuded in the ISA the output should be 0
	end generate;

end architecture Logic;
	
	