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
		
		


		vif.start_i=1'b0;
		vif.nrst=1'b0;
		forever begin
			seq_item_port.get_next_item(trn);//block until the sequencer puts data into the port and then gives a transactions in trn
			@(posedge vif.clk)
			begin	
				vif.start_i=1'b1;
				vif.nrst=1'b1;
				trn.opcode_i=AESENCFULL;

				vif.opcode_i=trn.opcode_i;
				vif.key_ready_o=trn.key_ready_o;
				vif.cipher_ready_o=trn.cipher_ready_o;
				vif.busy_o=trn.busy_o;
				vif.key_i=trn.key_i;
				vif.r_con_i=trn.r_con_i;
				vif.plain_text_i=trn.plain_text_i;
				vif.cipher_o=trn.cipher_o;

				seq_item_port.item_done();//the sequencer can send another sequence item
			end

		end

	//	vif.set_sequence(trn);

		
	endtask:run_phase


endclass:aes_driver
