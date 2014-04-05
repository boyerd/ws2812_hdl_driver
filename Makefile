FUSE=fuse
FUSE_OPTS=-intstyle ise -incremental -lib unisims_ver -lib unimacro_ver -lib xilinxcorelib_ver -lib secureip
SRC_DIR=./src/
TB_DIR=./bench/

DEPS=ws2812_gen.vhd
TB=ws2812_gen

DEP_VDB=$(addprefix isim/work/, $(addsuffix .vdb, $(notdir $(basename $(DEPS)))))
BENCH=$(addsuffix .testbench, $(TB))
DEP_VHDL=$(addprefix $(SRC_DIR), $(DEPS))

all: tb

.PHONY : all clean test 
	
test: $(BENCH)

%.testbench: % 
	./$(basename $@) -tclbatch $(TB_DIR)/$(basename $@)_tb.tcl -intstyle silent

$(TB): $(DEP_VDB)
	$(FUSE) $(FUSE_OPTS) work.$@ -o $@

$(DEP_VDB): $(DEP_VHDL)
	vhpcomp $(DEP_VHDL)

clean:
	-rm -f $(TB)
	-rm -rf isim
	-rm -f *.wdb
	-rm -f *.tap
	-rm -f *.xmsgs
	-rm -f *.log
	-rm -f *.cmd

#BIN=ws2803

#test: tb
#	./$(BIN) -tclbatch $(BIN)_tb.tcl -intstyle silent
#
#gui: tb
#	./$(BIN) -tclbatch $(BIN)_tb.tcl -intstyle silent -gui -view view.wcfg
#
#$(BIN): $(SRC_DIR)/$(BIN).vhd isim/work/$(BIN).vdb

