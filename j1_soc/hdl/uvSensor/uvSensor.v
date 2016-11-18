module uvSensor(clk, rst, start, ready, data, i2c_scl, i2c_sda);
	input clk, rst;
	input start;
	output ready;
	output [7:0] data;
	inout i2c_scl, i2c_sda;

	wire ena, rw, busy, ack_error;
	wire [6:0] addr;

	i2c_master i2c1(clk, rst, ena, addr, rw, 8'b0, busy, data, 
		ack_error, i2c_sda, i2c_scl);

	control fsm1(clk, rst, addr, ena, rw, busy, start, ready);

endmodule

