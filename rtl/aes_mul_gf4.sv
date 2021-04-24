module aes_mul_gf4
  import aes_pkg::aes_half_nibble,
    aes_pkg::aes_nibble,
    aes_pkg::mul_phi,
    aes_pkg::mul_gf2;
  ( 
    input  aes_nibble q, w,
    output aes_nibble k
  );
  aes_half_nibble qH,qL,wH,wL,kH,kL;
  assign qH = q [3:2];
  assign qL = q [1:0];
  assign wH = w [3:2];
  assign wL = w [1:0];


  aes_half_nibble in1,in2,in3,in4,in5,in6;      // inputs to mul_gf2
  aes_half_nibble out1,out2,out3;               // outputs from mul_gf2
  aes_half_nibble phi_out;                      // output from mul_phi

  assign in1 = qH;
  assign in2 = wH;
  assign out1 = mul_gf2(in1, in2);

  assign in3 = qH ^ qL;
  assign in4 = wH ^ wL;
  assign out2 = mul_gf2(in3, in4);

  assign in5 = qL;
  assign in6 = wL;
  assign out3 = mul_gf2(in5, in6);

  assign phi_out = mul_phi(out1);

  assign kH = out2 ^ out3 ;
  assign kL = out3 ^ phi_out;
  assign k ={kH,kL};

endmodule