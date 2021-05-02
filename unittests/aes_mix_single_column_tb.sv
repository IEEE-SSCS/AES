
module aes_mix_single_column_tb;
    timeunit 1ns;   //systemverilog equivalent for `timescale
    
    logic [0:3][7:0] state_i;
    logic [0:3][7:0] state_o;
    byte B[4], A[4];

    import "DPI-C" function void mix_single_column(input byte B[4], output byte A[4]);

    aes_mix_single_column DUT(
        .state_i(state_i),
        .state_o(state_o)
    );

    initial begin
        repeat(1000) begin  //generate 1000 stimuli
            foreach (B[i]) begin
                B[i] = $urandom();
                state_i[i] = B[i]; 
            end

            mix_single_column(B, A);

            #1 foreach (A[i]) begin
                check: assert(A[i] == state_o[i])   //check if refrence is equivalent to DUT
                    else $fatal("check failed: byte index = %d, B = %h, A = %h, state_o = %h", i, B[i], A[i], state_o[i]); //if not generate fatal error
            end
        end

        $stop;
    end
  
endmodule
