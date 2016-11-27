module peripheral_Comunicaciones(clk , rst , d_in , cs , addr , rd , wr, d_out, tx, ledout);
  
  input clk;
  input rst;
  input [15:0]d_in;
  input cs;
  input [3:0]addr; // 4 LSB from j1_io_addr
  input rd;
  input wr;
  output reg [15:0]d_out;
  output tx;
  output reg ledout=0;

//------------------------------------ regs and wires-------------------------------

reg [5:0] s; 	//selector mux_4  and write registers

reg [7:0] dato_in=0;//---mult_32 input registers
reg [7:0] comando_in=0;
reg init=0;
reg start=0;

wire [31:0] pp;	//mult_32 output Regs
wire done, tx, c_bussy;


//------------------------------------ regs and wires-------------------------------




always @(*) begin//------address_decoder------------------------------
case (addr)
4'h0:begin s = (cs && wr) ? 6'b000001 : 6'b000000 ;end //start
4'h2:begin s = (cs && wr) ? 6'b000010 : 6'b000000 ;end //dato
4'h4:begin s = (cs && wr) ? 6'b000100 : 6'b000000 ;end //comando

4'h6:begin s = (cs && rd) ? 6'b001000 : 6'b000000 ;end  //bussy
4'h8:begin s = (cs && rd) ? 6'b010000 : 6'b000000 ;end //ledout
default:begin s = 6'b000000 ; end
endcase
end//------------------address_decoder--------------------------------




always @(negedge clk) begin//-------------------- escritura de registros 
start       = (s[0]) ? d_in[0] :   start;
dato_in   	= (s[1]) ? d_in[7:0] : 	dato_in;	//Write Registers
comando_in	= (s[2]) ? d_in[7:0] : 	comando_in;	//Write Registers
ledout		=   (s[3]) ? d_in[0] : 	ledout;

//init = (s[2]) ? d_in : init;	//Write Registers

end//------------------------------------------- escritura de registros




always @(*) begin//-----------------------mux_4 :  multiplexa salidas del periferico
case (s[5:3])
3'b001: d_out[0] = c_bussy;
default: d_out   = 0 ;
endcase
end//-----------------------------------------------mux_4



TOP EnviarDatosWIFI(.clk(clk), .rst(rst), .tx(tx), .datos(dato_in), .comando(comando_in), .bussy(c_bussy), .start_j1(start));

endmodule