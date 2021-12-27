onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /slave_4k_tb/clk
add wave -noupdate /slave_4k_tb/reset
add wave -noupdate /slave_4k_tb/slave_ready
add wave -noupdate /slave_4k_tb/master_valid
add wave -noupdate -color Yellow /slave_4k_tb/rx_address
add wave -noupdate -color Yellow -radix hexadecimal /slave_4k_tb/UUT/SLAVE_PORT/SLAVE_IN_PORT/address
add wave -noupdate -color Yellow -radix hexadecimal /slave_4k_tb/UUT/SLAVE_PORT/SLAVE_IN_PORT/addr_state
add wave -noupdate -color Yellow /slave_4k_tb/rx_done
add wave -noupdate -color Green /slave_4k_tb/read_en
add wave -noupdate -color Green /slave_4k_tb/UUT/SLAVE_PORT/read_en_in1
add wave -noupdate -color Green /slave_4k_tb/UUT/SLAVE_PORT/read_en_in
add wave -noupdate -color Green /slave_4k_tb/slave_valid
add wave -noupdate -color Green /slave_4k_tb/master_ready
add wave -noupdate -color Yellow /slave_4k_tb/tx_data
add wave -noupdate -color Yellow -radix hexadecimal /slave_4k_tb/UUT/SLAVE_PORT/SLAVE_OUT_PORT/data_state
add wave -noupdate -color Yellow -radix hexadecimal /slave_4k_tb/UUT/SLAVE_PORT/SLAVE_OUT_PORT/datain
add wave -noupdate -color Yellow /slave_4k_tb/slave_tx_done
add wave -noupdate -expand -group BRAM -color Salmon -radix hexadecimal /slave_4k_tb/UUT/BRAM/address
add wave -noupdate -expand -group BRAM -color Salmon /slave_4k_tb/UUT/BRAM/rden
add wave -noupdate -expand -group BRAM -color Salmon -radix hexadecimal /slave_4k_tb/UUT/BRAM/q
add wave -noupdate /slave_4k_tb/UUT/SLAVE_PORT/write_en_in1
add wave -noupdate /slave_4k_tb/UUT/SLAVE_PORT/write_en_in
add wave -noupdate /slave_4k_tb/UUT/write_en
add wave -noupdate /slave_4k_tb/UUT/BRAM/data
add wave -noupdate /slave_4k_tb/UUT/BRAM/wren
add wave -noupdate /slave_4k_tb/UUT/SLAVE_PORT/SLAVE_IN_PORT/data_state
add wave -noupdate /slave_4k_tb/UUT/SLAVE_PORT/SLAVE_IN_PORT/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 352
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {406681 ps}
