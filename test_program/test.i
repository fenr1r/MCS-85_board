	org 000h
    jmp    main
delay:   mov R3, #03h
loop1:  mov R2, #0FFh
loop2:  mov R1, #0FFh
    djnz    R1, $
    djnz    R2, loop2
    djnz    R3, loop1
    ret
; Program start
; --------------------
main:
loop:
	mov	A, #0FFh
	outl	P1, A
	call	delay
	mov	A, #000h
	outl	P1, A
	call	delay
    jmp    loop
	END
