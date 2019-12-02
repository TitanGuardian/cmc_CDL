
module testbanch();
  reg [7:0] x;
  reg [1:0] on;
  reg start;
  reg clk, rst;
  wire [7:0] y;
  wire [2:0] s;
  wire b, active;
  wire [1:0] regime;
  
  wire [1:0] y_select_next, s_step;
  wire y_en, s_en, y_store_x, s_add, s_zero;
  
  reg test_valid;
  
  initial clk = 0;
  initial rst = 1;
  initial #2 rst = 0;
  
  initial #100 $finish;
  always #1 clk = !clk;
  
  main aaa(.x(x), .y(y), .s(s), .b(b), .on(on), .start(start), .regime(regime), .active(active), .clk(clk), .rst(rst));
  
  initial begin
    $dumpfile("test.vcd");
		$dumpvars;
    
    // тест для Режмима счёта 0~32 
    on = 2;
    #4 start = 1;
    on=0;
    #20 start = 0;
    #8 ;
    // тест Режима обновления 32~40
    x = 57;
    on = 3;
    #8 
    // тест Режима перечисления 40~80
    on=1;
    #4 start = 1;on = 0;
    #32 ;
    //тест выключенного режима 80~100
    
    
    
  end
  
  
  
endmodule
