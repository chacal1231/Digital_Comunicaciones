`timescale 10ns / 10ps
`define SIMULATION

module uvSensor_TB;
    reg clk, rst;
    reg start;
    wire ready, i2c_scl, i2c_sda;

    reg sda_out = 1'bz;
    assign i2c_sda = sda_out;

    fsmTest inst1(clk, rst, start, ready, i2c_scl, i2c_sda);

    always #1 clk = ~clk; 

    initial begin
        #200000
        $finish;
    end

    initial begin
        rst = 1'b0;
        start = 1'b0;
        clk = 1'b0;
        #20
        start = 1'b1;
        @(negedge ready);
        start = 1'b0;
        @(posedge ready);
        #20000
        start = 1'b1;
        @(negedge ready);
        start = 1'b0;
        @(posedge ready);
    end

   initial begin
     $dumpfile("uvSensor_TB.vcd");
     $dumpvars(-1, inst1);
   end

endmodule
