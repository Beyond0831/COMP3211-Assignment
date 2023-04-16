----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2023 01:17:31 AM
-- Design Name: 
-- Module Name: barrel_left_shift_comp_16b - Behavioral
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

entity barrel_left_shift_comp_16b is
    GENERIC (shift_amount : integer range 0 to 8 := 8);
    Port ( shift_value : in STD_LOGIC_VECTOR (15 downto 0);
           mux_sel : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (15 downto 0));
end barrel_left_shift_comp_16b;

architecture Behavioral of barrel_left_shift_comp_16b is
signal shifted_value : std_logic_vector (15 downto 0);
begin
    shifted_value <= std_logic_vector(shift_left(unsigned(shift_value), shift_amount));
    output <= shifted_value when (mux_sel = '1') else shift_value;
end Behavioral;
