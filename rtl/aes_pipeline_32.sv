module aes_pipeline_32(
    input clk, nrst, en, 
    input aes_pkg::aes_32 input_i,
    
    output aes_pkg::aes_32 output_o
);

    always @(posedge clk, negedge nrst) begin
        if (!nrst) output_o <= 128'h0;
        else begin
            if(en) output_o <= input_i;
            else output_o <= output_o;
        end
    end
    
endmodule
