;CSD Assignment 1
;Problem: Inversion of a Matrix
;Author: Pankaj (CS10B042)


global main

extern scanf
extern printf

section .data
newline db "",10, 0
formatin: db "%lf", 0
formatout: db "%lf", 10, 0 
formatdet: db "Determinant Value: %lf", 10, 0 
formatdetzero: db "Determinant Value is Zero. Exiting.", 0
format3: db " time taken %d cycles .. ",10,0

fvr: dq 0
tmp: dq 0
tmp2: dd 0

a: dq 0
b: dq 0
c: dq 0
detval: dq 0

;timing variables
CHval: dd 0
CLval: dd 0

section .bss

array1: resq 9
array2: resq 9
array3: resq 9

section .text

main:

;;;;;;;;;;;;;;;;;;;;;;;;;;; Reading mat ;;;;;;;;;;;;;;;;;;;;;;;;;;
readmat:
   mov ebx, 0;

inputMat:
   call readfloat
   fstp qword [array1+ebx*8]
   inc ebx;
   
   cmp ebx, 9
   jl inputMat

;;;;;;;;;;;;;;;;;;;;;;; Read mat over ;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;getting start time of computation;;;;;;;;;;;;;;;
;getting initial time
	xor eax,eax
	
	cpuid
	rdtsc

	mov [CHval],edx
	mov [CLval],eax


;;;;;;;;;;;;;;;;;;; Calculate mat determinant ;;;;;;;;;;;;;;

mov ecx, 7
fld qword [array1+ecx*8] ; 8th element
mov ecx, 5
fmul qword [array1+ecx*8] ; 6th element 
fstp qword [a]

mov ecx, 4
fld qword [array1+ecx*8] ; 5th element
mov ecx, 8
fmul qword [array1+ecx*8] ; 9th element

fsub qword[a]
fstp qword [a]
;-----------------

mov ecx, 6
fld qword [array1+ecx*8] ; 7th element
mov ecx, 5
fmul qword [array1+ecx*8] ; 6th element 
fstp qword [b]

mov ecx, 3
fld qword [array1+ecx*8] ; 4th element
mov ecx, 8
fmul qword [array1+ecx*8] ; 9th element

fsub qword[b]
fstp qword [b]
;-----------------

mov ecx, 6
fld qword [array1+ecx*8] ; 7th element
mov ecx, 4
fmul qword [array1+ecx*8] ; 5th element 
fstp qword [c]

mov ecx, 3
fld qword [array1+ecx*8] ; 4th element
mov ecx, 7
fmul qword [array1+ecx*8] ; 8th element

fsub qword[c]
fstp qword [c]
;------------------------------------------


fld qword[a]
fmul qword[array1]
fstp qword [a]

fld qword[b]
fmul qword[array1+8]
fstp qword [b]

fld qword[c]
fmul qword[array1+16]
fstp qword [c]

;-----------------------------------------


fld qword[a]
fsub qword[b]
fadd qword[c]
fstp qword[detval]

cmp dword [detval+4], 0
je detiszero


push dword [detval+4];
push dword [detval];
push formatdet;
call printf
add esp, 12

;;;;;;;;;;;;;;;;;;;;;;;;;;;; mat determinant over ;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;; creating tranpose ;;;;;;;;;;;;;;;;;;
 mov ebx, 0;
 fld qword [array1+ebx*8]
 fstp qword [array2+ebx*8]

 mov ebx, 1
 fld qword [array1+ebx*8]
 mov ebx, 3
 fstp qword [array2+ebx*8]

 mov ebx, 2
 fld qword [array1+ebx*8]
 mov ebx, 6
 fstp qword [array2+ebx*8]

 mov ebx, 3
 fld qword [array1+ebx*8]
 mov ebx, 1
 fstp qword [array2+ebx*8]

 mov ebx, 3
 fld qword [array1+ebx*8]
 mov ebx, 1
 fstp qword [array2+ebx*8]

 mov ebx, 4
 fld qword [array1+ebx*8]
 fstp qword [array2+ebx*8]

 mov ebx, 5
 fld qword [array1+ebx*8]
 mov ebx, 7
 fstp qword [array2+ebx*8]

 mov ebx, 6
 fld qword [array1+ebx*8]
 mov ebx, 2
 fstp qword [array2+ebx*8]

 mov ebx, 7
 fld qword [array1+ebx*8]
 mov ebx, 5
 fstp qword [array2+ebx*8]

 mov ebx, 8
 fld qword [array1+ebx*8]
 fstp qword [array2+ebx*8]

;;;;;;;;;;;;;;;;;;;;;;;;; creating transpose over ;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;; getting cofactor ;;;;;;;;;;;;;;;;;;
push 5
push 7
push 8
push 4
call getDet
pop ebx
pop ebx
pop ebx
pop ebx
mov ecx, 0
fstp qword [array3+ecx*8]



;---------
push 5
push 6
push 8
push 3
call getDet
pop ebx
pop ebx
pop ebx
pop ebx
mov ecx, 1

fstp qword [tmp]
mov dword [fvr], 0
mov dword [fvr+4], 0
fld qword [fvr]
fsub qword [tmp]

fstp qword [array3+ecx*8]

;---------
push 4
push 6
push 7
push 3
call getDet
pop ebx
pop ebx
pop ebx
pop ebx
mov ecx, 2
fstp qword [array3+ecx*8]

;---------
push 2
push 7
push 8
push 1
call getDet
pop ebx
pop ebx
pop ebx
pop ebx
mov ecx, 3

fstp qword [tmp]
mov dword [fvr], 0
mov dword [fvr+4], 0
fld qword [fvr]
fsub qword [tmp]

fstp qword [array3+ecx*8]

;---------
push 2
push 6
push 8
push 0
call getDet
pop ebx
pop ebx
pop ebx
pop ebx
mov ecx, 4
fstp qword [array3+ecx*8]

;---------
push 1
push 6
push 7
push 0
call getDet
pop ebx
pop ebx
pop ebx
pop ebx
mov ecx, 5

fstp qword [tmp]
mov dword [fvr], 0
mov dword [fvr+4], 0
fld qword [fvr]
fsub qword [tmp]

fstp qword [array3+ecx*8]

;---------
push 2
push 4
push 5
push 1
call getDet
pop ebx
pop ebx
pop ebx
pop ebx
mov ecx, 6
fstp qword [array3+ecx*8]

;---------
push 2
push 3
push 5
push 0
call getDet
pop ebx
pop ebx
pop ebx
pop ebx
mov ecx, 7


fstp qword [tmp]
mov dword [fvr], 0
mov dword [fvr+4], 0
fld qword [fvr]
fsub qword [tmp]

fstp qword [array3+ecx*8]

;---------
push 1
push 3
push 4
push 0
call getDet
pop ebx
pop ebx
pop ebx
pop ebx
mov ecx, 8
fstp qword [array3+ecx*8]

;;;;;;;;;;;;;;;;;;;;;; getting cofactor over ;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;; Division by determinant value ;;;;;;;;;;;;;;;
   mov ebx, 0;

nextdiv:
   fld qword [array3+ebx*8]
   fdiv qword [detval]
   fstp qword [array3+ebx*8]
   inc ebx

   cmp ebx, 9
   jl nextdiv


;;;;;;;;;;;;;;;;;;;;; Division by determinant value over ;;;;;;;;;;;;;;;


;;;;;;;;;; end of computation  getting the time for calcuation ;;;;;;;;
push eax
push edx

xor eax,eax
	
	cpuid
	rdtsc

	sub eax,[CLval]
	sub edx,[CHval]

	mov edx,0
	push eax
	;push edx
	;printing the cycles passed
	push format3
	call printf

pop edx
pop eax

;;;;;;;;;;;;;;;;;;;; Print the mat ;;;;;;;;;;;;;;;;;;;;;
pmat:
   mov ebx, 0;

printMat:

   push dword [array3+ebx*8+4];
   push dword [array3+ebx*8];
   push formatout;
   call printf
   add esp, 12 
   inc ebx
   
   cmp ebx, 3
   je wp

   cmp ebx, 6
   je wp

cnt:
   cmp ebx, 9
   jl printMat

jmp next



wp:
   push newline
   call printf
   add esp, 4
   jmp cnt

next:
;;;;;;;;;;;;;;;;;;;;;;;;; Print matrix over ;;;;;;;;;;;;;;;;;;


exit:
xor ebx, ebx
mov eax, 1
int 80h


detiszero:

push formatdetzero
call printf
add esp, 4

xor ebx, ebx
mov eax, 1
int 80h

;;;;;;;;;;;;;;;;;;;;; Read float value function ;;;;;;;;;;;;;;;;;;;;
readfloat:
push ebp
mov ebp, esp
sub esp, 8
lea eax, [esp]
push eax
push formatin
call scanf
add esp, 8
fld qword [ebp - 8]
mov esp, ebp
pop ebp
ret
;;;;;;;;;;;;;;;;;;;; Read float value fuction over ;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;; Finding determinant of minor matrices function ;;;;;;;;;;;;;;;;;;
getDet:

mov ecx, [esp+12]
fld qword [array2+ecx*8] ; bottom left element
mov ecx, [esp+16]
fmul qword [array2+ecx*8] ; top right element
fstp qword [tmp]

mov ecx, [esp+4]
fld qword[array2+ecx*8] ; top left element
mov ecx, [esp+8]
fmul qword [array2+ecx*8] ; bottom right element

fsub qword[tmp]

ret
;----------



