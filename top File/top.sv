import uvm_pkg::*;
`include "uvm_macros.svh"
import AEGIS_test_pkg::*;

module top;
	// clock generation
	bit clk;
	initial begin
		clk=0;
		forever #1 clk=~clk;
	end
	// interface
	AEGIS_if aegis_if(clk);
	// DUT
	AEGIS dut(aegis_if);

	initial begin
		uvm_config_db#(virtual AEGIS_if)::set(null, "uvm_test_top", "AEGIS_IF", aegis_if);
		run_test("AEGIS_test");
	end

endmodule