# Papilio One 500k Projects

Papilio One 500k is based on Xilinx FPGA: xc3s500e-4-vq100
- 20 x 18Kbit BRAM blocks
- 360Kbit Max SRAM (45KByte)
- 320Kbit Usable SRAM (40KByte)

Fully Assembled with a Xilinx XC3S500E and 4Mbit SPI Flash Memory
Provides an Easy Introduction to FPGA, Digital Electronics, and System on a Chip design
Easily add New Functionality with Wings that Snap onto the Board
Two-Channel USB Connection for JTAG and Serial Communications
Four Independent Power Rails at 5V, 3.3V, 2.5V, and 1.2V
Power Supplied by a Power Connector or USB
Input Voltage (recommended): 6.5-15V
48 I/O lines!

Check out those related resources:
- https://github.com/nsauzede/papilio_pins
- https://github.com/nsauzede/Papilio-Loader
- https://github.com/nsauzede/cpu86
- https://github.com/nsauzede/benchy_sump_p1_jtag

Pins:
```
## SPI flash
NET "SPI_CS"   LOC = "P24" | IOSTANDARD = LVCMOS33 | SLEW = SLOW | DRIVE = 8;
NET "SPI_SCK"  LOC = "P50" | IOSTANDARD = LVCMOS33 | SLEW = FAST | DRIVE = 8;
NET "SPI_MISO" LOC = "P44" | IOSTANDARD = LVCMOS33 | SLEW = FAST | DRIVE = 8;
NET "SPI_MOSI" LOC = "P27" | IOSTANDARD = LVCMOS33 ;

## JTAG
NET "JTAG_TMS" LOC = "P75"  | IOSTANDARD = LVTTL | DRIVE = 8 | SLEW = FAST ;
NET "JTAG_TCK" LOC = "P77"  | IOSTANDARD = LVTTL | DRIVE = 8 | SLEW = FAST ;
NET "JTAG_TDI" LOC = "P100" | IOSTANDARD = LVTTL | DRIVE = 8 | SLEW = FAST ;
NET "JTAG_TDO" LOC = "P76"  | IOSTANDARD = LVTTL | DRIVE = 8 | SLEW = FAST ;
```

## How to program FPGA on linux:
- install ISE 14.7 and build the bitstream (*.bit):
-- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_ISE_DS_Lin_14.7_1015_1.tar
- clone https://github.com/nsauzede/Papilio-Loader.git branch f-ns-fix
- on Archlinux, install:
-- pacman -S ftdi libusb-compat

Program FPGA RAM (temporary):
sudo <papilio-prog>/papilio-prog -f aaatop.bit

Program FPGA SPI Flash (permanent):
sudo <papilio-prog>/papilio-prog -f aaatop.bit -b <papilio-prog>/bscan_spi_xc3s500e.bit

## How to simulate with ISIM
If ISIM compiler fails because of "error: implicit declaration of function XXX"
then it's because recent C compilers use C Standard >= c99 which prevent implicit declaration of function.
One (nasty) workaround is to create "/usr/bin/gcc4" symlink to some "/usr/bin/gcc90" defined like this:
```shell
#!/bin/bash

# This kludge to workaround Xilinx ISE 14.7 generating C code with implicit function declarations
/usr/bin/gcc.orig -std=c90 $*
```
Don't forget to manually patch Xilinx/14.7/ISE_DS/ISE/data/include/{xsi.h, ieee_accel.h} to remove the "//" C++-style comments
because they are unsupported by "-std=c90".
