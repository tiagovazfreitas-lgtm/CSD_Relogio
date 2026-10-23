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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity principal is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           algarismo : out STD_LOGIC_VECTOR (7 downto 0);
           btn_hour : in STD_LOGIC;
           btn_min : in STD_LOGIC;
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
        PORT( Reset      : IN  std_logic;
              CLK        : IN  std_logic;
              Inc_hour : IN STD_LOGIC;
              Inc_min : IN STD_LOGIC;
              Hour_Tens  : OUT std_logic_vector(3 downto 0);
              Hour_Units : OUT std_logic_vector(3 downto 0);
              Min_Tens   : OUT std_logic_vector(3 downto 0);
              Min_Units  : OUT std_logic_vector(3 downto 0);
              Sec_Tens   : OUT std_logic_vector(3 downto 0);
              Sec_Units  : OUT std_logic_vector(3 downto 0)
             );
        END COMPONENT;
        
    COMPONENT Conv_Displays
    PORT(
        clk : IN std_logic;
        reset : IN std_logic;
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
    
    signal h_t, h_u, m_t, m_u, s_t, s_u : std_logic_vector(3 downto 0);
    signal d0, d1, d2, d3, d4, d5       : std_logic_vector(3 downto 0);
        
begin

    r : Watch_01
        port map (Reset => reset, CLK => clk,
                  Hour_Tens => h_t, Hour_Units => h_u,
                  Min_Tens  => m_t, Min_Units  => m_u,
                  Sec_Tens  => s_t, Sec_Units  => s_u);


    cd : conv_displays
        port map (reset => reset, clk => clk,
                  display0 => s_u, display1 => s_t,
                  display2 => m_u, display3 => m_t,
                  display4 => h_u, display5 => h_t,
                  algarismo => algarismo,
                  an7 => an7, an6 => an6, an5 => an5, an4 => an4,
                  an3 => an3, an2 => an2, an1 => an1, an0 => an0);

end Behavioral;