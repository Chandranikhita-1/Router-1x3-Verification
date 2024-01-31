class virtual_sequence_base extends uvm_sequence#(uvm_sequence_item);

	`uvm_object_utils(virtual_sequence_base)

	virtual_sequencer v_sqrh;
	write_sequencer w_sqrh[];
	read_sequencer r_sqrh[];

	bit[1:0]addr;

	//sequence's handle decleration
	small_packet s_pkt;
	medium_packet m_pkt;
	large_packet l_pkt;

	read_sequence rd_seq;
	soft_reset_checking soft_rst_check;


	env_config m_cfg;

	function new(string name = "virtual_sequence");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",m_cfg))
			`uvm_fatal(get_type_name(),"plz set it in test correctly")

		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal(get_type_name(),"plz set it in the test build_phase");

			w_sqrh = new[m_cfg.write_agents];
			r_sqrh = new[m_cfg.read_agents];
		
		if(!$cast(v_sqrh,m_sequencer))
			`uvm_fatal(get_type_name(),"casting failed")
		else
			foreach(w_sqrh[i])
				w_sqrh[i] = v_sqrh.wr_sqrh[i];
			foreach(r_sqrh[i])
				r_sqrh[i] = v_sqrh.rd_sqrh[i];
	endtask
endclass


class small_virtual_sequence extends virtual_sequence_base;

	`uvm_object_utils(small_virtual_sequence)

	function new(string name="small_virtual_sequence");
		super.new(name);
	endfunction

	task body();
	//for(int i=0;i<no_of_trans;i++)
	//begin
		super.body();
		s_pkt = small_packet::type_id::create("s_pkt");
		rd_seq = read_sequence::type_id::create("rd_seq");
		fork
			begin
				for(int i=0;i<m_cfg.write_agents;i++)
					s_pkt.start(w_sqrh[i]);
			end

			/*begin
				for(int i=0;i<m_cfg.read_agents;i++)
					rd_seq.start(r_sqrh[i]);
			end*/

			begin
				if(addr == 2'b00)
					rd_seq.start(r_sqrh[0]);
				if(addr == 2'b01)
					rd_seq.start(r_sqrh[1]);
				if(addr == 2'b10)
					rd_seq.start(r_sqrh[2]);
			end

		join
	//end
	endtask

endclass


class medium_virtual_sequence extends virtual_sequence_base;

	`uvm_object_utils(medium_virtual_sequence)

	function new(string name="medium_virtual_sequence");
		super.new(name);
	endfunction

	task body();
	//for(int i=0;i<no_of_trans;i++)
	//begin
		super.body();
		m_pkt = medium_packet::type_id::create("m_pkt");
	   	rd_seq = read_sequence::type_id::create("rd_seq");
		fork
			begin
				for(int i=0;i<m_cfg.write_agents;i++)
					m_pkt.start(w_sqrh[i]);
			end
                      /*
			begin
				for(int i=0;i<m_cfg.read_agents;i++)
					rd_seq.start(r_sqrh[i]);
			end*/

			begin
				if(addr == 2'b00)
					rd_seq.start(r_sqrh[0]);
				if(addr == 2'b01)
					rd_seq.start(r_sqrh[1]);
				if(addr == 2'b10)
					rd_seq.start(r_sqrh[2]);
			end
                      
		join
	//end
	endtask

endclass


class large_virtual_sequence extends virtual_sequence_base;

	`uvm_object_utils(large_virtual_sequence)

	function new(string name="large_virtual_sequence");
		super.new(name);
	endfunction

	task body();
	//for(int i=0;i<no_of_trans;i++)
	//begin
		super.body();
		l_pkt = large_packet::type_id::create("l_pkt");
		rd_seq = read_sequence::type_id::create("rd_seq");
		fork
			begin
				for(int i=0;i<m_cfg.write_agents;i++)
					l_pkt.start(w_sqrh[i]);
			end
                     /*
			begin
				for(int i=0;i<m_cfg.read_agents;i++)
					rd_seq.start(r_sqrh[i]);
			end*/

			begin
				if(addr == 2'b00)
					rd_seq.start(r_sqrh[0]);
				if(addr == 2'b01)
					rd_seq.start(r_sqrh[1]);
				if(addr == 2'b10)
					rd_seq.start(r_sqrh[2]);
			end
                    
		join
	//end
	endtask

endclass	

class small_virtual_sequence_reset extends virtual_sequence_base;

	`uvm_object_utils(small_virtual_sequence_reset)

	function new(string name="small_virtual_sequence_reset");
		super.new(name);
	endfunction

	task body();
	//for(int i=0;i<no_of_trans;i++)
	//begin
		super.body();
		s_pkt = small_packet::type_id::create("s_pkt");
		soft_rst_check = soft_reset_checking::type_id::create("soft_rst_check");
		fork
			begin
				for(int i=0;i<m_cfg.write_agents;i++)
					s_pkt.start(w_sqrh[i]);
			end

			
			begin
				if(addr == 2'b00)
					soft_rst_check.start(r_sqrh[0]);
				if(addr == 2'b01)
					soft_rst_check.start(r_sqrh[1]);
				if(addr == 2'b10)
					soft_rst_check.start(r_sqrh[2]);
			end

		join
	//end
	endtask

endclass

