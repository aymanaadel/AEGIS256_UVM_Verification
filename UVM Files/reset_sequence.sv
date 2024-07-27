package AEGIS_reset_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import AEGIS_seq_item_pkg::*;

	class AEGIS_reset_sequence extends uvm_sequence #(AEGIS_seq_item);
		`uvm_object_utils(AEGIS_reset_sequence)

		AEGIS_seq_item seq_item;

		function new(string name = "AEGIS_reset_sequence");
			super.new(name);
		endfunction

		task body;
			seq_item=AEGIS_seq_item::type_id::create("seq_item");
			
			start_item(seq_item);
			seq_item.reset=1;
		    seq_item.aegis_start=0;
			finish_item(seq_item);
		endtask
		
	endclass

endpackage