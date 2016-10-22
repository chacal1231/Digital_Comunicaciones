`timescale 10ns / 10ps
`define SIMULATION

module testMem_TB;
    reg [2:0] addr;
    wire [7:0] data;

    testMem inst1(data, addr);

    //always #1 clk = ~clk; 

    initial begin
        #1000000
        $finish;
    end

    initial begin
        addr = 3'd0;
        #10
        addr = 3'd1;
        #10
        addr = 3'd2;
        #10
        addr = 3'd3;
        #10
        addr = 3'd4;
        #10
        addr = 3'd5;
    end

   initial begin
     $dumpfile("testMem_TB.vcd");
     $dumpvars(-1, inst1);
   end

endmodule
