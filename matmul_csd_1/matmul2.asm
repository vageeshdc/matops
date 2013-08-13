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
	
	aOff: dd 0
	bOff: dd 0
	cOff: dd 0

section .text:
	global main
	extern printf

main:
    push eax

	mov eax,2
	push eax
	mov eax,arr2

	push eax
	push eax

	call add_mat_2d

	mov eax,1
	mov ebx,0
	int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mult_mat_2d:
	
	;args a[],b[],n,C[],ia,ja,ib,jb,Wid,ic,jc
	;here  (ij) is the location of blocks A and B wrt to parent matrices
	;Wid is the Width of parent matrix
	;Work under assumption that it is a square
	; A,B,C are the references of parent matrices only
	
	mov eax,[esp+12]
	sub eax,1

	mov dword [loop_i],eax
	mov dword [loop_j],eax
	;done with setting loop variables
	;push and pop eax for counter ops
	
	;find offset
	
	;;A's offset
	mov edx,[esp+20]
	sub edx,1
	imul edx,[esp+36]
	add edx,[esp+24]
	imul eds,4
	mov [aOff],edx
	
	;;B's offset
	mov edx,[esp+28]
	sub edx,1
	imul edx,[esp+36]
	add edx,[esp+32]
	imul eds,4
	mov [bOff],edx
	
	;;C's offset
	mov edx,[esp+40]
	sub edx,1
	imul edx,[esp+36]
	add edx,[esp+44]
	imul eds,4
	mov [cOff],edx
	
out_1:

	;outer loop
out_2:

	;inner loop

	;current B off
	mov eax,[loop_j]
	imul eax,4
	add eax,[esp+8]
	add eax,[bOff]
	mov dword [bVec],eax

	;current A off
	mov eax,[loop_i]
	imul eax,[esp+36]
	imul eax,4
	add eax,[esp+4]
	add eax,[aOff]
	mov dword [aVec],eax
	
	;;;row multiplication ops here...
	
	mov ebx,0
	mov ecx,[esp+12]
	sub ecx,1
	
out_3:	
	mov eax,ecx
	imul eax,[esp+36]
	imul eax,4
	add dword eax,[bVec]
	mov edx,[eax]

	mov eax,[aVec]
	push ecx
	imul ecx,4
	add eax,ecx
	pop ecx

	imul edx,[eax]
	add ebx,edx
	sub ecx,1
	
	cmp ecx,0
	jge out_3

out_3_exit:
	
    ;;;end of row op...
	
	mov edx,ebx

	;writing result of C
	mov eax,[loop_i]
	imul eax,[esp+36]
	mov ebx,[loop_j]
	add eax,ebx
	imul eax,4
	add eax,[cOff]
	add eax,[esp+16]
	mov [eax],edx
	
	mov eax,[loop_j]
	sub eax,1
	mov dword [loop_j],eax

	cmp eax,0

	jge out_2

out_2_end:


	mov eax,[esp+12]
	sub eax,1
	mov dword [loop_j],eax

	mov eax,[loop_i]
	sub eax,1
	mov [loop_i],eax

	cmp eax,0

	jge out_1

out_1_end:

	ret;
	;end of the procedure

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

add_mat_2d:
	;arr A[],B[],n,C[],ia,ja,ib,jb,Wid,ic,jc
	;here  (ij) is the location of blocks A and B wrt to parent matrices
	;Wid is the Width of parent matrix
	;Work under assumption that it is a square
	; A,B,C are the references of parent matrices only

	mov eax,[esp+12]
	sub eax,1

	mov [loop_i],eax
	mov [loop_j],eax

out_1a:
	
out_2a:
	
	;;addition logic
	
	;find offset
	
	;;A's offset
	mov edx,[esp+20]
	sub edx,1
	imul edx,[esp+36]
	add edx,[esp+24]
	imul eds,4
	mov [aOff],edx
	
	;;B's offset
	mov edx,[esp+28]
	sub edx,1
	imul edx,[esp+36]
	add edx,[esp+32]
	imul eds,4
	mov [bOff],edx
	
	;;C's offset
	mov edx,[esp+40]
	sub edx,1
	imul edx,[esp+36]
	add edx,[esp+44]
	imul eds,4
	mov [cOff],edx
	
	;common offset
	mov ebx,[loop_i]
	imul ebx,[esp+36]
	add ebx,[loop_j]
	imul ebx,4

	;get B[]
	mov ecx,[esp+8]
	add ecx,ebx
	add ecx,[bOff]
	mov eax,[ecx]

	;add A[]
	mov ecx,[esp+4]
	add ecx,ebx
	add ecx,[aOff]
	add eax,[ecx]

	;store to C[]
	mov ecx,[esp+16]
	add ecx,ebx
	add ecx.[cOff]
	mov [ecx],eax

	;;end of addition

	mov eax,[loop_j]
	sub eax,1
	mov [loop_j],eax

	cmp eax,0
	jge out_2

out_2a_end:
	
	mov eax,[esp+12]
	sub eax,1
	mov [loop_j],eax

	mov eax,[loop_i]
	sub eax,1
	mov [loop_i],eax

	cmp eax,0
	jge out_1

out_1a_end:

	ret;
	;end of addition

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
