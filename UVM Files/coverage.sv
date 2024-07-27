package AEGIS_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import AEGIS_seq_item_pkg::*;

	class AEGIS_coverage extends uvm_component;
		`uvm_component_utils(AEGIS_coverage)

		uvm_analysis_export #(AEGIS_seq_item) cov_export;
		uvm_tlm_analysis_fifo #(AEGIS_seq_item) cov_AEGIS;

		AEGIS_seq_item seq_item_cov;

		/* array for patterns all-ones, all-zeros, alternating (1010../0101..)) */
	   	bit [127:0] pt_specific_patterns[]  = '{ {128{1'b1}}, {128{1'b0}}, {32{4'hA}}, {32{4'h5}} };
	   	bit [255:0] kIV_specific_patterns[] = '{ {256{1'b1}}, {256{1'b0}}, {64{4'hA}}, {64{4'h5}} };

		covergroup cvr_grp;
			plain_text_patterns_cp: // cp on the plain_text every block encryption
			coverpoint seq_item_cov.plain_text[0] iff(seq_item_cov.enc_block_done) {
				bins all_ones = { pt_specific_patterns[0] };
				bins all_zeros = { pt_specific_patterns[1] };
				bins alternating_bits = { pt_specific_patterns[2], pt_specific_patterns[3] };
				bins random = default;
			}
			AD_patterns_cp: // cp on the AD every encryption process
			coverpoint seq_item_cov.AD iff(seq_item_cov.aegis_done) {
				bins all_ones = { pt_specific_patterns[0] };
				bins all_zeros = { pt_specific_patterns[1] };
				bins alternating_bits = { pt_specific_patterns[2], pt_specific_patterns[3] };
				bins random = default;
			}
			key_patterns_cp: // cp on the key every encryption process
			coverpoint seq_item_cov.key iff(seq_item_cov.aegis_done) {
				bins all_ones = { kIV_specific_patterns[0] };
				bins all_zeros = { kIV_specific_patterns[1] };
				bins alternating_bits = { kIV_specific_patterns[2], kIV_specific_patterns[3] };
				bins random = default;
			}
			IV_patterns_cp: // cp on the IV every encryption process
			coverpoint seq_item_cov.IV iff(seq_item_cov.aegis_done) {
				bins all_ones = { kIV_specific_patterns[0] };
				bins all_zeros = { kIV_specific_patterns[1] };
				bins alternating_bits = { kIV_specific_patterns[2], kIV_specific_patterns[3] };
				bins random = default;
			}
			msglen_patterns_cp: // cp on the msglen every encryption process
			coverpoint seq_item_cov.msglen iff(seq_item_cov.aegis_done) {
				bins one_block    = {128};
				bins two_blocks   = {256};
				bins three_blocks = {384};
				bins four_blocks  = {512};
				bins five_blocks  = {640};
				bins six_blocks	  = {768};
				bins seven_blocks = {896};
				bins eight_blocks = {1024};
			}
			adlen_patterns_cp: // cp on the adlen every encryption process
			coverpoint seq_item_cov.adlen iff(seq_item_cov.aegis_done) {
				bins adlen8   = {8};
				bins adlen16  = {16};
				bins adlen32  = {32};
				bins adlen64  = {64};
				bins adlen128 = {128};
			}
		endgroup

		function new(string name = "AEGIS_coverage", uvm_component parent = null);
			super.new(name,parent);
			cvr_grp=new();
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export=new("cov_export",this);
			cov_AEGIS=new("cov_AEGIS",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_AEGIS.analysis_export);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_AEGIS.get(seq_item_cov);
				cvr_grp.sample();
			end
		endtask

	endclass
endpackage