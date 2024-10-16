module sti_transmitter
#(
    parameter   BW = 4,
    parameter   CRC_BW = 3,
	parameter 	N = 100
);

	reg 						clk, rstn;
    reg 		[BW+CRC_BW-1:0] mat_in 	[0:N-1];
	reg 		[BW+CRC_BW-1:0] mat_out [0:N-1];
	reg 		[BW+CRC_BW-1:0] mat_CRC [0:N-1];
	reg 		[BW+CRC_BW-1:0] out_mat;
	reg 		[CRC_BW-1:0] 	CRC_mat;
	reg 		[BW-1:0] in;
    wire 		[BW+CRC_BW-1:0] out;
	wire 		[CRC_BW-1:0]	CRC; 

	integer i=0, j=0;
	integer err=0;
    
	always #5 clk <= ~clk;

	sender send (.out(out), .CRC(CRC), .in(in), .clk(clk), .rstn(rstn));
	//CRC_3b f (.out(out), .CRC(CRC), .in({in, 3'b000}));
	initial
	begin
		clk = 1;
		rstn = 0;
		#12
		rstn = 1;
		// #5248 $stop;
	end

	initial
	begin
		$readmemh("input_hex.txt", mat_in);
		$readmemh("Codeword_hex.txt", mat_out);
		$readmemh("CRC_hex.txt", mat_CRC);
	end

	initial
	begin
		#(20);
		for (j=0; j<N; j=j+1) begin
			in = mat_in[j];
			#(10);
		end
	end
	initial
	begin
		#(30);		
		for (i=0; i<N; i=i+1)
		begin
			out_mat = mat_out[i];
			CRC_mat = mat_CRC[i];
			#(10);
			if (out_mat != out) err = err + 1;
		end
	end

endmodule

