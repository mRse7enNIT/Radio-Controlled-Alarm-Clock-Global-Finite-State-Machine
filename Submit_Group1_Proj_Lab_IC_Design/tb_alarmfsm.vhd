----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/24/2020 03:18:10 PM
-- Design Name: 
-- Module Name: tb_alarmfsm - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_alarmfsm is
--  Port ( );
end tb_alarmfsm;

architecture Behavioral of tb_alarmfsm is

component alarm_fsm is
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
end component;

-- Inputs of the testbench
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal mode :   std_logic_vector(2 downto 0) := (others => '0');
signal key_act_imp : std_logic := '0';
signal key_act_long       :   STD_LOGIC := '0';
signal actual_hr          :  std_logic_vector(5 downto 0) := (others => '0');
signal actual_min         :  std_logic_vector(6 downto 0) := (others => '0');
signal actual_sec         :  std_logic_vector(6 downto 0) := (others => '0');
signal set_hr             :  std_logic_vector(5 downto 0) := (others => '0');
signal set_min            : std_logic_vector(6 downto 0) := (others => '0');
signal time_1min          : std_logic := '0';
signal clk_2hz            : std_logic := '0';
-- Ouputs of the testbench
signal en_counter         :std_logic := '0';
signal reset_counter      :std_logic := '0';
signal led_alarm_ring     :   STD_LOGIC := '0';
signal led_alarm_act      :    STD_LOGIC := '0';
signal snooze_act         :   STD_LOGIC := '0';

   


   constant clk_period : time := 10 ns;
   constant en_1_period : time := 1 sec;
   constant en_100_period : time := 10 ms;

begin

uut: alarm_fsm PORT MAP (
        clk => clk,
        reset =>  reset,
        mode => mode,
        actual_hr => actual_hr,
        actual_min => actual_min,
        actual_sec => actual_sec,
        set_hr => set_hr,
        set_min => set_min,
        key_act_imp => key_act_imp,
        key_act_long => key_act_long,
        time_1min  => time_1min,  
       clk_2hz => time_1min,
       reset_counter => reset_counter,
       en_counter   => en_counter,
        led_alarm_ring => led_alarm_ring,
        led_alarm_act => led_alarm_act,
        snooze_act => snooze_act  
    );
    
    --Clock process definitions
    clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
   
   -- Stimulus process
   stim_proc: process
   begin
        
        wait for clk_period;
        
        mode <= "010";
        key_act_imp <= '1';
        
      wait for clk_period;
      
       key_act_imp <= '0';
        
      wait for clk_period;
      
        mode <= "011";
      actual_hr <= "000000";
       actual_min <= "0010001";
       actual_sec <= "0000000"; 
       set_hr <= "000000";
       set_min <= "0010001";
       
       wait for clk_period;
       
      
        key_act_imp <= '1';
         wait for clk_period;
      
       key_act_imp <= '0';
        
      wait for clk_period;
      
    wait;        
   end process;     


end Behavioral;
