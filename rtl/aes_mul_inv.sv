
module aes_mul_inv
    import aes_pkg::*;

 ( input logic  [7:0] x  , output  logic [7:0] y  );

  aes_nibble out_square ,out_lamdamul, out_xor ,out_xor1, out_mul_gf, out_inverse_x;


assign out_square=aes_pkg::square_nibble(x[7:4]);
assign out_lamdamul=aes_pkg::mul_lambda(out_square);
assign out_xor  =  x [3:0] ^ x[7:4];
aes_mul_gf4 mul1  (out_xor,x[7:4],out_mul_gf);
assign out_xor1 = out_mul_gf^ out_lamdamul;
assign out_inverse_x = invert_nibble(out_xor1);
aes_mul_gf4 mul2  (out_inverse_x,x[3:0],y[3:0]);
aes_mul_gf4 mul3  (out_inverse_x,x[7:4],y[7:4]);


endmodule
    