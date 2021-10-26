/*
data_i   = {8'h6b, 8'hc1, 8'hbe, 8'he2, 8'h2e, 8'h40, 8'h9f, 8'h96, 8'he9, 8'h3d, 8'h7e, 8'h11, 8'h73, 8'h93, 8'h17, 8'h2a};
key_i    = {8'h2b, 8'h7e, 8'h15, 8'h16, 8'h28, 8'hae, 8'hd2, 8'ha6, 8'hab, 8'hf7, 8'h15, 8'h88, 8'h09, 8'hcf, 8'h4f, 8'h3c};
cipher_o = {8'h3a, 8'hd7, 8'h7b, 8'hb4, 8'h0d, 8'h7a, 8'h36, 8'h60, 8'ha8, 8'h9e, 8'hca, 8'hf3, 8'h24, 8'h66, 8'hef, 8'h97};
*/

module aes_top_tb;
    timeunit 1ns;
	
    logic clk, nrst;
//control out signals
    aes_pkg::opcode opcode_i;
    logic start_i;
    //input  logic en_i;
    logic key_ready_o;
    logic cipher_ready_o;
    logic busy_o;

//key_gen signals
    aes_pkg::aes_128 key_i;
    aes_pkg::aes_byte r_con_i;

//aes_enc signals
    aes_pkg::aes_128 plain_text_i;
    aes_pkg::aes_128 cipher_o;

    aes_top DUT (.*);

    assign r_con_i      = 0;
    assign opcode_i     = aes_pkg::AESENCFULL;
	assign plain_text_i = {8'h6b, 8'hc1, 8'hbe, 8'he2, 8'h2e, 8'h40, 8'h9f, 8'h96, 8'he9, 8'h3d, 8'h7e, 8'h11, 8'h73, 8'h93, 8'h17, 8'h2a};
	assign key_i        = {8'h2b, 8'h7e, 8'h15, 8'h16, 8'h28, 8'hae, 8'hd2, 8'ha6, 8'hab, 8'hf7, 8'h15, 8'h88, 8'h09, 8'hcf, 8'h4f, 8'h3c};
    assign cipher_tst   = {8'h3a, 8'hd7, 8'h7b, 8'hb4, 8'h0d, 8'h7a, 8'h36, 8'h60, 8'ha8, 8'h9e, 8'hca, 8'hf3, 8'h24, 8'h66, 8'hef, 8'h97};
    
    initial begin
        fork
            begin
                nrst = 0;
                start_i = 0;
                #10
                nrst = 1;
                start_i = 1;
                #50
                start_i = 0;
            end
            begin
                clk = 0;
                forever begin
                    #10 clk = ~clk;
                end
            end
        join_none
    end

    property pr1;
        @(posedge clk) cipher_ready_o |-> (cipher_o == cipher_tst);
    endproperty 

    equality_assert: assert property (pr1)
        else $display($stime,,,"\t\t %m FAIL"); 
    equality_cover: cover property (pr1)  $display($stime,,,"\t\t %m PASS");

    always @(posedge cipher_ready_o) begin
		#1;
        check: assert (cipher_o == cipher_tst)
            else $error("Assertion check failed!");
    end
endmodule
