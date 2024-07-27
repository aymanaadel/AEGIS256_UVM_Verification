package AEGIS_main_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import AEGIS_seq_item_pkg::*;

	class AEGIS_main_sequence extends uvm_sequence #(AEGIS_seq_item);
		`uvm_object_utils(AEGIS_main_sequence)

		AEGIS_seq_item seq_item;

		typedef enum bit {DECRYPT, ENCRYPT} enc_dec_e;
		
		function new(string name = "AEGIS_main_sequence");
			super.new(name);
		endfunction

		task body; /* AEGIS Encryption process Sequences */

			/*************************** 1st Case from AEGIS paper ***************************/
			seq_item=AEGIS_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.reset=0;
			seq_item.aegis_start=1;
			seq_item.encrypt_decrypt=ENCRYPT;
			seq_item.key=256'h0;
			seq_item.IV=256'h0;
			seq_item.plain_text[0]=128'h0;
			seq_item.AD=128'h0;
			seq_item.msglen=128;
			seq_item.adlen=0;
			finish_item(seq_item);
			/*********************************************************************************/

			/*************************** 2nd Case from AEGIS paper ***************************/
			seq_item=AEGIS_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.reset=0;
			seq_item.aegis_start=1;
			seq_item.encrypt_decrypt=ENCRYPT;
			seq_item.key=256'h0;
			seq_item.IV=256'h0;
			seq_item.plain_text[0]=128'h0;
			seq_item.AD=128'h0;
			seq_item.msglen=128;
			seq_item.adlen=128;
			finish_item(seq_item);
			/*********************************************************************************/

			/*************************** 3rd Case from AEGIS paper ***************************/
			seq_item=AEGIS_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.reset=0;
			seq_item.aegis_start=1;
			seq_item.encrypt_decrypt=ENCRYPT;
			seq_item.key=256'h0001000000000000000000000000000000000000000000000000000000000000;
			seq_item.IV=256'h0000020000000000000000000000000000000000000000000000000000000000;
			seq_item.plain_text[0]=128'h00000000000000000000000000000000;
			seq_item.AD=128'h00_01_02_03_00000000_00_00_00_00_00_00_00_00;
			seq_item.msglen=128;
			seq_item.adlen=32;
			finish_item(seq_item);
			/*********************************************************************************/

			/*************************** 4th Case from AEGIS paper ***************************/
			seq_item=AEGIS_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.reset=0;
			seq_item.aegis_start=1;
			seq_item.encrypt_decrypt=ENCRYPT;
			seq_item.key=256'h1001000000000000000000000000000000000000000000000000000000000000;
			seq_item.IV=256'h1000020000000000000000000000000000000000000000000000000000000000;
			seq_item.plain_text[0]=128'h000102030405060708090a0b0c0d0e0f;
			seq_item.plain_text[1]=128'h101112131415161718191a1b1c1d1e1f;
			seq_item.AD=128'h00_01_02_03_04_05_06_07_00_00_00_00_00_00_00_00;
			seq_item.msglen=256;
			seq_item.adlen=64;
			finish_item(seq_item);
			/*********************************************************************************/

			/******************************** Random sequence ********************************/
			repeat (50) begin  // randomization with turning off specific patterns constraint
				seq_item=AEGIS_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.patterns_c.constraint_mode(0);
				assert(seq_item.randomize());
				seq_item.reset=0;
				seq_item.aegis_start=1;
				seq_item.encrypt_decrypt=ENCRYPT;
				finish_item(seq_item);
			end

			repeat (50) begin  // randomization with turning on specific patterns constraint
				seq_item=AEGIS_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.patterns_c.constraint_mode(1);
				assert(seq_item.randomize());
				seq_item.reset=0;
				seq_item.aegis_start=1;
				seq_item.encrypt_decrypt=ENCRYPT;
				finish_item(seq_item);
			end
			/*********************************************************************************/
		
			// Add more sequences here...

		endtask
		
	endclass

endpackage


