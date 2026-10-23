library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Watch_01 is
    Port ( Reset      : in  STD_LOGIC;
           CLK        : in  STD_LOGIC;
           Hour_Tens  : out STD_LOGIC_VECTOR (3 downto 0);
           Hour_Units : out STD_LOGIC_VECTOR (3 downto 0);
           Min_Tens   : out STD_LOGIC_VECTOR (3 downto 0);
           Min_Units  : out STD_LOGIC_VECTOR (3 downto 0);
           Sec_Tens   : out STD_LOGIC_VECTOR (3 downto 0);
           Sec_Units  : out STD_LOGIC_VECTOR (3 downto 0));
end Watch_01;

architecture Behavioral of Watch_01 is
    signal subsec_cnt : integer range 0 to 99_999_999 := 0;
    signal count_seg  : integer range 0 to 59 := 0;
    signal count_min  : integer range 0 to 59 := 0;
    signal count_hour : integer range 0 to 23 := 0;
    signal seg_en, min_en, hour_en : std_logic;
begin

    process(CLK, Reset)
    begin
        if Reset = '1' then
            subsec_cnt <= 0;
        elsif rising_edge(CLK) then
            if subsec_cnt = 99_999_999 then
                subsec_cnt <= 0;
            else
                subsec_cnt <= subsec_cnt + 1;
            end if;
        end if;
    end process;

    seg_en  <= '1' when subsec_cnt = 99_999_999 else '0';
    min_en  <= '1' when count_seg = 59 and seg_en = '1' else '0';
    hour_en <= '1' when count_min = 59 and min_en = '1' else '0';

    process(CLK, Reset)
    begin
        if Reset = '1' then
            count_seg <= 0;
        elsif rising_edge(CLK) then
            if seg_en = '1' then
                if count_seg = 59 then count_seg <= 0;
                else count_seg <= count_seg + 1;
                end if;
            end if;
        end if;
    end process;

    process(CLK, Reset)
    begin
        if Reset = '1' then
            count_min <= 0;
        elsif rising_edge(CLK) then
            if min_en = '1' then
                if count_min = 59 then count_min <= 0;
                else count_min <= count_min + 1;
                end if;
            end if;
        end if;
    end process;

    process(CLK, Reset)
    begin
        if Reset = '1' then
            count_hour <= 0;
        elsif rising_edge(CLK) then
            if hour_en = '1' then
                if count_hour = 23 then count_hour <= 0;
                else count_hour <= count_hour + 1;
                end if;
            end if;
        end if;
    end process;

    Sec_Tens   <= std_logic_vector(to_unsigned(count_seg / 10, 4));
    Sec_Units  <= std_logic_vector(to_unsigned(count_seg mod 10, 4));
    Min_Tens   <= std_logic_vector(to_unsigned(count_min / 10, 4));
    Min_Units  <= std_logic_vector(to_unsigned(count_min mod 10, 4));
    Hour_Tens  <= std_logic_vector(to_unsigned(count_hour /