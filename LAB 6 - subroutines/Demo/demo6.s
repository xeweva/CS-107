	GLOBAL __main
	AREA main, CODE, READONLY
	EXPORT __main
	EXPORT __use_two_region_memory
__use_two_region_memory EQU 0
	EXPORT SystemInit
	ENTRY


; System Init routine
SystemInit
;
; Clear data memory...
	LDR		R0, =data_mem
	MOV		R1, #0xffffffff
	MOV		R2, #64			; 256 / 4 = 64
clr_loop
	STR		R1, [R0], #4
	SUBS	R2, #1
	BNE		clr_loop
FillStack
	LDR		R0, =MAXAB
	ADD		R0, #0x4
	MOV		R1, #0xfefefefe
	LDR		R2, =0x100
Fill_loop
	STR		R1, [R0], #4
	SUBS	R2, #1
	BNE		Fill_loop	

    LDR  	R1, =A   ; r1 = address of A
	MOV		R0, #5
	STR		R0, [R1]
    LDR  	R1, =B   ; r1 = address of B
	MOV		R0, #10
	STR		R0, [R1]

	BX		LR
;
; Main program
;
__main

	LDR		R0, =MAXAB ; r0 = address of MAXAB
	LDR		R1, =A     ; r1 = address of A
	LDR		R2, =B     ; r2 = address of B
	BL		__max

stop
	B		stop
	ALIGN

__max
; MAX(var result, var a, var b)
; R0 – result (address)
; R1 - a (address)
; R2 – b (address)
	PUSH  {R3, R4, LR}	; save working registers 
						; and LR
	LDR   R3, [R1]		; R3 = A	
	LDR   R4, [R2]		; R4 = B
	CMP   R3, R4		; if (R3 < R4)
	MOVLT R3, R4		;    R3 = R4
	STR   R3, [R0]		; result = r3
	POP   {R3, R4, PC}	; restore regs. and return

	ALIGN

	AREA variables, DATA, ALIGN=2
data_mem
A
	SPACE 4
B
	SPACE 4
MAXAB
	SPACE 4
	   
	END