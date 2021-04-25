module aes_key_gen_TB;

logic clk,nrst ,en ,gen_key,next_rnd;

  aes_pkg:: aes_byte r_con_ctrl,r_con_i;
  aes_pkg:: aes_128 key_i;
  aes_pkg::aes_32 sub_i;
  aes_pkg:: aes_32 sub_o;
  aes_pkg:: aes_128 key_o;


aes_key_gen DUT(.clk(clk),.nrst(nrst),.en(en),.gen_key(gen_key),.next_rnd(next_rnd),
              .r_con_ctrl(r_con_ctrl),.key_i(key_i),.sub_i(sub_i),.sub_o(sub_o),.key_o(key_o),.r_con_i(r_con_i));

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
//1st cycle 
 next_rnd=0;
key_i=128'h4c5d2f00 ;
r_con_i=8'h01;
sub_i=32'h5c;
gen_key=0;
#1000



//2nd  cycle
 next_rnd=1; 
 r_con_i=8'h02;
 sub_i=32'h5d;

#1000
 r_con_i=8'h03;
 sub_i=32'h5f;
$stop;

 end
endmodule