----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2026 11:49:33
-- Design Name: 
-- Module Name: principal - Behavioral
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

entity principal is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           btn_hour : in STD_LOGIC;
           btn_min : in STD_LOGIC;
           wth_set : in STD_LOGIC;
           btn_fast : in STD_LOGIC;
           sw_enable_timer : in STD_LOGIC;  --sw15 ativa a contagem 
           sw_display_mux  : in STD_LOGIC; --sw14 vai servir para alternar entre o temporizador ou o relogio (display normal)
           led_tomada : out STD_LOGIC;  --ld15 
           algarismo : out STD_LOGIC_VECTOR (7 downto 0);
           an7 : out STD_LOGIC;
           an6 : out STD_LOGIC;
           an5 : out STD_LOGIC;
           an4 : out STD_LOGIC;
           an3 : out STD_LOGIC;
           an2 : out STD_LOGIC;
           an1 : out STD_LOGIC;
           an0 : out STD_LOGIC);
end principal;

architecture Behavioral of principal is
   COMPONENT Watch_01
        PORT( Reset : IN std_logic;
              CLK : IN std_logic;
              Inc_hour : IN STD_LOGIC;
              Inc_min : IN STD_LOGIC;
              Hold_hour : IN STD_LOGIC; 
              Hold_min : IN STD_LOGIC;  
              btn_fast : IN STD_LOGIC;  
              Hour_Tens : OUT std_logic_vector(3 downto 0);
              Hour_Units : OUT std_logic_vector(3 downto 0);
              Min_Tens : OUT std_logic_vector(3 downto 0);
              Min_Units : OUT std_logic_vector(3 downto 0);
              Sec_Tens : OUT std_logic_vector(3 downto 0);
              Sec_Units : OUT std_logic_vector(3 downto 0);
              wth_set : in STD_LOGIC);
    END COMPONENT;
        
    COMPONENT Conv_Displays
    PORT(
        clk : IN std_logic;
        reset : IN std_logic;
        blink_en : IN std_logic;
        display0 : IN std_logic_vector(3 downto 0);
        display1 : IN std_logic_vector(3 downto 0);
        display2 : IN std_logic_vector(3 downto 0);
        display3 : IN std_logic_vector(3 downto 0);
        display4 : IN std_logic_vector(3 downto 0);
        display5 : IN std_logic_vector(3 downto 0);
        an7 : OUT std_logic;
        an6 : OUT std_logic;
        an5 : OUT std_logic;
        an4 : OUT std_logic;
        an3 : OUT std_logic;
        an2 : OUT std_logic;
        an1 : OUT std_logic;
        an0 : OUT std_logic;
        algarismo : OUT std_logic_vector(7 downto 0)
    );
    END COMPONENT;
    
    COMPONENT Button_Pulse
    PORT( clk, reset : IN std_logic;
          btn_in     : IN std_logic;
          pulse      : OUT std_logic;
          estado     : OUT std_logic);
    END COMPONENT;
    
    component Temporizador is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC; 
           clear_timer : in  STD_LOGIC;
           inc_min : in STD_LOGIC; 
           out_tomada : out STD_LOGIC; 
           Timer_Min_Tens : out STD_LOGIC_VECTOR (3 downto 0);
           Timer_Min_Units : out STD_LOGIC_VECTOR (3 downto 0);
           Timer_Sec_Tens : out STD_LOGIC_VECTOR (3 downto 0);
           Timer_Sec_Units : out STD_LOGIC_VECTOR (3 downto 0)
         );
    end component;
    
    -- Sinais para o relógio
    signal h_t, h_u, m_t, m_u, s_t, s_u : std_logic_vector(3 downto 0);
    signal p_hour, p_min, p_fast : std_logic;
    signal h_hour, h_min : std_logic;
    
    --Sinais para o temporizador
    signal t_min_tens, t_min_units, t_sec_tens, t_sec_units : std_logic_vector(3 downto 0);
    signal p_clear_temp : std_logic;
    --Sinais para o MUX
    signal disp0_mux, disp1_mux, disp2_mux, disp3_mux, disp4_mux, disp5_mux : std_logic_vector(3 downto 0);
       
begin
    bh : Button_Pulse
        port map (clk => clk, reset => reset, btn_in => btn_hour, pulse => p_hour, estado => h_hour);

    bm : Button_Pulse
        port map (clk => clk, reset => reset, btn_in => btn_min, pulse => p_min, estado => h_min);
    
    bf : Button_Pulse
        port map (clk => clk, reset => reset, btn_in => btn_fast, pulse => p_fast, estado => open);
    
    r : Watch_01
        port map (
            Reset => reset, 
            CLK => clk,
            Inc_hour => p_hour, 
            Inc_min => p_min,
            Hold_hour => h_hour, 
            Hold_min => h_min,
            btn_fast => p_fast, 
            Hour_Tens => h_t, 
            Hour_Units => h_u,
            Min_Tens  => m_t, 
            Min_Units  => m_u,
            Sec_Tens  => s_t, 
            Sec_Units  => s_u, 
            wth_set => wth_set
        );

    -- sw_display_mux = 0 passa a relogio
    -- sw_display_mux = 1 passa a temporizador
    disp5_mux <= h_t when sw_display_mux = '0' else "0000";
    disp4_mux <= h_u when sw_display_mux = '0' else "0000";
    disp3_mux <= m_t when sw_display_mux = '0' else t_min_tens;
    disp2_mux <= m_u when sw_display_mux = '0' else t_min_units;
    disp1_mux <= s_t when sw_display_mux = '0' else t_sec_tens; 
    disp0_mux <= s_u when sw_display_mux = '0' else t_sec_units; 

    cd : Conv_Displays
        port map (reset => reset, clk => clk,
                  blink_en => wth_set,
                  display0 => disp0_mux, display1 => disp1_mux,
                  display2 => disp2_mux, display3 => disp3_mux,
                  display4 => disp4_mux, display5 => disp5_mux,
                  algarismo => algarismo,
                  an7 => an7, an6 => an6, an5 => an5, an4 => an4,
                  an3 => an3, an2 => an2, an1 => an1, an0 => an0);
                  
    p_clear_temp <= p_hour when sw_display_mux = '1' else '0';
    temp_inst : Temporizador
        port map (
            clk             => clk,
            reset           => reset,
            enable          => sw_enable_timer,
            clear_timer     => p_clear_temp,
            inc_min         => p_min,           
            out_tomada      => led_tomada,
            Timer_Min_Tens  => t_min_tens,
            Timer_Min_Units => t_min_units,
            Timer_Sec_Tens  => t_sec_tens,
            Timer_Sec_Units => t_sec_units
        );

end Behavioral;
