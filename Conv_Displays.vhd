----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2026 11:39:47
-- Design Name: 
-- Module Name: Conv_Displays - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Conv_Displays is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           display0 : in STD_LOGIC_VECTOR (3 downto 0);
           display1 : in STD_LOGIC_VECTOR (3 downto 0);
           display2 : in STD_LOGIC_VECTOR (3 downto 0);
           display3 : in STD_LOGIC_VECTOR (3 downto 0);
           display4 : in STD_LOGIC_VECTOR (3 downto 0);
           display5 : in STD_LOGIC_VECTOR (3 downto 0);
           an7 : out STD_LOGIC;
           an6 : out STD_LOGIC;
           an5 : out STD_LOGIC;
           an4 : out STD_LOGIC;
           an3 : out STD_LOGIC;
           an2 : out STD_LOGIC;
           an1 : out STD_LOGIC;
           an0 : out STD_LOGIC;
           algarismo : out STD_LOGIC_VECTOR (7 downto 0));
           inc_hour : 
end Conv_Displays;

architecture Behavioral of conv_displays is
signal alg : integer range 0 to 9;
signal cont_clock : integer range 0 to 599999;
signal num_alg : std_logic_vector(2 downto 0);

begin

co: process (clk, reset)
begin
    if reset = '1' then
        cont_clock <= 0;
        num_alg    <= "000";
    elsif clk'event and clk = '1' then
        if cont_clock = 599999 then
            cont_clock <= 0;
            num_alg <= "000";
        else
            if    cont_clock = 99999  then num_alg <= "001";
            elsif cont_clock = 199999 then num_alg <= "010";
            elsif cont_clock = 299999 then num_alg <= "011";
            elsif cont_clock = 399999 then num_alg <= "100";
            elsif cont_clock = 499999 then num_alg <= "101";
            end if;
            cont_clock <= cont_clock + 1;
        end if;
    end if;
    
end process;

an : process(clk, reset)
begin
    if reset = '1' then
        an7 <= '1';
        an6 <= '1';
        an5 <= '1';
        an4 <= '1';
        an3 <= '1';
        an2 <= '1';
        an1 <= '1';
        an0 <= '1';
        alg <= 0;
        algarismo(7) <= '1';
    elsif clk'event and clk = '1' then
        an7 <= '1'; an6 <= '1'; an5 <= '1'; an4 <= '1';
        an3 <= '1'; an2 <= '1'; an1 <= '1'; an0 <= '1';
        algarismo(7) <= '1';
        case num_alg is
            when "000" => an0 <= '0'; alg <= to_integer(unsigned(display0));
            when "001" => an1 <= '0'; alg <= to_integer(unsigned(display1));
            when "010" => an2 <= '0'; alg <= to_integer(unsigned(display2));
                          algarismo(7) <= '0';   -- ponto entre MM e SS
            when "011" => an3 <= '0'; alg <= to_integer(unsigned(display3));
            when "100" => an4 <= '0'; alg <= to_integer(unsigned(display4));
                          algarismo(7) <= '0';   -- ponto entre HH e MM
            when others => an5 <= '0'; alg <= to_integer(unsigned(display5));
        end case;
        
     end if;
end process;

al : process(clk, reset)
begin
    if reset = '1' then
        algarismo(6 downto 0) <= "0000001";
    elsif clk'event and clk = '1' then
        case alg is
            when 0 => algarismo(6 downto 0) <= "1000000";
            when 1 => algarismo(6 downto 0) <= "1111001";
            when 2 => algarismo(6 downto 0) <= "0100100";
            when 3 => algarismo(6 downto 0) <= "0110000";
            when 4 => algarismo(6 downto 0) <= "0011001";
            when 5 => algarismo(6 downto 0) <= "0010010";
            when 6 => algarismo(6 downto 0) <= "0000010";
            when 7 => algarismo(6 downto 0) <= "1111000";
            when 8 => algarismo(6 downto 0) <= "0000000";
            when 9 => algarismo(6 downto 0) <= "0010000";
            when others => algarismo(6 downto 0) <= "0001110";
        end case;
     end if;
    end process;
end Behavioral;