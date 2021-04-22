import aes_pkg ::*;
module aes_mix_single_column(
    input aes_pkg::aes_32 state_i,

    output aes_pkg::aes_32 state_o
);

    aes_pkg::aes_32 x;
    aes_pkg::aes_32 mul;

    for (genvar i = 0; i < 3; i++)begin : gen_x
        assign x[i] = state_i[i] ^ state_i[i+1];
    end
    
    assign x[3] = state_i[3] ^ state_i[0];

    for (genvar i = 0; i < 4; i++) begin : gen_x_mul2
        assign mul[i] = aes_pkg::xtime(x[i]);
    end

    assign state_o[0] = mul[0] ^ x[2] ^ state_i[1];
    assign state_o[1] = mul[1] ^ x[2] ^ state_i[0];
    assign state_o[2] = mul[2] ^ x[0] ^ state_i[3];
    assign state_o[3] = mul[3] ^ x[0] ^ state_i[2]; 

endmodule : aes_mix_single_column
