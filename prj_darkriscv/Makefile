SRC:=bram_v.v ../common/wingbutled_v.v dut.v dut_tb.v

all: dut.vcd

view: dut.vcd
	gtkwave $< default.gtkw &

dut.vcd: dut.output
	vvp $<

dut.output: $(SRC)
	iverilog -o $@ $^

clean:
	rm -f dut_output dut.vcd
