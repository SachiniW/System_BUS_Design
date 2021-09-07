transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/increment.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/uart_tx.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/uart_rx.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/master_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/master_out_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/master_in_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/Bus_mux.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/Bus_interconnect.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/Bus_Arbiter.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/slave_out_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/slave_in_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/scaledclock.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/bin27.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/slave_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/uart_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/bridge.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/bridge_module.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/top2.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/increment_module.v}

vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/bus/top2_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  top2_tb

add wave *
view structure
view signals
run -all
