--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:55:34 01/01/2025
-- Design Name:   
-- Module Name:   /mnt/huge/lenovo/nico/perso/git/papilio_one_500k/prj_uart/dump_tb.vhd
-- Project Name:  papilio_one_500k
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_mem_dump
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY dump_tb IS
END dump_tb;
 
ARCHITECTURE behavior OF dump_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_mem_dump
    PORT(
         clk : IN  std_logic;
         nreset : IN  std_logic;
         mem_addr : OUT  std_logic_vector(16 downto 0);
         mem_data : IN  std_logic_vector(31 downto 0);
         mem_read : OUT  std_logic;
         mem_waitrequest : IN  std_logic;
         mem_readdatavalid : IN  std_logic;
         uart_data : OUT  std_logic_vector(7 downto 0);
         uart_valid : OUT  std_logic;
         uart_ready : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal nreset : std_logic := '0';
   signal mem_data : std_logic_vector(31 downto 0) := (others => '0');
   signal mem_waitrequest : std_logic := '0';
   signal mem_readdatavalid : std_logic := '0';
   signal uart_ready : std_logic := '0';

 	--Outputs
   signal mem_addr : std_logic_vector(16 downto 0);
   signal mem_read : std_logic;
   signal uart_data : std_logic_vector(7 downto 0);
   signal uart_valid : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_mem_dump PORT MAP (
          clk => clk,
          nreset => nreset,
          mem_addr => mem_addr,
          mem_data => mem_data,
          mem_read => mem_read,
          mem_waitrequest => mem_waitrequest,
          mem_readdatavalid => mem_readdatavalid,
          uart_data => uart_data,
          uart_valid => uart_valid,
          uart_ready => uart_ready
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;

      -- insert stimulus here 
		nreset <= '1';
      wait for clk_period*2;

		uart_ready <= '1';
      wait for clk_period*1;
		uart_ready <= '0';

      wait for clk_period*10;
		--mem_data <= x"deadbeef";
      wait for clk_period*10;
      wait for clk_period*10;

      wait;
   end process;

END;
