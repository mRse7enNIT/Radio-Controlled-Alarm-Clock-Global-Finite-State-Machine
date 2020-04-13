--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:07:02 01/30/2020
-- Design Name:   
-- Module Name:   G:/VHDL/code_testing/testcentre/tb_dataconfig.vhd
-- Project Name:  testcentre
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DataConfig
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_dataconfig IS
END tb_dataconfig;
 
ARCHITECTURE behavior OF tb_dataconfig IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DataConfig
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         state : IN  std_logic_vector(2 downto 0);
         data_bus : IN  std_logic_vector(49 downto 0);
         active_a : IN  std_logic;
         active_sw : IN  std_logic;
         DCF : IN  std_logic;
         snooze : IN  std_logic;
         lcd_en : OUT  std_logic;
         lcd_rw : OUT  std_logic;
         lcd_rs : OUT  std_logic;
         lcd_data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal state : std_logic_vector(2 downto 0) := (others => '0');
   signal data_bus : std_logic_vector(49 downto 0) := (others => '0');
   signal active_a : std_logic := '0';
   signal active_sw : std_logic := '0';
   signal DCF : std_logic := '0';
   signal snooze : std_logic := '0';

 	--Outputs
   signal lcd_en : std_logic;
   signal lcd_rw : std_logic;
   signal lcd_rs : std_logic;
   signal lcd_data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DataConfig PORT MAP (
          clk => clk,
          reset => reset,
          state => state,
          data_bus => data_bus,
          active_a => active_a,
          active_sw => active_sw,
          DCF => DCF,
          snooze => snooze,
          lcd_en => lcd_en,
          lcd_rw => lcd_rw,
          lcd_rs => lcd_rs,
          lcd_data => lcd_data
        );

   -- Clock process definitions
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		state <= "000";
		wait for clk_period*10;
		state <= "101";
		wait for clk_period*100;
		state <= "000";
		wait for clk_period*100;
		data_bus <= "00000000000000000000000000000000000000000000000001";
		wait;
      
   end process;

END;
