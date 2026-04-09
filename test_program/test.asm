        cpu 8085
        org 0
	JMP	init

RAMVAL1		equ	08001h
	
	; RST 7.5
	org	03CH
	JMP	int_vec

	org 040h
init:
	DI
	LXI	SP, 080FFh	; Set stack pointer

	; 8755 Port A DIR
	MVI	A, 0FFh
	OUT	002h	
	
	; 8755 Port B DIR
	MVI	A, 0FFh
	OUT	003h

	; 8755 Port B DATA
	MVI	A, 0AAh
	CMA
	OUT 001h

	; 8755 Port A DATA
	MVI	A, 0AAh
	CMA
	OUT 000h

	; 8155 Command/Status Reg
	; Port A (bit-0) : input (0)
	; Port B (bit-1) : output (1)
	MVI	A, 002h
	OUT 080h

	; 8155 Port B DATA
	MVI	A, 077h
	CMA
	OUT 082h

	; 8155 Timer
	MVI	A, 0FFh
	OUT 085h

	MVI	A, 0FFh
	OUT 084h

	; 8155 Timer start
	MVI	A, 0C2h
	OUT	080h

	; Clear RAM val
	MVI	A, 000h
	STA RAMVAL1

	; int vec settings
	MVI	A, 01Bh	; 00011011b
	SIM			; A -> Interrupt mask

	EI
loop:
	; 8155 Port A(DIP SW) in -> Port B(LED) out
	IN	081h
	CMA
	OUT 082h

	JMP	loop

	HLT

int_vec:

	; RST7.5 interrupt request clear
	MVI	A, 010h	; 00010000b
	SIM			; A -> Interrupt mask

	CALL		led_countup
	EI
	RET

led_countup:
	; Count-up 8755 Port B LED
	LDA	RAMVAL1
	INR	A
	STA	RAMVAL1
	CMA
	OUT 000h

	RET

        END