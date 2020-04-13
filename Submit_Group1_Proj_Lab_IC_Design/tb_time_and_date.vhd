--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:49:44 21/01/2020 
-- Design Name:   
-- Module Name:   
-- Project Name:  mytimedate
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: time_and_date
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
 
ENTITY tb_time_and_date IS
END tb_time_and_date;
 
ARCHITECTURE behavior OF tb_time_and_date IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT time_and_date
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         de_set : IN  std_logic;
         de_dow : IN  std_logic_vector(2 downto 0);
         de_day : IN  std_logic_vector(5 downto 0);
         de_month : IN  std_logic_vector(4 downto 0);
         de_year : IN  std_logic_vector(7 downto 0);
         de_hour : IN  std_logic_vector(5 downto 0);
         de_min : IN  std_logic_vector(6 downto 0);
         en_1 : IN  std_logic;
         DCF_valid : OUT  std_logic;
         hh_out : OUT  std_logic_vector(4 downto 0);
         mm_out : OUT  std_logic_vector(5 downto 0);
         ss_out : OUT  std_logic_vector(5 downto 0);
         dow_out : OUT  std_logic_vector(2 downto 0);
         month_out : OUT  std_logic_vector(3 downto 0);
         year_out : OUT  std_logic_vector(6 downto 0);
         day_out : OUT  std_logic_vector(4 downto 0));
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal de_set : std_logic := '0';
   signal de_dow : std_logic_vector(2 downto 0) := (others => '0');
   signal de_day : std_logic_vector(5 downto 0) := (others => '0');
   signal de_month : std_logic_vector(4 downto 0) := (others => '0');
   signal de_year : std_logic_vector(7 downto 0) := (others => '0');
   signal de_hour : std_logic_vector(5 downto 0) := (others => '0');
   signal de_min : std_logic_vector(6 downto 0) := (others => '0');
   signal en_1 : std_logic := '0';

 	--Outputs
   signal DCF_valid : std_logic;
   signal hh_out : std_logic_vector(4 downto 0);
   signal mm_out : std_logic_vector(5 downto 0);
   signal ss_out : std_logic_vector(5 downto 0);
   signal dow_out : std_logic_vector(2 downto 0);
   signal month_out : std_logic_vector(3 downto 0);
   signal year_out : std_logic_vector(6 downto 0);
   signal day_out : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 2 ns;
	constant en1_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: time_and_date PORT MAP (
          clk => clk,
          reset => reset,
          de_set => de_set,
          de_dow => de_dow,
          de_day => de_day,
          de_month => de_month,
          de_year => de_year,
          de_hour => de_hour,
          de_min => de_min,
          en_1 => en_1,
          DCF_valid => DCF_valid,
          hh_out => hh_out,
          mm_out => mm_out,
          ss_out => ss_out,
          dow_out => dow_out,
          month_out => month_out,
          year_out => year_out,
          day_out => day_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
	
	en_1_process :process
   begin
		en_1 <= '0';
		wait for en1_period - clk_period;
		en_1 <= '1';
		wait for clk_period;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		wait for 10 ns;
		
						-- rising edge of reset along with rising edge of clock
		reset 	<= '1' after 20 ns, '0' after 22 ns,
						-- rising edge of reset with falling edge of clock
						-- reset is high till next rising edge of clock
						'1' after 161 ns, '0' after 163 ns,
						-- rising edge of reset with falling edge of clock
						-- reset becomes low by next rising edge of clock
						'1' after 189 ns, '0' after 190 ns,
						-- reset is high when DCF_valid is high
						'1' after 1406 ns, '0' after 1408 ns;
						
						-- rising edge of de_set along with rising edge of clock
		de_set 	<= '1' after 320 ns, '0' after 322 ns,
						-- rising edge of de_set with falling edge of clock
						-- de_set is high till next rising edge of clock
						'1' after 981 ns, '0' after 983 ns,
						-- de_set is high for testing the time roll-offs
						'1' after 4000 ns, '0' after 4002 ns,
						'1' after 5000 ns, '0' after 5002 ns,
						'1' after 7000 ns, '0' after 7002 ns,
						'1' after 8000 ns, '0' after 8002 ns;
		
		-- 20, 25, 26, 59
		de_min 	<= "0100000" after 320 ns, "0100101" after 981 ns,
						"0100110" after 1600 ns,"1011001" after 4000 ns;
						
		-- 14, 6, 10, 23
		de_hour 	<= "010100" after 320 ns, "000110" after 981 ns,
						"010000" after 1600 ns,"100011" after 4000 ns; 
						
		-- 2, 5, 1, 6, 4
		de_dow 	<= "010" after 320 ns, "101" after 981 ns,
						"001" after 1600 ns,"110" after 4000 ns,
						"100" after 5000 ns;
						
		-- 29, 4, 10, 31, 28, 30
		de_day 	<= "101001" after 320 ns, "000100" after 981 ns,
						"000100" after 1600 ns,"110001" after 4000 ns,
						"101000" after 5000 ns, "110000" after 8000 ns;
						
		-- 12, 9, 7, 12, 2, 4
		de_month <= "10010" after 320 ns, "01001" after 981 ns,
						"00111" after 1600 ns,"10010" after 4000 ns,
						"00010" after 5000 ns, "00100" after 8000 ns; 
						
		-- 90, 10, 55, 99, 12, 13
		de_year 	<= "10010000" after 320 ns, "00010000" after 981 ns,
						"01010101" after 1600 ns,"10011001" after 4000 ns,
						"00010010" after 5000 ns, "00010011" after 7000 ns;
		
		wait;
   end process;

END;
