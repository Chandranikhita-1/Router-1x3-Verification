class write_trans extends uvm_sequence_item;

	`uvm_object_utils(write_trans)

	rand bit[7:0]header;
	rand bit[7:0]payload[];
	bit [7:0]parity;

	constraint c1{header[1:0] != 3;}  //in header address shouldn't be 3
	constraint c2{payload.size() == header[7:2];}
	constraint c3{header[7:2] !=0;}    //it means payload should be from 1 to 63 
	function new(string name="write_trans");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		//super.do_print(printer);

		// (string name , bitstream value , size , radix for printing)

		printer.print_field("header",this.header,8,UVM_DEC);

		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);

		printer.print_field("parity",this.parity,8,UVM_DEC);
	endfunction

	function void post_randomize();
		parity = 0 ^ header;
		foreach(payload[i])
			parity = parity ^ payload[i];
	endfunction 

endclass


