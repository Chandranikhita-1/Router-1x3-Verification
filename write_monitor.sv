class write_monitor extends uvm_monitor;

	`uvm_component_utils(write_monitor)

	write_agent_config wr_config;

	uvm_analysis_port#(write_trans)monitor_port;

	virtual write_interface.WR_MON vif;

	function new(string name="write_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info(get_type_name(),"i am in build_phase",UVM_LOW)

		if(!uvm_config_db#(write_agent_config)::get(this,"","write_agent_config",wr_config))
			`uvm_fatal(get_type_name(),"plz check the set in source_agent")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		//`uvm_info(get_type_name(),"i am in connect_phase",UVM_LOW)
		vif = wr_config.vif;
	endfunction


	task run_phase(uvm_phase phase);
		super.run_phase(phase);
        	forever
       			collect_data();     
       endtask

        task collect_data();

		write_trans trans;
		trans=write_trans::type_id::create("trans");
		//repeat(2)
		//@(vif.wr_mon_cb);

		while(vif.wr_mon_cb.pkt_valid!==1 || vif.wr_mon_cb.busy==1)
			@(vif.wr_mon_cb);
		trans.header = vif.wr_mon_cb.data_in;
			@(vif.wr_mon_cb);
		trans.payload = new[trans.header[7:2]];  //payload size decleration
		foreach(trans.payload[i])
			begin
				while(vif.wr_mon_cb.busy==1)
					@(vif.wr_mon_cb);
				trans.payload[i] = vif.wr_mon_cb.data_in;
				@(vif.wr_mon_cb);
			end

		//while(vif.wr_mon_cb.busy==1)
		while(vif.wr_mon_cb.pkt_valid!==0 || vif.wr_mon_cb.busy==1)
			@(vif.wr_mon_cb);
		trans.parity = vif.wr_mon_cb.data_in;

		`uvm_info(get_type_name,trans.sprint(),UVM_LOW)

		@(vif.wr_mon_cb);

		monitor_port.write(trans);
       endtask

endclass

