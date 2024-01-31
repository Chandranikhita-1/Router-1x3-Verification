class read_trans extends uvm_sequence_item;
	bit[7:0]header;
	bit[7:0]payload[];
	bit[7:0]parity;
	bit read_enb;
	bit vld_out;
	rand bit[4:0]no_of_cycles;

	`uvm_object_utils(read_trans)

	function new(string name="read_trans");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		//super.do_print(printer);

		// (string name , bitstream value , size , radix for printing)

		printer.print_field("header",this.header,8,UVM_DEC);

		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);

		printer.print_field("parity",this.parity,8,UVM_DEC);
		printer.print_field( "no_of_cycles",this.no_of_cycles,5, UVM_DEC);
		//printer.print_field( "read_enb",this.read_enb,'1, UVM_DEC);
		//printer.print_field( "vld_out",this.vld_out,'1, UVM_DEC);

	endfunction

endclass

