# Papilio One 500k Projects

Papilio One 500k is based on Xilinx FPGA: xc3s500e-4-vq100

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
