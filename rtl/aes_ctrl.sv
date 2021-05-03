module aes_ctrl (
    input logic clk, nrst, start_i,
    input aes_pkg::opcode opcode_i,
    output logic full_enc_o, zero_rnd_o, key_sel_o, final_rnd_o, en_rnd_o, // control signals to aes_enc
    output logic key_sub_o, en_key_o,                                      // control signal  to S_box
    output logic gen_key_o, next_rnd_o,                                    // control signals to key_gen
    output logic cipher_ready_o, key_ready_o, busy_o,
    output aes_pkg::aes_32 r_con_ctrl_o
);

    enum logic [1:0] {start  = 2'b00,
                      s_box  = 2'b01,
                      round  = 2'b11,
                      finish = 2'b10} next_state, current_state;
                      
    aes_pkg::opcode op_code;
    logic[3:0] rnd_num, next_num;
    aes_pkg::aes_byte r_con_temp;
    
    // Flip Flops (states - counter - opcode value - round constant)
    always_ff @(posedge clk, negedge nrst)
        begin
          if(!nrst)
            begin
              current_state <= start;
              op_code <= aes_pkg::NOOP;
              rnd_num <= 4'b0;
              r_con_ctrl_o [3] <= 8'h01;
              r_con_ctrl_o[0:2] <= 24'b0;

            end
          else
            begin
              current_state <= next_state;
              rnd_num <= next_num;
              r_con_ctrl_o [3] <= r_con_temp;
              if(start_i)
                op_code <= opcode_i;
              else
                op_code <= op_code;
            end
        end

    // next_state logic and setting outputs
    always_comb
        begin
          // default next state and outputs values
          next_state      = current_state;
          next_num        = rnd_num;
          r_con_temp      = r_con_ctrl_o[3];
          cipher_ready_o  = 0;
          key_ready_o     = 0;
          full_enc_o      = 1;
          final_rnd_o     = 1;
          zero_rnd_o      = 0;
          key_sel_o       = 0;
          next_rnd_o      = 0;
          gen_key_o       = 0;
          key_sub_o       = 0;
          en_rnd_o        = 1;
          en_key_o        = 1;
          busy_o          = 1;
          unique case (current_state)
              start:
                begin
                  if (start_i)
                    begin
                      unique case (opcode_i)
                        aes_pkg::NOOP: next_state = current_state;

                        aes_pkg::AESENC, aes_pkg::AESENCLAST:
                          begin
                            en_key_o    = 0; // disable aes_enc module piplines
                            full_enc_o  = 1;
                            final_rnd_o = 1;
                            zero_rnd_o  = 0;
                            key_sel_o   = 0;
                            next_state  = s_box;
                          end
                        aes_pkg::AESKEYGENASSIST:
                          begin
                            en_rnd_o    = 0; // disable key_gen module piplines
                            next_rnd_o  = 0;
                            gen_key_o   = 0;
                            key_sub_o   = 1;
                            next_state  = round;
                          end
                        aes_pkg::AESENCFULL:
                          begin
                            next_num    = 0;
                            r_con_temp  = 8'h01;
                            full_enc_o  = 1;
                            final_rnd_o = 1;
                            zero_rnd_o  = 1;
                            key_sel_o   = 1;
                            next_rnd_o  = 0;
                            key_sub_o   = 1;
                            next_state  = s_box;
                          end
                      endcase
                    end
                  else
                    begin
                        busy_o = 0;
                        next_state = current_state;
                    end
                end


              s_box:
                begin
                  unique case (op_code)
                        aes_pkg::AESENC, aes_pkg::AESENCLAST:
                          begin
                            key_sub_o   = 0;
                            next_state  = round;
                          end
                        aes_pkg::AESENCFULL:
                          begin
                            next_num     = rnd_num + 1;
                            key_sub_o    = 0;
                            gen_key_o    = 1;
                            next_rnd_o   = 0;
                            next_state   = round;
                          end

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
                            key_sel_o   = 1;
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
                        aes_pkg::AESKEYGENASSIST:
                          begin
                            gen_key_o   = 0;
                            next_state  = finish;
                          end
                        aes_pkg::AESENCFULL:
                          begin
                            full_enc_o  = 0;
                            zero_rnd_o  = 1;
                            key_sel_o   = 0;
                            key_sub_o   = 1;
                            next_rnd_o  = 1;

                            if (r_con_temp == 8'h80) begin
                              r_con_temp = 8'h1b ;
                            end
                            else
                              begin
                                r_con_temp = r_con_temp << 1;
                              end

                            if (rnd_num == 4'b1010) begin    //check the last round
                              final_rnd_o = 1;
                              next_state  = finish;
                            end
                            else begin
                              final_rnd_o = 0;
                              next_state  = s_box;
                            end
                          end
                  endcase
                end

             finish:
                begin
                  busy_o = 0;
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
             default: next_state = start;
          endcase
        end
endmodule
