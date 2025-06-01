library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------

	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
	
	component AdderSub IS
		GENERIC (n : INTEGER := 8);
		PORT (x,y : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			  sub_c : IN STD_LOGIC;
			  cout : OUT STD_LOGIC;
			  res : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
	END component;

	component Shifter IS
	GENERIC (n : INTEGER :=8;
			 k : INTEGER :=3);
	PORT(x,y : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		 dir : IN STD_LOGIC;
		 cout : OUT STD_LOGIC;
		 res : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
	END component;
	
	component Logic is
	generic(n : integer :=8);
	port(x,y : IN std_logic_vector(n-1 DOWNTO 0);
		 cntrl : IN std_logic_vector(2 DOWNTO 0);
		 res : OUT std_logic_vector(n-1 DOWNTO 0));
	end component;
	
component PWMunit IS
  GENERIC (n : integer := 16); 
  PORT(x,y : in std_logic_vector(n-1 downto 0);
	   en,rst,clk : in std_logic;
	   mode : in std_logic_vector(1 downto 0);
       PWM_o : out std_logic); 
END component;	
	
component CombDC IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
		   
  PORT(Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  ); -- Zflag,Cflag,Nflag,Vflag
END component;	
	
component SyncDC IS
  GENERIC (n : integer := 16); 
  PORT(x,y : in std_logic_vector(n-1 downto 0);
	   en,rst,clk : in std_logic;
	   ALUFN : in std_logic_vector(4 downto 0);
	   PWM_out : out std_logic); 
END component;	
		
component top IS
  GENERIC (n : integer := 16); 
  PORT(x,y : in std_logic_vector(n-1 downto 0);
	   en,rst,clk : in std_logic;
	   ALUFN : in std_logic_vector(4 downto 0);
	   PWM_out : out std_logic;
	   ALUout_o: out std_logic_vector(n/2-1 downto 0);
	   Nflag_o,Cflag_o,Zflag_o,Vflag_o : out std_logic); 
END component;	

component SevenSegDecoder IS
  PORT (data		: in STD_LOGIC_VECTOR (3 DOWNTO 0);
		seg   		: out STD_LOGIC_VECTOR (6 downto 0));
END component;	
	
component PLL IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
END component;	
		
	
end aux_package;

