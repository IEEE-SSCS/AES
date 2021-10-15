class aes_monitor_before extends uvm_monitor;   // the result monitor 

	`uvm_component_utils(aes_monitor_before) 

// declare the interface and the analysis port 
virtual aes_if vif; 
uvm_analysis_port#(aes_transaction) mon_ap_before ;     
//aes_transaction aes_tx;

function new(string name,uvm_component parent);
	super.new(name, parent);
endfunction: new 

// instantiate the analysis port  and get the interface value 
function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(virtual aes_if)::get(this,"*","vif",vif))
		`uvm_fatal("MON","could not get vif") 

	mon_ap_before = new(.name("mon_ap_before"), .parent(this));

endfunction: build_phase

task run_phase(uvm_phase phase);
	aes_transaction aes_tx;
	aes_tx = aes_transaction::type_id::create(.name("aes_tx"), .contxt(get_full_name()));
	//vif.get_sequence(aes_tx);
	//mon_ap_before.write(aes_tx);



	forever begin 
		
		@(posedge vif.clk)
		begin
			if(vif.start_i==1'b1)
			begin
				aes_tx.key_ready_o = vif.key_ready_o ;
				aes_tx.cipher_ready_o = vif.cipher_ready_o ;
				aes_tx.busy_o = vif.busy_o ;
				aes_tx.cipher_o = vif.cipher_o ; 
					
				mon_ap_before.write(aes_tx);
			end
		end 
	end 


endtask: run_phase

endclass : aes_monitor_before 

//////////////////////////////////////////////////////////////////// 

class aes_monitor_after extends uvm_monitor; // the command monitor  

	`uvm_component_utils(aes_monitor_after) 

virtual aes_if vif;
uvm_analysis_port#(aes_transaction) mon_ap_after;
//aes_transaction aes_tx;  

function new(string name, uvm_component parent);
	super.new(name, parent);
	
endfunction: new

function void build_phase(uvm_phase phase);

	super.build_phase(phase);

	if(!uvm_config_db#(virtual aes_if)::get(this,"*","vif",vif))
		`uvm_fatal("MON","could not get vif") 

	mon_ap_after = new(.name("mon_ap_before"), .parent(this));

endfunction: build_phase

task run_phase(uvm_phase phase);
	aes_transaction aes_tx;  
	aes_tx = aes_transaction::type_id::create(.name("aes_tx"), .contxt(get_full_name()));
	//vif.get_sequence(aes_tx);
	//mon_ap_after.write(aes_tx);  
	forever begin 
		
		@(posedge vif.clk)
		begin
			if(vif.start_i==1'b1)   
			begin
				//aes_tx.clk = vif.clk ; 	
				//aes_tx.nrst = vif.nrst ; 
				//aes_tx.opcode_i = vif.opcode_i ;
				aes_tx.key_i = vif.key_i ;
				aes_tx.r_con_i = vif.r_con_i ;
				aes_tx.plain_text_i = vif.plain_text_i ; 
				////
				mon_ap_after.write(aes_tx);  
			end
		end 
	end 

	
endtask: run_phase

endclass : aes_monitor_after 
