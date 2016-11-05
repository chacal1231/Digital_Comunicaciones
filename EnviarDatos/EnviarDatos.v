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
	reg	[27:0] timer_2		= 28'd0;
	reg	[27:0] timer_3		= 28'd0;
	reg [7:0] numeros		= 8'd0;
	reg multip 				= 1'b0;
	reg [7:0] data_in;

//Memoria ROM para comandos
	reg [7:0] romMen_commandos [0:21];
	initial begin
		$readmemh("EnviarDatos/comandos.list", romMen_commandos);
	end

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

	localparam INIT 		= 		3'b000;
	localparam WAIT			=		3'b001;
	localparam SEND 		= 		3'b010;
	localparam SEND_DATA 	= 		3'b100;
	localparam SEND_DATA_2  =		3'b011;
	localparam STOP 		= 		3'b101;

	assign data_send = (multip) ? data_in: romMen_commandos[numeros];


always @(posedge clk or negedge rst) begin
	if (!rst) begin
	state = INIT;
	end else begin
		case(state)
				INIT: begin
					if(start==1'b1)begin
					data_in 	= datos;
					timer 		= 28'd25000000;
					timer_2 	= 28'd25000000;
					timer_3		= 28'd2500;
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
						if(numeros == 8'd19)begin
							state	= SEND_DATA;
							multip	= 1'b1;
							numeros = numeros + 8'd1;
						end else begin
							numeros 	= numeros + 8'd1;
							start_uart 	= 1'b1;
							state 		= INIT;	
						end
					end
				end
				SEND_DATA:begin
				if(timer_3>0)begin
					start_uart 	= 1'b1;
					state 		= SEND_DATA;
					timer_3 	= timer_3 - 28'd1;
				end else begin
						state		= SEND_DATA_2;
						multip 		= 1'b0;
					end		
				end
				SEND_DATA_2:begin
					if(timer_2>0) begin
						start_uart 	= 1'b0;
						timer_2 	= timer_2 - 28'd1;
					end else begin
					if(numeros<8'd21)begin
						start_uart 	= 1'b1;
						timer_2 	= 28'd25000000;
						numeros 	= numeros + 8'd1;
						state 		= SEND_DATA_2;
					end else begin
						state = STOP;
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