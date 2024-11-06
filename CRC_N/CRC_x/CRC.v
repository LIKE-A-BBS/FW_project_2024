module CRC_unit
#(
    parameter   BW = 8
)
(
    output      [BW-1:0] out,
    input       [BW-1:0] in, CRC, 
    input                sel
);

    wire [BW-1:0] temp;
    assign out = in ^ ({(BW){sel}} & CRC);
    
endmodule

module CRC
#(
    parameter   BW = 40,                // Payload bits
    parameter   CRC_BW = 8,             // CRC bit
    parameter   divisor = 8'b0000_0111  // Divisor bit (except for 1bit of LSB)
)
(
    output      [CRC_BW-1:0] CRC,
    input       [BW+CRC_BW-1:0] in
);
    wire [CRC_BW-1:0] t [0:BW-1];

    CRC_unit uu (.out(t[0]), .in(in[BW+CRC_BW-2:BW-1]), .CRC(divisor), .sel(in[BW+CRC_BW-1]));
    genvar i;
    generate
        for (i = 1; i < BW; i = i + 1) begin : gen_CRC_unit
            CRC_unit U (.out(t[i]), .in({t[i-1][CRC_BW-2:0], in[BW-1-i]}), .CRC(divisor), .sel(t[i-1][CRC_BW-1]));
        end
    endgenerate
    
    assign CRC = t[BW-1];

endmodule