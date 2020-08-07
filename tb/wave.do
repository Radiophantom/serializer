onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /serializer_tb/clk_i
add wave -noupdate /serializer_tb/srst_i
add wave -noupdate -divider {Input interface}
add wave -noupdate /serializer_tb/data_val_i
add wave -noupdate -radix unsigned /serializer_tb/data_mod_i
add wave -noupdate -radix binary /serializer_tb/data_i
add wave -noupdate /serializer_tb/busy_o
add wave -noupdate -divider {Output interface}
add wave -noupdate /serializer_tb/ser_data_val_o
add wave -noupdate /serializer_tb/ser_data_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {395456 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue right
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {1674750 ps}
