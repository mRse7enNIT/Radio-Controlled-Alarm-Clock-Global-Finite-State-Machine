----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:03:02 01/26/2020 
-- Design Name: 
-- Module Name:    Data_Mux - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Data_Mux is
    Port ( state : in  STD_LOGIC_VECTOR (2 downto 0);
           data_bus_dt : in  STD_LOGIC_VECTOR (41 downto 0);
           data_bus_al : in  STD_LOGIC_VECTOR (12 downto 0);
           data_bus_sw : in  STD_LOGIC_VECTOR (29 downto 0);
           data_bus : out  STD_LOGIC_VECTOR (49 downto 0));
end Data_Mux;

architecture Behavioral of Data_Mux is

begin
process(state,data_bus_dt,data_bus_al,data_bus_sw)
begin
--if (state = "000" or state = "001" or state = "110") then
if (state = "000" or state = "001" or state = "110") then
data_bus <= "00000000" & data_bus_dt;
elsif (state = "010" or state = "011" ) then
data_bus <= "00000000000000000" & data_bus_al & data_bus_dt(19 downto 0) ;
elsif (state = "111") then
data_bus <=  data_bus_sw & data_bus_dt(19 downto 0);
else 
    data_bus <= "00000000" & data_bus_dt;
end if;
end process;

end Behavioral;

