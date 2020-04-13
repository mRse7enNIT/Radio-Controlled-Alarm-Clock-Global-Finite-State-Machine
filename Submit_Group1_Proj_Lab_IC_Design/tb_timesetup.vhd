----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/24/2020 04:02:47 PM
-- Design Name: 
-- Module Name: tb_timesetup - Behavioral
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

entity tb_timesetup is
--  Port ( );
end tb_timesetup;

architecture Behavioral of tb_timesetup is

component time_setup is
  Port ( clk            :   in STD_LOGIC;
        reset           :   in STD_LOGIC;
        mode               :   in std_logic_vector(2 downto 0);
        key_enable        :   in STD_LOGIC;
        key_plus_minus       :   in STD_LOGIC;
        set_hr          : out std_logic_vector(5 downto 0);
        set_min         : out std_logic_vector(6 downto 0));
end component;


-- Inputs of the testbench
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal mode :   std_logic_vector(2 downto 0) := (others => '0');
signal key_enable : std_logic := '0';
signal key_plus_minus : std_logic := '0';
-- Ouputs of the testbench
signal set_hr             :  std_logic_vector(5 downto 0) := (others => '0');
signal set_min            : std_logic_vector(6 downto 0) := (others => '0');

   constant clk_period : time := 10 ns;
   constant en_1_period : time := 1 sec;
   constant en_100_period : time := 10 ms;
begin

--Instantiate UUT and define the portmaps
uut: time_setup PORT MAP (
        clk => clk,
        reset =>  reset,
        mode => mode,
        key_enable => key_enable,
        key_plus_minus => key_plus_minus,
        set_hr => set_hr,
        set_min => set_min
    
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
         mode <= "011";
        key_enable <= '1';
        key_plus_minus <= '0';
        
        wait for clk_period;
        
        key_enable <= '0';
        key_plus_minus <= '0';
        wait for clk_period;
        
           key_enable <= '1';
        key_plus_minus <= '0';
        wait for clk_period;
        
           key_enable <= '0';
        key_plus_minus <= '0';
        wait for clk_period;
        
           key_enable <= '1';
        key_plus_minus <= '0';
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
       
           
    wait;        
   end process;     
end Behavioral;
