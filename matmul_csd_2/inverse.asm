SECTION .data
    message1: db "Enter the matrix: ", 0
    message3: db "Here: ", 0
    message2: db "Enter the second number: ", 0
    formatin: db "%d", 0
    formatout: db "%d", 10, 0 ; newline, nul terminator
    formatdet: db "Determinant of the Matrix is: %d", 10, 0 ; newline, nul terminator
    integer1: times 4 db 0 ; 32-bits integer = 4 bytes
    integer2: times 4 db 0 ;
    mat: dd 6,4,5,7,8,9,0,0,0
    a: dd 0;
    b: dd 0;
    c: dd 0;
    add1: dd 0
    add2: dd 0
    detval: dd 0
SEGMENT .bss
    array1:  resd 10
    array2:  resd 10
    array3:  resd 10
    array4:  resd 10
    tmp: resd 1
SECTION .text
   global main 
   extern scanf 
   extern printf     

main:

   push ebx ; save registers
   push ecx
   push message1
   call printf
   add esp, 4 ; remove parameters





;;;;;;   push integer1 ; address of integer1 (second parameter)



;;;;;;;;;;;;;;;;;;;;;;;;;;; Reading mat ;;;;;;;;;;;;;;;;;;;;;;;;;;
readmat:
   mov eax, 9;	
   mov ebx, 0;
   mov [a], eax;
   mov [b], ebx; 
   
inputMat:
   
   push add1;
   push formatin ; arguments are right to left (first parameter)
   call scanf
   add esp, 8; removing parameter.
   mov ecx, [add1]
   
   
   mov [array1+ebx*4], ecx   
   inc ebx;

   mov eax, [a]
   sub eax, 1; 
   mov [a], eax;   
   cmp eax, [b];	

   jne inputMat;
;;;;;;;;;;;;;;;;;;;;;;; Read mat over ;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;; Calculate mat determinant ;;;;;;;;;;;;;;

mov ecx, 4
mov eax, [array1+ecx*4] ; 5th element
mov ecx, 8
mov ebx, [array1+ecx*4] ; 9th element
mul ebx			; 5th * 9th in eax

mov [a], eax

mov ecx, 7
mov eax, [array1+ecx*4] ; 8th element
mov ecx, 5
mov ebx, [array1+ecx*4] ; 6th element
mul ebx			; 8th * 6th in eax

mov ebx, [a]
sub ebx, eax
mov [a], ebx
;----------

mov ecx, 3
mov eax, [array1+ecx*4] ; 4th element
mov ecx, 8
mov ebx, [array1+ecx*4] ; 9th element
mul ebx			; 4th * 9th in eax

mov [b], eax

mov ecx, 6
mov eax, [array1+ecx*4] ; 7th element
mov ecx, 5
mov ebx, [array1+ecx*4] ; 6th element
mul ebx			; 7th * 6th in eax


mov ebx, [b]
sub ebx, eax
mov [b], ebx



;---------

mov ecx, 3
mov eax, [array1+ecx*4] ; 4th element
mov ecx, 7
mov ebx, [array1+ecx*4] ; 8th element
mul ebx			; 4th * 8th in eax

mov [c], eax

mov ecx, 6
mov eax, [array1+ecx*4] ; 7th element
mov ecx, 4
mov ebx, [array1+ecx*4] ; 5th element
mul ebx			; 7th * 5th in eax

mov ebx, [c]
sub ebx, eax
mov [c], ebx

;------------------------------------



mov eax, [array1]
mov ebx, [a]
mul ebx;
mov [a], eax


mov eax, [array1+4]
mov ebx, [b]
mul ebx;
mov [b], eax


mov eax, [array1+8]
mov ebx, [c]
mul ebx;
mov [c], eax



;---------------

mov eax, [a]
mov ebx, [b]
sub eax, ebx
mov ebx, [c]
add eax, ebx
mov [a], eax
mov [detval], eax

push eax
push formatdet;
call printf
add esp, 8 ; remove parameters
;;;;;;;;;;;;;;;;;;;;;;;;;;;; mat determinant over ;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;; Creating transpose ;;;;;;;;;;;;;

 mov ebx, 0; 
 mov eax, [array1+ebx*4]
 mov [array2+ebx*4], eax

 mov ebx, 1
 mov eax, [array1+ebx*4]
 mov ebx, 3
 mov [array2+ebx*4], eax

 mov ebx, 2
 mov eax, [array1+ebx*4]
 mov ebx, 6
 mov [array2+ebx*4], eax

 mov ebx, 3
 mov eax, [array1+ebx*4]
 mov ebx, 1
 mov [array2+ebx*4], eax

 mov ebx, 3
 mov eax, [array1+ebx*4]
 mov ebx, 1
 mov [array2+ebx*4], eax

 mov ebx, 4
 mov eax, [array1+ebx*4]
 mov [array2+ebx*4], eax

 mov ebx, 5
 mov eax, [array1+ebx*4]
 mov ebx, 7
 mov [array2+ebx*4], eax

 mov ebx, 6
 mov eax, [array1+ebx*4]
 mov ebx, 2
 mov [array2+ebx*4], eax

 mov ebx, 7
 mov eax, [array1+ebx*4]
 mov ebx, 5
 mov [array2+ebx*4], eax

 mov ebx, 8
 mov eax, [array1+ebx*4]
 mov [array2+ebx*4], eax

;;;;;;;;;;;;;;;;;;;;; Creating transpose over ;;;;;;;;;;;;


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
mov [array3+ecx*4], eax

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

mov ebx, eax
mov eax, 0
sub eax, ebx

mov [array3+ecx*4], eax



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
mov [array3+ecx*4], eax

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
mov ebx, eax
mov eax, 0
sub eax, ebx
mov [array3+ecx*4], eax

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
mov [array3+ecx*4], eax

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
mov ebx, eax
mov eax, 0
sub eax, ebx
mov [array3+ecx*4], eax

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
mov [array3+ecx*4], eax

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
mov ebx, eax
mov eax, 0
sub eax, ebx
mov [array3+ecx*4], eax

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
mov [array3+ecx*4], eax

;;;;;;;;;;;;;;;;;;;;;; getting cofactor over ;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;; Division by determinant value ;;;;;;;;;;;;;;;
   mov eax, 9;  
   mov ebx, 0;
   mov [a], eax;
   mov [b], ebx; 
   
   mov edx, 0	

nextdiv:
   mov eax, [array3+ebx*4]

a1:
   mov ecx, [detval]
   div ecx
a2:
   mov [array4+ebx*4], eax
   inc ebx


   mov eax, [a]
   sub eax, 1; 
   mov [a], eax;   
   cmp eax, [b];        

   jne nextdiv;


;;;;;;;;;;;;;;;;;;;;; Division by determinant value over ;;;;;;;;;;;;;;;










;call test


;;;;;;;;;;;;;;;;;;;; Print the mat ;;;;;;;;;;;;;;;;;;;;;
pmat:
   mov eax, 9;	
   mov ebx, 0;
   mov [a], eax;
   mov [b], ebx; 
   
printMat:
   
l1:
   push dword [array4+ebx*4];
   push formatout;
   call printf
   add esp, 8 ; remove parameters
   inc ebx

l2:
   mov eax, [a]
   sub eax, 1; 
   mov [a], eax;   
   cmp eax, [b];	

   jne printMat;
   add esp, 8 ; remove parameters
;;;;;;;;;;;;;;;;;;;;; Print matrix over ;;;;;;;;;;;;;;;;;;

exit:
xor ebx, ebx
mov eax, 1
int 80h


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; test function ;;;;;;;;;;;;;;;;;;;
test:
   mov ebx, [esp+4]
   push ebx
   push formatout
   call printf
   add esp, 8 ; remove parameters
ret;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; test function over ;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;; Finding determinant of minor matrices ;;;;;;;;;;;;;;;;;;
getDet:

mov ecx, [esp+4]
mov eax, [array2+ecx*4] ; top left element
mov ecx, [esp+8]
mov ebx, [array2+ecx*4] ; bottom right element
mul ebx			

mov [a], eax

mov ecx, [esp+12]
mov eax, [array2+ecx*4] ; bottom left element
mov ecx, [esp+16]
mov ebx, [array2+ecx*4] ; top right element
mul ebx		

mov ebx, [a]
sub ebx, eax
mov eax, ebx

ret
;----------




