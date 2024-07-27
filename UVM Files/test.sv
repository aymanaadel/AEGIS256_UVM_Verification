package AEGIS_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import AEGIS_env_pkg::*;
import AEGIS_reset_sequence_pkg::*;
import AEGIS_main_sequence_pkg::*;

import AEGIS_config_pkg::*;

	class AEGIS_test extends uvm_component;
		`uvm_component_utils(AEGIS_test)

		AEGIS_env env;

		// sequences
		AEGIS_reset_sequence reset_sequence;
		AEGIS_main_sequence main_sequence;

		AEGIS_config AEGIS_cfg;

		function new(string name = "AEGIS_test", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env=AEGIS_env::type_id::create("env",this);
			reset_sequence=AEGIS_reset_sequence::type_id::create("reset_sequence");
			main_sequence=AEGIS_main_sequence::type_id::create("main_sequence");
			AEGIS_cfg=AEGIS_config::type_id::create("AEGIS_cfg");
			// get the IF
			if (!uvm_config_db#(virtual AEGIS_if)::get(this, "", "AEGIS_IF", AEGIS_cfg.AEGIS_vif)) begin
				`uvm_fatal("build_phase", "TEST - unable to get the IF");
			end
			// set the config object (which containing the IF)
			uvm_config_db#(AEGIS_config)::set(this, "*", "CFG", AEGIS_cfg);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);

			// reset sequence at the beginning of the operation
			`uvm_info("run_phase", "Reset Asserted", UVM_LOW);
			reset_sequence.start(env.agt.sqr);
			`uvm_info("run_phase", "Reset De-asserted", UVM_LOW);
			// ********************************************************* //

			// main sequence of encryption
			`uvm_info("run_phase", "main sequence Starts", UVM_LOW);
			main_sequence.start(env.agt.sqr);
			`uvm_info("run_phase", "main sequence Ends", UVM_LOW);
			// ********************************************************* //

			phase.drop_objection(this);
		endtask

	endclass

endpackage