class virtual_sequencer extends uvm_sequencer#(uvm_sequence_item) ;
	`uvm_component_utils(virtual_sequencer);
	write_sequencer wr_sqrh[];
	read_sequencer rd_sqrh[];
	env_config m_cfg;

	function new(string name="virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name,"i am in build_phase",UVM_LOW)
		
		if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
			`uvm_fatal(get_type_name(),"not getting plz set it correctly in test")

		wr_sqrh = new[m_cfg.write_agents];
		rd_sqrh = new[m_cfg.read_agents];
	endfunction

endclass

