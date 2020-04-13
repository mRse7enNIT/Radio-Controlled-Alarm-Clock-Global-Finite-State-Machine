----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:07:08 01/30/2020 
-- Design Name: 
-- Module Name:    Dataconfig - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity DataConfig is
    Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
           state : in  STD_LOGIC_VECTOR (2 downto 0);
           data_bus : in  STD_LOGIC_VECTOR (49 downto 0);
           active_a : in  STD_LOGIC;
           active_sw : in STD_LOGIC;
           DCF : in  STD_LOGIC;
           snooze : in  STD_LOGIC;
           lcd_en : out  STD_LOGIC;
           lcd_rw : out  STD_LOGIC;
           lcd_rs : out  STD_LOGIC;
           lcd_data : out  STD_LOGIC_VECTOR (7 downto 0));
end DataConfig;

architecture Behavioral of Dataconfig is

signal counter : STD_LOGIC_VECTOR(7 downto 0) := X"00";
signal dow1, dow2 : STD_LOGIC_VECTOR (7 downto 0);
signal ens : STD_LOGIC := '1';
signal temp_state : STD_LOGIC_VECTOR(2 downto 0);
signal temp_bus : STD_LOGIC_VECTOR(49 downto 0);

begin
lcd_en <= clk and ens;
lcd_rw <= '0';

	process(clk)
	begin

	if (clk='1' and clk'event) then
		case counter is
		when X"00" =>
			lcd_rs <= '0';
			lcd_data <= X"38"; --entry mode
			counter <= X"01";
		when X"01" =>
			lcd_rs <= '0';
			lcd_data <= X"06"; --function set
			counter <= X"02";
		when X"02" =>
			lcd_rs <= '0';
			lcd_data <= X"0C"; --display on/off
			counter <= X"03";
		when X"03" =>
			ens <= '1';
			lcd_rs <= '0';
			lcd_data <= X"01"; --clear display
			counter <= X"04";
		when X"04" =>
			ens <= '0';
			counter <= X"05";
		when X"05" =>
			ens <= '0';
			counter <= X"06";
		when X"06" =>
			ens <= '0';
			counter <= X"07";
		when X"07" =>
			ens <= '0';
			counter <= X"08";
		when X"08" =>
			ens <= '0';
			counter <= X"09";
		when X"09" =>
			ens <= '0';
			counter <= X"10";
		when X"10" =>
			ens <= '0';
			counter <= X"11";
		when X"11" =>
			ens <= '0';
			counter <= X"12";
		when X"12" =>
			ens <= '0';
			counter <= X"13";
		when X"13" =>
			ens <= '0';
			counter <= X"14";
		when X"14" =>
			ens <= '0';
			counter <= X"15";
		when X"15" =>
			ens <= '0';
			counter <= X"16";
		when X"16" =>
			ens <= '0';
			counter <= X"17";
		when X"17" =>
			ens <= '0';
			counter <= X"18";
		when X"18" =>
			ens <= '0';
			counter <= X"19";
		when X"19" =>
			ens <= '0';
			counter <= X"20";
		when X"20" =>
			ens <= '1';
			lcd_rs <= '0';
			lcd_data <= X"C0"; --a40
			counter <= X"21";
		when X"21" =>
			lcd_rs <= '1';
			lcd_data <= X"41"; --A
			counter <= X"22";
		when X"22" =>
			lcd_rs <= '0';
			lcd_data <= X"d3"; --a53
			counter <= X"23";
		when X"23" =>
			lcd_rs <= '1';
			lcd_data <= X"53"; --S
			counter <= X"24";
		----------------------------------------------------first line (full screen update)
		when X"24" =>
			ens <= '1';
			temp_state <= state;
			lcd_rs <= '0';
			lcd_data <= X"87"; --a07
			counter <= X"25";
		when X"25" =>
			lcd_rs <= '1';
			if(state="100" or state="101") then
			lcd_data <= X"20"; --blank
			else
			lcd_data <= X"54"; --T
			end if;
			counter <= X"26";
		when X"26" =>
			lcd_rs <= '1';
			if(state="100" or state="101") then
			lcd_data <= X"4f"; --O
			else
			lcd_data <= X"69"; --i
			end if;
			counter <= X"27";
		when X"27" =>
			lcd_rs <= '1';
			if(state="100" or state="101") then
			lcd_data <= X"6e"; --n
			else
			lcd_data <= X"6d"; --m
			end if;
			counter <= X"28";
		when X"28" =>
			lcd_rs <= '1';
			if(state="100" or state="101") then
			lcd_data <= X"3a"; --:
			else
			lcd_data <= X"65"; --e
			end if;
			counter <= X"29";
		when X"29" =>
			lcd_rs <= '1';
			if(state="100" or state="101") then
			lcd_data <= X"20"; --blank
			else
			lcd_data <= X"3a"; --:
			end if;
			counter <= X"30";
		------------------------------------------------------third line(mode update)
		when X"30" =>
			ens <= '1';
			temp_state <= state;
			lcd_rs <= '0';
			lcd_data <= X"97"; --a17
			counter <= X"31";
		when X"31" =>
			lcd_rs <= '1';
			if (state = "111") then
			lcd_data <= X"53"; --S
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"32";
		when X"32" =>
			lcd_rs <= '1';
			if (state = "111") then
			lcd_data <= X"74"; --t
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"33";
		when X"33" =>
			lcd_rs <= '1';
			if (state = "111") then
			lcd_data <= X"6f"; --o
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"34";
		when X"34" =>
			lcd_rs <= '1';
			if (state = "111") then
			lcd_data <= X"70"; --p
			elsif (state = "010" or state = "011") then
			lcd_data <= X"41"; --A
			elsif (state = "110") then
			lcd_data <= X"54"; --T
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"35";
		when X"35" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= X"44"; --D
			elsif (state = "010" or state = "011") then
			lcd_data <= X"6c"; --l
			elsif (state = "110") then
			lcd_data <= X"69"; --i
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"36";
		when X"36" =>
			lcd_rs <= '1';
			if (state = "001" or state = "010" or state = "011") then
			lcd_data <= X"61"; --a
			elsif (state = "100" or state = "101") then
			lcd_data <= X"4f"; --O
			elsif (state = "110") then
			lcd_data <= X"6d"; --m
			elsif (state = "111") then
			lcd_data <= X"57"; --W
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"37";
		when X"37" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= X"74"; --t
			elsif (state = "010" or state = "011") then
			lcd_data <= X"72"; --r
			elsif (state = "100" or state = "101") then
			lcd_data <= X"66"; --f
			elsif (state = "110") then
			lcd_data <= X"65"; --e
			elsif (state = "111") then
			lcd_data <= X"61"; --a
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"38";
		when X"38" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= X"65"; --e
			elsif (state = "010" or state = "011") then
			lcd_data <= X"6d"; --m
			elsif (state = "100" or state = "101") then
			lcd_data <= X"66"; --f
			elsif (state = "110") then
			lcd_data <= X"72"; --r
			elsif (state = "111") then
			lcd_data <= X"74"; --t
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"39";
		when X"39" =>
			lcd_rs <= '1';
			if (state="001" or state="010" or state="011" or state="100" or state="101" or state="110") then
			lcd_data <= X"3a"; --:
			elsif (state = "111") then
			lcd_data <= X"63"; --c
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"40";
		when X"40" =>
			lcd_rs <= '1';
			if (state = "111") then
			lcd_data <= X"68"; --h
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"41";
		when X"41" =>
			lcd_rs <= '1';
			if (state = "111") then
			lcd_data <= X"3a"; --:
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"42";
		-------------------------------------------------------second line (data 1 update)
		when X"42" =>
			ens <= '1'; 
			temp_bus <= data_bus;
			lcd_rs <= '0';
			lcd_data <= X"c3"; --a43
			counter <= X"43";
		when X"43" =>
			lcd_rs <= '1';
			if (state = "100") then
			lcd_data <= X"2a"; --*
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"44";
		when X"44" =>
			lcd_rs <= '1';
			lcd_data <= X"20"; --blank
			counter <= X"45";
		when X"45" =>
			lcd_rs <= '1';
			if(state="100" or state="101") then
			lcd_data <= X"30"; --0
			else
			lcd_data <= "001100" & data_bus(5 downto 4); --time hours
			end if;
			counter <= X"46";
		when X"46" =>
			lcd_rs <= '1';
			if(state="100" or state="101") then
			lcd_data <= X"30"; --0
			else
			lcd_data <= "0011" & data_bus(3 downto 0); --time hour
			end if;
			counter <= X"47"; 
		when X"47" =>
			lcd_rs <= '1';
			lcd_data <= X"3a"; --:
			counter <= X"48";
		when X"48" =>
			lcd_rs <= '1';
			if(state="100" or state="101") then
			lcd_data <= X"30"; --0
			else
			lcd_data <= "00110" & data_bus(12 downto 10); --time minutes
			end if;
			counter <= X"49";
		when X"49" =>
			lcd_rs <= '1';
			if(state="100" or state="101") then
			lcd_data <= X"34"; --4
			else
			lcd_data <= "0011" & data_bus(9 downto 6); --time minute
			end if;
			counter <= X"50";
		when X"50" =>
			lcd_rs <= '1';
			lcd_data <= X"3a"; --:
			counter <= X"51";
		when X"51" =>
			lcd_rs <= '1';
			if(state="100" or state="101") then
			lcd_data <= X"33"; --3
			else
			lcd_data <= "00110" & data_bus(19 downto 17); --time seconds
			end if;
			counter <= X"52"; 
		when X"52" =>
			lcd_rs <= '1';
			if(state="100" or state="101") then
			lcd_data <= X"30"; --0
			else
			lcd_data <= "0011" & data_bus(16 downto 13); --time second
			end if;
			counter <= X"53"; 
		when X"53" =>
			lcd_rs <= '1';
			lcd_data <= X"20"; --blank
			counter <= X"54";
		when X"54" =>
			lcd_rs <= '1';
			lcd_data <= X"20"; --blank
			counter <= X"55";
		when X"55" =>
			lcd_rs <= '1';
			if (DCF = '1') then
			lcd_data <= X"44"; --D
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"56";
		when X"56" =>
			lcd_rs <= '1';
			if (DCF = '1') then
			lcd_data <= X"43"; --C
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"57";
		when X"57" =>
			lcd_rs <= '1';
			if (DCF = '1') then
			lcd_data <= X"46"; --F
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"58";
		------------------------------------------------------fourth line(data 2 update)
		when X"58" =>
			ens <= '1';
			lcd_rs <= '0';
			lcd_data <= X"d4"; --a54
			counter <= X"59";
		when X"59" =>
			lcd_rs <= '1';
			if (state = "111" and active_sw = '1') then
			lcd_data <= X"4c"; --L
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"60";
		when X"60" =>
			lcd_rs <= '1';
			if (state = "111" and active_sw = '1') then
			lcd_data <= X"61"; --a
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"61";
		when X"61" =>
			lcd_rs <= '1';
			if (state = "111" and active_sw = '1') then
			lcd_data <= X"70"; --p
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"62";
		when X"62" =>
			lcd_rs <= '1';
			if (state = "101") then 
			lcd_data <= X"2a"; ----time switch off * 
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"63";
		when X"63" =>
			lcd_rs <= '1';
			if (state = "111") then
			lcd_data <= "0011" & data_bus(27 downto 24); --sw_hours
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"64";
		when X"64" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= dow1; --day
			elsif (state = "100" or state = "101" or state = "110") then
			lcd_data <= X"30"; --0
			elsif (state = "111") then
			lcd_data <= "0011" & data_bus(23 downto 20); --sw_hour
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"65";
		when X"65" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= dow2; --day
			elsif (state = "100" or state = "101" or state = "110") then
			lcd_data <= X"30"; --0
			elsif (state = "111") then
			lcd_data <= X"3a"; --: 
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"66";
		when X"66" =>
			lcd_rs <= '1';
			if (state = "010" or state = "011") then
			lcd_data <= "001100" & data_bus(25 downto 24); --alarm hours
			elsif (state = "100" or state = "101" or state = "110") then
			lcd_data <= X"3a"; --:
			elsif (state = "111") then
			lcd_data <= "00110" & data_bus(34 downto 32); --stopwatch minutes 
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"67";
		when X"67" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= "001100" & data_bus(28 downto 27); --day
			elsif (state = "010" or state = "011") then
			lcd_data <= "0011" & data_bus(23 downto 20); --alarm hour
			elsif (state = "100" or state = "101" or state = "110") then
			lcd_data <= X"30"; --0
			elsif (state = "111") then
			lcd_data <= "0011" & data_bus(31 downto 28); --stopwatch minute 
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"68";
		when X"68" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= "0011" & data_bus(26 downto 23); --days
			elsif (state = "010" or state = "011" or state = "111") then
			lcd_data <= X"3a"; --:
			elsif (state = "100" or state = "101" or state = "110") then
			lcd_data <= X"36"; --6
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"69";
		when X"69" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= X"2f"; --/
			elsif (state = "010" or state = "011") then
			lcd_data <= "00110" & data_bus(32 downto 30); --alarm minutes
			elsif (state = "100" or state = "101" or state = "110") then
			lcd_data <= X"3a"; --:
			elsif (state = "111") then
			lcd_data <= "00110" & data_bus(41 downto 39); --stopwatch seconds 
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"70";
		when X"70" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= "0011000" & data_bus(33); --months
			elsif (state = "010" or state = "011") then
			lcd_data <= "0011" & data_bus(29 downto 26); --alarm minute
			elsif (state = "100" or state = "101") then
			lcd_data <= X"30"; --0
			elsif (state = "110") then
			lcd_data <= X"33"; --3
			elsif (state = "111") then
			lcd_data <= "0011" & data_bus(38 downto 35); --stopwatch second 
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"71";
		when X"71" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= "0011" & data_bus(32 downto 29); --month
			elsif (state = "100" or state = "101" or state = "110") then
			lcd_data <= X"30"; --0
			elsif (state = "111") then
			lcd_data <= X"2e"; --. 
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"72";
		when X"72" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= X"2f"; --/
			elsif (state = "111") then
			lcd_data <= "0011" & data_bus(49 downto 46); --sw mseconds 
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"73";
		when X"73" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= "0011" & data_bus(41 downto 38); --years
			elsif (state = "110") then
			lcd_data <= X"4f"; --O
			elsif (state = "111") then
			lcd_data <= "0011" & data_bus(45 downto 42); --sw msecond
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"74";
		when X"74" =>
			lcd_rs <= '1';
			if (state = "001") then
			lcd_data <= "0011" & data_bus(37 downto 34); --year
			elsif (state = "110") then
			lcd_data <= X"66"; --f
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"75";
		when X"75" =>
			lcd_rs <= '1';
			if (state = "110") then
			lcd_data <= X"66"; --f
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"76";
		when X"76" =>
			lcd_rs <= '0';
			lcd_data <= X"94"; --a14
			counter <= X"77";
		when X"77" =>
			lcd_rs <= '1';
			if (snooze = '1') then
			lcd_data <= X"5a"; --Z
			elsif (active_a = '1') then
			lcd_data <= X"2a"; --*
			else
			lcd_data <= X"20"; --blank
			end if;
			counter <= X"78";
		when X"78" =>
			ens <= '0';
			if (state /= temp_state) then 
				if(state = "100" or state = "101" or state = "110") then
				counter <= X"24";  --full screen update
				else
				counter <= X"30"; --mode update
				end if;
			elsif (data_bus(19 downto 0) /= temp_bus(19 downto 0)) then
			counter <= X"42";  --data 1 update : if display time changes
			elsif (data_bus(49 downto 20) /= temp_bus(49 downto 20)) then
			counter <= X"58";  --data 2 update : if stopwatch or alarm data changes
			else
			counter <= X"78"; 
			end if;
		when others => null;
		end case;
	end if;
	end process p1;

	p2 : process(counter)
	begin
	if (data_bus(22 downto 20) = "001") then
	dow1 <= "01001101"; --M
	dow2 <= "01101111"; --o
	elsif (data_bus(22 downto 20) = "010") then
	dow1 <= "01000100"; --D 
	dow2 <= "01101001"; --i
	elsif (data_bus(22 downto 20) = "011") then
	dow1 <= "01001101"; --M 
	dow2 <= "01101001"; --i
	elsif (data_bus(22 downto 20) = "100") then
	dow1 <= "01000100"; --D 
	dow2 <= "01101111"; --o
	elsif (data_bus(22 downto 20) = "101") then
	dow1 <= "01000110"; --F 
	dow2 <= "01110010"; --r
	elsif (data_bus(22 downto 20) = "110") then
	dow1 <= "01010011"; --S 
	dow2 <= "01100001"; --a
	elsif (data_bus(22 downto 20) = "111") then
	dow1 <= "01010011"; --S 
	dow2 <= "01101111"; --o
	else 
	dow1 <= X"20"; --blank
	dow2 <= X"20"; --blank
	end if;
	end process p2;
end Behavioral;

