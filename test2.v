module test ;
    parameter W =16;
    reg clk = 0;
    always #1 clk = !clk;
    reg rst = 0;
    reg[W-1:0] in;
    reg[3:0] op;
    reg apply;
    
    wire [W-1:0] head;
    wire empty;
    wire valid;

    main #(W) mystack (.clk(clk), .rst(rst), .in(in),
            .op(op), .apply(apply), .head(head), .empty(empty), .valid(valid));
            
    initial #80 $finish;
    
    initial begin
    $dumpfile("test.vcd");
    $dumpvars;

    apply = 0;
    #2 rst = 1;
    #2 rst = 0;
    op = 4'd7;
    apply = 1;
    in = 16'd150; 
    #2 in =  16'd0;
    #2 op = 4'd5;
    #2 apply=0;
    end
    
endmodule