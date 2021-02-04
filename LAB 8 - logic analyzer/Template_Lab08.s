;*******************************************************************************
;
;    CS 107: Computer Architecture and Organization -- LAB 8
;    Filename: Lab08.s
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
; Step #4 - Define variables 'output' and 'increment' as global.
;
	
	ENTRY
	
main_delay	EQU	50

out_min  	EQU 0
out_max		EQU 1024

; System Init routine
SystemInit
	BX		LR
;
; Main program
;
__main
;
; Step #3 - Write your program in assembler. An approximate algorithm in Python:
;
; output = 0
; increment = 1
; while True:
;    delay(50)
;    output = output + increment
;    if output <= 0 or output >= 1024:
;       increment = -increment
;
; The graphical algorithm is given in the 'Lab08.doc' document.
;

	ALIGN

;
; Step #2 - Copy your 'delay' function from Lab06
;
	
	ALIGN

	AREA 	myData, DATA
;
; Step #1 - Define two variables: 'output' and 'increment'
;
		
	END