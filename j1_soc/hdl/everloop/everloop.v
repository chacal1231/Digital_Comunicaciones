module everloop(clk, rst, ledData, debugLed, memRd, memAdd, memData);
	input clk, rst;
	output reg ledData;
	output reg debugLed = 1'b0;

	output reg memRd;
	output reg [7:0] memAdd;
	input [7:0] memData;

	localparam NUM_LEDS = 35;
	localparam MAX_MEM_ADD = (NUM_LEDS*4) - 1;

	localparam TIME_H1 = 17'd30;
	localparam TIME_H0 = 17'd30;
	localparam TIME_L1 = 17'd15;
	localparam TIME_L0 = 17'd45;

	localparam TIME_RESET = 17'd100000;

	localparam S_RESET 	= 3'd0;
	localparam S_READ 	= 3'd1;
	localparam S_H_L	= 3'd2;
	localparam S_H1		= 3'd3;
	localparam S_H0		= 3'd4;
	localparam S_L1		= 3'd5;
	localparam S_L0		= 3'd6;

	reg [2:0] state = S_RESET;
	reg [19:0] timer = TIME_RESET;
	reg [2:0] bitCount = 3'd0;
	reg [7:0] dataToSend = 8'b0;

	//wire rst;
	//assign rst = 1'b0;

	//reg memRd = 1'b0;
	//reg [7:0] memAdd = 8'd0;
	//reg [7:0] memData = 8'd0;
	//reg [7:0] mem [0:MAX_MEM_ADD];
	//wire memAddWire;

	/*initial begin
		$readmemh("mem.list", mem); // memory_list is memory file
	end

	always @(negedge clk) begin
		if(memRd)
			memData = mem[memAdd];
		else
			memData = memData;
	end*/

	always @(posedge clk) begin
		if(rst) begin //(0)
			timer = TIME_RESET;
			ledData = 1'b0;
			memAdd = 8'd0;
			dataToSend = 8'b0;
			memRd = 1'b0;
			state = S_RESET;
		end else begin
			case(state)
				S_RESET: begin
					if(timer>17'd0) begin //(15)
						timer = timer - 17'd1;
						state = S_RESET;
					end else begin //(1)
						memAdd = 8'd0;
						memRd = 1'b1;
						debugLed = ~debugLed;
						state = S_READ;
					end
				end
				S_READ: begin //(2)
					bitCount = 3'b0;
					dataToSend = memData;
					memRd = 1'b0;
					state = S_H_L;
				end
				S_H_L: begin
					if(dataToSend[7]==1'b1) begin //(3)
						timer = TIME_H1;
						ledData = 1'b1;
						state = S_H1;
					end else begin //(4)
						timer = TIME_L1;
						ledData = 1'b1;
						state = S_L1;
					end
				end
				S_H1: begin
					if(timer>17'd0) begin //(5)
						timer = timer - 17'd1;
						state = S_H1;
					end else begin //(7)
						timer = TIME_H0;
						ledData = 1'b0;
						state = S_H0;
					end
				end
				S_H0: begin
					if(timer>17'd0) begin //(17)
						timer = timer - 17'd1;
						state = S_H0;
					end else begin
						if(bitCount<3'd7) begin //(9)
							bitCount = bitCount + 3'd1;
							dataToSend = {dataToSend[6:0],1'b0};
							state = S_H_L;
						end else begin
							if(memAdd<MAX_MEM_ADD) begin //(13)
								memAdd = memAdd + 8'd1;
								memRd = 1'b1;
								state = S_READ;
							end else begin //(11)
								timer = 17'd5000;
								state = S_RESET;
							end
						end
					end
				end
				S_L1: begin
					if(timer>17'd0) begin //(6)
						timer = timer - 17'd1;
						state = S_L1;
					end else begin //(8)
						timer = TIME_L0;
						ledData = 1'b0;
						state = S_L0;
					end
				end
				S_L0: begin
					if(timer>17'd0) begin //(18)
						timer = timer - 17'd1;
						state = S_L0;
					end else begin
						if(bitCount<3'd7) begin //(10)
							bitCount = bitCount + 3'd1;
							dataToSend = {dataToSend[6:0],1'b0};
							state = S_H_L;
						end else begin
							if(memAdd<MAX_MEM_ADD) begin //(14)
								memAdd = memAdd + 8'd1;
								memRd = 1'b1;
								state = S_READ;
							end else begin //(12)
								timer = 17'd1000000;
								state = S_RESET;
							end
						end
					end
				end
			endcase
		end
	end

endmodule
