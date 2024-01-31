module top;

	import uvm_pkg::*;
	import router_pkg::*;
	bit clock;
	always #5 clock = ~clock;
	
	write_interface w_in(clock);
	read_interface r_in0(clock);
	read_interface r_in1(clock);
	read_interface r_in2(clock);

	router_top DUV (.clock(clock),.resetn(w_in.resetn),.read_enb_0(r_in0.read_enb),.read_enb_1(r_in1.read_enb),.read_enb_2(r_in2.read_enb),.pkt_valid(w_in.pkt_valid),.data_in(w_in.data_in),.data_out_0(r_in0.data_out),.data_out_1(r_in1.data_out),.data_out_2(r_in2.data_out),.vld_out_0(r_in0.vld_out),.vld_out_1(r_in1.vld_out),.vld_out_2(r_in2.vld_out),.err(w_in.err),.busy(w_in.busy));
	

	initial
	begin
			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif

		no_of_trans=1;
		uvm_config_db#(virtual write_interface)::set(null,"*","svif_0",w_in);   //3rd argument should be same as in test class
		uvm_config_db#(virtual read_interface)::set(null,"*","vif_0",r_in0);
		uvm_config_db#(virtual read_interface)::set(null,"*","vif_1",r_in1);
		uvm_config_db#(virtual read_interface)::set(null,"*","vif_2",r_in2);

		run_test();

	end
endmodule


//module router_top(input clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,input [7:0]data_in, output [7:0]data_out_0,data_out_1,data_out_2, output vld_out_0,vld_out_1,vld_out_2,err,busy);

