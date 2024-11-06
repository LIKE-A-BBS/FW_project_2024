module TOP_SAW 
#(
    parameter PAYLOAD_BW = 10,
    parameter OUT_BW = 5,
    parameter CRC_BW = 8,
    parameter ACK_BW = 3,
    parameter CNT_BW = 5
)
(
    input [PAYLOAD_BW-1:0] payload,
    input [ACK_BW-1:0] ACK,
    input clk, rstn
);
    reg [PAYLOAD_BW+CRC_BW-1:0] frame, frame_t;
    wire [OUT_BW-1:0] ctrl;
    wire [CNT_BW-1:0] cnt;
    wire packet_in, V_ack;
    //Control
    FSM_SAW_transmitter fsm (.out(ctrl), .in({packet_in, cnt[CNT_BW-1], V_ack}), .clk(clk), .rstn(rstn));

    //Make frame
    transmitter t1(.out(frame), .in(payload), .clk(clk), .rstn(rstn));


    //send frame



    //counter(timer)
    counter cnt0 (.main(cnt), .clk(clk), .rstn(ctrl[1]), .append_main(ctrl[0]));

    // frame temp memory
    always @(posedge clk) begin
        if ((rstn | ctrl[0]) != 1'b1) begin
            frame_t <= {(PAYLOAD_BW+CRC_BW){1'b0}};
        end else begin
            frame_t <= frame;
        end
    end
endmodule