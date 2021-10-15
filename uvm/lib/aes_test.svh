class aes_test extends uvm_test;
    `uvm_component_utils(aes_test)

    aes_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = aes_env::type_id::create(.name("env"), .parent(this));
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        aes_sequence aes_seq;

        phase.raise_objection(.obj(this));
        aes_seq = aes_sequence::type_id::create(.name("aes_seq"));

	assert(aes_seq.randomize());
	aes_seq.print();
	aes_seq.start(env.agent.aes_seqr);//start seq with seqr
	

        phase.drop_objection(.obj(this));
    endtask: run_phase
endclass: aes_test
