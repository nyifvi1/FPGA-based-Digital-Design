LIBRARY ieee;
USE ieee.std_logic_1164.all;

--------------------------------------------------------
ENTITY Shifter IS
	GENERIC (n : INTEGER :=8;
			 k : INTEGER :=3); --k=log2(n)
	PORT(x,y : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		 dir : IN STD_LOGIC;
		 cout : OUT STD_LOGIC;
		 res : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END Shifter;
--------------------------------------------------------
ARCHITECTURE Shifter OF Shifter IS
	SUBTYPE vector is STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	TYPE matrix IS array (k DOWNTO 0) of vector;
	SIGNAL mat : matrix;
	SIGNAL c : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
begin	
L1:	for i in 0 to n-1 generate --L1 swap if SHR
	    mat(0)(i)<= y(n-i-1) when dir = '1' else y(i);    
		end generate;
L2:	for j in 1 to k generate --L2 Shift in stages
		mat(j)(2**(j-1) - 1 DOWNTO 0) <= mat(j-1)(2**(j-1) - 1 DOWNTO 0)	WHEN x(j-1)='0' ELSE (OTHERS => '0');
		mat(j)(n-1 DOWNTO 2**(j-1)) <= mat(j-1)(n-1 DOWNTO 2**(j-1))	WHEN x(j-1)='0' ELSE mat(j-1)(n-1-2**(j-1) DOWNTO 0);
	end generate;

L3:	for i in 0 to n-1 generate --L3 swap if SHR
	    res(i)<= mat(k)(n-i-1) when dir = '1' else mat(k)(i);    
		end generate;
	c(0) <= mat(0)(n-1) WHEN x(0) = '1' ELSE '0';
L4: for j in 1 to k-1 generate --L4 carry generation
	c(j) <= mat(j)(n-2**j)	WHEN x(j) = '1' ELSE c(j-1);
	end generate;
	cout <= c(k-1); 
		
END ARCHITECTURE Shifter;
			
			