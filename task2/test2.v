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
	
	reg test_valid=1;

    main #(W) mystack (.clk(clk), .rst(rst), .in(in),
            .op(op), .apply(apply), .head(head), .empty(empty), .valid(valid));
            
    initial #32 $finish;
    
    initial begin
    $dumpfile("test2.vcd");
    $dumpvars;
    #2 rst = 1;
    #2 rst = 0;
    op = 4'd7;
    apply = 1;
    in = 16'd300; 
	#4 ;
	in = 16'd150; 
    #2 in =  16'd2;
	test_valid = head == 16'd150;
	#2 op = 4'd0; // head++  // stack : 300 300 300 150 2
	test_valid = head == 16'd2;
	#2 test_valid = head == 16'd3;
	op = 4'd1; // head--
	#2 test_valid = head == 16'd2;
	op = 4'd2; // +
	#2 test_valid = head == 16'd152;
	op = 4'd3; // - // stack : 300 300 300 152
	#2 test_valid = head == 16'd148;
	op = 4'd4; // * // stack : 300 300 148
	#2 test_valid = head == 16'd44400;
	op = 4'd7; // add // stack : 300 44400
	in = 16'd148;
	#2 test_valid = head == 16'd148; // stack : 300 44400 148
	op = 4'd5;
	#2 test_valid = head == 16'd300; // stack : 300 300
	op = 4'd7; in = 16'd7; #2 test_valid = head == 16'd7;
	// stack : 300 300 7
	op = 4'd6 ; // % 
	#2 test_valid = head == 16'd6; // stack : 300 6
	op = 4'd8;
	#2 test_valid = head == 16'd300; // stack : 300
	op = 4'd8;
    // empty
    end
    
endmodule