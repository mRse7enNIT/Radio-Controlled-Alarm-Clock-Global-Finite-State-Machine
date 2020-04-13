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
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           selected_state : out STD_LOGIC_VECTOR (2 downto 0));




    end component;
   
    --Inputs of the testbench
    signal key_plus_imp:STD_LOGIC := '0';
    signal key_minus_imp:STD_LOGIC := '0';
    signal key_mode_imp:STD_LOGIC := '0';
    signal key_action_imp:STD_LOGIC := '0';
    signal led_alarm_ring:STD_LOGIC := '0';
    signal clk:STD_LOGIC := '0';
    signal reset:STD_LOGIC := '0';
    --Outputs of the testbench
    signal selected_state:STD_LOGIC_VECTOR(2 downto 0);
    constant clk_period : time := 100 us;
   
   
begin

    --Instantiate UUT and define the portmaps
    uut: gfsm PORT MAP (
        key_plus_imp => key_plus_imp,
        key_minus_imp => key_minus_imp,
        key_mode_imp => key_mode_imp,
        key_action_imp => key_action_imp,
        led_alarm_ring => led_alarm_ring,
        clk => clk,
        reset =>  reset,
        selected_state =>selected_state
           
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
       
               
       
       
        wait;        
   end process;

end Behavioral;