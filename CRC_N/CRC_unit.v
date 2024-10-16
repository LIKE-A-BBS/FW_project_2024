module CRC_unit
#(
    parameter   BW = 3
)
(
    output      [BW-1:0] out,
    input       [BW-1:0] in, CRC, 
    input                sel
);

    wire [BW-1:0] temp;

/*     reg [BW-1:0] mux_out;
    
    always @(*) begin
        if (sel == 1'b0) begin
            mux_out = 3'b000;
        end
        else begin
            mux_out = CRC;
        end
    end */

    assign out = in ^ {sel & CRC[2],sel & CRC[1],sel & CRC[0]};
endmodule