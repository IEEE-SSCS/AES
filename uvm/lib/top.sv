
import uvm_pkg::*;
`include "uvm_macros.svh" 


import aes_pkg::*;
import pkg::*;
`include "aes_if.sv"


module top;
	//import aes_pkg::*;
	//interface declaration
	 aes_if vif();


	//connects the interface to the dut
	aes_top dut(
		.clk(vif.clk),
    		.nrst(vif.nrst),
    		.opcode_i(vif.opcode_i),
		.start_i(vif.start_i),
     		.key_ready_o(vif.key_ready_o),
     	 	.cipher_ready_o(vif.cipher_ready_o),
    	 	.busy_o(vif.busy_o),
     		.key_i(vif.key_i),
     		.r_con_i(vif.r_con_i),
     		.plain_text_i(vif.plain_text_i),
     		.cipher_o(vif.cipher_o)
		);

	initial begin
		uvm_config_db #(virtual aes_if)::set(null,"*","vif",vif);
		run_test("aes_test");//start the test
		end

	
endmodule
