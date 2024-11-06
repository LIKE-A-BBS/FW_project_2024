module transmitter 
#(
    parameter   BW = 40,                // Payload bits
    parameter   CRC_BW = 8              // CRC bit
)
(
    output reg  [BW+CRC_BW-1:0] out,
    input       [BW-1:0] in,
    input       clk, rstn
);

    wire [BW+CRC_BW-1:0] out_t;
    wire [CRC_BW-1:0] CRC;
    reg [BW-1:0] in_d;

    CRC C1 (.CRC(CRC), .in({in_d, {(CRC_BW){1'b0}}}));

    assign out_t = {in_d, CRC};

    always @(posedge clk ) begin
    if (rstn != 1'b1) begin
        out     <= {(BW+CRC_BW){1'b0}};
        in_d    <= {(BW){1'b0}};
    end else begin
        out     <= out_t;
        in_d    <= in;
    end
end

endmodule