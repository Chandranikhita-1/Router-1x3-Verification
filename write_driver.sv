class write_driver extends uvm_driver#(write_trans);
	`uvm_component_utils(write_driver)
	write_agent_config wr_config;

	virtual write_interface.WR_DRV vif;

	function new(string name="write_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info(get_type_name,"i am in build phase",UVM_LOW)
		if(!uvm_config_db#(write_agent_config)::get(this,"","write_agent_config",wr_config))
			`uvm_fatal(get_type_name(),"plz check the set in env or test")		
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		//`uvm_info(get_type_name,"i am in connect phase",UVM_LOW)
		vif = wr_config.vif;
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		//`uvm_info(get_type_name,"i am in run phase",UVM_LOW)
		
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				`uvm_info(get_type_name,req.sprint(),UVM_LOW)
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(write_trans trans);

		vif.wr_drv_cb.pkt_valid <= 1'b0;
		@(vif.wr_drv_cb);
		vif.wr_drv_cb.resetn <= 1'b0;
		@(vif.wr_drv_cb);
		vif.wr_drv_cb.resetn <= 1'b1;

		while(vif.wr_drv_cb.busy == 1'b1)
			@(vif.wr_drv_cb);

		vif.wr_drv_cb.pkt_valid <= 1'b1;
		vif.wr_drv_cb.data_in <= trans.header;

		@(vif.wr_drv_cb);

		foreach(trans.payload[i])
			begin
				while(vif.wr_drv_cb.busy == 1'b1)
					@(vif.wr_drv_cb);
				vif.wr_drv_cb.data_in <= trans.payload[i];
					@(vif.wr_drv_cb);
			end
		
		while(vif.wr_drv_cb.busy == 1'b1)
			@(vif.wr_drv_cb);
		vif.wr_drv_cb.data_in <= trans.parity;
		vif.wr_drv_cb.pkt_valid <= 1'b0;

		repeat(2)
			@(vif.wr_drv_cb);
			
	endtask

endclass

