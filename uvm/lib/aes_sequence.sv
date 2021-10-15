
class aes_sequence extends uvm_sequence #(aes_transaction);

	`uvm_object_utils(aes_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	

	task body();
		aes_transaction trn;
		
		begin

		trn =aes_transaction::type_id::create(.name("trn"));
		start_item(trn);//blocks until the uvm_sequencer is ready to accept our sequence item
		assert(trn.randomize());
		finish_item(trn);// blocks until the driver completes the command

		end
	endtask: body
endclass:aes_sequence
