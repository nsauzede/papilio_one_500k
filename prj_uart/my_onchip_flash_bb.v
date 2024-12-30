module my_onchip_flash (
	clock,
	avmm_csr_addr,
	avmm_csr_read,
	avmm_csr_writedata,
	avmm_csr_write,
	avmm_csr_readdata,
	avmm_data_addr,
	avmm_data_read,
	avmm_data_writedata,
	avmm_data_write,
	avmm_data_readdata,
	avmm_data_waitrequest,
	avmm_data_readdatavalid,
	avmm_data_burstcount,
	reset_n
);
	input		clock;
	input		avmm_csr_addr;
	input		avmm_csr_read;
	input	[31:0]	avmm_csr_writedata;
	input		avmm_csr_write;
	output	[31:0]	avmm_csr_readdata;
	input	[16:0]	avmm_data_addr;
	input		avmm_data_read;
	input	[31:0]	avmm_data_writedata;
	input		avmm_data_write;
	output reg	[31:0]	avmm_data_readdata;
	output reg		avmm_data_waitrequest;
	output reg		avmm_data_readdatavalid;
	input	[1:0]	avmm_data_burstcount;
	input		reset_n;

	reg [16:0]	read_addr;
always @(posedge clock or negedge reset_n)
	if (~reset_n) begin
		avmm_data_readdata <= 32'b1;
		avmm_data_readdatavalid <= 1'b0;
		avmm_data_waitrequest <= 1'b0;
		read_addr <= 16'b0;
	end else begin
		if (~avmm_data_waitrequest) begin
			if (avmm_data_read) begin
				avmm_data_readdatavalid <= 1'b0;
				avmm_data_waitrequest <= 1'b1;
				read_addr <= avmm_data_addr;
			end
		end else begin
			avmm_data_readdata <= read_addr;
			avmm_data_readdatavalid <= 1'b1;
			avmm_data_waitrequest <= 1'b0;
		end
	end
endmodule
