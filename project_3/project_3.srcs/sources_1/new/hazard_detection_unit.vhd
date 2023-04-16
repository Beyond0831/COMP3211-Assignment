----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2023 11:04:40 PM
-- Design Name: 
-- Module Name: hazard_detection_unit - Behavioral
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

entity hazard_detection_unit is
    port (c_ex_data1 : in std_logic;
          c_ex_wreg1 : in std_logic;
          c_ex_wreg2 : in std_logic;
          c_mem_data1 : in std_logic; --used by branch stall
          id_rreg1 : in std_logic_vector(3 downto 0);
          id_rreg2 : in std_logic_vector(3 downto 0);
          ex_wreg1 : in std_logic_vector(3 downto 0); -- no need to check for reg2
          ex_wreg2 : in std_logic_vector(3 downto 0);
          mem_wreg1 : in std_logic_vector(3 downto 0);
          opcode   : in std_logic_vector(3 downto 0);
          hc_if_pc_write : out std_logic;
          hc_if_id_no_branch_write : out std_logic;
          hc_if_id_inst_write : out std_logic;
          hc_id_bubble_sel : out std_logic); 
end hazard_detection_unit;

architecture Behavioral of hazard_detection_unit is
constant OP_BNE     : std_logic_vector(3 downto 0) := "0110"; --6
signal stall_for_others : std_logic;
signal stall_for_branch : std_logic; -- branch instrucation need additional checking since it needs to stall when the load instruction is at mem stage
signal stall : std_logic;
begin
    stall_for_branch <= '1' when (opcode = OP_BNE) and 
                                 (((c_ex_wreg1 = '1') and (ex_wreg1 = id_rreg1)) or
                                 ((c_ex_wreg2 = '1') and (ex_wreg2 = id_rreg1)) or
                                 ((c_mem_data1 = '1') and (mem_wreg1 = id_rreg1)) or
                                 ((c_ex_wreg1 = '1') and (ex_wreg1 = id_rreg2)) or
                                 ((c_ex_wreg2 = '1') and (ex_wreg2 = id_rreg2)) or
                                 ((c_mem_data1 = '1') and (mem_wreg1 = id_rreg2))) else '0';
                                 
    stall_for_others <= '1' when (c_ex_data1 = '1' ) and
                      ((ex_wreg1 = id_rreg1) or (ex_wreg1 = id_rreg2)) else '0';
                        
    stall <= stall_for_others or stall_for_branch;
    hc_if_pc_write <= '0' when (stall = '1') else '1';
    hc_if_id_no_branch_write <= '0' when (stall = '1') else '1';
    hc_if_id_inst_write <= '0' when (stall = '1') else '1';
    hc_id_bubble_sel <= '1' when (stall = '1') else '0';
end Behavioral;
