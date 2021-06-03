#To run vsim -c -do run.do

if [file exists work] {vdel -all}
vlib work
vlog -f rtl.f
vsim  -novopt aes_top
set  NoQuitOnFinish 1
onbreak {resume}
log /* -r
