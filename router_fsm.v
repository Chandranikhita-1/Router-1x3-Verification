module router_fsm(input clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_pkt_valid,input[1:0]data_in, output write_enb_reg,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,busy);

parameter decode_address    =3'b000,  //s0
	  load_first_data   =3'b001,  //s1
	  load_data         =3'b010,  //s2
	  fifo_full_state   =3'b011,  //s3
	  load_after_full   =3'b100,  //s4
	  load_parity       =3'b101,  //s5
	  check_parity_error=3'b110,  //s6
	  wait_till_empty   =3'b111;  //s7

reg [2:0]ps,ns;
reg[1:0]temp;

//input data (temp) logic
always@(posedge clock)
begin
	if(!resetn)
		temp<=0;
	else
		temp<=data_in;
end

//reset logic
always@(posedge clock)
begin
	if(!resetn)
		ps<=decode_address;
	else if((soft_reset_0 &&(temp==2'b00)) || (soft_reset_1 &&(temp==2'b01)) || (soft_reset_2 &&(temp==2'b10)))
		ps<=decode_address;
	else
		ps<=ns;
end

//start writing state logic
always@(*)
begin
	ns=ps;
	case(ps)
		decode_address:begin
			if((pkt_valid  && (temp==2'b00) && fifo_empty_0) || (pkt_valid  && (temp==2'b01) && fifo_empty_1) || (pkt_valid  && (temp==2'b10) && fifo_empty_2))
				ns=load_first_data;
			else if((pkt_valid  && (temp==2'b00) && !fifo_empty_0) || (pkt_valid  && (temp==2'b01) && !fifo_empty_1) || (pkt_valid  && (temp==2'b10) && !fifo_empty_2))
				ns=wait_till_empty;
			else
				ns=decode_address;
		end

		load_first_data:begin
			ns=load_data;
		end

		load_data:begin
			if(fifo_full)
				ns=fifo_full_state;
			else
			begin
				if(!fifo_full && !pkt_valid)
					ns=load_parity;
				else
					ns=load_data;
			end
		end

		fifo_full_state:begin
			if(!fifo_full)
				ns=load_after_full;
			else
				ns=fifo_full_state;
		end

		load_after_full:begin
			if(!parity_done && low_pkt_valid)
				ns=load_parity;
			else if(!parity_done && !low_pkt_valid)
				ns=load_data;
			else if(parity_done)
				ns=decode_address;
			else
				ns=load_after_full;
		end
		
		load_parity:begin
			ns=check_parity_error;
		end

		check_parity_error:begin
			if(fifo_full)
				ns=fifo_full_state;
			else
				ns=decode_address;
		end

		wait_till_empty:begin
			if((fifo_empty_0 && (temp==2'b00)) || (fifo_empty_1 && (temp==2'b01)) || (fifo_empty_2 && (temp==2'b10)))
				ns=load_first_data;
			else
				ns=wait_till_empty;
		end
	endcase
end

assign detect_add = (ps==decode_address) ? 1'b1 : 1'b0;
assign lfd_state  = (ps==load_first_data) ? 1'b1 : 1'b0;
assign ld_state   = (ps==load_data) ? 1'b1 : 1'b0;
assign busy = ((ps==load_first_data) || (ps==load_parity) || (ps==fifo_full_state) || (ps==load_after_full) ||(ps==wait_till_empty) || (ps==check_parity_error)) ? 1'b1 : 1'b0;

//assign busy = ((ps==load_first_data)|| (ps==fifo_full_state) ||(ps==wait_till_empty) || (ps==check_parity_error)) ? 1'b1 : 1'b0;

//assign busy = ((ps!=decode_address) || (ps!=load_data)) ? 1'b0 : 1'b1;

assign write_enb_reg = ((ps==load_data) || (ps==load_parity) || (ps==load_after_full)) ? 1'b1 : 1'b0;
assign full_state = (ps==fifo_full_state) ? 1'b1 : 1'b0;
assign laf_state = (ps==load_after_full) ? 1'b1 : 1'b0;
assign rst_int_reg = (ps==check_parity_error) ? 1'b1 : 1'b0;
endmodule



