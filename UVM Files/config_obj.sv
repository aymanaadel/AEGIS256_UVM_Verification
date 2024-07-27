package AEGIS_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

	class AEGIS_config extends uvm_object;
		`uvm_object_utils(AEGIS_config)

		virtual AEGIS_if AEGIS_vif;

		function new(string name = "AEGIS_config");
			super.new(name);
		endfunction

	endclass

endpackage