module aes_ctrl (
    input logic clk, nrst, start_i,
    input aes_pkg::opcode opcode_i,
    output logic full_enc_o, zero_rnd_o, key_sel_o, final_rnd_o, // control signals to aes_enc
    output logic key_sub_o,                                      // control signal  to S_box
    output logic gen_key_o, r_con_ctrl_o, next_rnd_o,            // control signals to key_gen
    output logic cipher_ready_o, key_ready_o
);

    enum {start, s_box, round, finish} next_state, current_state;
    aes_pkg::opcode op_code;
    
    always_ff @(posedge clk, negedge nrst)
        begin
          if(!nrst)
            begin
              current_state <= start;
              op_code <= aes_pkg::NOOP;
            end
          else
            begin
              current_state <= next_state;
              if(start_i)
                op_code <= opcode_i;
              else
                op_code <= aes_pkg::NOOP;
            end
        end

    // next_state logic and set outputs
    always_comb
        begin
          next_state = current_state; // default
          unique case (current_state)
              start:
                begin
                  cipher_ready_o = 0;
                  key_ready_o    = 0;
                  full_enc_o     = 1;
                  final_rnd_o    = 1;
                  zero_rnd_o     = 0;
                  key_sel_o      = 0;
                  next_rnd_o     = 0;
                  gen_key_o      = 0;
                  key_sub_o      = 0;
                  if (start_i)
                    begin
                      unique case (opcode_i)
                        aes_pkg::NOOP: next_state = current_state;
                        
                        aes_pkg::AESENC, aes_pkg::AESENCLAST:
                          begin
                            full_enc_o  = 1;
                            final_rnd_o = 1;
                            zero_rnd_o  = 0;
                            key_sel_o   = 0;
                            next_rnd_o  = 0;
                            gen_key_o   = 0;
                            next_state  = s_box;
                          end
                        
                        //AESENCFULL:
                          
                        aes_pkg::AESKEYGENASSIST:
                          begin
                            next_rnd_o  = 0;
                            gen_key_o   = 0;
                            key_sub_o   = 1;
                            next_state  = round;
                          end
                        
                        //default:
                        
                      endcase
                    end
                  else
                    next_state = current_state;
                end
                
                  
              s_box:
                begin
                  unique case (op_code)
                        aes_pkg::AESENC, aes_pkg::AESENCLAST:
                          begin
                            key_sub_o   = 0;
                            gen_key_o   = 0;
                            next_state  = round;
                          end
                        /*
                        AESENCFULL: 
                        
                        default:
                        */
                  endcase 
                end
            
              round:
                begin
                  unique case (op_code)
                        aes_pkg::AESENC:
                          begin
                            full_enc_o  = 1;
                            final_rnd_o = 0;
                            zero_rnd_o  = 1;
                            key_sel_o   = 0;
                            next_state  = finish;
                          end
                          
                        aes_pkg::AESENCLAST:
                          begin
                            full_enc_o  = 0;
                            final_rnd_o = 1;
                            zero_rnd_o  = 1;
                            key_sel_o   = 0;
                            next_state  = finish;
                          end
                        
                        //AESENCFULL:
                          
                        aes_pkg::AESKEYGENASSIST:
                          begin
                            gen_key_o   = 0;
                            next_state  = finish;
                          end
                        
                        //default:
                        
                  endcase
                end
                
             finish:
                begin
                  unique case (op_code)
                      aes_pkg::AESKEYGENASSIST:
                        begin
                          key_ready_o    = 1;
                        end
                        
                      default:
                        begin
                          cipher_ready_o = 1;
                        end     
                         
                  endcase
                  
                  next_state = start;
                        
                end
          endcase
        end
endmodule
