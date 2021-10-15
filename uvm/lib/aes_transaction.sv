
class aes_transaction extends uvm_sequence_item;

	
	
	 // logic clk;
	 //rand logic nrst;

	 //control out signals
  	 aes_pkg::opcode opcode_i;
  	 //rand  logic start_i;
    	 logic key_ready_o;
    	 logic cipher_ready_o;
    	 logic busy_o;

	 //key_gen signals
	 rand aes_pkg:: aes_128 key_i;
	 rand aes_pkg:: aes_byte r_con_i;

	 //aes_enc signals
	 rand aes_pkg:: aes_128 plain_text_i;
	 aes_pkg:: aes_128 cipher_o;

	`uvm_object_utils(aes_transaction)

//constructor

	function new(string name= "");
		super.new(name);
	endfunction:new

//methods

	//print
	virtual function string convert2string();
		string s;
		s=$sformatf("  key_i=0x%0h  r_con_i=0x%0h  plain_text_i=0x%0h",key_i,r_con_i,plain_text_i);
		return s;

	endfunction:convert2string

		
	//copy
	virtual function void do_copy(uvm_object rhs);
		aes_transaction copied_transaction;
		if(rhs==null)	//check to make sure that we weren't passed a null handle
			`uvm_fatal(" fatal transaction","tried to copy from a null pointer")
		if(! $cast(copied_transaction,rhs))	//check to make sure that the rhs variable holds an object of our type
			`uvm_fatal(" fatal transaction","tried to copy wrong type")
		super.do_copy(rhs);	//copy all data
		
		//opcode_i=copied_transaction.opcode_i;
		key_i=copied_transaction.key_i;
		r_con_i=copied_transaction.r_con_i;
		plain_text_i=copied_transaction.plain_text_i;

	endfunction:do_copy

	//compare
	virtual function bit do_compare(uvm_object rhs,uvm_comparer comparer);
		aes_transaction compared_transaction;
		bit res;
		if(rhs==null)	//check to make sure that we weren't passed a null handle
			`uvm_fatal(" fatal transaction","tried to compare a null pointer")
		if(! $cast(compared_transaction,rhs))	//check to make sure that the rhs variable holds an object of our type
			res=0;
		else
			res=super.do_compare(rhs,comparer)&&
				//opcode_i==compared_transaction.opcode_i&&
				key_i==compared_transaction.key_i&&
				r_con_i==compared_transaction.r_con_i&&
				plain_text_i==compared_transaction.plain_text_i;
		return res;
				
	endfunction:do_compare

endclass:aes_transaction
