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
signal buttons : STD_LOGIC_VECTOR (3 downto 0);
signal leds : STD_LOGIC_VECTOR (3 downto 0);
signal reset: std_logic := '0';
signal count: UNSIGNED(31 downto 0) := (others => '0');
begin
	butled1: entity work.wingbutled
	Port map (
			 io => W1b(7 downto 0),
			 buttons => buttons,
			 leds => leds
	);
	reset <= buttons(0);
	tx <= rx;
   leds <= (others => '1') when count < to_unsigned(32000000 / 2, 32) else (others => '0');
	process(clk,reset)
	begin
		if reset = '1' then
			count <= (others => '0');
		elsif rising_edge(clk) then
			if count = 0 then
				count <= to_unsigned(32000000, 32);
			else
				count <= count - 1;
			end if;
		end if;
	end process;
end Behavioral;
