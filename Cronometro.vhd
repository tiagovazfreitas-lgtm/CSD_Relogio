library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Cronometro is
    Port ( clk              : in  STD_LOGIC;
           reset            : in  STD_LOGIC;
           enable           : in  STD_LOGIC; -- inicia/para
           clear_crono      : in  STD_LOGIC; -- coloca a zero
           Crono_Min_Tens   : out STD_LOGIC_VECTOR (3 downto 0);
           Crono_Min_Units  : out STD_LOGIC_VECTOR (3 downto 0);
           Crono_Sec_Tens   : out STD_LOGIC_VECTOR (3 downto 0);
           Crono_Sec_Units  : out STD_LOGIC_VECTOR (3 downto 0);
           Crono_Cent_Tens  : out STD_LOGIC_VECTOR (3 downto 0);
           Crono_Cent_Units : out STD_LOGIC_VECTOR (3 downto 0));
end Cronometro;

architecture Behavioral of Cronometro is

    signal subsec_cnt : integer range 0 to 999_999 := 0; 
    signal cent_en    : std_logic := '0';

    -- Contadores
    signal count_cent : integer range 0 to 99 := 0;
    signal count_sec  : integer range 0 to 59 := 0;
    signal count_min  : integer range 0 to 59 := 0;
begin

    -- 1 pulso por 1 centesimo de segundo
    process(clk, reset)
    begin
        if reset = '1' then
            subsec_cnt <= 0;
            cent_en <= '0';
        elsif rising_edge(clk) then
            if subsec_cnt = 999_999 then
                subsec_cnt <= 0;
                cent_en <= '1';
            else
                subsec_cnt <= subsec_cnt + 1;
                cent_en <= '0';
            end if;
        end if;
    end process;

    -- logica do cronometro
    process(clk, reset)
    begin
        if reset = '1' then
            count_cent <= 0;
            count_sec  <= 0;
            count_min  <= 0;
        elsif rising_edge(clk) then
            if clear_crono = '1' then
                -- cronometro a 0 ao premir o botao
                count_cent <= 0;
                count_sec  <= 0;
                count_min  <= 0;
            elsif enable = '1' then
                -- switch start a 1
                if cent_en = '1' then
                    if count_cent = 99 then
                        count_cent <= 0;
                        if count_sec = 59 then
                            count_sec <= 0;
                            if count_min = 59 then
                                count_min <= 0;
                            else
                                count_min <= count_min + 1;
                            end if;
                        else
                            count_sec <= count_sec + 1;
                        end if;
                    else
                        count_cent <= count_cent + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- 3. Separação para os Displays de 7 Segmentos (MM:SS:CC)
    Crono_Min_Tens   <= std_logic_vector(to_unsigned(count_min / 10, 4));
    Crono_Min_Units  <= std_logic_vector(to_unsigned(count_min mod 10, 4));
    Crono_Sec_Tens   <= std_logic_vector(to_unsigned(count_sec / 10, 4));
    Crono_Sec_Units  <= std_logic_vector(to_unsigned(count_sec mod 10, 4));
    Crono_Cent_Tens  <= std_logic_vector(to_unsigned(count_cent / 10, 4));
    Crono_Cent_Units <= std_logic_vector(to_unsigned(count_cent mod 10, 4));

end Behavioral;
