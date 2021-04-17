package aes_pkg;
    typedef enum logic [2:0] {NOOP, AESENCFULL, AESENC, AESENCLAST, AESKEYGENASSIST, 
        AESDEC, AESDECLAST, AESIMC} opcode;

    typedef logic [0:15][7:0] aes_128;
    typedef logic [0:23][7:0] aes_192;
    typedef logic [0:31][7:0] aes_256;
    typedef logic [0:3][7:0]  aes_32;

    typedef logic [7:0] aes_byte;
    typedef logic [3:0] aes_nibble;
    typedef logic [1:0] aes_half_nibble;
    
    function automatic aes_byte xtime(aes_byte in);
        aes_byte out;
        out[7] = in[6];
        out[6] = in[5];
        out[5] = in[4];
        out[4] = in[3] ^ in[7];
        out[3] = in[2] ^ in[7];
        out[2] = in[1];
        out[1] = in[0] ^ in[7];
        out[0] = in[7];
        return out;
    endfunction : xtime

    /*GF(2^2) FIELD FUNCTIONS*/
    function automatic aes_half_nibble mul_phi(aes_half_nibble in);
        aes_half_nibble out;
        out[1] = in[0] ^ in[1];
        out[0] = in[1];
        return out;
    endfunction : mul_phi

    function automatic aes_half_nibble mul_gf2(aes_half_nibble in1, aes_half_nibble in2);
        aes_half_nibble out;
        logic [4:0] temp;
        temp[0] = in1[0] ^ in1[1];
        temp[1] = in2[0] ^ in2[1];
        
        temp[2] = in1[1]  & in2[1];
        temp[3] = temp[0] & temp[1];
        temp[4] = in1[0]  & in2[0];

        out[1] = temp[3] ^ temp[4];
        out[0] = temp[2] ^ temp[4];
        return out;
    endfunction : mul_gf2

    /*GF(2^4) FIELD FUNCTIONS*/
    function automatic aes_nibble mul_lambda(aes_nibble in);
        aes_nibble out;
        out[0] = in[3] ^ in[2];
        out[1] = in[2];
        out[2] = in[3] ^ in[1];
        out[3] = out[0] ^ in[1] ^ in[0];
        return out;
    endfunction : mul_lambda

    function automatic aes_nibble square_nibble(aes_nibble in);
        aes_nibble out;
        out[3] = in[3];
        out[2] = in[3] ^ in[2];
        out[1] = in[2] ^ in[1];
        out[0] = in[3] ^ in[1] ^ in[0];
        return out;
    endfunction : square_nibble

    function automatic aes_nibble invert_nibble(aes_nibble in);
        aes_nibble out;
        aes_byte temp;
        temp[0] = in[3] & in[0]; //30
        temp[1] = in[2] & in[1]; //21
        temp[2] = in[2] & in[0]; //20
        temp[3] = in[3] & in[1]; //31
        temp[4] = in[3] & temp[1]; //321
        temp[5] = in[3] & temp[2]; //320
        temp[6] = in[1] & temp[0]; //310
        temp[7] = in[0] & temp[1]; //210

        out[3] = in[3]   ^ temp[4] ^ temp[0] ^ in[2];
        out[2] = temp[4] ^ temp[5] ^ temp[0] ^ in[2]   ^ temp[1];
        out[1] = in[3]   ^ temp[4] ^ temp[6] ^ in[2]   ^ temp[2] ^ in[1];
        out[0] = temp[4] ^ temp[5] ^ temp[3] ^ temp[6] ^ 
                 temp[0] ^ in[2]   ^ temp[1] ^ temp[7] ^ in[1]   ^ in[0];
        return out;
    endfunction : invert_nibble

    /*ISOMORPHISM FUNCTIONS*/
    function automatic aes_byte isomorph(aes_byte in);
        aes_byte out;
        out[0] = in[0] ^ in[2];
        out[1] = in[1] ^ in[6] ^ in[7];
        out[2] = in[2] ^ in[3] ^ in[5] ^ in[7];
        out[3] = in[2] ^ in[5];
        out[4] = in[1] ^ in[3] ^ in[6] ^ in[7];
        out[5] = in[1] ^ in[4] ^ in[5] ^ in[6];
        out[6] = in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6];
        out[7] = in[5] ^ in[7];
        return out;
    endfunction : isomorph 

    function automatic aes_byte inv_isomorph(aes_byte in);
        aes_byte out;
        out[0] = in[0] ^ in[1] ^ in[3] ^ in[5] ^ in[6];
        out[1] = in[4] ^ in[7];
        out[2] = in[1] ^ in[3] ^ in[5] ^ in[7];
        out[3] = in[1] ^ in[3];
        out[4] = in[1] ^ in[5] ^ in[7];
        out[5] = in[1] ^ in[2] ^ in[3] ^ in[5] ^ in[6];
        out[6] = in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6];
        out[7] = in[1] ^ in[2] ^ in[3] ^ in[5] ^ in[6] ^ in[7];
        return out;
    endfunction : inv_isomorph

    /*AFFINE TRANSFORMATION FUNCTIONS*/
    function automatic aes_byte affine(aes_byte in);
        aes_byte out;
        aes_nibble temp;
        temp[0] = in[6] ^ in[7];
        temp[1] = in[0] ^ in[1];
        temp[2] = in[2] ^ in[3];
        temp[3] = in[4] ^ in[5];

        out[0] = in[0]   ^ temp[3] ^ temp[0] ^ 1'b1;
        out[1] = temp[1] ^ in[5]   ^ temp[0] ^ 1'b1;
        out[2] = temp[1] ^ in[2]   ^ temp[0];
        out[3] = temp[1] ^ temp[2] ^ in[7];
        out[4] = temp[1] ^ temp[2] ^ in[4];
        out[5] = in[1]   ^ temp[2] ^ temp[3] ^ 1'b1;
        out[6] = temp[2] ^ temp[3] ^ in[6]   ^ 1'b1;
        out[7] = in[3]   ^ temp[3] ^ temp[0];
        return out;
    endfunction : affine

    function automatic aes_byte inv_affine(aes_byte in);
        aes_byte out;
        out[0] = in[2] ^ in[5] ^ in[7] ^ 1'b1;
        out[1] = in[0] ^ in[3] ^ in[6];
        out[2] = in[1] ^ in[4] ^ in[7] ^ 1'b1;
        out[3] = in[0] ^ in[2] ^ in[5];
        out[4] = in[1] ^ in[3] ^ in[6];
        out[5] = in[2] ^ in[4] ^ in[7];
        out[6] = in[0] ^ in[3] ^ in[5];
        out[7] = in[1] ^ in[4] ^ in[6];
        return out;
    endfunction : inv_affine

endpackage : aes_pkg