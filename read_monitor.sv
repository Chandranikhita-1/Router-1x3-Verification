class read_monitor extends uvm_monitor;
	`uvm_component_utils(read_monitor)

	read_agent_config rd_config;

	uvm_analysis_port #(read_trans)monitor_port;

	virtual read_interface.RD_MON vif;

	function new(string name="read_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info(get_type_name(),"i am in build_phase",UVM_LOW)
		if(!uvm_config_db#(read_agent_config)::get(this,"","read_agent_config",rd_config))
			`uvm_fatal(get_type_name(),"plz check the set in test or env")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		//`uvm_info(get_type_name,"i am in connect phase",UVM_LOW)
		vif = rd_config.vif;
	endfunction

	task run_phase(uvm_phase phase);
        	forever
			begin
       				collect_data();
			end
	endtask

       task collect_data();
		read_trans trans;
		trans = read_trans::type_id::create("trans");

		while(vif.rd_mon_cb.read_enb!==1 || vif.rd_mon_cb.vld_out !==1)
		@(vif.rd_mon_cb);

		wait(vif.rd_mon_cb.data_out[7:2])

		trans.header=vif.rd_mon_cb.data_out;
		@(vif.rd_mon_cb);

		trans.payload=new[trans.header[7:2]];

		foreach(trans.payload[i])
		begin
			@(vif.rd_mon_cb);
			while(vif.rd_mon_cb.read_enb!==1 || vif.rd_mon_cb.vld_out !==1)
			@(vif.rd_mon_cb);
			trans.payload[i]=vif.rd_mon_cb.data_out;
		end

		while(vif.rd_mon_cb.read_enb!==1 || vif.rd_mon_cb.vld_out !==1)
		@(vif.rd_mon_cb);

		@(vif.rd_mon_cb);
		trans.parity=vif.rd_mon_cb.data_out;
		`uvm_info(get_type_name(),trans.sprint(),UVM_LOW)
 	
		 @(vif.rd_mon_cb);
  	 	monitor_port.write(trans);
       	endtask

	/*task run_phase(uvm_phase phase);
        	forever
			begin
       				collect_data();
				//`uvm_info(get_type_name(),trans.sprint(),UVM_LOW)
			end
	endtask

       task collect_data();
		read_trans trans;
		trans = read_trans::type_id::create("trans");

		wait(vif.rd_mon_cb.vld_out && vif.rd_mon_cb.read_enb)
		wait(vif.rd_mon_cb.data_out[7:2])

		//$display($time,vif.rd_mon_cb.data_out);

		trans.header=vif.rd_mon_cb.data_out;
		@(vif.rd_mon_cb);

		trans.payload=new[trans.header[7:2]];

		foreach(trans.payload[i])
		begin
			@(vif.rd_mon_cb);
			wait(vif.rd_mon_cb.vld_out && vif.rd_mon_cb.read_enb)
			trans.payload[i]=vif.rd_mon_cb.data_out;
		end

		wait(vif.rd_mon_cb.vld_out && vif.rd_mon_cb.read_enb)
		@(vif.rd_mon_cb);
		trans.parity=vif.rd_mon_cb.data_out;
		`uvm_info(get_type_name(),trans.sprint(),UVM_LOW)
 
  	 	 monitor_port.write(trans);
       	endtask*/

endclass

