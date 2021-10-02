class AES_test extends uvm_test;
    `uvm_component_utils(AES_test)

    AES_env aes_env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        aes_env = AES_env::type_id::create(.name("aes_env"), .parent(this));
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        AES_sequence aes_seq;

        phase.raise_objection(.obj(this));
        aes_seq = AES_sequence::type_id::create(.name("aes_seq"));

        phase.drop_objection(.obj(this));
    endtask: run_phase
endclass: AES_test