;assignment 1
;CSD course
;author: vageesh
;
;Info : a matrix multiplication implementation

SECTION .data
	msg: db "sup there",16
	len: equ $-msg

	arr: dd 12,123123,2323,454,234,3434,324
	
	arr2: dd 1,2,3,4
	arr3: dd 0,0,0,0
	arr4: dd 0,0,0,0
	arr5: dd 1,0,0,1

	format: db " | %d ",0
	format2: db " | ",10,0
	format3: db " time taken %lld cycles .. ",10,0

	CHval: dd 0
	CLval: dd 0

	loop_i: dd 0
	loop_j: dd 0
	
	aVec: dd 0
	bVec: dd 0
	
	aOff: dd 0
	bOff: dd 0
	cOff: dd 0

	aOff2: dd 0
	bOff2: dd 0
	cOff2: dd 0

	lop_i: dd 0
	lop_j: dd 0
	lop_k: dd 0
	
	Av: dd 0
	Bv: dd 0
	Cv: dd 0
	Dv: dd 0
	Nval: dd 0
	Bval: dd 0

	AA: dd 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
	BB: dd 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
	BB1: dd 1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1
	BB2: dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	CC: dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	DD: dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

SECTION .text
	global main
	extern printf

main:

	;getting initial time
	xor eax,eax
	
	cpuid
	rdtsc

	mov [CHval],edx
	mov [CLval],eax

	;b
	mov eax,2
    push eax

	;N
	mov eax,4
	push eax

	;D
	mov eax,arr3
	push eax

	;C
	mov eax,arr4
	push eax

	;B
	mov eax,arr2
	push eax

	;A
	mov eax,arr2
	push eax

	call mult_block_2d

print_timer:
	;;getting later time

	xor eax,eax
	
	cpuid
	rdtsc

	sub eax,[CLval]
	sub edx,[CHval]

	push eax
	push edx
	push format3
	call printf

	;; print the matrix C

	mov eax,2
	mov [lop_i],eax

	mov ebx,0
	mov [loop_i],ebx
	mov [loop_j],ebx

pl1:

pl2:

	;; print to screen

	mov ecx,[loop_i]
	imul ecx,[lop_i]
	add ecx,[loop_j]
	imul ecx,4
	add ecx,arr4
	
	mov eax,[ecx]
	push eax
	push format
	call printf

	;;end of print

	;update
	
	mov ebx,[loop_j]
	add ebx,1
	mov [loop_j],ebx

	cmp ebx,[lop_i]
	jl pl2

pl2_out:

	;new line print

	push format2
	call printf
	;;

	mov ebx,0
	mov [loop_j],ebx

	mov ebx,[loop_i]
	add ebx,1
	mov [loop_i],ebx

	cmp ebx,[lop_i]
	jl pl1

pl1_out:

	;; end of print bye

	mov eax,1
	mov ebx,0
	int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mult_block_2d:

	;the params are A[],B[],C[],D[],N,b
	; A,B are the ip C is the OP
	; D is the dummy 
	; N is the dimension
	; b is the block parameter

	mov eax,[esp+4]
	mov [Av],eax

	mov eax,[esp+8]
	mov [Bv],eax

	mov eax,[esp+12]
	mov [Cv],eax

	mov eax,[esp+16]
	mov [Dv],eax

	mov eax,[esp+20]
	mov [Nval],eax

	mov eax,[esp+24]
	mov [Bval],eax

	mov eax,[Nval]
	mov ecx,[Bval]
	mov edx,0
	;donr specifically
	div ecx

	cmp edx,0
	jne exit_error_noerror

	;use lop_i,lop_j,lop_k
	;ind ia ja ib jb ic jc id jd
	
	mov eax,0
	mov [lop_i],eax
	mov [lop_j],eax


l1:
	
l2:
	mov eax,0
	mov [lop_k],eax
	
l3:
	
	;;mult here
	
	;jc
	mov eax,[lop_k]
	push eax

	;ic
	mov eax,0
	push eax

	;Wid
	mov eax,[Nval]
	push eax

	;jb
	mov eax,[lop_j]
	push eax

	;ib
	mov eax,[lop_k]
	push eax

	;ja
	mov eax,[lop_k]
	push eax

	;ia
	mov eax,[lop_i]
	push eax

	;C
	mov eax,[Dv]
	push eax

	;n
	mov eax,[Bval]
	push eax

	;b
	mov eax,[Bv]
	push eax

	;a
	mov eax,[Av]
	push eax

	;; call the function
	call mult_mat_2d

	;; mult ends

	pop eax
	pop eax	
	pop eax
	pop eax	
	pop eax	
	pop eax	
	pop eax	
	pop eax	
	pop eax	
	pop eax	
	pop eax	
	
	;loop management
	mov eax,[lop_k]
	add eax,[Bval]
	mov [lop_k],eax

	cmp eax,[Nval]
	jl l3

l3_out:

	;; add ops here
	
	mov eax,0
	mov [lop_k],eax

l4:

	;; push ops

	;jc
	mov eax,[lop_j]
	push eax

	;ic
	mov eax,[lop_i]
	push eax

	;Wid
	mov eax,[Nval]
	push eax

	;jb
	mov eax,[lop_j]
	push eax

	;ib
	mov eax,[lop_i]
	push eax

	;ja
	mov eax,[lop_k]
	push eax

	;ia
	mov eax,0
	push eax

	;C
	mov eax,[Cv]
	push eax

	;n
	mov eax,[Bval]
	push eax

	;b
	mov eax,[Cv]
	push eax

	;a
	mov eax,[Dv]
	push eax

	;; call
	call add_mat_2d

	;;end of pushops
	
	pop eax
	pop eax	
	pop eax
	pop eax	
	pop eax	
	pop eax	
	pop eax	
	pop eax	
	pop eax	
	pop eax	
	pop eax	

	mov eax,[lop_k]
	add eax,[Bval]
	mov [lop_k],eax

	cmp eax,[Nval]
	jl l4

l4_out:

	;; end of add ops



	mov eax,[lop_j]
	add eax,[Bval]
	mov [lop_j],eax

	cmp eax,[Nval]
	jl l2

l2_out:
	
	mov eax,0
	mov [lop_j],eax

	mov eax,[lop_i]
	add eax,[Bval]
	mov [lop_i],eax

	cmp eax,[Nval]
	jl l1

l1_out:
	

exit_error_noerror:
	ret;;

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
	imul edx,4
	mov [aOff],edx
	
	;;B's offset
	mov edx,[esp+28]
	sub edx,1
	imul edx,[esp+36]
	add edx,[esp+32]
	imul edx,4
	mov [bOff],edx
	
	;;C's offset
	mov edx,[esp+40]
	sub edx,1
	imul edx,[esp+36]
	add edx,[esp+44]
	imul edx,4
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


	;find offset
	
	;;A's offset
	mov edx,[esp+20]
	sub edx,1
	imul edx,[esp+36]
	add edx,[esp+24]
	imul edx,4
	mov [aOff2],edx
	
	;;B's offset
	mov edx,[esp+28]
	sub edx,1
	imul edx,[esp+36]
	add edx,[esp+32]
	imul edx,4
	mov [bOff2],edx
	
	;;C's offset
	mov edx,[esp+40]
	sub edx,1
	imul edx,[esp+36]
	add edx,[esp+44]
	imul edx,4
	mov [cOff2],edx
	
	mov eax,[esp+12]
	sub eax,1
	mov [loop_i],eax
	mov [loop_j],eax

out_1a:
	
out_2a:
	
	;;addition logic
	
	;common offset
	mov ebx,[loop_i]
	imul ebx,[esp+36]
	add ebx,[loop_j]
	imul ebx,4

	;get B[]
	mov ecx,[esp+8]
	add ecx,ebx
	add ecx,[bOff2]
	mov eax,[ecx]

	;add A[]
	mov ecx,[esp+4]
	add ecx,ebx
	add ecx,[aOff2]
	add eax,[ecx]

	;store to C[]
	mov ecx,[esp+16]
	add ecx,ebx
	add ecx,[cOff2]
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

trans_mat_2d:
	;args - A[],N
	
	mov eax,[esp+8]

	mov dword [loop_i],0
	mov dword [loop_j],0

tl_1:

tl_2:
	
	;swap here

	mov eax,[loop_i]
	imul eax,[esp+8]
	add eax,[loop_j]
	imul eax,4
	add eax,[esp+4]
	mov ebx,[eax]
	
	mov ecx,[loop_j]
	imul ecx,[esp+8]
	add ecx,[loop_i]
	imul ecx,4
	add ecx,[esp+4]
	mov edx,[ecx]
	
	mov [eax],edx
	mov [ecx],ebx

	;end swapping


	mov eax,[loop_j]
	add eax,1
	mov [loop_j],eax

	mov ebx,[loop_i]
	cmp eax,ebx
	jle tl_2

tl2_out:

	mov dword [loop_j],0

	mov eax,[loop_i]
	add eax,1
	mov [loop_i],eax

	mov ebx,[esp+8]
	cmp eax,ebx

	jl tl_1

tl1_out:

	ret;;

