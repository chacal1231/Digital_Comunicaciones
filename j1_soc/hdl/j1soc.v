module j1soc#(
              //parameter   bootram_file     = "../../firmware/hello_world/j1.mem"    // For synthesis            
              parameter   bootram_file     = "../firmware/Hello_World/j1.mem",       // For simulation  
              parameter clkFreq = 50000000,
              parameter baudRateUart = 115200  
  )
  (
    sys_clk_i, sys_rst_i, //System
    //uart_tx, uart_rx, ledout,      //Uart
    //ledControl, ledUpdate, //everloop
    //i2c_sda, i2c_scl,  //i2c uv sensor
    c_tx, c_bussy//comunicaciones
    );

   input sys_clk_i;
   input sys_rst_i; 
   //input uart_rx;
   //output uart_tx, ledout;
   //output ledControl, ledUpdate;
   //inout i2c_sda, i2c_scl;
   output c_tx, c_bussy, ledout;

   //assign sys_rst_i = 1'b1;

//------------------------------------ regs and wires-------------------------------

   wire                 j1_io_rd;//********************** J1
   wire                 j1_io_wr;//********************** J1
   wire                 [15:0] j1_io_addr;//************* J1
   reg                  [15:0] j1_io_din;//************** J1
   wire                 [15:0] j1_io_dout;//************* J1
 
   reg [7:0]cs;  // CHIP-SELECT

   //wire			[15:0] mult_dout;  
   //wire			[15:0] div_dout;
   wire			[15:0] uart_dout;
   //wire			[15:0] dp_ram_dout;
   wire     [15:0] uvSensor_dout;
   wire     [15:0] Comunicaciones_dout;

//------------------------------------ regs and wires-------------------------------

  j1 #(bootram_file)  cpu0(sys_clk_i, sys_rst_i, j1_io_din, j1_io_rd, j1_io_wr, j1_io_addr, j1_io_dout);

  //peripheral_mult   per_m ( .clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[1]), 
  //                            .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(mult_dout) );

  //peripheral_div    per_d ( .clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[2]), .addr(j1_io_addr[3:0]), 
  //                            .rd(j1_io_rd), .wr(j1_io_wr), .d_out(div_dout));

  //peripheral_uart   #(.clkFreq(clkFreq), .baudRate(baudRateUart))   
               //     per_u ( .clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[3]), .addr(j1_io_addr[3:0]), 
                 //             .rd(j1_io_rd), .wr(j1_io_wr), .d_out(uart_dout), .uart_tx(uart_tx), .uart_rx(uart_rx), 
                   //           .ledout(ledout));

  //dpRAM_interface   dpRm(   .clk(sys_clk_i), .d_in(j1_io_dout), .cs(cs[4]), .addr(j1_io_addr[7:0]), .rd(j1_io_rd), 
  //                            .wr(j1_io_wr), .d_out(dp_ram_dout));

  //peripheral_gpout  gpout1( .clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[5]), .addr(j1_io_addr[3:0]), 
  //                            .wr(j1_io_wr), .gp_out0(gp_out0), .gp_out1(gp_out1));

  //peripheral_gpin   gpin1(  .clk(sys_clk_i), .rst(sys_rst_i), .cs(cs[6]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd),
  //                            .d_out(gpin1_dout), .gp_in0(gp_in0), .gp_in1(gp_in1));

  //everloop_interface ever1(.clk(sys_clk_i), .rst(sys_rst_i), .addr(j1_io_addr[7:0]), .d_in(j1_io_dout[7:0]), 
                              //.cs(cs[7]), .wr(j1_io_wr), .ledControl(ledControl), .ledUpdate(ledUpdate));

  //peripheral_uvSensor uvSensor1(.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[8]), 
                              //.addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(uvSensor_dout), 
                              //.i2c_sda(i2c_sda), .i2c_scl(i2c_scl));


  peripheral_Comunicaciones WIFI(.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout),
                                .cs(cs[2]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(Comunicaciones_dout), .tx(c_tx));  


  // ============== Chip_Select (Addres decoder) ========================  // se hace con los 8 bits mas significativos de j1_io_addr
  always @*
  begin
      case (j1_io_addr[15:8])	// direcciones - chip_select
        //8'h67:    cs= 8'b10000000; 	    //mult
        //8'h68:    cs= 8'b01000000;		  //div
        //8'h69:    cs= 8'b00100000;		  //uart
        //8'h70:    cs= 8'b00010000;		  //dp_ram
        //8'h71:    cs= 8'b00001000;      //gpout
        //8'h72:    cs= 8'b00000100;      //gpin
        //8'h73:    cs= 8'b00000010;     //everloop
        //8'h74:    cs= 8'b00000001;     //uvSensor
        8'h99:    cs= 8'b00000100;   //Comunicaciones
        default:  cs= 8'b00000000;
      endcase
  end
  // ============== Chip_Select (Addres decoder) ========================  //




  // ============== MUX ========================  // se encarga de lecturas del J1
  always @*
  begin
      case (cs)
        //8'b10000000: j1_io_din = mult_dout;       //mult
        //8'b01000000: j1_io_din = div_dout;        //div
        //8'b00100000: j1_io_din = uart_dout;       //uart
        //8'b00010000: j1_io_din = dp_ram_dout;     //dp_ram
        //8'b00001000: j1_io_din = {16{1'bX}};      //gpout
        //8'b00000100: j1_io_din = gpin1_dout;      //gpin
        //8'b00000010: j1_io_din = {16{1'bX}};      //everloop
        //8'b00000001: j1_io_din = uvSensor_dout;      //uvSensor
        8'b00000100: j1_io_din = Comunicaciones_dout;
        default:   j1_io_din = {16{1'bX}};
      endcase
  end
 // ============== MUX ========================  // 

endmodule // top
