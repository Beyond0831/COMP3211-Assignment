---------------------------------------------------------------------------
-- control_unit.vhd - Control Unit Implementation
--
-- Notes: refer to headers in single_cycle_core.vhd for the supported ISA.
--
--  control signals:
--     reg_dst    : asserted for ADD instructions, so that the register
--                  destination number for the 'write_register' comes from
--                  the rd field (bits 3-0). 
--     reg_write  : asserted for ADD and LOAD instructions, so that the
--                  register on the 'write_register' input is written with
--                  the value on the 'write_data' port.
--     alu_src    : asserted for LOAD and STORE instructions, so that the
--                  second ALU operand is the sign-extended, lower 4 bits
--                  of the instruction.
--     mem_write  : asserted for STORE instructions, so that the data 
--                  memory contents designated by the address input are
--                  replaced by the value on the 'write_data' input.
--     mem_to_reg : asserted for LOAD instructions, so that the value fed
--                  to the register 'write_data' input comes from the
--                  data memory.
--
--
-- Copyright (C) 2006 by Lih Wen Koh (lwkoh@cse.unsw.edu.au)
-- All Rights Reserved. 
--
-- The single-cycle processor core is provided AS IS, with no warranty of 
-- any kind, express or implied. The user of the program accepts full 
-- responsibility for the application of the program and the use of any 
-- results. This work may be downloaded, compiled, executed, copied, and 
-- modified solely for nonprofit, educational, noncommercial research, and 
-- noncommercial scholarship purposes provided that this notice in its 
-- entirety accompanies all copies. Copies of the modified software can be 
-- delivered to persons who use it solely for nonprofit, educational, 
-- noncommercial research, and noncommercial scholarship purposes provided 
-- that this notice in its entirety accompanies all copies.
--
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_unit is
    port ( opcode     : in  std_logic_vector(3 downto 0);
           control_bus : out std_logic_vector(11 downto 0)); -- used as signal for forwarding detection
end control_unit;

architecture behavioural of control_unit is

constant OP_LOAD  : std_logic_vector(3 downto 0) := "0001";
constant OP_STORE : std_logic_vector(3 downto 0) := "0011";
constant OP_ADD   : std_logic_vector(3 downto 0) := "1000";

--new opcodes
constant OP_BNE     : std_logic_vector(3 downto 0) := "0110"; --6
constant OP_LA      : std_logic_vector(3 downto 0) := "1010"; --a
constant OP_SLRi    : std_logic_vector(3 downto 0) := "1100"; --c
begin
    --- control bus list ---
        --- control for WB stage ---
            -- 0 | c_wb_out_of_bound
            -- 1 | c_wb_data1
            -- 2 | c_wb_wreg1
            -- 3 | c_wb_wreg2
        
        --- control for MEM stage ---
            -- 4 | c_mem_address
            -- 5 | c_mem_write
            
        --- control for EX stage ---
            -- 6 | c_ex_result
            -- 7 | c_ex_data_b
            -- 8 | c_ex_array_op
            -- (this stage will modify c_wb_wreg2 and c_wb_out_of_bound)
            
        --- control for ID stage ---
            -- 9 | c_id_branch_enable
            -- 10| c_id_extension
            -- 11| c_id_wreg1_sel     
    ---------------------------------------
    control_bus(0) <= '0'; -- c_wb_out_of_bound determined in EX stage 
    control_bus(1) <= '1' when (opcode = OP_LOAD or 
                                opcode = OP_LA) else '0';
    control_bus(2) <= '1' when (opcode = OP_LOAD or
                                opcode = OP_ADD or
                                opcode = OP_LA or 
                                opcode = OP_SLRi) else '0';
    control_bus(3) <= '0'; -- c_wb_wreg2 determined in EX stage 
    control_bus(4) <= '1' when opcode = OP_LA else '0';
    control_bus(5) <= '1' when opcode = OP_STORE else '0';
    control_bus(6) <= '1' when opcode = OP_SLRi else '0';
    control_bus(7) <= '1' when (opcode = OP_LOAD or
                                opcode = OP_STORE or
                                opcode = OP_SLRi) else '0';
    control_bus(8) <= '1' when opcode = OP_LA else '0';
    control_bus(9) <= '1' when opcode = OP_BNE else '0';
    control_bus(10) <= '1' when opcode = OP_SLRi else '0';
    control_bus(11) <= '1' when (opcode = OP_ADD or
                                 opcode = OP_LA) else '0';
end behavioural;
