all : test1 test2 test3

test1 :
	iverilog main.v test1.v -o test1
	./test1
    
test2 :
	iverilog main.v test2.v -o test2
	./test2
    
test3 :
	iverilog main.v test3.v -o test3
	./test3

clear:
	rm test1 test2 test3 test1.vcd test2.vcd test3.vcd
