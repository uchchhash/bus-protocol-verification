
# NC-Sim Command File
# TOOL:	ncsim	15.20-s044
#
#
# You can restore this configuration with:
#
#      irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=spi_combination_test -s -input /home/Uc211217/uchchhash_work/digital_verification/apb_spi/spi_master_v5/sim/debug.tcl
#

set tcl_prompt1 {puts -nonewline "ncsim> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1
set assert_reporting_mode 0
alias . run
alias iprof profile
alias quit exit
stop -create -name Randomize -randomize
database -open -shm -into waves.shm waves -default
probe -create -database waves tb_top.apb_intf.PCLK tb_top.apb_intf.PRESETn tb_top.apb_intf.PREADY tb_top.apb_intf.PSEL tb_top.apb_intf.PENABLE tb_top.apb_intf.PSLVERR tb_top.DUT.PWRITE tb_top.apb_intf.PADDR tb_top.apb_intf.PWDATA tb_top.apb_intf.PRDATA tb_top.DUT.rx tb_top.DUT.divider tb_top.DUT.ss tb_top.DUT.ctrl tb_top.DUT.char_len tb_top.DUT.tx_negedge tb_top.DUT.rx_negedge tb_top.DUT.lsb tb_top.DUT.ass tb_top.DUT.ie tb_top.DUT.go tb_top.sclk_pad_o_signal tb_top.mosi_pad_o_signal tb_top.miso_pad_i_signal tb_top.ss_pad_o_signal tb_top.intr_intf.IRQ tb_top.DUT.shift.s_in tb_top.DUT.shift.rx_clk tb_top.DUT.shift.rx_bit_pos tb_top.DUT.shift.data tb_top.DUT.shift.p_in tb_top.spi_vif[0].SCLK tb_top.spi_vif[0].MOSI tb_top.spi_vif[0].MISO tb_top.spi_vif[0].SLVSEL tb_top.spi_vif[1].SCLK tb_top.spi_vif[1].MOSI tb_top.spi_vif[1].MISO tb_top.spi_vif[1].SLVSEL tb_top.spi_vif[2].SCLK tb_top.spi_vif[2].MOSI tb_top.spi_vif[2].MISO tb_top.spi_vif[2].SLVSEL tb_top.spi_vif[3].SCLK tb_top.spi_vif[3].MOSI tb_top.spi_vif[3].MISO tb_top.spi_vif[3].SLVSEL tb_top.spi_vif[4].SCLK tb_top.spi_vif[4].MOSI tb_top.spi_vif[4].MISO tb_top.spi_vif[4].SLVSEL tb_top.spi_vif[5].SCLK tb_top.spi_vif[5].MOSI tb_top.spi_vif[5].MISO tb_top.spi_vif[5].SLVSEL tb_top.spi_vif[6].SCLK tb_top.spi_vif[6].MOSI tb_top.spi_vif[6].MISO tb_top.spi_vif[6].SLVSEL tb_top.spi_vif[7].SCLK tb_top.spi_vif[7].MOSI tb_top.spi_vif[7].MISO tb_top.spi_vif[7].SLVSEL
probe -create -database waves tb_top.DUT.shift.tx_clk tb_top.DUT.shift.s_clk tb_top.DUT.shift.neg_edge tb_top.DUT.shift.pos_edge

simvision -input debug.tcl.svcf
