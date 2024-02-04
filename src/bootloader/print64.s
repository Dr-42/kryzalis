[global bld2_clear_long]
[global bld2_print_long]
[bits 64]
bld2_clear_long:
	push rdi
	push rax
	push rcx

	shl rdi, 8
	mov rax, rdi

	mov al, space_char

	mov rdi, vga_start
	mov rcx, vga_extent / 2

	rep stosw

	pop rcx
	pop rax
	pop rdi
	ret
bld2_print_long:
    push rax
    push rdx
    push rdi
    push rsi

    mov rdx, vga_start
    shl rdi, 8

    print_long_loop:
        cmp byte[rsi], 0
        je  print_long_done

        ; Handle strings that are too long
        cmp rdx, vga_start + vga_extent
        je print_long_done

        ; Move character to al, style to ah
        mov rax, rdi
        mov al, byte[rsi]

        ; Print character to vga memory location
        mov word[rdx], ax

        ; Increment counter registers
        add rsi, 1
        add rdx, 2

        ; Redo loop
        jmp print_long_loop

print_long_done:
    pop rsi
    pop rdi
    pop rdx
    pop rax

    ret

[section .data]
space_char:		equ ` `
; VGA text mode color constants
vga_start:                  equ 0x000B8000
vga_extent:                 equ 80 * 25 * 2
