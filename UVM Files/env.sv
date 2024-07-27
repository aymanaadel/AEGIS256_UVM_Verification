package AEGIS_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import AEGIS_agent_pkg::*;
import AEGIS_scoreboard_pkg::*;
import AEGIS_coverage_pkg::*;

	class AEGIS_env extends uvm_env;
		`uvm_component_utils(AEGIS_env)

		AEGIS_agent agt;
		AEGIS_scoreboard sb;
		AEGIS_coverage cov;

		function new(string name = "AEGIS_env", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			agt=AEGIS_agent::type_id::create("agt",this);
			sb=AEGIS_scoreboard::type_id::create("sb",this);
			cov=AEGIS_coverage::type_id::create("cov",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			agt.agt_ap.connect(sb.sb_export);
			agt.agt_ap.connect(cov.cov_export);
		endfunction
	endclass

endpackage