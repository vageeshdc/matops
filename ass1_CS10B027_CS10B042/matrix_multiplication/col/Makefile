all:
	nasm -f elf matmul_col1.asm
	nasm -f elf matmul_col2.asm
	nasm -f elf matmul_col3.asm
	gcc -o matmul_col1 matmul_col1.o
	gcc -o matmul_col2 matmul_col2.o
	gcc -o matmul_col3 matmul_col3.o

clean:
	rm *.o
	rm ./matmul_col*
