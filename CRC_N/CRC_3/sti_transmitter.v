module sti_transmitter
#(
    parameter   BW = 4,
    parameter   CRC_BW = 3,
	parameter 	N = 100
);

	reg 						clk, rstn;
    reg 		[BW-1:0] 		mat_in 	[0:N-1];
	reg 		[BW+CRC_BW-1:0] mat_out [0:N-1];
	reg 		[BW+CRC_BW-1:0] out_mat;
	reg 		[BW-1:0] 		in;
    wire 		[BW+CRC_BW-1:0] out;

	integer i=0, j=0;
	integer err=0;
    
	always #5 clk <= ~clk;

	transmitter send (.out(out), .in(in), .clk(clk), .rstn(rstn));
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
			#(10);
			if (out_mat != out) err = err + 1;
		end
	end

endmodule

