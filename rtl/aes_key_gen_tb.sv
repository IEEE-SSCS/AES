module aes_key_gen_TB;
logic clk,nrst ,en ,gen_key,next_rnd;
  aes_pkg:: ByteType r_con_ctrl;//,rcon_i;
  aes_pkg:: key_128 key_i;
  aes_pkg::aes_word Sub_i;
 aes_pkg:: aes_word Sub_o;
 aes_pkg:: key_128 key_o;
//int i;
aes_key_gen DUT(.clk(clk),.nrst(nrst),.en(en),.gen_key(gen_key),.next_rnd(next_rnd)
                ,.r_con_ctrl(r_con_ctrl),//.rcon_i(rcon_i)
                .key_i(key_i),.Sub_i(Sub_i),.Sub_o(Sub_o),.key_o(key_o));

initial
begin
clk =0;
forever #50 clk=~clk;
end
initial
begin
en=1;
#10 nrst=0;
#10 nrst=1;
//rnd_1 
//1st clk cycle 
#10 next_rnd=0;
gen_key=0;
key_i=128'h4c5d2f00 ;
//i=0 ;#10
//2nd clock cycle 
#10 Sub_i=32'h5c ;

//rnd_2 
//1st clk cycle 
#1000 next_rnd=1;
//i=1; //for first 8 rounds rcon_i+1=rcon_i*2
//2st clk cycle
Sub_i=32'h3d ;


//rnd_3 
//1st clk cycle 
//next_rnd=1;
//rcon_i=rcon_i*2;#10 
//2st clk cycle
#100 Sub_i=32'h5 ;
#100 Sub_i=32'h6 ;
#100 Sub_i=32'h6 ;
#100 Sub_i=32'h8 ;
#100 Sub_i=32'h11 ;
#100 Sub_i=32'h66 ;
#100 Sub_i=32'h44 ;
#100 Sub_i=32'h667 ;
#100 Sub_i=32'hef ;

 end
endmodule
