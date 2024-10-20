// Mealy_machine

module FSM_SAW_transmitter
#(
    parameter x = 10,
    parameter tp = 3        //propagation time
)
(
    output reg state, next_state,
	output reg [4:0] out,                                          // send, rst_timer, copy, discard, add_timer,
	input in,
    input clk, rstn
);

	//States
	parameter S0 = 0, S1 = 1; // S0 = Ready, S1 = Blocking
    parameter S01 = 2, S02 = 3, S03 = 4, S04 = 5;
    parameter S11 = 6, S12 = 7, S13 = 8, S14 = 9;
    /* 
    S0
    :Packet came from network layer
    Make a frame -> save a copy -> and send the frame -> Start the timer
    S01          -> S02         -> S03                -> S04

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
				if (in == 1'b1) begin
					next_state <= S1;
					out <= 1'b1;
				end
				else begin
					next_state <= S0;
					out <= S0;
				end
			end
			S1: begin
				if (in == 1'b1) begin
					next_state <= S0;
					out <= S0;
				end
				else begin
					next_state <= S1;
					out <= S1;
				end
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