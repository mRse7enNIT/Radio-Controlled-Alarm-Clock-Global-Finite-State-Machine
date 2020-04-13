
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alarm_fsm is
 Port (clk                :   in STD_LOGIC;
       reset              :   in STD_LOGIC;
       mode               :   in std_logic_vector(2 downto 0); 
       actual_hr          : in std_logic_vector(5 downto 0);
       actual_min         : in std_logic_vector(6 downto 0);
       actual_sec         : in std_logic_vector(6 downto 0);
       set_hr             : in std_logic_vector(5 downto 0);
       set_min            : in std_logic_vector(6 downto 0);
       key_act_imp        :   in STD_LOGIC;
       key_act_long       :   in STD_LOGIC;
       time_1min          :   in STD_LOGIC;
       clk_2hz            :   in STD_LOGIC;
       reset_counter      :   out STD_LOGIC;
       en_counter         :   out STD_LOGIC;
       snooze_act             :   out STD_LOGIC;
       led_alarm_ring     :   out STD_LOGIC;
       led_alarm_act      :   out STD_LOGIC
         );
end alarm_fsm;

architecture Behavioral of alarm_fsm is

TYPE state IS (inactive, active, ringing, snooze);

Signal current_state, next_state : state;


begin

p1: process(reset, current_state, mode, set_hr, set_min, key_act_imp, key_act_long, time_1min, clk_2Hz, actual_hr, actual_min,actual_sec,time_1min)

begin

case current_state is
    
        when inactive =>
            if ( reset = '0' and key_act_imp = '1' and (mode="010" or mode = "011")) then  
                next_state <= active;
            else 
                next_state <= inactive;    
            end if;
            
            reset_counter <= '1';
            en_counter    <= '0';
            led_alarm_ring <= '0';
            led_alarm_act  <= '0';
            snooze_act     <= '0'; 
           
            
        
        when  active =>
            if (  key_act_imp = '1' and (mode="010" or mode = "011")) then                 
                next_state <= inactive;
                
            elsif(set_hr = actual_hr) and (set_min = actual_min) and (actual_sec = "0000000")  then
                next_state <= ringing;
            else
                next_state <= active;
            end if;
            
            reset_counter <= '1';
            en_counter    <= '0';
            led_alarm_ring <= '0';
            led_alarm_act  <= '1';
            snooze_act     <= '0';

           
        
         when ringing =>
            if time_1min = '1' then
                reset_counter <= '1';
                en_counter    <= '0';
                next_state <= active;

            
            elsif(key_act_imp = '1') then 
                reset_counter <= '1';
                next_state <= snooze;
            
            elsif(key_act_long = '1')  then
                next_state <= active;
 
                else
                    next_state <= ringing;
                    reset_counter <= '0';
                en_counter    <= '1';
            end if;
            
         
            led_alarm_ring <= '1';
            led_alarm_act  <= '1';
            snooze_act     <= '0';
        
        when snooze =>
            if time_1min = '1' then
                reset_counter <= '1';
               en_counter    <= '0';
                next_state <= ringing;
            
            elsif(key_act_long = '1') then
                next_state <= active;

            else
                next_state <= snooze;
                reset_counter <= '0';
                en_counter    <= '1';
            end if; 
            
            led_alarm_ring <= '0';
            led_alarm_act  <= clk_2hz;
            snooze_act     <= '1';
        when others =>
            reset_counter <= '1'; 
           en_counter    <= '0';
            led_alarm_ring <= '0';
            led_alarm_act  <= '0';
            snooze_act     <= '0'; 
           
                       
 end case;
end process;



p2:process(clk)
begin
if clk'EVENT AND clk='1' then
        if reset = '1' then
            current_state <= inactive;
        else
            current_state <= next_state;
        end if;
    end if;

end process;



end Behavioral;