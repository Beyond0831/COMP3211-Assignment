----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2023 05:17:24 PM
-- Design Name: 
-- Module Name: next_insn_logic - Behavioral
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

entity next_inst_logic is
    Port ( curr : in STD_LOGIC_VECTOR (3 DOWNTO 0);
           offset : in STD_LOGIC_VECTOR (3 DOWNTO 0);
           inst_size : in STD_LOGIC_VECTOR (3 DOWNTO 0); 
           enable_branch : in STD_LOGIC;
           branch : in STD_LOGIC;
           next_inst : out STD_LOGIC_VECTOR (3 DOWNTO 0));
end next_inst_logic;

architecture Behavioral of next_inst_logic is
component mux_2to1_4b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(3 downto 0);
           data_b     : in  std_logic_vector(3 downto 0);
           data_out   : out std_logic_vector(3 downto 0) );
end component;
component adder_4b is
    port ( src_a     : in  std_logic_vector(3 downto 0);
           src_b     : in  std_logic_vector(3 downto 0);
           sum       : out std_logic_vector(3 downto 0);
           carry_out : out std_logic );
end component;

signal no_branch_inst : std_logic_vector(3 downto 0);
signal branch_inst : std_logic_vector(3 downto 0);
signal adder_no_b_carry_out : std_logic;
signal adder_b_carry_out : std_logic;
signal branch_mux_ctrl: std_logic;
begin
   next_pc_no_b: adder_4b port map (src_a => curr,
                                    src_b => inst_size,
                                    sum => no_branch_inst,
                                    carry_out => adder_no_b_carry_out);
                                    
   next_pc_b: adder_4b port map (src_a => no_branch_inst,
                                    src_b => offset,
                                    sum => branch_inst,
                                    carry_out => adder_b_carry_out);  
   branch_mux : mux_2to1_4b port map (mux_select => branch_mux_ctrl,
                                      data_a => no_branch_inst,
                                      data_b => branch_inst,
                                      data_out => next_inst); 
   branch_mux_ctrl <= branch AND enable_branch;
end Behavioral;
