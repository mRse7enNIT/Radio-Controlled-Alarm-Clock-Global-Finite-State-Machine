LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY tb_alarm IS
END tb_alarm;
 
ARCHITECTURE behavior OF tb_alarm IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alarm_main_module
    PORT(
         clk               :   in STD_LOGIC;
       reset              :   in STD_LOGIC;
       mode               :   in std_logic_vector(2 downto 0);
       en_1               :   in STD_LOGIC;
       en_10             :   in STD_LOGIC;
       actual_hr          : in std_logic_vector(5 downto 0);
       actual_min         : in std_logic_vector(6 downto 0);
       actual_sec         : in std_logic_vector(6 downto 0);
       key_enable           :   in STD_LOGIC;
       key_plus_minus          :   in STD_LOGIC;
       key_act_imp        :   in STD_LOGIC;
       key_act_long       :   in STD_LOGIC;
       led_alarm_ring     :   out STD_LOGIC;
       led_alarm_act      :   out STD_LOGIC;
       snooze_act         :   out STD_LOGIC;
       set_hr             : out std_logic_vector(5 downto 0);
       set_min            : out std_logic_vector(6 downto 0)
		
		
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal mode:   std_logic_vector(2 downto 0) := (others => '0');
   signal en_1               :   STD_LOGIC := '0';
   signal    en_10             :   STD_LOGIC := '0';
   signal actual_hr : std_logic_vector(5 downto 0) := (others => '0');
   signal actual_min : std_logic_vector(6 downto 0) := (others => '0');
   signal actual_sec : std_logic_vector(6 downto 0) := (others => '0');
   signal key_enable           :   STD_LOGIC := '0';
   signal key_plus_minus          :    STD_LOGIC := '0';
   signal key_act_imp : std_logic := '0';
   signal key_act_long : std_logic := '0';
  

  --Outputs
   signal led_alarm_ring : std_logic;
   signal led_alarm_act : std_logic;
  signal set_hr :  std_logic_vector(5 downto 0);
	 signal set_min : std_logic_vector(6 downto 0); 
   signal snooze_act : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 us;
    constant en_1_period : time := 1 sec;
    constant en_10_period : time := 10 ms;
BEGIN
 
-- Instantiate the Unit Under Test (UUT)
   uut: alarm_main_module PORT MAP (
          clk => clk,
          reset => reset,
          mode => mode,
		  en_1 => en_1,
		  en_10 => en_10,
		  actual_hr => actual_hr,
		  actual_min => actual_min,
		  actual_sec => actual_sec,
		  key_enable => key_enable,
		  key_plus_minus => key_plus_minus,
          key_act_imp => key_act_imp,
          key_act_long => key_act_long,
		 
          led_alarm_ring => led_alarm_ring,
          led_alarm_act => led_alarm_act,
           set_hr => set_hr,
		  set_min => set_min,
          snooze_act => snooze_act
        );

   -- Clock process definitions
   clock_process :process
   begin
clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;
   end process;
   
  en_1_process :process
      begin
   en_1 <= '0';
   wait for en_1_period/2;
   en_1 <= '1';
   wait for en_1_period/2;
      end process;
      
   en_100_process :process
         begin
      en_10 <= '0';
      wait for en_10_period/2;
      en_10 <= '1';
      wait for en_10_period/2;
         end process; 
 
   -- Stimulus process
   stim_proc: process
   begin 
    
    reset <= '1';
    actual_hr <= "000000";
    actual_min <= "0010110";
    actual_sec <= "0000000";
    
        wait for clk_period;
     
      reset <= '0';
       key_act_imp <= '1';
     mode <= "011";
     wait for clk_period;
     
     
     key_enable <= '1';
    key_plus_minus <= '1';
     wait for clk_period;
     
      key_enable <= '0';
    key_plus_minus <= '0';
     wait for clk_period;
     
      key_enable <= '1';
    key_plus_minus <= '1';
     wait for clk_period;
     
      key_enable <= '0';
    key_plus_minus <= '0';
     wait for clk_period;
      key_enable <= '1';
    key_plus_minus <= '1';
     wait for clk_period;
     
      key_enable <= '0';
    key_plus_minus <= '0';
     wait for clk_period;
      key_enable <= '1';
    key_plus_minus <= '1';
     wait for clk_period;
     
      key_enable <= '0';
    key_plus_minus <= '0';
     wait for clk_period;
      key_enable <= '1';
    key_plus_minus <= '1';
     wait for clk_period;
     
      key_enable <= '0';
    key_plus_minus <= '0';
     wait for clk_period;
     
      
    
     
     key_act_imp <= '0';
             
        wait for clk_period;
     
      wait for 5*clk_period;
      
       
       key_act_imp <= '1';
                   
        wait for clk_period; 
  
         key_act_imp <= '0';
                   
        wait for clk_period;
       
       wait;

end process;

END;