class aes_env extends uvm_env;
	`uvm_component_utils(aes_env)

	aes_agent agent;
	aes_scoreboard aes_sb;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent	= aes_agent::type_id::create(.name("agent"), .parent(this));
		aes_sb		= aes_scoreboard::type_id::create(.name("aes_sb"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent.agent_ap_before.connect(aes_sb.export_before);
		agent.agent_ap_after.connect(aes_sb.export_after);
	endfunction: connect_phase
endclass: aes_env 
