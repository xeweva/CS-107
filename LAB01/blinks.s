;*******************************************************************************
;
;    CS 107: Computer Architecture and Organization -- LAB 1
;    Filename: blinks.s
;    Date: 01.14.2020
;    Author: MAX DOKUKIN
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

;================ DO NOT CHANGE ANYTHING BELOW THIS LINE =======================
GPIO_DIRx	EQU	0x00
GPIO_SETx	EQU	0x18
GPIO_CLRx	EQU	0x1C

;
; LED1 - P1_18
; LED2 - P0_13
; LED3 - P1_13
; LED4 - P2_19

LED_1_PORT	EQU 0x20098020
LED_1_PIN	EQU	0x00040000
LED_1_IOCON	EQU 0x4002C0C8
LED_1_CONF	EQU 0x00
LED_1_ON	EQU GPIO_CLRx
LED_1_OFF	EQU GPIO_SETx

LED_2_PORT	EQU 0x20098000
LED_2_PIN	EQU	0x00002000
LED_2_IOCON	EQU 0x4002C034
LED_2_CONF	EQU 0x80
LED_2_ON	EQU GPIO_CLRx
LED_2_OFF	EQU GPIO_SETx

LED_3_PORT	EQU 0x20098020
LED_3_PIN	EQU	0x00002000
LED_3_IOCON	EQU 0x4002C0B4
LED_3_CONF	EQU 0x00
LED_3_ON	EQU GPIO_SETx
LED_3_OFF	EQU GPIO_CLRx

LED_4_PORT	EQU 0x20098040
LED_4_PIN	EQU	0x00080000
LED_4_IOCON	EQU 0x4002C14C
LED_4_CONF	EQU 0x00
LED_4_ON	EQU GPIO_SETx
LED_4_OFF	EQU GPIO_CLRx
;================ DO NOT CHANGE ANYTHING ABOVE THIS LINE =======================

main_delay	EQU	50000

led_delay  	EQU 100
	
LED_FLAG	EQU 0x01

; System Init routine
SystemInit
    LDR    R1, =LED_4_IOCON 	; Configure GPIO Pin
	MOVW	R2, #LED_4_CONF
	STR     R2, [R1,#0]
	LDR		R1, =LED_4_PORT 	; Set pin for output
	LDR		R2, =LED_4_PIN  	
	LDR		R0, [R1,#GPIO_DIRx] ; Keep direction for another pins in the port
	ORR		R0, R2
	STR     R0, [R1,#GPIO_DIRx]
	STR     R2, [R1,#LED_4_OFF]	; Turn LED off
;
	BX		LR
;
; Main program
;
__main
;
	MOV		R0, #0
set_delay
	MOV		R4, #led_delay		; LED Counter;
loop	
;
; delay...
;
	LDR		R3, =main_delay
delay_loop
	SUBS	R3, R3, #1
	BNE		delay_loop
; LED...
led
	SUBS	R4, R4, #1
	BNE		loop
	LDR		R1, =LED_4_PORT; Set proper port
	LDR		R2, =LED_4_PIN  	
	EOR		R0, #LED_FLAG		; Invert and check the flag
	TST		R0, #LED_FLAG
	ITE		NE
    STRNE   R2, [R1,#LED_4_ON]  ; if flag==1, turn LED on
    STREQ   R2, [R1,#LED_4_OFF] ; if flag==0, turn LED off
;
	B		set_delay
;
	ALIGN
	END