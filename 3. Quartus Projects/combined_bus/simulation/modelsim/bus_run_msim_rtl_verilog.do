transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/increment.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/uart_tx.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/uart_rx.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/master_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/master_out_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/master_in_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/Bus_mux.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/Bus_interconnect.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/Bus_Arbiter.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/slave_out_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/slave_in_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/scaledclock.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/bin27.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/slave_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/uart_port.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/bridge.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/bridge_module.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/top2.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/increment_module.v}
vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/tops_combined.v}

vlog -vlog01compat -work work +incdir+D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3.\ Quartus\ Projects/combined_bus {D:/Academics/ADS/Project/Bus_project/System_BUS_Design/3. Quartus Projects/combined_bus/tops_combined_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tops_combined_tb

add wave *
view structure
view signals
run -all
