module aes_mix_column_tb;
    timeunit 1ns;   //systemverilog equivalent for `timescale
    
    logic [0:15][7:0] state_i;
    logic [0:15][7:0] state_o;
    
    
    byte A[16], B[16];

    import "DPI-C" function void mix_single_column(input byte in[4],  output byte out[4]);

    aes_mix_column c1(
        .state_i(state_i),
        .state_o(state_o)
    );


initial begin
	repeat(1000) begin  //generate 1000 stimuli
            foreach (A[i]) begin
                A[i] = $urandom();
                state_i[i] = A[i]; 
            end

            mix_single_column(A[0:3],   B[0:3]);
            mix_single_column(A[4:7],   B[4:7]);
            mix_single_column(A[8:11],  B[8:11]);
            mix_single_column(A[12:15], B[12:15]);

            #1 foreach (B[i]) begin
                check: assert(B[i] == state_o[i])   //check if refrence is equivalent to DUT
                    else $fatal("check failed: byte index = %d, A = %h, E = %h, state_o = %h", i, A[i], E[i], state_o[i]); //if not generate fatal error
               end
        
 	end
end
endmodule 