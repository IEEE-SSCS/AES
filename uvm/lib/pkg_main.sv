package pkg_main;
	
import aes_pkg::*;

	import uvm_pkg::*;
	`include "uvm_macros.svh" 

	`include "aes_transaction.sv"
	`include "aes_sequence.sv"
	`include "aes_sequencer.sv"
	`include "aes_monitor.sv"
	//`include "aes_monitor_after.sv"
	`include "aes_driver.sv"
	//`include "aes_agent_config.sv"
	`include "aes_agent.sv"
	`include "fill.sv"

	
	`include "aes_scoreboard.sv"
	//`include "aes_env_config.sv"
	`include "aes_env.sv"
	`include "aes_test.sv"
        
	

endpackage: pkg_main
