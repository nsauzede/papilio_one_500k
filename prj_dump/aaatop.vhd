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
component uart_mem_dump                           
	 port(                                              
		  clk: in std_logic;
		  nreset: in std_logic;
                                               
		  mem_addr: out std_logic_vector(17-1 downto 0);
		  mem_data: in std_logic_vector(32-1 downto 0);
                                               
		  mem_read: out std_logic;    -- Read request
		  mem_waitrequest: in std_logic;
		  mem_readdatavalid: in std_logic;
                                               
		  uart_data: out std_logic_vector(7 downto 0);
		  uart_valid: out std_logic;
		  uart_ready: in std_logic
);
end component;

        component my_onchip_flash is
                port (
                        clock                   : in  std_logic                     := 'X';             -- clk
                        avmm_csr_addr           : in  std_logic                     := 'X';             -- address
                        avmm_csr_read           : in  std_logic                     := 'X';             -- read
                        avmm_csr_writedata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
                        avmm_csr_write          : in  std_logic                     := 'X';             -- write
                        avmm_csr_readdata       : out std_logic_vector(31 downto 0);                    -- readdata
                        avmm_data_addr          : in  std_logic_vector(16 downto 0) := (others => 'X'); -- address
                        avmm_data_read          : in  std_logic                     := 'X';             -- read
                        avmm_data_writedata     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
                        avmm_data_write         : in  std_logic                     := 'X';             -- write
                        avmm_data_readdata      : out std_logic_vector(31 downto 0);                    -- readdata
                        avmm_data_waitrequest   : out std_logic;                                        -- waitrequest
                        avmm_data_readdatavalid : out std_logic;                                        -- readdatavalid
                        avmm_data_burstcount    : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- burstcount
                        reset_n                 : in  std_logic                     := 'X'              -- reset_n
                );
        end component my_onchip_flash;


signal clock : std_logic := '0';
signal reset : std_logic := '0';
signal enable : std_logic := '0';
signal buttons : STD_LOGIC_VECTOR (3 downto 0);
signal leds : STD_LOGIC_VECTOR (3 downto 0);
signal count: UNSIGNED(31 downto 0) := (others => '0');
	signal nreset: std_logic := '1';
	signal uart_valid: std_logic := '0';
	signal uart_ready: std_logic := '0';
	signal uart_data: std_logic_vector(7 downto 0) := (others => '0');
	signal mem_addr: std_logic_vector(17-1 downto 0) := (others => '0');
	signal mem_data: std_logic_vector(32-1 downto 0) := (others => '0');
	signal mem_read: std_logic := '0';
	signal mem_waitrequest: std_logic := '0';
	signal mem_readdatavalid: std_logic := '0';

signal rd        : std_logic := '0';
signal wr        : std_logic := '0';
signal be        : std_logic_vector(3 downto 0) := (others => '0');
signal datai     : std_logic_vector(31 downto 0) := (others => '0');
signal datao     : std_logic_vector(31 downto 0) := (others => '0');
signal irq       : std_logic := '0';
begin
	butled1: entity work.wingbutled
	Port map (
			 io => W1b(7 downto 0),
			 buttons => buttons,
			 leds => leds
	);
--	counter1: entity work.counter
--	Port map( clock => clock,
--		  reset => reset,
--		  enable => enable,
--		  counter_out => leds
--	);
	reset <= buttons(0);
	enable <= buttons(1);
	clock <= buttons(2) or count(19);
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
--	 leds <= (others => '1') when count < to_unsigned(32000000 / 2, 32) else (others => '0');
	 w1a(0) <= count(17);
	 w1a(1) <= count(18);
	 w1a(2) <= count(19);
	 w1a(3) <= count(20);

	nreset <= not buttons(3);
	--tx <= rx;
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

--	uart_mem_dump1: uart_mem_dump
--	Port map(
--		clk => clk,
--		nreset => nreset,
--		
--		mem_addr => mem_addr,
--		mem_data => mem_data,
--		
--		mem_read => mem_read,	-- Read request
--		mem_waitrequest => mem_waitrequest,
--		mem_readdatavalid => mem_readdatavalid,
--		
--		uart_data => uart_data,
--		uart_valid => uart_valid,
--		uart_ready => uart_ready
--	);
--        fake_flash : my_onchip_flash
--                port map (
--                        clock                   => clk,                   --    clk.clk
--                        avmm_csr_addr           => '0',           --    csr.address
--                        avmm_csr_read           => '0',           --       .read
--                        avmm_csr_writedata      => x"EEEEEEEE",      --       .writedata
--                        avmm_csr_write          => '0',          --       .write
--                        avmm_csr_readdata       => open,       --       .readdata
--                        avmm_data_addr          => mem_addr,          --   data.address
--                        avmm_data_read          => mem_read,          --       .read
--                        avmm_data_writedata     => x"EEEEEEEE",     --       .writedata
--                        avmm_data_write         => '0',         --       .write
--                        avmm_data_readdata      => mem_data,      --       .readdata
--                        avmm_data_waitrequest   => mem_waitrequest,   --       .waitrequest
--                        avmm_data_readdatavalid => mem_readdatavalid, --       .readdatavalid
--                        avmm_data_burstcount    => "01",    --       .burstcount
--                        reset_n                 => nreset                  -- nreset.reset_n
--                );

end Behavioral;
