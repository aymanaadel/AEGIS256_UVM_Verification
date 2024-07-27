package AEGIS_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import AEGIS_sequencer_pkg::*;
import AEGIS_driver_pkg::*;
import AEGIS_monitor_pkg::*;
import AEGIS_config_pkg::*;
import AEGIS_seq_item_pkg::*;

	class AEGIS_agent extends uvm_agent;
		`uvm_component_utils(AEGIS_agent)

		AEGIS_sequencer sqr;
		AEGIS_driver drv;
		AEGIS_monitor mon;
		// config object to get the IF
		AEGIS_config AEGIS_cfg;
		uvm_analysis_port #(AEGIS_seq_item) agt_ap;

		function new(string name = "AEGIS_agent", uvm_component parent = null);
			super.new(name,parent);
		endfunction
		
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sqr=AEGIS_sequencer::type_id::create("sqr",this);
			drv=AEGIS_driver::type_id::create("drv",this);
			mon=AEGIS_monitor::type_id::create("mon",this);
			agt_ap=new("agt_ap",this);

			if ( !uvm_config_db#(AEGIS_config)::get(this, "", "CFG", AEGIS_cfg) ) begin
				`uvm_fatal("build_phase", "AGENT - unable to get the IF");
			end

		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			drv.AEGIS_vif=AEGIS_cfg.AEGIS_vif;
			mon.AEGIS_vif=AEGIS_cfg.AEGIS_vif;
			drv.seq_item_port.connect(sqr.seq_item_export);
			mon.mon_ap.connect(agt_ap);
		endfunction
	endclass

endpackage