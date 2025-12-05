# original mini_wrapper testbench
TOP_MINI     = tb_mini_wrapper
VERILATOR = verilator

SRC_MINI = \
    mini_test.sv \
    DSP48E1_wrapper.sv \
    DSP48E1.sv \
	dsp48e1.c

all: run

compile:
	$(VERILATOR) --cc --exe --build \
		--timing \
		--trace \
		--top-module $(TOP_MINI) \
	    -Wall -Wno-fatal \
	    -CFLAGS "-std=c++17" \
	    $(SRC_MINI) sim_main.cpp

run: compile
	./obj_dir/V$(TOP_MINI)

# fp32_utils testbench
TOP_FP32 = tb_fp32_utils
SRC_FP32 = \
    fp32_utils_pkg.sv \
    tb_fp32_utils.sv \
	dsp48e1.c

fp32_compile:
	$(VERILATOR) --cc --exe --build \
		--timing \
		--top-module $(TOP_FP32) \
		-Wall -Wno-fatal \
		-CFLAGS "-std=c++17" \
		$(SRC_FP32) sim_fp32_utils.cpp

fp32_run: fp32_compile
	./obj_dir/V$(TOP_FP32)

# clean
clean:
	rm -rf obj_dir *.vcd