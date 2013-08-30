all:
	nasm -f elf matmul_row1.asm
	nasm -f elf matmul_row2.asm
	nasm -f elf matmul_row3.asm
	gcc -o matmul_row1 matmul_row1.o
	gcc -o matmul_row2 matmul_row2.o
	gcc -o matmul_row3 matmul_row3.o

clean:
	rm *.o
	rm ./matmul_row1 ./matmul_row2 ./matmul_row3
