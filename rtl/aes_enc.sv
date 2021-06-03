module aes_enc(
    input clk, nrst, en,
    input aes_pkg::aes_128 plain_text_i, mapped_i,
    input aes_pkg::aes_128 key_i, rnd_key_i,
    // control signals
    input logic full_enc_ctrl, zero_rnd_ctrl, final_rnd_ctrl, key_sel_ctrl,
    output aes_pkg::aes_128 cipher_o
);
  
    /* wires */
    aes_pkg::aes_128 shifted_rows_o;       // output from shift rows operation
    aes_pkg::aes_128 mixcols_o;            // output from mixcols
 

    aes_pkg::aes_128 muxed_initial_final;  // output plain_text or shifted rows 
    aes_pkg::aes_128 muxed_final_rnd;      // output shifted rows if final round
    aes_pkg::aes_128 muxed_rnd_key;        // output initial key or key of rounds 1 to last round
    aes_pkg::aes_128 round_key;            // output zero or round key to preform add round key operation

    aes_pkg::aes_128 add_key;

    assign shifted_rows_o = aes_pkg::shift_rows(mapped_i);

  /* mixcols instantiation */
    aes_mix_column  aes_mixcols(
        .state_i(shifted_rows_o),
        .state_o(mixcols_o)
    );
  /* ********************* */

  assign muxed_initial_final = full_enc_ctrl ? plain_text_i : shifted_rows_o;
  assign muxed_final_rnd     = final_rnd_ctrl? muxed_initial_final : mixcols_o;
  assign muxed_rnd_key       = key_sel_ctrl  ? key_i : rnd_key_i;
  assign round_key           = zero_rnd_ctrl ? muxed_rnd_key : '0;

  // add round key
  assign add_key = muxed_final_rnd ^ round_key;

  /* add_key pipe */
  aes_pipeline addkey_pipe_2 (
    .clk(clk),
    .nrst(nrst),
    .en(en_rnd_i),
    .input_i(add_key),
    .output_o(cipher_o)
  );

endmodule
