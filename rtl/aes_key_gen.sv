module aes_key_gen (

input logic clk,nrst ,en ,gen_key,next_rnd,
input  aes_pkg:: aes_32 r_con_ctrl,
input  aes_pkg:: aes_byte r_con_i,
input  aes_pkg:: aes_128 key_i,
input  aes_pkg:: aes_32 sub_i,
output aes_pkg:: aes_32 sub_o,
output aes_pkg:: aes_128 key_o

);

aes_pkg:: key_128 word_rnd_in,word_rnd;
aes_pkg:: key_128 word_rnd_out;
aes_pkg:: aes_128 key_round;
aes_pkg:: aes_byte rcon_o; 
aes_pkg:: aes_32 xor_result; 


////////////////////////////////////////////////////////////////////////////////////////
//Muxs
//first mux 
assign rcon_o  = gen_key ? r_con_ctrl : r_con_i;
//secound mux 
assign key_round  = next_rnd ? key_o : key_i;
//////////////////////////////////////////////////////////////////////////////////////// 
assign word_rnd_in = key_round;
assign sub_o = ( word_rnd_in[3] << 8); //  to s_box 

/* key_gen pipeline*/
  aes_pipeline key_gen_pipe_1 (
    .clk(clk),
    .nrst(nrst),
    .en(en),
    .input_i(word_rnd_in),
    .output_o(word_rnd)
);

assign xor_result = 32'({(rcon_o^sub_i[0]),sub_i[1:3]});//after pipe1

always_comb
begin
word_rnd_out[0] = word_rnd[0] ^ (xor_result);//rcon from ctrl^sub_i from s_box
word_rnd_out[1] = word_rnd[1] ^ word_rnd_out[0];
word_rnd_out[2] = word_rnd[2] ^ word_rnd_out[1];
word_rnd_out[3] = word_rnd[3] ^ word_rnd_out[2];
end


/* key_gen pipeline*/
  aes_pipeline key_gen_pipe_2 (
    .clk(clk),
    .nrst(nrst),
    .en(en),
    .input_i(word_rnd_out),
    .output_o(key_o)
);



endmodule

