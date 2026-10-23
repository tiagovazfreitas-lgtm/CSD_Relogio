library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity teste_relogio is
end teste_relogio;

architecture behavior of teste_relogio is

    signal reset     : std_logic := '1';
    signal clk       : std_logic := '0';
    signal sw        : std_logic := '0';
    signal algarismo : std_logic_vector(7 downto 0);
    signal an7, an6, an5, an4, an3, an2, an1, an0 : std_logic;

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    uut : entity work.principal
        port map (
            reset     => reset,
            clk       => clk,
            sw        => sw,
            algarismo => algarismo,
            an7 => an7, an6 => an6, an5 => an5, an4 => an4,
            an3 => an3, an2 => an2, an1 => an1, an0 => an0
        );

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    stim_process : process
    begin
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 3 ms;
        sw <= '1';        -- testa também o modo MM:SS
        wait;
    end process;

end behavior;