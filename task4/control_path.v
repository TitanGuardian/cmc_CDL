// Имена новых управляющих портов добавить после соответствующего комментария в первой строке объявления модуля.
// Сами объявления дописывать под соответствующим комментарием после имеющихся объявлений портов. Комментарий не стирать.
// Реализацию управляющего автомата дописывать под соответствующим комментарием в конце модуля. Комментарий не стирать.
// По необходимости можно раскомментировать ключевые слова "reg" в объявлениях портов.
module control_path(on, start, regime, active, y_select_next, s_step, y_en, s_en, y_store_x, s_add, s_zero, clk, rst, s_is_zero);
  input [1:0] on;
  input start, clk, rst;
  output reg [1:0] regime;
  output reg active;
  output reg [1:0] y_select_next;
  output reg  [1:0] s_step;
  output reg  y_en;
  output reg  s_en;
  output reg y_store_x; // ну тут не так необходимо, но пусть все выглядит одинаково
  output reg  s_add;
  output reg  s_zero;
  
  /* ОБЪЯВЛЕНИЯ НОВЫХ УПРАВЛЯЮЩИХ ПОРТОВ */
  
  input s_is_zero;
  
  
  /* КОД УПРАВЛЯЮЩЕГО АВТОМАТА */
  
  // локальные точки 
  reg [4:0] counter16; 
  reg [1:0] counter3;
  
  wire enum_off;
  wire refresh_off;
  assign enum_off = (counter16 == 1'b0);
  assign refresh_off = (counter3 == 1'b0);
  
  // состояние автомата управляющего выходами regime и active  
  localparam STATE_OFF = 3'd0,
             STATE_ENUM_INACTIV = 3'd1,
             STATE_ENUM_ACTIV = 3'd2,
             STATE_COUNT = 3'd3,
             STATE_REFRESH = 3'd4;

  reg [2:0] state, next_state; 
             
  always @(posedge clk, posedge rst)
    if (rst) state <= STATE_OFF;
    else state <= next_state;
	
  //процедура функции переходов Sigma_T
  always @* begin 
    next_state = 1'bx;
    
    case(state)
    STATE_OFF: case (on)
               2'd0: next_state = STATE_OFF;
               2'd1: next_state = STATE_ENUM_INACTIV;
               2'd2: next_state = STATE_COUNT;
               2'd3: next_state = STATE_REFRESH;
               endcase
               
    STATE_ENUM_INACTIV: if (start) next_state = STATE_ENUM_ACTIV;
                        else next_state = STATE_ENUM_INACTIV;
    
    STATE_ENUM_ACTIV:   if (enum_off) next_state = STATE_OFF;
                        else next_state = STATE_ENUM_ACTIV;
    
    STATE_COUNT:  if (start) next_state = STATE_COUNT;
                  else next_state = STATE_OFF;
                  
    STATE_REFRESH: if (refresh_off) next_state = STATE_OFF;
                   else next_state = STATE_REFRESH;
    endcase    
  end
  
  
  //процедура функции выходов Sigma_В
  
  always @* begin 
    regime = 1'bx; active = 1'bx;
    
    case(state)
    STATE_OFF:  begin
                  regime = 2'd0;
                  active = 0;
                end
               
    STATE_ENUM_INACTIV: begin
                          regime = 2'd1;
                          active = 0;
                        end
    
    STATE_ENUM_ACTIV:   begin
                          regime = 2'd1;
                          active = 1;
                        end
    
    STATE_COUNT:  begin
                    regime = 2'd2;
                    active = 0;
                  end
                  
    STATE_REFRESH:  begin
                      regime = 2'd3;
                      active = 0;
                    end
    endcase    
  end
  

  //процедура для counter16
  always @(posedge clk)
    if (state == STATE_ENUM_ACTIV) counter16 <= counter16 - 1; 
    else counter16 <= 5'd16;  
    
  //процедура для counter3
  always @(posedge clk)
    if (state == STATE_REFRESH) counter3 <= counter3 - 1; 
    else counter3 <= 2'd2;


  // типовые реализации закончились, можно отжигать (?)
  
  
  
  // управляющие выходы для  операционного автомата 
  
//процедуры для каждого состояния -----> процедуры для групп выходов;
  
  
  //процедура для y_en, s_en;
  
  
  always @* begin
    y_en = 0; s_en=0;
    case (state) 
    STATE_ENUM_ACTIV:
      case (counter16)
      5'd16: begin
        s_en = 1;
      end
      5'd12: begin
        s_en = 1;
      end
      5'd8: begin
        s_en = 1;
      end
      5'd4: begin
        s_en = 1;
      end
      5'd0: begin
        s_en = 1;
      end
      endcase
    
    STATE_COUNT: 
      if (start)
        begin
        s_en = 1;
        if (s_is_zero)
          y_en = 1;
        end

    STATE_REFRESH:
      case (counter3) 
      2'd2: y_en=1;
      2'd1: begin
        s_en = 1;
        y_en = 1;
      end
      endcase
    endcase
  end
  
  //процедура для s_step, s_add, s_zero
  always @* begin
    s_step = 0; s_add=0; s_zero = 0;
    case (state) 
    STATE_ENUM_ACTIV:  begin
      s_add = 1;
      case (counter16)
      5'd16: begin
        s_step = 2'd1; 
        s_zero = 1;
      end
      5'd12: begin
        s_step = 2'd2;
      end
      5'd8: begin
        s_step = 2'd2;
      end
      5'd4: begin
        s_step = 2'd2;
      end
      5'd0: begin
        s_zero = 1;
        s_step = 1;
      end
      endcase
    end
    
    STATE_COUNT:
      if (start)
        s_step = 2'd1;
    
    
    STATE_REFRESH:
      case (counter3) 
      2'd1: begin
        s_step = 1;
        s_add = 1;
      end
      endcase
    endcase
  end
  
  // процедура для y_select_next и y_store_x
  always @* begin
    y_select_next = 0; y_store_x = 0;
    case (state) 
 
    STATE_COUNT:
      if (start)
        if (s_is_zero)
          y_select_next = 2'd1;

    STATE_REFRESH:
      case (counter3) 
      2'd2: begin
        y_store_x = 1;
      end
      2'd1: begin
        y_select_next = 2'd3; 
      end
      endcase
    endcase
  end

endmodule


