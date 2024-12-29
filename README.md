
Papilio One 500k is based on Xilinx FPGA: xc3s500e-4-vq100

How to program FPGA on linux:
- install ISE 14.7 and build the bitstream (*.bit):
-- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_ISE_DS_Lin_14.7_1015_1.tar
- clone https://github.com/nsauzede/Papilio-Loader.git branch f-ns-fix
- on Archlinux, install:
-- pacman -S ftdi libusb-compat

Program FPGA RAM (temporary):
sudo <papilio-prog>/papilio-prog -f aaatop.bit

Program FPGA SPI Flash (permanent):
sudo <papilio-prog>/papilio-prog -f aaatop.bit -b <papilio-prog>/bscan_spi_xc3s500e.bit
