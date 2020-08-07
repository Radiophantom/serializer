module serializer(

	// Тактовый сигнал
	input 			clk_i,

	// Синхронный сброс
	input 			srst_i,

	// Входные данные
	input 			data_val_i,
	input [3:0] 	data_mod_i,
	input [15:0] 	data_i,

	// Выходные данные
	output logic 	ser_data_o,
	output logic 	ser_data_val_o,
	output logic 	busy_o
);

//-----------------------------------------
//	Variables declaration
//-----------------------------------------

	logic [15:0] ser_data;
	logic [3:0]  ser_data_cnt;
	logic 		 valid_transfer;

//-----------------------------------------
//	User logic
//-----------------------------------------

	// Запрос удовлетворяет условиям по длине передаваемого сообщения
	assign valid_transfer = (data_val_i && (data_mod_i >= 3));

	// Назначение выхода сдвигового регистра на выход данных схемы
	assign ser_data_o = ser_data[15];

	always_ff @(posedge clk_i)begin
		if(srst_i)begin
			busy_o <= 0;
		end else begin
			if(valid_transfer)begin
				busy_o <= 1;
			end else if(ser_data_cnt == 0)begin
				busy_o <= 0;
			end
		end
	end

	always_ff @(posedge clk_i)begin
		if(srst_i) begin
			ser_data_cnt <= 0;
		end else begin
			if(valid_transfer)begin
				ser_data_cnt <= data_mod_i - 1;
			end else if(ser_data_cnt !== 0)begin
				ser_data_cnt <= ser_data_cnt - 1;
			end
		end
	end

	always_ff @(posedge clk_i)begin
		if(srst_i) begin
			ser_data <= 0;
		end else begin
			if(valid_transfer)begin
				ser_data <= data_i;
			end else if(ser_data_cnt !== 0)begin
				ser_data <= ser_data << 1;
			end
		end
	end

	always_ff @(posedge clk_i)begin
		if(srst_i) begin
			ser_data_val_o <= 0;
		end else begin
			if(valid_transfer)begin
				ser_data_val_o <= 1;
			end else if(ser_data_cnt == 0)begin
				ser_data_val_o <= 0;
			end
		end
	end

endmodule : serializer