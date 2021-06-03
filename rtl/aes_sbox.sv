module aes_sbox
    import  aes_pkg::aes_128,
            aes_pkg::aes_32;
    (
        input aes_128 in,
        input aes_32 key_in,
        input logic key_gen,
        output aes_128 out,
        output aes_32 key_out
    );
    aes_128 temp_in, temp_out;
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin
        aes_sub_byte g16 (
            .J(temp_in[i]),
            .Z(temp_out[i])
        );
        end 
    endgenerate

    always_comb begin
    	if (key_gen) begin
            temp_in[15] = key_in[3]; 
            temp_in[14] = key_in[2];
            temp_in[13] = key_in[1];
            temp_in[12] = key_in[0];
            temp_in [0:11] = in[0:11];

        	key_out[0]= temp_out [12];
        	key_out[1]= temp_out [13];
        	key_out[2]= temp_out [14];
        	key_out[3]= temp_out [15];
    	end 
    	else begin
            temp_in = in;
        	out = temp_out;    
    	end
    end         
 
endmodule 