module aes_key_gen
 (

input logic clk,nrst ,en ,gen_key,next_rnd,
input  aes_pkg:: aes_byte r_con_ctrl,r_con_i,
input  aes_pkg:: aes_128 key_i,
input  aes_pkg:: aes_32 Sub_i,
output aes_pkg:: aes_32 Sub_o,
output aes_pkg:: aes_128 key_o

);

aes_pkg:: key_128 word_rnd_in;
aes_pkg:: key_128 word_rnd_out;
aes_pkg:: aes_128 key_round;
aes_pkg:: aes_byte rcon_o; 
aes_pkg:: aes_32 xor_result; 



//Muxs
//first mux so we will use it's out
assign rcon_o  = gen_key ? r_con_ctrl : r_con_i;
//secound mux so we will use it's out
assign key_round  = next_rnd ? key_o : key_i;

assign word_rnd_in=key_round;

assign Sub_o =( word_rnd_in[3] << 8); // sub byte from s box 



always_comb
begin
xor_result=32'({rcon_o^Sub_i[0],Sub_i[1:3]});
word_rnd_out[0] = word_rnd_in[0] ^ (xor_result);//rcon from ctrl&sub_i from s_box
word_rnd_out[1] = word_rnd_in[1] ^ word_rnd_out[0];
word_rnd_out[2] = word_rnd_in[2] ^ word_rnd_out[1];
word_rnd_out[3] = word_rnd_in[3] ^ word_rnd_out[2];
end


/* key_gen pipeline*/
  aes_pipeline key_gen_pipe (
    .clk(clk),
    .nrst(nrst),
    .en(en),
    .input_i(word_rnd_out),
    .output_o(key_o)
);



endmodule

