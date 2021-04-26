module aes_top(
/*control signals
input  opcode_i,
input run_i,
output key_ready_o,
output cipher_ready_o, */

//key_gen signals
input aes_pkg:: aes_128 key_i,
input aes_pkg:: aes_byte r_con_i,

//aes_enc signals
input aes_pkg:: aes_128 plain_text_i,
output aes_pkg:: aes_128 cipher_o
);

//key_gen wires
aes_pkg:: aes_32 sub_i,sub_o;
aes_pkg:: aes_128 key_o;

//s_box to enc wire
aes_pkg:: aes_128 mapped_i ;

//control wires

//control singals for aes_key_gen
aes_pkg:: aes_byte r_con_ctrl;
logic clk ,nrst ,en , gen_key, next_rnd;
//control signals for aes_enc
logic full_enc, zero_rnd, final_rnd;
//control signals for aes_sbox
logic key_gen;

//s_byte instantiate 
aes_sbox sbox_module (
  .in(cipher_o),
  .key_in(sub_o),
  .key_gen(key_gen),
  .out(mapped_i),
  .key_out(sub_i)
);

//key_gen instantiate
aes_key_gen key_gen_module (
  .clk(clk),
  .nrst(nrst),
  .en(en),
  .gen_key(gen_key),
  .next_rnd(next_rnd),
  .r_con_ctrl(r_con_ctrl),
  .r_con_i(r_con_i),
  .key_i(key_i),
  .key_o(key_o),
  .sub_i(sub_i),
  .sub_o(sub_o)
);

//enc instantiate 
aes_enc enc_module (
  .clk(clk),
  .nrst(nrst),
  .en(en),
  .plain_text_i(plain_text_i),
  .mapped_i(mapped_i),
  .key_i(key_i),
  .rnd_key_i(key_o),
  .full_enc(full_enc),
  .zero_rnd(zero_rnd),
  .final_rnd(final_rnd),
  .cipher_o(cipher_o)
);

//control instantiate


endmodule
