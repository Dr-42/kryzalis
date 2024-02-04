[bits 32]

[global bld2_create_page_tables]
[global bld2_enable_paging]

[section .text]
bld2_create_page_tables:
    pushad
    mov	eax, page_table_l3
    or	eax, 0b11		; present + writable
    mov [page_table_l4], eax

    mov eax, page_table_l2
    or	eax, 0b11		; present + writable
    mov	[page_table_l3], eax

    mov ecx, 0			; counter
    .loop:
	mov eax, 0x200000	; 2MB
	mul ecx
	or  eax, 0b10000011	; present, writable, huge_page
				; Hence no l1 pt needed
	mov [page_table_l2 + ecx * 8], eax

	inc ecx
	cmp ecx, 512		; Checks if whole table is mapped
	jne .loop

	popad
	ret

bld2_enable_paging:
    pushad
    mov	eax, page_table_l4
    mov	cr3, eax

    mov eax, cr4
    or	eax, 1 << 5		; Enable PAE
    mov cr4, eax

    ; Enable long mode
    mov ecx, 0xc0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; Enable paging
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    popad
    ret



[section .bss]
align 4096
page_table_l4: resb 4096
page_table_l3: resb 4096
page_table_l2: resb 4096
