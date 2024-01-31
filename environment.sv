class environment extends uvm_env;

	`uvm_component_utils(environment)

	write_agent_top wr_agent_top;
	read_agent_top rd_agent_top;

	//write_agent wr_agent[];
	//read_agent rd_agent[];

	virtual_sequencer v_sqrh;
	scoreboard sb;

	env_config m_cfg;

	function new (string name = "environment",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info(get_type_name,"i am in build_phase",UVM_LOW)

		if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
			`uvm_fatal(get_type_name(),"plz set it in the test")

		wr_agent_top = write_agent_top::type_id::create("wr_agent_top",this);
		rd_agent_top = read_agent_top::type_id::create("rd_agent_top",this);

		/*wr_agent = new[1];
				
		foreach(wr_agent[i])
			begin
				wr_agent[i]=write_agent::type_id::create($sformatf("wr_agent[%0d]",i) ,this);
			end

		rd_agent = new[3];

		foreach(rd_agent[i])
			begin
				rd_agent[i]=read_agent::type_id::create($sformatf("rd_agent[%0d]",i) ,this);
			end*/

		v_sqrh = virtual_sequencer::type_id::create("v_sqrh",this);
		sb = scoreboard::type_id::create("sb",this);
	endfunction

				
	function void connect_phase(uvm_phase phase);
			for(int i=0;i<m_cfg.write_agents;i++)
					v_sqrh.wr_sqrh[i]=wr_agent_top.wr_agent[i].wr_seqr;
					
			for(int i=0;i<m_cfg.read_agents;i++)
					v_sqrh.rd_sqrh[i]=rd_agent_top.rd_agent[i].rd_seqr;
			
			foreach(wr_agent_top.wr_agent[i])
				wr_agent_top.wr_agent[0].wr_monitor.monitor_port.connect(sb.fifo_wr.analysis_export);

			foreach(rd_agent_top.rd_agent[i])
				rd_agent_top.rd_agent[i].rd_monitor.monitor_port.connect(sb.fifo_rd[i].analysis_export);
				//rd_agent_top.rd_agent[1].rd_monitor.monitor_port.connect(sb.fifo_rd[1].analysis_export);
				//rd_agent_top.rd_agent[2].rd_monitor.monitor_port.connect(sb.fifo_rd[2].analysis_export);
	endfunction


endclass


