;*******************************************************************************
;
;    CS 107: Computer Architecture and Organization -- LAB 6
;    Filename: Lab06.s
;    Date: [YOUR DATE]
;    Author: [YOUR NAME]
;
;*******************************************************************************
;
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
	BX		LR
;
; Main program
;
__main
;
; Test 'delay'
;
; vvvvvv Uncomment when procedure 'delay' is ready to test! vvvvv
;	LDR		R1, =5
;	BL		delay
;	LDR		R1, =0
;	BL		delay
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;
; Test 'my_rbit'
;
; vvvvvv Uncomment when procedure 'my_rbit' is ready to test! vvvvv
;	LDR		R1, = 0x1
;	LDR		R2, = 0x1
;	BL		my_rbit
;	RBIT	R2, R2
;	
;	LDR		R1, = 0x80000000
;	LDR		R2, = 0x80000000
;	BL		my_rbit
;	RBIT	R2, R2
;	
;	LDR		R1, = 0x05000000
;	LDR		R2, = 0x05000000
;	BL		my_rbit
;	RBIT	R2, R2
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;
; Test 'strcpy' and 'strcat'
;
; vvvvvv Uncomment when procedures 'strcpy' and 'strcat' are ready to test! vvvvv
;	LDR		R0, =result_str
;	LDR		R1, =test_str_1
;	BL		strcpy
;	LDR		R1, =test_str_2
;	BL		strcat
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	
stop
	B		stop

	ALIGN

;
; 1. In future labs you will use 'delay' procedure. The procedure may be described as:
;
; void delay(unsigned long rx)
; {
;    while (rx--);
; }
;
; Please note: the procedure should also work for parameter = 0. Check the parameter and return if 0 before the loop. 
;
; Write this procedure in assembler. Pass parameter throw register. rx may be any register of your choice.
; (You may use the 'delay' code from Lab05.)
;
delay
; -- Your code for procedure is here --- 		
	
	CMP 	R1, #0
	SUBNE 	R1, #1
	BNE 	delay
	BEQ		LR             ; return

;
; 2. Write a routine the reverse the bits in a register R1, so then
; a register containing D31 D30 D29 ... D1 D0 now contains D0 D1 ...
; D30 D31. Compare this to the instruction RBIT to check if your
; routine works ok.
;
; Parameter: R1
; Result: R1
; 
; The subroutine should preserve all other registers used.
;
my_rbit
; -- Your code for procedure is here --- 	
	
;	ALLIGN
	

	PUSH	{R0,R2}; save registers
	MOV 	R0, #0; counter
	MOV 	R2, #0; reversed register

my_rbit_loop

	LSRS 	R1, #1; right shift with carry bit
	ORR 	R2, C; add carry bit fo reversed register
	LSL 	R2, #1; left shift reversed register

	ADD 	R0, #1; increase counter
	CMP 	R0, #32; if all bits moved
	BNE 	my_rbit_loop; if not


	LDR, R1, R2; store reversed register to R1

	POP		{R0,R2};	restore registers



;
; 3. Wrirte the standard C 'strcpy' function in Assembler.
;
;    char* strcpy(char* destination, const char* source);
;
; Parameters
;
;    dest - This is the pointer to the destination array where the content is to be copied.
;
;    src - This is the string to be copied.
; Use R0 for 'dest' and R1 for 'src'. The 'src' is a 'constant', so, the procedure should not change R1 as well as all another register(s) used. 
; 
; Result: R0 - original 'dest'
; 
;
strcpy
; -- Your code for procedure is here --- 	 
	
	PUSH 	{R2,R3}; save registers
	LDR 	R2, #0; char pointer

strcpy_loop
	LDRB 	R3, [src, R2]		; load current char
	STRB 	R3, [dest, R2]		; store current char
	ADD 	R2, #1		; move pointer
	CMP  	R3, #0		; if the end of the string is reached
	BNE 	strcpy_loop		; if not reached
	BX		LR             ; return if reached

	POP 	{R2,R3}; restore registers

	;ALIGN

;
; 4. Wrirte the standard C 'strcat' function in Assembler.
;
; char *strcat(char *dest, const char *src)
; 
; Parameters
;
;   dest - This is pointer to the destination array, which should contain a C string, and should be large enough to contain the concatenated resulting string.
;
;   src - This is the string to be appended. This should not overlap the destination.
;
; Use R0 for 'dest' and R1 for 'src'. The 'src' is a 'constant', so, the procedure should not change R1 as well as all another register(s) used. 
; 
; Result: R0 - original 'dest'
; 
; Tip: You may want to call strcpy procedure!
;
; Please note:
; for
;    dst = "Hello "\0
;    src = "World!"\0
;
; Correct result is: dst = "Hello World!"\0
;
; NOT a dst = "Hello "\0"World!"\0
;
;
strcat
; -- Your code for procedure is here --- 	

	;ALIGN

	MOV 	R2, #0; first string last char pointer

find_end_loop
	LDR 	R3, [dst, R2]; 		load current char
	CMP  	R3, #0; if the end of the string found
	ADDNE 	R2, #1; move pointer
	BNE 	find_end_loop	


	ADD 	R0, R2; set adress to first string null char
	strcpy ; add strings

	SUB 	R0, R2; restore original adress
	BX		LR; return 

	

	





-----STRLEN FUNCTION-----
;passing string adress through the stack
;stores strlen in R2
;R0 is a string adress
;R1 is a current char
;R2 is a char count

strlen
	
	PUSH	{R0-R1, LR}; save R0 and R1 registers
	LDR 	R0, {SP, #12} ;load string adress
	MOV 	R2, #0; char number

strlen_loop
	LDRB 	R1, [R0], #1; load current char and move string adress by one char
	CMP 	R1, #0; if the end of the string reached
	ADDNE 	R2, #1;	in no increase char number
	BNE 	strlen_loop

	POP		{R0-R1, LR};	restore registers
	ADD		SP, #8; 	clear stack
	BX		LR; 	return

	
	





	ALIGN

test_str_1
	DCB		"Santa Barbara ", 0
	ALIGN
test_str_2
	DCB		"City College", 0
	ALIGN

	AREA variables, DATA, ALIGN=2
result_str
	SPACE	64

	END
		