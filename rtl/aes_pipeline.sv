module aes_pipeline(
    input clk, nrst, en, 
    input aes_pkg::aes_128 input_i,
    
    output aes_pkg::aes_128 output_o
);

    always @(posedge clk, negedge nrst) begin
        if (!nrst) output_o <= 128'h0;
        else begin
            if(en) output_o <= input_i;
            else output_o <= output_o;
        end
    end
    
endmodule
