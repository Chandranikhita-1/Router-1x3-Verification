class write_agent extends uvm_agent;

	`uvm_component_utils(write_agent)

	write_driver wr_driver;
	write_monitor wr_monitor;
	write_sequencer wr_seqr;

	write_agent_config wr_config;

	function new(string name="write_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info(get_type_name(),"i am in build_phase",UVM_LOW)

		if(!uvm_config_db #(write_agent_config)::get(this,"","write_agent_config",wr_config))
			`uvm_fatal(get_type_name(),"plz check the set in env or test")

			wr_monitor = write_monitor::type_id::create("wr_monitor",this);
		if(wr_config.is_active == UVM_ACTIVE)
			begin
				wr_driver = write_driver::type_id::create("wr_driver",this);
				wr_seqr = write_sequencer::type_id::create("wr_seqr",this);
			end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		//`uvm_info(get_type_name(),"i am in connect_phase",UVM_LOW)

		if(wr_config.is_active == UVM_ACTIVE)
			wr_driver.seq_item_port.connect(wr_seqr.seq_item_export);
	endfunction

endclass

