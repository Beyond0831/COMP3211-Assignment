----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2023 05:37:16 PM
-- Design Name: 
-- Module Name: alu - Behavioral
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

entity alu is
    Port ( data_a : in STD_LOGIC_VECTOR (15 downto 0);
           data_b : in STD_LOGIC_VECTOR (15 downto 0);
           result_sel : in STD_LOGIC;
           array_op : in STD_LOGIC;
           result : out STD_LOGIC_VECTOR (15 downto 0);
           carry_out : out STD_LOGIC;
           equal : out STD_LOGIC;
           greater : out STD_LOGIC;
           less : out STD_LOGIC);
end alu;

architecture Behavioral of alu is
component adder_16b is
    port ( src_a     : in  std_logic_vector(15 downto 0);
           src_b     : in  std_logic_vector(15 downto 0);
           sum       : out std_logic_vector(15 downto 0);
           carry_out : out std_logic );
end component;

component barrel_left_shift_16b is
    Port ( shift_value : in STD_LOGIC_VECTOR (15 downto 0);
           shift_amount : in STD_LOGIC_VECTOR (15 downto 0);
           output : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component comparator_16b is
    Port ( data_a : in STD_LOGIC_VECTOR (15 downto 0);
           data_b : in STD_LOGIC_VECTOR (15 downto 0);
           equal : out STD_LOGIC;
           greater : out STD_LOGIC;
           less : out STD_LOGIC);
end component;
 
--new datapath
signal adder_result, shifter_result : STD_LOGIC_VECTOR (15 downto 0); 
signal adder_input_a, comparator_input_a, barrel_shifter_input_a : STD_LOGIC_VECTOR (15 downto 0);
constant array_incr : std_logic_vector (15 downto 0) := x"0001";
begin
   adder_input_a <= data_a when (array_op = '0') else array_incr;
   comparator_input_a <= data_a;
   barrel_shifter_input_a <= data_a;
   
   alu_result: adder_16b 
   port map (src_a => adder_input_a,
             src_b => data_b,
             sum => adder_result,
             carry_out => carry_out);
             
   comparator: comparator_16b
   port map (data_a => comparator_input_a,
             data_b => data_b,
             equal => equal,
             greater=> greater,
             less => less);
   
   barrel_left_shifter : barrel_left_shift_16b
   port map (shift_value => data_a,
             shift_amount => data_b,
             output => shifter_result);
             
   --mux for result selection, default for adder
   result <= adder_result when (result_sel = '0') else shifter_result;
end Behavioral;
