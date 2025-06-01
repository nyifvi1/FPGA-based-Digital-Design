onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /tb_top/x
add wave -noupdate -radix decimal /tb_top/y
add wave -noupdate /tb_top/en
add wave -noupdate /tb_top/rst
add wave -noupdate /tb_top/clk
add wave -noupdate /tb_top/ALUFN
add wave -noupdate /tb_top/PWM_out
add wave -noupdate /tb_top/ALUout_o
add wave -noupdate /tb_top/Nflag_o
add wave -noupdate /tb_top/Cflag_o
add wave -noupdate /tb_top/Zflag_o
add wave -noupdate /tb_top/Vflag_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 160
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
WaveRestoreZoom {0 ps} {19982229 ps}
