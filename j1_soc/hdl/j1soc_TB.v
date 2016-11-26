`timescale 1ns / 1ps
`define SIMULATION
// ============================================================================
// TESTBENCH FOR TINYCPU
// ============================================================================

module j1soc_TB ();

reg 	sys_clk_i, sys_rst_i;
wire  	uart_tx, uart_rx, ledout, ledControl, ledUpdate, i2c_sda, i2c_scl, c_tx, c_bussy;

assign uart_rx = uart_tx;

j1soc uut (
	sys_clk_i, sys_rst_i, //System
    //uart_tx, uart_rx, ledout,      //Uart
    //ledControl, ledUpdate, i2c_sda, i2c_scl, 
    c_tx, c_bussy //Comunicaciones
);

initial begin
  sys_clk_i   = 1;
  sys_rst_i = 1;
  #10 
  sys_rst_i = 0;
end

//always sys_clk_i = #5 ~sys_clk_i;   //100MHz
always sys_clk_i = #10 ~sys_clk_i;    //50MHz

initial begin: TEST_CASE
  $dumpfile("j1soc_TB.vcd");
  $dumpvars(-1, uut);
  #15000000 $finish;
end

endmodule
