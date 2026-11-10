library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity principal is
    Port ( reset           : in  STD_LOGIC;
           clk             : in  STD_LOGIC;
           btn_hour        : in  STD_LOGIC;
           btn_min         : in  STD_LOGIC;
           btn_fast        : in  STD_LOGIC;
           wth_set         : in  STD_LOGIC;   -- acerto da hora atual
           sw_sel_alarm    : in  STD_LOGIC;   -- modo alarme (mostra/acerta o alarme)
           sw_alarm        : in  STD_LOGIC;   -- ativa o alarme
           sw_enable_timer : in  STD_LOGIC;   -- sw15
           sw_display_mux  : in  STD_LOGIC;   -- sw14: timer / relógio
           led_tomada      : out STD_LOGIC;   -- ld15
           led_alarme      : out STD_LOGIC;   -- ld14
           algarismo       : out STD_LOGIC_VECTOR (7 downto 0);
           an7, an6, an5, an4, an3, an2, an1, an0 : out STD_LOGIC);
end principal;

architecture Behavioral of principal is

    COMPONENT Watch_01
        PORT( Reset      : IN  std_logic;
              CLK        : IN  std_logic;
              Inc_hour   : IN  STD_LOGIC;
              Inc_min    : IN  STD_LOGIC;
              Hold_hour  : IN  STD_LOGIC;
              Hold_min   : IN  STD_LOGIC;
              btn_fast   : IN  STD_LOGIC;
              Hour_Tens  : OUT std_logic_vector(3 downto 0);
              Hour_Units : OUT std_logic_vector(3 downto 0);
              Min_Tens   : OUT std_logic_vector(3 downto 0);
              Min_Units  : OUT std_logic_vector(3 downto 0);
              Sec_Tens   : OUT std_logic_vector(3 downto 0);
              Sec_Units  : OUT std_logic_vector(3 downto 0);
              Min_Pulse  : OUT std_logic;
              wth_set    : IN  STD_LOGIC);
    END COMPONENT;

    COMPONENT Conv_Displays
        PORT( clk, reset : IN std_logic;
              blink_en   : IN std_logic;
              display0, display1, display2, display3, display4, display5
                         : IN std_logic_vector(3 downto 0);
              an7, an6, an5, an4, an3, an2, an1, an0 : OUT std_logic;
              algarismo  : OUT std_logic_vector(7 downto 0));
    END COMPONENT;

    COMPONENT Button_Pulse
        PORT( clk, reset : IN  std_logic;
              btn_in     : IN  std_logic;
              pulse      : OUT std_logic;
              estado     : OUT std_logic);
    END COMPONENT;

    COMPONENT Alarme
        PORT ( clk              : in  STD_LOGIC;
               reset            : in  STD_LOGIC;
               Hour_Tens        : in  STD_LOGIC_VECTOR (3 downto 0);
               Hour_Units       : in  STD_LOGIC_VECTOR (3 downto 0);
               wth_set          : in  STD_LOGIC;
               Inc_hour         : in  STD_LOGIC;
               Inc_min          : in  STD_LOGIC;
               Min_Tens         : in  STD_LOGIC_VECTOR (3 downto 0);
               Min_Units        : in  STD_LOGIC_VECTOR (3 downto 0);
               pulso            : in  STD_LOGIC;
               sw_alarm         : in  STD_LOGIC;
               Alarm_out        : out STD_LOGIC;
               Hour_Alarm_Tens  : out STD_LOGIC_VECTOR (3 downto 0);
               Hour_Alarm_Units : out STD_LOGIC_VECTOR (3 downto 0);
               Min_Alarm_Tens   : out STD_LOGIC_VECTOR (3 downto 0);
               Min_Alarm_Units  : out STD_LOGIC_VECTOR (3 downto 0));
    END COMPONENT;

    COMPONENT Temporizador
        PORT ( clk, reset       : in  STD_LOGIC;
               enable           : in  STD_LOGIC;
               clear_timer      : in  STD_LOGIC;
               inc_min          : in  STD_LOGIC;
               out_tomada       : out STD_LOGIC;
               Timer_Min_Tens   : out STD_LOGIC_VECTOR (3 downto 0);
               Timer_Min_Units  : out STD_LOGIC_VECTOR (3 downto 0);
               Timer_Sec_Tens   : out STD_LOGIC_VECTOR (3 downto 0);
               Timer_Sec_Units  : out STD_LOGIC_VECTOR (3 downto 0));
    END COMPONENT;

    -- Relógio e alarme
    signal h_t, h_u, m_t, m_u, s_t, s_u : std_logic_vector(3 downto 0);
    signal ha_t, ha_u, ma_t, ma_u       : std_logic_vector(3 downto 0);
    signal p_hour, p_min, p_fast        : std_logic;
    signal h_hour, h_min                : std_logic;
    signal pulso_min, alarm_out_s       : std_logic;

    -- Temporizador
    signal t_min_tens, t_min_units, t_sec_tens, t_sec_units : std_logic_vector(3 downto 0);

    -- Modos (cada botão tem um só destino)
    signal mode_timer, mode_alarm, mode_clock : std_logic;

    -- Sinais encaminhados
    signal w_inc_hour, w_inc_min, w_hold_hour, w_hold_min, w_fast, w_set : std_logic;
    signal a_inc_hour, a_inc_min : std_logic;
    signal t_clear, t_inc_min    : std_logic;

    -- Mux do display
    signal d0, d1, d2, d3, d4, d5 : std_logic_vector(3 downto 0);

begin

    -- Seleção de modo (o timer tem prioridade sobre o alarme)
    mode_timer <= sw_display_mux;
    mode_alarm <= sw_sel_alarm and (not sw_display_mux);
    mode_clock <= (not sw_display_mux) and (not sw_sel_alarm);

    -- Botões com debounce e pulso
    bh : Button_Pulse port map (clk => clk, reset => reset, btn_in => btn_hour,
                                pulse => p_hour, estado => h_hour);
    bm : Button_Pulse port map (clk => clk, reset => reset, btn_in => btn_min,
                                pulse => p_min, estado => h_min);
    bf : Button_Pulse port map (clk => clk, reset => reset, btn_in => btn_fast,
                                pulse => p_fast, estado => open);

    -- Encaminhamento: cada pulso vai só para um destino
    w_inc_hour  <= p_hour and mode_clock;
    w_inc_min   <= p_min  and mode_clock;
    w_hold_hour <= h_hour and mode_clock;
    w_hold_min  <= h_min  and mode_clock;
    w_fast      <= p_fast and mode_clock;
    w_set       <= wth_set and mode_clock;

    a_inc_hour  <= p_hour and mode_alarm;
    a_inc_min   <= p_min  and mode_alarm;

    t_clear     <= p_hour and mode_timer;
    t_inc_min   <= p_min  and mode_timer;

    r : Watch_01
        port map (Reset => reset, CLK => clk,
                  Inc_hour => w_inc_hour, Inc_min => w_inc_min,
                  Hold_hour => w_hold_hour, Hold_min => w_hold_min,
                  btn_fast => w_fast,
                  Hour_Tens => h_t, Hour_Units => h_u,
                  Min_Tens => m_t, Min_Units => m_u,
                  Sec_Tens => s_t, Sec_Units => s_u,
                  Min_Pulse => pulso_min,
                  wth_set => w_set);

    alarm : Alarme
        port map (clk => clk, reset => reset,
                  Hour_Tens => h_t, Hour_Units => h_u,
                  Min_Tens => m_t, Min_Units => m_u,
                  wth_set => mode_alarm,
                  Inc_hour => a_inc_hour, Inc_min => a_inc_min,
                  pulso => pulso_min,
                  sw_alarm => sw_alarm,
                  Alarm_out => alarm_out_s,
                  Hour_Alarm_Tens => ha_t, Hour_Alarm_Units => ha_u,
                  Min_Alarm_Tens => ma_t, Min_Alarm_Units => ma_u);

    temp_inst : Temporizador
        port map (clk => clk, reset => reset,
                  enable => sw_enable_timer,
                  clear_timer => t_clear,
                  inc_min => t_inc_min,
                  out_tomada => led_tomada,
                  Timer_Min_Tens => t_min_tens, Timer_Min_Units => t_min_units,
                  Timer_Sec_Tens => t_sec_tens, Timer_Sec_Units => t_sec_units);

    led_alarme <= alarm_out_s;

    -- Mux do display: timer > alarme > relógio
    d5 <= "0000"      when mode_timer = '1' else ha_t when mode_alarm = '1' else h_t;
    d4 <= "0000"      when mode_timer = '1' else ha_u when mode_alarm = '1' else h_u;
    d3 <= t_min_tens  when mode_timer = '1' else ma_t when mode_alarm = '1' else m_t;
    d2 <= t_min_units when mode_timer = '1' else ma_u when mode_alarm = '1' else m_u;
    d1 <= t_sec_tens  when mode_timer = '1' else "0000" when mode_alarm = '1' else s_t;
    d0 <= t_sec_units when mode_timer = '1' else "0000" when mode_alarm = '1' else s_u;

    cd : Conv_Displays
        port map (clk => clk, reset => reset,
                  blink_en => (w_set or mode_alarm or alarm_out_s),
                  display0 => d0, display1 => d1, display2 => d2,
                  display3 => d3, display4 => d4, display5 => d5,
                  algarismo => algarismo,
                  an7 => an7, an6 => an6, an5 => an5, an4 => an4,
                  an3 => an3, an2 => an2, an1 => an1, an0 => an0);

end Behavioral;
