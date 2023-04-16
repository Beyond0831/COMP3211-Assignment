----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2023 03:26:51 PM
-- Design Name: 
-- Module Name: fowarding_unit - Behavioral
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

entity fowarding_unit is
    port (c_mem_data1 : in std_logic; --data1 = 1 when read from memory, data = 0 when read from alu (wreg 1)
          c_wb_data1 : in std_logic;
          c_mem_wreg1 : in std_logic;
          c_wb_wreg1 : in std_logic;
          c_mem_wreg2 : in std_logic;
          c_wb_wreg2 : in std_logic;
          c_mem_out_of_bound : in std_logic;
          c_wb_out_of_bound : in std_logic;
          mem_wreg1 : in std_logic_vector(3 downto 0);
          wb_wreg1 : in std_logic_vector(3 downto 0);
          mem_wreg2 : in std_logic_vector(3 downto 0);
          wb_wreg2 : in std_logic_vector(3 downto 0);
          EX_MEM_result : in std_logic_vector(15 downto 0);
          wb_wdata1 : in std_logic_vector(15 downto 0);
          wb_wdata2 : in std_logic_vector(15 downto 0);
          ex_rreg1 : in std_logic_vector(3 downto 0);
          ex_rreg2 : in std_logic_vector(3 downto 0);
          ex_old_a : in std_logic_vector(15 downto 0);
          ex_old_b : in  std_logic_vector(15 downto 0);
          ex_new_a : out std_logic_vector(15 downto 0);
          ex_new_b : out std_logic_vector(15 downto 0));
end fowarding_unit;

architecture Behavioral of fowarding_unit is
--- mem stage forwarding first layer logic, (will be 1 even data is not available), 
signal from_mem_to_ex_wreg1_rreg1 : std_logic;
signal from_mem_to_ex_wreg2_rreg1 : std_logic;
signal from_mem_to_ex_wreg1_rreg2 : std_logic;
signal from_mem_to_ex_wreg2_rreg2 : std_logic;

--- wb stage forwarding first layer logic, (will be 1 even data is not available)
signal from_wb_to_ex_wreg1_rreg1 : std_logic;
signal from_wb_to_ex_wreg2_rreg1 : std_logic;
signal from_wb_to_ex_wreg1_rreg2 : std_logic;
signal from_wb_to_ex_wreg2_rreg2 : std_logic;         
                            
begin
    from_mem_to_ex_wreg1_rreg1 <= '1' when ((ex_rreg1 /= "0000") and 
                                           (ex_rreg1 = mem_wreg1) and
                                           (c_mem_wreg1 = '1')) else '0';
                                 
    from_mem_to_ex_wreg2_rreg1 <= '1' when ((ex_rreg1 /= "0000") and
                                             (ex_rreg1 = mem_wreg2) and
                                             (c_mem_wreg2 = '1')) else '0';
                                             
    from_mem_to_ex_wreg1_rreg2 <= '1' when ((ex_rreg2 /= "0000") and
                                             (ex_rreg2 = mem_wreg1) and
                                             (c_mem_wreg1 = '1')) else '0';
    
    from_mem_to_ex_wreg2_rreg2 <= '1' when ((ex_rreg2 /= "0000") and
                                             (ex_rreg2 = mem_wreg2) and
                                             (c_mem_wreg2 = '1')) else '0';
                                             
    from_wb_to_ex_wreg1_rreg1 <= '1' when ((ex_rreg1 /= "0000") and
                                            (ex_rreg1 = wb_wreg1) and
                                            (c_wb_wreg1 = '1')) else '0';
                                            
    from_wb_to_ex_wreg2_rreg1 <= '1' when ((ex_rreg1 /= "0000") and
                                            (ex_rreg1 = wb_wreg2) and
                                            (c_wb_wreg2 = '1')) else '0';
                                                        
    from_wb_to_ex_wreg1_rreg2 <= '1' when ((ex_rreg2 /= "0000") and
                                             (ex_rreg2 = wb_wreg1) and
                                             (c_wb_wreg1 = '1')) else '0';
                                             
    from_wb_to_ex_wreg2_rreg2 <= '1' when ((ex_rreg2 /= "0000") and
                                            (ex_rreg2 = wb_wreg2) and
                                            (c_wb_wreg2 = '1')) else '0';
    ------------ data forward to ex stage ----------------
    
    -- forwarding to read register a
    process(from_mem_to_ex_wreg1_rreg1,
            from_mem_to_ex_wreg2_rreg1,
            from_wb_to_ex_wreg1_rreg1,
            from_wb_to_ex_wreg2_rreg1,
            c_mem_data1,
            c_mem_out_of_bound,
            c_wb_data1,
            c_wb_out_of_bound,
            ex_old_a,
            EX_MEM_result,
            wb_wdata1,
            wb_wdata2)
    begin
        ex_new_a <= ex_old_a;
        if ((from_mem_to_ex_wreg1_rreg1 = '1') or (from_mem_to_ex_wreg2_rreg1 = '1')) then
            if (from_mem_to_ex_wreg1_rreg1 = '1') then
                if (c_mem_data1 = '0') then --check only ADD and SLRi instruction is in mem stage since LW and LA data 
                                            -- is not available
                    ex_new_a <= EX_MEM_result;
                end if;
            else
                if (c_mem_out_of_bound = '0') then -- check the out of bound condition is not met (not used now as we stall)
                    ex_new_a <= EX_MEM_result;
                end if;
            end if;
        elsif ((from_wb_to_ex_wreg1_rreg1 = '1') or (from_wb_to_ex_wreg2_rreg1 = '1')) then
            if (from_wb_to_ex_wreg1_rreg1 = '1') then
                ex_new_a <= wb_wdata1;
            else
                ex_new_a <= wb_wdata2;
            end if;
        end if;
    end process;
    
    
    -- forwarding to read register b
    process(from_mem_to_ex_wreg1_rreg2,
            from_mem_to_ex_wreg2_rreg2,
            from_wb_to_ex_wreg1_rreg2,
            from_wb_to_ex_wreg2_rreg2,
            c_mem_data1,
            c_mem_out_of_bound,
            c_wb_data1,
            c_wb_out_of_bound,
            ex_old_b,
            EX_MEM_result,
            wb_wdata1,
            wb_wdata2)
    begin
        ex_new_b <= ex_old_b;
        if ((from_mem_to_ex_wreg1_rreg2 = '1') or (from_mem_to_ex_wreg2_rreg2 = '1')) then
            if (from_mem_to_ex_wreg1_rreg2 = '1') then
                if (c_mem_data1 = '0') then --check only ADD and SLRi instruction is in mem stage since LW and LA data 
                                            -- is not available
                    ex_new_b <= EX_MEM_result;
                end if;
            else
                if (c_mem_out_of_bound = '0') then -- check the out of bound condition is not met 
                    ex_new_b <= EX_MEM_result;
                end if;
            end if;
        elsif ((from_wb_to_ex_wreg1_rreg2 = '1') or (from_wb_to_ex_wreg2_rreg2 = '1')) then
            if (from_wb_to_ex_wreg1_rreg2 = '1') then
                ex_new_b <= wb_wdata1;
            else
                ex_new_b <= wb_wdata2;
            end if;
        end if;
    end process;
    
    ---------------------------------------------------------------------

end Behavioral;
