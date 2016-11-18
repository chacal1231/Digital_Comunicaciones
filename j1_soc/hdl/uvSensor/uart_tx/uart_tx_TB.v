`timescale 10ns / 10ps
`define SIMULATION

module uart_tx_TB;
    reg clk, reset, start;
    reg [7:0] data;
    wire tx, ready;

    uart_tx inst1(clk, reset, start, data, tx, ready);

    always #1 clk = ~clk; 

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        start = 1'b0;
        #10 
        reset = 1'b0;
        #10  
        reset = 1'b1;
        #1000
        @(posedge clk);
        data = 8'h55;
        start = 1'b1;
        @(negedge ready);
        @(posedge clk);
        start = 1'b0;
        @(posedge ready);
        data = 8'hAA;
        start = 1'b1;
        @(negedge ready);
        @(posedge clk);
        start = 1'b0;
        @(posedge ready);
    end

    initial begin
        #40000
        $finish;
    end

   initial begin
     $dumpfile("uart_tx_TB.vcd");
     $dumpvars(-1, inst1);
   end

endmodule
