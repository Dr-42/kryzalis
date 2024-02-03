[global _start]

[extern print_msg]
[extern clear]
[extern check]

[section .text]
[bits 32]
_start:
	; print `OK`
	mov		esp, stack_top
	call	check

	call	clear
	mov		esi, ok_msg
	call	print_msg
	hlt

; Data
ok_msg: db `Long mode is supported, please proceed`, 0

[section .bss]
stack_bottom:
	resb	4096 * 4
stack_top:
