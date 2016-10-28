module TOP( clk,
			tx);

input wire clk;
output wire tx;
wire [2:0] command_in;
wire ready_command1;

wire rst,start;
assign rst = 1'b1;


//Instanciar módulo control
Control control1(	.clk(clk), 
					.rst(rst), 
					.command_1(command_in), 
					.start(start), 
					.ready_command(ready_command1)
				); 

//Instanciar módulo comunicaciones
Comunicaciones com1(.clk(clk), 
					.rst(rst), 
					.command({5'd0,command_in}), 
					.tx(tx), 
					.ready_command(ready_command1), 
					.str(start)
				); 


endmodule