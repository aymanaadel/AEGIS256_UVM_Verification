package AEGIS_sequencer_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import AEGIS_seq_item_pkg::*;

	class AEGIS_sequencer extends uvm_sequencer #(AEGIS_seq_item);
		`uvm_component_utils(AEGIS_sequencer)

		function new(string name = "AEGIS_sequencer", uvm_component parent = null);
			super.new(name,parent);
		endfunction

	endclass

endpackage