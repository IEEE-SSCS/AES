module aes_key_gen
//import aes_pkg::key_128;
 (

input logic clk,nrst ,en ,gen_key,next_rnd,rnd_number,
input  aes_pkg:: ByteType r_con_ctrl,rcon_i,
input  aes_pkg:: key_128 key_i,
input  aes_pkg::aes_word Sub_i,
output aes_pkg:: aes_word Sub_o,
output aes_pkg:: key_128 key_o

);

//const aes_pkg:: ByteType = '{ 8'h01, 8'h02, 8'h04, 8'h08, 8'h10,8'h20, 8'h40, 8'h80, 8'h1B, 8'h36 };
aes_pkg:: key_128 word_rnd_in;
aes_pkg:: key_128 word_rnd_out;
aes_pkg:: key_128 key_round;
aes_pkg:: ByteType rcon_o; 
logic [3:0] i =0;


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
i=i+1;
word_rnd_out[0] = word_rnd_in[0] ^ (rcon_o[i]^Sub_i);
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

module aes_key_gen_TB();

aes_key_gen DUT(.clk(clk),.nsrt(nsrt),.en(en),.gen_key(gen_key),.next_rnd(next_rnd)
                ,.r_con_ctrl(r_con_ctrl),.rcon_i(rcon_i)
                ,.key_i(key_i),.Sub_i(Sub_i),.Sub_o(Sub_o),.key_o(key_o));

input logic clk,nrst ,en ,gen_key,next_rnd;
input logic [9:0] r_con_ctrl,rcon_i;
input  aes_pkg:: key_128 key_i;
input  aes_pkg::aes_word Sub_i;
output aes_pkg:: aes_word Sub_o;
output aes_pkg:: key_128 key_o;

intial
begin
forever 
  begin
    clk=1;#5
    clk=0;#5
  end
en=1;
nsrt=0;#10
nsrt=1;#10

//rnd_1 
//1st clk cycle 
next_rnd=0;
gen_key=0;
key_i=128'h
r_con_i=8'h01 ;#10
//2nd clock cycle 
sub_i=32'h ;#10

//rnd_2 
//1st clk cycle 
next_rnd=1;
r_con_i=r_con_i*2;#10 //for first 8 rounds r_con_i+1=r_con_i*2
//2st clk cycle
sub_i=32'h ;#10

//rnd_3 
//1st clk cycle 
next_rnd=1;
r_con_i=r_con_i*2;#10 
//2st clk cycle
sub_i=32'h ;#10

//rnd_4 
//1st clk cycle 
next_rnd=1;
r_con_i=r_con_i*2;#10 
//2st clk cycle
sub_i=32'h ;#10

//rnd_5 
//1st clk cycle 
next_rnd=1;
r_con_i=r_con_i*2;#10 
//2st clk cycle
sub_i=32'h ;#10

//rnd_6 
//1st clk cycle 
next_rnd=1;
r_con_i=r_con_i*2;#10 
//2st clk cycle
sub_i=32'h ;#10

//rnd_7 
//1st clk cycle 
next_rnd=1;
r_con_i=r_con_i*2;#10 
//2st clk cycle
sub_i=32'h ;#10

//rnd_8 
//1st clk cycle 
next_rnd=1;
r_con_i=r_con_i*2;#10 
//2st clk cycle
sub_i=32'h ;#10

//rnd_9
//1st clk cycle 
next_rnd=1;
r_con_i=8'h1B;#10 
//2st clk cycle
sub_i=32'h ;#10

//rnd_10 
//1st clk cycle 
next_rnd=1;
r_con_i=8'h36;#10 
//2st clk cycle
sub_i=32'h ;#10

end