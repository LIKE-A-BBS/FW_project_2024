module counter
#(
    parameter BW = 10
)
(
    output reg [BW-1:0] main,
    input clk, rstn, append_main
);
    always @(posedge clk) begin
        if (rstn != 1'b1) begin
            main <= {(BW){1'b0}}; 
        end else begin
            main <= main + append_main;
        end
    end
endmodule
// counter cnt0 (.main(), .clk(), .rstn(), .append_main());