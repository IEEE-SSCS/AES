module aes_mix_column_tb;
    timeunit 1ns;   //systemverilog equivalent for `timescale
    
    logic [0:15][7:0] state_i;
    logic [0:15][7:0] state_O;
    
    
    byte A[4], B[4] , C[4], D[4], E[4], F[4], G[4], H[4];

    import "DPI-C" function void mix_single_column( A[4],  E[4]);

    aes_mix_column c1(state_i,state_O);


  initial begin
	repeat(1000) begin  //generate 1000 stimuli
            foreach (A[i]) begin
                A[i] = $urandom();
                state_i[i] = A[i]; 
            end

            mix_single_column(A, B);

            #1 foreach (E[i]) begin
                check: assert(E[i] == state_o[i])   //check if refrence is equivalent to DUT
                    else $fatal("check failed: byte index = %d, A = %h, E = %h, state_o = %h", i, A[i], E[i], state_o[i]); //if not generate fatal error
               end
        
/*------------------------------------------------------------*/
 	    foreach (B[i]) begin
                B[i] = $urandom();
                state_i[i] = B[i]; 
            end
           	 mix_single_column(B, F);

            	#1 foreach (F[i]) begin
                check: assert(F[i] == state_o[i])   //check if refrence is equivalent to DUT
                    else $fatal("check failed: byte index = %d, B = %h, F = %h, state_o = %h", i, B[i], A[i], state_o[i]); //if not generate fatal error
            	   end
       			
/*--------------------------------------------------------------------*/
 		foreach (C[i]) begin
                C[i] = $urandom();
                state_i[i] = C[i]; 
            	end

            	mix_single_column(B, A);

            	#1 foreach (G[i]) begin
                check: assert(G[i] == state_o[i])   //check if refrence is equivalent to DUT
                    else $fatal("check failed: byte index = %d, C = %h, G = %h, state_o = %h", i, C[i], G[i], state_o[i]); //if not generate fatal error
            	   end
       
/*-----------------------------------------------------------------*/
 		foreach (D[i]) begin
                D[i] = $urandom();
                state_i[i] = D[i]; 
            	end

           	 mix_single_column(D, H);

            	#1 foreach (H[i]) begin
                check: assert(H[i] == state_o[i])   //check if refrence is equivalent to DUT
                    else $fatal("check failed: byte index = %d, D = %h, H = %h, state_o = %h", i, D[i], H[i], state_o[i]); //if not generate fatal error
           	   end
 	end
  end
endmodule 