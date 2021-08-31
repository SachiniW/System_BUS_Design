transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {c:/intelfpga_lite/20.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {c:/intelfpga_lite/20.1/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {bus.vo}

vlog -vlog01compat -work work +incdir+D:/ADS_BUS/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/ADS_BUS/System_BUS_Design/3. Quartus Projects/bus/slave_in_port_tb.v}

vsim -t 1ps -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  slave_in_port_tb

add wave *
view structure
view signals
run -all
