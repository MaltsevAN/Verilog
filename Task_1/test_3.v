module test #(parameter W = 8) ;
    // parameter W = 16;
    reg clk = 0;
    always #1 clk = !clk;

    reg rst = 0;
    reg [W-1:0] in;
    reg [3:0] op;
    reg apply;
    
    wire [W-1:0] head;
    wire empty;
    wire valid;

    main #(W) test_stack(
        .clk(clk),
        .rst(rst),
        .in(in),
        .op(op),
        .apply(apply),

        .head(head),
        .empty(empty),
        .valid(valid)
        );
            
    
    
    initial
    begin
        $dumpfile("test_3.vcd");
        $dumpvars;
        $display("rst clk apply in op head empty valid");
        $monitor(" %2d %2d %2d %8d %4d %8d %2d %2d",
            rst,
            clk,
            apply,
            in,
            op,
            head,
            empty,
            valid
        );

        // rst
        #1 rst = 1;
        #1 rst = 0;

        apply = 1;

        op = 4'd0;
        in = 8'd10;
        #8 in = 8'd3;

        // head + 1
        #4 op = 4'd2;

        // head - 1
        #2 op = 4'd3;

        // a + b
        #2 op = 4'd4;

        // b - a
        #2 op = 4'd5;

        // a * b
        #2 op = 4'd6;

        // b % a
        #2 op = 4'd8;

        // b / a
        #2 op = 4'd7;




        //Итог 1:
        // 1. Проверка rst
        // 2. Проверка op = [0, 2, 3, 4, 5, 6, 7, 8]
        // 3. Проверка valid (недостаток элементов для операции)
        // 4. Проверка вывода головы стека
        // 5. Проверка состояния empty
        // 6. Проверка отображения size 

    end

    initial
    begin
        #30 $finish;
    end
    
endmodule