module peripheral_uvSensor(clk , rst , d_in , cs , addr , rd , wr, d_out, i2c_sda, i2c_scl );
  input clk;
  input rst;
  input [15:0]d_in;
  input cs;
  input [3:0]addr; // 4 LSB from j1_io_addr
  input rd;
  input wr;
  output reg [15:0]d_out;

  inout i2c_sda;
  inout i2c_scl;

  //------------------------------------ regs and wires-------------------------------

  reg [2:0] s; 	//selector mux_4  and demux_4

  wire [7:0] uv_data;
  wire uv_ready;
  reg uv_start = 1'b0;

  //------------------------------------ regs and wires-------------------------------

  always @(*) begin//----address_decoder------------------
    case (addr)
      4'h0:begin s = (cs && wr) ? 3'b001 : 3'b000 ;end //uv_start
      4'h2:begin s = (cs && rd) ? 3'b010 : 3'b000 ;end //uv_ready
      4'h4:begin s = (cs && rd) ? 3'b100 : 3'b000 ;end //uv_data
    default:begin s=3'b000 ; end
    endcase
  end//-----------------address_decoder--------------------

  always @(negedge clk) begin//-------------------- escritura de registros
    uv_start= (s[0]) ? d_in[0] : uv_start; //uv_start
  end//------------------------------------------- escritura de registros	

  always @(negedge clk) begin//-----------------------mux_4 :  multiplexa salidas del periferico
    case (s)
      3'b010: d_out = {15'd0, uv_ready};			//uv_ready
      3'b100: d_out = {8'd0, uv_data};  	//uv_data
      default: d_out=16'd0;
    endcase
  end//----------------------------------------------mux_4

  uvSensor uvSensor1(clk, rst, uv_start, uv_ready, uv_data, i2c_scl, i2c_sda);

endmodule
