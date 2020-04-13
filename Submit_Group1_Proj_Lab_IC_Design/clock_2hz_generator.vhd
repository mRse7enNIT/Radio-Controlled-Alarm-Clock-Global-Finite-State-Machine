library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_2hz_generator is
 Port ( clk     :   in STD_LOGIC;
        reset   :   in STD_LOGIC;
        en_10  :   in STD_LOGIC;
        snooze_act  :   in STD_LOGIC;
        clk_2hz :   out STD_LOGIC );
end clock_2hz_generator;

architecture Behavioral of clock_2hz_generator is

Signal clk_2hz_tmp :  STD_LOGIC :='0';
Signal count :  integer := 0;

begin

process(clk)

begin

if (clk'EVENT and clk = '1') then
   
    if reset ='1' then
        clk_2hz_tmp <= '0'; 
        count       <=  0; 
    
    else if snooze_act = '1' then
            if en_10 = '1' then
                count <= count +1 ;
            end if;
            
            if count > 4 then
                 clk_2hz_tmp <= '1';
                if count > 9 then
                    count <= 0;
                end if;
            else 
                 clk_2hz_tmp <= '0';  
            end if;
    else
          clk_2hz_tmp <= '0'; 
          count       <=  0;   
    end if;
 end if;
 
 end if;

end process;

clk_2hz <= clk_2hz_tmp;


end Behavioral;