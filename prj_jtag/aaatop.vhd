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
--use IEEE.NUMERIC_STD.ALL;

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
--           JTAG_TMS : inout  STD_LOGIC;
--           JTAG_TCK : inout  STD_LOGIC;
--           JTAG_TDI : inout  STD_LOGIC;
--           JTAG_TDO : inout  STD_LOGIC;
           clk : in  STD_LOGIC);
end aaatop;

architecture Behavioral of aaatop is
  component BSCAN_SPARTAN3                                                                  
    port (CAPTURE : out std_ulogic;                                                         
          DRCK1   : out std_ulogic;                                                         
          DRCK2   : out std_ulogic;                                                         
          RESET   : out std_ulogic;                                                         
          SEL1    : out std_ulogic;                                                         
          SEL2    : out std_ulogic;                                                         
          SHIFT   : out std_ulogic;                                                         
          TDI     : out std_ulogic;                                                         
          UPDATE  : out std_ulogic;                                                         
          TDO1    : in  std_ulogic;                                                         
          TDO2    : in  std_ulogic);                                                        
  end component;                                                                            
signal clock : std_logic := '0';
signal reset : std_logic := '0';
signal enable : std_logic := '0';
signal buttons : STD_LOGIC_VECTOR (3 downto 0);
signal leds : STD_LOGIC_VECTOR (3 downto 0);

signal user_CAPTURE : std_ulogic := 'Z';
signal user_DRCK1 : std_ulogic := 'Z';
signal user_RESET : std_ulogic := 'Z';
signal user_SEL1 : std_ulogic := 'Z';
signal user_SHIFT : std_ulogic := 'Z';
signal user_TDI : std_ulogic := 'Z';
signal user_UPDATE : std_ulogic := 'Z';
signal user_TDO1 : std_ulogic := 'Z';
signal user_TDO2 : std_ulogic := 'Z';
begin
	butled1: entity work.wingbutled
	Port map (
			 io => W1b(7 downto 0),
			 buttons => buttons,
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
	clock <= buttons(2);

--JTAG_TMS <= buttons(0);
--JTAG_TCK <= buttons(1);
--JTAG_TDI <= buttons(2);
--JTAG_TDO <= buttons(3);
user_TDO2 <= buttons(2);
user_TDO1 <= buttons(3);

BS : BSCAN_SPARTAN3
port map(
CAPTURE => user_CAPTURE,
DRCK1 => user_DRCK1,
DRCK2 => open,
RESET => user_RESET,
SEL1 => user_SEL1,
SEL2 => open,
SHIFT => user_SHIFT,
TDI => user_TDI,
UPDATE => user_UPDATE,
TDO1 => user_TDO1,
--TDO2 => '1'
TDO2 => user_TDO2
);
-- BSCAN_SPARTAN3A_inst : BSCAN_SPARTAN3A
--port map (
--CAPTURE => CAPTURE, -- CAPTURE output from TAP controller
--DRCK1 => DRCK1, -- Data register output for USER1 functions
--DRCK2 => open, -- Data register output for USER2 functions
--RESET => RESET, -- Reset output from TAP controller
--SEL1 => SEL1, -- USER1 active output
--SEL2 => open, -- USER2 active output
--SHIFT => SHIFT, -- SHIFT output from TAP controller
--TCK => open, -- TCK output from TAP controller
--TDI => TDI, -- TDI output from TAP controller
--TMS => open, -- TMS output from TAP controller
--UPDATE => UPDATE, -- UPDATE output from TAP controller
--TDO1 => TDO1, --TDO1, -- Data input for USER1 function
--TDO2 => '0' -- Data input for USER2 function
--);

--	JTAG_TMS <= buttons(0);
--	JTAG_TCK <= buttons(1);
--	JTAG_TDI <= buttons(2);
--	JTAG_TDO <= buttons(3);
	
--	leds <= buttons;
end Behavioral;
