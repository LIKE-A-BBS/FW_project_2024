module TOP_SAW 
#(
    parameter BW = 10,
    parameter OUT_BW = 5,
    parameter CNT_BW = 5
)
(
    input clk, rstn
);
    reg [BW-1:0] frame, frame_t;
    wire [OUT_BW-1:0] ctrl;
    wire [CNT_BW-1:0] cnt;
    wire Packet, ACK;
    //Control
    FSM_SAW_transmitter fsm (.out(ctrl), .in({Packet, cnt[CNT_BW-1], ACK}), .clk(clk), .rstn(rstn));

    //Make frame
    CRC crc ();

    //send frame



    //counter(timer)
    counter cnt0 (.main(cnt), .clk(clk), .rstn(ctrl[1]), .append_main(ctrl[0]));

    // frame temp memory
    always @(posedge clk) begin
        if ((rstn | ctrl[0]) != 1'b1) begin
            frame_t <= {(BW){1'b0}};
        end else begin
            frame_t <= frame;
        end
    end
endmodule