--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   00:18:13 07/22/2017
-- Design Name:
-- Module Name:   papilio_one_500k/aaatop_tb.vhd
-- Project Name:  papilio_one_500k
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: aaatop
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

ENTITY aaatop_tb IS
END aaatop_tb;

ARCHITECTURE behavior OF aaatop_tb IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT aaatop
    PORT(
         rx : IN  std_logic;
         tx : INOUT  std_logic;
         W1A : INOUT  std_logic_vector(15 downto 0);
         W1B : INOUT  std_logic_vector(15 downto 0);
         W2C : INOUT  std_logic_vector(15 downto 0);
         clk : IN  std_logic
        );
    END COMPONENT;


   --Inputs
   signal rx : std_logic := '0';
   signal clk : std_logic := '0';

	--BiDirs
   signal tx : std_logic;
   signal W1A : std_logic_vector(15 downto 0);
   signal W1B : std_logic_vector(15 downto 0);
   signal W2C : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: aaatop PORT MAP (
          rx => rx,
          tx => tx,
          W1A => W1A,
          W1B => W1B,
          W2C => W2C,
          clk => clk
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

      wait for clk_period*10;

      -- insert stimulus here

      wait;
   end process;

END;
