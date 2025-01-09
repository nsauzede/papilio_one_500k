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
component darkram is
        port (
            CLK     : in  std_logic;
            RES     : in  std_logic;
            HLT     : in  std_logic;

            IDREQ   : in  std_logic;
            IADDR   : in  std_logic_vector(31 downto 0);
            IDATA   : out std_logic_vector(31 downto 0);
            IDACK   : out std_logic;

            XDREQ   : in  std_logic;
            XRD     : in  std_logic;
            XWR     : in  std_logic;
            XBE     : in  std_logic_vector(3 downto 0);
            XADDR   : in  std_logic_vector(31 downto 0);
            XATAI   : in  std_logic_vector(31 downto 0);
            XATAO   : out std_logic_vector(31 downto 0);
            XDACK   : out std_logic;

            DEBUG   : out std_logic_vector(3 downto 0)
        );
    end component;
component darkuart
port(
        -- Clock and Reset
        CLK     : in  std_logic;             -- Clock signal
        RES     : in  std_logic;             -- Reset signal

        -- Bus Interface
        RD      : in  std_logic;             -- Bus read signal
        WR      : in  std_logic;             -- Bus write signal
        BE      : in  std_logic_vector(3 downto 0); -- Byte enable
        DATAI   : in  std_logic_vector(31 downto 0); -- Data input
        DATAO   : out std_logic_vector(31 downto 0); -- Data output
        IRQ     : out std_logic;             -- Interrupt request

        -- UART Interface
        RXD     : in  std_logic;             -- UART receive line
        TXD     : out std_logic;             -- UART transmit line

        -- Optional Simulation Ports
--`ifdef SIMULATION
        ESIMREQ : out std_logic := '0';      -- Simulation request
        ESIMACK : in  std_logic;             -- Simulation acknowledge
--`endif

        -- Debug Ports
        DEBUG   : out std_logic_vector(3 downto 0) -- Debug signal
);
end component;
signal reset : std_logic := '0';
signal buttons : STD_LOGIC_VECTOR (3 downto 0);
signal leds : STD_LOGIC_VECTOR (3 downto 0);

    signal clk_sig     : std_logic;
    signal res_sig     : std_logic;
    signal hlt_sig     : std_logic;

    signal idreq_sig   : std_logic;
    signal iaddr_sig   : std_logic_vector(31 downto 0);
    signal idata_sig   : std_logic_vector(31 downto 0);
    signal idack_sig   : std_logic;

    signal xdreq_sig   : std_logic;
    signal xrd_sig     : std_logic;
    signal xwr_sig     : std_logic;
    signal xbe_sig     : std_logic_vector(3 downto 0);
    signal xaddr_sig   : std_logic_vector(31 downto 0);
    signal xatai_sig   : std_logic_vector(31 downto 0);
    signal xatao_sig   : std_logic_vector(31 downto 0);
    signal xdack_sig   : std_logic;

    signal debug_sig   : std_logic_vector(3 downto 0);

signal rd        : std_logic := '0';
signal wr        : std_logic := '0';
signal be        : std_logic_vector(3 downto 0) := (others => '0');
signal datai     : std_logic_vector(31 downto 0) := (others => '0');
signal datao     : std_logic_vector(31 downto 0) := (others => '0');
signal irq       : std_logic := '0';
signal esimreq       : std_logic := '0';
signal esimack       : std_logic := '0';
begin
	butled1: entity work.wingbutled
	Port map (
			 io => W1b(7 downto 0),
			 buttons => buttons,
			 leds => leds
	);
	reset <= buttons(0);

    res_sig <= buttons(0);
--	 darkram_inst : darkram
--        port map (
--            CLK     => clk_sig,
--            RES     => res_sig,
--            HLT     => hlt_sig,
--
--            IDREQ   => idreq_sig,
--            IADDR   => iaddr_sig,
--            IDATA   => idata_sig,
--            IDACK   => idack_sig,
--
--            XDREQ   => xdreq_sig,
--            XRD     => xrd_sig,
--            XWR     => xwr_sig,
--            XBE     => xbe_sig,
--            XADDR   => xaddr_sig,
--            XATAI   => xatai_sig,
--            XATAO   => xatao_sig,
--            XDACK   => xdack_sig,
--
--            DEBUG   => debug_sig
--        );

	darkuart1: darkuart
	port map(
        -- Clock and Reset
        CLK     => clk,
        RES     => reset,
        -- Bus Interface
        RD      => rd,
        WR      => wr,
        BE      => be,
        DATAI   => datai,
        DATAO   => datao,
        IRQ     => irq,
        -- UART Interface
        RXD     => rx,
        TXD     => tx,
--`ifdef SIMULATION
        -- Simulation Ports
        ESIMREQ => esimreq,
        ESIMACK => esimack,
--`endif
        -- Debug Ports
        DEBUG   => open
		  );
end Behavioral;
