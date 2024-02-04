[bits 64]
[global _kstart]

[extern	bld2_clear_long]
[extern bld2_print_long]
[extern kernel_main]

[section .text]

_kstart:
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov  rdi, style_green
    call bld2_clear_long
    mov	 esi, ok_msg
    call bld2_print_long

    call kernel_main

    jmp $

[section .data]
ok_msg: db `Currently in 64 mode`, 0
style_green:	equ 0x02	; Green text, black background
