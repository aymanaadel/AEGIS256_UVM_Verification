package AEGIS_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import AEGIS_seq_item_pkg::*;

	class AEGIS_driver extends uvm_driver #(AEGIS_seq_item);
		`uvm_component_utils(AEGIS_driver)

		virtual AEGIS_if AEGIS_vif;
		AEGIS_seq_item stim_seq_item;

		function new(string name = "AEGIS_driver", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		typedef enum bit {DECRYPT, ENCRYPT} enc_dec_e;
		int msg_blocks_num=0;
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				stim_seq_item=AEGIS_seq_item::type_id::create("stim_seq_item");
				seq_item_port.get_next_item(stim_seq_item);

				if (stim_seq_item.reset) begin /* reset case */
					AEGIS_vif.reset=stim_seq_item.reset;
					AEGIS_vif.aegis_start=stim_seq_item.aegis_start;
					@(negedge AEGIS_vif.clk);
				end
				else begin /* normal case */
					AEGIS_vif.reset=stim_seq_item.reset;
					AEGIS_vif.aegis_start=stim_seq_item.aegis_start;
					AEGIS_vif.key=stim_seq_item.key;
					AEGIS_vif.IV=stim_seq_item.IV;
					AEGIS_vif.msglen=stim_seq_item.msglen;
					AEGIS_vif.adlen=stim_seq_item.adlen;
					AEGIS_vif.AD=stim_seq_item.AD;

					if (stim_seq_item.encrypt_decrypt==ENCRYPT) begin
						AEGIS_vif.encrypt_decrypt=ENCRYPT;
					end
					else begin
						AEGIS_vif.encrypt_decrypt=DECRYPT;
					end

					/* drive the 1st block of the plain text */
					AEGIS_vif.plain_text=stim_seq_item.plain_text[0];
					/* drive the next block after finishing the encryption of the prev. block */
					msg_blocks_num=stim_seq_item.msglen/128;
			        if (msg_blocks_num>1) begin
			        	for (int i = 1; i < msg_blocks_num; i++) begin			        	
				        	@(negedge AEGIS_vif.enc_block_done);
							@(negedge AEGIS_vif.clk);
				            AEGIS_vif.plain_text=stim_seq_item.plain_text[i];
				        end   		
			        end

			        /* after finishing the encryption of the all blocks, wait till the generation of the tag  */
					@(negedge AEGIS_vif.clk);
					@(negedge AEGIS_vif.aegis_done);
				end // else of normal case

				seq_item_port.item_done();
			end
		endtask
	endclass
endpackage