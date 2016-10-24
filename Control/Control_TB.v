`timescale 10ns / 10ps
`define SIMULATION

module Control_TB;
    reg clk = 1'b0, rst, ready_command;
    wire command_1;

    Control 
        inst1(clk, rst, command_1, start, ready_command);

    always #1 clk = ~clk; 

    initial begin
        #1000000
        $finish;
    end

    initial begin
    rst = 1'b0;
    #10
    ready_command = 1'b0;
    end

   initial begin
     $dumpfile("Control_TB.vcd");
     $dumpvars(-1, inst1);
   end

endmodule
