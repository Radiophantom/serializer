module serializer (
  input                 clk_i,
  input                 srst_i,

  input                 data_val_i,
  input         [3:0]   data_mod_i,
  input         [15:0]  data_i,

  output logic          ser_data_o,
  output logic          ser_data_val_o,

  output logic          busy_o
);

logic [15:0] ser_data;
logic [3:0]  ser_data_cnt;

logic        valid_transfer;

assign valid_transfer = ( data_val_i && ( data_mod_i >= 3 ) );
assign ser_data_o     = ser_data[15];

always_ff @( posedge clk_i )
  if( srst_i )
    busy_o <= 0;
  else if( valid_transfer )
    busy_o <= 1;
  else if( ser_data_cnt == 0 )
    busy_o <= 0;

always_ff @( posedge clk_i )
  if( srst_i )
    ser_data_cnt <= 0;
  else if( valid_transfer )
    ser_data_cnt <= data_mod_i - 1;
  else if( ser_data_cnt !== 0 )
    ser_data_cnt <= ser_data_cnt - 1;

always_ff @( posedge clk_i )
  if( srst_i )
    ser_data <= 0;
  else if( valid_transfer )
    ser_data <= data_i;
  else if( ser_data_cnt !== 0 )
    ser_data <= ser_data << 1;

always_ff @( posedge clk_i )
  if( srst_i )
    ser_data_val_o <= 0;
  else if( valid_transfer )
    ser_data_val_o <= 1;
  else if( ser_data_cnt == 0 )
    ser_data_val_o <= 0;

endmodule : serializer