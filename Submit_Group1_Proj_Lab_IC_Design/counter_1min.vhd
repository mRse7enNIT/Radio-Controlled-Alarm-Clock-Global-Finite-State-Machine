library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_1min is
 Port ( clk         :   in STD_LOGIC;
        reset       :   in STD_LOGIC;
        en_counter  :   in STD_LOGIC;
        en_1        :   in STD_LOGIC;
        reset_counter  :   in STD_LOGIC;
        time_1min   :   out STD_LOGIC);
end counter_1min;

architecture Behavioral of counter_1min is


Signal time_1min_tmp : STD_LOGIC := '0';
Signal count : integer := 0 ;

begin

process(clk)

begin

if (clk'EVENT and clk = '1') then
   
    if reset ='1' or reset_counter = '1' then
        count <= 0;
        time_1min_tmp <= '0';
    else 
         if en_counter = '1' and en_1 = '1' then
            count <= count + 1;
         end if;  
         
         if count > 59 then
            time_1min_tmp <= '1';
            count <= 0;    
         else
            time_1min_tmp <= '0';
        end if;
     end if;
     
end if;

end process;
time_1min <= time_1min_tmp;
end Behavioral;