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
	
	reg test_valid = 1;

	integer i;
	
    main #(W) mystack (.clk(clk), .rst(rst), .in(in),
            .op(op), .apply(apply), .head(head), .empty(empty), .valid(valid));
            
    initial #150 $finish;
    
    initial begin
		$dumpfile("test3.vcd");
		$dumpvars;
		
		rst=1;
		#2 rst =0; apply =1;
		
		for (i=9; i!=16; i= i+1) begin
			op = i; 
			#2 test_valid = valid == 0;
			#2 rst = 1;
			#2 rst =0;
		end
		
		for (i=2; i!=7; i= i+1) begin
			
			#2 rst = 1;
			#2 rst =0;
			op = 7;
			in = 16'd1;
			#2 op = i;
			#2 test_valid = valid ==0;
			
		end
		
		
		#2 rst = 1;
		#2 rst =0;
		op = 0;
		in = 16'd1;
		#2 test_valid = valid ==0;
		
		#2 rst = 1;
		#2 rst =0;
		op = 1;
		in = 16'd1;
		#2 test_valid = valid ==0;
		
		#2 rst = 1;
		#2 rst =0;
		op = 8;
		in = 16'd1;
		#2 test_valid = valid ==0;
	
		#2 rst = 1;
		#2 rst =0;
		op = 7;
		in = 16'd1;
		for (i=0; i!=12; i= i+1) begin
			test_valid = valid ==1;
			#2 ;
		end
		test_valid = valid ==0;
		
		#2 rst = 1;
		#2 rst =0;
		op = 7;
		in = 5;
		#2 in = 0;
		op = 5;
		#2 test_valid = valid ==0;
		
		#2 rst = 1;
		#2 rst =0;
		op = 7;
		in = 5;
		#2 in = 0;
		op = 6;
		#2 test_valid = valid ==0;
		
	
    end
    
endmodule