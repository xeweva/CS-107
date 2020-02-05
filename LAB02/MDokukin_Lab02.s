;*******************************************************************************
;
;    CS 107: Computer Architecture and Organization -- LAB 2
;    Filename: Lab02.s
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
; 1. Write four different instructions that clear register R7 to zero.
;
;    - Your commands should works for any number in R7
;
;    - Do not use "LDR Rx, =..." command!
;
	MOV		R7, #0x11111111
	MOV 	R7, #0X00000000
	
	MOV		R7, #0x22222222
	AND 	R7, #0X00000000
;-- Your instruction here ---
;	
	MOV		R7, #0x33333333
	BIC 	R7, #0XFFFFFFFF
;-- Your instruction here ---
;	
	MOV		R7, #0x44444444
	SUB		R7, R7
;-- Your instruction here ---

	MOV		R7, #0x55555555
	BIC 	R7, R7

;
; 2. You have some positive non-zero two's complement number into R0
;
;    Write an instruction(s) to change a sign of the number in R0.
;    
;    - Your command(s) should works for any number in R0
;
;    - Do not use any other registers!
;
; -- Place your code here! --

	MOV 	R0, #0X000000FF
	EOR		R0, #0XFFFFFFFF
	
;    Write some other instruction(s) to change a sign of the number in R0 again. 
;
;    - Use some another command(s) to do it
;
;    - Do not use any other registers!
;
; -- Place your code here! --
	MOV 	R0, #0X000000FF
	MVN 	R0, R0

;    Check yourself: Do you have your original number in R0?
;
;    Can you change the sign by using some thrid way?
;
;    - Do not use any other registers!
;
; -- Place your code here! --


;
; 3. Write instructions that set bits 0, 4 and 12 to 1,
;    then clear (sets to 0's) bits 31 and 8,
;    and invert bit 5 in register R6 and leave the 
;    remaining bits unchanged. 
;
;    Bit 0 is less significant bit, the bit 31 is most 
;    significant one
;
;    - Your code should works for any number in R6
;
;    - Do not use "LDR Rx, =..." command!
;	
; +----+-----------------------+---+---+
; ! 31 !    ... R6 bits  ...   ! 1 ! 0 !
; +----+-----------------------+---+---+
;
; (0x9EB1)
;
	MOVW	R6, #0x8F80
	MOVT	R6, #0x8000
;
; -- Place your code here! --
	
	MOVW 	R0, #0x1011
	ORR		R6, R0 ; SETTING BITS 0 4 AND 12 TO 1
	
	MOVW	R0, #0XFEFF
	MOVT	R0, #0X7FFF
	AND	R6, R0 ; CLEARING BITS 8 AND 32
	
	EOR 	R6, #0X20 ; INVERTING BIT 5

;
; 4. Suppose you have some 32-bit number in register R0. Give the instructions 
;    that would replace lower half of register R0 by the value of 0x7777. High
;    16 bits should be remains unchanged.
;
;    - You may use one additional register to do it.
;
;    - Your code should works for any number in R6
;
;    - Do not use "LDR Rx, =..." command!
;
	MOVW	R0, #0x658A
	MOVT	R0, #0xBBFF
;	
; -- Place your code here! --
	MOVW	R1, #0x7777
	MOVT	R1, #0xBBFF
	MOV 	R0, R1
;
;    Try another way to do it without using any other register(s)
;
	MOVW	R0, #0x5678
	MOVT	R0, #0x1234
;
; -- Place your code here! --

	BIC 	R0, #0x00FF
	BIC 	R0, #0x00FF << 8
	
	EOR 	R0, #0x0077
	EOR 	R0, #0x0077 << 8

;
; 5. Store 0x3FFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF into R4, R5, R6 and R7 
;
;    (R4 = 0x3FFFFFFF, R5 = 0xFFFFFFFF, R6 = 0xFFFFFFFF and R7 = 0xFFFFFFFF) 
;
;    Store 0, 0, 0, and 1 into R8, R9, R10 and R11 
; 
;    Write a program to add 128-bit numbers together, placing the result in registers
;    R0 (MSL), R1, R2 and R3 (LSB). The first operand should is in registers R4 (MSB), R5,
;    R6 and R7 {LSB), and the second operand in registers R8 (MSB), R9, R10, and R11 (LSB).
;
;    - Your code should works correctly for any numbers in R4-R11
;
;    - Do not use "LDR Rx, =..." command!
;
;  ( 0x40000000, 0x00000000, 0x00000000, 0x00000000 )
;
; -- Place your code here! --

	MOV 	R4, #0x00FF00FF
	ORR		R4, #0x0000FF00
	ORR 	R4, #0x3F000000

	MOV		R5, #0XFFFFFFFF
	MOV		R6, #0XFFFFFFFF
	MOV		R7, #0XFFFFFFFF
	
	MOV 	R8, #0
	MOV 	R9, #0
	MOV 	R10, #0
	MOV 	R11, #1
	
	ADDS 	R3, R7, R11;
	ADCS 	R2, R6, R10;
	ADCS 	R1, R5, R9;
	ADCS 	R0, R4, R8;
	
	
;
;
; 6. Temperature conversion between Celsius and Fahrenheit can be computed using
;    the relationship
;
;    C = (5 / 9) * (F - 32)
;
;    where C and F are in degrees (signed integer). Celsius value is in R0, the result 
;    should be stored in R1 (signed integer). 
;
;    Try 24C, 46C, 0C, -4C, -25C
;
;    - Convert your hexadecimal result in R1 to decimal (signed).
;      ( https://www.rapidtables.com/convert/number/hex-to-decimal.html ) 
;
;    - Use Google online C to F conversion tool to check your results.
;
;    - Do not use "LDR Rx, =..." command!
;
	MOV		R0, #-25		; 24 deg C
; -- Place your code here! --

	MOV		R1, #9
	MOV		R2, #5
	MOV 	R3, #32
	
	MUL 	R0, R1
	SDIV 	R0, R2
	ADD 	R0, R3
	
;
; What to do to see tenths of Fahrenheit?
;
	MOV		R0, #21	

	MOV 	R4, #10 ;//MULTIPLIER
	MUL		R0, R4 ;//MULTIPLY BY 10 TO SEE 1 DIGIT AFTER ,
	
	MOV		R1, #9
	MOV		R2, #5
	MOV 	R3, #32 
	
	MUL 	R3, R4 ;// 32 * MULTIPLIER
	
	MUL 	R0, R1
	SDIV 	R0, R2
	ADD 	R0, R3
	
	;//RESULT HAS TO BE DIVIDED MY MULTIPLIER (I HAVE NO IDEA HOW TO WORK WITH FLOAT, SO RESULT HAS TO BE DIVIDED MANUALLY)
	
;
; 7. Make code to write the number 0x5555AAAA to R0. You may use only one 'MOV', 'MOVW' or 'MOVT' command 
;    and one or more any other command(s)...
;
;    - Do not use "LDR Rx, =..." command!
;
;    Tip: Use barrel shifter.
;
; -- Place your code here! --

	MOV 	R0, #0xAA
	ORR 	R0, #0xAA00
	ORR 	R0, #0x550000
	ORR 	R0, #0x55000000
;
;    Add one more command to maker R0 equal to 0xAAAA5555

	MVN R0, R0

;
;-- Your instruction here ---
	; ? ROR R0, #32


;
; 8. Make code to write the number 0x7FF80 to R0. You may use only one 'MOV', 'MOVW' or 'MOVT' command 
;    and one or more any other command(s)...
;
;    Tip: Use may want to use paper and pencil to find the solution...
;    Tip: Barrel shifter may be your friend again.
;
;    - Do not use "LDR Rx, =..." command!
;
; -- Place your code here! --

	MOV		R0, 0x80
	ORR		R0, 0xFF00
	ORR		R0, 0x70000


;
; 9. Cortex-M4 has 'ROR' (Rotate right) command but have no ROL (Rotate left) command. 
;    Rotate Left by 1 bit is:
;
;         +--------------->------------------>+
;         !                                   !
; +---+   ! +--+--+-----------------+--+--+   !
; ! C !<--+-!  !  !     . . .       !  !  !<--+
; +---+     +--+--+-----------------+--+--+
;
;    - Test your code with R0 = 0xC0005003   (Result: R0=0x8000A007, Flag C = 1)
;    - Test your code with R0 = 0x80000000   (Result: R0=0x00000001, Flag C = 1)
;
	MOVW	R0, #0x5003
	MOVT	R0, #0xC000
;	MOV		R0, #0x80000000
; -- Place your code here! --

	LSLS	R0, #1
	ADC		R0, #0
	

;
; 10. Cortex-M4 has command to divide numbers, but have no command to get a remainder.
;
;	  Store some positive unsigned numbers into R0 and R1 (R0 > R1)
;
;     Write the code to do:
;
;     R2 = R0 / R1    (Result of unsigned division)
;	  R3 = R0 mod D1  (Remainder)
;
;     Check your code with different numbers.
;
; -- Place your code here! --
	MOV 	R0, #125
	MOV		R1, #7
	
	SDIV 	R2, R0, R1
	MUL		R4, R1, R2
	SUB 	R3, R0, R4
	
	
	
;
; 11. Without using MUL instruction, give instructions that multiply register R4 by:
;
;     R4 = R4 * 16384  (one command)
;     R4 = R4 * 257    (one command)
;     R4 = R4 * 255    (one command)
;     R4 = R4 * 18     (two command)
;     R4 = R4 * 135    (two commands)
;
;     - Do not use any other register(s)
;
;     - Convert your hexadecimal results in R4 to decimal 
;       (use online converter https://www.rapidtables.com/convert/number/hex-to-decimal.html) 
;       to check your results.
;
;     - Your commands should work for any number in R4.
;
	MOV		R4, #1
; -- Place one commands here! --
	LSL 	R4, #14 ;16384
;
	MOV		R4, #1
; -- Place one commands here! --
	ADD 	R4, R4, LSL #8 ;257
;
	MOV		R4, #1
; -- Place one commands here! -- 
;	MOV 	R5, R4, LSL#8  ; it should be a way to make a shift within SUB operator
;	SUB 	R4, R5, R4;255

	RSB 	R4, R4, LSL #8

;
	MOV		R4, #1
; -- Place two commands here! --
	MOV 	R5, #18
	MUL 	R4, R5 ;18
;
	MOV		R4, #1
; -- Place two commands here! --
	MOV 	R5, #135
	MUL 	R4, R5 ;135

stop
	B		stop
	
	END