module main (clk, rst, in, op, apply, head, empty, valid);
    
    parameter W= 4'd8;

    input wire clk, rst, apply;
    input wire [W-1:0] in;
    input wire [3:0] op;
    
    output wire [W-1:0] head;
    output wire empty;
    output reg valid;
    
    reg [W-1:0] stack [0:10];
    reg [3:0] size;
    
    wire has2; 
    assign has2 = size>=2;

    wire has1;
    assign has1 = size>=1;
     
    assign empty = size == 0;
    assign head = has1 ? stack[size-1] : {W{1'bx}};
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            size <= 4'd0;
            valid <= 1;
        end
        else if (clk) begin
            if (valid == 1 && apply == 1) begin
                case(op)
                    4'd0 :
                        begin
                            if (has1) stack[size-1] <= stack[size-1] + 1;
                            else valid <= 0;
                        end
                    
                    4'd1 :
                        begin
                            if (has1) stack[size-1] <= stack[size-1] - 1;
                            else valid <= 0;
                        end
                    
                    4'd2 :
                        begin
                            if (has2) begin
                                stack[size-2] <= stack[size-2] + stack[size-1];
                                size <= size - 1;
                            end
                            else valid <= 0;
                        end
                    
                    4'd3 :
                        begin
                            if (has2) begin
                                stack[size-2] <= stack[size-2] - stack[size-1];
                                size <= size - 1;
                            end
                            else valid <= 0;
                        end
                    
                    4'd4 :
                        begin
                            if (has2) begin
                                stack[size-2] <= stack[size-2] * stack[size-1];
                                size <= size - 1;
                            end
                            else valid <= 0;
                        end
                    
                    4'd5 :
                        begin
                            if (has2 && head != 0) begin
                                stack[size-2] <= stack[size-2] / stack[size-1];
                                size <= size - 1;
                            end
                            else valid <= 0;
                        end
                    
                    4'd6 :
                        begin
                            if (has2 && head != 0) begin
                                stack[size-2] <= stack[size-2] % stack[size-1];
                                size <= size - 1;
                            end
                            else valid <= 0;
                        end
                    
                    4'd7 :
                        begin
                            if (size < 4'd11) begin
                                stack[size] <= in;
                                size <= size + 1;
                            end
                            else valid<=0;
                        end
                    
                    4'd8 :
                        begin
                            if (has1) size <= size -1;
                            else valid <= 0;
                        end
                    
                    default: valid <= 0;
                endcase
            end       
        end
        
    end
    
endmodule