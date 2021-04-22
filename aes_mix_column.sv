import aes_pkg::*;
module aes_mix_column(
	input aes_pkg::aes_128 state_i,
	output aes_pkg::aes_128 state_o);
for (genvar i = 0; i < 4; i++) begin
        aes_mix_single_column Ci(.state_i(state_i[4*i:(4*(i+1))-1]), .state_o(state_o[4*i:(4*(i+1))-1]));
    end

endmodule
