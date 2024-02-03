[global clear]
[global print_msg]
[global print_error]

[bits 32]
clear:
	pushad
	mov		ebx, vga_extent
	mov		ecx, vga_start
	mov		edx, 0

	; Main loop
	clear_loop:
		cmp		edx, ebx
		jge		clear_done

		push	edx

		mov		al, space_char
		mov		ah, style_black_bg

		add		edx, ecx
		mov		word[edx], ax

		pop		edx

		add		edx, 2
		jmp		clear_loop

clear_done:
	popad
	ret

print_error:
	pushad
	mov		edx, vga_start

	print_error_loop:
		cmp		byte[esi], 0			; Check null termination
		je		print_error_done

		mov		al, byte[esi]
		mov		ah, style_red

		mov		word[edx], ax			; Print char by 
									; moving to vga memeory
		add		esi, 1
		add		edx, 2

		jmp		print_error_loop

	print_error_done:
		popad
		ret

print_msg:
	pushad
	mov		edx, vga_start

	print_msg_loop:
		cmp		byte[esi], 0			; Check null termination
		je		print_msg_done

		mov		al, byte[esi]
		mov		ah, style_green

		mov		word[edx], ax			; Print char by 
									; moving to vga memeory
		add		esi, 1
		add		edx, 2

		jmp		print_msg_loop

	print_msg_done:
		popad
		ret

space_char:		equ ` `
; VGA text mode color constants
style_red:		equ 0x04	; Red text, black background
style_green:	equ 0x02	; Green text, black background
style_black_bg:	equ 0x00	; Black text, black background
vga_start:                  equ 0x000B8000
vga_extent:                 equ 80 * 25 * 2
