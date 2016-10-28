`timescale 10ns / 10ps
`define SIMULATION

module TOP_TB;
    reg clk = 1'b0;
    wire tx;

    TOP 
        inst1(clk, tx);

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
