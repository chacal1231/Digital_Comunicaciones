`timescale 10ns / 10ps
`define SIMULATION

module TOP_TB;
    reg clk = 1'b0, rst, str;
    reg [7:0] command;
    wire rx, tx, ready_command;

    TOP 
        inst1(rst, clk, tx, command_in);

    always #1 clk = ~clk; 

    initial begin
        #600000
        $finish;
    end

    initial begin

    end

   initial begin
     $dumpfile("TOP_TB.vcd");
     $dumpvars(-1, inst1);
   end

endmodule
