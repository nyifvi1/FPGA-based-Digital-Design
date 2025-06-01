LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-----------------------------------------------
ENTITY GPIO_Interface IS
  GENERIC (n : integer := 16); 
  PORT(KEY0,KEY1,KEY2,KEY3 : in std_logic;
	   SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW8,SW9 : in std_logic;
	   clk : in std_logic;
	   HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out std_logic_vector(6 downto 0);
	   LEDR0,LEDR1,LEDR2,LEDR3,LEDR5,LEDR6,LEDR7,LEDR8,LEDR9 : out std_logic;
	   PWM_out : out std_logic); 
END GPIO_Interface;
-----------------------------------------------
ARCHITECTURE GPIO_Interface OF GPIO_Interface IS 
signal en0,en1,en2,en3,en4 : std_logic;
signal Y_8bit_low,Y_8bit_high,X_8bit_low,X_8bit_high,ALUFN_8bit : std_logic_vector(7 downto 0);
signal Y_16bit,X_16bit : std_logic_vector(15 downto 0);
signal ALUout_o : std_logic_vector(n/2-1 downto 0);
signal Y_to_HEX,X_to_HEX : std_logic_vector(7 downto 0);
signal PLLout,KEY3_not : std_logic;
begin

PLL_2Meg : PLL port map(inclk0=>clk, c0=>PLLout);

top_comp : top generic map(n) port map(x=>X_16bit,y=>Y_16bit,en=>SW8,rst=>KEY3_not,clk=>PLLout,ALUFN=>ALUFN_8bit(4 downto 0),
									   PWM_out=>PWM_out,ALUout_o=>ALUout_o,Nflag_o=>LEDR0,Cflag_o=>LEDR1,Zflag_o=>LEDR2,Vflag_o=>LEDR3);
--------------------auxilary signals---------------------------
X_16bit <= X_8bit_high&X_8bit_low;
Y_16bit <= Y_8bit_high&Y_8bit_low;
KEY3_not <= not KEY3;
--------------------LEDR5-LEDR9 display configuration---------------------------
LEDR5 <= ALUFN_8bit(0);
LEDR6 <= ALUFN_8bit(1);
LEDR7 <= ALUFN_8bit(2);
LEDR8 <= ALUFN_8bit(3);
LEDR9 <= ALUFN_8bit(4);
--------------------HEX display configuration---------------------------
HEX4_Dec : SevenSegDecoder port map(data=>ALUout_o(3 downto 0), seg=>HEX4);
HEX5_Dec : SevenSegDecoder port map(data=>ALUout_o(7 downto 4), seg=>HEX5);

Y_to_HEX <= Y_8bit_low when SW9='0' else Y_8bit_high;
X_to_HEX <= X_8bit_low when SW9='0' else X_8bit_high;

HEX0_Dec : SevenSegDecoder port map(data=>X_to_HEX(3 downto 0), seg=>HEX0);
HEX1_Dec : SevenSegDecoder port map(data=>X_to_HEX(7 downto 4), seg=>HEX1);
HEX2_Dec : SevenSegDecoder port map(data=>Y_to_HEX(3 downto 0), seg=>HEX2);
HEX3_Dec : SevenSegDecoder port map(data=>Y_to_HEX(7 downto 4), seg=>HEX3);
--------------------Input 8Bit Registers Creation---------------------------
en0 <= not KEY0 and not SW9;
en1 <= not KEY0 and SW9;
en2 <= not KEY2;
en3 <= not KEY1 and not SW9;
en4 <= not KEY1 and SW9;

Y_8bit_low <= SW7&SW6&SW5&SW4&SW3&SW2&SW1&SW0 when en0='1' else Y_8bit_low;
Y_8bit_high <= SW7&SW6&SW5&SW4&SW3&SW2&SW1&SW0 when en1='1' else Y_8bit_high; 			
ALUFN_8bit <= SW7&SW6&SW5&SW4&SW3&SW2&SW1&SW0 when en2='1' else ALUFN_8bit;
X_8bit_low <= SW7&SW6&SW5&SW4&SW3&SW2&SW1&SW0 when en3='1' else X_8bit_low;
X_8bit_high <= SW7&SW6&SW5&SW4&SW3&SW2&SW1&SW0 when en4='1' else X_8bit_high;			
-----------------------------------------------			
END GPIO_Interface;
