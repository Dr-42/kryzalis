[global _start]

[extern bld2_lm_check]
[extern bld2_create_page_tables]
[extern bld2_enable_paging]
[extern	_kstart]

[section .text]
[bits 32]
_start:
	mov		esp, stack_top
	call	bld2_lm_check

	call	bld2_create_page_tables
	call	bld2_enable_paging

    lgdt    [gdt64.pointer]
    jmp	    gdt64.code_segment:_kstart

[section .bss]
stack_bottom:
	resb	4096 * 4
stack_top:

[section .rodata]
gdt64:
    dq 0   ; Zero entry
.code_segment: equ $ - gdt64
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)	; code segment
.pointer:
    dw $ - gdt64 - 1
    dq gdt64
