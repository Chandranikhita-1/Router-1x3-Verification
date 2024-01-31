class read_agent_top extends uvm_env;
	`uvm_component_utils(read_agent_top)

	read_agent rd_agent[];
	env_config m_cfg;
	
	function new(string name="read_agent_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(),"i am in build_phase",UVM_LOW)

		if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg))
			`uvm_fatal(get_type_name(),"plz set in test")

		//rd_agent=new[3];
		rd_agent = new[m_cfg.read_agents];
		foreach(rd_agent[i])
			rd_agent[i]=read_agent::type_id::create($sformatf("rd_agent[%0d]",i),this);
		for(int i=0;i<m_cfg.read_agents;i++)
			uvm_config_db#(read_agent_config)::set(this,$sformatf("rd_agent[%0d]*",i),"read_agent_config",m_cfg.rd_config[i]);	
	endfunction

endclass

