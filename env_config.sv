class env_config extends uvm_object;

	`uvm_object_utils(env_config)

	write_agent_config wr_config[];
	read_agent_config rd_config[];

	int write_agents = 1;
	int read_agents = 3;

	function new(string name = "env_config");
		super.new(name);
	endfunction

endclass


