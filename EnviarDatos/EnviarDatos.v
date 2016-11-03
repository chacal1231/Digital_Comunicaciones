`define B115200 434
`define B57600  868
`define B38400  1302
`define B19200  2604
`define B9600   5208
`define B4800   10417
`define B2400   20833
`define B1200   41667
`define B600    83333
`define B300    166667

module EnviarDatos(	input wire clk,
					input wire rst,
					input wire start,
					input wire [7:0] datos,
					output wire tx
					);

//Velocidad de transmision
	parameter BAUD 			= `B115200;
	reg start_uart 			= 1'b0;
	reg [2:0] state 		= INIT;
	wire [7:0] data_send;
	wire ready_u;
	reg [27:0] timer		= 28'd0;
	reg [7:0] numeros 		= 8'h30;

assign data_send = numeros;
//Instanciar UART
uart_tx #(.BAUD(BAUD))
	  TX0 (
	    .clk(clk), //Señal de reloj matrix
	    .rstn(rst), //Reset del protocolo
	    .data(data_send), //Datos a enviar
	    .start(start_uart),  // Activar a 1 para transmitir
	    .ready(ready_u), // 1 para reposo (Listos para transmitir) 0 para acabar
	    .tx(tx) //-- Salida de datos serie (hacia el PC)
	  );

	localparam INIT 	= 		3'b000;
	localparam WAIT		=		3'b001;
	localparam SEND 	= 		3'b010;
	localparam STOP 	= 		3'b100;

	


always @(posedge clk or negedge rst) begin
	if (!rst) begin
	state = INIT;
	end else begin
		case(state)
				INIT: begin
					if(start==1'b1)begin
					timer 		= 28'd25000000;
					state		= WAIT;
					start_uart 	= 1'b0;
				end else begin
						state = INIT;
						start_uart = 1'b0;
					end
				end
				WAIT:begin
					if(ready_u==0)begin
						state = WAIT;
					end else begin
						state = SEND;
					end
				end
				SEND: begin
					if(timer>0)begin
						timer 		= timer - 28'd1;
					end else begin
						if(numeros == 8'h39)begin
							state	= STOP;
						end else begin
							start_uart 	= 1'b1;
							numeros 	= numeros + 8'd1;
							state 		= INIT;	
						end
					end
				end
				STOP:begin
					start_uart	= 1'b0;
				end					
				default:begin
					state 		= INIT;
					start_uart	= 1'b0;
					numeros 	= 8'd0; 
				end
		endcase
	end
end
endmodule