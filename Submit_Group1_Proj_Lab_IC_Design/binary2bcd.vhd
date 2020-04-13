----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    binary2bcd - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity binary2bcd is
    Port ( binary : in  STD_LOGIC_VECTOR (7 downto 0);
           hundreds : out  STD_LOGIC_VECTOR (3 downto 0);
           tens : out  STD_LOGIC_VECTOR (3 downto 0);
           ones : out  STD_LOGIC_VECTOR (3 downto 0));
end binary2bcd;

architecture Behavioral of binary2bcd is

begin

	bin_to_bcd : process(binary)
	
	variable tmp_hundred : bit_vector(3 downto 0) := "0000";		
	variable tmp_tens : bit_vector(3 downto 0) := "0000";		
	variable tmp_ones : bit_vector(3 downto 0) := "0000";		
	variable tmp_inp : bit_vector(7 downto 0) := "00000000";  
	
	begin
	
		tmp_inp := to_bitvector(binary);
		tmp_hundred := "0000";
		tmp_tens := "0000";
		tmp_ones := "0000";
		
		
		for I in 0 to 7 loop-- Iterate bitwise for 8 bit input binary
		
			-- add 3 after ones, tens and hundreds greater than 5
			if(tmp_ones >= "0101") then
				tmp_ones := to_bitvector(to_stdlogicvector(tmp_ones) + "0011");
			end if;
			
			if(tmp_tens >= "0101") then
				tmp_tens := to_bitvector(to_stdlogicvector(tmp_tens) + "0011");
			end if;
			
			if(tmp_hundred >= "0101") then
				tmp_hundred := to_bitvector(to_stdlogicvector(tmp_hundred) + "0011");
			end if;
			
			-- left shift by 1 and assign msb of hundreds to lsb of tens 
			
			tmp_hundred := tmp_hundred sll 1;
			tmp_hundred(0) := tmp_tens(3);
			tmp_tens := tmp_tens sll 1;
			tmp_tens(0) := tmp_ones(3);
			tmp_ones := tmp_ones sll 1;
			tmp_ones(0) := tmp_inp(7);			
			tmp_inp := tmp_inp sll 1;
			
		end loop;
	
		hundreds <= to_stdlogicvector(tmp_hundred);
		tens <= to_stdlogicvector(tmp_tens);
		ones <= to_stdlogicvector(tmp_ones);
	
	end process;

end Behavioral;