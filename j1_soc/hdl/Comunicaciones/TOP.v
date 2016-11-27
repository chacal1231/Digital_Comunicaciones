module TOP( clk,
			rst,
			tx,
			datos,
			comando,
			bussy,
			start_j1
			);

input clk, rst;
output tx,bussy;
wire [2:0] command_in;
wire ready_command1, start_datos, bussy, bussy_m, bussy_e, rst, start, tx_1, tx_2, bussyComunicaciones;
input wire [7:0] datos;
input wire [7:0] comando;
input wire start_j1;
reg bussy_j1 = 1'b0;
wire rst_negado;

assign rst_negado = ~rst;

assign bussy = bussy_j1;

always @(negedge clk) begin
	if(bussyComunicaciones==1'b1 || bussy_e==1'b1)begin
	bussy_j1=1'b1;
	end else begin
		bussy_j1=1'b0;
	end
end

//Instanciar módulo control
Control control1(	.clk(clk), 
					.rst(rst_negado), 
					.command_1(command_in), 
					.start(start), 
					.ready_command(ready_command1),
					.start_datos(start_datos),
					.start_in(start_j1),
					.bussy_e(bussy_e),
					.bussyComunicaciones(bussyComunicaciones)
				); 

//Instanciar módulo comunicaciones
Comunicaciones com1(.clk(clk), 
					.rst(rst_negado), 
					.command({5'd0,command_in}), 
					.tx(tx_1), 
					.ready_command(ready_command1), 
					.str(start),
					.bussyComunicaciones(bussyComunicaciones)
				);

EnviarDatos envi(	.clk(clk),
					.rst(rst_negado),
					.start(start_datos),
					.datos(datos),
					.tx(tx_2),
					.comm_in(comando),
					.bussy_e(bussy_e)
				);
//Multiplexor 2-1 para controlar TX
assign tx = (start_datos) ? tx_2: tx_1;
endmodule