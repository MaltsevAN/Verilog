all : test_1.o test_2.o test_3.o test_4.o test_5.o

test_1.o :
	iverilog main.v test_1.v -o test_1
	./test_1
    
test_2.o :
	iverilog main.v test_2.v -o test_2
	./test_2
    
test_3.o :
	iverilog main.v test_3.v -o test_3
	./test_3

test_4.o :
	iverilog main.v test_4.v -o test_4
	./test_4

test_5.o :
	iverilog main.v test_5.v -o test_5
	./test_5

clean:
	rm -f test_1 test_2 test_3 test_4 test_5 test_1.vcd test_2.vcd test_3.vcd test_4.vcd test_5.vcd