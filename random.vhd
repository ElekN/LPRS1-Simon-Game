library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity random is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  secuencia : out STD_LOGIC_VECTOR(15 downto 0);
			  secuencia2 : out STD_LOGIC_VECTOR(1 downto 0)
	);
end entity;

architecture Behavioral of random is

   signal secuencia_aux : std_logic_vector(15 downto 0);
	signal secuencia_aux2 : std_logic_vector(15 downto 0);
	signal kurcina1 : std_logic_vector(15 downto 0);
	signal kurcina2 : std_logic_vector(15 downto 0);
	signal vagina : std_logic := '0';
	signal vaginacnt : std_logic_vector(1 downto 0) := "00";

begin

   P_random:process(clk, reset, vaginacnt)
   begin
      if (reset = '1') then
         secuencia_aux <= x"DECA";
			secuencia_aux2 <= x"ACAB";
			vagina <= '1';
      elsif rising_edge(clk) then
		   secuencia_aux <= secuencia_aux(14 downto 0) & (secuencia_aux(10) XOR secuencia_aux(12) XOR secuencia_aux(13) XOR secuencia_aux(15));
			secuencia_aux2 <= secuencia_aux2(14 downto 0) & (secuencia_aux2(10) XOR secuencia_aux2(12) XOR secuencia_aux2(13) XOR secuencia_aux2(15));
			
			if(vaginacnt="10") then
				secuencia_aux2(0) <= not(secuencia_aux(0));
			end if;
			
			if(secuencia_aux(0)=vagina) then
				vaginacnt <= vaginacnt + 1;
			end if;
			
      end if;
   end process;
	
	secuencia <= secuencia_aux;
	kurcina1 <= secuencia_aux;
	kurcina2 <= secuencia_aux2;
	secuencia2 <= kurcina1(0) & kurcina2(0);
	
end Behavioral;