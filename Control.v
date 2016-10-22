module Control(	input wire clk,
				input wire rst,
				output reg command_1,
				output reg start,
				input wire ready_command);

reg [1:0] command_1 = 0;

//Parametros maquina de estados
localparam S_SEND = 3'b000;
localparam S_WAITCOM = 3'b001;
localparam S_TIMER = 3'b010;


reg [2:0] state = S_SEND;

always @(posedge clk or posedge rst) begin
	if (!rst) begin
		state = S_SEND:
		case(state)
		S_SEND: begin
			if(ready_command=1'b1)begin
				state=S_SEND;
			end else begin
				state = S_WAITCOM;
			end
		end
		S_WAITCOM: begin
			if(ready_command=1'b0)begin
				state=S_WAITCOM;
			end else begin
				state=S_TIMER;
			end
		end
		S_TIMER: begin
			if()begin
			
			end
		end
		endcase
	end
	else if () begin
		
	end
end

endmodule