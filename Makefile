# ===== User settings =====
TOP      := tb_top
RTL_F    := rtl.f
TB_F     := tb.f
WORK     := work

UVM_HOME := /tools/questasim/uvm-1.2

# Output directories
SIM_DIR  := sim
WAVE_DIR := $(SIM_DIR)/waves

# Compile options
VLOG_OPTS := -sv \
             +incdir+$(UVM_HOME)/src \
             $(UVM_HOME)/src/uvm_pkg.sv \
             +define+UVM_NO_DPI

# Optimization options for design.bin
VOPT_OPTS := +acc -o design_opt

# QuestaSim options with qwavedb (for Visualizer)
VSIM_QWAVE_OPTS := -uvmcontrol=all \
                   -qwavedb=+signal+memory+class+uvm_schematic

# QuestaSim options with WLF (for traditional wave viewer)
VSIM_WLF_OPTS := -uvmcontrol=all \
                 -wlf $(WAVE_DIR)/vsim.wlf

# ===== Default =====
all: run

lib:
	vlib $(WORK)
	vmap $(WORK) $(WORK)

compile: lib
	vlog $(VLOG_OPTS) -f $(RTL_F)
	vlog $(VLOG_OPTS) +incdir+tb -f $(TB_F)

# Optimize design and create design.bin
opt: compile
	vopt $(VOPT_OPTS) $(WORK).$(TOP)

# Run simulation with qwavedb (for Visualizer)
run: opt
	@mkdir -p $(WAVE_DIR)
	vsim -c design_opt $(VSIM_QWAVE_OPTS) -do "run -all; quit"

# Run simulation with WLF (traditional waveform)
run_wlf: opt
	@mkdir -p $(WAVE_DIR)
	vsim -c design_opt $(VSIM_WLF_OPTS) -do "log -r /*; run -all; quit"

# GUI mode with qwavedb
gui: opt
	@mkdir -p $(WAVE_DIR)
	vsim design_opt $(VSIM_QWAVE_OPTS)

# GUI mode with WLF and wave.do
gui_wlf: opt
	@mkdir -p $(WAVE_DIR)
	vsim design_opt $(VSIM_WLF_OPTS) -do "do sim/wave.do; run -all"

# Run with specific test (qwavedb)
run_test: opt
	@mkdir -p $(WAVE_DIR)
	vsim -c design_opt $(VSIM_QWAVE_OPTS) +UVM_TESTNAME=async_fifo_rd_test -do "run -all; quit"

# Run with specific test (WLF)
run_test_wlf: opt
	@mkdir -p $(WAVE_DIR)
	vsim -c design_opt $(VSIM_WLF_OPTS) +UVM_TESTNAME=async_fifo_rd_test -do "log -r /*; run -all; quit"

# GUI with specific test
gui_test: opt
	@mkdir -p $(WAVE_DIR)
	vsim design_opt $(VSIM_QWAVE_OPTS) +UVM_TESTNAME=async_fifo_rd_test

# Clean all generated files
clean:
	rm -rf $(WORK) transcript vsim.wlf modelsim.ini *.qdb qwave.db design_opt

# Clean including wave directory
cleanall: clean
	rm -rf $(SIM_DIR)

.PHONY: all lib compile opt run run_wlf gui gui_wlf run_test run_test_wlf gui_test clean cleanall
