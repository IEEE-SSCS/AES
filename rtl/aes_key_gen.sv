module aes_key_gen
//import aes_pkg::key_128;
 (

input logic clk,nrst ,en ,gen_key,next_rnd,
input logic [9:0] r_con_ctrl,rcon_i,
input logic [0:3][31:0] key_i,
input logic [31:0] Sub_i,
output logic [31:0] Sub_o,
output logic [0:3][31:0] key_o

);

//const logic [9:0] rcon_i = '{ 8'h01, 8'h02, 8'h04, 8'h08, 8'h10,8'h20, 8'h40, 8'h80, 8'h1B, 8'h36 };
logic [0:3][31:0] word_rnd_in;
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

always @(posedge clk, negedge nrst)
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
		end

assign Sub_o =( word_rnd_in[3] << 8); // sub bye from s box 


endmodule
