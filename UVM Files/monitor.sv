package AEGIS_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import AEGIS_seq_item_pkg::*;

	class AEGIS_monitor extends uvm_monitor;
		`uvm_component_utils(AEGIS_monitor)

		virtual AEGIS_if AEGIS_vif;
		AEGIS_seq_item rsp_seq_item;

		uvm_analysis_port #(AEGIS_seq_item) mon_ap;

		function new(string name = "AEGIS_monitor", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			mon_ap=new("mon_ap",this);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				rsp_seq_item=AEGIS_seq_item::type_id::create("rsp_seq_item");

				/** sample only when:
				 	1. enc_block_done rises (a block was encrypted), to sample the cipher & plain_text
				 	2. aegis_done rises (aegis finished and tag was generated), to sample the tag **/
				@(posedge AEGIS_vif.enc_block_done or posedge AEGIS_vif.aegis_done);
				@(negedge AEGIS_vif.clk)

				// design outputs
				rsp_seq_item.cipher=AEGIS_vif.cipher;
				rsp_seq_item.tag=AEGIS_vif.tag;
				rsp_seq_item.decrypted=AEGIS_vif.decrypted;
				rsp_seq_item.enc_block_done=AEGIS_vif.enc_block_done;
				rsp_seq_item.dec_block_done=AEGIS_vif.dec_block_done;
				rsp_seq_item.aegis_done=AEGIS_vif.aegis_done;
				// design inputs
				rsp_seq_item.reset=AEGIS_vif.reset;
				rsp_seq_item.aegis_start=AEGIS_vif.aegis_start;
				rsp_seq_item.encrypt_decrypt=AEGIS_vif.encrypt_decrypt;
				rsp_seq_item.key=AEGIS_vif.key;
				rsp_seq_item.IV=AEGIS_vif.IV;
				rsp_seq_item.plain_text[0]=AEGIS_vif.plain_text;
				rsp_seq_item.AD=AEGIS_vif.AD;
				rsp_seq_item.msglen=AEGIS_vif.msglen;
				rsp_seq_item.adlen=AEGIS_vif.adlen;

				mon_ap.write(rsp_seq_item);
			end
		endtask

	endclass
endpackage
