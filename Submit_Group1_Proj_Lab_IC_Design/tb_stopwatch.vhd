----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nikhil
-- 
-- Create Date: 12/20/2020 04:29:33 PM
-- Design Name: 
-- Module Name: tb_stopwatch - Behavioral
-- Project Name: Project Lab IC Design
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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_stopwatch IS
END tb_stopwatch;
 
ARCHITECTURE behavior OF tb_stopwatch IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT stopwatch
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         key_action_imp : IN  std_logic;
         key_plus_imp : IN  std_logic;
         key_minus_imp : IN  std_logic;
         led_alarm_ring : IN  std_logic;
         current_mode : IN  std_logic_vector(2 downto 0);
         en_100 : IN  std_logic;
         sw_lap : OUT  std_logic;
         sw_hh : OUT  std_logic_vector(6 downto 0);
         sw_mm : OUT  std_logic_vector(5 downto 0);
         sw_ss : OUT  std_logic_vector(5 downto 0);
         sw_ms : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal key_action_imp : std_logic := '0';
   signal key_plus_imp : std_logic := '0';
   signal key_minus_imp : std_logic := '0';
   signal led_alarm_ring : std_logic := '0';
   signal current_mode : std_logic_vector(2 downto 0) := "110";
   signal en_100 : std_logic := '0';

 	--Outputs
   signal sw_lap : std_logic;
   signal sw_hh : std_logic_vector(6 downto 0);
   signal sw_mm : std_logic_vector(5 downto 0);
   signal sw_ss : std_logic_vector(5 downto 0);
   signal sw_ms : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clock_period : time := 2 ns;
   constant counting_period : time := 10 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: stopwatch PORT MAP (
          clock => clock,
          reset => reset,
          key_action_imp => key_action_imp,
          key_plus_imp => key_plus_imp,
          key_minus_imp => key_minus_imp,
          led_alarm_ring => led_alarm_ring,
          current_mode => current_mode,
          en_100 => en_100,
          sw_lap => sw_lap,
          sw_hh => sw_hh,
          sw_mm => sw_mm,
          sw_ss => sw_ss,
          sw_ms => sw_ms
        );

   -- Clock process definitions
   
   clock_process :process
   begin
		clock <= '1';
		wait for clock_period/2;
		clock <= '0';
		wait for clock_period/2;
   end process;
   
   --en_100 process definitions
 
	counter_clock :process
		begin
		en_100 <= '0';
		wait for counting_period - clock_period;
		en_100 <= '1';
		wait for clock_period;
   end process;

    --Stimulus process
   stim_proc: process
   begin		
	current_mode <= "111";
	    
	key_action_imp <= '0', '1' after 10 ns, '0' after 12 ns, '1' after 2250 ns, '0' after 2300 ns,
					  '1' after 2450 ns, '0' after 7102 ns, '1' after 7600 ns, '0' after 7602 ns,
					  '1' after 8060 ns, '0' after 8150 ns; --for start and pause state transition (0 for pause 1 for start)
	key_minus_imp <= '0', '1' after 3000 ns, '0' after 3002 ns, '1' after 5000 ns, '0' after 5002 ns; --for lap mode and start mode state switch ()
	key_plus_imp <= '0','1' after 6100 ns, '0' after 6102 ns, '1' after 7410 ns, '0' after 7412 ns ; --for soft reset or counter initialization
	led_alarm_ring <= '0', '1' after 7100ns,'0' after 7200ns; --for alarm ringing mode
	reset <= '0', '1' after 8000 ns, '0' after 8050 ns; --hard reset check
      wait;
   end process;


END;
