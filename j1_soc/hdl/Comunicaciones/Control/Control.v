module Control(	input wire clk,
				input wire rst,
				output reg [2:0] command_1,
				output reg start,
				input wire ready_command,
				output reg start_datos = 1'b0,
				input wire start_in,
				input wire bussy_e,
				output reg bussy_m=1'b0);

reg [27:0] timer;

//Parametros maquina de estados
localparam S_WSTART		= 	3'b000;
localparam S_INIT		=  	3'b001;
localparam S_SEND 		= 	3'b010;
localparam S_WAITCOM 	= 	3'b100;
localparam S_TIMER 		= 	3'b110;
localparam S_WAITD		=   3'b111;

reg [2:0] state = S_WSTART;


always @(posedge clk or negedge rst) begin
	if (!rst) begin
		state = S_WSTART;
	end else begin
		case(state)
			S_WSTART:begin
				if(start_in==1'b1)begin
					bussy_m		=1'b1;
					command_1	= 3'b0;
					state 		= S_INIT;
				end else begin
					state = S_WSTART;
				end
			end
			S_INIT: begin
				start_datos = 1'b0;
				timer 		= 28'd100000000;
				start 		= 1'b1;
				state 		= S_SEND;
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
					if(command_1 > 3'd2) begin
						bussy_m		= 1'b0;
						start 		= 1'b0;
						start_datos	= 1'b1;
						state		= S_WAITD;
					end else begin
						state = S_INIT;
						command_1 = command_1 + 1;
					end
					
				end
			end
			S_WAITD:begin
				if(bussy_e==1'b0)begin
					start_datos = 1'b0;
					state = S_WSTART;
				end else begin
					state = S_WAITD;
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
