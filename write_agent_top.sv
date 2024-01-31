class write_agent_top extends uvm_env;
	`uvm_component_utils(write_agent_top)

	write_agent wr_agent[];
	env_config m_cfg;

	function new(string name="write_agent_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		`uvm_info(get_type_name(),"i am in build_phase",UVM_LOW)

		if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg))
			`uvm_fatal(get_type_name(),"plz set in test")
		//wr_agent=new[1];
		wr_agent = new[m_cfg.write_agents];
		foreach(wr_agent[i])
			wr_agent[i]=write_agent::type_id::create($sformatf("wr_agent[%0d]",i),this);
		for(int i=0;i<m_cfg.write_agents;i++)
			uvm_config_db#(write_agent_config)::set(this,$sformatf("wr_agent[%0d]*",i),"write_agent_config",m_cfg.wr_config[i]);	
	endfunction

endclass

