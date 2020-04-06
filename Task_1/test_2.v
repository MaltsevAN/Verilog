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
        $dumpfile("test_2.vcd");
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
        in = 8'd22;

        #2 op = 4'd1;



        //Итог 1:
        // 1. Проверка rst
        // 2. Проверка op = [0, 1]
        // 3. Проверка valid (попытка извлечь из пустого стека)
        // 4. Проверка вывода головы стека
        // 5. Проверка состояния empty
        // 6. Проверка отображения size 

    end

    initial
    begin
        #10 $finish;
    end
    
endmodule