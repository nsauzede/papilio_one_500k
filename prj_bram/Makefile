DUT:=top_icarus
SRC:=bram_v.v ../common/wingbutled_v.v dut.v top.v top_tb.v
IVOPT:=-D TOP_VCD=\"top_icarus.vcd\"

all: $(DUT).vcd

view: $(DUT).vcd
	gtkwave $< default_icarus.gtkw &

$(DUT).vcd: $(DUT).output
	vvp $<

$(DUT).output: $(SRC)
	iverilog $(IVOPT) -o $@ $^

clean:
	rm -f $(DUT).output $(DUT).vcd
