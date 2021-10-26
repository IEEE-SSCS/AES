module aes_top(
    input logic clk, nrst,
//control out signals
    input  aes_pkg::opcode opcode_i,
    input  logic start_i,
    //input  logic en_i,
    output logic key_ready_o,
    output logic cipher_ready_o,
    output logic busy_o,

//key_gen signals
    input aes_pkg:: aes_128 key_i,
    input aes_pkg:: aes_byte r_con_i,

//aes_enc signals
    input aes_pkg:: aes_128 plain_text_i,
    output aes_pkg:: aes_128 cipher_o
);

//control wires
//control singals for aes_key_gen
    aes_pkg::aes_32 r_con_ctrl;
    logic gen_key_ctrl;
    logic next_rnd_ctrl;
    logic en_key_o;
//control signals for aes_enc
    logic full_enc_ctrl;
    logic zero_rnd_ctrl;
    logic final_rnd_ctrl;
    logic key_sel_ctrl;
    logic en_rnd_o;
//control signals for aes_sbox
    logic key_sub_ctrl;

    aes_ctrl ctrl(
        .clk            (clk), 
        .nrst           (nrst), 
        .start_i        (start_i),
        .opcode_i       (opcode_i),
        // control signals to aes_enc
        .full_enc_o     (full_enc_ctrl), 
        .zero_rnd_o     (zero_rnd_ctrl), 
        .key_sel_o      (key_sel_ctrl), 
        .final_rnd_o    (final_rnd_ctrl), 
        .en_rnd_o       (en_rnd_o),
        // control signal to S_box 
        .key_sub_o      (key_sub_ctrl), 
        .en_key_o       (en_key_o),  
        // control signals to key_gen                                    
        .gen_key_o      (gen_key_ctrl), 
        .next_rnd_o     (next_rnd_ctrl),                                    
        .cipher_ready_o (cipher_ready_o), 
        .key_ready_o    (key_ready_o), 
        .busy_o         (busy_o),
        .r_con_ctrl_o   (r_con_ctrl)
    );

//key_gen instantiate
    aes_pkg::aes_128 key_o;
    aes_pkg::aes_32  sub_i;
    aes_pkg::aes_32  sub_o;

    aes_key_gen key_gen(
        .clk            (clk),
        .nrst           (nrst),
        .en             (en_key_o),
        .gen_key        (gen_key_ctrl),
        .next_rnd       (next_rnd_ctrl),
        .r_con_ctrl     (r_con_ctrl),
        .r_con_i        (r_con_i),
        .key_i          (key_i),
        .key_o          (key_o),
        .sub_i          (sub_i),
        .sub_o          (sub_o)
    );

//s_byte instantiate 
    aes_pkg::aes_128 sbox_out;
    aes_pkg::aes_32  key_out;
    aes_pkg::aes_128 sbox_out_q;
    aes_pkg::aes_32  key_out_q;
    aes_pkg::aes_128 mapped_i;

    assign mapped_i = sbox_out_q;
    assign sub_i    = key_out_q;

    aes_sbox sbox(
        .in             (cipher_o),
        .key_in         (sub_o),
        .key_gen        (key_sub_ctrl),
        .out            (sbox_out),
        .key_out        (key_out)
    );

    logic en_i;
    assign en_i = start_i;

    aes_pipeline sbox_pipe(
        .clk            (clk),
        .nrst           (nrst),
        .en             (1'b1),
        .input_i        (sbox_out),
        .output_o       (sbox_out_q)
    );

    aes_pipeline_32 sbox_pipe_32(
        .clk            (clk),
        .nrst           (nrst),
        .en             (1'b1),
        .input_i        (key_out),
        .output_o       (key_out_q)
    );

//enc instantiate 
    aes_enc enc(
        .clk            (clk),
        .nrst           (nrst),
        .en             (en_rnd_o),
        .plain_text_i   (plain_text_i),
        .mapped_i       (mapped_i),
        .key_i          (key_i),
        .rnd_key_i      (key_o),
        .full_enc_ctrl  (full_enc_ctrl),
        .zero_rnd_ctrl  (zero_rnd_ctrl),
        .final_rnd_ctrl (final_rnd_ctrl),
        .key_sel_ctrl   (key_sel_ctrl),
        .cipher_o       (cipher_o)
    );
endmodule
