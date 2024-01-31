/**************** without coverage ********************************/

/*class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	write_trans wr_trans;
	read_trans rd_trans;
	env_config m_cfg;

	uvm_tlm_analysis_fifo #(write_trans) fifo_wr;
	uvm_tlm_analysis_fifo #(read_trans) fifo_rd[];
	

	function new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
		`uvm_fatal(get_type_name(),"plz set properly in test")

		wr_trans = write_trans::type_id::create("wr_trans");
 		rd_trans = read_trans::type_id::create("rd_trans");

		fifo_wr = new("fifo_wr",this);

		fifo_rd = new[m_cfg.read_agents];

		foreach(fifo_rd[i])
			fifo_rd[i] = new($sformatf("fifo_rd[%0d]",i),this);
	endfunction

		

	task run_phase(uvm_phase phase);
		forever
			fork
				begin
					fifo_wr.get(wr_trans);
					$display("source got");
				end
				fork
					begin
					fifo_rd[0].get(rd_trans);
					comparing(wr_trans,rd_trans);
					end

					begin
					fifo_rd[1].get(rd_trans);
					comparing(wr_trans,rd_trans);
					end

					begin
					fifo_rd[2].get(rd_trans);
					comparing(wr_trans,rd_trans);
					end

				join_any
				disable fork;
			join

		//compare(wr_trans,rd_trans);
	endtask

	task comparing(write_trans wr,read_trans rd);
		if(wr.header==rd.header)
			$display("header match %0d",wr.header);
		else
			$display("header mismatch");

		//for(int i=0;i<wr.header[7:2];i++)

		if(wr.payload==rd.payload)
			$display("payload match");
		else
			$display("payload mismatch");

		if(wr.parity==rd.parity)
			$display("parity match %0d",wr.parity);
		else
			$display("parity mismatch");
	endtask

endclass*/

/*****************************************************************************************************************************************************/

/**************************** with coverage **************************************/

class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	write_trans wr_trans;
	read_trans rd_trans;
	env_config m_cfg;

	write_trans wr_cover;
	read_trans rd_cover;

	uvm_tlm_analysis_fifo #(write_trans) fifo_wr;
	uvm_tlm_analysis_fifo #(read_trans) fifo_rd[];
	


	covergroup sr_coverage;
	option.per_instance=1;
		HEADER : coverpoint wr_cover.header[1:0]  { bins address = {[0:2]};}
		PAYLOAD : coverpoint wr_cover.header[7:2] { bins small_packet = {[1:15]};
							    bins medium_packet = {[16:32]};
							    bins large_packet = {[33:63]};}
		HEAD_PAY: cross HEADER,PAYLOAD;
	endgroup

	covergroup ds_coverage;
	option.per_instance=1;
		HEADER : coverpoint rd_cover.header[1:0]  { bins address = {[0:2]};}
		PAYLOAD : coverpoint rd_cover.header[7:2] { bins small_packet = {[1:15]};
							    bins medium_packet = {[16:32]};
							    bins large_packet = {[33:63]};}
		HEAD_PAY: cross HEADER,PAYLOAD;
	endgroup

		
	function new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);
		sr_coverage = new();
		ds_coverage = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
		`uvm_fatal(get_type_name(),"plz set properly in test")

		wr_trans = write_trans::type_id::create("wr_trans");
 		rd_trans = read_trans::type_id::create("rd_trans");

		fifo_wr = new("fifo_wr",this);

		fifo_rd = new[m_cfg.read_agents];

		foreach(fifo_rd[i])
			fifo_rd[i] = new($sformatf("fifo_rd[%0d]",i),this);
	endfunction

		

	task run_phase(uvm_phase phase);
		forever
			fork
				begin
					fifo_wr.get(wr_trans);
					$display("source got");
					wr_cover = wr_trans;
					sr_coverage.sample();
				end
				fork
					begin
					fifo_rd[0].get(rd_trans);
					comparing(wr_trans,rd_trans);
					rd_cover = rd_trans;
					ds_coverage.sample();

					end

					begin
					fifo_rd[1].get(rd_trans);
					comparing(wr_trans,rd_trans);
					rd_cover = rd_trans;
					ds_coverage.sample();

					end

					begin
					fifo_rd[2].get(rd_trans);
					comparing(wr_trans,rd_trans);
					rd_cover = rd_trans;
					ds_coverage.sample();

					end

				join_any
				disable fork;
			join

	endtask

	task comparing(write_trans wr,read_trans rd);
		if(wr.header==rd.header)
			$display("header match %0d",wr.header);
		else
			$display("header mismatch");

		//for(int i=0;i<wr.header[7:2];i++)

		if(wr.payload==rd.payload)
			$display("payload match");
		else
			$display("payload mismatch");

		if(wr.parity==rd.parity)
			$display("parity match %0d",wr.parity);
		else
			$display("parity mismatch");
	endtask

endclass
	


