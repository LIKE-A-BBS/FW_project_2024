module CRC_3b
#(
    parameter   BW = 4,
    parameter   CRC_BW = 3,
    parameter   divisor = 3'b011
)
(
    output      [CRC_BW-1:0] CRC,
    input       [BW+CRC_BW-1:0] in
);
    wire [CRC_BW-1:0] t1, t2, t3, t4;

    CRC_unit u1 (.out(t1), .in(in[5:3]), .CRC(divisor), .sel(in[6]));
    CRC_unit u2 (.out(t2), .in({t1[1:0], in[2]}), .CRC(divisor), .sel(t1[2]));
    CRC_unit u3 (.out(t3), .in({t2[1:0], in[1]}), .CRC(divisor), .sel(t2[2]));
    CRC_unit u4 (.out(t4), .in({t3[1:0], in[0]}), .CRC(divisor), .sel(t3[2]));

    
    assign CRC = t4;
endmodule