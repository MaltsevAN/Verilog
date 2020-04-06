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
        $dumpfile("test_1.vcd");
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

        //apply = 0 and try apply op = 0 (push)
        apply = 0;
        op = 4'd0;
        in = 8'd22;

        //apply = 1
        #2 apply = 1;

        #2 apply = 0;

        #2 apply = 1;

        //Итог 1:
        // 1. Проверка rst
        // 2. Проверка apply
        // 3. Проверка op = 0
        // 4. Проверка valid (условие переполнения стека)
        // 5. Проверка вывода головы стека
        // 6. Проверка состояния empty
        // 7. Проверка отображения size 

    end

    initial
    begin
        #30 $finish;
    end
    
endmodule