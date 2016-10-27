module TOP( rst,
			clk,
			tx,
			command_in);

input wire clk, rst, command_in;
output wire tx;

Comunicaciones com1(clk, rst, command, tx, ready_command, srt); //Instanciar módulo comunicaciones

Control control1(clk, rst, command_1, start, ready_command); //Instanciar módulo control
endmodule