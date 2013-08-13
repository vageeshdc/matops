;assignment 1
;CSD course
;author: vageesh
;
;Info : a matrix multiplication implementation

section .data
	msg: db "sup there",16
	len: equ $-msg

	arr: dd 12,123123,2323,454,234,3434,324
	
	arr2: dd 1,2,3,4
	arr3: dd 0,0,0,0

	format: db "yo %d num",10,0
	
	loop_i: dd 0
	loop_j: dd 0
	
	aVec: dd 0
	bVec: dd 0

section .text:
	global main
	extern printf

main:
	;pop ebx
	;dec ebx
	;pop ebp
	;pop ebp

	;mov edx,4
	;mov ecx,arr
	;mov ebx,1
	;mov eax,4
	;int 80h

    mov eax,arr3
    push eax

	mov eax,2
	push eax
	mov eax,arr2

	push eax
	push eax

	call mult_mat_2d

	;lea eax,[arr]
	;mov ecx,[eax]
	;mov eax,[arr + 4]
	;pop eax
	;push eax
	
	;push format
	;call printf

	;end of program
	mov eax,1
	mov ebx,0
	int 80h
	;return 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mult_mat:
	;multiplies matrices
	;a[],b[],n

	mov ecx,[esp+12]
	sub ecx,1
	
	mov edx,0

L1_main:
	mov eax,[esp+12]
	push eax

	mov eax,[esp+8]
	mov ebx,ecx
	imul ebx,4
	add eax,ebx
	push eax

	mov eax,[esp+4]
	mov ebx,[esp+12]
	imul ebx,ecx
	imul ebx,4
	add eax,ebx
	push eax

	call mult_row

	add edx,eax
	sub ecx,1
	cmp ecx,0
	jge L1_main

L2_main:
	mov eax,edx
	push eax
	ret;
	;end of matmul

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mult_mat_2d:
	
	;args a[],b[],n,C[] -- the sol
	mov eax,[esp+12]
	sub eax,1

	mov dword [loop_i],eax
	mov dword [loop_j],eax
	;done with setting loop variables
	;push and pop eax for counter ops

out_1:

	;outer loop
out_2:

	;inner loop

	mov edx,[esp+12]
	push edx

	mov eax,[loop_j]
	imul eax,4
	add eax,[esp+8+4]
	push eax

	mov eax,[loop_i]
	imul eax,edx
	imul eax,4
	add eax,[esp+4+8]
	push eax

	call mult_row

	mov edx,eax
	
	pop eax
	pop eax
	pop eax

	mov eax,[loop_i]
    mov ebx,[esp+12]
	imul eax,ebx
	mov ebx,[loop_j]
	add eax,ebx
	imul eax,4
	add eax,[esp+16]
	mov [eax],edx
	
	push eax
	mov eax,[loop_j]
	sub eax,1
	mov dword [loop_j],eax
	pop eax

	push eax
	mov eax,[loop_j]
	cmp eax,0
	pop eax

	jge out_2

out_2_end:


	push eax
	mov eax,[esp+12]
	sub eax,1
	mov dword [loop_j],eax
	pop eax

	push eax
	mov eax,[loop_i]
	sub eax,1
	mov [loop_i],eax
	pop eax

	push eax
	mov eax,[loop_i]
	cmp eax,0
	pop eax

	jge out_1

out_1_end:

	ret;
	;end of the procedure

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mult_row:
	;multiplies a row
	;a[],b[],n

	;mov eax,[esp+12]
	;push eax
	;push format
	;call printf


	;mov eax,[esp+12]
	;sub eax,1
	;imul eax,[esp+12]
	;imul eax,4
	;add [esp+8],eax

	;mov eax,[esp+12]
	;sub eax,1
	;imul eax,4
	;add [esp+4],eax

	;mov eax,[esp+12]
	;push eax
	;push format
	;call printf

	mov ebx,0
	mov ecx,[esp+12]
	sub ecx,1
L1:	
	mov eax,ecx
	imul eax,[esp+12]
	imul eax,4
	add eax,[esp+8]
	mov edx,[eax]

	mov eax,[esp+4]
	push ecx
	imul ecx,4
	add eax,ecx
	pop ecx

	imul edx,[eax]
	add ebx,edx
	sub ecx,1
	
	cmp ecx,0
	jge L1

L2:
	mov eax,ebx
	;push eax
	ret

	;end or row mult


