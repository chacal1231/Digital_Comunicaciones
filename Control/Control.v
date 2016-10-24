module Control(	input wire clk,
				input wire rst,
				output reg [1:0] command_1,
				output reg start,
				input wire ready_command);

reg [24:0] timer = 25'd25000000;

//Parametros maquina de estados
localparam S_SEND 		= 	3'b000;
localparam S_WAITCOM 	= 	3'b001;
localparam S_TIMER 		= 	3'b010;


reg [2:0] state = S_SEND;

always @(posedge clk or posedge rst) begin
	if (!rst) begin
		state = S_SEND;
		case(state)
		S_SEND: begin
			start = 1'b1;
			command_1 = command_1 + 1;
			if(ready_command==1'b1)begin
				state = S_SEND;
			end else begin
				state = S_TIMER;
			end
		end
		S_WAITCOM: begin
				//state = S_TIMER;
		end
		S_TIMER: begin
			if(timer>0)begin
			timer = timer - 25'd1;
			state = S_TIMER;
			end else begin
				state = S_SEND;
			end
		end
		default: begin
			state = S_SEND;
		end
		endcase
	end
end

endmodule