[bits 32]
[extern bld2_print_error]
[extern bld2_clear]

[global bld2_lm_check]
[section .text]
bld2_lm_check:
	pushad
	cmp		eax, MULTIBOOT_BOOTLOADER_MAGIC
	jne		print_multiboot_error

	; 1. Check for CPUID
    ; 2. Check for CPUID extended functions
    ; 3. Check for long mode support
	pushfd				; Copy flags to eax via stack
	pop		eax
	mov		ecx, eax		; Save to ecx for later comp
	xor		eax, 1 << 21	; Flip the ID bit
	; Write to flags
	push	eax
	popfd

	; Read from flags. Bit is flipped if cpuid is supported
	pushfd
	pop		eax

	push	ecx
	popfd

	cmp		eax, ecx
	je		print_nocpuid_error	; Print error if no cpuid

	; Check for cpid extended functions
	mov		eax, 0x80000000
	cpuid
	cmp		eax, 0x80000001	; See if result is larger than 80000001
	jb		print_nocpuid_ext_error	; No extended cpuid, error and hang

	; Check for long mode
	mov		eax, 0x80000001
	cpuid
	test	edx, 1 << 29
	jz		print_no_longmode_error	; No long mode, error and hang
	
	popad
	ret

; Error functions
print_multiboot_error:
	call	bld2_clear
	mov		esi, multiboot_error
	call	bld2_print_error
	jmp		$

print_nocpuid_error:
	call	bld2_clear
	mov		esi, cpuid_error
	call	bld2_print_error
	jmp		$

print_nocpuid_ext_error:
	call	bld2_clear
	mov		esi, cpuid_ext_error
	call	bld2_print_error
	jmp		$

print_no_longmode_error:
	call	bld2_clear
	mov		esi, longmode_error
	call	bld2_print_error
	jmp		$
	

[section .data]
multiboot_error db `Error: Multiboot not set up`, 0
cpuid_error		db `Error: CPU doesn't cpuid`, 0
cpuid_ext_error	db `Error: CPU doesn't support extended cpuid`, 0
longmode_error	db `Error: 64 bit mode not supported`, 0

MULTIBOOT_BOOTLOADER_MAGIC equ 0x36d76289
