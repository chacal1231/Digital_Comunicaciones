module everloopRAM(clk, d_in, addr_wr, wr, d_out, addr_rd, rd);
  
  input clk;

  input [7:0] d_in;
  input [7:0] addr_wr;
  input wr;

  output reg [7:0] d_out=0;
  input [7:0] addr_rd;
  input rd;


  // Declare the RAM variable
  reg [7:0] ram [0:139]; // 32-bit x 8-bit RAM


always @(negedge clk)
begin

	if(wr) begin
		ram[addr_wr] <= d_in;
	end

	if (rd) begin
		d_out <= ram[addr_rd];
	end

end

endmodule
