all : test

test :
	iverilog testbanch.v main.v control_path.v data_path.v -o test
	./test
    
clean:
	rm -f test test.vcd
	