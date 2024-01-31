interface write_interface(input bit clock);
	logic resetn;
	logic [7:0]data_in;
	logic pkt_valid;
	logic err;
	logic busy;

	clocking wr_drv_cb@(posedge clock);
		default input #1 output #1;
		output resetn;
		output data_in;
		output pkt_valid;
		input err;
		input busy;
	endclocking

	clocking wr_mon_cb@(posedge clock);
		default input #1 output #1;
		input resetn;
		input data_in;
		input pkt_valid;
		input err;
		input busy;
	endclocking

	modport WR_DRV(clocking wr_drv_cb);
	modport WR_MON(clocking wr_mon_cb);
	
endinterface

