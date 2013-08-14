section .data
section .text

	global main

main:
	
	mov eax,1
	push eax
	mov eax,5
	push eax

	call fib

lol:
	mov edx,ebx

	mov eax,1
	mov ebx,0
	int 80h

fib:
	
	mov eax,[esp+4]
	
	cmp eax,1

	jg cont
	
	mov ebx,[esp+8]
	jmp exit_stat

cont:
	
	imul eax,[esp+8]
	push eax
	mov eax,[esp+8]
	sub eax,1
	push eax

	call fib

	pop eax
	pop eax

exit_stat:
	ret;;
