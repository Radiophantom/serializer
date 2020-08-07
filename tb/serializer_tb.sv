`timescale 1ns / 1ps

module serializer_tb;

	bit clk_i = 0;
	bit srst_i = 0;

	always #5 clk_i = ~clk_i;

	// interconnect variables declaration
	logic 		 data_val_i;
	logic [3:0]  data_mod_i;
	logic [15:0] data_i;

	logic 		 ser_data_o;
	logic 		 ser_data_val_o;
	logic 		 busy_o;

	// Module instantiation
	serializer DUT(
		.clk_i(clk_i),
		.srst_i(srst_i),
		.*
	);

	// Task for sending message
	task automatic send_msg(input logic[3:0] data_length);

		@(posedge clk_i);
			data_mod_i = data_length;
			data_i = $urandom;
			data_val_i = 1;
		@(posedge clk_i);
			data_val_i = 0;
		@(posedge clk_i);
			wait(!busy_o);

	endtask

	// Test programm
	initial begin

		// inputs initialization
		data_val_i = 0;
		data_mod_i = 0;
		data_i = 0;

		#10;
		@(posedge clk_i);
			srst_i = 1;
		@(posedge clk_i);
			srst_i = 0;

		#50;

		for(int i = 0; i < 16; i++)begin
			send_msg(i);
		end

		#10;
		$stop();
	end

endmodule : serializer_tb