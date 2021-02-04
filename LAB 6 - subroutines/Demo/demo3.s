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

str_size
; R0 - source address (input)
; R2 - length of the string (result)
; R3 - temporary variable
; proc str_size(long r0)
; {
;   r2 = 0
;   do 
;   {
;      r3 = Mem[r0++]
;      r2++
;   } while (r3 != 0)
; return r2
; }
;
	MOV		R2, #0        ; Result := 0
str_size_loop
	LDRB	R3, [R0], #1  ; r3 = Mem[r0++]
	ADD		R2, R2, #1    ; r2++
	TEQ		R3, #0		  ; r3 == 0 ???
	BNE		str_size_loop ; while (r3 != 0) 
	BX		LR            ; return
	
	ALIGN

str_copy
; R0 - source address
; R1 - destination address
; R2 - size of the string (including '\0'}
; R3 - temporary variable
;
; r2 = str_size(r0)
; do
; {
;	 r3 = Mem[r0++]
;    Mem[r1++] = r3
;    r2--
; } while (r2 > 0)
;
    BL		str_size	   ; r2 = str_size(r0)
str_copy_loop
	LDRB	R3, [R0], #1   ; r3 = Mem[r0++]
	STRB	R3, [R1], #1   ; Mem[r1++] = r3
	SUBS	R2, #1         ; r2--
	BGT		str_copy_loop  ; while (r2 > 0)
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