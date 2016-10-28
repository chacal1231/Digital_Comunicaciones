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
`default_nettype none


module Comunicaciones ( input wire clk,
						input wire rst,
						input [7:0] command,
						output tx,
						output reg ready_command,
						input str
	);

	//Velocidad de transmision
	parameter BAUD =  `B115200;

	//Parametros estados
	parameter ready = 0;
	reg [7:0] RegCommand = 0;
	reg [7:0] MemPost = 0;
	reg [7:0] CrrCh = 0;
	reg [7:0] Data = 0;

	localparam IDDLE = 		3'b000;
	localparam SAVE_COMM = 	3'b001;
	localparam READ_MEM = 	3'b010;
	localparam START_SEND = 3'b011;
	localparam WAIT_COMM = 	3'b100;
	localparam ADD_CHAR = 	3'b101;

	reg [2:0] state = IDDLE;

	//Memoria ROM para comandos
	reg [7:0] romMen_commandos [0:127];
	initial begin
		$readmemh("Comunicaciones/comandos.list", romMen_commandos);
	end

	//Memoria ROM para direcciones
	reg [7:0] romMen_direcciones [0:15];
	initial begin
		$readmemh("Comunicaciones/direcciones.list", romMen_direcciones);
	end
	//Instanciar UART_TX
	wire [7:0] data_send_u;
	wire ready_u;
	assign data_send_u = Data;
	reg start = 0;
	
	uart_tx #(.BAUD(BAUD))
	  TX0 (
	    .clk(clk), //Señal de reloj matrix
	    .rstn(rst), //Reset del protocolo
	    .data(data_send_u), //Datos a enviar
	    .start(start),  // Activar a 1 para transmitir
	    .ready(ready_u), // 1 para reposo (Listos para transmitir) 0 para acabar
	    .tx(tx) //-- Salida de datos serie (hacia el PC)
	  );

	always @(posedge clk, posedge rst) begin
		if(!rst)begin
			state = IDDLE;
		end else begin
			case(state)
					IDDLE: begin
						if(str==1'b1) begin //(1)
							RegCommand = command;
							state=SAVE_COMM;
							ready_command = 1'b0;
						end else begin //(0)
							ready_command = 1'b1;
							state=IDDLE;
						end
					end
				SAVE_COMM: begin //(2)
					CrrCh = romMen_direcciones[RegCommand];
					state = READ_MEM;
				end
				READ_MEM: begin //(3)
					Data = romMen_commandos[CrrCh];
					start = 1;
					state = START_SEND;
				end
				START_SEND: begin //(4)
					start = 0;
					state = WAIT_COMM;
					//ready = 1;
				end
				WAIT_COMM: begin 
					if(ready_u==0)begin //(5)
						state=WAIT_COMM;
					end else begin
						if(Data==8'h0a)begin
							ready_command = 1'b1;
							state=IDDLE;
						end else begin // (6)
							CrrCh = CrrCh + 1;
							state = READ_MEM;
						end
					end
				end
				ADD_CHAR: begin //(7)
						start = 1;
						state = START_SEND;
				end
				default:
						state = IDDLE;
			endcase
		end
	end

endmodule