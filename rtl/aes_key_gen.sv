module aes_key_gen
//import aes_pkg::key_128;
 (

input logic clk,nrst ,en ,gen_key,next_rnd,
input logic [9:0] r_con_ctrl,rcon_i,
input  aes_pkg:: key_128 key_i,
input  aes_pkg::aes_word Sub_i,
output aes_pkg:: aes_word Sub_o,
output aes_pkg:: key_128 key_o

);

//const logic [9:0] rcon_i = '{ 8'h01, 8'h02, 8'h04, 8'h08, 8'h10,8'h20, 8'h40, 8'h80, 8'h1B, 8'h36 };
aes_pkg:: key_128 word_rnd_in;
aes_pkg:: key_128 word_rnd_out;
aes_pkg:: key_128 key_round;
logic [9:0] rcon_o; 



//Muxs
//first mux so we will use it's out
assign rcon_o  = gen_key ? r_con_ctrl : rcon_i;
//secound mux so we will use it's out
assign key_round  = next_rnd ? key_o : key_i;

/* key_gen pipeline*/
  aes_pipeline key_gen_pipe_1 (
    .clk(clk),
    .nrst(nrst),
    .en(en),
    .input_i(key_round),
    .output_o(word_rnd_in)
);

/*always @(posedge clk, negedge nrst)
	begin
	          if (!nrst)
	             begin
                        word_rnd_in[0] <= 0;	
			word_rnd_in[1] <= 0;
			word_rnd_in[2] <= 0;
		 	word_rnd_in[3] <= 0;
                       end
                 else
			word_rnd_in[0] <= key_round[0];	
			word_rnd_in[1] <= key_round[1];
			word_rnd_in[2] <= key_round[2];
			word_rnd_in[3] <= key_round[3];
		end*/

assign Sub_o =( word_rnd_in[3] << 8); // sub bye from s box 

always_comb
begin
word_rnd_out[0] = word_rnd_in[0] ^ (rcon_o^Sub_i);
word_rnd_out[1] = word_rnd_in[1] ^ word_rnd_out[0];
word_rnd_out[2] = word_rnd_in[2] ^ word_rnd_out[1];
word_rnd_out[3] = word_rnd_in[3] ^ word_rnd_out[2];

end
/* key_gen pipeline*/
  aes_pipeline key_gen_pipe_2 (
    .clk(clk),
    .nrst(nrst),
    .en(en),
    .input_i(word_rnd_out),
    .output_o(key_o)
);

/*always @(posedge clk, negedge nrst)
	begin
	          if (!nrst)
	             begin
                        key_o[0] <= 0;	
			key_o[1] <= 0;
			key_o[2] <= 0;
		 	key_o[3] <= 0;
                       end
                 else
			key_o[0] <= word_rnd_out[0];	
			key_o[1] <= word_rnd_out[1];
			key_o[2] <= word_rnd_out[2];
			key_o[3] <= word_rnd_out[3];
		end
*/
endmodule
