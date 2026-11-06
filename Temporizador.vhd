----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.11.2026 12:32:22
-- Design Name: 
-- Module Name: Temporizador - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity Temporizador is
    Port ( clk             : in STD_LOGIC;
           reset           : in STD_LOGIC;
           enable          : in STD_LOGIC; 
           clear_timer     : in STD_LOGIC; 
           inc_min         : in STD_LOGIC; 
           out_tomada      : out STD_LOGIC; 
           Timer_Min_Tens  : out STD_LOGIC_VECTOR (3 downto 0);
           Timer_Min_Units : out STD_LOGIC_VECTOR (3 downto 0);
           Timer_Sec_Tens  : out STD_LOGIC_VECTOR (3 downto 0);
           Timer_Sec_Units : out STD_LOGIC_VECTOR (3 downto 0));
end Temporizador;

architecture Behavioral of Temporizador is
    signal cnt_1s : integer range 0 to 99999999 := 0;
    signal sec_val : integer range 0 to 59 := 0;
    signal min_val : integer range 0 to 59 := 0;
    signal tick_s : std_logic := '0';
    signal running : std_logic := '0';
begin

    -- divisor de 1 segundo pra contagem regressiva
    process(clk, reset)
    begin
        if reset = '1' then
            cnt_1s <= 0;
            tick_s <= '0';
        elsif rising_edge(clk) then
            if cnt_1s = 99_999_999 then
                cnt_1s <= 0;
                tick_s <= '1';
            else
                cnt_1s <= cnt_1s + 1;
                tick_s <= '0';
            end if;
        end if;
    end process;

    -- logica pra ajustar tempo ou rodar o timer
    process(clk, reset)
    begin
        if reset = '1' then
            min_val <= 5; -- tempo inicial padrao de teste
            sec_val <= 0;
            running <= '0';
        elsif rising_edge(clk) then
            if clear_timer = '1' then
                min_val <= 0;
                sec_val <= 0;
                running <= '0';
            elsif enable = '1' then
                running <= '1';
                if tick_s = '1' then
                    if sec_val = 0 then
                        if min_val > 0 then
                            min_val <= min_val - 1;
                            sec_val <= 59;
                        else
                            running <= '0'; -- chegou a zero
                        end if;
                    else
                        sec_val <= sec_val - 1;
                    end if;
                end if;
            else
                running <= '0';
                if inc_min = '1' then -- ajusta minutos se apertar o botao
                    if min_val = 59 then
                        min_val <= 0;
                    else
                        min_val <= min_val + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- liga a tomada se o timer ta rodando
    out_tomada <= '1' when (running = '1' and (min_val > 0 or sec_val > 0)) else '0';

    -- bcd do temporizador
    Timer_Sec_Tens  <= std_logic_vector(to_unsigned(sec_val / 10, 4));
    Timer_Sec_Units <= std_logic_vector(to_unsigned(sec_val mod 10, 4));
    Timer_Min_Tens  <= std_logic_vector(to_unsigned(min_val / 10, 4));
    Timer_Min_Units <= std_logic_vector(to_unsigned(min_val mod 10, 4));

end Behavioral;
