module TOP_SAW 
#(
    parameter BW = 10
)
(
    input clk, rstn
);
    reg [BW-1:0] frame, frame_t;
    wire [1:0] ctrl;



    //Make frame

    //send frame



    //counter(timer)



    // frame temp memory
    always @(posedge clk) begin
        if ((rstn | ctrl[0]) != 1'b1) begin
            frame_t <= {(BW){1'b0}};
        end else begin
            frame_t <= frame;
        end
    end
endmodule