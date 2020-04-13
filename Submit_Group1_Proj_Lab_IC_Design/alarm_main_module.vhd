----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2019 02:36:54 PM
-- Design Name: 
-- Module Name: alarm_main_module - Behavioral
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
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alarm_main_module is
 Port ( clk               :   in STD_LOGIC;
       reset              :   in STD_LOGIC;
       mode               :   in std_logic_vector(2 downto 0); 
       en_1               :   in STD_LOGIC;
       en_10             :   in STD_LOGIC;
       actual_hr          : in std_logic_vector(5 downto 0);
       actual_min         : in std_logic_vector(6 downto 0);
       actual_sec         : in std_logic_vector(6 downto 0);
       key_enable        :   in STD_LOGIC;
       key_plus_minus       :   in STD_LOGIC;
       key_act_imp        :   in STD_LOGIC;
       key_act_long       :   in STD_LOGIC;
       led_alarm_ring     :   out STD_LOGIC;
       led_alarm_act      :   out STD_LOGIC;
       snooze_act         :   out STD_LOGIC;
       set_hr             : out std_logic_vector(5 downto 0);
       set_min            : out std_logic_vector(6 downto 0)

 );
end alarm_main_module;

architecture Behavioral of alarm_main_module is


COMPONENT time_setup is
  Port ( clk            :   in STD_LOGIC;
        reset           :   in STD_LOGIC;
        mode            :   in std_logic_vector(2 downto 0);
        key_enable        :   in STD_LOGIC;
        key_plus_minus       :   in STD_LOGIC;
        set_hr          : out std_logic_vector(5 downto 0);
        set_min         : out std_logic_vector(6 downto 0));
end COMPONENT;

COMPONENT counter_1min is
 Port ( clk         :   in STD_LOGIC;
        reset       :   in STD_LOGIC;
        en_counter  :   in STD_LOGIC;
        en_1        :   in STD_LOGIC;
        reset_counter  :   in STD_LOGIC;
        time_1min   :   out STD_LOGIC);
end COMPONENT;

COMPONENT clock_2hz_generator is
 Port ( clk     :   in STD_LOGIC;
        reset   :   in STD_LOGIC;
        en_10  :   in STD_LOGIC;
        snooze_act  :   in STD_LOGIC;
        clk_2hz :   out STD_LOGIC );
end COMPONENT;


COMPONENT alarm_fsm is
 Port (clk                :   in STD_LOGIC;
       reset              :   in STD_LOGIC;
       mode            :   in std_logic_vector(2 downto 0); 
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
end COMPONENT;

signal set_hr_bcd       : std_logic_vector(5 downto 0);
signal set_min_bcd      : std_logic_vector(6 downto 0);
signal reset_counter_sig    : std_logic := '0';
signal en_counter_sig       : std_logic := '0';
signal time_1min_sig       : std_logic :='0';    
signal snooze_act_sig   : std_logic := '0';
signal clk_2Hz_sig         : std_logic :='0';
signal led_alarm_ring_sig: std_logic := '0';
signal led_alarm_act_sig : std_logic := '0';


begin                               

CI1: time_setup PORT MAP (
          clk => clk,
          reset => reset,
          mode => mode,
          key_enable => key_enable,
          key_plus_minus => key_plus_minus,
          set_hr => set_hr_bcd,
          set_min => set_min_bcd
        );

CI2: counter_1min PORT MAP (
          clk => clk,
          reset => reset,
          reset_counter => reset_counter_sig,
          en_1 => en_1,
          en_counter => en_counter_sig,
          time_1min => time_1min_sig
        );
        
CI3: clock_2hz_generator PORT MAP (
          clk => clk,
          reset => reset,
          en_10 => en_10,
          snooze_act => snooze_act_sig,
          clk_2Hz => clk_2Hz_sig
        );

CI4: alarm_fsm PORT MAP (
          clk => clk,
          reset => reset,
          mode => mode,
          actual_hr => actual_hr,
          actual_min => actual_min,
          actual_sec => actual_sec,
          key_act_imp => key_act_imp,
          key_act_long => key_act_long,
          time_1min => time_1min_sig,
          clk_2Hz => clk_2Hz_sig,
          set_hr => set_hr_bcd,
          set_min => set_min_bcd,
          reset_counter => reset_counter_sig,
          en_counter => en_counter_sig,
          led_alarm_ring => led_alarm_ring_sig,
          led_alarm_act => led_alarm_act_sig,
          snooze_act => snooze_act_sig

        );
set_hr <= set_hr_bcd;
set_min <= set_min_bcd;
snooze_act <= snooze_act_sig;
led_alarm_act <= led_alarm_act_sig;
led_alarm_ring<= led_alarm_ring_sig;


end Behavioral;