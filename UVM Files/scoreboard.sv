package AEGIS_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import AEGIS_seq_item_pkg::*;

/** C++ function description:
	name		  : AEGIS_check
	function 	  : performs AEGIS-algorithm Encryption process then compares the result with the RTL output  
	arguments     : the RTL inputs (msglen, adlen, key, IV, AD, plain_text),
	 				the RTL encryption outputs (cipher, tag) 
	arguments_type: string/string array
	return	      : 1/0 (int) depending on the C++ output equals/not_equal the RTL output 
**/
import "DPI-C" function int AEGIS_check(input string msglen_sv, input string adlen_sv,
			input string key_sv, input string IV_sv, input string AD_sv, input string plain_text_sv[8], 
			input string cipher_sv[8], input string tag_sv);

	class AEGIS_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(AEGIS_scoreboard)	

		uvm_analysis_export #(AEGIS_seq_item) sb_export;
		uvm_tlm_analysis_fifo #(AEGIS_seq_item) sb_AEGIS;

		AEGIS_seq_item seq_item_sb;

		/* to store the monitored plaint_text, cipher, tag to check them after aegis done */
	    logic [127:0] plain_text[8];
	    logic [127:0] cipher[8];
	    logic [127:0] tag;

	    int msg_blocks_num=0; /* number of msg block depending on msglen */
	    int i=0; /* iterator used to iterate on msg/cipher blocks */
	   	int check_flag=0; /* receive the output from the C++ AEGIS function */
	    int error_count=0, correct_count=0; /* count numer of errors/correct in enc. processes */

	    /* strings used to pass values to C++ function */
	    string msglen_str, adlen_str, key_str, IV_str, AD_str, tag_str;
	    string plain_text_str[8];
	    string cipher_str[8];
		/*****************************************************************/

		function new(string name = "AEGIS_scoreboard", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_export=new("sb_export",this);
			sb_AEGIS=new("sb_AEGIS",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_AEGIS.analysis_export);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_AEGIS.get(seq_item_sb);

				msg_blocks_num=seq_item_sb.msglen/128;
				if (i < msg_blocks_num) begin
			            plain_text[i]=seq_item_sb.plain_text[0];
			            cipher[i]=seq_item_sb.cipher;
			            /* transform to string to send it to the c++ function */
			            $sformat(plain_text_str[i], "%h", plain_text[i]);
						$sformat(cipher_str[i], "%h", cipher[i]);
			            i++;
			    end
			    else begin
			    	i=0;
			    	tag=seq_item_sb.tag;
			    	/* transform to string to send it to the c++ function */
					$sformat(tag_str, "%h", tag);
					$sformat(key_str, "%h", seq_item_sb.key);
					$sformat(IV_str, "%h", seq_item_sb.IV);
					$sformat(AD_str, "%h", seq_item_sb.AD);
					$sformat(msglen_str, "%d", seq_item_sb.msglen);
					$sformat(adlen_str, "%d", seq_item_sb.adlen);

					/* if there is no error (design out=golden out), check_flag = 1, else = 0 */
					check_flag=AEGIS_check(msglen_str, adlen_str, key_str, IV_str, AD_str,
											plain_text_str, cipher_str, tag_str);
					if (check_flag) begin
						correct_count++; 
						`uvm_info("run_phase", $sformatf("Encryption of %0d msg blocks Succeeded!\n", msg_blocks_num),UVM_MEDIUM);
					end
					else error_count++;
			    end
			end // forever

		endtask

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase", $sformatf("At time %0t: Simulation Ends and Error Count= %0d,\nCorrect Count= %0d",
					 $time, error_count, correct_count), UVM_MEDIUM);
		endfunction

	endclass

endpackage