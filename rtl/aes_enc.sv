module aes_enc 
  import aes_pkg::aes_128, aes_pkg::shift_rows;
  (
    input clk, nrst, en,
    input aes_128 plain_text_i, mapped_i,
    input aes_128 key_i, rnd_key_i,
    // control signals
    input logic full_enc, zero_rnd, final_rnd,
    output aes_128 round_o, cipher_o
  );
  
  /* wires */
  aes_128 shifted_rows_i;       // input to mixcols and to the pipe
  aes_128 shifted_rows_o;       // output from mixcols_pipe_1
  aes_128 mixcols_o;            // output from mixcols_pipe_2

  aes_128 muxed_initial_final;  // output plain_text or shifted rows 
  aes_128 muxed_final_rnd;      // output shifted rows if final round
  aes_128 muxed_rnd_key;        // output initial key or key of rounds 1 to last round
  aes_128 round_key;            // output zero or round key to preform add round key operation

  assign shifted_rows_i = shift_rows(mapped_i);

  /* mixcols instantiation */

  /* ********************* */

  /* mixcols pipe */
  aes_pipeline mixcols_pipe_1 (
    .clk(clk),
    .nrst(nrst),
    .en(en),
    .input_i(shifted_rows_i),
    .output_o(shifted_rows_o)
  );

  /* mixcols_pipe_2 instantiation */

  /* **************************** */

  assign muxed_initial_final = full_enc ? plain_text_i : shifted_rows_o;
  assign muxed_final_rnd     = final_rnd? muxed_initial_final : mixcols_o;
  assign muxed_rnd_key       = zero_rnd ? key_i : rnd_key_i;
  assign round_key           = zero_rnd ? muxed_rnd_key : '0;

  // add round key
  assign add_key = muxed_final_rnd ^ round_key;

  /* add_key pipe */
  aes_pipeline addkey_pipe (
    .clk(clk),
    .nrst(nrst),
    .en(en),
    .input_i(add_key),
    .output_o(cipher_o)
  );

  // output to next round
  assign round_o = add_key;

endmodule
