----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/16/2023 03:06:34 PM
-- Design Name: 
-- Module Name: register_nb - Behavioral
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

entity register_nb is
    Generic (N : integer range 0 to 16 := 16);
    Port ( reset : in std_logic;
           clk : in std_logic;
           load : in std_logic;
           input : in std_logic_vector(N-1 downto 0);
           output : out std_logic_vector(N-1 downto 0));
end register_nb;

architecture Behavioral of register_nb is
begin
    process(reset, clk)
    begin
        if (rising_edge(clk)) then
            if reset = '1' then
                output <= (others => '0');
            elsif load = '1' then
                output <= input;
            end if;
        end if;
    end process;
end Behavioral;
