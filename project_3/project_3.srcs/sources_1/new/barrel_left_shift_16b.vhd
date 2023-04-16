----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2023 12:58:49 AM
-- Design Name: 
-- Module Name: barrel_left_shift_16b - Behavioral
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

entity barrel_left_shift_16b is
    Port ( shift_value : in STD_LOGIC_VECTOR (15 downto 0);
           shift_amount : in STD_LOGIC_VECTOR (15 downto 0);
           output : out STD_LOGIC_VECTOR (15 downto 0));
end barrel_left_shift_16b;

architecture Behavioral of barrel_left_shift_16b is
component barrel_left_shift_comp_16b is
    GENERIC (shift_amount : integer range 0 to 8);
    Port ( shift_value : in STD_LOGIC_VECTOR (15 downto 0);
           mux_sel : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (15 downto 0));
end component;

--type integer_array is array (0 to 8) of integer;
--constant shifts : integer_array := (8, 4, 2, 1);
signal m1, m2, m3, m4: STD_LOGIC_VECTOR (15 downto 0);
begin
    barrel_shifter_component1: barrel_left_shift_comp_16b
    generic map (shift_amount => 8)
    port map (shift_value => shift_value,
              mux_sel => shift_amount(3),
              output => m1);
              
    barrel_shifter_component2: barrel_left_shift_comp_16b
    generic map (shift_amount => 4)
    port map (shift_value => m1,
              mux_sel => shift_amount(2),
              output => m2);
              
    barrel_shifter_component3: barrel_left_shift_comp_16b
    generic map (shift_amount => 2)
    port map (shift_value => m2,
              mux_sel => shift_amount(1),
              output => m3);

    barrel_shifter_component4: barrel_left_shift_comp_16b
    generic map (shift_amount => 1)
    port map (shift_value => m3,
              mux_sel => shift_amount(0),
              output => output);  
end Behavioral;
