class write_sequence extends uvm_sequence#(write_trans);

	`uvm_object_utils(write_sequence)

	bit[1:0]addr;

	function new(string name = "write_sequence");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal(get_type_name(),"plz set it in the test build_phase")
	endtask

endclass

class small_packet extends write_sequence;
	`uvm_object_utils(small_packet)
	
	function new(string name = "small_packet");
		super.new(name);
	endfunction

	task body();
		super.body();
		//repeat(2)
		//for(int i=0;i<no_of_trans;i++)
		begin
			req = write_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {header[7:2] inside {[1:15]}; header[1:0]==addr;});
			//assert(req.randomize with {header[7:2] ==3 ; header[1:0]==addr;});
			//req.print();
			//`uvm_info(get_type_name,$sformatf("sequence output \n%s",req.sprint()),UVM_LOW)
			`uvm_info(get_type_name,req.sprint(),UVM_LOW)
			finish_item(req);
		end
	endtask
endclass

class medium_packet extends write_sequence;
	`uvm_object_utils(medium_packet)
	
	function new(string name = "medium_packet");
		super.new(name);
	endfunction

	task body();
		super.body();
		//repeat(2)
		//for(int i=0;i<no_of_trans;i++)
		begin
			req = write_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {header[7:2] inside {[16:32]}; header[1:0]==addr;});
			//req.print();
			//`uvm_info(get_type_name,$sformatf("sequence output \n%s",req.sprint()),UVM_LOW)
			`uvm_info(get_type_name,req.sprint(),UVM_LOW)
			finish_item(req);
		end
	endtask
endclass


class large_packet extends write_sequence;
	`uvm_object_utils(large_packet)
	
	function new(string name = "large_packet");
		super.new(name);
	endfunction

	task body();
		super.body();
		//repeat(2)
		//for(int i=0;i<no_of_trans;i++)
		begin
			req = write_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {header[7:2] inside {[33:63]}; header[1:0]==addr;});
			//req.print();
			//`uvm_info(get_type_name,$sformatf("sequence output \n%s",req.sprint()),UVM_LOW)
			`uvm_info(get_type_name,req.sprint(),UVM_LOW)
			finish_item(req);
		end
	endtask
endclass

