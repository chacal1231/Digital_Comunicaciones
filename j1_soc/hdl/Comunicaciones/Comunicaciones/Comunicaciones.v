// 50MHz External Clock
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

module Comunicaciones ( input wire clk,
						input wire rst,
						input wire [7:0] command,
						output wire tx,
						output reg ready_command,
						input wire str,
						output reg bussyComunicaciones = 1'b0
	);

	//Velocidad de transmision
	parameter BAUD =  `B115200;

	//Parametros estados
	reg [7:0] RegCommand 	= 0;
	reg [7:0] MemPost 		= 0;
	reg [7:0] CrrCh 		= 0;
	reg [7:0] Data 			= 0;
	reg start 				= 1'b0;
	reg [27:0] timer		= 28'd0;

	localparam IDDLE 		=	3'b000;
	localparam SAVE_COMM	= 	3'b001;
	localparam READ_MEM 	= 	3'b010;
	localparam START_SEND 	= 	3'b100;
	localparam WAIT_COMM 	= 	3'b110;
	localparam WAIT_MEM		=   3'b011;
	localparam STOP 	 	= 	3'b111;

	reg [2:0] state = IDDLE;
	reg stop;
	reg start_uart = 1'b0;

	//Memoria ROM para comandos
	reg [7:0] romMen_commandos [0:82];
	initial begin
		$readmemh("Comunicaciones/Comunicaciones/comandos.list", romMen_commandos);
	end

	//Memoria ROM para direcciones
	reg [7:0] romMen_direcciones [0:15];
	initial begin
		$readmemh("Comunicaciones/Comunicaciones/direcciones.list", romMen_direcciones);
	end
	//Instanciar UART_TX
	wire [7:0] data_send_u;
	wire ready_u;
	assign data_send_u = Data;

	uart_tx #(.BAUD(BAUD))
	  TX0 (
	    .clk(clk), //Señal de reloj matrix
	    .rstn(rst), //Reset del protocolo
	    .data(data_send_u), //Datos a enviar
	    .start(start_uart),  // Activar a 1 para transmitir
	    .ready(ready_u), // 1 para reposo (Listos para transmitir) 0 para acabar
	    .tx(tx) //-- Salida de datos serie (hacia el PC)
	  );

	always @(posedge clk, negedge rst) begin
		if(!rst)begin
			state = IDDLE;
		end else begin
			case(state)
					IDDLE: begin
						timer = 28'd100000000;
						if(str==1'b1) begin //(1)
							bussyComunicaciones = 1'b1;
							RegCommand = command;
							state=SAVE_COMM;
							start_uart = 1'b1;
							ready_command = 1'b0;
						end else begin //(0)
							ready_command = 1'b1;
							state=IDDLE;
							start_uart = 1'b0;
						end
					end
				SAVE_COMM: begin //(2)
					CrrCh = romMen_direcciones[RegCommand];
					state = READ_MEM;
				end
				READ_MEM: begin //(3)
					Data = romMen_commandos[CrrCh];
					state = START_SEND;
				end
				START_SEND: begin //(4)
					state = WAIT_COMM;
				end
				WAIT_COMM: begin 
					if(ready_u==0)begin //(5)
						state=WAIT_COMM;
					end else begin
						state = WAIT_MEM;
						end
				end
				WAIT_MEM:begin
						if(CrrCh < 8'd76)begin
							if(Data==8'h0a)begin
								if(timer>0)begin
									timer = timer - 28'd1;
									ready_command 	= 1'b1;
									start_uart 		= 1'b0;
									state 			= WAIT_MEM;		
								end else begin
									state = IDDLE;
								end
							end else begin
								CrrCh = CrrCh + 1;
								state = READ_MEM;
							end
						end else begin
							ready_command 	= 1'b1;
							state 			= STOP;
						end
				end
				STOP: begin //(7)
						bussyComunicaciones = 1'b0;
						start_uart 			= 1'b0;
						if(str == 1'b1)begin
							state = IDDLE;
						end else begin
							state = STOP;
						end
				end
				default: begin
						state 			= IDDLE;
						RegCommand		= 7'd0;
						MemPost			= 7'd0;	
						CrrCh			= 7'd0;
						Data 			= 7'd0;
						start           = 1'b0;
						start_uart 		= 1'b0;	
						timer 			= 28'd0;
				end
			endcase
		end
	end

endmodule
