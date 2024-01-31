class read_driver extends uvm_driver#(read_trans);
	`uvm_component_utils(read_driver)

	read_agent_config rd_config;

	virtual read_interface.RD_DRV vif;


	function new(string name="read_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info(get_type_name,"i am in build phase",UVM_LOW)
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
				seq_item_port.get_next_item(req);
				vif.rd_drv_cb.read_enb<=1'b0;
				sent_to_dut(req);
				`uvm_info(get_type_name,req.sprint(),UVM_LOW)
				seq_item_port.item_done;
			end
	endtask

	task sent_to_dut(read_trans trans);

		while(vif.rd_drv_cb.vld_out !==1'b1)
		@(vif.rd_drv_cb);
		repeat(trans.no_of_cycles)
		@(vif.rd_drv_cb);
		vif.rd_drv_cb.read_enb <= 1'b1;
		while(vif.rd_drv_cb.vld_out!==1'b0)
		@(vif.rd_drv_cb);	
		vif.rd_drv_cb.read_enb <= 1'b0;
		repeat(2)
		@(vif.rd_drv_cb);
	endtask
	
	/*task run_phase(uvm_phase phase);
		forever
			begin
				seq_item_port.get_next_item(req);
				vif.rd_drv_cb.read_enb<=1'b0;
				sent_to_dut(req);
				`uvm_info(get_type_name,req.sprint(),UVM_LOW)
				seq_item_port.item_done;
			end
	endtask

	task sent_to_dut(read_trans trans);

		wait(vif.rd_drv_cb.vld_out)
		repeat(trans.no_of_cycles)
		@(vif.rd_drv_cb);
		vif.rd_drv_cb.read_enb <= 1'b1;
		while(vif.rd_drv_cb.vld_out)
		@(vif.rd_drv_cb);	
		vif.rd_drv_cb.read_enb <= 1'b0;
		repeat(2)
		@(vif.rd_drv_cb);
	endtask*/

endclass

