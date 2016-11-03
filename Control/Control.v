module Control(	input wire clk,
				input wire rst,
				output reg [2:0] command_1 = 3'b0,
				output reg start,
				input wire ready_command);

reg [27:0] timer;

//Parametros maquina de estados
localparam S_INIT		=  	3'b000;
localparam S_SEND 		= 	3'b001;
localparam S_WAITCOM 	= 	3'b010;
localparam S_TIMER 		= 	3'b100;

reg [2:0] state = S_INIT;

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		state = S_INIT;
	end else begin
		case(state)
			S_INIT: begin
				timer = 28'd200000000;
				start = 1'b1;
				state = S_SEND;
			end
			S_SEND: begin
				if(ready_command==1'b1) begin
					state = S_SEND;
				end else begin
					state = S_WAITCOM;
				end
			end
			S_WAITCOM: begin
					if(ready_command==1'b0) begin
						state = S_WAITCOM;
					end else begin
						state = S_TIMER;
					end		
			end
			S_TIMER: begin
				if(timer>0)begin
					timer = timer - 28'd1;
					state = S_TIMER;
				end else begin
					start = 1'b0;
					if(command_1 == 3'd3) begin
						start = 1'b0;
					end else begin
						state = S_INIT;
						command_1 = command_1 + 1;
					end
					
				end
			end
			default: begin
				state 		= S_INIT;
				timer 		= 28'd0;
				command_1	= 3'd0;
				start 		= 1'b0;
			end
		endcase
	end
end
endmodule
