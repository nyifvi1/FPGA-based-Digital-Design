LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY CombDC_FF IS
  GENERIC (n : INTEGER := 16;
		   k : integer := 4;   -- k=log2(n)
		   m : integer := 8	); -- m=2^(k-1)
  PORT 
  (  clk : in STD_LOGIC;
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  ); -- Zflag,Cflag,Nflag,Vflag
END CombDC_FF;
-----------------------------------------------
ARCHITECTURE CombDC_FF OF CombDC_FF IS 
	signal AdderSub_y,AdderSub_x, Logic_y, Logic_x, Shifter_y,Shifter_x : STD_LOGIC_VECTOR(n-1 downto 0);
	signal AND_in_01,AND_in_11,AND_in_10 : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	signal AND_out_01_Y,AND_out_11_Y,AND_out_10_Y : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	signal AND_out_01_X,AND_out_11_X,AND_out_10_X : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	signal Y_swaped : STD_LOGIC_VECTOR(n-1 downto 0);
	signal AdderSub_sub_c : STD_LOGIC;

	signal Y_i_Q,X_i_Q : std_logic_vector(n-1 downto 0);
	signal ALUFN_i_Q : std_logic_vector(4 downto 0);
	signal ALUout_o_D : std_logic_vector(n-1 downto 0);
	signal Nflag_o_D,Cflag_o_D,Zflag_o_D,Vflag_o_D : STD_LOGIC;
	
	SUBTYPE vector is STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	TYPE matrix IS array (2 DOWNTO 0) of vector;
	SIGNAL Comp_O : matrix;  --Component_Output
	SIGNAL c : STD_LOGIC_VECTOR(2 DOWNTO 0); --Carry_Output
	
begin
process(clk)
begin
		if(rising_edge(clk)) then
			Y_i_Q <= Y_i;
			X_i_Q <= X_i;
			ALUFN_i_Q <= ALUFN_i;
			Nflag_o <= Nflag_o_D;
			Cflag_o <= Cflag_o_D;
			Zflag_o <= Zflag_o_D;
			Vflag_o <= Vflag_o_D;
			ALUout_o<=ALUout_o_D;
		end if;
end process;

L0:  for i in 0 to n-1 generate --Input after comparators 
	AND_in_01(i) <= '1' when ALUFN_i_Q(4 DOWNTO 3) = "01" else '0';   --AdderSub "01"
	AND_in_11(i) <= '1' when ALUFN_i_Q(4 DOWNTO 3) = "11" else '0';   --Logic    "11"
	AND_in_10(i) <= '1' when ALUFN_i_Q(4 DOWNTO 3) = "10" else '0';   --Shifter  "10"
	end generate;	
		
L1: for i in 0 to n-1 generate --Output of all AND gates configuration
		AND_out_01_Y(i) <=  AND_in_01(i) AND Y_i_Q(i); 
		AND_out_01_X(i) <= AND_in_01(i) AND X_i_Q(i); 
		AND_out_11_Y(i) <=  AND_in_11(i) AND Y_i_Q(i); 
		AND_out_11_X(i) <= AND_in_11(i) AND X_i_Q(i); 
		AND_out_10_Y(i) <=  AND_in_10(i) AND Y_i_Q(i); 
		AND_out_10_X(i) <= AND_in_10(i) AND X_i_Q(i); 		
		end generate;

L2: for i in 0 to n-1 generate --input of all components configuration
		AdderSub_y(i)<= AND_out_01_Y(i)         when ALUFN_i_Q(2 DOWNTO 0) = "000" else
					    AND_out_01_Y(i)			when ALUFN_i_Q(2 DOWNTO 0) = "001" else
						AND_out_01_Y(i)		    when ALUFN_i_Q(2 DOWNTO 0) = "011" else
						AND_out_01_Y(i)			when ALUFN_i_Q(2 DOWNTO 0) = "100" else
						'0';								
		AdderSub_x(i)<=AND_out_01_X(i)	   when ALUFN_i_Q(2 DOWNTO 0) = "000" else
					   AND_out_01_X(i)	   when ALUFN_i_Q(2 DOWNTO 0) = "001" else
					   AND_out_01_X(i)	   when ALUFN_i_Q(2 DOWNTO 0) = "010" else		
					   '1'	   			   when ALUFN_i_Q(2 DOWNTO 0) = "011" else		
					   '1'	   			   when ALUFN_i_Q(2 DOWNTO 0) = "100" else							
					   '0';
					   
		Logic_y(i)<=AND_out_11_Y(i);			   
		Logic_x(i)<=AND_out_11_X(i);		   
					   
		Shifter_y(i)<=AND_out_10_Y(i)     when ALUFN_i_Q(2 DOWNTO 0) = "000" else
					  AND_out_10_Y(i)     when ALUFN_i_Q(2 DOWNTO 0) = "001" else	
					  '0';
		Shifter_x(i)<=AND_out_10_X(i);
		end generate;							

AdderSub_sub_c <= ALUFN_i_Q(0) 		 when ALUFN_i_Q(4 DOWNTO 0) = "01000" else  --sub_c configuration  
				  ALUFN_i_Q(0)		 when ALUFN_i_Q(4 DOWNTO 0) = "01001" else
				  not ALUFN_i_Q(0) 	 when ALUFN_i_Q(4 DOWNTO 0) = "01010" else
				  ALUFN_i_Q(0)		 when ALUFN_i_Q(4 DOWNTO 0) = "01011" else
				  ALUFN_i_Q(0)		 when ALUFN_i_Q(4 DOWNTO 0) = "01100" else
				  '0';			 
		
L3:	AdderSub generic map(n) port map(x=>AdderSub_x,
									 y=>AdderSub_y,
									 sub_c=> AdderSub_sub_c,
									 cout=>c(0),
									 res=>Comp_O(0));		
L4:	Logic generic map(n) port map(x=>Logic_x,
				                  y=>Logic_y,
				                  cntrl=>ALUFN_i_Q(2 DOWNTO 0),
								  res=>Comp_O(1));
L5: Shifter generic map(n,k) port map(x=>Shifter_x,
									  y=>Shifter_y,
					                  dir=>ALUFN_i_Q(0),
									  cout=>c(2),
									  res=>Comp_O(2));
c(1) <= '0'; --Logic has no carry

Y_swaped <= Y_i_Q(n/2-1 downto 0)&Y_i_Q(n-1 downto n/2);

		ALUout_o_D(n-1 DOWNTO 0)<=Comp_O(0) when ((ALUFN_i_Q(4 DOWNTO 3)= "01") and (ALUFN_i_Q(2 DOWNTO 0)="000" or ALUFN_i_Q(2 DOWNTO 0)="001" or ALUFN_i_Q(2 DOWNTO 0)="010" or ALUFN_i_Q(2 DOWNTO 0)="011" or ALUFN_i_Q(2 DOWNTO 0)="100")) else 
								Y_swaped when ((ALUFN_i_Q(4 DOWNTO 3))= "01" and (ALUFN_i_Q(2 DOWNTO 0)="101")) else
				                Comp_O(1) when ALUFN_i_Q(4 DOWNTO 3)= "11" else
				                Comp_O(2) when ALUFN_i_Q(4 DOWNTO 3)= "10" else
								(others =>'0');
									
		Cflag_o_D<=c(0)		when ((ALUFN_i_Q(4 DOWNTO 3)= "01") and (ALUFN_i_Q(2 DOWNTO 0)="000" or ALUFN_i_Q(2 DOWNTO 0)="001" or ALUFN_i_Q(2 DOWNTO 0)="010" or ALUFN_i_Q(2 DOWNTO 0)="011" or ALUFN_i_Q(2 DOWNTO 0)="100")) else 	
				 c(1)		when ALUFN_i_Q(4 DOWNTO 3)="11" else
		         c(2)		when ALUFN_i_Q(4 DOWNTO 3)="10" else 
				 '0';
		
		Zflag_o_D<= '0'		when ((ALUFN_i_Q(4 DOWNTO 3)= "01") and (ALUFN_i_Q(2 DOWNTO 0)="000" or ALUFN_i_Q(2 DOWNTO 0)="001" or ALUFN_i_Q(2 DOWNTO 0)="010" or ALUFN_i_Q(2 DOWNTO 0)="011" or ALUFN_i_Q(2 DOWNTO 0)="100")) and Comp_O(0)/=0 else 
				  '0'		when ALUFN_i_Q(4 DOWNTO 0)= "01101" and Y_swaped/=0 else
				  '0'		when ALUFN_i_Q(4 DOWNTO 3)="11" and Comp_O(1)/=0 else
				  '0'		when ALUFN_i_Q(4 DOWNTO 3)="10" and Comp_O(2)/=0 else
				  '1';		  

		Nflag_o_D<= Comp_O(0)(n-1)    when ((ALUFN_i_Q(4 DOWNTO 3)= "01") and (ALUFN_i_Q(2 DOWNTO 0)="000" or ALUFN_i_Q(2 DOWNTO 0)="001" or ALUFN_i_Q(2 DOWNTO 0)="010" or ALUFN_i_Q(2 DOWNTO 0)="011" or ALUFN_i_Q(2 DOWNTO 0)="100")) else		
				  Y_swaped(n-1)     when ALUFN_i_Q(4 DOWNTO 0)= "01101" else
				  Comp_O(1)(n-1)    when ALUFN_i_Q(4 DOWNTO 3)= "11" else
				  Comp_O(2)(n-1)    when ALUFN_i_Q(4 DOWNTO 3)= "10" else
			            '0'	        when ALUFN_i_Q(4 DOWNTO 3)= "00";
						
		Vflag_o_D<= '1'		when (ALUFN_i_Q(4 downto 0)="01000" or ALUFN_i_Q(4 downto 0)="01011") and 
							((AdderSub_y(n-1)=AdderSub_x(n-1)) and (Comp_O(0)(n-1) /= AdderSub_y(n-1))) else  
				  '1'		when (ALUFN_i_Q(4 downto 0)="01001" or ALUFN_i_Q(4 downto 0)="01100") and 
							((AdderSub_y(n-1)/= AdderSub_x(n-1)) and (Comp_O(0)(n-1) = AdderSub_x(n-1))) else  						
				  '0'; 									 
END CombDC_FF;

