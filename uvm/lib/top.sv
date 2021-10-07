
import uvm_pkg::*;
`include "uvm_macros.svh" 


import aes_pkg::*;
import pkg::*;
`include "aes_if.sv"


module top;
	import aes_pkg::*;
	//interface declaration
	 aes_if vif();


	//connects the interface to the dut
	aes_top dut(
		vif.clk,
    		vif.nrst,
	
    		vif.opcode_i,
		vif.start_i,
     		vif.key_ready_o,
     	 	vif.cipher_ready_o,
    	 	vif.busy_o,

     		vif.key_i,
     		vif.r_con_i,

     		vif.plain_text_i,
     		vif.cipher_o
		);

	initial begin
		uvm_config_db #(virtual aes_if)::set(null,"*","vif",vif);
		run_test();//start the test
		end

	
endmodule