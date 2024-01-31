interface read_interface(input bit clock);
	logic read_enb;
	logic vld_out;
	logic [7:0]data_out;

	clocking rd_drv_cb@(posedge clock);
		default input #1 output #1;
		output read_enb;
		input vld_out;
	endclocking

	clocking rd_mon_cb@(posedge clock);
		default input #1 output #1;
			input read_enb;
			input vld_out;
			input data_out;
	endclocking

	modport RD_DRV(clocking rd_drv_cb);
	modport RD_MON(clocking rd_mon_cb);

endinterface


