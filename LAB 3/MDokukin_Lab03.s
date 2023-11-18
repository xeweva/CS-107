;*******************************************************************************
;
;    CS 107: Computer Architecture and Organization -- LAB 3
;    Filename: Lab03.s
;    Date: 02/11/2020
;    Author: Max Dokukin
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
; 1. Code the following IF-THEN statement:
;
;    if (r2 != r7)
;       r2 = r2 - r7;
;    else
;	    r2 = r2 + r4;
;
;    Your code have to work with any numbers in R2, R7 and R4
;    (5, 25(0x19))
;
	MOVW	R2, #10
	MOVW	R7, #5
	MOVW	R4, #15
;
;	MOVW	R2, #10
;	MOVW	R7, #10
;	MOVW	R4, #15
;
;-- Your instructions here ---
;-- Approx. 3 instructions ---
	CMP 	R2, R7
	ADDNE		R2, R4	
	SUBEQ 	R2, R7


;
; 2. Write a program that converts a hexadecimal value between 0x0 and 0xf in register
;    R0 into its ASCII representation. Store ASCII representation into R1.
;
;    Digits '0' through '9' are represented with the ASCII codes 0x30 to 0x39. The digits 
;    'A' through 'F' are coded as 0x41 through 0x46. (See 'ascii.pdf' file)
;
;    Test your code with R0 = 15, 0 and 9
;    (0x46, 0x30, 0x39)
;
	MOV		R0, #15
;	MOV		R0, #0
;	MOV		R0, #9

;	if(r0 < 10)
;		r1 = #0x30
;	else
;		r1 = #0x37;
;
;	add r1, r0
;	
;-- Your instructions here ---
	CMP		R0, #10
	MOVGT	R1, #0x37 ; set up bias FOR 10 AND MORE
	MOVLT	R1, #0x30 ;set up bias FOR 9 AND LESS
	ADD		R1, R0 ; add value
;
;
; 3. Modify the code you did for task #2 to check for valid number (0..15) in R0. 
;    Store '*' (0x2a) into R1 if R0 is out of valid range. Store ASCII representation
;    for valid numbers (from 0 to 15 inclusive).
;
;    Test your code with R0 = 255, 15, 0, 9, 12 and 16
;    (0x2a, 0x46, 0x30, 0x39, 0x43, 0x2a)
;
;	MOV		R0, #255
;	MOV		R0, #15
;	MOV		R0, #0
	MOV		R0, #9
;	MOV		R0, #12
;	MOV		R0, #16
	
;-- Your instructions here ---
	CMP		R0, #16 ; >15 filter
	BGT		out_of_range
	
	CMP 	R0, #0 ; negative filter
	BLT		out_of_range

	CMP		R0, #10
	MOVGT	R1, #0x37 ; set up bias FOR 10 AND MORE
	MOVLT	R1, #0x30 ;set up bias FOR 9 AND LESS
	ADD		R1, R0 ; add value
	
out_of_range
	MOV 	R1, #0x2a 
	

;
; 4. Write a program that counts number of binary '1's and number of binary '0's in R0.
;    Save number of '1's into R1, number of '0's in R2. You may use any other register(s) and
;    do not need to preserve the value of R0 register.
;
;    Your code have to work with any number in R0
;
;    Debug your program with tets values R0 = 0xAAAAAAAA and R0 = 0x55555555. Both should give 
;    you 16 1's and 16 0's
;
;    Then run your progarm with R0 = 0x708. Is your result correct? (use online converter to check)

;	MOV		R0, #0xAAAAAAAA
;	MOV		R0, #0x55555555
	MOVW	R0, #0x708

;-- Your instructions here ---
	MOV		R3, #1
	MOV		R1, #0
	MOV		R2, #0
	MOV		R4, #0
	
bin_cnt_loop
	
		AND 	R4, R0, R3
		CMP 	R4, #0
		BNE		it_was_1
		ADD		R2, #1   ; add zero cnt
		B 		loop_if_quit
		
it_was_1
		ADD		R1, #1   ;add 1 count
		
loop_if_quit
		LSLS 	R3, #1

		BCC bin_cnt_loop


;
; 5. Write a "shift, test and restore" division algorithm (See "Binary Division.pdf" for details).
;
;    For i = 1 to 32 do { we're using 32-bit representations }
;    { 
;	    Left Shift the RQ pair
;       Subtract the Divisor from R
;       If R is positive then
;          Set the low order (right most) bit in Q to 1
;       Else
;          Restore R by Adding back the Divisor
;    }
;
;    R0 = remainder         (R)
;    R1 = divident/quotient (Q)
;    R2 = divisor           (D)
;
;    R1,R0 = R1/R2
;
;    Do not use UDIV and SDIV ARM commands!
;
;    Your code have to work with any valid numbers in R0. You may use any other register(s). Check your 
;    code with given values first. Then  try some another numbers in R1 and R2.

	MOV		R0, 0
	MOVW	R1, #1000	; 163/10 = 16, 3
	MOVW	R2, #29		
	MOV		R3, #0
	MOV		R4, #0 ; COUNTER


;-- Your instructions here ---

division_loop
	
	;DOUBLE SHIFT
	LSLS	R1, #1 ; Q<<1 + SET CARRY BIT
	LSL		R0, #1 ; R<<1
	ADDCS	R0, #1 ; ADD CARRY BIT
	
	
	CMP 	R0, R2 ;R >= B
	ORRGE	R1, #1 ;SET LSB
	SUBGE	R0, R2 ;R = R - B
	
	
	;LOOP CMDS
	ADD		R4, #1  ;i++
	CMP		R4, #32	; loop exit
	BLT		division_loop

;
; 6. Write a small program to compare two 64-bit values. Set R0 to 0 if two values 
;    are equal, set R0 to 1 if two values are not equal. First 64-bit number placed into 
;    R1(HI bits) and R2(LO bits), second number is in R3(HI bits) and R4(LO bits). Use only
;    4 ARM instructions!
;
;    Your code have to work with any numbers in R1-R4
; 
;    Check your code with all test sets below
;
	MOV		R1, #0xAAAAAAAA
	MOV		R2, #0x55555555
;	MOV		R3, #0xAAAAAAAA
;	MOV		R4, #0x55555555
; ----	
;	MOV		R3, #0x55555555
;	MOV		R4, #0xAAAAAAAA
; ----	
	MOV		R3, #0xAAAAAAAA
	MOV		R4, #0xAAAAAAAA
; ----	
;	MOV		R3, #0x55555555
;	MOV		R4, #0x55555555
	
;-- Your 4 instructions here ---
	MOV		R0, #1
	CMP		R1, R3
	CMPEQ	R2, R4
	MOVEQ	R0, #0
	
	

;
; 7. (Bonus). Write a code that allows you to rotate 64-bit values in registers 
;    R0 and R1. The code should shift value left...
;
;    +--------------------+   +--------------------+
; +<-!         R0         !<--!         R1         !<--+
; !  +--------------------+   +--------------------+   !
; !                                                    !
; +-->---------------------->------------------------->+
;
;    ...then right by one bit.
;
;    +--------------------+   +--------------------+
; +->!         R0         !-->!         R1         !-->+
; !  +--------------------+   +--------------------+   !
; !                                                    !
; +<------------------------<-----------------------<--+
;
;    - Do not use any other registers.
;
;    - Make sure that after two shifts the final value is equal to original one.
;
;    Tip: Left shift is tricky. You may remember: a << 1 = a * 2; a * 2 = ???
;    ... and take care of LSB...
; 
;    Check your code with all 3 test sets below:
;
	MOVW	R0, #0x0001
	MOVT	R0, #0x8000
	MOVW	R1, #0x0001
	MOVT	R1, #0x8000
; ----	
;	MOVW	R0, #0xAAAA
;	MOVT	R0, #0x8555
;	MOVW	R1, #0x0F0F
;	MOVT	R1, #0xF0F0
; ----	
;	MOV		R0, #0x00000001
;	MOV		R1, #0x00000001
;
; -- left --
;--     Your instructions here    ---
;-- May be done in 3 instructions ---

; -- right --
;--     Your instructions here    ---
;-- May be done in 3 instructions ---


; 8. (Bonus++). Write a program that check if the binary pattern 2_11001010 are presented at least once 
;    somewhere in the number R0. The program should set R1 to 1 if the pattern is found, and clear R1 to 0 
;    if no pattern in the R0. 
; 
;    Your code have to work with any number in R0
;
;    Your code have to preserve (do not change) the value in R0
;
;    You may use any other registers
;
;    Examples: the number 2_11001101100100101111001010101100 (0xCD92F2AC) has the pattern inside
;                                             --------
;                         2_11001100110011001100110110010100 (0xCCCCCD94) has the pattern inside
;                                                  --------
;                         2_11011010101101110011100111010101 (0xDAB739D5) - no pattern
;
	MOVW	R0, #0xF2AC
	MOVT	R0, #0xCD92
;---
;	MOVW	R0, #0xCD94
;	MOVT	R0, #0xCCCC
;---
;	MOVW	R0, #0x39D5
;	MOVT	R0, #0xDAB7

;-- Your instructions here ---


stop
	B		stop
	
	END