DESIGN          = j1soc
PINS            = $(DESIGN).ucf
DEVICE          = xc6slx4-tqg144-2
BGFLAGS         = -g TdoPin:PULLNONE -g DonePin:PULLUP \
                  -g CRC:enable -g StartUpClk:CCLK
USER			= pi
IP				= 192.168.1.20

XILINXCADROOT   = /opt/Xilinx/13.4/ISE_DS/ISE/bin/lin/ise
SIM_CMD         = vsim 
SIM_COMP_SCRIPT = simulation/$(DESIGN)_TB.do
SIMGEN_OPTIONS  = -p $(FPGA_ARCH) -lang $(LANGUAGE)
IVERILOG        = iverilog

SAKC_IP         = 192.168.1.20

#MULT		= multiplier
#MULT_32		= multiplier/mult_32
#J1			= j1
#DIV			= divider
#DIV_16		= divider/div_16
UART		= uart
#dp_RAM		= dpRAM
#GPOUT 		= gpout
#GPIN 		= gpin
EVERLOOP	= everloop
UVSENSOR	= uvSensor
WIFI 		= Comunicaciones

# SOURCE
# j1soc:
#SRC         = $(DESIGN).v j1.v dpram.v $(UART)/uart.v $(UART)/peripheral_uart.v $(MULT)/peripheral_mult.v  $(MULT_32)/acc.v  $(MULT_32)/comp.v  $(MULT_32)/control_mult.v  $(MULT_32)/lsr.v  $(MULT_32)/rsr.v  $(MULT_32)/mult_32.v $(DIV)/peripheral_div.v $(DIV_16)/control_div.v $(DIV_16)/counter_div.v $(DIV_16)/div_16.v $(DIV_16)/final_result.v $(DIV_16)/lsr_div.v $(DIV_16)/subtractor.v $(dp_RAM)/core_peripheric.v $(dp_RAM)/dualport_RAM.v $(dp_RAM)/dpRAM_interface.v
SRC_CORE 	= j1.v dpram.v 
#SRC_DPRAMP 	= $(dp_RAM)/core_peripheric.v $(dp_RAM)/dualport_RAM.v $(dp_RAM)/dpRAM_interface.v
#SRC_UART 	= $(UART)/uart.v $(UART)/uart_rx.v $(UART)/baudgen_rx.v $(UART)/peripheral_uart.v 
#SRC_MULT 	= $(MULT)/peripheral_mult.v  $(MULT_32)/acc.v  $(MULT_32)/comp.v  $(MULT_32)/control_mult.v  \
			  $(MULT_32)/lsr.v  $(MULT_32)/rsr.v $(MULT_32)/mult_32.v 
#SRC_DIV 	= $(DIV)/peripheral_div.v $(DIV_16)/control_div.v $(DIV_16)/counter_div.v $(DIV_16)/div_16.v \
			  $(DIV_16)/final_result.v $(DIV_16)/lsr_div.v $(DIV_16)/subtractor.v 
#SRC_GPOUT	= $(GPOUT)/peripheral_gpout.v
#SRC_GPIN	= $(GPIN)/peripheral_gpin.v
#SRC_EVERLOOP = $(EVERLOOP)/everloop.v $(EVERLOOP)/everloopRAM.v $(EVERLOOP)/everloop_interface.v 
#SRC_UVSENSOR = $(UVSENSOR)/uvSensor.v $(UVSENSOR)/control/control.v $(UVSENSOR)/i2c/i2c_master.v $(UVSENSOR)/peripheral_uvSensor.v 
SRC_WIFI	 = $(WIFI)/TOP.v $(WIFI)/Comunicaciones/Comunicaciones.v $(WIFI)/Control/Control.v $(WIFI)/EnviarDatos/EnviarDatos.v $(WIFI)/EnviarDatos/uart_tx.v $(WIFI)/EnviarDatos/baudgen.v $(WIFI)/peripheral_Comunicaciones.v $(WIFI)/peripheral_Datos.v
#SRC         = $(DESIGN).v $(SRC_CORE) $(SRC_DPRAMP) $(SRC_UART) $(SRC_MULT) $(SRC_DIV) $(SRC_GPOUT) $(SRC_GPIN)
SRC          = $(DESIGN).v $(SRC_CORE) $(SRC_DPRAMP) $(SRC_UART) $(SRC_EVERLOOP) $(SRC_UVSENSOR) $(SRC_WIFI)



SIM_SRC = $(DESIGN)_TB.v          \

 
all:            bits

remake:         clean-build all

clean:
	rm -f *~ */*~ a.out *.log *.key *.edf *.ps trace.dat 
	rm -f *.bit
	rm -rf build

cleanall: clean
	rm -rf build simulation/work simulation/transcript  simulation/vsim.wlf simulation/$(DESIGN)_TB.vvp simulation/*

bits:           $(DESIGN).bit

#
# Synthesis
#
build/project.src:
	@[ -d build ] || mkdir build
	@[ -d simulation ] || mkdir simulation
	@rm -f $@
	for i in $(SRC); do echo verilog work ../$$i >> $@; done
	for i in $(SRC_HDL); do echo VHDL work ../$$i >> $@; done

build/project.xst: build/project.src
	echo "run" > $@
	echo "-top $(DESIGN) " >> $@
	echo "-p $(DEVICE)" >> $@
	echo "-opt_mode Area" >> $@
	echo "-opt_level 1" >> $@
	echo "-ifn project.src" >> $@
	echo "-ifmt mixed" >> $@
	echo "-ofn project.ngc" >> $@
	echo "-ofmt NGC" >> $@
	echo "-rtlview yes" >> $@

build/project.ngc: build/project.xst $(SRC)
	cd build && xst -ifn project.xst -ofn project.log

build/project.ngd: build/project.ngc $(PINS)
	cd build && ngdbuild -p $(DEVICE) project.ngc -uc ../$(PINS)

build/project.ncd: build/project.ngd
	cd build && map -w -pr b -p $(DEVICE) project

build/project_r.ncd: build/project.ncd
	cd build && par -w project project_r.ncd

build/project_r.twr: build/project_r.ncd
	cd build && trce -v 25 project_r.ncd project.pcf

$(DESIGN).bit:  build/project_r.ncd build/project_r.twr
	cd build && bitgen project_r.ncd -l -w $(BGFLAGS)
	@mv -f build/project_r.bit $@

build/project_r.v: build/project_r.ncd
	cd build &&  ngd2ver project.ngd  -w project.v

postsim: build/project.ngc
	cd build &&  netgen -sim -ofmt verilog project.ngc
	cd build && iverilog -Wall \
	-y $(XILINXCADROOT)/verilog/src/unisims \
	-y $(XILINXCADROOT)/verilog/src/XilinxCoreLib \
	project.v ../$(DESIGN)_TB.v -o $(DESIGN).bin
	cd build && vvp $(DESIGN).bin
	gtkwave build/$(DESIGN)_TB.vcd&


iversim:  build/project.src
	$(IVERILOG) -gno-io-range-error -o simulation/$(DESIGN)_TB.vvp $(VINCDIR) $(SRC) $(SIM_SRC) -s $(DESIGN)_TB
	vvp simulation/$(DESIGN)_TB.vvp; mv $(DESIGN)_TB.vcd simulation/
	gtkwave simulation/$(DESIGN)_TB.vcd&

upload: $(DESIGN).bit
	scp $(DESIGN).bit root@$(SAKC_IP): 

config: $(DESIGN).bit
	scp $(DESIGN).bit $(USER)@$(IP):/home/pi
	ssh $(USER)@$(IP) sudo xc3sprog -c matrix_pi $(DESIGN).bit -p 1
