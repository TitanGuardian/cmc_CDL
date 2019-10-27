all : test1.o test2.o test3.o

test1.o :
	iverilog main.v test1.v -o test1
	./test1
    
test2.o :
	iverilog main.v test2.v -o test2
	./test2
    
test3.o :
	iverilog main.v test3.v -o test3
	./test3

clean:
	rm -f test1 test2 test3 test1.vcd test2.vcd test3.vcd
	