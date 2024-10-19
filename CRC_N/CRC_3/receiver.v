module receiver 
#(
    parameter   BW = 4,
    parameter   CRC_BW = 3,
    parameter   divisor = 4'b1011
)
(
    output reg  [BW-1:0] out,
    input       [BW+CRC_BW-1:0] in,
    input       clk, rstn
);

    reg [BW-1:0] out_t;
    wire [CRC_BW-1:0] CRC;
    reg [BW+CRC_BW-1:0] in_d;

    CRC_3b C1 (.CRC(CRC), .in(in_d));

    always @(*) begin
        if (CRC == {(CRC_BW){1'b0}}) begin
            out_t = in_d[BW+CRC_BW-1:CRC_BW];
        end else begin
            out_t = {(BW){1'b0}};
        end
    end
    always @(posedge clk ) begin
        if (rstn != 1'b1) begin
            out     <= {(BW){1'b0}};
            in_d    <= {(BW+CRC_BW){1'b0}};
        end else begin
            out     <= out_t;
            in_d    <= in;
        end
    end

endmodule