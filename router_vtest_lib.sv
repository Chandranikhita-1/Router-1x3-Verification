class base_test extends uvm_test;

	`uvm_component_utils(base_test)
	
	environment env;

	env_config m_cfg;
	write_agent_config wr_cfg[];
	read_agent_config rd_cfg[];

	//virtual_sequence v_seq;

	int write_agents = 1;
	int read_agents = 3;

	bit [1:0]addr;

	function new(string name = "base_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void router_config();
		wr_cfg = new[write_agents];

		foreach(wr_cfg[i])
			begin
				wr_cfg[i] = write_agent_config::type_id::create($sformatf("wr_cfg[%0d]",i));
				if(!uvm_config_db#(virtual write_interface)::get(this,"",$sformatf("svif_%0d",i),wr_cfg[i].vif))
					`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
				wr_cfg[i].is_active = UVM_ACTIVE;
				m_cfg.wr_config[i] = wr_cfg[i];
			end

		rd_cfg = new[read_agents];

		foreach(rd_cfg[i])
			begin
				rd_cfg[i] = read_agent_config::type_id::create($sformatf("rd_cfg[%0d]",i));
				if(!uvm_config_db#(virtual read_interface)::get(this,"",$sformatf("vif_%0d",i),rd_cfg[i].vif))
					`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
				rd_cfg[i].is_active = UVM_ACTIVE;

				/*if(i==2)
					begin
					rd_cfg[i].is_active = UVM_PASSIVE;
					end
				else
					rd_cfg[i].is_active = UVM_ACTIVE;*/
	
				m_cfg.rd_config[i] = rd_cfg[i];
			end

		//assigning agents of int type in both env_config class and test class

		m_cfg.write_agents = write_agents;
		m_cfg.read_agents = read_agents;
		
		addr = {$random}%3;
		//addr = 0;
		uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);

	endfunction

				

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info(get_type_name,"i am in build_phase",UVM_LOW)

		m_cfg=env_config::type_id::create("m_cfg");
	
		env = environment::type_id::create("env",this);
		//v_seq = virtual_sequence::type_id::create("v_seq",this);

        	m_cfg.wr_config = new[write_agents];
		m_cfg.rd_config = new[read_agents];

		router_config();  //calling the above config method

		uvm_config_db #(env_config)::set(this,"*","env_config",m_cfg);

		
	endfunction


	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		//`uvm_info(get_type_name,"i am in end_of_elaboration_phase",UVM_LOW)
		uvm_top.print_topology();
	endfunction

	/*task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		wr_seq.start(env.v_sqrh);
		phase.drop_objection(this);
	endtask*/

endclass


class small_packet_test extends base_test;

	`uvm_component_utils(small_packet_test)

	small_virtual_sequence v_seq;

	function new(string name="small_packet_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		v_seq = small_virtual_sequence::type_id::create("v_seq",this);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		for(int i=0;i<no_of_trans;i++)
		begin
		phase.raise_objection(this);
		v_seq.start(env.v_sqrh);
		phase.drop_objection(this);
		end
	endtask

endclass


class medium_packet_test extends base_test;

	`uvm_component_utils(medium_packet_test)

	medium_virtual_sequence v_seq;

	function new(string name="medium_packet_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		v_seq = medium_virtual_sequence::type_id::create("v_seq",this);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		for(int i=0;i<no_of_trans;i++)
		begin
		phase.raise_objection(this);
		v_seq.start(env.v_sqrh);
		phase.drop_objection(this);
		end
	endtask

endclass


class large_packet_test extends base_test;

	`uvm_component_utils(large_packet_test)

	large_virtual_sequence v_seq;

	function new(string name="large_packet_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		v_seq = large_virtual_sequence::type_id::create("v_seq",this);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		for(int i=0;i<no_of_trans;i++)
		begin
		phase.raise_objection(this);
		v_seq.start(env.v_sqrh);
		phase.drop_objection(this);
		end
	endtask

endclass

class soft_check_packet_test extends base_test;

	`uvm_component_utils(soft_check_packet_test)

	small_virtual_sequence_reset v_seq;

	function new(string name="soft_check_packet_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		v_seq = small_virtual_sequence_reset::type_id::create("v_seq",this);
	endfunction

	task run_phase(uvm_phase phase);
//		super.run_phase(phase);
		for(int i=0;i<no_of_trans;i++)
		begin
		phase.raise_objection(this);
		v_seq.start(env.v_sqrh);
		phase.drop_objection(this);
		end
	endtask

endclass


