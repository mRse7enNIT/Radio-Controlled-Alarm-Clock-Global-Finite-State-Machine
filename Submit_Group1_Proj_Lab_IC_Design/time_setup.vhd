----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2019 01:37:05 PM
-- Design Name: 
-- Module Name: time_setup - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity time_setup is
  Port ( clk            :   in STD_LOGIC;
        reset           :   in STD_LOGIC;
        mode               :   in std_logic_vector(2 downto 0); 
        key_enable        :   in STD_LOGIC;
        key_plus_minus       :   in STD_LOGIC;
        set_hr          : out std_logic_vector(5 downto 0);
        set_min         : out std_logic_vector(6 downto 0));
end time_setup;

architecture Behavioral of time_setup is

signal set_hr_ones : integer RANGE 0 TO 9 := 0;
signal set_hr_tens : integer RANGE 0 TO 2 := 0;
signal set_min_ones : integer RANGE 0 TO 9 := 1;
signal set_min_tens : integer RANGE 0 TO 5 := 1;
Signal count : integer := 0 ;



begin

process(clk)

begin

if (clk'EVENT and clk = '1') then

    if reset = '1' then
        set_min_ones <= 1;
        set_min_tens <= 1;
        set_hr_ones <= 0;
        set_hr_tens <= 0;
    else
        if (mode="011") then
            if ( key_enable = '1' and key_plus_minus = '1') then        
                if (set_min_ones = 9) and (set_min_tens = 5) then
                    set_min_ones <= 0;
                    set_min_tens <= 0;
                    if (set_hr_ones = 3) and (set_hr_tens = 2) then
                        set_hr_ones <= 0;
                        set_hr_tens <= 0;
                    else
                        if set_hr_ones = 9 then
                            set_hr_ones <= 0;
                            set_hr_tens <= set_hr_tens + 1;
                        else
                            set_hr_ones <= set_hr_ones + 1;
                        end if;
                    end if; 
                else
                    if set_min_ones = 9 then
                        set_min_ones <= 0;
                        set_min_tens <= set_min_tens + 1;
                    else
                        set_min_ones <= set_min_ones + 1;
                    end if;
                end if; 
                end if;
                
                if (key_enable = '1' and key_plus_minus = '0') then
                if (set_min_ones = 0)  and (set_min_tens = 0) then
                    set_min_ones <= 9;
                    set_min_tens <= 5;
                    if (set_hr_ones = 0)  and (set_hr_tens = 0) then
                        set_hr_ones <= 3;
                        set_hr_tens <= 2;
                    else
                        if set_hr_ones = 0 then
                            set_hr_ones <= 9;
                            set_hr_tens <= set_hr_tens - 1;
                        else
                            set_hr_ones <= set_hr_ones - 1;
                        end if;
                    end if; 
                else
                    if set_min_ones = 0 then
                        set_min_ones <= 9;
                        set_min_tens <= set_min_tens - 1;
                    else
                        set_min_ones <= set_min_ones - 1;
                    end if;
                end if;
            end if; 
            end if;
       
        end if;
    end if;
      
end process;

set_hr(3 downto 0) <= std_logic_vector (to_unsigned(set_hr_ones,4));        -- Integer to BCD Conversion
set_hr(5 downto 4) <= std_logic_vector(to_unsigned(set_hr_tens, 2));
set_min(3 downto 0) <= std_logic_vector(to_unsigned(set_min_ones, 4));
set_min(6 downto 4) <= std_logic_vector(to_unsigned(set_min_tens, 3));


end Behavioral;