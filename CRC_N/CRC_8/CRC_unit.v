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