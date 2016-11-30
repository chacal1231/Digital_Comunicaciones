module peripheral_Datos(clk , rst , d_in , cs , addr , rd , wr, d_out);
  
  input clk;
  input rst;
  input [15:0]d_in;
  input cs;
  input [3:0]addr; // 4 LSB from j1_io_addr
  input rd;
  input wr;
  output reg [15:0]d_out;
  reg [7:0] Temp      = 8'h39;
  reg [7:0] Peso      = 8'h38;
  reg [7:0] Nluz      = 8'h37;
  reg [7:0] EtapaCre  = 8'h36;
  reg [7:0] Dagua     = 8'h35;
  reg [7:0] Nagua     = 8'h34;
  reg [7:0] Pconsu    = 8'h33;
  reg [7:0] CPoten    = 8'h32;
  reg [7:0] Tetha     = 8'h31;
  reg [7:0] Fhi       = 8'h32;


//------------------------------------ regs and wires-------------------------------
reg [9:0] s; 	//selector mux_4  and write registers



//------------------------------------ regs and wires-------------------------------




always @(*) begin//------address_decoder------------------------------
case (addr)
10'h0:begin s = (cs && rd)  ? 10'b0000000001 : 10'b0000000000 ;end  //Temp    (rd)
10'h2:begin s = (cs && rd)  ? 10'b0000000010 : 10'b0000000000 ;end  //Peso    (rd)
10'h4:begin s = (cs && rd)  ? 10'b0000000100 : 10'b0000000000 ;end  //Nluz    (rd)
10'h6:begin s = (cs && rd)  ? 10'b0000001000 : 10'b0000000000 ;end  //EtapaCre(rd)
10'h8:begin s = (cs && rd)  ? 10'b0000010000 : 10'b0000000000 ;end  //Dagua   (rd)
10'hA:begin s = (cs && rd)  ? 10'b0000100000 : 10'b0000000000 ;end  //Nagua   (rd)
10'hB:begin s = (cs && rd)  ? 10'b0001000000 : 10'b0000000000 ;end  //Pconsu  (rd)
10'hC:begin s = (cs && rd)  ? 10'b0010000000 : 10'b0000000000 ;end  //CPoten  (rd)
10'hD:begin s = (cs && rd) ? 10'b0100000000 : 10'b0000000000 ;end  //Tetha   (rd)
10'hE:begin s = (cs && rd) ? 10'b1000000000 : 10'b0000000000 ;end  //Fhi     (rd)
default:begin s = 10'b0000000000 ; end
endcase
end//------------------address_decoder--------------------------------




always @(negedge clk) begin//-------------------- escritura de registros 

end//------------------------------------------- escritura de registros




always @(*) begin//-----------------------mux_4 :  multiplexa salidas del periferico
  case (s[9:0])
      10'b0000000001: d_out[7:0] = Temp;
      10'b0000000010: d_out[7:0] = Peso;
      10'b0000000100: d_out[7:0] = Nluz;
      10'b0000001000: d_out[7:0] = EtapaCre;
      10'b0000010000: d_out[7:0] = Dagua;
      10'b0000100000: d_out[7:0] = Nagua;
      10'b0001000000: d_out[7:0] = Pconsu;
      10'b0010000000: d_out[7:0] = CPoten;
      10'b0100000000: d_out[7:0] = Tetha;
      10'b1000000000: d_out[7:0] = Fhi;
      default: d_out=0;
  endcase
end//--

endmodule