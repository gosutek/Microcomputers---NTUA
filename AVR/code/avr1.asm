.include "m16def.inc"

reset: 
    ; Initialize Stack Pointer
    ldi r24 , low(RAMEND) 
	out SPL , r24
	ldi r24 , high(RAMEND)
	out SPH , r24
	; Set Port A as Output
	ser r24 ; initialize PORTA for output
	out DDRA , r24
	; Set Port B as Input
	clr r24
	out DDRB , r24
	; Switch on first led
	ldi r20 , 0x01
	out PORTA , r20
	; Set direction to left
	ldi r21, 0x00


	;r20 holds the current switched on led
	;r21 holds the direction
	;r21 = 0x00 -> left
	;r21 = 0x01 -> right
	;r22 holds the current input from PB0
main:
    ; Check if input from button in PB0 is 0 to switch on the next led
	; else branch back to main 
    in r22 , PINB
	andi r22 , 0x01
    cpi r22 , 0x00
	brne main

	; If r21 (direction) is 0x00 shift output to the left
	cpi r21 , 0x00
	brne rotate_led_right
rotate_led_left:
    rol r20
	rjmp switch_new_led_on
	; If r21 (direction) is 0x01 shift output to the right 
rotate_led_right:
    ror r20
switch_new_led_on:
	;Switch on new led
    out PORTA , r20
	; Switch direction if needed
	rcall update_direction
	rjmp main


update_direction:
	; If the first led is switched on change direction
	; to left
if_first_led_on:
	cpi r20 , 0x01
	brne if_last_led_on
	ldi r21 , 0x00;
    rjmp endif
	; If the last led is switched on change direction
	; to right
if_last_led_on:
    cpi r20 , 0x80
	brne endif
	ldi r21 , 0x01
	; else keep the same direction
endif: 
	ret
