module control(	clk, rst,
				addr, ena, rw, busy,
				start, ready);
	//General
	input clk, rst;
	//i2c
	output reg [6:0] addr = 7'h00;
	output reg ena = 1'b0;
	output reg rw = 1'b0;
	input busy;
	//external control
	input start;
	output reg ready = 1'b0;

	localparam S_WAIT1		= 2'b00;
	localparam S_READ_I2C	= 2'b01;
	localparam S_WAIT2_I2C	= 2'b10;

	reg [1:0] state = S_WAIT1;

	always @(posedge clk) begin
		if(rst) begin
			//(0)
			addr = 7'h00;
			rw = 1'b0;
			ena = 1'b0;
			ready = 1'd0;
			state = S_WAIT1;
		end else begin
			case(state)
				S_WAIT1: begin
					if(!start) begin
						//(1)
						ready = 1'd1;
						state = S_WAIT1;
					end else begin
						//(2)
						ready = 1'd0;
						addr = 7'h38;
						rw = 1'b1;
						ena = 1'b1;
						state = S_READ_I2C;
					end
				end
				S_READ_I2C: begin
					if(busy==1'b0) begin
						//(7)
						state = S_READ_I2C;
					end else begin
						//(8)
						ena = 1'b0;
						state = S_WAIT2_I2C;
					end
				end
				S_WAIT2_I2C: begin
					if(busy==1'b1) begin
						//(9)
						state = S_WAIT2_I2C;
					end else begin
						//(10)
						state = S_WAIT1;
					end
				end
				default: begin
					addr = 7'h00;
					rw = 1'b0;
					ena = 1'b0;
					state = S_WAIT1;
					ready = 1'd0;
				end
			endcase
		end
	end

endmodule