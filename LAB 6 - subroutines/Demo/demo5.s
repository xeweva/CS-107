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
loop
	MOV		R0, #0x11111111  ; First parameter
	PUSH	{R0}
	MOV		R0, #0x22222222  ; Second parameter 
	PUSH	{R0}
	MOV		R0, #0x33333333  ; Third parameter
	PUSH	{R0}
	MOV		R0, #0
	MOV		R3, #3
	MOV		R4, #4
	MOV		R5, #5
	BL		sub_stack
	ADD		SP, #12			 ; Clear stack (comment for run-time error)
;   b       loop             ; (uncomment for run-time error)

	MOV		R0, #0x55555555  ; First parameter
	PUSH	{R0}
	MOV		R0, #0x44444444  ; Second parameter 
	PUSH	{R0}
	MOV		R0, #0x44444444  ; Third parameter
	PUSH	{R0}
	MOV		R0, #2
	MOV		R3, #1
	MOV		R4, #0
	MOV		R5, #1
	BL		sub_stack
	ADD		SP, #12			 ; Clear stack

stop
	B		stop
	ALIGN

sub_stack
; func sub_stack(long p1, long p2, long p3)
; {
;   r0 = p1 + p2 + p3
;   return r0
; }
;
; r0 - result
; r3, r4, r5 - temporary variables
;
	PUSH	{R3-R5, LR}   ; save temp. var. registers and LR 
	LDR		R3, [SP, #24] ; First parameter
	LDR		R4, [SP, #20] ; Second parameter
	LDR		R5, [SP, #16] ; Third parameter
	ADD		R0, R3, R4    ; r0 = p1 + p2
	ADD		R0, R5        ; r0 = r0 + p3
	POP		{R3-R5, PC}   ; restore registers and return
	
	ALIGN
		
str_1
	DCB		"HELLO", 0
str_2
	DCB		"CS 107", 0
	ALIGN

	AREA variables, DATA, ALIGN=2
data_mem
str_1_copy
	SPACE	8
str_2_copy
	SPACE	8
		
		
	END