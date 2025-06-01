onerror {resume}
add list /tb_top/x
add list /tb_top/y
add list /tb_top/en
add list /tb_top/rst
add list /tb_top/clk
add list /tb_top/ALUFN
add list /tb_top/PWM_out
add list /tb_top/ALUout_o
add list /tb_top/Nflag_o
add list /tb_top/Cflag_o
add list /tb_top/Zflag_o
add list /tb_top/Vflag_o
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
