module testbanch();
    reg clk, rst;
    
    initial clk = 0;
    initial rst = 1;
    initial #2 rst = 0;

    initial #20 $finish;
    always #1 clk = !clk;
    
    single_cpu single_cpu(clk, rst);
    
    initial begin
        $dumpfile("test.vcd");
        $dumpvars;
    end

endmodule