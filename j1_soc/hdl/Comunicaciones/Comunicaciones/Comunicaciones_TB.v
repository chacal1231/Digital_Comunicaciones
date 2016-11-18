`timescale 10ns / 10ps
`define SIMULATION

module Comunicaciones_TB;
    reg clk = 1'b0, rst, str;
    reg [7:0] command;
    wire rx, tx, ready_command;

    Comunicaciones 
        inst1(clk, rst, command, tx,ready_command, str);

    always #1 clk = ~clk; 

    initial begin
        #600000
        $finish;
    end

    initial begin
        rst = 1'b1;
        command = 8'd0;
        #10
        str = 1'b1;
        #10
        str = 1'b0;
        #130000
        command = 8'd1;
        #10
        str = 1'b1;
        #10
        str = 1'b0;
        #70000
        command = 8'd2;
        #10
        str = 1'b1;
        #10
        str = 1'b0;
        #100000
        command = 8'd3;
        #10
        str = 1'b1;
        #10
        str = 1'b0;
        #140000
        command = 8'd4;
        #10
        str = 1'b1;
        #10
        str = 1'b0;

    end

   initial begin
     $dumpfile("Comunicaciones_TB.vcd");
     $dumpvars(-1, inst1);
   end

endmodule
