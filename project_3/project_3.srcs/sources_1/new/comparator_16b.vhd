----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2023 05:41:54 PM
-- Design Name: 
-- Module Name: comparator_16b - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparator_16b is
    Port ( data_a : in STD_LOGIC_VECTOR (15 downto 0);
           data_b : in STD_LOGIC_VECTOR (15 downto 0);
           equal : out STD_LOGIC;
           greater : out STD_LOGIC;
           less : out STD_LOGIC);
end comparator_16b;

architecture Behavioral of comparator_16b is

begin
    process(data_a, data_b)
    begin
        equal <= '0'; greater <= '0'; less <= '0';
        if (data_a = data_b) then
            equal <= '1';
        elsif (data_a < data_b) then
            less <= '1';
        else
            greater <= '1';
        end if;
    end process;
end Behavioral;
