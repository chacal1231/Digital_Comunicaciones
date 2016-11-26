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
					output wire tx,
					input wire [7:0] comm_in,
					output reg bussy_e = 1'b0
					);

//Velocidad de transmision
	parameter BAUD 			= `B115200;
	reg start_uart 			= 1'b0;
	reg [3:0] state 		= INIT;
	wire [7:0] data_send;
	wire ready_u;
	reg [27:0] timer		= 28'd0;
	reg	[27:0] timer_2		= 28'd0;
	reg	[27:0] timer_3		= 28'd0;
	reg	[27:0] timer_4		= 28'd0;
	reg [27:0] timer_5		= 28'd0;
	reg [27:0] timer_6		= 28'd0;
	reg [7:0] numeros		= 8'd0;
	reg multip 				= 1'b0;
	reg [7:0] data_in;

//Memoria ROM para comandos
	reg [7:0] romMen_commandos [0:30];
	initial begin
		$readmemh("Comunicaciones/EnviarDatos/comandos.list", romMen_commandos);
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

	localparam INIT 		= 		4'b0000; //1
	localparam WAIT			=		4'b0010;	//2
	localparam SEND 		= 		4'b0011; //3
	localparam SEND_DATA 	= 		4'b0100;	//4
	localparam SEND_DATA_2  =		4'b0101;	//5
	localparam SEND_DATA_3 	=		4'b0110;	//6
	localparam STOP 		= 		4'b0111;	//7
	localparam DATA_MED		=		4'b1000;

	assign data_send = (multip) ? data_in: romMen_commandos[numeros];


always @(posedge clk or negedge rst) begin
	if (!rst) begin
	state = INIT;
	end else begin
		case(state)
				INIT: begin
					if(start==1'b1)begin
					bussy_e		= 1'b1;
					data_in 	= datos;
					timer 		= 28'd25000000;
					timer_2 	= 28'd25000000;
					timer_3		= 28'd4000;
					timer_4		= 28'd2500;
					timer_5		= 28'd2500;
					timer_6     = 28'd2500;
					start_uart 	= 1'b0;
					state		= WAIT;
				end else begin
						state 		= INIT;
						start_uart 	= 1'b0;
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
						if(numeros == 8'd14)begin
							state	= SEND_DATA;
							multip	= 1'b0;
							numeros = numeros + 8'd1;
						end else begin
							numeros 	= numeros + 8'd1;
							start_uart 	= 1'b1;
							state 		= INIT;	
						end
					end
				end
				SEND_DATA:begin
					case(comm_in)
					8'd0:begin
						if(timer_4>0)begin
						start_uart 	= 1'b1;
						state 		= SEND_DATA;
						timer_4 	= timer_4 - 28'd1;
						end else begin
						start_uart	= 1'b1;
						numeros		= 8'd25;
						state		= DATA_MED;
						end
					end
					8'd1:begin
						numeros = 8'd16;
						if(timer_4>0)begin
						start_uart 	= 1'b1;
						state 		= SEND_DATA;
						timer_4 	= timer_4 - 28'd1;
						end else begin
						start_uart	= 1'b1;
						numeros		= 8'd25;
						state		= DATA_MED;
						end
					end
					8'd2:begin
						numeros = 8'd17;
						if(timer_4>0)begin
						start_uart 	= 1'b1;
						state 		= SEND_DATA;
						timer_4 	= timer_4 - 28'd1;
						end else begin
						start_uart	= 1'b1;
						numeros		= 8'd25;
						state		= DATA_MED;
						end
					end
					8'd3:begin
						numeros = 8'd18;
						if(timer_4>0)begin
						start_uart 	= 1'b1;
						state 		= SEND_DATA;
						timer_4 	= timer_4 - 28'd1;
						end else begin
						start_uart	= 1'b1;
						numeros		= 8'd25;
						state		= DATA_MED;
						end
					end
					8'd4:begin
						numeros = 8'd19;
						if(timer_4>0)begin
						start_uart 	= 1'b1;
						state 		= SEND_DATA;
						timer_4 	= timer_4 - 28'd1;
						end else begin
						start_uart	= 1'b1;
						numeros		= 8'd25;
						state		= DATA_MED;
						end
					end
					8'd5:begin
						numeros = 8'd20;
						if(timer_4>0)begin
						start_uart 	= 1'b1;
						state 		= SEND_DATA;
						timer_4 	= timer_4 - 28'd1;
						end else begin
						start_uart	= 1'b1;
						numeros		= 8'd25;
						state		= DATA_MED;
						end
					end
					8'd6:begin
						numeros = 8'd21;
						if(timer_4>0)begin
						start_uart 	= 1'b1;
						state 		= SEND_DATA;
						timer_4 	= timer_4 - 28'd1;
						end else begin
						start_uart	= 1'b1;
						numeros		= 8'd25;
						state		= DATA_MED;
						end
					end
					8'd7:begin
						numeros = 8'd22;
						if(timer_4>0)begin
						start_uart 	= 1'b1;
						state 		= SEND_DATA;
						timer_4 	= timer_4 - 28'd1;
						end else begin
						start_uart	= 1'b1;
						numeros		= 8'd25;
						state		= DATA_MED;
						end
					end
					8'd8:begin
						numeros = 8'd23;
						if(timer_4>0)begin
						start_uart 	= 1'b1;
						state 		= SEND_DATA;
						timer_4 	= timer_4 - 28'd1;
						end else begin
						start_uart	= 1'b1;
						numeros		= 8'd25;
						state		= DATA_MED;
						end
					end
					8'd9:begin
						numeros = 8'd24;
						if(timer_4>0)begin
						start_uart 	= 1'b1;
						state 		= SEND_DATA;
						timer_4 	= timer_4 - 28'd1;
						end else begin
						start_uart	= 1'b1;
						numeros		= 8'd25;
						state		= DATA_MED;
						end
					end
					endcase
				end
				DATA_MED:begin
				if(timer_5>0)begin
					start_uart = 1'b1;
					timer_5	   = timer_5 - 28'd1;
					end else begin
						state		= SEND_DATA_2;
						start_uart	= 1'b0;
					end	
				end
				SEND_DATA_2:begin
				if(timer_3>0)begin
					start_uart 	= 1'b1;
					multip 		= 1'b1;
					state 		= SEND_DATA_2;
					timer_3 	= timer_3 - 28'd1;
				end else begin
						numeros 	= 8'd26;
						state		= SEND_DATA_3;
						multip 		= 1'b0;
					end		
				end
				SEND_DATA_3:begin
					if(timer_2>0) begin
						start_uart 	= 1'b0;
						timer_2 	= timer_2 - 28'd1;
					end else begin
					if(numeros<8'd27)begin
						start_uart 	= 1'b1;
						timer_2 	= 28'd25000000;
						numeros 	= numeros + 8'd1;
						state 		= SEND_DATA_3;
					end else begin
						state = STOP;
					end		
				end
					
				end
				STOP:begin
					start_uart	= 1'b0;
					numeros		= 8'd0;
					if(timer_6>0)begin
						bussy_e	 	= 1'b0;
						timer_6		= timer_6 - 28'd1;
						state		= STOP;
					end else begin
						state 		= INIT;
					end
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