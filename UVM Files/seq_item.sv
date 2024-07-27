package AEGIS_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

	class AEGIS_seq_item extends uvm_sequence_item;
		`uvm_object_utils(AEGIS_seq_item)

	    // Design inputs
	    rand logic reset, aegis_start;
	    rand logic encrypt_decrypt;
	    rand logic [255:0] key, IV;
	    rand logic [127:0] plain_text[8]; /* 1KB msg */
	    rand logic [127:0] AD;
	    rand logic [63:0] msglen;
	    rand logic [63:0] adlen;
	    // Design outputs
	    logic [127:0] cipher;
	    logic [127:0] tag;
	    logic [127:0] decrypted;
	    logic enc_block_done;
	    logic dec_block_done;
	    logic aegis_done;
	   	
	    /* array for patterns all-ones, all-zeros, alternating (1010../0101..)) */
	   	bit [127:0] pt_specific_patterns[] = '{ {128{1'b1}}, {128{1'b0}}, {32{4'hA}}, {32{4'h5}} };
		rand bit [127:0] pt_specific_patterns_t, pt_specific_patterns_f;

	   	bit [255:0] kIV_specific_patterns[] = '{ {256{1'b1}}, {256{1'b0}}, {64{4'hA}}, {64{4'h5}} };
		rand bit [255:0] kIV_specific_patterns_t, kIV_specific_patterns_f;

		/* used in adlen constraint below */
		rand bit [63:0] adlen_val_t, adlen_val_f;

		/* signal used below in padding zeros to AD */
	   	logic [127:0] mask;

		localparam RST_ASSERT=2, RST_DE_ASSERT=98;

		/* assert reset (active high) less often */
		constraint rst_c { reset dist {1:=RST_ASSERT, 0:=RST_DE_ASSERT}; }

		/* multiples of 128-bit & max msglen of 1024 (1KB) */
		constraint msglen_c {
			msglen inside {128, 256, 384, 512, 640, 768, 896, 1024};
		}

		/* adlen is power of 2 & max of 128 bits & min of 8 and takes value of 128 more often */
		constraint adlen_c {
			adlen inside {8, 16, 32, 64, 128};
			adlen_val_t inside {128};
			!(adlen_val_f inside {128});
			adlen dist {adlen_val_t:/40, adlen_val_f:/60};
		}

		constraint patterns_c {
			/* constraint on plain text & AD to take specific values more often */
			pt_specific_patterns_t inside {pt_specific_patterns};
			!(pt_specific_patterns_f inside {pt_specific_patterns});
			foreach(plain_text[i]) {
				plain_text[i] dist {pt_specific_patterns_t:/10, pt_specific_patterns_f:/90};
			}
			AD dist {pt_specific_patterns_t:/10, pt_specific_patterns_f:/90};
			/* constraint on key & IV to take specific values more */
			kIV_specific_patterns_t inside {kIV_specific_patterns};
			!(kIV_specific_patterns_f inside {kIV_specific_patterns});
			key dist {kIV_specific_patterns_t:/10, kIV_specific_patterns_f:/90};
			IV dist {kIV_specific_patterns_t:/10, kIV_specific_patterns_f:/90};
		}

		function void post_randomize();
			pad_zeros(adlen);
		endfunction

		/* function to pad zeros to AD depending on the randomized adlen */
	    function void pad_zeros(int num_bits=0);
 			mask = {128{1'b1}};
        	mask = mask << (128-num_bits);
        	AD &= mask;
	    endfunction

		function new(string name = "AEGIS_seq_item");
			super.new(name);
		endfunction

	endclass

endpackage