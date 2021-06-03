module aes_sub_byte
    import aes_pkg::isomorph,
           aes_pkg::inv_isomorph,
           aes_pkg::aes_byte,
           aes_pkg::affine;
    ( 
        input aes_byte J,
        output aes_byte Z
    );

    aes_byte in1,out1,in2,out2,in3,out3,in4,out4;
    assign in1 = J;
    assign out1 = isomorph(in1);
    assign in2 = out1;
    aes_mul_inv a1(in2,out2);
    assign in3 = out2;
    assign out3 = inv_isomorph(in3);
    assign in4 = out3;
    assign  out4 = affine(in4);
    assign  Z = out4;
endmodule 