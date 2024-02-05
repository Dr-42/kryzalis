	.file	"ports.c"
	.intel_syntax noprefix
	.text
	.globl	byte_in
	.type	byte_in, @function
byte_in:
.LFB0:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	eax, edi
	mov	WORD PTR [rbp-20], ax
	movzx	eax, WORD PTR [rbp-20]
	mov	edx, eax
#APP
# 13 "./src/kernel/cpu/ports.c" 1
	.intel_syntax
in %al, %dx
.att_syntax

# 0 "" 2
#NO_APP
	mov	BYTE PTR [rbp-1], al
	movzx	eax, BYTE PTR [rbp-1]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	byte_in, .-byte_in
	.globl	byte_out
	.type	byte_out, @function
byte_out:
.LFB1:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	edx, edi
	mov	eax, esi
	mov	WORD PTR [rbp-4], dx
	mov	BYTE PTR [rbp-8], al
	movzx	eax, BYTE PTR [rbp-8]
	movzx	edx, WORD PTR [rbp-4]
#APP
# 25 "./src/kernel/cpu/ports.c" 1
	.intel_syntax
out %dx, %al
.att_syntax

# 0 "" 2
#NO_APP
	nop
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	byte_out, .-byte_out
	.ident	"GCC: (GNU) 13.2.1 20231205 (Red Hat 13.2.1-6)"
	.section	.note.GNU-stack,"",@progbits
