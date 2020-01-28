----------------------------------------------------------------------------------
-- Company: TUM
-- Engineer: Saptarshi Mitra
-- 
-- Create Date: 01/11/2020 04:32:48 AM
-- Design Name: 
-- Module Name: tb_gfsm - Behavioral
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

entity tb_gfsm is
--  Port ( );
end tb_gfsm;

architecture Behavioral of tb_gfsm is


    component gfsm
        Port ( key_plus_imp : in STD_LOGIC;
           key_minus_imp : in STD_LOGIC;
           key_mode_imp : in STD_LOGIC;
           key_action_imp : in STD_LOGIC;
           led_alarm_ring : in STD_LOGIC;
           out_mode : in STD_LOGIC;
           --en_1 : in STD_LOGIC;
           clk : in STD_LOGIC;--check if 'clock' is needed or not
           reset : in STD_LOGIC;
           selected_state : out STD_LOGIC_VECTOR (2 downto 0));
           --active_alarm : out STD_LOGIC;
           --active_countdown : out STD_LOGIC;
           --active_stopwatch : out STD_LOGIC;
           --active_alarm_settings : out STD_LOGIC);



    end component;
    
    --Inputs of the testbench
    signal key_plus_imp:STD_LOGIC := '0';
    signal key_minus_imp:STD_LOGIC := '0';
    signal key_mode_imp:STD_LOGIC := '0';
    signal key_action_imp:STD_LOGIC := '0';
    signal led_alarm_ring:STD_LOGIC := '0';
    signal out_mode:STD_LOGIC := '0';
    --signal en_1:STD_LOGIC := '0';
    signal clk:STD_LOGIC := '0';
    signal reset:STD_LOGIC := '0';
    --Outputs of the testbench
    signal selected_state:STD_LOGIC_VECTOR(2 downto 0);
    --signal active_alarm:STD_LOGIC;
    --signal active_countdown:STD_LOGIC;
    --signal active_stopwatch:STD_LOGIC;
    --signal active_alarm_settings:STD_LOGIC;
    --Clock period definition
    --constant clk_period : time := 10 ns;
    --constant en_1_period : time := 100ns;--really this period will be 10^9 ns, check with Florian if this is ok for behav simulation
    constant clk_period : time := 100 us;
    constant en_1_period : time := 1 sec;
    
begin

    --Instantiate UUT and define the portmaps
    uut: gfsm PORT MAP (
        key_plus_imp => key_plus_imp,
        key_minus_imp => key_minus_imp,
        key_mode_imp => key_mode_imp,
        key_action_imp => key_action_imp,
        led_alarm_ring => led_alarm_ring,
        out_mode => out_mode,
        --en_1 => en_1,
        clk => clk,
        reset =>  reset,
        selected_state =>selected_state
        --active_alarm =>  active_alarm,
        --active_countdown => active_countdown,
        --active_stopwatch => active_stopwatch,
        --active_alarm_settings => active_alarm_settings

    
    );
    --Clock process definitions
    clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
        
   --en_1 process definitions
--    en_1_process :process
--   begin
--		en_1 <= '0';
--		wait for en_1_period/2;
--		en_1 <= '1';
--		wait for en_1_period/2;
--   end process;
   
   
   -- Stimulus process
   stim_proc: process
   begin
   
        wait for 1 sec;
        
        key_mode_imp <= '1';--expected to goto date mode while in time mode , currently according to code, state 001
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for 3 sec;--back to time mode
        
        key_mode_imp <= '1';--expected to goto date mode while in time mode , currently according to code, state 001
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for 2999500 us;-- still not 3 sec is over, mode clicked. precision upto 3000000-2999500 us = 500us = 0.5ms=.0005sec
        
        key_mode_imp <= '1';--expected to goto alarm mode while in date mode , currently according to code, state 010
        
        wait for clk_period;
        
        key_mode_imp <= '0';
                
        wait for clk_period;
        
        key_mode_imp <= '1';--expected to goto timeswitch_on while in alarm mode , currently according to code, state 100
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for clk_period;
        
        key_mode_imp <= '1';--expected to goto timeswitch_off while in timeswitch_on mode , currently according to code, state 101
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for clk_period;
        
        key_mode_imp <= '1';--expected to goto countdown while in timeswitch_off mode , currently according to code, state 110
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for clk_period;
        
        key_mode_imp <= '1';--expected to time mode while in countdown mode , currently according to code, state 000
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for clk_period;
        
        key_mode_imp <= '1';--expected to goto date mode while in time mode , currently according to code, state 001
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for clk_period;
        
        key_mode_imp <= '1';--expected to goto alarm mode while in date mode , currently according to code, state 010
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for clk_period;
        
        key_action_imp <= '1';--expected to goto alarm_settings mode while in alarm mode , currently according to code, state 011
        
        wait for clk_period;
        
        key_action_imp <= '0';
        
        wait for clk_period;
        
        key_mode_imp <= '1';--expected to goto time mode while in alarm_settings mode , currently according to code, state 000
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for clk_period;
        
        key_minus_imp <= '1';--expected to goto stopwatch mode , currently according to code, state 111
        
        wait for clk_period;
      
        key_minus_imp <= '0';
        
        wait for clk_period;
        
        key_mode_imp <= '1';--expected to goto time mode while in stopwatch mode , currently according to code, state 000
        
        wait for clk_period;
        
        key_mode_imp <= '0';
       
        wait for 500ms;
        
        key_mode_imp <= '1';--expected to goto date mode while in time mode , currently according to code, state 001
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for clk_period;
        
        key_mode_imp <= '1';--expected to goto alarm mode while in date mode , currently according to code, state 010
        
        wait for clk_period;
        
        key_mode_imp <= '0';
                
        wait for clk_period;
        
        key_mode_imp <= '1';--expected to goto timeswitch_on while in alarm mode , currently according to code, state 100
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for clk_period;
        
        key_mode_imp <= '1';--expected to goto timeswitch_off while in timeswitch_on mode , currently according to code, state 101
        
        wait for clk_period;
        
        key_mode_imp <= '0';
        
        wait for clk_period;
        
        led_alarm_ring <= '1';--expected to goto alarm mode while in timeswitch_off mode , currently according to code, state 010
        
        wait for clk_period;
        
        led_alarm_ring <= '0';
        
        wait for 100ms;
        
        out_mode <= '1';--expected to goto last remembered  mode while in alarm mode , currently according to code, state 101
        
        wait for clk_period;
        
        out_mode <= '0';
        
        wait for clk_period;
        

        
        
        
        
        
        --another old testbench
        
        
--        key_minus_imp <= '1';--expected to goto stopwatch mode , currently according to code, state 111
        
--        wait for clk_period;
        
--        key_minus_imp <= '0';
        
--        wait for clk_period;
        
--        key_mode_imp <= '1';--expected to goto time mode while in stopwatch mode , currently according to code, state 000
        
--        wait for clk_period;
        
--        key_mode_imp <= '0';
        
--        wait for clk_period;
        
--        key_mode_imp <= '1';--expected to goto date mode while in time mode , currently according to code, state 001
        
--        wait for clk_period;
        
--        key_mode_imp <= '0';
        
--        wait for 430 ns;--back to time mode
        
--        key_mode_imp <= '1';--expected to goto date mode while in time mode , currently according to code, state 001
        
--        wait for clk_period;
        
--        key_mode_imp <= '0';
        
--        wait for clk_period;
        
--        key_mode_imp <= '1';--expected to goto alarm mode while in date mode , currently according to code, state 010
        
--        wait for clk_period;
        
--        key_mode_imp <= '0';
        
--        wait for clk_period;
        
--        key_mode_imp <= '1';--expected to goto timeswitch_on while in alarm mode , currently according to code, state 100
        
--        wait for clk_period;
        
--        key_mode_imp <= '0';
        
--        wait for clk_period;
        
--        key_mode_imp <= '1';--expected to goto timeswitch_off while in timeswitch_on mode , currently according to code, state 101
        
--        wait for clk_period;
        
--        key_mode_imp <= '0';
        
--        wait for clk_period;
        
--        key_mode_imp <= '1';--expected to goto countdown while in timeswitch_off mode , currently according to code, state 110
        
--        wait for clk_period;
        
--        key_mode_imp <= '0';
        
--        wait for clk_period;
        
--        key_mode_imp <= '1';--expected to time countdown while in countdown mode , currently according to code, state 000
        
--        wait for clk_period;
        
--        key_mode_imp <= '0';
        
--        wait for clk_period;
        
--        key_mode_imp <= '1';--expected to goto date mode while in time mode , currently according to code, state 001
        
--        wait for clk_period;
        
--        key_mode_imp <= '0';
        
--        wait for clk_period;
        
--        key_mode_imp <= '1';--expected to goto alarm mode while in date mode , currently according to code, state 010
        
--        wait for clk_period;
        
--        key_mode_imp <= '0';
        
--        wait for clk_period;
        
--        key_action_imp <= '1';--expected to goto alarm_settings mode while in alarm mode , currently according to code, state 011
        
--        wait for clk_period;
        
--        key_action_imp <= '0';
        
--        wait for clk_period;
        
--        key_mode_imp <= '1';--expected to goto time mode while in alarm_settings mode , currently according to code, state 000
        
--        wait for clk_period;
        
--        key_mode_imp <= '0';
        
        
--        wait for 5000 ns;  
        
        wait;        
   end process;

end Behavioral;
