module TOP( clk,
			tx);

input clk;
output tx;
wire [2:0] command_in;
wire ready_command1, start_datos;
reg [7:0] datos = 8'b00110001;
reg [7:0] comando = 8'd9;

wire rst,start,tx_1,tx_2;
assign rst = 1'b1;


//Instanciar módulo control
Control control1(	.clk(clk), 
					.rst(rst), 
					.command_1(command_in), 
					.start(start), 
					.ready_command(ready_command1),
					.start_datos(start_datos)
				); 

//Instanciar módulo comunicaciones
Comunicaciones com1(.clk(clk), 
					.rst(rst), 
					.command({5'd0,command_in}), 
					.tx(tx_1), 
					.ready_command(ready_command1), 
					.str(start)
				);

EnviarDatos envi(	.clk(clk),
					.rst(rst),
					.start(start_datos),
					.datos(datos),
					.tx(tx_2),
					.comm_in(comando)
				);
//Multiplexor 2-1 para controlar TX
assign tx = (start_datos) ? tx_2: tx_1;

endmodule