module aes_key_gen
//import aes_pkg::key_128;
 (

input logic clk,nrst,en,gen_key,next_rnd,
input logic [9:0] r_con_ctrl,rcon_i,
input [0:3][31:0] key_i,
input logic [31:0] Sub_i,
output logic [31:0] Sub_o,
output logic [0:3][31:0] key_o

);

//const logic [9:0] rcon_i = '{ 8'h01, 8'h02, 8'h04, 8'h08, 8'h10,8'h20, 8'h40, 8'h80, 8'h1B, 8'h36 };
logic [0:3][31:0] word_rnd_in;
logic [0:3][31:0] word_rnd_out;
logic [0:3][31:0] key_round;
logic [9:0] rcon_o; 


always_comb begin //first mux so we will use it's out
        unique case(gen_key)
            0: rcon_o  = rcon_i;
            1: rcon_o  = r_con_ctrl;
           
            default: rcon_o = rcon_i;
        endcase
end
always_comb //secound mux so we will use it's out
begin
        unique case(next_rnd)
            0: key_round  = key_i;
            1: key_round  = key_o;
           
            default: key_round = key_i;
        endcase
end

aes_pipeline word_rnd_in_pipe (.clk(clk),.nrst(nrst),.en(en),.input_i(key_round),.output_o(word_rnd_in));

assign Sub_o =( word_rnd_in[3] << 8); // sub bye from s box 

always_comb
begin
word_rnd_out[0] = word_rnd_in[0] ^ (rcon_o^Sub_i);
word_rnd_out[1] = word_rnd_in[1] ^ word_rnd_out[0];
word_rnd_out[2] = word_rnd_in[2] ^ word_rnd_out[1];
word_rnd_out[3] = word_rnd_in[3] ^ word_rnd_out[2];
end

aes_pipeline o_key_pipe (.clk(clk),.nrst(nrst),.en(en),.input_i(word_rnd_out),.output_o(key_o));

endmodule
module aes_pipeline(
    input clk, nrst, en, 
    input aes_pkg::aes_128 input_i,
    
    output aes_pkg::aes_128 output_o
);

    always @(posedge clk, negedge nrst) begin
        if (!nrst) output_o <= 128'h0;
        else begin
            if(en) output_o <= input_i;
            else output_o <= output_o;
        end
    end
 endmodule   
