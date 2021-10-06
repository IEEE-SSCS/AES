`include "uvm_macros.svh"
`include "seq item.sv"
`include "fill.svh"
import uvm_pkg::*;
class scoreboard extends uvm_subscriber  #(aes_transaction);
   `uvm_component_utils(scoreboard);
  fill fill;

        uvm_analysis_export #(aes_transaction) export_before;
	uvm_analysis_export #(aes_transaction) export_after;

	uvm_tlm_analysis_fifo #(aes_transaction) before_fifo;
	uvm_tlm_analysis_fifo #(aes_transaction) after_fifo;

   
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
    before_fifo = new ("before_fifo", this);
    after_fifo = new ("after_fifo", this);
   endfunction : build_phase

    function void connect_phase(uvm_phase phase);
	export_before.connect(before_fifo.analysis_export);
	export_after.connect(after_fifo.analysis_export);
    endfunction:connect_phase

   parameter N=99;
   bit[127:0] ct_mc[99:0],pt_mc[99:0],k_mc[99:0];
   bit[127:0] ct_mm[9:0],pt_mm[9:0],k_mm[9:0];
   //function to scan the test vectors
   function void read_file(string location,bit[127:0] ct[int],pt[int],k[int]);
      int c,fd,m;
      fd = $fopen(location,"r");
       while(!$feof(fd))
         begin
          m=$fscanf(fd,"COUNT = %d\n",c);
          m=$fscanf(fd,"KEY = %h\n",k[c]);
          m=$fscanf(fd,"PLAINTEXT = %h\n",pt[c]);
          m=$fscanf(fd,"CIPHERTEXT = %h\n\n",ct[c]);
         $display(" %d\n %h\n %h\n %h",c,k[c],pt[c],ct[c]);
         end
   endfunction
//function to extract the result from the test vectors
function  predict_result(aes_transaction cmd);
   bit[127:0] ct_mc[int];
   bit[127:0]k_mc[int];
   bit[127:0]pt_mc[int];
   bit[1279:0] ct_mmt[int];
   bit[127:0] k_mmt[int];
   bit[1279:0] pt_mmt[int];
   bit[127:0] predicted;
   bit[127:0] predicted_mmt;
   int l[9:0];
   int s [$];
   int w [$];
     fill.fill();
      if(cmd.opcode_i==AESENCFULL)
    begin
    if(cmd.key_i==0)
    predicted=fill.katvt[cmd.plain_text_i];
	 else if(cmd.plain_text_i==0)
	 predicted=fill.katvk[cmd.key_i];
	 else
	 begin
	 read_file("ECBMCT128.txt",ct_mc,pt_mc,k_mc);
         s= pt_mc.find_index with (item==cmd.plain_text_i);
         w= k_mc.find_index with (item==cmd.key_i);   
	 if(pt_mc.exists(s)&&k_mc.exists(w))
	  begin
     predicted=ct_mc[s];
     compare(cmd,predicted);
      end
       else
       begin
          read_file_mmt("ECBMMT128.txt",ct_mmt,pt_mmt,k_mmt,l);
               for (int i =0;i<10;i++ ) begin
                  if (cmd.plain_text_i==pt_mmt[i][127:0]&&cmd.key_i==k_mmt)
                   begin
                  for (int j =0; j<l[i]+1; j++ ) begin
                     int q;
                     q=j+1;
                     if (j==0) begin
                        predicted_mmt=ct_mmt[l[i]][127:0];   
                     end
                     if (j==1) begin
                        predicted_mmt=ct_mmt[l[i]][255:128];   
                     end
                     if (j==2) begin
                        predicted_mmt=ct_mmt[l[i]][383:256];   
                     end
                     if (j==3) begin
                        predicted_mmt=ct_mmt[l[i]][511:384];   
                     end
                     if (j==4) begin
                        predicted_mmt=ct_mmt[l[i]][639:512];   
                     end
                     if (j==5) begin
                        predicted_mmt=ct_mmt[l[i]][767:640];   
                     end
                     if (j==6) begin
                        predicted_mmt=ct_mmt[l[i]][895:768];   
                     end
                     if (j==7) begin
                        predicted_mmt=ct_mmt[l[i]][1023:896];   
                     end
                     if (j==8) begin
                        predicted_mmt=ct_mmt[l[i]][1151:1024];   
                     end
                     if (j==9) begin
                        predicted_mmt=ct_mmt[l[i]][1279:1152];   
                     end

                     if(!compare(cmd,predicted_mmt));
                     break;
                  end   
                  break;
                  end
                  
               end
       end
	 
	 end
   end 


endfunction : predict_result
 
 virtual function  compare(aes_transaction kmd,bit[127:0] predicted);
		if(kmd.cipher_o== predicted) begin
         return 1;
			`uvm_info("compare", {"Test: OK!"}, UVM_LOW);
		end else begin
         return 0;
			`uvm_error("compare", {"Test: Fail!"});
		end
	endfunction: compare

  endclass : scoreboard

