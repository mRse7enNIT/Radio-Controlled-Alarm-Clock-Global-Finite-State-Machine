----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nikhil
-- 
-- Create Date: 12/20/2019 02:50:54 PM
-- Design Name: 
-- Module Name: stopwatch - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stopwatch is
    Port(   clock    : in   STD_LOGIC;
            reset    : in   STD_LOGIC;
            key_action_imp : in   STD_LOGIC;
            key_plus_imp : in   STD_LOGIC;
            key_minus_imp : in   STD_LOGIC; 
            led_alarm_ring : in   STD_LOGIC;
            current_mode : in   STD_LOGIC_VECTOR(2 downto 0); 
            en_100    : in   STD_LOGIC;  
            sw_lap          : out  std_logic;  
            sw_hh    : out  STD_LOGIC_VECTOR (6 downto 0); 
            sw_mm    : out  STD_LOGIC_VECTOR (5 downto 0); 
            sw_ss    : out  STD_LOGIC_VECTOR (5 downto 0); 
            sw_ms    : out  STD_LOGIC_VECTOR (6 downto 0));
end stopwatch;

architecture Behavioral of stopwatch is
signal hour_tmp,msec_tmp,hour_lcd,msec_lcd : STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
signal min_tmp,sec_tmp,min_lcd,sec_lcd : STD_LOGIC_VECTOR (5 downto 0)  := (others => '0');
signal lap_mode:STD_LOGIC ;

type state_type is (Init, Start, Pause, Lap);
signal current_state,next_state: state_type; 

begin

NS_logic: process(current_state, current_mode, key_action_imp,key_plus_imp,key_minus_imp) 
    begin
        case (current_state) is
            when Init => --initial state and soft reset state for stopwatch
                if(current_mode = "111" and key_action_imp = '1' and led_alarm_ring = '0') then
                    next_state <= Start;
                else 
                    next_state <= Init;
                end if;
                lap_mode <='0';
            when Start =>   -- running state
                if(current_mode = "111" and key_action_imp = '1' and led_alarm_ring = '0') then
                    next_state <= Pause;
                elsif(current_mode = "111" and key_plus_imp = '1') then --soft reset on high plus key
                    next_state <= Init;
                elsif(current_mode = "111" and key_minus_imp = '1') then --switch to lap on high minus key
                    next_state <= Lap;
                else
                    next_state <= Start;
                end if;
            lap_mode <='0';
            when Pause =>
                if(current_mode = "111" and key_action_imp = '1' and led_alarm_ring = '0') then -- pause on action key press from start
                    next_state <= Start; 
                else
                    next_state <= Pause;
                end if;
                lap_mode <= '0';
            when Lap =>
                if(current_mode = "111" and key_minus_imp = '1') then  -- lap to start state switch on key press of minus key
                  next_state <= Start; 
                elsif(current_mode = "111" and key_plus_imp = '1') then
                    next_state <= Init;
                else
                    next_state <= Lap;
                end if;
                lap_mode <='1'; 
            when others =>  -- init state as default
                next_state  <= Init;
                lap_mode <='0';
        end case;
    end process;


Counter_logic: process (en_100, current_state) 
    begin 
        if(current_state = Init) then
            hour_tmp <= "0000000";min_tmp  <= "000000"; sec_tmp  <= "000000"; msec_tmp <= "0000000";
            hour_lcd<= "0000000";min_lcd <= "000000"; sec_lcd <= "000000"; msec_lcd <= "0000000";  -- counter value initialization
        
        elsif(current_state = Lap or current_state = Start)then
            if (en_100'event and en_100='1') then -- 100 Hz rising edge 
                msec_tmp<= msec_tmp + "0000001"; --ms counter increment
                if(msec_tmp="1100100") then
                    msec_tmp<="0000000"; sec_tmp<=sec_tmp + "000001" ; -- msec counter reset sec counter starts
                if(sec_tmp="111100") then
                    sec_tmp<="000000"; min_tmp <= min_tmp + "000001";  -- sec counter reset min counter starts
                if(min_tmp = "111100") then 
                    min_tmp <= "000000"; hour_tmp <= hour_tmp + "0000001"; -- min counter reset hour counter starts
                if(hour_tmp = "1100100") then 
                    hour_tmp <= "0000000"; -- hour reset after 99
                end if; 
                end if;
                end if;
                end if;
                if(current_state /= Lap) then -- assign to temp signal current counter value of state is not lap
                    hour_lcd <= hour_tmp; min_lcd <= min_tmp; sec_lcd <= sec_tmp; msec_lcd <=msec_tmp;
                end if; 
            end if;
        end if; 
    end process;

Output_FF: process(clock, reset)  -- signal assignment and storing result into register
    begin
        if(clock'event and clock = '1') then 
            if(reset = '1') then  -- hard reset condition
                current_state <= Init; 
            else
                current_state <= next_state;
            end if;
            sw_hh <= hour_lcd;
            sw_mm <= min_lcd; 
            sw_ss <= sec_lcd; 
            sw_ms <= msec_lcd;
            sw_lap<= lap_mode; 
        end if; 
    end process;
end Behavioral;
