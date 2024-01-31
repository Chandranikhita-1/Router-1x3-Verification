class read_sequence_base extends uvm_sequence#(read_trans);
	`uvm_object_utils(read_sequence_base)
	function new(string name="read_sequence_base");
		super.new(name);
	endfunction
	
	task body();
	endtask

endclass

class read_sequence extends read_sequence_base;
	`uvm_object_utils(read_sequence)
	function new(string name="read_sequence");
		super.new(name);
	endfunction

	virtual task body();
		super.body();
		//repeat(2)
		//for(int i=0;i<no_of_trans;i++)
		begin
			req = read_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {no_of_cycles inside{[1:29]};});
		//	assert(req.randomize() with {no_of_cycles ==30;});

			//`uvm_info(get_type_name(),req.sprint(),UVM_LOW)
			finish_item(req);
		end
	endtask
endclass


class soft_reset_checking extends read_sequence_base;
	`uvm_object_utils(soft_reset_checking)
	function new(string name="soft_reset_checking");
		super.new(name);
	endfunction

	virtual task body();
		super.body();
		//repeat(2)
		//for(int i=0;i<no_of_trans;i++)
		begin
			req = read_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {no_of_cycles ==31;});
			//`uvm_info(get_type_name(),req.sprint(),UVM_LOW)
			finish_item(req);
		end
	endtask
endclass

