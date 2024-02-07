[bits 64]
[section .text]

[global byte_in]
[global byte_out]

; http://6.s081.scripts.mit.edu/sp18/x86-64-architecture-guide.html
; Register use guide

byte_in:
        push	rbp
        mov     dx, di
		in		al, dx
        pop     rbp
        ret
byte_out:
        push    rbp
		mov		dx, di
		mov		ax, si
		out		dx, al
        pop     rbp
        ret
