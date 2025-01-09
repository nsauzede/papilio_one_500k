--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:01:21 01/09/2025
-- Design Name:   
-- Module Name:   /home/nsauzede/perso/git/papilio_one_500k/prj_darkriscv/darkuart_tb.vhd
-- Project Name:  papilio_one_500k
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: darkuart
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
 
ENTITY darkuart_tb IS
END darkuart_tb;
 
ARCHITECTURE behavior OF darkuart_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT darkuart
    PORT(
         CLK : IN  std_logic;
         RES : IN  std_logic;
         RD : IN  std_logic;
         WR : IN  std_logic;
         BE : IN  std_logic_vector(3 downto 0);
         DATAI : IN  std_logic_vector(31 downto 0);
         DATAO : OUT  std_logic_vector(31 downto 0);
         IRQ : OUT  std_logic;
         RXD : IN  std_logic;
         TXD : OUT  std_logic;
         ESIMREQ : OUT  std_logic;
         ESIMACK : IN  std_logic;
         DEBUG : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RES : std_logic := 'Z';
   signal RD : std_logic := '0';
   signal WR : std_logic := '0';
   signal BE : std_logic_vector(3 downto 0) := (others => '0');
   signal DATAI : std_logic_vector(31 downto 0) := (others => '0');
   signal RXD : std_logic := '0';
   signal ESIMACK : std_logic := '0';

 	--Outputs
   signal DATAO : std_logic_vector(31 downto 0);
   signal IRQ : std_logic;
   signal TXD : std_logic;
   signal ESIMREQ : std_logic;
   signal DEBUG : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: darkuart PORT MAP (
          CLK => CLK,
          RES => RES,
          RD => RD,
          WR => WR,
          BE => BE,
          DATAI => DATAI,
          DATAO => DATAO,
          IRQ => IRQ,
          RXD => RXD,
          TXD => TXD,
          ESIMREQ => ESIMREQ,
          ESIMACK => ESIMACK,
          DEBUG => DEBUG
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
      wait for 100 ns;	
      RES <= '1';
		-- hold reset state for 100 ns.
      wait for 100 ns;	
      RES <= '0';

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
