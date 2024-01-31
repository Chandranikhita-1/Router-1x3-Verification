module router_reg(input clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,input[7:0]data_in,output reg err,parity_done,low_pkt_valid,output reg[7:0]dout);
reg[7:0]header,fifo_full_state,internal_parity,packet_parity;

//dout logic
always@(posedge clock)
begin
	if(!resetn)
		dout<=0;
	else if(detect_add && pkt_valid && data_in[1:0]!=3)
		dout<=dout;
	else if(lfd_state)
		dout<=header;
	else if(ld_state && !fifo_full)
		dout<=data_in;
	else if(ld_state && fifo_full)
		dout<=dout;
	else if(laf_state)
		dout<=fifo_full_state;
	else
		dout<=dout;
end

//header logic
always@(posedge clock)
begin
	if(!resetn)
		header<=8'd0;
	else if(detect_add && pkt_valid && data_in[1:0]!=3)
		header<=data_in;
	else
		header<=header;
end

//internal_parity logic
always@(posedge clock)
begin
	if(!resetn)
		internal_parity<=8'd0;
	else if(detect_add)
		internal_parity<=8'd0;
	else if(lfd_state)
		internal_parity<=internal_parity^header;
	else if(pkt_valid && ld_state && ~full_state)
		internal_parity<=internal_parity^data_in;
	else
		internal_parity<=internal_parity;
end

//packet_parity logic
always@(posedge clock)
begin
	if(!resetn)
		packet_parity<=8'd0;
	else if(detect_add)
		packet_parity<=8'd0;
	else if(~pkt_valid && ld_state)
		packet_parity<=data_in;
	else
		packet_parity<=packet_parity;
end

//fifo_full_state logic
always@(posedge clock)
begin
	if(!resetn)
		fifo_full_state<=8'd0;
	else if(ld_state && fifo_full)
		fifo_full_state<=data_in;
	else
		fifo_full_state<=fifo_full_state;
end

//low_pkt_valid logic
always@(posedge clock)
begin
	if(!resetn)
		low_pkt_valid<=1'b0;
	else if(rst_int_reg)
		low_pkt_valid<=1'b0;
	else if(ld_state && !pkt_valid)
		low_pkt_valid<=1'b1;
end

//parity_done logic
always@(posedge clock)
begin
	if(!resetn)
		parity_done<=1'b0;
	else if((ld_state && !fifo_full && !pkt_valid) || (laf_state && low_pkt_valid)) //&& !parity_done))
		parity_done<=1'b1;
	else if(detect_add)
		parity_done<=1'b0;
end

//error logic
always@(posedge clock)
begin
	if(!resetn)
		err<=1'b0;
	else if(parity_done)
	begin
		if(packet_parity !=internal_parity)
			err<=1'b1;
		else
			err<=1'b0;
	end
end
endmodule

