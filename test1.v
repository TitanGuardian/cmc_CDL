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
	
	
	integer i;
	reg test_valid = 1;

    main #(W) mystack (.clk(clk), .rst(rst), .in(in),
            .op(op), .apply(apply), .head(head), .empty(empty), .valid(valid));
            
    initial #24 $finish;
    
    initial begin
		$dumpfile("test1.vcd");
		$dumpvars;

		apply = 0;
		#2 rst = 1;
		#1 test_valid = empty;
		#1 rst = 0;
		op = 4'd7;
		apply = 1;
		in = 16'd150; 
		#6 rst = 1;
		apply = 0;	
		#1 rst = 0;
		test_valid = empty;
		#1
		// time 12
		apply = 1;
		#2
		test_valid = (head == 16'd150);
		in = 16'd13;
		#2
		test_valid = (head == 16'd13);
		apply = 0;
		in = 16'd18;
		#2
		test_valid = head != in;
		
		for (i = 0; i<5 ; i = i+1) begin
			#1 test_valid = head != in;
		end
    end
    
endmodule