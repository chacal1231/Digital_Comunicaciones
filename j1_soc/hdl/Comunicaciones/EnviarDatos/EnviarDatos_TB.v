`timescale 10ns / 10ps
`define SIMULATION

module EnviarDatos_TB;
    reg clk = 1'b0;
    wire tx;
    reg rst;
    reg start;
    reg [7:0] datos;
    wire [7:0] data_send;
    reg [7:0] numeros;
    wire comm_in;
    wire bussy_e;

    EnviarDatos 
        inst1(clk, rst, start, datos, tx, comm_in, bussy_e);

    always #1 clk = ~clk; 

    initial begin
        #100000
        $finish;
    end

    initial begin
    rst = 1'b1;
    numeros = 8'd1;
    #10
    start = 1'b1;
    end

   initial begin
     $dumpfile("EnviarDatos_TB.vcd");
     $dumpvars(-1, inst1);
   end

endmodule
