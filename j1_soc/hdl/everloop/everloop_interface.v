module everloop_interface(clk, rst, addr, d_in, cs, wr, ledControl, ledUpdate);
  
  input clk, rst;
  input [7:0]d_in;
  input cs;
  input [7:0]addr; // 8 LSB from j1_io_addr
  input wr;
  output ledControl, ledUpdate;

  wire memWr, memRd;
  wire [7:0] addrRd, dataRd;

  assign memWr = (cs && wr && (addr<140)) ? 1'b1 : 1'b0;
	
  everloopRAM ram1(.clk(clk), .d_in(d_in), .addr_wr(addr), .wr(memWr), 
  			.d_out(dataRd), .addr_rd(addrRd), .rd(memRd));

  everloop ever1(.clk(clk), .rst(rst), .ledData(ledControl), .debugLed(ledUpdate), 
  	.memRd(memRd), .memAdd(addrRd), .memData(dataRd));

endmodule
