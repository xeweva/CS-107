;*******************************************************************************
;
;    CS 107: Computer Architecture and Organization -- LAB 5
;    Filename: Lab05.s
;    Date: 3/10/2020
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

	GET		BOARD.S

; You may want to define some constant(s) for delay and/or bitmask.
; if so, do it below this lines or uncomment following lines and
; type proper constant(s) instead of '??????'
;
main_delay	EQU	2500000
RGB_PINS	EQU RGBLED_R_BIT
RGB_DIR_MASK	EQU	RGB_PINS 

; System Init routine
SystemInit
;
; Configure GPIO Pins
;
; --- Write your pin configuration code here....

   LDR	R0, =RGBLED_IOCONF_PORT        ; Base Addr. Of IOCON registers 
   MOV	R1, #RGBLED_R_IOCONF_CFG       ; Conf. bits  
   STR	R1, [R0, #RGBLED_R_IOCONF_PIN] ; Write conf. bits to register..

   MOV	R1, #RGBLED_G_IOCONF_CFG       ; Conf. bits  
   STR	R1, [R0, #RGBLED_G_IOCONF_PIN] ; Write conf. bits to register..

   MOV	R1, #RGBLED_B_IOCONF_CFG       ; Conf. bits  
   STR	R1, [R0, #RGBLED_B_IOCONF_PIN] ; Write conf. bits to register..

;
; Set pins for output
;
	LDR	R0, =RGBLED_PORT 	; R0 = Port 1 Base address
	LDR	R1, =RGB_DIR_MASK	; R1 = direction mask
	LDR	R2, [R0, #DIR]	; Read DIR1 register.
	ORR	R2, R2, R1		; R2 = R2 OR R1
	STR	R2, [R0, #DIR]	; Store result to DIR1 

;
; Turn all off!
;
	STR	R1, [R0, #RGBLED_OFF] ; Turn all LEDs OFF…
;
	BX		LR
;
	ALIGN

__main
;
	LDR	R1, =RGBLED_PORT  ; R1 is base address of LEDs GPIO Port
	LDR	R2, =RGB_PINS	     ; R2 is bitmap

loop
	LDR		R3, =main_delay
delay_loop
	SUBS	R3, #1
	BNE		delay_loop
;
; Invert pin(s)
;
	LDR	R0, [R1, #PIN]	; Load PIN register into R0
	EOR	R0, R2			; XOR with bitmask
	STR	R0, [R1, #PIN]	; Store R0 back to PIN register

	B		loop	; Loop forever!

	ALIGN
	
	END