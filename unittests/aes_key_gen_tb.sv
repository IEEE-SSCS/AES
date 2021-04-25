module aes_key_gen_TB;

logic clk,nrst ,en ,gen_key,next_rnd;

  aes_pkg:: aes_byte r_con_ctrl,r_con_i;
  aes_pkg:: key_128 key_i;
  aes_pkg::aes_32 sub_i;
  aes_pkg:: aes_32 sub_o;
  aes_pkg:: key_128 key_o;


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
key_i=128'h328c4fe405b593bc2010628c937b61e3
 ;
r_con_i=8'h01;
sub_i=32'hee3dbf60;
gen_key=0;
#100
next_rnd=1;
r_con_i=8'h02;
sub_i=32'h77dc66b3;
#100
r_con_i=8'h04;
sub_i=32'h34622654;
#100
r_con_i=8'h08;
sub_i=32'h20751700;
#100
r_con_i=8'h10;
sub_i=32'hde9addb5;
#100
r_con_i=8'h20;
sub_i=32'h4f06a5dc;
#100
r_con_i=8'h40;
sub_i=32'h37b92a5f;
#100
r_con_i=8'h80;
sub_i=32'h61e25ec1;
#100
r_con_i=8'h1b;
sub_i=32'h54ddc3db;
#100
r_con_i=8'h36;
sub_i=32'h6d947139;
 end
endmodule