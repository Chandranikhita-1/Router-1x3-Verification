class read_agent_config extends uvm_object;

	`uvm_object_utils(read_agent_config)
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;

	virtual read_interface vif;

	function new(string name="read_agent_config");
		super.new(name);
	endfunction

endclass

