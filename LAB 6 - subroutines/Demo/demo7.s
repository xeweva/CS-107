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
	LDR		R0, =str_2_copy
	ADD		R0, #0x8
	MOV		R1, #0xfefefefe
	LDR		R2, =0x100
Fill_loop
	STR		R1, [R0], #4
	SUBS	R2, #1
	BNE		Fill_loop	
	BX		LR
;
; Main program
;
__main
;
   LDR  R0, =ABC ; r0 = address of MAXAB
   LDR  R1, =A   ; r1 = address of A
   LDR  R2, =B   ; r2 = address of B
   BL   __max
;  MAX(MAXAB, A, B)
;//  A = 5; B = 10

	ALIGN

	AREA variables, DATA, ALIGN=2
data_mem
str_1_copy
	SPACE	8
str_2_copy
	SPACE	8
		
		
	END