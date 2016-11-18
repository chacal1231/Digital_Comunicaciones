module peripheral_uart(clk , rst , d_in , cs , addr , rd , wr, d_out,  uart_tx, uart_rx, ledout );

  parameter clkFreq = 100000000;
  parameter baudRate = 115200;
  
  input clk;
  input rst;
  input [15:0]d_in;
  input cs;
  input [3:0]addr; // 4 LSB from j1_io_addr
  input rd;
  input wr;
  input uart_rx;
  output reg [15:0]d_out;

  output uart_tx;
  output reg ledout=0;

  //------------------------------------ regs and wires-------------------------------

  reg [4:0] s; 	//selector mux_4  and demux_4

  reg [7:0] d_in_uart; // data in uart

  wire uart_busy;  // out_uart

  wire rcv;
  reg reg_rcv = 1'b0;
  wire [7:0] rcv_data;

  //------------------------------------ regs and wires-------------------------------

  always @(*) begin//----address_decoder------------------
    case (addr)
      4'h0:begin s = (cs && rd) ? 5'b00001 : 5'b00000 ;end //busy
      4'h2:begin s = (cs && wr) ? 5'b00010 : 5'b00000 ;end //data
      4'h4:begin s = (cs && wr) ? 5'b00100 : 5'b00000 ;end //ledout
      4'h6:begin s = (cs && rd) ? 5'b01000 : 5'b00000 ;end //data_rcv
      4'h8:begin s = (cs && rd) ? 5'b10000 : 5'b00000 ;end //flag_rcv
    default:begin s=5'b00000 ; end
    endcase
  end//-----------------address_decoder--------------------

  always @(negedge clk) begin//-------------------- escritura de registros
    d_in_uart= (s[1]) ? d_in[7:0] : d_in_uart; // data in uart
    ledout = (s[2]) ? d_in[0] : ledout;	// write ledout register
  end//------------------------------------------- escritura de registros	

  always @(negedge clk) begin//-----------------------mux_4 :  multiplexa salidas del periferico
    case (s)
      5'b00001: d_out[0] = uart_busy;	// data out uart
      5'b01000: d_out = {8'd0, rcv_data};  // data out uart
      5'b10000: d_out[0] = reg_rcv;  // data out uart
      default: d_out=0;
    endcase
  end//----------------------------------------------mux_4

  always @(negedge clk) begin
    if(!reg_rcv && rcv)
      reg_rcv = 1'b1;
    else if(s==5'b01000)
      reg_rcv = 1'b0;
    else
      reg_rcv = reg_rcv;
  end

  //(addr != 4'h4): se hace para evitar escrituras fantasma
  uart #(.clkFreq(clkFreq), .baudRate(baudRate)) 
      uart(.uart_busy(uart_busy), .uart_tx(uart_tx), .uart_wr_i(cs && wr && (addr != 4'h4) ), .uart_dat_i(d_in_uart), .sys_clk_i(clk), .sys_rst_i(rst));// System clock, 

  //wire rst_rx;
  //assign rst_rx = ~rst;

  uart_rx uart_rx1(.clk(clk), .rstn(~rst), .rx(uart_rx), .rcv(rcv), .data(rcv_data));

endmodule
