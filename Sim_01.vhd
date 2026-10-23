----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2026 12:47:29
-- Design Name: 
-- Module Name: Sim_01 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sim_01 is
--  Port ( );
end Sim_01;

architecture Behavioral of Sim_01 is

    signal reset     : std_logic := '1'; 
    signal clk       : std_logic := '0'; 
    
    signal sec_u  : std_logic_vector(3 downto 0);
    signal sec_t  : std_logic_vector(3 downto 0);
    signal min_u  : std_logic_vector(3 downto 0);
    signal min_t  : std_logic_vector(3 downto 0);
    signal hour_u : std_logic_vector(3 downto 0);
    signal hour_t : std_logic_vector(3 downto 0);
 
    constant CLK_PERIOD : time := 10 ns;  -- 100 MHz  

begin
     uut : entity work.Watch_01
        port map ( 
            CLK        => clk,
            RESET      => reset,
            sec_units  => sec_u,
            sec_Tens   => sec_t,
            min_Units  => min_u,
            min_Tens   => min_t,
            hour_Units => hour_u,
            hour_Tens  => hour_t 
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
        wait;   
    end process; 

end Behavioral;
