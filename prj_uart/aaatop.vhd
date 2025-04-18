----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    21:10:34 03/08/2017
-- Design Name:
-- Module Name:    aaatop - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aaatop is
    Port ( rx : in  STD_LOGIC;
           tx : inout  STD_LOGIC;
           W1A : inout  STD_LOGIC_VECTOR (15 downto 0);
           W1B : inout  STD_LOGIC_VECTOR (15 downto 0);
           W2C : inout  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC);
end aaatop;

architecture Behavioral of aaatop is
component uart_tx
port(
		  nreset: in std_logic;
		  clk: in std_logic;

		  tx_valid: in std_logic;
		  tx_ready: out std_logic;
		  tx_data: in std_logic_vector(7 downto 0);

		  tx: out std_logic
);
end component;
component uart_rx
generic(
	clk_freq: integer := 32000000;
	baud_rate: integer := 115200
);
port(
		  nreset: in std_logic;
		  clk: in std_logic;

		  rx_valid: out std_logic;
		  rx_ready: in std_logic;
		  rx_data: out std_logic_vector(7 downto 0);

		  cmax_o: out std_logic_vector(7 downto 0);
		  voted_o: out std_logic;

		  rx: in std_logic
);
end component;

signal buttons : STD_LOGIC_VECTOR (3 downto 0);
signal leds : STD_LOGIC_VECTOR (3 downto 0);

signal nreset: std_logic := '1';
signal uart_valid: std_logic := '0';
signal uart_ready: std_logic := '0';
signal uart_data: std_logic_vector(7 downto 0) := (others => '0');

begin
	butled1: entity work.wingbutled
	Port map (
			 io => W1b(7 downto 0),
			 buttons => buttons,
			 leds => leds
	);
	nreset <= not buttons(3);
	uart_tx1: uart_tx
	Port map(
		nreset => nreset,
		clk => clk,
		
		tx_valid => uart_valid,
		tx_ready => uart_ready,
		tx_data => uart_data,
		
		tx => tx
	);
	leds <= uart_data(3 downto 0);
	uart_rx1: uart_rx
	generic map(
		clk_freq => 32000000,
		baud_rate => 115200		
	)
	Port map(
		nreset => nreset,
		clk => clk,
		
		rx_valid => uart_valid,
		rx_ready => uart_ready,
		rx_data => uart_data,
		
		rx => rx
	);
end Behavioral;
