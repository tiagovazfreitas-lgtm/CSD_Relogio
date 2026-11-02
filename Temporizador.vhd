library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Temporizador is
    Port ( clk        : in  STD_LOGIC;
           reset      : in  STD_LOGIC;
           enable     : in  STD_LOGIC; 
           inc_min    : in  STD_LOGIC; 
           out_tomada : out STD_LOGIC; 
           Timer_Min_Tens  : out STD_LOGIC_VECTOR (3 downto 0);
           Timer_Min_Units : out STD_LOGIC_VECTOR (3 downto 0);
           Timer_Sec_Tens  : out STD_LOGIC_VECTOR (3 downto 0);
           Timer_Sec_Units : out STD_LOGIC_VECTOR (3 downto 0)
         );
end Temporizador;

architecture Behavioral of Temporizador is
    signal subsec_cnt : integer range 0 to 99_999_999 := 0;
    signal seg_en     : std_logic := '0';
    signal count_min  : integer range 0 to 59 := 0;
    signal count_sec  : integer range 0 to 59 := 0;
begin

    -- pulso a cada 1s
    process(clk, reset)
    begin
        if reset = '1' then
            subsec_cnt <= 0;
            seg_en <= '0';
        elsif rising_edge(clk) then
            if subsec_cnt = 99_999_999 then
                subsec_cnt <= 0;
                seg_en <= '1';
            else
                subsec_cnt <= subsec_cnt + 1;
                seg_en <= '0';
            end if;
        end if;
    end process;

    -- logica de Contagem e Controlo 
    process(clk, reset)
    begin
        if reset = '1' then
            count_min <= 0;
            count_sec <= 0;
            out_tomada <= '0';
        elsif rising_edge(clk) then
            if enable = '0' then
                out_tomada <= '0';
                
                if inc_min = '1' then
                    if count_min = 59 then 
                        count_min <= 0;
                    else 
                        count_min <= count_min + 1;
                    end if;
                end if;
           
            else
                --contagem com switch ativo
                if (count_min > 0 or count_sec > 0) then
                    out_tomada <= '1'; 
                    
                    if seg_en = '1' then
                        if count_sec = 0 then
                            count_sec <= 59;
                            count_min <= count_min - 1;
                        else
                            count_sec <= count_sec - 1;
                        end if;
                    end if;
                else
                    out_tomada <= '0'; 
                end if;
            end if;
        end if;
    end process;
    
    -- display 7 segmentos
    Timer_Min_Tens  <= std_logic_vector(to_unsigned(count_min / 10, 4));
    Timer_Min_Units <= std_logic_vector(to_unsigned(count_min mod 10, 4));
    Timer_Sec_Tens  <= std_logic_vector(to_unsigned(count_sec / 10, 4));
    Timer_Sec_Units <= std_logic_vector(to_unsigned(count_sec mod 10, 4));

end Behavioral;
