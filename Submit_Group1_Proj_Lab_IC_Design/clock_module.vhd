----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:55:49 04/30/2013 
-- Design Name: 
-- Module Name:    clockMain - Behavioral 
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
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity clock_module is
    Port ( clk : in  std_logic;
           reset : in  std_logic;
           en_1K : in  std_logic;
           en_100 : in  std_logic;
           en_10 : in  std_logic;
           en_1 : in  std_logic;
  
           key_action_imp : in  std_logic;
  key_action_long : in std_logic;
           key_mode_imp : in  std_logic;
           key_minus_imp : in  std_logic;
           key_plus_imp : in  std_logic;
           key_plus_minus : in  std_logic;
           key_enable : in  std_logic;
  
           de_set : in  std_logic;
           de_dow : in  std_logic_vector (2 downto 0);
           de_day : in  std_logic_vector (5 downto 0);
           de_month : in  std_logic_vector (4 downto 0);
           de_year : in  std_logic_vector (7 downto 0);
           de_hour : in  std_logic_vector (5 downto 0);
           de_min : in  std_logic_vector (6 downto 0);
  
           led_alarm_act : out  std_logic;
           led_alarm_ring : out  std_logic;
           led_countdown_act : out  std_logic:= '0';
           led_countdown_ring : out  std_logic:= '0';
           led_switch_act : out  std_logic:= '0';
           led_switch_on : out  std_logic := '0';
  
  lcd_en : out std_logic;
  lcd_rw : out std_logic;
  lcd_rs : out std_logic;
  lcd_data : out std_logic_vector(7 downto 0)
  
  -- OLED signal only for development
  --oled_en : out std_logic;
  --oled_dc : out std_logic;
  --oled_data : out std_logic;
  --oled_reset : out std_logic;
  --oled_vdd : out std_logic;
  --oled_vbat : out std_logic
);
end clock_module;

architecture Behavioral of clock_module is

component gfsm is
    Port ( key_plus_imp : in STD_LOGIC;
           key_minus_imp : in STD_LOGIC;
           key_mode_imp : in STD_LOGIC;
           key_action_imp : in STD_LOGIC;
           led_alarm_ring : in STD_LOGIC;--to check in every state if the alarm is ringing
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           selected_state : out STD_LOGIC_VECTOR (2 downto 0));
end component;



component time_and_date is
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
           
           
end component;


component alarm_main_module is
 Port ( clk               :   in STD_LOGIC;
       reset              :   in STD_LOGIC;
       mode               :   in std_logic_vector(2 downto 0); 
       en_1               :   in STD_LOGIC;
       en_10             :   in STD_LOGIC;
       actual_hr          : in std_logic_vector(5 downto 0);
       actual_min         : in std_logic_vector(6 downto 0);
       actual_sec         : in std_logic_vector(6 downto 0);
       key_enable        :   in STD_LOGIC;
       key_plus_minus       :   in STD_LOGIC;
       key_act_imp        :   in STD_LOGIC;
       key_act_long       :   in STD_LOGIC;
       led_alarm_ring     :   out STD_LOGIC;
       led_alarm_act      :   out STD_LOGIC;
       snooze_act         :   out STD_LOGIC;
       set_hr             : out std_logic_vector(5 downto 0);
       set_min            : out std_logic_vector(6 downto 0)
 );
end component;


component stopwatch is
Port(   clock    : in   STD_LOGIC;
  reset    : in   STD_LOGIC;
  key_action_imp : in   STD_LOGIC;
  key_plus_imp : in   STD_LOGIC;
  key_minus_imp : in   STD_LOGIC; 
  led_alarm_ring : in   STD_LOGIC;
  current_mode : in   STD_LOGIC_VECTOR(2 downto 0); 
  en_100    : in   STD_LOGIC;  
  sw_lap          : OUT  std_logic;  
  sw_hh    : out  STD_LOGIC_VECTOR (6 downto 0); 
  sw_mm    : out  STD_LOGIC_VECTOR (5 downto 0); 
  sw_ss    : out  STD_LOGIC_VECTOR (5 downto 0); 
  sw_ms    : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

component binary2bcd is
    Port ( binary : in  STD_LOGIC_VECTOR (7 downto 0);
           hundreds : out  STD_LOGIC_VECTOR (3 downto 0);
           tens : out  STD_LOGIC_VECTOR (3 downto 0);
           ones : out  STD_LOGIC_VECTOR (3 downto 0));
end component;





component Data_Mux is
    Port ( state : in  STD_LOGIC_VECTOR (2 downto 0);
           data_bus_dt : in  STD_LOGIC_VECTOR (41 downto 0);
           data_bus_al : in  STD_LOGIC_VECTOR (12 downto 0);
           data_bus_sw : in  STD_LOGIC_VECTOR (29 downto 0);
           data_bus : out  STD_LOGIC_VECTOR (49 downto 0));
end component;

component DataConfig is
    Port (  clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            state : in  STD_LOGIC_VECTOR (2 downto 0);
            data_bus : in  STD_LOGIC_VECTOR (49 downto 0);
            active_a : in  STD_LOGIC;
            active_sw : in  STD_LOGIC;
            DCF : in  STD_LOGIC;
            snooze : in  STD_LOGIC;
            lcd_en : out  STD_LOGIC;
            lcd_rw : out  STD_LOGIC;
            lcd_rs : out  STD_LOGIC;
            lcd_data : out  STD_LOGIC_VECTOR (7 downto 0));
end component;


signal selected_state : STD_LOGIC_VECTOR(2 downto 0);
signal snooze,DCF : STD_LOGIC;
signal data_bus : STD_LOGIC_VECTOR(49 downto 0);
signal data_bus_dt : STD_LOGIC_VECTOR(41 downto 0) ;
signal data_bus_al : STD_LOGIC_VECTOR(12 downto 0);
signal data_bus_sw : STD_LOGIC_VECTOR(29 downto 0);
signal alarm_act, sw_lap,alarm_ring : STD_LOGIC;
signal sw_hh_bin,sw_ms_bin : STD_LOGIC_VECTOR (6 downto 0);
signal sw_mm_bin,sw_ss_bin : STD_LOGIC_VECTOR (5 downto 0);
signal swhh_h, swhh_t, swhh_o,swmm_h, swmm_t, swmm_o,swss_h, swss_t, swss_o,swms_h, swms_t, swms_o : std_logic_vector (3 downto 0);
signal bin_sw_hh,bin_sw_ms : std_logic_vector(7 downto 0);
signal bin_sw_mm,bin_sw_ss : std_logic_vector(7 downto 0);

signal time_hh_bin , date_day_bin : std_logic_vector(4 downto 0);
signal time_mm_bin , time_ss_bin : std_logic_vector(5 downto 0);
signal date_year_bin : std_logic_vector(6 downto 0);
signal date_month_bin: std_logic_vector(3 downto 0);
signal date_dow_bin : std_logic_vector(2 downto 0);

signal pad_time_hh,pad_time_mm,pad_time_ss,pad_date_dow,pad_date_month,pad_date_year,pad_date_day : std_logic_vector (7 downto 0);
signal hh_h, hh_t, hh_o,mm_h, mm_t, mm_o,ss_h, ss_t, ss_o, dow_h, dow_t, dow_o,yr_h,yr_t,yr_o,mon_h,mon_t,mon_o,day_h,day_t,day_o  : std_logic_vector (3 downto 0);


signal c_act,c_ring,c_act_cd : std_logic;
signal c_hh_bin : STD_LOGIC_VECTOR (4 downto 0);
signal c_mm_bin : STD_LOGIC_VECTOR (5 downto 0);
signal c_ss_bin : STD_LOGIC_VECTOR (5 downto 0);
signal pad_c_hh,pad_c_mm,pad_c_ss : std_logic_vector (7 downto 0);
signal chh_h,chh_t,chh_o,cmm_h,cmm_t,cmm_o,css_h,css_t,css_o : std_logic_vector (3 downto 0);
signal data_bus_cd : std_logic_vector (19 downto 0);

begin
global_fsm : gfsm 
    Port map ( 
            key_plus_imp => key_plus_imp,
            key_minus_imp => key_minus_imp,
            key_mode_imp => key_mode_imp,
            key_action_imp => key_action_imp,
            clk => clk,
            reset => reset,
            selected_state => selected_state,
            led_alarm_ring => alarm_ring
);






time_date : time_and_date 
    Port map ( clk => clk,
           reset => reset,
           de_set => de_set,
           de_dow => de_dow,
           de_day => de_day,
           de_month => de_month,
           de_year => de_year,
           de_hour => de_hour,
           de_min => de_min,
           en_1 => en_1,
           DCF_valid => DCF,
           hh_out => time_hh_bin,
           mm_out => time_mm_bin,
           ss_out => time_ss_bin,
           dow_out => date_dow_bin,
           month_out => date_month_bin,
           year_out => date_year_bin,
           day_out => date_day_bin
           );



pad_time_hh <= "000" & time_hh_bin;
pad_time_mm <= "00" & time_mm_bin;
pad_time_ss <= "00" & time_ss_bin;
pad_date_dow <= "00000" & date_dow_bin;
pad_date_month <= "0000" & date_month_bin;
pad_date_year <= "0" & date_year_bin;
pad_date_day <= "000" & date_day_bin;



time_bcd_hh : binary2bcd port map(binary => pad_time_hh, hundreds =>hh_h, tens=>hh_t, ones=>hh_o);
time_bcd_mm : binary2bcd port map(binary => pad_time_mm, hundreds => mm_h, tens=> mm_t, ones=>mm_o);
time_bcd_ss : binary2bcd port map(binary => pad_time_ss, hundreds => ss_h, tens=> ss_t, ones=>ss_o);
date_bcd_dow : binary2bcd port map(binary => pad_date_dow, hundreds =>dow_h, tens=>dow_t, ones=>dow_o);
date_bcd_month : binary2bcd port map(binary => pad_date_month, hundreds =>mon_h, tens=>mon_t, ones=>mon_o);
date_bcd_year : binary2bcd port map(binary => pad_date_year, hundreds =>yr_h, tens=>yr_t, ones=>yr_o);
date_bcd_day : binary2bcd port map(binary => pad_date_day, hundreds =>day_h, tens=>day_t, ones=>day_o);


data_bus_dt <= yr_t & yr_o & mon_t(0) & mon_o & day_t(1 downto 0) & day_o & dow_o(2 downto 0) & ss_t(2 downto 0) & ss_o & mm_t(2 downto 0) & mm_o & hh_t(1 downto 0) & hh_o;



func_alarm : alarm_main_module 
 Port map( 
            clk => clk,              
            reset => reset,   
            mode => selected_state,         
            en_1 => en_1,             
            en_10 => en_10,          
            actual_hr => data_bus_dt(5 downto 0),       
            actual_min => data_bus_dt(12 downto 6),      
            actual_sec => data_bus_dt(19 downto 13),      
            key_enable => key_enable,         
            key_plus_minus  =>  key_plus_minus,      
            key_act_imp => key_action_imp,      
            key_act_long  =>  key_action_long,   
            led_alarm_ring => alarm_ring,   
            led_alarm_act => alarm_act,    
            snooze_act => snooze,       
            set_hr => data_bus_al(5 downto 0),           
            set_min  => data_bus_al(12 downto 6)         
 
 );

led_alarm_act <= alarm_act;
led_alarm_ring  <= alarm_ring;


func_stopwatch : stopwatch
 Port map(
          clock => clk,
          reset => reset,
          key_action_imp => key_action_imp,
          key_plus_imp => key_plus_imp,
          key_minus_imp => key_minus_imp,
          led_alarm_ring => alarm_ring,
      current_mode => selected_state,
          en_100 => en_100,
          sw_hh => sw_hh_bin,
          sw_mm => sw_mm_bin,
          sw_ss => sw_ss_bin,
          sw_ms => sw_ms_bin,
  sw_lap=>  sw_lap 
        ); 




bin_sw_hh <= "0" & sw_hh_bin;
bin_sw_mm <= "00" & sw_mm_bin;
bin_sw_ss <= "00" & sw_ss_bin;
bin_sw_ms <= "0" & sw_ms_bin;

sw_hours : binary2bcd port map(binary => bin_sw_hh, hundreds =>swhh_h, tens=>swhh_t, ones=>swhh_o);
sw_minutes : binary2bcd port map(binary => bin_sw_mm, hundreds => swmm_h, tens=> swmm_t, ones=>swmm_o);
sw_seconds : binary2bcd port map(binary => bin_sw_ss, hundreds => swss_h, tens=> swss_t, ones=>swss_o);
sw_milliseconds : binary2bcd port map(binary => bin_sw_ms, hundreds =>swms_h, tens=>swms_t, ones=>swms_o);


data_bus_sw <= swms_t & swms_o & swss_t(2 downto 0) & swss_o & swmm_t(2 downto 0) & swmm_o & swhh_t & swhh_o;


Data_Multiplexer : Data_Mux 
    Port map ( 
            state => selected_state,
            data_bus_dt => data_bus_dt,
            data_bus_al => data_bus_al,
            data_bus_sw => data_bus_sw,
            data_bus => data_bus 
  );
DispController : DataConfig
Port map (
            clk => clk,
            reset => reset,
            state => selected_state,
            data_bus => data_bus,
            active_a => alarm_act,
            active_sw => sw_lap,
            DCF => DCF,
            snooze => snooze, 
            
            lcd_en => lcd_en,
            lcd_rw => lcd_rw,
            lcd_rs => lcd_rs,
            lcd_data => lcd_data
            );
end Behavioral;