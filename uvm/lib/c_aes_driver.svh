class aes_driver extends uvm_driver #(aes_transaction);

	`uvm_component_utils(aes_driver)

	virtual aes_if vif ;
	
//constructor
	function new(string name ,uvm_component parent);
		super.new(name,parent);
	endfunction: new

//build_phase

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (! uvm_config_db #(virtual aes_if)::get(this,"*","vif",vif))
			`uvm_fatal("GET INTERFACE","failed to get interface");
	endfunction:build_phase

//run_phase

	task run_phase(uvm_phase phase);
		
		aes_transaction trn;
		
		seq_item_port.get_next_item(trn);//block until the sequencer puts data into the port and then gives a transactions in trn
		vif.set_sequence(trn);
		seq_item_port.item_done();//the sequencer can send another sequence item
	endtask:run_phase


endclass:aes_driver
