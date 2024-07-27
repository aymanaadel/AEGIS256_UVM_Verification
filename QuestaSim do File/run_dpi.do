vlib work
vlog -f src_files.list -mfcu +cover -covercells
vsim -sv_lib ./AEGIS_check top
run -all