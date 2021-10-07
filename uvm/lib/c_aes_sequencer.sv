
class aes_sequencer extends uvm_sequencer #(aes_transaction);

	`uvm_component_utils(aes_sequencer)

	function new(string name="aes_sequencer" ,uvm_component parent);
		super.new(name,parent);
	endfunction: new


endclass:aes_sequencer