
package router_pkg;

	int no_of_trans = 1;

	import uvm_pkg::*;

	`include "uvm_macros.svh"

	`include "write_trans.sv"
	`include "write_agent_config.sv"
	`include "read_agent_config.sv"
	`include "env_config.sv"
	`include "write_driver.sv"
	`include "write_monitor.sv"
	`include "write_sequencer.sv"
	`include "write_agent.sv"
	`include "write_agent_top.sv"
	`include "write_sequence.sv"

	`include "read_trans.sv"
	`include "read_monitor.sv"
	`include "read_sequencer.sv"
	`include "read_sequence.sv"
	`include "read_driver.sv"
	`include "read_agent.sv"
	`include "read_agent_top.sv"

	`include "virtual_sequencer.sv"
	`include "virtual_sequence.sv"
	`include "scoreboard.sv"

	`include "environment.sv"


	`include "router_vtest_lib.sv"

endpackage

