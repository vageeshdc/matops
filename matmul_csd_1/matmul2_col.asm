;assignment 1
;CSD course
;author: vageesh,pankaj
;
;Info : a matrix multiplication implementation
; This is the column major format .. same code except the way the multiplication is done 

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
	format3: db " time taken %d cycles .. ",10,0

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

	;;maj vals
	
	AAA: dd 1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0
	
	BBB: dd  1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0
	
	CCC: dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
	DDD: dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	;;end maj vals


	AA: dd 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
	BB: dd 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
	BB1: dd 1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1
	BB2: dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	CC: dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	DD: dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	i1: dd 0
	j1: dd 0
	k1: dd 0
	k1_t: dd 0

	i2: dd 0
	j2: dd 0
	k2: dd 0
	ia2: dd 0
	ja2: dd 0
	ib2: dd 0
	jb2: dd 0
	ic2: dd 0
	jc2: dd 0
	k2_t: dd 0
	av2: dd 0
	bv2: dd 0
	cv2: dd 0
	bi2: dd 0
	bj2: dd 0
	bk2: dd 0

	i3: dd 0
	j3: dd 0
	k3: dd 0
	bi3: dd 0
	bj3: dd 0
	ia3: dd 0
	ja3: dd 0
	av3: dd 0

	W1: dd 0
	W2: dd 0
	W3: dd 0

	bi: dd 0
	bj: dd 0
	bk: dd 0

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
	;CLval and CHval are for storing clock cycles

	
	;bi,bj are blocks of A bj,bk are the blocks in B
	;A - iXj and B -jXk
	;DDD - tmp space
	;CCC ressult
	;AAA and BBB are the matrices

	;bj
	mov eax,30
	push eax

	;bk
	mov eax,20
	push eax
	
	;bi
	mov eax,10
	push eax

	;j
	mov eax,30
	push eax

	;k
	mov eax,20
    push eax

	;i
	mov eax,10
	push eax

	;D
	mov eax,DDD
	push eax

	;C
	mov eax,CCC
	push eax

	;B
	mov eax,BBB
	push eax

	;A
	mov eax,AAA
	push eax

	;call for the block matrix multiplication
	call mult_block_2d

print_timer:
	;;getting later time

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

	;; print the matrix CCC the result

	mov eax,10
	mov [lop_i],eax

	mov eax,30
	mov [lop_j],eax

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
	add ecx,CCC
	
	mov eax,[ecx]
	push eax
	push format
	call printf

	;;end of print

	;update
	
	mov ebx,[loop_j]
	add ebx,1
	mov [loop_j],ebx

	cmp ebx,[lop_j]
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

	;the params are A[],B[],C[],D[],i,k,j,bi,bk,bj
	; A,B are the ip C is the OP
	; D is the dummy iX[jXk]
	; i j ,j k is the dimension of A and B
	; bi bk,bk bj is the block parameter of A and B

	;matrix A
	mov eax,[esp+4]
	mov [Av],eax

	;matrix B
	mov eax,[esp+8]
	mov [Bv],eax

	;matrix C for solution
	mov eax,[esp+12]
	mov [Cv],eax

	;tmp matrix
	mov eax,[esp+16]
	mov [Dv],eax

	;indices i , k and j
	mov eax,[esp+20]
	mov [i1],eax

	mov eax,[esp+24]
	mov [k1],eax
	
	mov eax,[esp+28]
	mov [j1],eax

	;blocks bi,bk and bj
	mov eax,[esp+32]
	mov [bi],eax

	mov eax,[esp+36]
	mov [bk],eax

	mov eax,[esp+40]
	mov [bj],eax

	;check if the block sizes are multiples
	mov eax,[i1]
	mov ecx,[bi]
	mov edx,0
	;donr specifically
	div ecx

	cmp edx,0
	jne exit_error_noerror

	mov eax,[j1]
	mov ecx,[bj]
	mov edx,0
	;donr specifically
	div ecx

	cmp edx,0
	jne exit_error_noerror

	mov eax,[k1]
	mov ecx,[bk]
	mov edx,0
	;donr specifically
	div ecx

	cmp edx,0
	jne exit_error_noerror


	;use lop_i,lop_j,lop_k as loop indices
	;ind ia ja ib jb ic jc id jd as the offsets for the blocks
	;starting loop from the bottom right corner
	
	mov eax,0
	mov [lop_i],eax
	mov [lop_j],eax


l1:
	
l2:
	mov eax,0
	mov [lop_k],eax
	
l3:
	
	;;multiplication here here
	
	;; the block sizes
	;bj
	mov eax,[bj]
	push eax

	;bk
	mov eax,[bk]
	push eax

	;bi
	mov eax,[bi]
	push eax

	;; matrix dims
	;j
	mov eax,[j1]
	push eax

	;k
	mov eax,[k1]
	push eax

	;i
	mov eax,[i1]
	push eax

	; offsets of C B ans A in order
	;jc
	mov eax,0
	push eax

	;ic
	mov eax,[lop_k]
	imul eax,[bi]
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

	; the matrices
	;C
	mov eax,[Dv]
	push eax

	;b
	mov eax,[Bv]
	push eax

	;a
	mov eax,[Av]
	push eax

	;; call the function for multiplication
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
	pop eax
	pop eax
	pop eax
	pop eax

	;loop management
	mov eax,[lop_k]
	add eax,[bk]
	mov [lop_k],eax

	cmp eax,[k1]
	jl l3

l3_out:

	;; add ops here
	;; multiplied blocks stored in temp place now added
	
	mov eax,0
	mov [lop_k],eax

l4:

	;; push ops

	; the block dimension
	;bj
	mov eax,[bj]
	push eax

	;bi
	mov eax,[bi]
	push eax

	;arr dimension
	;j
	mov eax,[j1]
	push eax

	;i
	mov eax,[i1]
	push eax

	;offsets
	;jc
	mov eax,[lop_j]
	push eax

	;ic
	mov eax,[lop_i]
	push eax

	;jb
	mov eax,0
	push eax

	;ib
	mov eax,[lop_k]
	imul eax,[bi]
	push eax

	;ja
	mov eax,[lop_j]
	push eax

	;ia
	mov eax,[lop_i]
	push eax

	;C
	mov eax,[Cv]
	push eax

	;b
	mov eax,[Dv]
	push eax

	;a
	mov eax,[Cv]
	push eax

	;; call of adding intermediate results
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
	pop eax
	pop eax

	mov eax,[lop_k]
	add eax,[bk]
	mov [lop_k],eax

	cmp eax,[k1]
	jl l4

l4_out:

	;; end of add ops



	mov eax,[lop_j]
	add eax,[bj]
	mov [lop_j],eax

	cmp eax,[j1]
	jl l2

l2_out:
	
	mov eax,0
	mov [lop_j],eax

	mov eax,[lop_i]
	add eax,[bi]
	mov [lop_i],eax

	cmp eax,[i1]
	jl l1

l1_out:
	

exit_error_noerror:
	ret;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mult_mat_2d:
	
	;args a[],b[],C[],ia,ja,ib,jb,ic,jc,i,k,j,bi,bj,bk
	;here  (ij) is the location of blocks A and B wrt to parent matrices
	;Wid is the Width of parent matrix
	;Work under assumption that it is a square
	; A,B,C are the references of parent matrices only
	; here this is the colimn major format

	; mat a
	mov eax,[esp+4]
	mov [av2],eax

	;mat b
	mov eax,[esp+8]
	mov [bv2],eax

	; mat c
	mov eax,[esp+12]
	mov [cv2],eax

	; the offsets
	mov eax,[esp+16]
	mov [ia2],eax

	mov eax,[esp+20]
	mov [ja2],eax

	mov eax,[esp+24]
	mov [ib2],eax

	mov eax,[esp+28]
	mov [jb2],eax

	mov eax,[esp+32]
	mov [ic2],eax

	mov eax,[esp+36]
	mov [jc2],eax

	; the big array dims
	mov eax,[esp+40]
	mov [i2],eax

	mov eax,[esp+44]
	mov [k2],eax

	mov eax,[esp+48]
	mov [j2],eax

	;block sizes
	mov eax,[esp+52]
	mov [bi2],eax

	mov eax,[esp+56]
	mov [bk2],eax

	mov eax,[esp+60]
	mov [bj2],eax

	; iterating using the column first
	mov eax,[bi2]
	sub eax,1
	mov dword [loop_j],eax

	mov eax,[bj2]
	sub eax,1
	mov dword [loop_i],eax

	;done with setting loop variables
	;push and pop eax for counter ops
	
	;find offset
	
	;;A's offset
	mov edx,[ia2]
	;sub edx,1
	imul edx,[k2]
	add edx,[ja2]
	imul edx,4
	mov [aOff],edx
	
	;;B's offset
	mov edx,[ib2]
	;sub edx,1
	imul edx,[j2]
	add edx,[jb2]
	imul edx,4
	mov [bOff],edx
	
	;;C's offset
	mov edx,[ic2]
	;sub edx,1
	imul edx,[j2]
	add edx,[jc2]
	imul edx,4
	mov [cOff],edx
	
out_1:

	;outer loop
out_2:

	;inner loop

	; gettiing B trans
	;current B off
	mov eax,[loop_i]
	imul eax,4
	add eax,[bv2]
	add eax,[bOff]
	mov dword [bVec],eax

	; getting a trans
	;current A off
	mov eax,[loop_j]
	imul eax,[k2]
	imul eax,4
	add eax,[av2]
	add eax,[aOff]
	mov dword [aVec],eax
	
	;;;row multiplication ops here...
	; a row and column are multiplied element wise here
	
	; this has the result
	mov ebx,0
	mov ecx,[bk2]
	sub ecx,1
	
out_3:	
	;getting the element positions for B
	mov eax,ecx
	imul eax,[j2]
	imul eax,4
	add dword eax,[bVec]
	mov edx,[eax]

	; getting element in A
	mov eax,[aVec]
	push ecx
	imul ecx,4
	add eax,ecx
	pop ecx

	;multiplication and store
	imul edx,[eax]
	add ebx,edx
	sub ecx,1
	
	cmp ecx,0
	jge out_3

out_3_exit:
	
    ;;;end of row op...
	
	mov edx,ebx

	; storing as transpose
	;writing result of C
	mov eax,[loop_j]
	imul eax,[i2]
	mov ebx,[loop_i]
	add eax,ebx
	imul eax,4
	add eax,[cOff]
	add eax,[cv2]
	mov [eax],edx
	
	mov eax,[loop_i]
	sub eax,1
	mov dword [loop_i],eax

	cmp eax,0

	jge out_2

out_2_end:


	mov eax,[bj2]
	sub eax,1
	mov dword [loop_i],eax

	mov eax,[loop_j]
	sub eax,1
	mov [loop_j],eax

	cmp eax,0

	jge out_1

out_1_end:

	ret;
	;end of the procedure

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

add_mat_2d:
	;arr A[],B[],C[],ia,ja,ib,jb,ic,jc,i,j,bi,bj
	;here  (ij) is the location of blocks A and B wrt to parent matrices
	;Wid is the Width of parent matrix
	;Work under assumption that it is a square
	; A,B,C are the references of parent matrices only


	; matrices 
	mov eax,[esp+4]
	mov [av2],eax

	mov eax,[esp+8]
	mov [bv2],eax

	mov eax,[esp+12]
	mov [cv2],eax

	; the offsets
	mov eax,[esp+16]
	mov [ia2],eax

	mov eax,[esp+20]
	mov [ja2],eax

	mov eax,[esp+24]
	mov [ib2],eax

	mov eax,[esp+28]
	mov [jb2],eax

	mov eax,[esp+32]
	mov [ic2],eax

	mov eax,[esp+36]
	mov [jc2],eax

	; the arr dimensions
	mov eax,[esp+40]
	mov [i2],eax

	mov eax,[esp+44]
	mov [j2],eax

	;block parameters
	mov eax,[esp+48]
	mov [bi2],eax

	mov eax,[esp+52]
	mov [bj2],eax

	;find offset
	
	;;A's offset
	mov edx,[ia2]
	imul edx,[j2]
	add edx,[ja2]
	imul edx,4
	mov [aOff2],edx
	
	;;B's offset
	mov edx,[ib2]
	imul edx,[j2]
	add edx,[jb2]
	imul edx,4
	mov [bOff2],edx
	
	;;C's offset
	mov edx,[ic2]
	imul edx,[j2]
	add edx,[jc2]
	imul edx,4
	mov [cOff2],edx
	
	mov eax,0
	mov [loop_i],eax

	mov eax,0
	mov [loop_j],eax

out_1a:
	
out_2a:
	
	;;addition logic
	
	;common offset
	mov ebx,[loop_i]
	imul ebx,[j2]
	add ebx,[loop_j]
	imul ebx,4

	;get B[]
	mov ecx,[bv2]
	add ecx,ebx
	add ecx,[bOff2]
	mov eax,[ecx]

	;add A[]
	mov ecx,[av2]
	add ecx,ebx
	add ecx,[aOff2]
	mov edx,[ecx]

	add eax,edx

	;store to C[]
	mov ecx,[cv2]
	add ecx,ebx
	add ecx,[cOff2]
	mov [ecx],eax

	;;end of addition

	mov eax,[loop_j]
	add eax,1
	mov [loop_j],eax

	cmp eax,[bj2]
	jl out_2a

out_2a_end:
	
	mov eax,0
	mov [loop_j],eax

	mov eax,[loop_i]
	add eax,1
	mov [loop_i],eax

	cmp eax,[bi2]
	jl out_1a

out_1a_end:

	ret;
	;end of addition

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; NOT needed ;;;;;;;;;;;;;;;;;;;;

trans_mat_2d:
	;args - A[],i,j,ia,ja,W

	mov eax,[esp+4]
	mov [av3],eax

	mov eax,[esp+8]
	mov [i3],eax

	mov eax,[esp+12]
	mov [j3],eax

	mov eax,[esp+16]
	mov [ia3],eax

	mov eax,[esp+20]
	mov [ja3],eax

	mov eax,[esp+24]
	mov [bj3],eax

	mov eax,0
	mov [loop_i],eax
	mov [loop_j],eax

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

	cmp eax,[loop_i]
	jle tl_2

tl2_out:
	
	mov eax,0
	mov [loop_j],eax

	mov eax,[loop_i]
	add eax,1
	mov [loop_i],eax

	cmp eax,[esp+8]

	jl tl_1

tl1_out:

	ret;;

