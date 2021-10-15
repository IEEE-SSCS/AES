interface aes_if;

    	logic clk;
    	logic nrst;

	//control out signals
        aes_pkg::opcode opcode_i;
	logic start_i;
     	logic key_ready_o;
     	logic cipher_ready_o;
    	logic busy_o;

	//key_gen signals
     	aes_pkg:: aes_128 key_i;
     	aes_pkg:: aes_byte r_con_i;

	//aes_enc signals
     	aes_pkg:: aes_128 plain_text_i;
     	aes_pkg:: aes_128 cipher_o;


	//setters 
	   task set_sequence(input aes_transaction trn);
		//translate sequences to signals
		
		start_i=1'b0;
		nrst=1'b0;
		forever begin
			@(posedge clk)
			begin	
				start_i=1'b1;
				nrst=1'b1;
				trn.opcode_i=AESENCFULL;

				opcode_i=trn.opcode_i;
				key_ready_o=trn.key_ready_o;
				cipher_ready_o=trn.cipher_ready_o;
				busy_o=trn.busy_o;
				key_i=trn.key_i;
				r_con_i=trn.r_con_i;
				plain_text_i=trn.plain_text_i;
				cipher_o=trn.cipher_o;
			end

		end

	endtask:set_sequence


	//getters
	 task get_sequence(output aes_transaction trn);
		
				forever begin 
		
			@(posedge clk)
			begin
				if(start_i==1'b1)
				begin
					trn.key_ready_o = key_ready_o ;
					trn.cipher_ready_o = cipher_ready_o ;
					trn.busy_o = busy_o ;
					trn.cipher_o = cipher_o ; 
					trn.opcode_i = opcode_i ;
					trn.key_i = key_i ;
					trn.r_con_i = r_con_i ;
					trn.plain_text_i = plain_text_i ; 
						
					//mon_ap_before.write(trn);
				end
			end 
			end
	
	endtask:get_sequence


	//reset task
	 task reset();
		@(posedge clk)begin
			nrst=1'b0;
		end
		
		@(posedge clk);//wait

		nrst=1'b1;
	 endtask:reset
	
	
	//initial reset
	initial begin
		reset();
	end

	//initial clock
	initial begin
		clk <= 1'b1;

		forever
		#5 clk = ~clk;
	end
	
	
	

endinterface 


