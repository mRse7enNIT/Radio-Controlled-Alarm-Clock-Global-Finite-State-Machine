----------------------------------------------------------------------------------
-- Company: TUM
-- Engineer: Saptarshi Mitra
--
-- Create Date: 11/18/2019 08:16:03 PM
-- Design Name:
-- Module Name: gfsm - Behavioral
-- Project Name: Project Lab IC Design(Alarm Clock)
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gfsm is
    Port ( key_plus_imp : in STD_LOGIC;
           key_minus_imp : in STD_LOGIC;
           key_mode_imp : in STD_LOGIC;
           key_action_imp : in STD_LOGIC;
           led_alarm_ring : in STD_LOGIC;--to check in every state if the alarm is ringing
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           selected_state : out STD_LOGIC_VECTOR (2 downto 0));
           
end gfsm;

architecture Behavioral of gfsm is
--enumerate types, create different states required
    TYPE states IS(time_mode, date_mode, alarm_mode, alarm_settings_mode, timeswitch_on_mode, timeswitch_off_mode, countdown_mode, stopwatch_mode);
    SIGNAL current_state, next_state : states;
    --declare any other  variables that needs to be implemented
    SIGNAL date_timeout_count:integer range 0 to 30001;--time period is 100us, means for 3 sec, pos edge of clk apears for 30000 times
    begin
        state_memory: PROCESS(clk)
        begin
            IF clk'EVENT AND clk='1' THEN
                IF reset = '1' THEN
                    current_state <= time_mode;--this is a signal assignment
                 ELSE
                    current_state <= next_state;
                 END IF;
            END IF;
        end process state_memory;
       
       
       
        next_state_logic: PROCESS(current_state, key_plus_imp, key_minus_imp, key_mode_imp, key_action_imp, date_timeout_count, led_alarm_ring)
        begin
            CASE current_state IS
                WHEN time_mode =>
                   
                    IF key_mode_imp = '1' THEN
                        next_state <= date_mode;
                    ELSIF key_plus_imp = '1' OR key_minus_imp = '1' THEN
                        next_state <= stopwatch_mode;  
                    ELSE
                        next_state <= time_mode;
                    END IF;
               

                WHEN date_mode =>
                   
                    IF date_timeout_count = 29999 THEN--30000, 30001 can also be used, takes another 100us extra for each
                        next_state <= time_mode;
                    ELSIF key_mode_imp = '1' THEN
                        next_state <= alarm_mode;
                    ELSE
                        next_state <= date_mode;
                    END IF;
                   
                WHEN alarm_mode =>
                    IF key_mode_imp = '1' THEN
                        next_state <= timeswitch_on_mode;
                    ELSIF (key_plus_imp = '1' OR key_minus_imp = '1' OR key_action_imp = '1') AND led_alarm_ring = '0' THEN
                        next_state <= alarm_settings_mode;
                    ELSE
                        next_state <= alarm_mode;
                    END IF;
                   
                WHEN alarm_settings_mode =>
                    IF key_mode_imp = '1' THEN
                        next_state <= time_mode;
                    ELSE
                        next_state <= alarm_settings_mode;
                    END IF;
                   
                WHEN timeswitch_on_mode =>
                    IF key_mode_imp = '1' THEN
                        next_state <= timeswitch_off_mode;
                    ELSE
                        next_state <= timeswitch_on_mode;
                    END IF;
                   
                WHEN timeswitch_off_mode =>
                    IF key_mode_imp = '1' THEN
                        next_state <= countdown_mode;
                    ELSE
                        next_state <= timeswitch_off_mode;
                    END IF;    
                   
                WHEN countdown_mode =>
                    IF key_mode_imp = '1' THEN
                        next_state <= time_mode;
                    ELSE
                        next_state <= countdown_mode;
                    END IF;
                   
                WHEN stopwatch_mode =>
                    IF key_mode_imp = '1' THEN
                        next_state <= time_mode;
                    ELSE
                        next_state <= stopwatch_mode;
                    END IF;  
            END CASE;                                    
                                           
        end process next_state_logic;
       

       
       
        timeout: PROCESS(clk, current_state)
        begin
            IF current_state = date_mode THEN
                IF clk'EVENT AND clk='1' THEN
                    IF date_timeout_count  <30001 THEN
                        date_timeout_count <= date_timeout_count +1;
                    ELSE
                        date_timeout_count <= 0;
                    END IF;
                END IF;
            ELSE
                date_timeout_count <= 0;
            END IF;
                     
        end process timeout;
       
        output_logic: process(current_state)
        begin
           
            CASE current_state IS
                WHEN time_mode =>
                    selected_state <="000";
                WHEN date_mode =>
                    selected_state <="001";
                WHEN alarm_mode =>
                    selected_state <="010";
                WHEN alarm_settings_mode =>
                    selected_state <="011";
                WHEN timeswitch_on_mode =>
                    selected_state <="100";
                WHEN timeswitch_off_mode =>
                    selected_state <="101";
                WHEN countdown_mode =>
                    selected_state <="110";
                WHEN stopwatch_mode =>
                    selected_state <="111";
            END CASE;                        
               
        end process output_logic;
           


    end Behavioral;