all:
	nasm -f elf matmul_row.asm
	nasm -f elf matmul_col.asm
	gcc -o matmul_row matmul_row.o
	gcc -o matmul_col matmul_col.o

row:
	nasm -f elf matmul_row.asm
	gcc -o matmul_row matmul_row.o

col:
	nasm -f elf matmul_col.asm
	gcc -o matmul_col matmul_col.o

clean:
	rm *.o
	rm ./matmul_col ./matmul_row

clean_row:
	rm matmul_row.o
	rm ./matmul_row

clean_col:
	rm matmul_col.o
	rm ./matmul_col
