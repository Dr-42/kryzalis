[global _start]

[extern bld2_print_msg]
[extern bld2_clear]
[extern bld2_lm_check]

[section .text]
[bits 32]
_start:
	; print `OK`
	mov		esp, stack_top
	call	bld2_lm_check

	call	bld2_clear
	mov		esi, ok_msg
	call	bld2_print_msg
	hlt

; Data
ok_msg: db `Long mode is supported, please proceed`, 0

[section .bss]
stack_bottom:
	resb	4096 * 4
stack_top:
