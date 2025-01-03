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
signal clock : std_logic := '0';
signal reset : std_logic := '0';
signal enable : std_logic := '0';
signal buttons : STD_LOGIC_VECTOR (3 downto 0);
signal leds : STD_LOGIC_VECTOR (3 downto 0);
signal count: UNSIGNED(31 downto 0) := (others => '0');
begin
	butled1: entity work.wingbutled
	Port map (
			 io => W1b(7 downto 0),
			 buttons => buttons,
			 leds => leds
	);
	butled2: entity work.wingbutled
	Port map (
			 io => W1b(15 downto 8),
			 buttons => open,
			 leds => leds
	);
--	butled3: entity work.wingbutled
--	Port map (
--			 io => W1a(7 downto 0),
--			 buttons => open,
--			 leds => leds
--	);
	butled4: entity work.wingbutled
	Port map (
			 io => W1a(15 downto 8),
			 buttons => open,
			 leds => leds
	);
	butled5: entity work.wingbutled
	Port map (
			 io => W2c(7 downto 0),
			 buttons => open,
			 leds => leds
	);
	butled6: entity work.wingbutled
	Port map (
			 io => W2c(15 downto 8),
			 buttons => open,
			 leds => leds
	);
	counter1: entity work.counter
	Port map( clock => clock,
		  reset => reset,
		  enable => enable,
		  counter_out => leds
	);
	reset <= buttons(0);
	enable <= buttons(1);
	clock <= buttons(2) or count(19);
    process(clk,reset)
    begin
        if reset = '1' then
            count <= (others => '0');
        elsif rising_edge(clk) then
            count <= count + 1;
        end if;
    end process;
	 w1a(0) <= count(17);
	 w1a(1) <= count(18);
	 w1a(2) <= count(19);
	 w1a(3) <= count(20);
	
--	leds <= buttons;
end Behavioral;
