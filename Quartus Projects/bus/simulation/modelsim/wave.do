onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /slave_3k_tb/clk
add wave -noupdate /slave_3k_tb/reset
add wave -noupdate /slave_3k_tb/write_en
add wave -noupdate /slave_3k_tb/master_valid
add wave -noupdate /slave_3k_tb/slave_ready
add wave -noupdate /slave_3k_tb/rx_address
add wave -noupdate /slave_3k_tb/rx_data
add wave -noupdate /slave_3k_tb/rx_done
add wave -noupdate -color Yellow /slave_3k_tb/read_en
add wave -noupdate -color Yellow /slave_3k_tb/master_ready
add wave -noupdate -color Yellow /slave_3k_tb/slave_valid
add wave -noupdate -color Yellow /slave_3k_tb/tx_data
add wave -noupdate -color Yellow /slave_3k_tb/slave_tx_done
add wave -noupdate /slave_3k_tb/UUT/datain
add wave -noupdate /slave_3k_tb/UUT/address
add wave -noupdate /slave_3k_tb/UUT/data
add wave -noupdate -expand -group SLAVE_IN /slave_3k_tb/UUT/UUT/SLAVE_IN_PORT/addr_state
add wave -noupdate -expand -group SLAVE_IN /slave_3k_tb/UUT/UUT/SLAVE_IN_PORT/data_state
add wave -noupdate -expand -group SLAVE_OUT /slave_3k_tb/UUT/UUT/SLAVE_OUT_PORT/data_state
add wave -noupdate -expand -group SLAVE_OUT /slave_3k_tb/UUT/UUT/SLAVE_OUT_PORT/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {344656 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 353
configure wave -valuecolwidth 112
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {732616 ps}
