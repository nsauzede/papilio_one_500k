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
generic(
			SHIFT: integer := 23	-- counter shift to incr the addr
);
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

constant ADDR_WIDTH: integer := 13;
component bram_with_init_v
    generic (
        ADDR_WIDTH : integer;                -- Address width (2^ADDR_WIDTH locations)
        DATA_WIDTH : integer;               -- Data width
        INIT_FILE  : string  -- Initialization file
    );
    port (
        clk   : in  std_logic;                      -- Clock
        we    : in  std_logic;                      -- Write enable
        addr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0); -- Address
        din   : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- Data input
        dout  : out std_logic_vector(DATA_WIDTH-1 downto 0)  -- Data output
    );
end component;
signal we    : std_logic := '0';
signal addr  : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0'); -- Example: 10-bit address
signal din   : std_logic_vector(31 downto 0) := (others => '0'); -- Example: 32-bit data input
signal dout  : std_logic_vector(31 downto 0); -- Example: 32-bit data output
begin
	u_bram: bram_with_init_v
	generic map (
		ADDR_WIDTH => ADDR_WIDTH,
		DATA_WIDTH => 32,
		INIT_FILE  => "../src/darksocv_padded.mem"
	)
	port map (
		clk   => clk,
		we    => we,
		addr  => addr,
		din   => din,
		dout  => dout
	);
--	addr <= std_logic_vector(count(ADDR_WIDTH-1+SHIFT downto 0+SHIFT));
	addr(1 downto 0) <= std_logic_vector(count(1+SHIFT downto 0+SHIFT));
	addr(ADDR_WIDTH-1 downto 2) <= (others => '0');
--	addr <= (others => '0');

--	leds(2 downto 0) <= dout(2 downto 0);
--	leds(2 downto 1) <= dout(1 downto 0);
--	leds(2 downto 0) <= dout(30 downto 28);
--	leds(2 downto 0) <= dout(10 downto 8);
	leds(2 downto 0) <= dout(6 downto 4);
--	leds(0) <= '1';

--	leds(2 downto 0) <= dout(2+4 downto 0+4);
--	leds(1 downto 0) <= (others => '1');
--	leds(3) <= addr(0);
	butled1: entity work.wingbutled
	Port map (
			 io => W1b(7 downto 0),
			 buttons => buttons,
			 leds => leds
	);
	reset <= buttons(0);
	tx <= rx;
--   leds <= (others => '0') when count < to_unsigned(32000000 / 2, 32) else (others => '1');
   leds(3 downto 3) <= (others => '1') when count < to_unsigned(32000000 / 2, 32) else (others => '0');
	process(clk,reset)
	begin
		if reset = '1' then
			count <= (others => '0');
		elsif rising_edge(clk) then
			if count >= to_unsigned(32000000, 32) then
				count <= (others => '0');
			else
				count <= count + 1;
			end if;
		end if;
	end process;
end Behavioral;
