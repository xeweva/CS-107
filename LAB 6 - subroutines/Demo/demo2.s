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
	MOV		R2, #0x25252525
	LDR		R0, =str_1
	LDR		R1, =str_1_copy
	BL		str_copy
	
	MOV		R2, #0x52525252
	LDR		R0, =str_2
	LDR		R1, =str_2_copy
	BL		str_copy

stop
	B		stop
	ALIGN
	
str_copy
; R0 - source address
; R1 - destination address
; R2 - temporary variable
;
; do
; {
;	 r2 = Mem[r0++]
;    Mem[r1++] = r2
; } while (r2 != 0)
;
	PUSH	{R2}           ; Save r2 to stack
str_copy_loop
	LDRB	R2, [R0], #1   ; r2 = Mem[r0++]
	STRB	R2, [R1], #1   ; Mem[r1++] = r2
	TEQ		R2, #0         ; r2 == 0 ???
	BNE		str_copy_loop  ; while (r2 != 0)
	POP		{R2}           ; Restore r2
	BX		LR             ; return
	
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