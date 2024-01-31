class read_agent extends uvm_agent;

	`uvm_component_utils(read_agent)

	read_driver rd_driver;
	read_monitor rd_monitor;
	read_sequencer rd_seqr;

	read_agent_config rd_config;

	function new(string name="read_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info(get_type_name(),"i am in build_phase",UVM_LOW)
		
		if(!uvm_config_db#(read_agent_config)::get(this,"","read_agent_config",rd_config))
			`uvm_fatal(get_type_name(),"plz check the set in env or test")

			rd_monitor = read_monitor::type_id::create("rd_monitor",this);
		if(rd_config.is_active == UVM_ACTIVE)
			begin
				rd_driver = read_driver::type_id::create("rd_driver",this);
				rd_seqr = read_sequencer::type_id::create("rd_seqr",this);
			end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		//`uvm_info(get_type_name(),"i am in connect_phase",UVM_LOW)

		if(rd_config.is_active == UVM_ACTIVE)
			rd_driver.seq_item_port.connect(rd_seqr.seq_item_export);
	endfunction
	
endclass


