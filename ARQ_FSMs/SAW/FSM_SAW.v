// Mealy_machine

module FSM_SAW_transmitter
#(
    parameter x = 10,
    parameter tp = 3,        // propagation time * 2 + alpha
	parameter OUT_BW = 5
)
(
    output reg 	[3:0] 			state, next_state,
	output reg 	[OUT_BW-1:0] 	out,				// make_frame, copy, send, rst_timer, stop_timer,
	input 		[2:0] 			in,					// enable-packet, time-out bit, ACK
    input 						clk, rstn
);

	//States
	parameter S0 = 0, S1 = 1; // S0 = Ready, S1 = Blocking
    parameter S01 = 2, S02 = 3, S03 = 4;
    parameter S11 = 5, S12 = 6, S13 = 7, S14 = 8;
    /* 
    S0
    :Packet came from network layer
    Make a frame -> save a copy -> and send the frame -> Start the timer
    			S01             S02         		 S03                

    S1
    :Time-out
    Resend the saved frame -> Restart the timer
    S11                    -> S12

    :Corrupted ACK arrived
    Discard the ACK

    :Error-free ACK arrived
    Stop the timer -> Discard the saved frame
    S13            -> S14

     */

	always @(*) begin
		case (state)
			S0: begin
				if (in[2] == 1'b1) begin
					next_state <= S01;
					out <= 5'b10000;
				end
				else begin
					next_state <= S0;
					out <= {(OUT_BW){1'b0}};
				end
			end
			S01: begin
				next_state <= S02;
				out <= 5'b01000;
			end
			S02: begin
				next_state <= S03;
				out <= 5'b00100;
			end
			S03: begin
				next_state <= S1;
				out <= 5'b00010;
			end
			S1: begin
				if (in[1] == 1'b1) begin	// time out
					next_state <= S03;
					out <= 5'b00100;
				end
				else if (in[0] == 1'b1) begin
					next_state <= S11;
					out <= 5'b00001;
				end
				else begin
					next_state <= S1;
					out <= {(OUT_BW){1'b0}};
				end
			end
			S11: begin
				next_state <= S1;
				out <= 5'b00010;
			end
			
            default: begin
                    next_state <= S0;
                    out <= S0;
                end
		endcase
	end

	always @(posedge clk) begin
        if (rstn != 1'b1) begin
		    state <= S0;
	    end
	    else begin
	        state <= next_state;
	    end
	end

endmodule