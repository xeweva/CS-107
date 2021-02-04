;*******************************************************************************
;
;    CS 107: Computer Architecture and Organization -- LAB 9
;    Filename: Lab09.s
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
;
; Step #2b. Make 'virtual GPIO Pin register' variable GLOBAL (use GLOBAL or EXTERNAL assembler instruction) 
;
	GET		BOARD.S

	ENTRY
;
; Step #3. You will use bit 1 as MOSI, bit 3 as CLK and bit 5 as SS. The delay constant will be 10.
;
SS		EQU		BIT5
CLK		EQU		BIT3
MOSI	EQU		BIT1
	
spi_delay EQU	10
	
;
;          +---+   +---+   +---+   +---+   +---+   +---+   +---+   +---+   
;          !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   
;          !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   
; CLK  ----+   +---+   +---+   +---+   +---+   +---+   +---+   +---+   +---
;
;         -----   ----   -----   -----   -----   -----   -----   -----
;        /     \ /    \ /     \ /     \ /     \ /     \ /     \ /     \   
; MOSI -X       X      X       X       X       X       X       X       X---
;        \     / \    / \     / \     / \     / \     / \     / \     /
;         -----   ----   -----   -----   -----   -----   -----   -----
;  ---+                                                                  +---
;     !                                                                  !
;     !                                                                  !
; SS  +------------------------------------------------------------------+
;
;
;  CPOL = 0; CPHA = 0
;

; System Init routine
SystemInit
;
; Step #7. Write your ‘SystemInit’ function
;

	BX		LR
;
; Main program
;
__main
;
; Step #8. Finally, write your ‘__main’ program. 
;

loop
	B		loop	        ; Loop forever!

	ALIGN

;
; Step #5. Write your ‘spi_slot’ function. spi_slot
;
;spi_slot
	
	ALIGN
;
; Step #6. Write your 'send_byte' function. 
;
;send_byte

	ALIGN

;
; Step #4 You will reuse the 'delay' function you did for Lab06. 
;
;delay
	
	ALIGN

	AREA 	myData, DATA
;
; Step #2a. Define 'virtual GPIO Pin register' in DATA memory.
;
		
	END