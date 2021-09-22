class AES_env extends uvm_env;
	`uvm_component_utils(AES_env)

	AES_agent aes_agent;
	AES_scoreboard aes_sb;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		aes_agent	= simpleadder_agent::type_id::create(.name("aes_agent"), .parent(this));
		aes_sb		= simpleadder_scoreboard::type_id::create(.name("aes_sb"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		aes_agent.agent_ap_before.connect(aes_sb.sb_export_before);
		aes_agent.agent_ap_after.connect(aes_sb.sb_export_after);
	endfunction: connect_phase
endclass: simpleadder_env 