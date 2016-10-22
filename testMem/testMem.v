module testMem ( data, addr );

	output [7:0] data;
	input  [2:0] addr;

	//Memoria ROM para comandos
	reg [7:0] romMen_commandos [0:7];
	initial begin
		$readmemh("mem.list", romMen_commandos);
	end

	assign data = romMen_commandos[addr];

endmodule