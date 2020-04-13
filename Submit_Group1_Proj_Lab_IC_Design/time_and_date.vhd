----------------------------------------------------------------------------------
-- Company: 
-- Engineer:      Md Yasir Umar
-- 
-- Create Date:    20:49:44 20/01/2020 
-- Design Name: 
-- Module Name:    time_and_date - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity time_and_date is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           de_set : in  STD_LOGIC;
           de_dow : in  STD_LOGIC_VECTOR (2 downto 0);
           de_day : in  STD_LOGIC_VECTOR (5 downto 0);
           de_month : in  STD_LOGIC_VECTOR (4 downto 0);
           de_year : in  STD_LOGIC_VECTOR (7 downto 0);
           de_hour : in  STD_LOGIC_VECTOR (5 downto 0);
           de_min : in  STD_LOGIC_VECTOR (6 downto 0);
           en_1 : in  STD_LOGIC;
           DCF_valid : out  STD_LOGIC := '0';
           hh_out : out  STD_LOGIC_VECTOR (4 downto 0);
           mm_out : out  STD_LOGIC_VECTOR (5 downto 0);
           ss_out : out  STD_LOGIC_VECTOR (5 downto 0);
           dow_out : out  STD_LOGIC_VECTOR (2 downto 0);
           month_out : out  STD_LOGIC_VECTOR (3 downto 0);
           year_out : out  STD_LOGIC_VECTOR (6 downto 0);
           day_out : out  STD_LOGIC_VECTOR (4 downto 0));
end time_and_date;

architecture Behavioral of time_and_date is
type state is (dcf_state, time_state);
signal binary_de_min,binary_de_hour,binary_de_day,binary_de_month,binary_de_year,dcf_min,dcf_hour,dcf_day,dcf_month: STD_LOGIC_VECTOR (7 downto 0);  --BCD to binary conversion

begin
	
	--padding to make 8 bits
	
    dcf_min <= "0"&de_min;      
    dcf_hour <= "00"&de_hour;
    dcf_day <= "00"&de_day;
    dcf_month <= "000"&de_month;
	
	--BCD to binary conversion
	
	binary_de_min 		<= dcf_min(3 downto 0)*"01" + dcf_min(7 downto 4)*"1010";
	binary_de_hour 	    <= dcf_hour(3 downto 0)*"01" + dcf_hour(7 downto 4)*"1010";
	binary_de_day 		<= dcf_day(3 downto 0)*"01" + dcf_day(7 downto 4)*"1010";
	binary_de_month	    <= dcf_month(3 downto 0)*"01" + dcf_month(7 downto 4)*"1010";
	binary_de_year	    <= de_year(3 downto 0)*"01" + de_year(7 downto 4)*"1010";
	

	State_proc: process(clk, reset, de_set)
		
		
		variable tmp_ss : integer range 0 to 60 := 0;
		variable tmp_mm : integer range 0 to 60 := 0;
		variable tmp_hh : integer range 0 to 24 := 0;
		variable tmp_day : integer range 1 to 32 := 1;
		variable tmp_dow : integer range 0 to 7 := 1;
		variable tmp_month : integer range 1 to 13 := 1;
		variable tmp_year : integer range 0 to 100 := 1;
		variable tmp_DCF_valid : STD_LOGIC := '0'; -- variable to check valid DCF
		variable days_in_month : integer range 1 to 32 := 32;  
		variable curr_state: state := time_state; --default state
		
		begin
			if (clk'event and clk = '1') then
			
				if (reset = '1') then
					-- default counter value Mo, 01.01.01
					tmp_ss 	:= 0;
					tmp_mm 	:= 0;
					tmp_hh 	:= 0;
					tmp_day 	:= 1;
					tmp_dow 	:= 1;
					tmp_month := 1;
					tmp_year 	:= 1;
					tmp_DCF_valid	:= '0';
					curr_state := time_state;
					
				else
					case curr_state is 
						when time_state =>
							if (de_set = '1') then  --check dcf valid
								curr_state := dcf_state;
							else 
								if (en_1 = '1') then --high 1 sec clock
								tmp_ss := tmp_ss + 1; --ss counter
								
								if (tmp_ss = 60) then 
									tmp_DCF_valid := '0';
									tmp_ss := 0;         -- ss counter reset after 60
									tmp_mm := tmp_mm + 1; -- mm counter start
								end if;

								if (tmp_mm = 60) then 
									tmp_mm := 0;       -- mm counter reset after 60
									tmp_hh := tmp_hh +1; --hh counter start
								end if;
								

								if (tmp_hh = 24) then 
									tmp_hh := 0;      -- hh counter reset
									tmp_dow := tmp_dow + 1; -- dow counter start
									tmp_day := tmp_day + 1; -- day counter start
								end if;
								
								if (tmp_dow = 7) then 
									tmp_dow := 0; --dow weekly reset
								end if;
								
								
								if (tmp_month = 2 and (tmp_year mod 4) = 0) then --leap year check
									days_in_month := 30;
								elsif (tmp_month = 2) then 
									days_in_month := 29;
								elsif 
									(tmp_month = 1 or -- Jan
									 tmp_month = 3 or -- Mar
									 tmp_month = 5 or -- May
									 tmp_month = 7 or -- Jul
									 tmp_month = 8 or -- Aug
									 tmp_month = 10 or -- Oct
									 tmp_month = 12) then -- Dec
									 days_in_month := 32;
								else
									days_in_month := 31; -- rest months
								end if;

								if (tmp_day = days_in_month) then 
									tmp_day := 1;
									tmp_month := tmp_month + 1; --month counter
								end if; 
								

								if (tmp_month = 13) then 
									tmp_month := 1;
									tmp_year := tmp_year + 1; -- year counter
								end if; 
								

								if (tmp_year = 100) then 
									tmp_year := 0; --year reset after 100 years
								end if;	
								
							end if;
						end if;
					
					when dcf_state =>
						tmp_DCF_valid := '1';
						tmp_ss 	:= 0;
						tmp_mm 	:= to_integer(unsigned(binary_de_min));       
						tmp_hh 	:= to_integer(unsigned(binary_de_hour));      
						tmp_day 	:= to_integer(unsigned(binary_de_day));   
						tmp_dow 	:= to_integer(unsigned(de_dow));          
						tmp_month := to_integer(unsigned(binary_de_month));   
						tmp_year 	:= to_integer(unsigned(binary_de_year));  
						curr_state  := time_state;
						
					when others => 
						 --idle state
				end  case;
				
			end if;
			
			DCF_valid <= tmp_DCF_valid;
			hh_out <= std_logic_vector(to_unsigned(tmp_hh, hh_out'length));          --final binary hh out
			mm_out <= std_logic_vector(to_unsigned(tmp_mm, mm_out'length));          --final binary mm out
			ss_out <= std_logic_vector(to_unsigned(tmp_ss, ss_out'length));          --final binary ss out
			dow_out <= std_logic_vector(to_unsigned(tmp_dow, dow_out'length));       --final binary dow out
			day_out <= std_logic_vector(to_unsigned(tmp_day, day_out'length));       --final binary day out
			month_out <= std_logic_vector(to_unsigned(tmp_month, month_out'length)); --final binary month out
			year_out <= std_logic_vector(to_unsigned(tmp_year, year_out'length));    --final binary year out
		end if;
				
	end process State_proc;
end;
