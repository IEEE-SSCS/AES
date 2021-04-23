module aes_key_gen_TB;
int rnd_number;
logic clk,nrst ,en ,gen_key,next_rnd;
  aes_pkg:: ByteType r_con_ctrl;//,rcon_i;
  aes_pkg:: aes_128 key_i;
  aes_pkg::aes_word Sub_i;
 aes_pkg:: aes_word Sub_o;
 aes_pkg:: aes_128 key_o;
//int i;
aes_key_gen DUT(.clk(clk),.nrst(nrst),.en(en),.gen_key(gen_key),.next_rnd(next_rnd)
                ,.r_con_ctrl(r_con_ctrl),//.rcon_i(rcon_i)
                .key_i(key_i),.Sub_i(Sub_i),.Sub_o(Sub_o),.key_o(key_o),.rnd_number(rnd_number));

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
rnd_number=0;
gen_key=0;
 next_rnd=0;

key_i=128'h4c5d2f00 ;
//i=0 ;#10
//2nd clock cycle 
#10 Sub_i=32'h5c ;

//rnd_2 
//1st clk cycle 
 next_rnd=1;
rnd_number=1;
//2st clk cycle
Sub_i=32'h3d ;


//rnd_3 
//1st clk cycle 
//next_rnd=1;
//rcon_i=rcon_i*2;#10 
//2st clk cycle
#100 rnd_number=2;
 Sub_i=32'h5 ;
#100 rnd_number=3;
 Sub_i=32'h6 ;
#100 rnd_number=4;
 Sub_i=32'h6 ;
#100 rnd_number=5;
 Sub_i=32'h8 ;
#100 rnd_number=6;
 Sub_i=32'hef ;
#100 rnd_number=7;
 Sub_i=32'hef ;

#100 rnd_number=12;
      
 end
endmodule