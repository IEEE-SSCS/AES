module aes_sbox_lut(
    input aes_pkg::aes_128 data_i,
    input aes_pkg::aes_128 data_o
); 
    //generate 16 sboxes
    for(genvar i = 0; i < 16; i++) 
        aes_sub_byte_lut LUT(
            .data_i(data_i[i]), 
            .data_o(data_o[i])
        );
        
endmodule
