module Control(	input wire clk,
				input wire rst,
				output reg [2:0] command_1,
				output reg start,
				input wire ready_command,
				output reg start_datos = 1'b0,
				input wire start_in,
				input wire bussy_e,
				input wire bussyComunicaciones
			  );

reg [27:0] timer;
reg [10:0]  timer2;

//Parametros maquina de estados
localparam S_WSTART		= 	4'b0000;
localparam S_INIT		=  	4'b0001;
localparam S_SEND 		= 	4'b0010;
localparam S_WAITCOM 	= 	4'b0100;
localparam S_TIMER 		= 	4'b1000;
localparam S_WAITBUSSYC	=	4'b0011;
localparam S_WAITD		=   4'b1100;

reg [3:0] state = S_WSTART;


always @(posedge clk or negedge rst) begin
	if (!rst) begin
		state = S_WSTART;
	end else begin
		case(state)
			S_WSTART:begin
				if(start_in==1'b1)begin
					command_1	= 3'b0;
					state 		= S_INIT;
				end else begin
					state = S_WSTART;
				end
			end
			S_INIT: begin
				start_datos = 1'b0;
				timer 		= 28'd100000000;
				timer2		= 11'd2000;
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
						start 		= 1'b0;
						state		= S_WAITBUSSYC;
					end else begin
						state = S_INIT;
						command_1 = command_1 + 1;
					end
					
				end
			end
			S_WAITBUSSYC:begin
				if(bussyComunicaciones==1'b0)begin
					if(timer2>0)begin
						start_datos	= 1'b1;
						timer2		= timer2 - 11'd1;
						state		= S_WAITBUSSYC;
					end else begin
						state = S_WAITD;
					end
				end else begin
					state = S_WAITBUSSYC;
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
				state 		= S_WSTART;
				timer 		= 28'd0;
				command_1	= 3'd0;
				start 		= 1'b0;
			end
		endcase
	end
end
endmodule
