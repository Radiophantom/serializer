`timescale 1ns / 1ps

module serializer_tb;

bit clk_i  = 0;
bit srst_i = 0;

logic        data_val_i;
logic [3:0]  data_mod_i;
logic [15:0] data_i;

logic        ser_data_o;
logic        ser_data_val_o;

logic        busy_o;

serializer DUT(
  .clk_i  ( clk_i  ),
  .srst_i ( srst_i ),
  .*
);

logic current_msg[$];

task automatic send_msg( input logic[3:0] data_length );
  @( posedge clk_i );
  data_mod_i = data_length;
  data_i     = $urandom;
  data_val_i = 1;
  if( data_length >= 3 )
    for( int i = 0; i < data_length; i++ )
      current_msg.push_back( data_i[15 - i] );
  @( posedge clk_i );
  data_val_i = 0;
  @( posedge clk_i );
  wait( !busy_o );
endtask : send_msg

task automatic receive_msg();
  logic ref_bit;
  forever
    begin
      while( ser_data_val_o !== 1'b1 )
        @( posedge clk_i );
      ref_bit = current_msg.pop_front();
      if( ref_bit == ser_data_o )
        @( posedge clk_i );
      else
        begin
          $display( "Bit mismatch" );
          $display( "Expected %b bit", ref_bit );
          $display( "Received %b bit", ser_data_o );
          @( posedge clk_i );
          $stop();
        end
    end
endtask : receive_msg

always #5 clk_i = ~clk_i;

initial begin
  data_val_i = 0;
  data_mod_i = 0;
  data_i     = 0;

  @( posedge clk_i );
  srst_i = 1;
  @( posedge clk_i );
  srst_i = 0;

  fork
    receive_msg();
  join_none

  for( int i = 0; i < 16; i++ )
    send_msg( i );

  repeat(3) @( posedge clk_i );
  $display( "Test successfully passed" );
  $stop();
end

endmodule : serializer_tb