module TestControl ; 

logic clk , nrst , start_i ; 

aes_pkg::opcode opcode_i ; 

// control signals to aes_enc
logic full_enc_o, zero_rnd_o, key_sel_o, final_rnd_o, en_rnd_o ; 

// control signal  to S_box
logic key_sub_o , en_key_o ; 

// control signals to key_gen
logic gen_key_o , next_rnd_o ;    

logic cipher_ready_o ,  key_ready_o ,  busy_o  ;    

aes_pkg::aes_32 r_con_ctrl_o ; 



///// generating the clock       
initial clk = 0;
always #10 clk = ~clk;



///// instantiation control module 
aes_ctrl ctrl_aes(
    .clk(clk),
    .nrst(nrst),
    .start_i(start_i),
    .opcode_i(opcode_i),
    .full_enc_o(full_enc_o),
    .zero_rnd_o(zero_rnd_o),
    .key_sel_o(key_sel_o),
    .final_rnd_o(final_rnd_o),
    .en_rnd_o(en_rnd_o), 
    .key_sub_o(key_sub_o),
    .en_key_o(en_key_o),                                    
    .gen_key_o(gen_key_o),
    .next_rnd_o(next_rnd_o),                                 
    .cipher_ready_o(cipher_ready_o),
    .key_ready_o(key_ready_o),
    .busy_o(busy_o),
    .r_con_ctrl_o(r_con_ctrl_o));  



initial 
begin 

nrst = 0 ; 
opcode_i = aes_pkg::NOOP ;
#200
nrst = 1 ;
start_i = 1 ;  
opcode_i = aes_pkg::AESENCFULL ; 
#200 
opcode_i = aes_pkg::AESENC ; 
#200 
opcode_i = aes_pkg::AESENCLAST ;
#200 
opcode_i =aes_pkg:: AESKEYGENASSIST ;
#200 
opcode_i = aes_pkg::AESDEC ;
#200 
opcode_i = aes_pkg::AESDECLAST ;
#200 
opcode_i = aes_pkg::AESIMC ;
$stop ; 
end 

endmodule 