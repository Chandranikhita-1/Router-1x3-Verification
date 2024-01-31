module router_top(input clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,input [7:0]data_in, output [7:0]data_out_0,data_out_1,data_out_2, output vld_out_0,vld_out_1,vld_out_2,err,busy);
wire [2:0]write_enb;
wire [7:0]dout;

router_fsm FSM1 (clock,resetn,pkt_valid,fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_pkt_valid,data_in[1:0],write_enb_reg,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,busy);

router_sync SYNC1 (clock,resetn,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,data_in[1:0],write_enb,vld_out_0,vld_out_1,vld_out_2,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2);

router_reg REG1 (clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,data_in,err,parity_done,low_pkt_valid,dout);

router_fifo FIFO0 (.clock(clock),.resetn(resetn),.soft_reset(soft_reset_0),.write_enb(write_enb[0]),.read_enb(read_enb_0),.lfd_state(lfd_state),.data_in(dout),.full(full_0),.empty(empty_0),.data_out(data_out_0));

router_fifo FIFO1 (.clock(clock),.resetn(resetn),.soft_reset(soft_reset_1),.write_enb(write_enb[1]),.read_enb(read_enb_1),.lfd_state(lfd_state),.data_in(dout),.full(full_1),.empty(empty_1),.data_out(data_out_1));

router_fifo FIFO2 (.clock(clock),.resetn(resetn),.soft_reset(soft_reset_2),.write_enb(write_enb[2]),.read_enb(read_enb_2),.lfd_state(lfd_state),.data_in(dout),.full(full_2),.empty(empty_2),.data_out(data_out_2));

endmodule

