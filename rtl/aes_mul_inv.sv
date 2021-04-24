module aes_mul_inv
    import aes_pkg::*;
    (
        input aes_byte x,
        output aes_byte y
    );
    aes_nibble g,e,yH,yL,out_square, out_lamdamul, out_xor, out_xor1, out_mul_gf, out_inverse_x;

    assign g = x [7:4];
    assign e = x [3:0];
    assign out_square = aes_pkg::square_nibble(g);
    assign out_lamdamul = aes_pkg::mul_lambda(out_square);
    assign out_xor = e ^ g;
    aes_mul_gf4 mul1  (out_xor, e, out_mul_gf);
    assign out_xor1 = out_mul_gf ^ out_lamdamul;
    assign out_inverse_x = invert_nibble(out_xor1);
    aes_mul_gf4 mul2  (out_inverse_x, g,yH);
    aes_mul_gf4 mul3  (out_inverse_x, out_xor, yL);
    assign y ={yH,yL};
endmodule
    