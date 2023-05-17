	.file	"tests.cpp"
	.text
	.section	.text._ZNKSt5ctypeIcE8do_widenEc,"axG",@progbits,_ZNKSt5ctypeIcE8do_widenEc,comdat
	.align 2
	.p2align 4
	.weak	_ZNKSt5ctypeIcE8do_widenEc
	.type	_ZNKSt5ctypeIcE8do_widenEc, @function
_ZNKSt5ctypeIcE8do_widenEc:
.LFB2744:
	.cfi_startproc
	endbr64
	movl	%esi, %eax
	ret
	.cfi_endproc
.LFE2744:
	.size	_ZNKSt5ctypeIcE8do_widenEc, .-_ZNKSt5ctypeIcE8do_widenEc
	.text
	.p2align 4
	.type	_Z11addElements8diagonalS_._omp_fn.0, @function
_Z11addElements8diagonalS_._omp_fn.0:
.LFB9907:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	call	omp_get_num_threads@PLT
	movl	%eax, %ebp
	call	omp_get_thread_num@PLT
	movl	%eax, %ecx
	movq	(%rbx), %rax
	movl	4(%rax), %eax
	cltd
	idivl	%ebp
	cmpl	%edx, %ecx
	jl	.L4
.L10:
	imull	%eax, %ecx
	addl	%ecx, %edx
	leal	(%rax,%rdx), %esi
	movl	%esi, 36(%rsp)
	cmpl	%esi, %edx
	jge	.L3
	movq	40(%rbx), %r11
	movq	24(%rbx), %rbp
	movslq	%edx, %rcx
	movq	48(%rbx), %rdi
	movq	32(%rbx), %r10
	leaq	16(,%rcx,4), %r9
	leaq	0(,%rcx,4), %rsi
	movq	16(%rbx), %r12
	movq	8(%rbx), %r13
	leaq	(%r11,%rsi), %r8
	leaq	(%r11,%r9), %r15
	leaq	(%rdi,%r9), %r14
	leaq	(%r10,%r9), %rbx
	movq	%rdi, 48(%rsp)
	movq	%r11, 56(%rsp)
	leaq	(%rdi,%rsi), %rdi
	leaq	(%r10,%rsi), %r11
	movq	%r10, 64(%rsp)
	leaq	0(%rbp,%r9), %r10
	movq	%rbx, (%rsp)
	leaq	0(%rbp,%rsi), %rbx
	movq	%r10, 8(%rsp)
	leaq	(%r12,%r9), %r10
	addq	%r13, %r9
	movq	%rbp, 72(%rsp)
	leaq	(%r12,%rsi), %rbp
	addq	%r13, %rsi
	cmpq	%r15, %rdi
	movq	%r15, 40(%rsp)
	setnb	%r15b
	cmpq	%r14, %r8
	movq	%r9, 24(%rsp)
	setnb	%r9b
	orl	%r9d, %r15d
	cmpq	%r11, %r14
	movq	%r10, 16(%rsp)
	setbe	%r10b
	cmpq	(%rsp), %rdi
	setnb	%r9b
	orl	%r10d, %r9d
	leal	-1(%rax), %r10d
	andl	%r15d, %r9d
	cmpl	$2, %r10d
	seta	%r10b
	andl	%r10d, %r9d
	cmpq	%rbx, %r14
	setbe	%r10b
	cmpq	8(%rsp), %rdi
	setnb	%r15b
	orl	%r15d, %r10d
	andl	%r10d, %r9d
	cmpq	%rbp, %r14
	setbe	%r10b
	cmpq	16(%rsp), %rdi
	setnb	%r15b
	orl	%r15d, %r10d
	movq	40(%rsp), %r15
	andl	%r10d, %r9d
	cmpq	%rsi, %r14
	setbe	%r14b
	cmpq	24(%rsp), %rdi
	setnb	%r10b
	orl	%r14d, %r10d
	andl	%r10d, %r9d
	cmpq	%r11, %r15
	setbe	%r14b
	cmpq	(%rsp), %r8
	setnb	%r10b
	orl	%r14d, %r10d
	andl	%r9d, %r10d
	cmpq	%rbx, %r15
	setbe	%r14b
	cmpq	8(%rsp), %r8
	setnb	%r9b
	orl	%r14d, %r9d
	andl	%r10d, %r9d
	cmpq	%rbp, %r15
	setbe	%r10b
	cmpq	16(%rsp), %r8
	setnb	%r14b
	orl	%r14d, %r10d
	testb	%r10b, %r9b
	je	.L19
	cmpq	%rsi, %r15
	setbe	%r10b
	cmpq	24(%rsp), %r8
	setnb	%r9b
	orb	%r9b, %r10b
	je	.L19
	movl	%eax, %r9d
	xorl	%ecx, %ecx
	shrl	$2, %r9d
	salq	$4, %r9
	.p2align 4,,10
	.p2align 3
.L7:
	movups	(%rsi,%rcx), %xmm0
	movups	(%rbx,%rcx), %xmm1
	addps	%xmm1, %xmm0
	movups	%xmm0, (%r8,%rcx)
	movups	0(%rbp,%rcx), %xmm0
	movups	(%r11,%rcx), %xmm2
	addps	%xmm2, %xmm0
	movups	%xmm0, (%rdi,%rcx)
	addq	$16, %rcx
	cmpq	%r9, %rcx
	jne	.L7
	movl	%eax, %ecx
	andl	$-4, %ecx
	addl	%ecx, %edx
	cmpl	%ecx, %eax
	je	.L3
	movq	72(%rsp), %rdi
	movslq	%edx, %rax
	movq	56(%rsp), %rbx
	movss	0(%r13,%rax,4), %xmm0
	movq	64(%rsp), %rsi
	addss	(%rdi,%rax,4), %xmm0
	movq	48(%rsp), %rcx
	movl	36(%rsp), %r8d
	movss	%xmm0, (%rbx,%rax,4)
	movss	(%r12,%rax,4), %xmm0
	addss	(%rsi,%rax,4), %xmm0
	movss	%xmm0, (%rcx,%rax,4)
	leal	1(%rdx), %eax
	cmpl	%eax, %r8d
	jle	.L3
	cltq
	addl	$2, %edx
	movss	0(%r13,%rax,4), %xmm0
	addss	(%rdi,%rax,4), %xmm0
	movss	%xmm0, (%rbx,%rax,4)
	movss	(%r12,%rax,4), %xmm0
	addss	(%rsi,%rax,4), %xmm0
	movss	%xmm0, (%rcx,%rax,4)
	cmpl	%edx, %r8d
	jle	.L3
	movslq	%edx, %rax
	movss	0(%r13,%rax,4), %xmm0
	addss	(%rdi,%rax,4), %xmm0
	movss	%xmm0, (%rbx,%rax,4)
	movss	(%r12,%rax,4), %xmm0
	addss	(%rsi,%rax,4), %xmm0
	movss	%xmm0, (%rcx,%rax,4)
.L3:
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L4:
	.cfi_restore_state
	addl	$1, %eax
	xorl	%edx, %edx
	jmp	.L10
	.p2align 4,,10
	.p2align 3
.L19:
	movq	48(%rsp), %rax
	movq	56(%rsp), %rdx
	movq	64(%rsp), %rsi
	movq	72(%rsp), %rdi
	movl	36(%rsp), %r8d
	.p2align 4,,10
	.p2align 3
.L13:
	movss	0(%r13,%rcx,4), %xmm0
	addss	(%rdi,%rcx,4), %xmm0
	movss	%xmm0, (%rdx,%rcx,4)
	movss	(%r12,%rcx,4), %xmm0
	addss	(%rsi,%rcx,4), %xmm0
	movss	%xmm0, (%rax,%rcx,4)
	addq	$1, %rcx
	cmpl	%ecx, %r8d
	jg	.L13
	jmp	.L3
	.cfi_endproc
.LFE9907:
	.size	_Z11addElements8diagonalS_._omp_fn.0, .-_Z11addElements8diagonalS_._omp_fn.0
	.p2align 4
	.type	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE._omp_fn.0, @function
_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE._omp_fn.0:
.LFB9910:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	omp_get_num_threads@PLT
	movl	%eax, %ebp
	call	omp_get_thread_num@PLT
	movl	%eax, %ecx
	movq	24(%rbx), %rax
	movq	(%rax), %rax
	movl	44(%rax), %eax
	cltd
	idivl	%ebp
	cmpl	%edx, %ecx
	jl	.L22
.L25:
	imull	%eax, %ecx
	addl	%ecx, %edx
	addl	%edx, %eax
	cmpl	%eax, %edx
	jge	.L21
	movq	(%rbx), %rcx
	movq	40(%rbx), %r10
	movq	32(%rbx), %r9
	movq	16(%rbx), %r8
	movq	(%rcx), %rcx
	movq	8(%rbx), %rdi
	movslq	4(%rcx), %rsi
	movslq	%edx, %rcx
	addl	48(%rbx), %edx
	movq	%rsi, %r11
	leaq	4(,%rsi,4), %rsi
	imull	%r11d, %edx
	movslq	52(%rbx), %r11
	addq	%rcx, %r11
	movslq	%edx, %rdx
	addq	%r11, %rdx
	salq	$2, %rdx
	.p2align 4,,10
	.p2align 3
.L24:
	movss	(%r9,%rcx,4), %xmm0
	movss	%xmm0, (%rdi,%rdx)
	movss	(%r10,%rcx,4), %xmm0
	addq	$1, %rcx
	movss	%xmm0, (%r8,%rdx)
	addq	%rsi, %rdx
	cmpl	%ecx, %eax
	jg	.L24
.L21:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L22:
	.cfi_restore_state
	addl	$1, %eax
	xorl	%edx, %edx
	jmp	.L25
	.cfi_endproc
.LFE9910:
	.size	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE._omp_fn.0, .-_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE._omp_fn.0
	.p2align 4
	.type	_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE._omp_fn.0, @function
_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE._omp_fn.0:
.LFB9912:
	.cfi_startproc
	endbr64
	movq	(%rdi), %rax
	movq	16(%rdi), %rcx
	movq	8(%rdi), %rsi
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movq	%rax, %rdi
	subq	%rdx, %rdi
	sarq	$3, %rdi
	je	.L28
	leaq	15(%rcx), %r9
	leaq	0(,%rdi,4), %r8
	subq	%rsi, %r9
	cmpq	$30, %r9
	leaq	-1(%rdi), %r9
	seta	%r10b
	cmpq	$2, %r9
	seta	%r9b
	andl	%r9d, %r10d
	leaq	(%rcx,%r8), %r9
	cmpq	%r9, %rdx
	setnb	%r9b
	cmpq	%rax, %rcx
	setnb	%r11b
	orl	%r11d, %r9d
	testb	%r9b, %r10b
	je	.L36
	leaq	(%rsi,%r8), %r9
	cmpq	%r9, %rdx
	setnb	%r9b
	cmpq	%rax, %rsi
	setnb	%al
	orb	%al, %r9b
	je	.L36
	movq	%rdi, %r8
	xorl	%eax, %eax
	shrq	$2, %r8
	salq	$4, %r8
	.p2align 4,,10
	.p2align 3
.L31:
	movups	(%rdx,%rax,2), %xmm0
	movups	16(%rdx,%rax,2), %xmm1
	movaps	%xmm0, %xmm2
	shufps	$221, %xmm1, %xmm0
	shufps	$136, %xmm1, %xmm2
	movups	%xmm2, (%rsi,%rax)
	movups	%xmm0, (%rcx,%rax)
	addq	$16, %rax
	cmpq	%r8, %rax
	jne	.L31
	movq	%rdi, %rax
	andq	$-4, %rax
	testb	$3, %dil
	je	.L28
	leaq	(%rdx,%rax,8), %r8
	movss	(%r8), %xmm0
	movss	%xmm0, (%rsi,%rax,4)
	movss	4(%r8), %xmm0
	leal	1(%rax), %r8d
	movslq	%r8d, %r8
	movss	%xmm0, (%rcx,%rax,4)
	cmpq	%rdi, %r8
	jnb	.L28
	leaq	(%rdx,%r8,8), %r9
	addl	$2, %eax
	movss	(%r9), %xmm0
	cltq
	movss	%xmm0, (%rsi,%r8,4)
	movss	4(%r9), %xmm0
	movss	%xmm0, (%rcx,%r8,4)
	cmpq	%rax, %rdi
	jbe	.L28
	leaq	(%rdx,%rax,8), %rdx
	movss	(%rdx), %xmm0
	movss	%xmm0, (%rsi,%rax,4)
	movss	4(%rdx), %xmm0
	movss	%xmm0, (%rcx,%rax,4)
	ret
	.p2align 4,,10
	.p2align 3
.L36:
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L30:
	movss	(%rdx,%rax,2), %xmm0
	movss	%xmm0, (%rsi,%rax)
	movss	4(%rdx,%rax,2), %xmm0
	movss	%xmm0, (%rcx,%rax)
	addq	$4, %rax
	cmpq	%rax, %r8
	jne	.L30
.L28:
	ret
	.cfi_endproc
.LFE9912:
	.size	_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE._omp_fn.0, .-_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE._omp_fn.0
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"basic_string::_M_construct null not valid"
	.text
	.align 2
	.p2align 4
	.type	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.isra.0, @function
_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.isra.0:
.LFB10040:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	leaq	16(%rdi), %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movq	%r13, (%rdi)
	testq	%rsi, %rsi
	je	.L56
	movq	%rdi, %rbx
	movq	%rsi, %rdi
	movq	%rsi, %rbp
	call	strlen@PLT
	movq	%rax, (%rsp)
	movq	%rax, %r12
	cmpq	$15, %rax
	ja	.L57
	cmpq	$1, %rax
	jne	.L49
	movzbl	0(%rbp), %eax
	movb	%al, 16(%rbx)
.L50:
	movq	(%rsp), %rax
	movq	(%rbx), %rdx
	movq	%rax, 8(%rbx)
	movb	$0, (%rdx,%rax)
	movq	8(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L58
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L49:
	.cfi_restore_state
	testq	%rax, %rax
	je	.L50
	jmp	.L48
.L57:
	movq	%rsp, %rsi
	xorl	%edx, %edx
	movq	%rbx, %rdi
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm@PLT
	movq	%rax, (%rbx)
	movq	%rax, %r13
	movq	(%rsp), %rax
	movq	%rax, 16(%rbx)
.L48:
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movq	%r13, %rdi
	call	memcpy@PLT
	jmp	.L50
.L56:
	leaq	.LC0(%rip), %rdi
	call	_ZSt19__throw_logic_errorPKc@PLT
.L58:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE10040:
	.size	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.isra.0, .-_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.isra.0
	.section	.text.unlikely,"ax",@progbits
	.align 2
.LCOLDB1:
	.text
.LHOTB1:
	.align 2
	.p2align 4
	.type	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0, @function
_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0:
.LFB10127:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10127
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pxor	%xmm0, %xmm0
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	$0, 16(%rdi)
	movups	%xmm0, (%rdi)
	movl	$8, %edi
.LEHB0:
	call	_Znwm@PLT
.LEHE0:
	movq	0(%rbp), %rcx
	leaq	8(%rax), %rdx
	movq	%rax, (%rbx)
	movq	%rdx, 16(%rbx)
	movq	%rcx, (%rax)
	movq	%rdx, 8(%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L62:
	.cfi_restore_state
	endbr64
	movq	%rax, %rbp
	jmp	.L60
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA10127:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10127-.LLSDACSB10127
.LLSDACSB10127:
	.uleb128 .LEHB0-.LFB10127
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L62-.LFB10127
	.uleb128 0
.LLSDACSE10127:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC10127
	.type	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0.cold, @function
_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0.cold:
.LFSB10127:
.L60:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -24
	.cfi_offset 6, -16
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L61
	call	_ZdlPv@PLT
.L61:
	movq	%rbp, %rdi
.LEHB1:
	call	_Unwind_Resume@PLT
.LEHE1:
	.cfi_endproc
.LFE10127:
	.section	.gcc_except_table
.LLSDAC10127:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC10127-.LLSDACSBC10127
.LLSDACSBC10127:
	.uleb128 .LEHB1-.LCOLDB1
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
.LLSDACSEC10127:
	.section	.text.unlikely
	.text
	.size	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0, .-_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
	.section	.text.unlikely
	.size	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0.cold, .-_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0.cold
.LCOLDE1:
	.text
.LHOTE1:
	.section	.rodata.str1.8
	.align 8
.LC2:
	.string	"cannot create std::vector larger than max_size()"
	.section	.text.unlikely
	.align 2
.LCOLDB3:
	.text
.LHOTB3:
	.align 2
	.p2align 4
	.type	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1, @function
_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1:
.LFB10126:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10126
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pxor	%xmm0, %xmm0
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	leaq	0(,%rdx,4), %r12
	movabsq	$2305843009213693951, %rdx
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%r12, %rax
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	sarq	$2, %rax
	movq	%rdi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	$0, 16(%rdi)
	movups	%xmm0, (%rdi)
	cmpq	%rdx, %rax
	ja	.L84
	movq	%rsi, %rbp
	testq	%rax, %rax
	je	.L74
	movq	%r12, %rdi
.LEHB2:
	call	_Znwm@PLT
	movq	%rax, %rdi
.L70:
	leaq	(%rdi,%r12), %r13
	movq	%rdi, (%rbx)
	movq	%r13, 16(%rbx)
	testq	%r12, %r12
	je	.L71
	movq	%r12, %rdx
	movq	%rbp, %rsi
	call	memcpy@PLT
.L71:
	movq	%r13, 8(%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L74:
	.cfi_restore_state
	xorl	%edi, %edi
	jmp	.L70
.L84:
	leaq	.LC2(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE2:
.L75:
	endbr64
	movq	%rax, %rbp
	jmp	.L72
	.section	.gcc_except_table
.LLSDA10126:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10126-.LLSDACSB10126
.LLSDACSB10126:
	.uleb128 .LEHB2-.LFB10126
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L75-.LFB10126
	.uleb128 0
.LLSDACSE10126:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC10126
	.type	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1.cold, @function
_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1.cold:
.LFSB10126:
.L72:
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -40
	.cfi_offset 6, -32
	.cfi_offset 12, -24
	.cfi_offset 13, -16
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L73
	call	_ZdlPv@PLT
.L73:
	movq	%rbp, %rdi
.LEHB3:
	call	_Unwind_Resume@PLT
.LEHE3:
	.cfi_endproc
.LFE10126:
	.section	.gcc_except_table
.LLSDAC10126:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC10126-.LLSDACSBC10126
.LLSDACSBC10126:
	.uleb128 .LEHB3-.LCOLDB3
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
.LLSDACSEC10126:
	.section	.text.unlikely
	.text
	.size	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1, .-_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1
	.section	.text.unlikely
	.size	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1.cold, .-_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1.cold
.LCOLDE3:
	.text
.LHOTE3:
	.section	.rodata._ZN19quantumSparseMatrix5printEv.str1.1,"aMS",@progbits,1
.LC4:
	.string	"matrix_shape ("
.LC5:
	.string	","
.LC6:
	.string	")"
.LC7:
	.string	"tensor_shape ("
.LC8:
	.string	"(dIndex="
.LC9:
	.string	") "
.LC10:
	.string	"["
.LC11:
	.string	""
.LC12:
	.string	"("
.LC13:
	.string	"]"
	.section	.text._ZN19quantumSparseMatrix5printEv,"axG",@progbits,_ZN19quantumSparseMatrix5printEv,comdat
	.align 2
	.p2align 4
	.weak	_ZN19quantumSparseMatrix5printEv
	.type	_ZN19quantumSparseMatrix5printEv, @function
_ZN19quantumSparseMatrix5printEv:
.LFB3372:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA3372
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	$14, %edx
	leaq	.LC4(%rip), %rsi
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	leaq	_ZSt4cout(%rip), %rdi
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
.LEHB4:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%rbx), %rcx
	movq	8(%rbx), %rax
	subq	%rcx, %rax
	cmpq	$4, %rax
	je	.L86
	xorl	%ebp, %ebp
	leaq	_ZSt4cout(%rip), %r12
	.p2align 4,,10
	.p2align 3
.L87:
	movl	(%rcx,%rbp,4), %esi
	movq	%r12, %rdi
	addq	$1, %rbp
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%rbx), %rcx
	movq	8(%rbx), %rax
	subq	%rcx, %rax
	movq	%rax, %rdx
	sarq	$2, %rdx
	subq	$1, %rdx
	cmpq	%rbp, %rdx
	ja	.L87
.L86:
	movl	-4(%rcx,%rax), %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rbp
	movq	%rax, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %r12
	testq	%r12, %r12
	je	.L93
	cmpb	$0, 56(%r12)
	je	.L89
	movsbl	67(%r12), %esi
.L90:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movl	$14, %edx
	leaq	.LC7(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	24(%rbx), %rcx
	movq	32(%rbx), %rax
	subq	%rcx, %rax
	cmpq	$4, %rax
	je	.L91
	xorl	%ebp, %ebp
	leaq	_ZSt4cout(%rip), %r12
	.p2align 4,,10
	.p2align 3
.L92:
	movl	(%rcx,%rbp,4), %esi
	movq	%r12, %rdi
	addq	$1, %rbp
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	24(%rbx), %rcx
	movq	32(%rbx), %rax
	subq	%rcx, %rax
	movq	%rax, %rdx
	sarq	$2, %rdx
	subq	$1, %rdx
	cmpq	%rbp, %rdx
	ja	.L92
.L91:
	movl	-4(%rcx,%rax), %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rbp
	movq	%rax, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %r12
	testq	%r12, %r12
	je	.L93
	cmpb	$0, 56(%r12)
	je	.L94
	movsbl	67(%r12), %esi
.L95:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
.LEHE4:
	movq	80(%rbx), %rbp
	leaq	64(%rbx), %rax
	movq	%rax, 8(%rsp)
	cmpq	%rax, %rbp
	je	.L85
	leaq	32(%rsp), %r15
	leaq	.LC12(%rip), %r14
	.p2align 4,,10
	.p2align 3
.L106:
	movl	$44, %eax
	movl	$8, %edx
	leaq	.LC8(%rip), %rsi
	movq	%r15, 16(%rsp)
	leaq	_ZSt4cout(%rip), %rdi
	movw	%ax, 32(%rsp)
	movq	$1, 24(%rsp)
.LEHB5:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	40(%rbp), %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movq	%rax, %rdi
	movl	$2, %edx
	leaq	.LC9(%rip), %rsi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	$1, %edx
	leaq	.LC10(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	xorl	%edx, %edx
	leaq	.LC11(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movslq	44(%rbp), %rbx
	cmpl	$1, %ebx
	jle	.L99
	leal	-2(%rbx), %eax
	xorl	%r12d, %r12d
	leaq	4(,%rax,4), %rax
	movq	%rax, (%rsp)
	.p2align 4,,10
	.p2align 3
.L100:
	movl	$1, %edx
	movq	%r14, %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	48(%rbp), %rax
	pxor	%xmm0, %xmm0
	leaq	_ZSt4cout(%rip), %rdi
	cvtss2sd	(%rax,%r12), %xmm0
	call	_ZNSo9_M_insertIdEERSoT_@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	56(%rbp), %rax
	pxor	%xmm0, %xmm0
	movq	%r13, %rdi
	cvtss2sd	(%rax,%r12), %xmm0
	call	_ZNSo9_M_insertIdEERSoT_@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	24(%rsp), %rdx
	movq	16(%rsp), %rsi
	movq	%r13, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	addq	$4, %r12
	cmpq	(%rsp), %r12
	jne	.L100
.L99:
	movl	$1, %edx
	movq	%r14, %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	48(%rbp), %rax
	pxor	%xmm0, %xmm0
	leaq	_ZSt4cout(%rip), %rdi
	leaq	0(,%rbx,4), %r13
	cvtss2sd	-4(%rax,%rbx,4), %xmm0
	call	_ZNSo9_M_insertIdEERSoT_@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r12
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	56(%rbp), %rax
	pxor	%xmm0, %xmm0
	movq	%r12, %rdi
	cvtss2sd	-4(%rax,%r13), %xmm0
	call	_ZNSo9_M_insertIdEERSoT_@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r12
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	xorl	%edx, %edx
	leaq	.LC11(%rip), %rsi
	movq	%r12, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	$1, %edx
	leaq	.LC13(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	xorl	%edx, %edx
	leaq	.LC11(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	_ZSt4cout(%rip), %rax
	leaq	_ZSt4cout(%rip), %rdx
	movq	-24(%rax), %rax
	movq	240(%rdx,%rax), %r12
	testq	%r12, %r12
	je	.L127
	cmpb	$0, 56(%r12)
	je	.L102
	movsbl	67(%r12), %esi
.L103:
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movq	16(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.L104
	call	_ZdlPv@PLT
.L104:
	movq	%rbp, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %rbp
	cmpq	8(%rsp), %rax
	jne	.L106
.L85:
	movq	56(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L128
	addq	$72, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L102:
	.cfi_restore_state
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rcx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rcx, %rax
	je	.L103
	movq	%r12, %rdi
	call	*%rax
.LEHE5:
	movsbl	%al, %esi
	jmp	.L103
	.p2align 4,,10
	.p2align 3
.L89:
	movq	%r12, %rdi
.LEHB6:
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	movl	$10, %esi
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L90
	movq	%r12, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L90
	.p2align 4,,10
	.p2align 3
.L94:
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	movl	$10, %esi
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L95
	movq	%r12, %rdi
	call	*%rax
.LEHE6:
	movsbl	%al, %esi
	jmp	.L95
.L127:
.LEHB7:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE7:
.L93:
.LEHB8:
	call	_ZSt16__throw_bad_castv@PLT
.L128:
	call	__stack_chk_fail@PLT
.L113:
	endbr64
	movq	%rax, %rbp
.L107:
	movq	16(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.L108
	call	_ZdlPv@PLT
.L108:
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE8:
	.cfi_endproc
.LFE3372:
	.section	.gcc_except_table
.LLSDA3372:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3372-.LLSDACSB3372
.LLSDACSB3372:
	.uleb128 .LEHB4-.LFB3372
	.uleb128 .LEHE4-.LEHB4
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB5-.LFB3372
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L113-.LFB3372
	.uleb128 0
	.uleb128 .LEHB6-.LFB3372
	.uleb128 .LEHE6-.LEHB6
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB7-.LFB3372
	.uleb128 .LEHE7-.LEHB7
	.uleb128 .L113-.LFB3372
	.uleb128 0
	.uleb128 .LEHB8-.LFB3372
	.uleb128 .LEHE8-.LEHB8
	.uleb128 0
	.uleb128 0
.LLSDACSE3372:
	.section	.text._ZN19quantumSparseMatrix5printEv,"axG",@progbits,_ZN19quantumSparseMatrix5printEv,comdat
	.size	_ZN19quantumSparseMatrix5printEv, .-_ZN19quantumSparseMatrix5printEv
	.section	.text._ZN11denseMatrix7getItemESt6vectorIiSaIiEE,"axG",@progbits,_ZN11denseMatrix7getItemESt6vectorIiSaIiEE,comdat
	.align 2
	.p2align 4
	.weak	_ZN11denseMatrix7getItemESt6vectorIiSaIiEE
	.type	_ZN11denseMatrix7getItemESt6vectorIiSaIiEE, @function
_ZN11denseMatrix7getItemESt6vectorIiSaIiEE:
.LFB3417:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA3417
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	8(%rsi), %r8
	movq	(%rsi), %r14
	movq	56(%rdi), %r15
	movq	%r8, %r9
	subq	%r14, %r9
	movq	%r9, %rax
	sarq	$2, %rax
	movq	%rax, 8(%rsp)
	je	.L147
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L167
	movq	%r9, %rdi
.LEHB9:
	call	_Znwm@PLT
.LEHE9:
	movq	8(%r12), %r8
	movq	(%r12), %r14
	movq	%rax, %rbp
	movq	%r8, %r9
	subq	%r14, %r9
	movq	%r9, %rax
	sarq	$2, %rax
	movq	%rax, 8(%rsp)
.L130:
	cmpq	%r14, %r8
	je	.L132
	movq	%r9, %rdx
	movq	%r14, %rsi
	movq	%rbp, %rdi
	movq	%r8, 16(%rsp)
	movq	%r9, (%rsp)
	call	memcpy@PLT
	movq	16(%rsp), %r8
	movq	(%rsp), %r9
.L132:
	movq	24(%rbx), %r13
	movq	32(%rbx), %r11
	subq	%r13, %r11
	movq	%r11, %rax
	sarq	$2, %rax
	movq	%rax, (%rsp)
	je	.L133
	movl	48(%rbx), %r10d
	xorl	%ecx, %ecx
	xorl	%edi, %edi
	movl	$1, %esi
	.p2align 4,,10
	.p2align 3
.L134:
	imull	0(%r13,%rcx), %esi
	movl	%r10d, %eax
	cltd
	idivl	%esi
	imull	0(%rbp,%rcx), %eax
	addq	$4, %rcx
	addl	%eax, %edi
	cmpq	%rcx, %r11
	jne	.L134
	movslq	%edi, %rdi
	leaq	(%r15,%rdi,4), %r15
.L133:
	movss	(%r15), %xmm1
	movq	8(%rsp), %rdx
	movq	64(%rbx), %r15
	movss	%xmm1, 16(%rsp)
	testq	%rdx, %rdx
	je	.L148
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L168
	movq	%r9, %rdi
.LEHB10:
	call	_Znwm@PLT
.LEHE10:
	movq	24(%rbx), %r13
	movq	%rax, %rdi
	movq	32(%rbx), %rax
	movq	8(%r12), %r8
	movq	(%r12), %r14
	subq	%r13, %rax
	sarq	$2, %rax
	movq	%r8, %r9
	movq	%rax, (%rsp)
	subq	%r14, %r9
.L135:
	cmpq	%r14, %r8
	je	.L137
	movq	%r9, %rdx
	movq	%r14, %rsi
	call	memcpy@PLT
	cmpq	$0, (%rsp)
	movq	%rax, %rdi
	je	.L169
.L138:
	movq	(%rsp), %r10
	movl	48(%rbx), %r9d
	xorl	%ecx, %ecx
	xorl	%r8d, %r8d
	movl	$1, %esi
	salq	$2, %r10
	.p2align 4,,10
	.p2align 3
.L141:
	imull	0(%r13,%rcx), %esi
	movl	%r9d, %eax
	cltd
	idivl	%esi
	imull	(%rdi,%rcx), %eax
	addq	$4, %rcx
	addl	%eax, %r8d
	cmpq	%rcx, %r10
	jne	.L141
	movslq	%r8d, %r8
	movss	(%r15,%r8,4), %xmm0
.L142:
	movss	%xmm0, (%rsp)
	call	_ZdlPv@PLT
	movss	(%rsp), %xmm0
.L143:
	testq	%rbp, %rbp
	je	.L144
	movq	%rbp, %rdi
	movss	%xmm0, (%rsp)
	call	_ZdlPv@PLT
	movss	(%rsp), %xmm0
.L144:
	movss	16(%rsp), %xmm2
	movss	%xmm0, 28(%rsp)
	movss	%xmm2, 24(%rsp)
	movq	24(%rsp), %xmm0
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L137:
	.cfi_restore_state
	cmpq	$0, (%rsp)
	jne	.L138
	movss	(%r15), %xmm0
	testq	%rdi, %rdi
	je	.L143
	jmp	.L142
	.p2align 4,,10
	.p2align 3
.L148:
	xorl	%edi, %edi
	jmp	.L135
	.p2align 4,,10
	.p2align 3
.L147:
	xorl	%ebp, %ebp
	jmp	.L130
.L167:
.LEHB11:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE11:
.L169:
	movss	(%r15), %xmm0
	jmp	.L142
.L168:
.LEHB12:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE12:
.L149:
	endbr64
	movq	%rax, %r12
.L145:
	testq	%rbp, %rbp
	je	.L146
	movq	%rbp, %rdi
	call	_ZdlPv@PLT
.L146:
	movq	%r12, %rdi
.LEHB13:
	call	_Unwind_Resume@PLT
.LEHE13:
	.cfi_endproc
.LFE3417:
	.section	.gcc_except_table
.LLSDA3417:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3417-.LLSDACSB3417
.LLSDACSB3417:
	.uleb128 .LEHB9-.LFB3417
	.uleb128 .LEHE9-.LEHB9
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB10-.LFB3417
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L149-.LFB3417
	.uleb128 0
	.uleb128 .LEHB11-.LFB3417
	.uleb128 .LEHE11-.LEHB11
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB12-.LFB3417
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L149-.LFB3417
	.uleb128 0
	.uleb128 .LEHB13-.LFB3417
	.uleb128 .LEHE13-.LEHB13
	.uleb128 0
	.uleb128 0
.LLSDACSE3417:
	.section	.text._ZN11denseMatrix7getItemESt6vectorIiSaIiEE,"axG",@progbits,_ZN11denseMatrix7getItemESt6vectorIiSaIiEE,comdat
	.size	_ZN11denseMatrix7getItemESt6vectorIiSaIiEE, .-_ZN11denseMatrix7getItemESt6vectorIiSaIiEE
	.section	.text._ZN11denseMatrix5printEv,"axG",@progbits,_ZN11denseMatrix5printEv,comdat
	.align 2
	.p2align 4
	.weak	_ZN11denseMatrix5printEv
	.type	_ZN11denseMatrix5printEv, @function
_ZN11denseMatrix5printEv:
.LFB3420:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movl	$14, %edx
	leaq	.LC4(%rip), %rsi
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %rbx
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%rbx), %rcx
	movq	8(%rbx), %rax
	subq	%rcx, %rax
	cmpq	$4, %rax
	je	.L171
	xorl	%ebp, %ebp
	leaq	_ZSt4cout(%rip), %r12
	.p2align 4,,10
	.p2align 3
.L172:
	movl	(%rcx,%rbp,4), %esi
	movq	%r12, %rdi
	addq	$1, %rbp
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%rbx), %rcx
	movq	8(%rbx), %rax
	subq	%rcx, %rax
	movq	%rax, %rdx
	sarq	$2, %rdx
	subq	$1, %rdx
	cmpq	%rbp, %rdx
	ja	.L172
.L171:
	movl	-4(%rcx,%rax), %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rbp
	movq	%rax, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %r12
	testq	%r12, %r12
	je	.L178
	cmpb	$0, 56(%r12)
	je	.L174
	movsbl	67(%r12), %esi
.L175:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movl	$14, %edx
	leaq	.LC7(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	24(%rbx), %rcx
	movq	32(%rbx), %rax
	subq	%rcx, %rax
	cmpq	$4, %rax
	je	.L176
	xorl	%ebp, %ebp
	leaq	_ZSt4cout(%rip), %r12
	.p2align 4,,10
	.p2align 3
.L177:
	movl	(%rcx,%rbp,4), %esi
	movq	%r12, %rdi
	addq	$1, %rbp
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	24(%rbx), %rcx
	movq	32(%rbx), %rax
	subq	%rcx, %rax
	movq	%rax, %rdx
	sarq	$2, %rdx
	subq	$1, %rdx
	cmpq	%rbp, %rdx
	ja	.L177
.L176:
	movl	-4(%rcx,%rax), %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rbp
	movq	%rax, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %r12
	testq	%r12, %r12
	je	.L178
	cmpb	$0, 56(%r12)
	je	.L179
	movsbl	67(%r12), %esi
.L180:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movl	48(%rbx), %eax
	testl	%eax, %eax
	jle	.L170
	xorl	%ebp, %ebp
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %r13
	jmp	.L182
	.p2align 4,,10
	.p2align 3
.L205:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	56(%rbx), %rax
	leaq	_ZSt4cout(%rip), %rdi
	pxor	%xmm0, %xmm0
	cvtss2sd	(%rax,%rbp,4), %xmm0
	call	_ZNSo9_M_insertIdEERSoT_@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r12
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	64(%rbx), %rax
	movq	%r12, %rdi
	pxor	%xmm0, %xmm0
	cvtss2sd	(%rax,%rbp,4), %xmm0
	call	_ZNSo9_M_insertIdEERSoT_@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %r12
	movq	%rax, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%r12), %rax
	movq	-24(%rax), %rax
	movq	240(%r12,%rax), %r14
	testq	%r14, %r14
	je	.L178
	cmpb	$0, 56(%r14)
	je	.L184
	movsbl	67(%r14), %esi
.L185:
	movq	%r12, %rdi
	addq	$1, %rbp
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	cmpl	%ebp, 48(%rbx)
	jle	.L170
.L182:
	leal	1(%rbp), %eax
	movq	(%rbx), %rcx
	leaq	.LC12(%rip), %rsi
	cltd
	leaq	_ZSt4cout(%rip), %rdi
	idivl	4(%rcx)
	testl	%edx, %edx
	movl	$1, %edx
	je	.L205
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	56(%rbx), %rax
	leaq	_ZSt4cout(%rip), %rdi
	pxor	%xmm0, %xmm0
	cvtss2sd	(%rax,%rbp,4), %xmm0
	call	_ZNSo9_M_insertIdEERSoT_@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r12
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	64(%rbx), %rax
	movq	%r12, %rdi
	pxor	%xmm0, %xmm0
	cvtss2sd	(%rax,%rbp,4), %xmm0
	call	_ZNSo9_M_insertIdEERSoT_@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %r12
	movq	%rax, %rdi
	addq	$1, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%r12, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	cmpl	%ebp, 48(%rbx)
	jg	.L182
.L170:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L184:
	.cfi_restore_state
	movq	%r14, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r14), %rax
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%r13, %rax
	je	.L185
	movq	%r14, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L185
	.p2align 4,,10
	.p2align 3
.L179:
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	movl	$10, %esi
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L180
	movq	%r12, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L180
	.p2align 4,,10
	.p2align 3
.L174:
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	movl	$10, %esi
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L175
	movq	%r12, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L175
.L178:
	call	_ZSt16__throw_bad_castv@PLT
	.cfi_endproc
.LFE3420:
	.size	_ZN11denseMatrix5printEv, .-_ZN11denseMatrix5printEv
	.text
	.p2align 4
	.globl	_Z12load_partialiPKf
	.type	_Z12load_partialiPKf, @function
_Z12load_partialiPKf:
.LFB8693:
	.cfi_startproc
	endbr64
	cmpl	$3, %edi
	je	.L207
	jg	.L208
	cmpl	$1, %edi
	je	.L209
	cmpl	$2, %edi
	jne	.L213
	movq	(%rsi), %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L208:
	cmpl	$4, %edi
	jne	.L213
	movups	(%rsi), %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L213:
	pxor	%xmm0, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L209:
	movss	(%rsi), %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L207:
	movq	(%rsi), %xmm0
	movss	8(%rsi), %xmm1
	movlhps	%xmm1, %xmm0
	ret
	.cfi_endproc
.LFE8693:
	.size	_Z12load_partialiPKf, .-_Z12load_partialiPKf
	.p2align 4
	.globl	_Z13store_partialiPfDv4_f
	.type	_Z13store_partialiPfDv4_f, @function
_Z13store_partialiPfDv4_f:
.LFB8694:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movaps	%xmm0, (%rsp)
	testl	%edi, %edi
	jle	.L214
	movq	%rsi, %r8
	leal	-1(%rdi), %eax
	movq	%rsp, %rsi
	leaq	4(,%rax,4), %rdx
	movq	%r8, %rdi
	call	memcpy@PLT
.L214:
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE8694:
	.size	_Z13store_partialiPfDv4_f, .-_Z13store_partialiPfDv4_f
	.p2align 4
	.globl	_Z17getDiagonalLengthiSt6vectorIiSaIiEE
	.type	_Z17getDiagonalLengthiSt6vectorIiSaIiEE, @function
_Z17getDiagonalLengthiSt6vectorIiSaIiEE:
.LFB8695:
	.cfi_startproc
	endbr64
	movq	(%rsi), %rcx
	movl	(%rcx), %eax
	testl	%edi, %edi
	js	.L222
	movl	4(%rcx), %edx
	jne	.L223
	cmpl	%edx, %eax
	cmovle	%eax, %edx
	movl	%edx, %edi
.L219:
	cmpl	%eax, %edi
	jg	.L217
	cmpl	%edi, 4(%rcx)
	movl	%edi, %eax
	cmovle	4(%rcx), %eax
.L217:
	ret
	.p2align 4,,10
	.p2align 3
.L223:
	subl	%edi, %edx
	movl	%edx, %edi
	jmp	.L219
	.p2align 4,,10
	.p2align 3
.L222:
	addl	%eax, %edi
	jmp	.L219
	.cfi_endproc
.LFE8695:
	.size	_Z17getDiagonalLengthiSt6vectorIiSaIiEE, .-_Z17getDiagonalLengthiSt6vectorIiSaIiEE
	.section	.text.unlikely
.LCOLDB14:
	.text
.LHOTB14:
	.p2align 4
	.globl	_Z17multiplyDiagonalsSt6vectorIiSaIiEES1_ii8diagonalS2_
	.type	_Z17multiplyDiagonalsSt6vectorIiSaIiEES1_ii8diagonalS2_, @function
_Z17multiplyDiagonalsSt6vectorIiSaIiEES1_ii8diagonalS2_:
.LFB8696:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8696
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	leal	(%rcx,%r8), %edi
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$104, %rsp
	.cfi_def_cfa_offset 160
	movq	%fs:40, %rax
	movq	%rax, 88(%rsp)
	xorl	%eax, %eax
	movq	(%rdx), %rax
	movl	%edi, (%rsp)
	movl	4(%rax), %r15d
	cmpl	%r15d, %edi
	jge	.L288
	movq	(%rsi), %rax
	movl	(%rax), %eax
	movl	%eax, %edx
	negl	%edx
	cmpl	%edx, (%rsp)
	jg	.L227
	movq	$0, (%r12)
	movl	$4, %esi
	xorl	%edi, %edi
	call	calloc@PLT
	movl	$4, %esi
	xorl	%edi, %edi
	movq	%rax, (%rsp)
	call	calloc@PLT
	movq	(%rsp), %xmm0
	movq	%rax, %xmm2
	punpcklqdq	%xmm2, %xmm0
	movups	%xmm0, 8(%r12)
.L224:
	movq	88(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L289
	addq	$104, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L227:
	.cfi_restore_state
	movl	$8, %edi
	salq	$32, %r15
	movl	%ecx, %ebp
	movl	%r8d, %ebx
	orq	%rax, %r15
	movl	164(%rsp), %r13d
	movl	188(%rsp), %r14d
.LEHB14:
	call	_Znwm@PLT
.LEHE14:
	movl	$8, %edi
	movq	%r15, (%rax)
	movq	%rax, 16(%rsp)
.LEHB15:
	call	_Znwm@PLT
.LEHE15:
	movq	%rax, %rdi
	movq	16(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, (%rdi)
	movl	(%rsp), %eax
	movl	(%rdi), %r15d
	testl	%eax, %eax
	js	.L290
	movl	4(%rdi), %eax
	je	.L230
	subl	(%rsp), %eax
.L229:
	cmpl	%r15d, %eax
	jg	.L231
	cmpl	%eax, 4(%rdi)
	cmovle	4(%rdi), %eax
	movl	%eax, %r15d
.L231:
	call	_ZdlPv@PLT
	movslq	%r15d, %rdi
	movl	$4, %esi
	movq	%rdi, 24(%rsp)
	call	calloc@PLT
	movq	24(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, 8(%rsp)
	call	calloc@PLT
	movl	%ebp, %edx
	movl	%ebx, %ecx
	sarl	$31, %edx
	movq	%rax, 24(%rsp)
	sarl	$31, %ecx
	movl	%edx, %eax
	xorl	%ebp, %eax
	subl	%edx, %eax
	movl	%ecx, %edx
	xorl	%ebx, %edx
	subl	%ecx, %edx
	testl	%ebp, %ebp
	jle	.L232
	testl	%ebx, %ebx
	js	.L291
.L285:
	xorl	%ebx, %ebx
	xorl	%ebp, %ebp
.L233:
	cmpl	%r15d, %ebp
	jge	.L240
	cmpl	%ebx, %r13d
	jle	.L240
	cmpl	%eax, %r14d
	jle	.L240
	movl	%r15d, %esi
	xorl	%edx, %edx
	subl	%ebp, %esi
	jmp	.L241
	.p2align 4,,10
	.p2align 3
.L243:
	leal	(%rbx,%rdx), %ecx
	cmpl	%ecx, %r13d
	jle	.L242
	leal	(%rax,%rdx), %ecx
	cmpl	%ecx, %r14d
	jle	.L242
.L241:
	addl	$1, %edx
	cmpl	%esi, %edx
	jne	.L243
.L242:
	movl	%edx, %r10d
	movl	%edx, %r11d
	movq	192(%rsp), %r9
	movq	200(%rsp), %r8
	andl	$-4, %r10d
	andl	$3, %r11d
	sarl	$2, %edx
	movq	168(%rsp), %r14
	leal	(%r10,%rbx), %esi
	movq	%r9, 40(%rsp)
	movl	%esi, 32(%rsp)
	leal	(%r10,%rax), %esi
	movl	%esi, 36(%rsp)
	movq	176(%rsp), %rsi
	movq	%r8, 56(%rsp)
	movq	%rsi, 48(%rsp)
	je	.L244
	leal	-1(%rdx), %edi
	movslq	%ebx, %rdx
	movslq	%eax, %rcx
	movq	8(%rsp), %rax
	salq	$2, %rdx
	salq	$2, %rcx
	addq	$1, %rdi
	leaq	(%r14,%rdx), %r13
	addq	%rsi, %rdx
	movslq	%ebp, %rsi
	addq	%rcx, %r9
	salq	$2, %rsi
	addq	%r8, %rcx
	salq	$4, %rdi
	leaq	(%rax,%rsi), %r8
	addq	24(%rsp), %rsi
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L245:
	movups	(%r9,%rax), %xmm6
	movups	(%rcx,%rax), %xmm7
	movups	0(%r13,%rax), %xmm0
	movups	(%rdx,%rax), %xmm1
	mulps	%xmm6, %xmm0
	mulps	%xmm7, %xmm1
	subps	%xmm1, %xmm0
	movups	(%rdx,%rax), %xmm1
	mulps	%xmm6, %xmm1
	movups	%xmm0, (%r8,%rax)
	movups	0(%r13,%rax), %xmm0
	mulps	%xmm7, %xmm0
	addps	%xmm1, %xmm0
	movups	%xmm0, (%rsi,%rax)
	addq	$16, %rax
	cmpq	%rdi, %rax
	jne	.L245
	addl	%r10d, %ebp
.L244:
	testl	%r11d, %r11d
	je	.L240
	movslq	32(%rsp), %rdx
	leaq	0(,%rdx,4), %rax
	addq	%rax, %r14
	cmpl	$2, %r11d
	je	.L246
	cmpl	$3, %r11d
	je	.L247
	cmpl	$1, %r11d
	je	.L292
	movslq	%ebp, %rbp
	testl	%r11d, %r11d
	jne	.L293
	.p2align 4,,10
	.p2align 3
.L240:
	movl	(%rsp), %eax
	movq	16(%rsp), %rdi
	movl	%r15d, 4(%r12)
	movq	8(%rsp), %xmm0
	movl	%eax, (%r12)
	movhps	24(%rsp), %xmm0
	movups	%xmm0, 8(%r12)
	call	_ZdlPv@PLT
	jmp	.L224
	.p2align 4,,10
	.p2align 3
.L288:
	movq	$0, (%r12)
	movl	$4, %esi
	xorl	%edi, %edi
	call	calloc@PLT
	movl	$4, %esi
	xorl	%edi, %edi
	movq	%rax, (%rsp)
	call	calloc@PLT
	movq	(%rsp), %xmm0
	movq	%rax, %xmm4
	punpcklqdq	%xmm4, %xmm0
	movups	%xmm0, 8(%r12)
	jmp	.L224
	.p2align 4,,10
	.p2align 3
.L290:
	addl	%r15d, %eax
	jmp	.L229
	.p2align 4,,10
	.p2align 3
.L232:
	je	.L234
	testl	%ebx, %ebx
	jle	.L235
	cmpl	%r14d, %r13d
	jle	.L236
	movl	%r15d, %ebp
	subl	%r14d, %ebp
.L237:
	xorl	%eax, %eax
	xorl	%ebx, %ebx
	jmp	.L233
.L230:
	cmpl	%eax, %r15d
	cmovle	%r15d, %eax
	jmp	.L229
.L234:
	xorl	%eax, %eax
	testl	%ebx, %ebx
	js	.L294
	xorl	%ebx, %ebx
	jmp	.L233
.L235:
	cmovne	%edx, %ebx
.L286:
	xorl	%eax, %eax
	xorl	%ebp, %ebp
	jmp	.L233
.L291:
	movl	(%rsp), %ebx
	movl	%ebx, %ecx
	sarl	$31, %ecx
	xorl	%ecx, %ebx
	subl	%ecx, %ebx
	cmpl	%edx, %eax
	jle	.L286
	movl	%ebx, %eax
	jmp	.L285
.L246:
	movq	48(%rsp), %rax
	movq	40(%rsp), %rbx
	movq	(%r14), %xmm4
	movq	(%rax,%rdx,4), %xmm3
	movslq	36(%rsp), %rax
	movq	(%rbx,%rax,4), %xmm0
	movq	56(%rsp), %rbx
	movq	(%rbx,%rax,4), %xmm2
.L287:
	movaps	%xmm2, %xmm5
	movaps	%xmm0, %xmm1
	mulps	%xmm4, %xmm5
	mulps	%xmm3, %xmm1
	mulps	%xmm4, %xmm0
	mulps	%xmm3, %xmm2
	addps	%xmm5, %xmm1
	subps	%xmm2, %xmm0
.L249:
	movslq	%ebp, %rbp
.L265:
	leal	-1(%r11), %eax
	movq	8(%rsp), %rbx
	movaps	%xmm0, 64(%rsp)
	leaq	64(%rsp), %rdi
	leaq	4(,%rax,4), %rdx
	leaq	0(,%rbp,4), %rax
	leaq	(%rbx,%rax), %rcx
	cmpl	$8, %edx
	jnb	.L251
	testb	$4, %dl
	jne	.L295
	testl	%edx, %edx
	je	.L252
	movzbl	(%rdi), %esi
	movb	%sil, (%rcx)
.L252:
	movaps	%xmm1, 64(%rsp)
	addq	24(%rsp), %rax
	cmpl	$8, %edx
	jnb	.L257
	testb	$4, %dl
	jne	.L296
	testl	%edx, %edx
	je	.L240
	movzbl	(%rdi), %edx
	movb	%dl, (%rax)
	jmp	.L240
.L247:
	movq	48(%rsp), %rbx
	movq	(%r14), %xmm0
	movss	8(%r14), %xmm1
	movq	(%rbx,%rax), %xmm2
	movlhps	%xmm1, %xmm0
	movss	8(%rbx,%rax), %xmm1
	movslq	36(%rsp), %rax
	movq	40(%rsp), %rbx
	movlhps	%xmm1, %xmm2
	movq	(%rbx,%rax,4), %xmm4
	movss	8(%rbx,%rax,4), %xmm1
	movq	56(%rsp), %rbx
	movq	(%rbx,%rax,4), %xmm3
	movlhps	%xmm1, %xmm4
	movss	8(%rbx,%rax,4), %xmm1
	movlhps	%xmm1, %xmm3
	jmp	.L287
.L292:
	movq	48(%rsp), %rax
	movq	40(%rsp), %rbx
	movss	(%r14), %xmm0
	movaps	%xmm0, %xmm5
	movss	(%rax,%rdx,4), %xmm2
	movslq	36(%rsp), %rax
	movaps	%xmm2, %xmm1
	movss	(%rbx,%rax,4), %xmm4
	movq	56(%rsp), %rbx
	mulps	%xmm4, %xmm1
	mulps	%xmm4, %xmm0
	movss	(%rbx,%rax,4), %xmm3
	mulps	%xmm3, %xmm5
	mulps	%xmm3, %xmm2
	addps	%xmm5, %xmm1
	subps	%xmm2, %xmm0
	jmp	.L249
.L251:
	movq	64(%rsp), %rsi
	movq	%rdi, %r9
	movq	%rsi, (%rcx)
	movl	%edx, %esi
	movq	-8(%rdi,%rsi), %r8
	movq	%r8, -8(%rcx,%rsi)
	leaq	8(%rcx), %r8
	andq	$-8, %r8
	subq	%r8, %rcx
	subq	%rcx, %r9
	addl	%edx, %ecx
	andl	$-8, %ecx
	cmpl	$8, %ecx
	jb	.L252
	andl	$-8, %ecx
	xorl	%esi, %esi
.L255:
	movl	%esi, %r10d
	addl	$8, %esi
	movq	(%r9,%r10), %r11
	movq	%r11, (%r8,%r10)
	cmpl	%ecx, %esi
	jb	.L255
	jmp	.L252
.L257:
	movq	64(%rsp), %rcx
	movq	%rcx, (%rax)
	movl	%edx, %ecx
	movq	-8(%rdi,%rcx), %rsi
	movq	%rsi, -8(%rax,%rcx)
	leaq	8(%rax), %rsi
	andq	$-8, %rsi
	subq	%rsi, %rax
	subq	%rax, %rdi
	addl	%edx, %eax
	andl	$-8, %eax
	movq	%rdi, %rcx
	cmpl	$8, %eax
	jb	.L240
	andl	$-8, %eax
	xorl	%edx, %edx
.L261:
	movl	%edx, %edi
	addl	$8, %edx
	movq	(%rcx,%rdi), %r8
	movq	%r8, (%rsi,%rdi)
	cmpl	%eax, %edx
	jb	.L261
	jmp	.L240
.L236:
	jge	.L238
	movl	%r15d, %ebp
	subl	%r13d, %ebp
	jmp	.L237
.L294:
	movl	%edx, %ebx
	jmp	.L233
.L238:
	movl	(%rsp), %ecx
	testl	%ecx, %ecx
	cmovs	%edx, %eax
	movl	%eax, %ebp
	jmp	.L237
.L296:
	movl	(%rdi), %ecx
	movl	%edx, %edx
	movl	%ecx, (%rax)
	movl	-4(%rdi,%rdx), %ecx
	movl	%ecx, -4(%rax,%rdx)
	jmp	.L240
.L295:
	movl	(%rdi), %esi
	movl	%esi, (%rcx)
	movl	%edx, %esi
	movl	-4(%rdi,%rsi), %r8d
	movl	%r8d, -4(%rcx,%rsi)
	jmp	.L252
.L293:
	pxor	%xmm0, %xmm0
	movaps	%xmm0, %xmm1
	jmp	.L265
.L289:
	call	__stack_chk_fail@PLT
.L271:
	endbr64
	movq	%rax, %rbp
	jmp	.L263
	.section	.gcc_except_table
.LLSDA8696:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8696-.LLSDACSB8696
.LLSDACSB8696:
	.uleb128 .LEHB14-.LFB8696
	.uleb128 .LEHE14-.LEHB14
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB15-.LFB8696
	.uleb128 .LEHE15-.LEHB15
	.uleb128 .L271-.LFB8696
	.uleb128 0
.LLSDACSE8696:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8696
	.type	_Z17multiplyDiagonalsSt6vectorIiSaIiEES1_ii8diagonalS2_.cold, @function
_Z17multiplyDiagonalsSt6vectorIiSaIiEES1_ii8diagonalS2_.cold:
.LFSB8696:
.L263:
	.cfi_def_cfa_offset 160
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	16(%rsp), %rdi
	call	_ZdlPv@PLT
	movq	%rbp, %rdi
.LEHB16:
	call	_Unwind_Resume@PLT
.LEHE16:
	.cfi_endproc
.LFE8696:
	.section	.gcc_except_table
.LLSDAC8696:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8696-.LLSDACSBC8696
.LLSDACSBC8696:
	.uleb128 .LEHB16-.LCOLDB14
	.uleb128 .LEHE16-.LEHB16
	.uleb128 0
	.uleb128 0
.LLSDACSEC8696:
	.section	.text.unlikely
	.text
	.size	_Z17multiplyDiagonalsSt6vectorIiSaIiEES1_ii8diagonalS2_, .-_Z17multiplyDiagonalsSt6vectorIiSaIiEES1_ii8diagonalS2_
	.section	.text.unlikely
	.size	_Z17multiplyDiagonalsSt6vectorIiSaIiEES1_ii8diagonalS2_.cold, .-_Z17multiplyDiagonalsSt6vectorIiSaIiEES1_ii8diagonalS2_.cold
.LCOLDE14:
	.text
.LHOTE14:
	.section	.text._ZN11denseMatrixD2Ev,"axG",@progbits,_ZN11denseMatrixD5Ev,comdat
	.align 2
	.p2align 4
	.weak	_ZN11denseMatrixD2Ev
	.type	_ZN11denseMatrixD2Ev, @function
_ZN11denseMatrixD2Ev:
.LFB8715:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	movq	24(%rdi), %rdi
	testq	%rdi, %rdi
	je	.L298
	call	_ZdlPv@PLT
.L298:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L297
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	jmp	_ZdlPv@PLT
	.p2align 4,,10
	.p2align 3
.L297:
	.cfi_restore_state
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE8715:
	.size	_ZN11denseMatrixD2Ev, .-_ZN11denseMatrixD2Ev
	.weak	_ZN11denseMatrixD1Ev
	.set	_ZN11denseMatrixD1Ev,_ZN11denseMatrixD2Ev
	.section	.rodata.str1.8
	.align 8
.LC15:
	.string	"diagonals are of different lengths!"
	.section	.text.unlikely
.LCOLDB16:
	.text
.LHOTB16:
	.p2align 4
	.globl	_Z11addElements8diagonalS_
	.type	_Z11addElements8diagonalS_, @function
_Z11addElements8diagonalS_:
.LFB8720:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8720
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movq	%fs:40, %rax
	movq	%rax, 72(%rsp)
	xorl	%eax, %eax
	movq	152(%rsp), %rbx
	movq	160(%rsp), %r13
	movq	176(%rsp), %r14
	movq	184(%rsp), %r15
	movslq	148(%rsp), %rbp
	cmpl	172(%rsp), %ebp
	jne	.L309
	movq	%rdi, %r12
	movl	$4, %esi
	movq	%rbp, %rdi
	call	calloc@PLT
	movq	%rbp, %rdi
	movl	$4, %esi
	movq	%rax, 8(%rsp)
	call	calloc@PLT
	xorl	%ecx, %ecx
	leaq	16(%rsp), %rsi
	movl	$16, %edx
	movq	%rax, 64(%rsp)
	movq	%rax, %rbp
	movq	8(%rsp), %rax
	leaq	_Z11addElements8diagonalS_._omp_fn.0(%rip), %rdi
	movq	%r15, 48(%rsp)
	movq	%rax, 56(%rsp)
	leaq	144(%rsp), %rax
	movq	%rax, 16(%rsp)
	movq	%r14, 40(%rsp)
	movq	%r13, 32(%rsp)
	movq	%rbx, 24(%rsp)
	call	GOMP_parallel@PLT
	movq	144(%rsp), %rax
	movq	%rbp, %xmm1
	movq	8(%rsp), %xmm0
	movq	%rax, (%r12)
	punpcklqdq	%xmm1, %xmm0
	movups	%xmm0, 8(%r12)
	movq	72(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L312
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L312:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.section	.gcc_except_table
.LLSDA8720:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8720-.LLSDACSB8720
.LLSDACSB8720:
.LLSDACSE8720:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8720
	.type	_Z11addElements8diagonalS_.cold, @function
_Z11addElements8diagonalS_.cold:
.LFSB8720:
.L309:
	.cfi_def_cfa_offset 144
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC15(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
.LEHB17:
	call	_ZNSt16invalid_argumentC1EPKc@PLT
.LEHE17:
	movq	_ZNSt16invalid_argumentD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt16invalid_argument(%rip), %rsi
	movq	%rbp, %rdi
.LEHB18:
	call	__cxa_throw@PLT
.L308:
	endbr64
	movq	%rax, %r12
	movq	%rbp, %rdi
	call	__cxa_free_exception@PLT
	movq	%r12, %rdi
	call	_Unwind_Resume@PLT
.LEHE18:
	.cfi_endproc
.LFE8720:
	.section	.gcc_except_table
.LLSDAC8720:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8720-.LLSDACSBC8720
.LLSDACSBC8720:
	.uleb128 .LEHB17-.LCOLDB16
	.uleb128 .LEHE17-.LEHB17
	.uleb128 .L308-.LCOLDB16
	.uleb128 0
	.uleb128 .LEHB18-.LCOLDB16
	.uleb128 .LEHE18-.LEHB18
	.uleb128 0
	.uleb128 0
.LLSDACSEC8720:
	.section	.text.unlikely
	.text
	.size	_Z11addElements8diagonalS_, .-_Z11addElements8diagonalS_
	.section	.text.unlikely
	.size	_Z11addElements8diagonalS_.cold, .-_Z11addElements8diagonalS_.cold
.LCOLDE16:
	.text
.LHOTE16:
	.p2align 4
	.globl	_Z5array19quantumSparseMatrix
	.type	_Z5array19quantumSparseMatrix, @function
_Z5array19quantumSparseMatrix:
.LFB8739:
	.cfi_startproc
	endbr64
	movq	(%rsi), %rdx
	movq	$0, (%rsi)
	movq	%rdi, %rax
	leaq	64(%rdi), %rcx
	movq	%rdx, (%rdi)
	movq	8(%rsi), %rdx
	movq	$0, 8(%rsi)
	movq	%rdx, 8(%rdi)
	movq	16(%rsi), %rdx
	movq	$0, 16(%rsi)
	movq	%rdx, 16(%rdi)
	movq	24(%rsi), %rdx
	movq	$0, 24(%rsi)
	movq	%rdx, 24(%rdi)
	movq	32(%rsi), %rdx
	movq	$0, 32(%rsi)
	movq	%rdx, 32(%rdi)
	movq	40(%rsi), %rdx
	movq	$0, 40(%rsi)
	movq	%rdx, 40(%rdi)
	movl	48(%rsi), %edx
	movl	%edx, 48(%rdi)
	movq	72(%rsi), %rdx
	testq	%rdx, %rdx
	je	.L314
	movl	64(%rsi), %edi
	movq	%rdx, 72(%rax)
	movl	%edi, 64(%rax)
	movq	80(%rsi), %rdi
	movq	%rdi, 80(%rax)
	movq	88(%rsi), %rdi
	movq	%rdi, 88(%rax)
	movq	%rcx, 8(%rdx)
	movq	96(%rsi), %rdx
	movq	$0, 72(%rsi)
	movq	%rdx, 96(%rax)
	leaq	64(%rsi), %rdx
	movq	%rdx, 80(%rsi)
	movq	%rdx, 88(%rsi)
	movq	$0, 96(%rsi)
	ret
	.p2align 4,,10
	.p2align 3
.L314:
	movl	$0, 64(%rdi)
	movq	$0, 72(%rdi)
	movq	%rcx, 80(%rdi)
	movq	%rcx, 88(%rdi)
	movq	$0, 96(%rdi)
	ret
	.cfi_endproc
.LFE8739:
	.size	_Z5array19quantumSparseMatrix, .-_Z5array19quantumSparseMatrix
	.p2align 4
	.globl	_Z6einsum19quantumSparseMatrixSt6vectorIiSaIiEE
	.type	_Z6einsum19quantumSparseMatrixSt6vectorIiSaIiEE, @function
_Z6einsum19quantumSparseMatrixSt6vectorIiSaIiEE:
.LFB8740:
	.cfi_startproc
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rdi, %r12
	leaq	_ZSt4cout(%rip), %rdi
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rsi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	(%rdx), %rax
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movq	%rax, %rbp
	movq	(%rax), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %r13
	testq	%r13, %r13
	je	.L324
	cmpb	$0, 56(%r13)
	je	.L318
	movsbl	67(%r13), %esi
.L319:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movq	(%rbx), %rax
	movq	$0, (%rbx)
	leaq	64(%r12), %rdx
	movq	%rax, (%r12)
	movq	8(%rbx), %rax
	movq	$0, 8(%rbx)
	movq	%rax, 8(%r12)
	movq	16(%rbx), %rax
	movq	$0, 16(%rbx)
	movq	%rax, 16(%r12)
	movq	24(%rbx), %rax
	movq	$0, 24(%rbx)
	movq	%rax, 24(%r12)
	movq	32(%rbx), %rax
	movq	$0, 32(%rbx)
	movq	%rax, 32(%r12)
	movq	40(%rbx), %rax
	movq	$0, 40(%rbx)
	movq	%rax, 40(%r12)
	movl	48(%rbx), %eax
	movl	%eax, 48(%r12)
	movq	72(%rbx), %rax
	testq	%rax, %rax
	je	.L320
	movl	64(%rbx), %ecx
	movq	%rax, 72(%r12)
	movl	%ecx, 64(%r12)
	movq	80(%rbx), %rcx
	movq	%rcx, 80(%r12)
	movq	88(%rbx), %rcx
	movq	%rcx, 88(%r12)
	movq	%rdx, 8(%rax)
	movq	96(%rbx), %rax
	movq	$0, 72(%rbx)
	movq	%rax, 96(%r12)
	leaq	64(%rbx), %rax
	movq	%rax, 80(%rbx)
	movq	%rax, 88(%rbx)
	movq	%r12, %rax
	movq	$0, 96(%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L318:
	.cfi_restore_state
	movq	%r13, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%r13), %rax
	movl	$10, %esi
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L319
	movq	%r13, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L319
	.p2align 4,,10
	.p2align 3
.L320:
	movl	$0, 64(%r12)
	movq	%r12, %rax
	movq	$0, 72(%r12)
	movq	%rdx, 80(%r12)
	movq	%rdx, 88(%r12)
	movq	$0, 96(%r12)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L324:
	.cfi_restore_state
	call	_ZSt16__throw_bad_castv@PLT
	.cfi_endproc
.LFE8740:
	.size	_Z6einsum19quantumSparseMatrixSt6vectorIiSaIiEE, .-_Z6einsum19quantumSparseMatrixSt6vectorIiSaIiEE
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC19:
	.string	"double norm(const Vector&)"
.LC20:
	.string	"../include/../src/norms.hpp"
.LC21:
	.string	"sum.imag() == 0.0"
	.text
	.p2align 4
	.globl	_Z4normRK6Vector
	.type	_Z4normRK6Vector, @function
_Z4normRK6Vector:
.LFB8756:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	movq	(%rdi), %rbp
	testq	%rbp, %rbp
	je	.L333
	movq	8(%rdi), %rbx
	pxor	%xmm9, %xmm9
	salq	$4, %rbp
	movq	.LC18(%rip), %xmm8
	movapd	%xmm9, %xmm6
	movapd	%xmm9, %xmm5
	addq	%rbx, %rbp
	.p2align 4,,10
	.p2align 3
.L330:
	movsd	8(%rbx), %xmm1
	movsd	(%rbx), %xmm0
	movapd	%xmm1, %xmm3
	movapd	%xmm0, %xmm4
	movapd	%xmm0, %xmm7
	mulsd	%xmm0, %xmm4
	xorpd	%xmm8, %xmm3
	mulsd	%xmm3, %xmm7
	movapd	%xmm3, %xmm2
	mulsd	%xmm1, %xmm2
	subsd	%xmm2, %xmm4
	movapd	%xmm0, %xmm2
	mulsd	%xmm1, %xmm2
	addsd	%xmm7, %xmm2
	ucomisd	%xmm4, %xmm2
	jp	.L336
	addq	$16, %rbx
	addsd	%xmm4, %xmm5
	addsd	%xmm2, %xmm6
	cmpq	%rbp, %rbx
	jne	.L330
.L329:
	ucomisd	%xmm9, %xmm6
	jp	.L334
	jne	.L334
	ucomisd	%xmm5, %xmm9
	movapd	%xmm5, %xmm1
	sqrtsd	%xmm1, %xmm1
	ja	.L337
.L325:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movapd	%xmm1, %xmm0
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L333:
	.cfi_restore_state
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pxor	%xmm1, %xmm1
	movapd	%xmm1, %xmm0
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L336:
	.cfi_restore_state
	movapd	%xmm0, %xmm2
	movsd	%xmm5, 8(%rsp)
	addq	$16, %rbx
	movsd	%xmm6, (%rsp)
	call	__muldc3@PLT
	movsd	8(%rsp), %xmm5
	movsd	(%rsp), %xmm6
	cmpq	%rbx, %rbp
	movq	.LC18(%rip), %xmm8
	pxor	%xmm9, %xmm9
	addsd	%xmm0, %xmm5
	addsd	%xmm1, %xmm6
	jne	.L330
	jmp	.L329
.L337:
	movapd	%xmm5, %xmm0
	movsd	%xmm1, (%rsp)
	call	sqrt@PLT
	movsd	(%rsp), %xmm1
	jmp	.L325
.L334:
	leaq	.LC19(%rip), %rcx
	movl	$24, %edx
	leaq	.LC20(%rip), %rsi
	leaq	.LC21(%rip), %rdi
	call	__assert_fail@PLT
	.cfi_endproc
.LFE8756:
	.size	_Z4normRK6Vector, .-_Z4normRK6Vector
	.section	.text._ZN11denseMatrixC2ERKS_,"axG",@progbits,_ZN11denseMatrixC5ERKS_,comdat
	.align 2
	.p2align 4
	.weak	_ZN11denseMatrixC2ERKS_
	.type	_ZN11denseMatrixC2ERKS_, @function
_ZN11denseMatrixC2ERKS_:
.LFB8779:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8779
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pxor	%xmm0, %xmm0
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	8(%rsi), %r12
	movq	%rdi, %rbx
	subq	(%rsi), %r12
	movq	$0, 16(%rdi)
	movq	%r12, %rax
	movups	%xmm0, (%rdi)
	sarq	$2, %rax
	je	.L357
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L358
	movq	%r12, %rdi
.LEHB19:
	call	_Znwm@PLT
.LEHE19:
	movq	%rax, %rcx
.L340:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 16(%rbx)
	movups	%xmm0, (%rbx)
	movq	8(%rbp), %rax
	movq	0(%rbp), %rsi
	movq	%rax, %r12
	subq	%rsi, %r12
	cmpq	%rsi, %rax
	je	.L343
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L343:
	addq	%r12, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%rbx)
	movq	32(%rbp), %r12
	subq	24(%rbp), %r12
	movq	$0, 40(%rbx)
	movq	%r12, %rax
	movups	%xmm0, 24(%rbx)
	sarq	$2, %rax
	je	.L359
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L360
	movq	%r12, %rdi
.LEHB20:
	call	_Znwm@PLT
.LEHE20:
	movq	%rax, %rcx
.L345:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 40(%rbx)
	movups	%xmm0, 24(%rbx)
	movq	32(%rbp), %rax
	movq	24(%rbp), %rsi
	movq	%rax, %r12
	subq	%rsi, %r12
	cmpq	%rsi, %rax
	je	.L348
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L348:
	movl	48(%rbp), %eax
	movdqu	56(%rbp), %xmm1
	addq	%r12, %rcx
	movq	%rcx, 32(%rbx)
	movl	%eax, 48(%rbx)
	movups	%xmm1, 56(%rbx)
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L357:
	.cfi_restore_state
	xorl	%ecx, %ecx
	jmp	.L340
	.p2align 4,,10
	.p2align 3
.L359:
	xorl	%ecx, %ecx
	jmp	.L345
.L358:
.LEHB21:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE21:
.L360:
.LEHB22:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE22:
.L351:
	endbr64
	movq	%rax, %rbp
.L349:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L350
	call	_ZdlPv@PLT
.L350:
	movq	%rbp, %rdi
.LEHB23:
	call	_Unwind_Resume@PLT
.LEHE23:
	.cfi_endproc
.LFE8779:
	.section	.gcc_except_table
.LLSDA8779:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8779-.LLSDACSB8779
.LLSDACSB8779:
	.uleb128 .LEHB19-.LFB8779
	.uleb128 .LEHE19-.LEHB19
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB20-.LFB8779
	.uleb128 .LEHE20-.LEHB20
	.uleb128 .L351-.LFB8779
	.uleb128 0
	.uleb128 .LEHB21-.LFB8779
	.uleb128 .LEHE21-.LEHB21
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB22-.LFB8779
	.uleb128 .LEHE22-.LEHB22
	.uleb128 .L351-.LFB8779
	.uleb128 0
	.uleb128 .LEHB23-.LFB8779
	.uleb128 .LEHE23-.LEHB23
	.uleb128 0
	.uleb128 0
.LLSDACSE8779:
	.section	.text._ZN11denseMatrixC2ERKS_,"axG",@progbits,_ZN11denseMatrixC5ERKS_,comdat
	.size	_ZN11denseMatrixC2ERKS_, .-_ZN11denseMatrixC2ERKS_
	.weak	_ZN11denseMatrixC1ERKS_
	.set	_ZN11denseMatrixC1ERKS_,_ZN11denseMatrixC2ERKS_
	.section	.text._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"axG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
	.p2align 4
	.weak	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	.type	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_, @function
_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_:
.LFB8782:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8782
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdi, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movl	%r8d, %r13d
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rcx, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdx, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	%rsi, 8(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	call	__errno_location@PLT
	leaq	16(%rsp), %rsi
	movl	%r13d, %edx
	movq	%rbp, %rdi
	movl	(%rax), %r14d
	movq	%rax, %rbx
	movl	$0, (%rax)
.LEHB24:
	call	*%r15
	movq	16(%rsp), %rdx
	cmpq	%rbp, %rdx
	je	.L378
	movl	(%rbx), %esi
	cmpl	$34, %esi
	je	.L363
	movl	$2147483648, %ecx
	movl	$4294967295, %edi
	addq	%rax, %rcx
	cmpq	%rdi, %rcx
	ja	.L363
	testq	%r12, %r12
	je	.L365
	subq	%rbp, %rdx
	movq	%rdx, (%r12)
.L365:
	testl	%esi, %esi
	je	.L379
.L361:
	movq	24(%rsp), %rbx
	xorq	%fs:40, %rbx
	jne	.L380
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L379:
	.cfi_restore_state
	movl	%r14d, (%rbx)
	jmp	.L361
.L363:
	movq	8(%rsp), %rdi
	call	_ZSt20__throw_out_of_rangePKc@PLT
.L378:
	movq	8(%rsp), %rdi
	call	_ZSt24__throw_invalid_argumentPKc@PLT
.LEHE24:
.L380:
	call	__stack_chk_fail@PLT
.L370:
	endbr64
	movq	%rax, %rdi
.L367:
	cmpl	$0, (%rbx)
	jne	.L368
	movl	%r14d, (%rbx)
.L368:
.LEHB25:
	call	_Unwind_Resume@PLT
.LEHE25:
	.cfi_endproc
.LFE8782:
	.section	.gcc_except_table
.LLSDA8782:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8782-.LLSDACSB8782
.LLSDACSB8782:
	.uleb128 .LEHB24-.LFB8782
	.uleb128 .LEHE24-.LEHB24
	.uleb128 .L370-.LFB8782
	.uleb128 0
	.uleb128 .LEHB25-.LFB8782
	.uleb128 .LEHE25-.LEHB25
	.uleb128 0
	.uleb128 0
.LLSDACSE8782:
	.section	.text._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"axG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
	.size	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_, .-_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	.section	.text._ZNSt6vectorIiSaIiEEaSERKS1_,"axG",@progbits,_ZNSt6vectorIiSaIiEEaSERKS1_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIiSaIiEEaSERKS1_
	.type	_ZNSt6vectorIiSaIiEEaSERKS1_, @function
_ZNSt6vectorIiSaIiEEaSERKS1_:
.LFB9001:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	cmpq	%rdi, %rsi
	je	.L382
	movq	8(%rsi), %r15
	movq	(%rsi), %r13
	movq	%rsi, %rbx
	movq	(%rdi), %r14
	movq	16(%rdi), %rax
	movq	%r15, %rbp
	subq	%r13, %rbp
	subq	%r14, %rax
	movq	%rbp, %rcx
	sarq	$2, %rax
	sarq	$2, %rcx
	cmpq	%rax, %rcx
	ja	.L402
	movq	8(%rdi), %rdi
	movq	%rdi, %rsi
	subq	%r14, %rsi
	movq	%rsi, %rax
	sarq	$2, %rax
	cmpq	%rax, %rcx
	ja	.L390
	cmpq	%r15, %r13
	je	.L401
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%r14, %rdi
	call	memmove@PLT
	addq	(%r12), %rbp
	movq	%rbp, 8(%r12)
.L382:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L402:
	.cfi_restore_state
	xorl	%ebx, %ebx
	testq	%rcx, %rcx
	je	.L385
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L403
	movq	%rbp, %rdi
	call	_Znwm@PLT
	movq	(%r12), %r14
	movq	%rax, %rbx
.L385:
	cmpq	%r15, %r13
	je	.L387
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
.L387:
	testq	%r14, %r14
	je	.L388
	movq	%r14, %rdi
	call	_ZdlPv@PLT
.L388:
	addq	%rbx, %rbp
	movq	%rbx, (%r12)
	movq	%rbp, 16(%r12)
	jmp	.L389
	.p2align 4,,10
	.p2align 3
.L390:
	movq	%rsi, %rdx
	testq	%rsi, %rsi
	je	.L392
	movq	%r14, %rdi
	movq	%r13, %rsi
	call	memmove@PLT
	movq	8(%r12), %rdi
	movq	(%r12), %r14
	movq	8(%rbx), %r15
	movq	(%rbx), %r13
	movq	%rdi, %rdx
	subq	%r14, %rdx
.L392:
	leaq	0(%r13,%rdx), %rsi
	cmpq	%r15, %rsi
	jne	.L393
.L401:
	addq	%r14, %rbp
.L389:
	movq	%rbp, 8(%r12)
	jmp	.L382
	.p2align 4,,10
	.p2align 3
.L393:
	movq	%r15, %rdx
	subq	%rsi, %rdx
	call	memmove@PLT
	addq	(%r12), %rbp
	jmp	.L389
.L403:
	call	_ZSt17__throw_bad_allocv@PLT
	.cfi_endproc
.LFE9001:
	.size	_ZNSt6vectorIiSaIiEEaSERKS1_, .-_ZNSt6vectorIiSaIiEEaSERKS1_
	.section	.rodata.str1.8
	.align 8
.LC23:
	.string	"input matrices are not multiplyable"
	.section	.text.unlikely
.LCOLDB24:
	.text
.LHOTB24:
	.p2align 4
	.globl	_Z12denseProduct11denseMatrixS_
	.type	_Z12denseProduct11denseMatrixS_, @function
_Z12denseProduct11denseMatrixS_:
.LFB8713:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8713
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdx, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rsi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$168, %rsp
	.cfi_def_cfa_offset 224
	movq	(%rsi), %rsi
	movq	%rdi, 48(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 152(%rsp)
	xorl	%eax, %eax
	movq	8(%r14), %rax
	movq	%rax, %rdx
	subq	%rsi, %rdx
	movq	%rdx, %rcx
	sarq	$2, %rcx
	je	.L439
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L466
	movq	%rdx, %rdi
.LEHB26:
	call	_Znwm@PLT
.LEHE26:
	movq	(%r14), %rsi
	movq	%rax, 32(%rsp)
	movq	8(%r14), %rax
	movq	%rax, %rdx
	subq	%rsi, %rdx
.L405:
	cmpq	%rsi, %rax
	je	.L407
	movq	32(%rsp), %rdi
	call	memcpy@PLT
.L407:
	movq	8(%r15), %rax
	movq	(%r15), %rbx
	movq	%rax, %rdx
	subq	%rbx, %rdx
	movq	%rdx, %rcx
	sarq	$2, %rcx
	je	.L440
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L467
	movq	%rdx, %rdi
.LEHB27:
	call	_Znwm@PLT
.LEHE27:
	movq	%rax, 40(%rsp)
	movq	8(%r15), %rax
	movq	(%r15), %rbx
	movq	%rax, %rdx
	subq	%rbx, %rdx
.L408:
	cmpq	%rax, %rbx
	je	.L410
	movq	40(%rsp), %rdi
	movq	%rbx, %rsi
	call	memcpy@PLT
.L410:
	movq	40(%rsp), %rsi
	movq	32(%rsp), %rax
	movl	(%rsi), %esi
	cmpl	%esi, 4(%rax)
	jne	.L461
	movl	(%rax), %ebp
	movq	40(%rsp), %rax
	movl	$4, %esi
	imull	4(%rax), %ebp
	movslq	%ebp, %rbp
	movq	%rbp, %rdi
	call	calloc@PLT
	movq	%rbp, %rdi
	movl	$4, %esi
	movq	%rax, (%rsp)
	call	calloc@PLT
	movq	(%r14), %rdx
	pxor	%xmm0, %xmm0
	movl	$8, %edi
	movq	%rax, 8(%rsp)
	movl	4(%rbx), %eax
	movl	(%rdx), %ebx
	movaps	%xmm0, 128(%rsp)
	movq	$0, 144(%rsp)
	salq	$32, %rax
	orq	%rax, %rbx
.LEHB28:
	call	_Znwm@PLT
.LEHE28:
	leaq	8(%rax), %rdx
	movq	%rbx, (%rax)
	pxor	%xmm0, %xmm0
	leaq	128(%rsp), %rbp
	movq	%rax, 128(%rsp)
	movq	48(%rsp), %rax
	movq	%rbp, %rsi
	movq	%rdx, 144(%rsp)
	movups	%xmm0, (%rax)
	movq	%rax, %rdi
	leaq	24(%rax), %r12
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	(%rsp), %xmm0
	movq	%rdx, 136(%rsp)
	movhps	8(%rsp), %xmm0
	movups	%xmm0, 56(%rax)
.LEHB29:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	48(%rsp), %rsi
	movq	%r12, %rdi
	movq	(%rsi), %rdx
	movl	(%rdx), %eax
	imull	4(%rdx), %eax
	movl	%eax, 48(%rsi)
	movq	%rbp, %rsi
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE29:
	movq	32(%rsp), %rax
	movl	(%rax), %eax
	movl	%eax, 20(%rsp)
	testl	%eax, %eax
	jle	.L427
	movq	40(%rsp), %rsi
	movl	4(%rsi), %eax
	testl	%eax, %eax
	jle	.L427
	movl	(%rsi), %r10d
	movq	48(%rsp), %rsi
	leal	-1(%rax), %r11d
	xorl	%r8d, %r8d
	pxor	%xmm9, %xmm9
	movq	%r15, %rcx
	movq	56(%rsi), %rdi
	movq	(%rsi), %rdx
	leal	-1(%r10), %eax
	movq	64(%rsi), %rsi
	movq	%rax, (%rsp)
	movq	%rdi, 24(%rsp)
	movl	4(%rdx), %edi
	movq	%r14, %rdx
	movq	%rsi, 8(%rsp)
	movl	%edi, 16(%rsp)
	.p2align 4,,10
	.p2align 3
.L433:
	movl	16(%rsp), %edi
	movq	24(%rsp), %rax
	xorl	%r15d, %r15d
	imull	%r8d, %edi
	movslq	%edi, %rdi
	salq	$2, %rdi
	leaq	(%rax,%rdi), %r9
	addq	8(%rsp), %rdi
	testl	%r10d, %r10d
	jle	.L441
	.p2align 4,,10
	.p2align 3
.L470:
	movq	(%rcx), %rax
	movq	56(%rdx), %rsi
	movaps	%xmm9, %xmm6
	movaps	%xmm9, %xmm7
	movq	56(%rcx), %r13
	leaq	0(,%r15,4), %r12
	movslq	4(%rax), %r14
	movq	(%rdx), %rax
	addq	%r12, %r13
	addq	64(%rcx), %r12
	movl	4(%rax), %ebx
	salq	$2, %r14
	imull	%r8d, %ebx
	movslq	%ebx, %rax
	leaq	0(,%rax,4), %rbp
	addq	(%rsp), %rax
	leaq	(%rsi,%rbp), %rbx
	leaq	4(%rsi,%rax,4), %rax
	addq	64(%rdx), %rbp
	.p2align 4,,10
	.p2align 3
.L429:
	movss	(%rbx), %xmm2
	movss	0(%rbp), %xmm3
	movss	0(%r13), %xmm5
	movss	(%r12), %xmm1
	movaps	%xmm2, %xmm4
	movaps	%xmm3, %xmm0
	movaps	%xmm3, %xmm8
	mulss	%xmm1, %xmm0
	mulss	%xmm5, %xmm4
	mulss	%xmm5, %xmm8
	subss	%xmm0, %xmm4
	movaps	%xmm2, %xmm0
	mulss	%xmm1, %xmm0
	addss	%xmm8, %xmm0
	ucomiss	%xmm4, %xmm0
	jp	.L468
	addq	$4, %rbx
	addss	%xmm4, %xmm7
	addss	%xmm0, %xmm6
	addq	%r14, %r13
	addq	%r14, %r12
	addq	$4, %rbp
	cmpq	%rbx, %rax
	jne	.L429
.L428:
	movss	%xmm7, (%r9,%r15,4)
	leaq	1(%r15), %rax
	movss	%xmm6, (%rdi,%r15,4)
	cmpq	%r15, %r11
	je	.L469
	movq	%rax, %r15
	testl	%r10d, %r10d
	jg	.L470
.L441:
	movaps	%xmm9, %xmm6
	movaps	%xmm9, %xmm7
	jmp	.L428
	.p2align 4,,10
	.p2align 3
.L469:
	addl	$1, %r8d
	cmpl	20(%rsp), %r8d
	jne	.L433
.L427:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L424
	call	_ZdlPv@PLT
.L424:
	movq	40(%rsp), %rdi
	call	_ZdlPv@PLT
	movq	32(%rsp), %rdi
	call	_ZdlPv@PLT
	movq	152(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L471
	movq	48(%rsp), %rax
	addq	$168, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L439:
	.cfi_restore_state
	movq	$0, 32(%rsp)
	jmp	.L405
.L440:
	movq	$0, 40(%rsp)
	jmp	.L408
.L468:
	movaps	%xmm5, %xmm0
	movq	%rcx, 112(%rsp)
	addq	$4, %rbx
	addq	%r14, %r13
	movq	%rdx, 104(%rsp)
	addq	%r14, %r12
	addq	$4, %rbp
	movl	%r10d, 100(%rsp)
	movq	%rax, 88(%rsp)
	movq	%r9, 80(%rsp)
	movq	%rdi, 72(%rsp)
	movq	%r11, 64(%rsp)
	movl	%r8d, 96(%rsp)
	movss	%xmm7, 60(%rsp)
	movss	%xmm6, 56(%rsp)
	call	__mulsc3@PLT
	movq	88(%rsp), %rax
	movss	60(%rsp), %xmm7
	pxor	%xmm9, %xmm9
	movq	%xmm0, 120(%rsp)
	movss	56(%rsp), %xmm6
	addss	120(%rsp), %xmm7
	cmpq	%rbx, %rax
	addss	124(%rsp), %xmm6
	movl	96(%rsp), %r8d
	movq	64(%rsp), %r11
	movq	72(%rsp), %rdi
	movq	80(%rsp), %r9
	movl	100(%rsp), %r10d
	movq	104(%rsp), %rdx
	movq	112(%rsp), %rcx
	jne	.L429
	jmp	.L428
.L471:
	call	__stack_chk_fail@PLT
.L466:
.LEHB30:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE30:
.L467:
.LEHB31:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE31:
.L446:
	endbr64
	movq	%rax, %rbx
	jmp	.L417
.L447:
	endbr64
	movq	%rax, %rbx
	jmp	.L436
.L445:
	endbr64
	movq	%rax, %rbx
	jmp	.L419
	.section	.gcc_except_table
.LLSDA8713:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8713-.LLSDACSB8713
.LLSDACSB8713:
	.uleb128 .LEHB26-.LFB8713
	.uleb128 .LEHE26-.LEHB26
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB27-.LFB8713
	.uleb128 .LEHE27-.LEHB27
	.uleb128 .L447-.LFB8713
	.uleb128 0
	.uleb128 .LEHB28-.LFB8713
	.uleb128 .LEHE28-.LEHB28
	.uleb128 .L445-.LFB8713
	.uleb128 0
	.uleb128 .LEHB29-.LFB8713
	.uleb128 .LEHE29-.LEHB29
	.uleb128 .L446-.LFB8713
	.uleb128 0
	.uleb128 .LEHB30-.LFB8713
	.uleb128 .LEHE30-.LEHB30
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB31-.LFB8713
	.uleb128 .LEHE31-.LEHB31
	.uleb128 .L447-.LFB8713
	.uleb128 0
.LLSDACSE8713:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8713
	.type	_Z12denseProduct11denseMatrixS_.cold, @function
_Z12denseProduct11denseMatrixS_.cold:
.LFSB8713:
.L417:
	.cfi_def_cfa_offset 224
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	48(%rsp), %rax
	movq	24(%rax), %rdi
	testq	%rdi, %rdi
	je	.L418
	call	_ZdlPv@PLT
.L418:
	movq	48(%rsp), %rax
	movq	(%rax), %rdi
	testq	%rdi, %rdi
	je	.L419
	call	_ZdlPv@PLT
.L419:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L472
.L415:
	movq	40(%rsp), %rdi
	call	_ZdlPv@PLT
.L435:
	movq	32(%rsp), %rdi
	call	_ZdlPv@PLT
.L437:
	movq	%rbx, %rdi
.LEHB32:
	call	_Unwind_Resume@PLT
.LEHE32:
.L436:
	cmpq	$0, 32(%rsp)
	jne	.L435
	jmp	.L437
.L472:
	call	_ZdlPv@PLT
	jmp	.L415
.L461:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC23(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
.LEHB33:
	call	_ZNSt16invalid_argumentC1EPKc@PLT
.LEHE33:
	movq	_ZNSt16invalid_argumentD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt16invalid_argument(%rip), %rsi
	movq	%rbp, %rdi
.LEHB34:
	call	__cxa_throw@PLT
.LEHE34:
.L443:
	endbr64
	movq	%rbp, %rdi
	movq	%rax, %rbx
	call	__cxa_free_exception@PLT
	jmp	.L415
.L444:
	endbr64
	movq	%rax, %rbx
	jmp	.L415
	.cfi_endproc
.LFE8713:
	.section	.gcc_except_table
.LLSDAC8713:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8713-.LLSDACSBC8713
.LLSDACSBC8713:
	.uleb128 .LEHB32-.LCOLDB24
	.uleb128 .LEHE32-.LEHB32
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB33-.LCOLDB24
	.uleb128 .LEHE33-.LEHB33
	.uleb128 .L443-.LCOLDB24
	.uleb128 0
	.uleb128 .LEHB34-.LCOLDB24
	.uleb128 .LEHE34-.LEHB34
	.uleb128 .L444-.LCOLDB24
	.uleb128 0
.LLSDACSEC8713:
	.section	.text.unlikely
	.text
	.size	_Z12denseProduct11denseMatrixS_, .-_Z12denseProduct11denseMatrixS_
	.section	.text.unlikely
	.size	_Z12denseProduct11denseMatrixS_.cold, .-_Z12denseProduct11denseMatrixS_.cold
.LCOLDE24:
	.text
.LHOTE24:
	.section	.text._ZN11denseMatrixC2EPSt6vectorIiSaIiEEPf,"axG",@progbits,_ZN11denseMatrixC5EPSt6vectorIiSaIiEEPf,comdat
	.align 2
	.p2align 4
	.weak	_ZN11denseMatrixC2EPSt6vectorIiSaIiEEPf
	.type	_ZN11denseMatrixC2EPSt6vectorIiSaIiEEPf, @function
_ZN11denseMatrixC2EPSt6vectorIiSaIiEEPf:
.LFB3396:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA3396
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pxor	%xmm0, %xmm0
	movq	%rdx, %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movups	%xmm0, (%rdi)
	movups	%xmm0, 16(%rdi)
	movups	%xmm0, 32(%rdi)
.LEHB35:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	(%rbx), %rax
	movl	$4, %esi
	leaq	24(%rbx), %r12
	movl	(%rax), %edi
	imull	4(%rax), %edi
	movq	%r13, 56(%rbx)
	movl	%edi, 48(%rbx)
	movslq	%edi, %rdi
	call	calloc@PLT
	movq	%rbp, %rsi
	movq	%r12, %rdi
	movq	%rax, 64(%rbx)
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE35:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L477:
	.cfi_restore_state
	endbr64
	movq	%rax, %rbp
.L474:
	movq	24(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L475
	call	_ZdlPv@PLT
.L475:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L476
	call	_ZdlPv@PLT
.L476:
	movq	%rbp, %rdi
.LEHB36:
	call	_Unwind_Resume@PLT
.LEHE36:
	.cfi_endproc
.LFE3396:
	.section	.gcc_except_table
.LLSDA3396:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3396-.LLSDACSB3396
.LLSDACSB3396:
	.uleb128 .LEHB35-.LFB3396
	.uleb128 .LEHE35-.LEHB35
	.uleb128 .L477-.LFB3396
	.uleb128 0
	.uleb128 .LEHB36-.LFB3396
	.uleb128 .LEHE36-.LEHB36
	.uleb128 0
	.uleb128 0
.LLSDACSE3396:
	.section	.text._ZN11denseMatrixC2EPSt6vectorIiSaIiEEPf,"axG",@progbits,_ZN11denseMatrixC5EPSt6vectorIiSaIiEEPf,comdat
	.size	_ZN11denseMatrixC2EPSt6vectorIiSaIiEEPf, .-_ZN11denseMatrixC2EPSt6vectorIiSaIiEEPf
	.weak	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
	.set	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf,_ZN11denseMatrixC2EPSt6vectorIiSaIiEEPf
	.section	.text.unlikely
	.align 2
.LCOLDB25:
	.text
.LHOTB25:
	.align 2
	.p2align 4
	.globl	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE
	.type	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE, @function
_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE:
.LFB8743:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8743
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	leaq	64(%r13), %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	movq	(%rsi), %rbx
	movl	$4, %esi
	movq	%rdx, 24(%rsp)
	movl	(%rbx), %edi
	imull	4(%rbx), %edi
	movq	%fs:40, %rax
	movq	%rax, 104(%rsp)
	xorl	%eax, %eax
	movslq	%edi, %rdi
	call	calloc@PLT
	movl	(%rbx), %edi
	imull	4(%rbx), %edi
	movl	$4, %esi
	movq	%rax, 16(%rsp)
	movslq	%edi, %rdi
	call	calloc@PLT
	movq	%rax, %rbx
	movq	80(%r13), %rax
	movq	%rax, 40(%rsp)
	cmpq	%rbp, %rax
	je	.L487
	movq	%r13, %xmm3
	leaq	40(%rsp), %r15
	leaq	48(%rsp), %r14
	movhps	16(%rsp), %xmm3
	movaps	%xmm3, (%rsp)
	.p2align 4,,10
	.p2align 3
.L489:
	movq	48(%rax), %xmm0
	movq	56(%rax), %rcx
	xorl	%edx, %edx
	movl	32(%rax), %eax
	testl	%eax, %eax
	je	.L488
	jg	.L488
	negl	%eax
	movl	%eax, %edx
	xorl	%eax, %eax
.L488:
	movq	%rcx, %xmm1
	movdqa	(%rsp), %xmm2
	movl	%edx, 96(%rsp)
	xorl	%ecx, %ecx
	punpcklqdq	%xmm1, %xmm0
	movl	$16, %edx
	movq	%r14, %rsi
	movl	%eax, 100(%rsp)
	leaq	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE._omp_fn.0(%rip), %rdi
	movaps	%xmm0, 80(%rsp)
	movaps	%xmm2, 48(%rsp)
	movq	%rbx, 64(%rsp)
	movq	%r15, 72(%rsp)
	call	GOMP_parallel@PLT
	movq	40(%rsp), %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, 40(%rsp)
	cmpq	%rbp, %rax
	jne	.L489
.L487:
	pxor	%xmm0, %xmm0
	movq	%rbx, %xmm4
	movq	24(%rsp), %rbx
	movq	%r12, %rdi
	movups	%xmm0, (%r12)
	leaq	24(%r12), %rbp
	movups	%xmm0, 16(%r12)
	movq	%rbx, %rsi
	movups	%xmm0, 32(%r12)
	movq	16(%rsp), %xmm0
	punpcklqdq	%xmm4, %xmm0
	movups	%xmm0, 56(%r12)
.LEHB37:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	(%r12), %rdx
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	movl	(%rdx), %eax
	imull	4(%rdx), %eax
	movl	%eax, 48(%r12)
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE37:
	leaq	24(%r13), %rsi
	movq	%rbp, %rdi
.LEHB38:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE38:
	movq	104(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L511
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L511:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
.L498:
	endbr64
	movq	%rax, %rbp
	jmp	.L494
.L499:
	endbr64
	movq	%rax, %rbp
	jmp	.L491
	.section	.gcc_except_table
.LLSDA8743:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8743-.LLSDACSB8743
.LLSDACSB8743:
	.uleb128 .LEHB37-.LFB8743
	.uleb128 .LEHE37-.LEHB37
	.uleb128 .L499-.LFB8743
	.uleb128 0
	.uleb128 .LEHB38-.LFB8743
	.uleb128 .LEHE38-.LEHB38
	.uleb128 .L498-.LFB8743
	.uleb128 0
.LLSDACSE8743:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8743
	.type	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE.cold, @function
_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE.cold:
.LFSB8743:
.L494:
	.cfi_def_cfa_offset 176
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	%rbp, %rdi
.LEHB39:
	call	_Unwind_Resume@PLT
.L491:
	movq	24(%r12), %rdi
	testq	%rdi, %rdi
	je	.L492
	call	_ZdlPv@PLT
.L492:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L493
	call	_ZdlPv@PLT
.L493:
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE39:
	.cfi_endproc
.LFE8743:
	.section	.gcc_except_table
.LLSDAC8743:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8743-.LLSDACSBC8743
.LLSDACSBC8743:
	.uleb128 .LEHB39-.LCOLDB25
	.uleb128 .LEHE39-.LEHB39
	.uleb128 0
	.uleb128 0
.LLSDACSEC8743:
	.section	.text.unlikely
	.text
	.size	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE, .-_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE
	.section	.text.unlikely
	.size	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE.cold, .-_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE.cold
.LCOLDE25:
	.text
.LHOTE25:
	.section	.text.unlikely
.LCOLDB26:
	.text
.LHOTB26:
	.p2align 4
	.globl	_Z8to_numpy19quantumSparseMatrix
	.type	_Z8to_numpy19quantumSparseMatrix, @function
_Z8to_numpy19quantumSparseMatrix:
.LFB8746:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8746
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pxor	%xmm0, %xmm0
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$112, %rsp
	.cfi_def_cfa_offset 160
	movq	(%rsi), %rsi
	movq	%fs:40, %rax
	movq	%rax, 104(%rsp)
	xorl	%eax, %eax
	movq	8(%rbp), %rax
	movaps	%xmm0, (%rsp)
	movq	$0, 16(%rsp)
	movq	%rax, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L554
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L555
	movq	%rbx, %rdi
.LEHB40:
	call	_Znwm@PLT
.LEHE40:
	movq	0(%rbp), %rsi
	movq	%rax, %rcx
	movq	8(%rbp), %rax
	movq	%rax, %r13
	subq	%rsi, %r13
.L514:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 16(%rsp)
	movaps	%xmm0, (%rsp)
	cmpq	%rsi, %rax
	je	.L516
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L516:
	leaq	32(%rsp), %r14
	addq	%r13, %rcx
	movq	%rsp, %rdx
	movq	%rbp, %rsi
	movq	%r14, %rdi
	movq	%rcx, 8(%rsp)
.LEHB41:
	call	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE
.LEHE41:
	movq	(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L517
	call	_ZdlPv@PLT
.L517:
	movabsq	$1152921504606846975, %rdx
	movslq	80(%rsp), %rax
	cmpq	%rdx, %rax
	ja	.L556
	pxor	%xmm0, %xmm0
	leaq	0(,%rax,8), %r13
	movq	$0, 16(%r12)
	movups	%xmm0, (%r12)
	testq	%rax, %rax
	je	.L519
	movq	%r13, %rdi
.LEHB42:
	call	_Znwm@PLT
	leaq	(%rax,%r13), %rbp
	movq	%rax, (%r12)
	movl	80(%rsp), %ebx
	movq	%r13, %rdx
	movq	%rbp, 16(%r12)
	xorl	%esi, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movq	%rbp, 8(%r12)
	movq	%rax, %rcx
	testl	%ebx, %ebx
	jle	.L526
	movslq	%ebx, %rdi
	movq	88(%rsp), %rdx
	movq	96(%rsp), %rsi
	leal	-1(%rbx), %r8d
	leaq	0(,%rdi,4), %rax
	leaq	(%rcx,%rdi,8), %r9
	leaq	(%rdx,%rax), %rdi
	cmpq	%rdi, %rcx
	setnb	%dil
	cmpq	%r9, %rdx
	setnb	%r10b
	addq	%rsi, %rax
	orl	%r10d, %edi
	cmpq	%rax, %rcx
	setnb	%al
	cmpq	%r9, %rsi
	setnb	%r9b
	orl	%r9d, %eax
	testb	%al, %dil
	je	.L523
	cmpl	$2, %r8d
	jbe	.L523
	movl	%ebx, %edi
	xorl	%eax, %eax
	shrl	$2, %edi
	salq	$4, %rdi
	.p2align 4,,10
	.p2align 3
.L525:
	movups	(%rdx,%rax), %xmm0
	movups	(%rsi,%rax), %xmm1
	movaps	%xmm0, %xmm2
	unpckhps	%xmm1, %xmm0
	unpcklps	%xmm1, %xmm2
	movups	%xmm0, 16(%rcx,%rax,2)
	movups	%xmm2, (%rcx,%rax,2)
	addq	$16, %rax
	cmpq	%rax, %rdi
	jne	.L525
	movl	%ebx, %eax
	andl	$-4, %eax
	testb	$3, %bl
	je	.L526
	movl	%eax, %edi
	movss	(%rdx,%rdi,4), %xmm1
	movss	(%rsi,%rdi,4), %xmm0
	leaq	(%rcx,%rdi,8), %rdi
	movss	%xmm1, (%rdi)
	movss	%xmm0, 4(%rdi)
	leal	1(%rax), %edi
	cmpl	%ebx, %edi
	jge	.L526
	movslq	%edi, %rdi
	addl	$2, %eax
	movss	(%rdx,%rdi,4), %xmm1
	movss	(%rsi,%rdi,4), %xmm0
	leaq	(%rcx,%rdi,8), %rdi
	movss	%xmm1, (%rdi)
	movss	%xmm0, 4(%rdi)
	cmpl	%eax, %ebx
	jle	.L526
	cltq
	movss	(%rdx,%rax,4), %xmm1
	movss	(%rsi,%rax,4), %xmm0
	leaq	(%rcx,%rax,8), %rax
	movss	%xmm1, (%rax)
	movss	%xmm0, 4(%rax)
.L526:
	movq	56(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L522
	call	_ZdlPv@PLT
.L522:
	movq	32(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L512
	call	_ZdlPv@PLT
.L512:
	movq	104(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L557
	addq	$112, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L554:
	.cfi_restore_state
	movq	%rbx, %r13
	xorl	%ecx, %ecx
	jmp	.L514
	.p2align 4,,10
	.p2align 3
.L523:
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L529:
	movss	(%rdx,%rax,4), %xmm1
	movss	(%rsi,%rax,4), %xmm0
	movq	%rax, %rdi
	movss	%xmm1, (%rcx,%rax,8)
	movss	%xmm0, 4(%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rdi, %r8
	jne	.L529
	jmp	.L526
	.p2align 4,,10
	.p2align 3
.L519:
	movq	$0, 8(%r12)
	jmp	.L526
.L556:
	leaq	.LC2(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE42:
.L557:
	call	__stack_chk_fail@PLT
.L555:
.LEHB43:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE43:
.L536:
	endbr64
	movq	%rax, %rbp
	jmp	.L533
.L535:
	endbr64
	movq	%rax, %rbp
	jmp	.L531
	.section	.gcc_except_table
.LLSDA8746:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8746-.LLSDACSB8746
.LLSDACSB8746:
	.uleb128 .LEHB40-.LFB8746
	.uleb128 .LEHE40-.LEHB40
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB41-.LFB8746
	.uleb128 .LEHE41-.LEHB41
	.uleb128 .L535-.LFB8746
	.uleb128 0
	.uleb128 .LEHB42-.LFB8746
	.uleb128 .LEHE42-.LEHB42
	.uleb128 .L536-.LFB8746
	.uleb128 0
	.uleb128 .LEHB43-.LFB8746
	.uleb128 .LEHE43-.LEHB43
	.uleb128 0
	.uleb128 0
.LLSDACSE8746:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8746
	.type	_Z8to_numpy19quantumSparseMatrix.cold, @function
_Z8to_numpy19quantumSparseMatrix.cold:
.LFSB8746:
.L533:
	.cfi_def_cfa_offset 160
	.cfi_offset 3, -48
	.cfi_offset 6, -40
	.cfi_offset 12, -32
	.cfi_offset 13, -24
	.cfi_offset 14, -16
	movq	%r14, %rdi
	call	_ZN11denseMatrixD1Ev
.L553:
	movq	%rbp, %rdi
.LEHB44:
	call	_Unwind_Resume@PLT
.LEHE44:
.L531:
	movq	(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L553
	call	_ZdlPv@PLT
	jmp	.L553
	.cfi_endproc
.LFE8746:
	.section	.gcc_except_table
.LLSDAC8746:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8746-.LLSDACSBC8746
.LLSDACSBC8746:
	.uleb128 .LEHB44-.LCOLDB26
	.uleb128 .LEHE44-.LEHB44
	.uleb128 0
	.uleb128 0
.LLSDACSEC8746:
	.section	.text.unlikely
	.text
	.size	_Z8to_numpy19quantumSparseMatrix, .-_Z8to_numpy19quantumSparseMatrix
	.section	.text.unlikely
	.size	_Z8to_numpy19quantumSparseMatrix.cold, .-_Z8to_numpy19quantumSparseMatrix.cold
.LCOLDE26:
	.text
.LHOTE26:
	.section	.text._ZNSt6vectorIiSaIiEEC2ERKS1_,"axG",@progbits,_ZNSt6vectorIiSaIiEEC5ERKS1_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIiSaIiEEC2ERKS1_
	.type	_ZNSt6vectorIiSaIiEEC2ERKS1_, @function
_ZNSt6vectorIiSaIiEEC2ERKS1_:
.LFB9023:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pxor	%xmm0, %xmm0
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	8(%rsi), %rbx
	subq	(%rsi), %rbx
	movq	$0, 16(%rdi)
	movq	%rbx, %rax
	movups	%xmm0, (%rdi)
	sarq	$2, %rax
	je	.L565
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L566
	movq	%rbx, %rdi
	call	_Znwm@PLT
	movq	%rax, %rcx
.L560:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 16(%rbp)
	movups	%xmm0, 0(%rbp)
	movq	8(%r12), %rax
	movq	(%r12), %rsi
	movq	%rax, %rbx
	subq	%rsi, %rbx
	cmpq	%rsi, %rax
	je	.L563
	movq	%rcx, %rdi
	movq	%rbx, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L563:
	addq	%rbx, %rcx
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rcx, 8(%rbp)
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L565:
	.cfi_restore_state
	xorl	%ecx, %ecx
	jmp	.L560
.L566:
	call	_ZSt17__throw_bad_allocv@PLT
	.cfi_endproc
.LFE9023:
	.size	_ZNSt6vectorIiSaIiEEC2ERKS1_, .-_ZNSt6vectorIiSaIiEEC2ERKS1_
	.weak	_ZNSt6vectorIiSaIiEEC1ERKS1_
	.set	_ZNSt6vectorIiSaIiEEC1ERKS1_,_ZNSt6vectorIiSaIiEEC2ERKS1_
	.section	.text._ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED2Ev,"axG",@progbits,_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED5Ev,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED2Ev
	.type	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED2Ev, @function
_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED2Ev:
.LFB9116:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movq	%rdi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	8(%rdi), %r13
	movq	(%rdi), %r12
	cmpq	%r12, %r13
	je	.L568
	.p2align 4,,10
	.p2align 3
.L578:
	movq	8(%r12), %rbx
	movq	(%r12), %rbp
	cmpq	%rbp, %rbx
	je	.L569
	.p2align 4,,10
	.p2align 3
.L574:
	movq	24(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L570
	call	_ZdlPv@PLT
.L570:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L571
	call	_ZdlPv@PLT
	addq	$72, %rbp
	cmpq	%rbx, %rbp
	jne	.L574
.L572:
	movq	(%r12), %rbp
.L569:
	testq	%rbp, %rbp
	je	.L575
	movq	%rbp, %rdi
	addq	$24, %r12
	call	_ZdlPv@PLT
	cmpq	%r12, %r13
	jne	.L578
.L576:
	movq	(%r14), %r12
.L568:
	testq	%r12, %r12
	je	.L567
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movq	%r12, %rdi
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	jmp	_ZdlPv@PLT
	.p2align 4,,10
	.p2align 3
.L571:
	.cfi_restore_state
	addq	$72, %rbp
	cmpq	%rbp, %rbx
	jne	.L574
	jmp	.L572
	.p2align 4,,10
	.p2align 3
.L575:
	addq	$24, %r12
	cmpq	%r12, %r13
	jne	.L578
	jmp	.L576
	.p2align 4,,10
	.p2align 3
.L567:
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE9116:
	.size	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED2Ev, .-_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED2Ev
	.weak	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED1Ev
	.set	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED1Ev,_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED2Ev
	.section	.text._ZNSt6vectorI11denseMatrixSaIS0_EED2Ev,"axG",@progbits,_ZNSt6vectorI11denseMatrixSaIS0_EED5Ev,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorI11denseMatrixSaIS0_EED2Ev
	.type	_ZNSt6vectorI11denseMatrixSaIS0_EED2Ev, @function
_ZNSt6vectorI11denseMatrixSaIS0_EED2Ev:
.LFB9128:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	8(%rdi), %rbx
	movq	(%rdi), %rbp
	cmpq	%rbp, %rbx
	je	.L585
	.p2align 4,,10
	.p2align 3
.L590:
	movq	24(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L586
	call	_ZdlPv@PLT
.L586:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L587
	call	_ZdlPv@PLT
	addq	$72, %rbp
	cmpq	%rbp, %rbx
	jne	.L590
.L588:
	movq	(%r12), %rbp
.L585:
	testq	%rbp, %rbp
	je	.L584
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbp, %rdi
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	_ZdlPv@PLT
	.p2align 4,,10
	.p2align 3
.L587:
	.cfi_restore_state
	addq	$72, %rbp
	cmpq	%rbp, %rbx
	jne	.L590
	jmp	.L588
	.p2align 4,,10
	.p2align 3
.L584:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE9128:
	.size	_ZNSt6vectorI11denseMatrixSaIS0_EED2Ev, .-_ZNSt6vectorI11denseMatrixSaIS0_EED2Ev
	.weak	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	.set	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev,_ZNSt6vectorI11denseMatrixSaIS0_EED2Ev
	.section	.text._ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E,"axG",@progbits,_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	.type	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E, @function
_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E:
.LFB9216:
	.cfi_startproc
	endbr64
	testq	%rsi, %rsi
	je	.L604
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rsi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
.L598:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L598
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L604:
	.cfi_restore 3
	.cfi_restore 6
	ret
	.cfi_endproc
.LFE9216:
	.size	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E, .-_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	.section	.text._ZN19quantumSparseMatrixD2Ev,"axG",@progbits,_ZN19quantumSparseMatrixD5Ev,comdat
	.align 2
	.p2align 4
	.weak	_ZN19quantumSparseMatrixD2Ev
	.type	_ZN19quantumSparseMatrixD2Ev, @function
_ZN19quantumSparseMatrixD2Ev:
.LFB8711:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	72(%rdi), %rbp
	movq	%rdi, %rbx
	testq	%rbp, %rbp
	je	.L608
	leaq	56(%rdi), %r12
.L609:
	movq	24(%rbp), %rsi
	movq	%r12, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
	movq	16(%rbp), %rbp
	call	_ZdlPv@PLT
	testq	%rbp, %rbp
	jne	.L609
.L608:
	movq	24(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L610
	call	_ZdlPv@PLT
.L610:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L607
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	_ZdlPv@PLT
	.p2align 4,,10
	.p2align 3
.L607:
	.cfi_restore_state
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE8711:
	.size	_ZN19quantumSparseMatrixD2Ev, .-_ZN19quantumSparseMatrixD2Ev
	.weak	_ZN19quantumSparseMatrixD1Ev
	.set	_ZN19quantumSparseMatrixD1Ev,_ZN19quantumSparseMatrixD2Ev
	.section	.rodata._ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_.str1.1,"aMS",@progbits,1
.LC27:
	.string	"vector::_M_realloc_insert"
	.section	.text._ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_,"axG",@progbits,_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	.type	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_, @function
_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_:
.LFB9235:
	.cfi_startproc
	endbr64
	movabsq	$2305843009213693951, %rcx
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	8(%rdi), %r12
	movq	(%rdi), %r8
	movq	%r12, %rax
	subq	%r8, %rax
	sarq	$2, %rax
	cmpq	%rcx, %rax
	je	.L634
	movq	%rdx, %r15
	movq	%rsi, %rdx
	movq	%rdi, %rbp
	movq	%rsi, %r13
	subq	%r8, %rdx
	testq	%rax, %rax
	je	.L630
	movabsq	$9223372036854775804, %r14
	leaq	(%rax,%rax), %rsi
	cmpq	%rsi, %rax
	jbe	.L635
.L622:
	movq	%r14, %rdi
	movq	%rdx, 8(%rsp)
	movq	%r8, (%rsp)
	call	_Znwm@PLT
	movq	(%rsp), %r8
	movq	8(%rsp), %rdx
	movq	%rax, %rbx
	addq	%rax, %r14
.L629:
	movl	(%r15), %eax
	subq	%r13, %r12
	leaq	4(%rbx,%rdx), %r15
	movl	%eax, (%rbx,%rdx)
	leaq	(%r15,%r12), %rax
	movq	%rax, (%rsp)
	testq	%rdx, %rdx
	jg	.L636
	testq	%r12, %r12
	jg	.L625
	testq	%r8, %r8
	jne	.L628
.L626:
	movq	%rbx, %xmm0
	movq	%r14, 16(%rbp)
	movhps	(%rsp), %xmm0
	movups	%xmm0, 0(%rbp)
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L636:
	.cfi_restore_state
	movq	%r8, %rsi
	movq	%rbx, %rdi
	movq	%r8, 8(%rsp)
	call	memmove@PLT
	testq	%r12, %r12
	movq	8(%rsp), %r8
	jg	.L625
.L628:
	movq	%r8, %rdi
	call	_ZdlPv@PLT
	jmp	.L626
	.p2align 4,,10
	.p2align 3
.L635:
	testq	%rsi, %rsi
	jne	.L623
	xorl	%r14d, %r14d
	xorl	%ebx, %ebx
	jmp	.L629
	.p2align 4,,10
	.p2align 3
.L625:
	movq	%r12, %rdx
	movq	%r13, %rsi
	movq	%r15, %rdi
	movq	%r8, 8(%rsp)
	call	memcpy@PLT
	movq	8(%rsp), %r8
	testq	%r8, %r8
	je	.L626
	jmp	.L628
	.p2align 4,,10
	.p2align 3
.L630:
	movl	$4, %r14d
	jmp	.L622
.L634:
	leaq	.LC27(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.L623:
	cmpq	%rcx, %rsi
	cmovbe	%rsi, %rcx
	movq	%rcx, %r14
	salq	$2, %r14
	jmp	.L622
	.cfi_endproc
.LFE9235:
	.size	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_, .-_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	.section	.text.unlikely
.LCOLDB28:
	.text
.LHOTB28:
	.p2align 4
	.globl	_Z17modifyTensorShapeSt6vectorIiSaIiEES1_
	.type	_Z17modifyTensorShapeSt6vectorIiSaIiEES1_, @function
_Z17modifyTensorShapeSt6vectorIiSaIiEES1_:
.LFB8728:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8728
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pxor	%xmm0, %xmm0
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rdx, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	$0, 16(%rdi)
	movups	%xmm0, (%rdi)
	movq	(%rdx), %rdx
	cmpq	8(%rbp), %rdx
	je	.L656
	xorl	%ebx, %ebx
	xorl	%eax, %eax
	xorl	%esi, %esi
	jmp	.L638
	.p2align 4,,10
	.p2align 3
.L657:
	movl	(%r8), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
.L644:
	movq	8(%rbp), %rax
	addq	$1, %rbx
	subq	%rdx, %rax
	sarq	$2, %rax
	cmpq	%rbx, %rax
	jbe	.L637
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
.L638:
	movslq	(%rdx,%rbx,4), %rdi
	movq	0(%r13), %rcx
	leaq	(%rcx,%rdi,4), %r8
	cmpq	%rax, %rsi
	jne	.L657
	movq	%r8, %rdx
	movq	%r12, %rdi
.LEHB45:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	0(%rbp), %rdx
	jmp	.L644
	.p2align 4,,10
	.p2align 3
.L637:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L656:
	.cfi_restore_state
	movq	(%rsi), %rdx
	movq	8(%rsi), %rbx
	subq	%rdx, %rbx
	sarq	$2, %rbx
	subl	$1, %ebx
	js	.L637
	movslq	%ebx, %rbp
	xorl	%eax, %eax
	xorl	%esi, %esi
	salq	$2, %rbp
	jmp	.L642
	.p2align 4,,10
	.p2align 3
.L658:
	movl	(%rdx), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
.L641:
	subl	$1, %ebx
	subq	$4, %rbp
	cmpl	$-1, %ebx
	je	.L637
	movq	0(%r13), %rdx
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
.L642:
	addq	%rbp, %rdx
	cmpq	%rax, %rsi
	jne	.L658
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE45:
	jmp	.L641
.L648:
	endbr64
	movq	%rax, %rbp
	jmp	.L645
	.section	.gcc_except_table
.LLSDA8728:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8728-.LLSDACSB8728
.LLSDACSB8728:
	.uleb128 .LEHB45-.LFB8728
	.uleb128 .LEHE45-.LEHB45
	.uleb128 .L648-.LFB8728
	.uleb128 0
.LLSDACSE8728:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8728
	.type	_Z17modifyTensorShapeSt6vectorIiSaIiEES1_.cold, @function
_Z17modifyTensorShapeSt6vectorIiSaIiEES1_.cold:
.LFSB8728:
.L645:
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -40
	.cfi_offset 6, -32
	.cfi_offset 12, -24
	.cfi_offset 13, -16
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L646
	call	_ZdlPv@PLT
.L646:
	movq	%rbp, %rdi
.LEHB46:
	call	_Unwind_Resume@PLT
.LEHE46:
	.cfi_endproc
.LFE8728:
	.section	.gcc_except_table
.LLSDAC8728:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8728-.LLSDACSBC8728
.LLSDACSBC8728:
	.uleb128 .LEHB46-.LCOLDB28
	.uleb128 .LEHE46-.LEHB46
	.uleb128 0
	.uleb128 0
.LLSDACSEC8728:
	.section	.text.unlikely
	.text
	.size	_Z17modifyTensorShapeSt6vectorIiSaIiEES1_, .-_Z17modifyTensorShapeSt6vectorIiSaIiEES1_
	.section	.text.unlikely
	.size	_Z17modifyTensorShapeSt6vectorIiSaIiEES1_.cold, .-_Z17modifyTensorShapeSt6vectorIiSaIiEES1_.cold
.LCOLDE28:
	.text
.LHOTE28:
	.section	.text.unlikely
.LCOLDB29:
	.text
.LHOTB29:
	.p2align 4
	.globl	_Z14newTensorShapeSt6vectorIiSaIiEES1_S1_S1_
	.type	_Z14newTensorShapeSt6vectorIiSaIiEES1_S1_S1_, @function
_Z14newTensorShapeSt6vectorIiSaIiEES1_S1_S1_:
.LFB8727:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8727
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pxor	%xmm0, %xmm0
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rdx, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%r8, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movq	$0, 16(%rdi)
	movups	%xmm0, (%rdi)
	movq	(%rsi), %rdi
	movq	8(%rsi), %r8
	cmpq	%rdi, %r8
	je	.L660
	movq	%rsi, %r15
	movq	%rcx, %r13
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L665:
	movq	0(%r13), %rcx
	movq	8(%r13), %rdx
	xorl	%eax, %eax
	subq	%rcx, %rdx
	sarq	$2, %rdx
	jne	.L661
	jmp	.L662
	.p2align 4,,10
	.p2align 3
.L694:
	addq	$1, %rax
	cmpq	%rax, %rdx
	je	.L662
.L661:
	cmpl	%ebx, (%rcx,%rax,4)
	jne	.L694
.L664:
	movq	%r8, %rax
	addq	$1, %rbx
	subq	%rdi, %rax
	sarq	$2, %rax
	cmpq	%rbx, %rax
	ja	.L665
.L660:
	movq	(%r14), %rdi
	movq	8(%r14), %r8
	xorl	%ebx, %ebx
	cmpq	%rdi, %r8
	je	.L659
	.p2align 4,,10
	.p2align 3
.L663:
	movq	0(%rbp), %rcx
	movq	8(%rbp), %rdx
	subq	%rcx, %rdx
	sarq	$2, %rdx
	je	.L666
	xorl	%eax, %eax
	jmp	.L668
	.p2align 4,,10
	.p2align 3
.L695:
	addq	$1, %rax
	cmpq	%rdx, %rax
	je	.L666
.L668:
	cmpl	%ebx, (%rcx,%rax,4)
	jne	.L695
.L667:
	movq	%r8, %rax
	addq	$1, %rbx
	subq	%rdi, %rax
	sarq	$2, %rax
	cmpq	%rbx, %rax
	ja	.L663
.L659:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L662:
	.cfi_restore_state
	movq	8(%r12), %rsi
	leaq	(%rdi,%rbx,4), %rdx
	cmpq	16(%r12), %rsi
	je	.L696
	movl	(%rdx), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
	jmp	.L664
	.p2align 4,,10
	.p2align 3
.L666:
	movq	8(%r12), %rsi
	leaq	(%rdi,%rbx,4), %rdx
	cmpq	16(%r12), %rsi
	je	.L697
	movl	(%rdx), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
	jmp	.L667
.L696:
	movq	%r12, %rdi
.LEHB47:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	(%r15), %rdi
	movq	8(%r15), %r8
	jmp	.L664
.L697:
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE47:
	movq	(%r14), %rdi
	movq	8(%r14), %r8
	jmp	.L667
.L678:
	endbr64
	movq	%rax, %rbp
	jmp	.L670
	.section	.gcc_except_table
.LLSDA8727:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8727-.LLSDACSB8727
.LLSDACSB8727:
	.uleb128 .LEHB47-.LFB8727
	.uleb128 .LEHE47-.LEHB47
	.uleb128 .L678-.LFB8727
	.uleb128 0
.LLSDACSE8727:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8727
	.type	_Z14newTensorShapeSt6vectorIiSaIiEES1_S1_S1_.cold, @function
_Z14newTensorShapeSt6vectorIiSaIiEES1_S1_S1_.cold:
.LFSB8727:
.L670:
	.cfi_def_cfa_offset 64
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L671
	call	_ZdlPv@PLT
.L671:
	movq	%rbp, %rdi
.LEHB48:
	call	_Unwind_Resume@PLT
.LEHE48:
	.cfi_endproc
.LFE8727:
	.section	.gcc_except_table
.LLSDAC8727:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8727-.LLSDACSBC8727
.LLSDACSBC8727:
	.uleb128 .LEHB48-.LCOLDB29
	.uleb128 .LEHE48-.LEHB48
	.uleb128 0
	.uleb128 0
.LLSDACSEC8727:
	.section	.text.unlikely
	.text
	.size	_Z14newTensorShapeSt6vectorIiSaIiEES1_S1_S1_, .-_Z14newTensorShapeSt6vectorIiSaIiEES1_S1_S1_
	.section	.text.unlikely
	.size	_Z14newTensorShapeSt6vectorIiSaIiEES1_S1_S1_.cold, .-_Z14newTensorShapeSt6vectorIiSaIiEES1_S1_S1_.cold
.LCOLDE29:
	.text
.LHOTE29:
	.section	.text._ZN19quantumSparseMatrix11pruneMatrixEv,"axG",@progbits,_ZN19quantumSparseMatrix11pruneMatrixEv,comdat
	.align 2
	.p2align 4
	.weak	_ZN19quantumSparseMatrix11pruneMatrixEv
	.type	_ZN19quantumSparseMatrix11pruneMatrixEv, @function
_ZN19quantumSparseMatrix11pruneMatrixEv:
.LFB3388:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA3388
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pxor	%xmm0, %xmm0
	xorl	%r15d, %r15d
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	leaq	64(%rdi), %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	movq	80(%rdi), %r13
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	movaps	%xmm0, 32(%rsp)
	movq	$0, 48(%rsp)
	cmpq	%r12, %r13
	je	.L698
	.p2align 4,,10
	.p2align 3
.L699:
	movl	44(%r13), %r8d
	movq	48(%r13), %rcx
	movq	56(%r13), %rsi
	testl	%r8d, %r8d
	jle	.L735
	leal	-1(%r8), %edx
	movl	$1, %eax
	addq	$2, %rdx
	jmp	.L707
	.p2align 4,,10
	.p2align 3
.L775:
	jne	.L704
	ucomiss	-4(%rsi,%rax,4), %xmm1
	jp	.L704
	jne	.L704
	movl	%eax, %edi
	addq	$1, %rax
	cmpq	%rax, %rdx
	je	.L703
.L707:
	pxor	%xmm1, %xmm1
	ucomiss	-4(%rcx,%rax,4), %xmm1
	jnp	.L775
.L704:
	movq	%r13, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %r13
	cmpq	%r12, %rax
	jne	.L699
.L781:
	movq	32(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.L776
	leaq	56(%rbp), %rax
	xorl	%r13d, %r13d
	movq	%rax, 16(%rsp)
	.p2align 4,,10
	.p2align 3
.L730:
	movq	72(%rbp), %r8
	leaq	(%rdi,%r13,4), %rax
	testq	%r8, %r8
	je	.L710
	movl	(%rax), %edx
	movq	%r12, %r14
	movq	%r8, %rbx
	jmp	.L711
	.p2align 4,,10
	.p2align 3
.L778:
	movq	24(%rbx), %rbx
	testq	%rbx, %rbx
	je	.L777
.L711:
	cmpl	%edx, 32(%rbx)
	jl	.L778
	movq	16(%rbx), %rax
	jle	.L779
	movq	%rbx, %r14
	movq	%rax, %rbx
	testq	%rbx, %rbx
	jne	.L711
.L777:
	cmpq	%r14, 80(%rbp)
	jne	.L728
	cmpq	%r12, %r14
	je	.L726
	.p2align 4,,10
	.p2align 3
.L728:
	movq	%r15, %rax
	addq	$1, %r13
	subq	%rdi, %rax
	sarq	$2, %rax
	cmpq	%r13, %rax
	ja	.L730
.L702:
	testq	%rdi, %rdi
	je	.L698
	call	_ZdlPv@PLT
.L698:
	movq	56(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L780
	addq	$72, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L726:
	.cfi_restore_state
	movq	24(%r8), %rsi
	movq	16(%rsp), %rdi
	movq	%r8, 8(%rsp)
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	8(%rsp), %r8
	movq	%r8, %rdi
	movq	16(%r8), %r8
	movq	%r8, 8(%rsp)
	movq	%r8, 24(%rsp)
	call	_ZdlPv@PLT
	movq	8(%rsp), %r8
	testq	%r8, %r8
	jne	.L726
	movq	32(%rsp), %rdi
	movq	40(%rsp), %r15
.L727:
	movq	$0, 72(%rbp)
	movq	%r12, 80(%rbp)
	movq	%r12, 88(%rbp)
	movq	$0, 96(%rbp)
	jmp	.L728
.L735:
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L703:
	cmpl	%r8d, %edi
	jne	.L704
	cmpq	%r15, 48(%rsp)
	je	.L708
	movl	32(%r13), %eax
	movq	%r13, %rdi
	addq	$4, %r15
	movl	%eax, -4(%r15)
	movq	%r15, 40(%rsp)
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %r13
	cmpq	%r12, %rax
	jne	.L699
	jmp	.L781
	.p2align 4,,10
	.p2align 3
.L779:
	movq	24(%rbx), %rsi
	testq	%rsi, %rsi
	jne	.L718
	jmp	.L724
	.p2align 4,,10
	.p2align 3
.L782:
	movq	%rsi, %r14
	movq	16(%rsi), %rsi
	testq	%rsi, %rsi
	je	.L724
.L718:
	cmpl	32(%rsi), %edx
	jl	.L782
	movq	24(%rsi), %rsi
	testq	%rsi, %rsi
	jne	.L718
	.p2align 4,,10
	.p2align 3
.L724:
	testq	%rax, %rax
	je	.L719
.L783:
	cmpl	32(%rax), %edx
	jg	.L723
	movq	%rax, %rbx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L783
.L719:
	cmpq	%rbx, 80(%rbp)
	jne	.L725
	cmpq	%r12, %r14
	je	.L726
.L725:
	cmpq	%r14, %rbx
	je	.L728
	.p2align 4,,10
	.p2align 3
.L729:
	movq	%rbx, %rdi
	movq	%rbx, %r15
	call	_ZSt18_Rb_tree_incrementPKSt18_Rb_tree_node_base@PLT
	movq	%r12, %rsi
	movq	%r15, %rdi
	movq	%rax, %rbx
	call	_ZSt28_Rb_tree_rebalance_for_erasePSt18_Rb_tree_node_baseRS_@PLT
	movq	%rax, %rdi
	call	_ZdlPv@PLT
	subq	$1, 96(%rbp)
	cmpq	%r14, %rbx
	jne	.L729
	movq	32(%rsp), %rdi
	movq	40(%rsp), %r15
	jmp	.L728
	.p2align 4,,10
	.p2align 3
.L723:
	movq	24(%rax), %rax
	jmp	.L724
.L710:
	cmpq	%r12, 80(%rbp)
	jne	.L728
	jmp	.L727
.L708:
	leaq	32(%r13), %rdx
	leaq	32(%rsp), %rdi
	movq	%r15, %rsi
.LEHB49:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE49:
	movq	%r13, %rdi
	movq	40(%rsp), %r15
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %r13
	cmpq	%r12, %rax
	jne	.L699
	jmp	.L781
.L776:
	movq	%r15, %rdi
	jmp	.L702
.L780:
	call	__stack_chk_fail@PLT
.L737:
	endbr64
	movq	%rax, %rbp
.L731:
	movq	32(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L732
	call	_ZdlPv@PLT
.L732:
	movq	%rbp, %rdi
.LEHB50:
	call	_Unwind_Resume@PLT
.LEHE50:
	.cfi_endproc
.LFE3388:
	.section	.gcc_except_table
.LLSDA3388:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3388-.LLSDACSB3388
.LLSDACSB3388:
	.uleb128 .LEHB49-.LFB3388
	.uleb128 .LEHE49-.LEHB49
	.uleb128 .L737-.LFB3388
	.uleb128 0
	.uleb128 .LEHB50-.LFB3388
	.uleb128 .LEHE50-.LEHB50
	.uleb128 0
	.uleb128 0
.LLSDACSE3388:
	.section	.text._ZN19quantumSparseMatrix11pruneMatrixEv,"axG",@progbits,_ZN19quantumSparseMatrix11pruneMatrixEv,comdat
	.size	_ZN19quantumSparseMatrix11pruneMatrixEv, .-_ZN19quantumSparseMatrix11pruneMatrixEv
	.section	.text._ZN11denseMatrixC2EiPf,"axG",@progbits,_ZN11denseMatrixC5EiPf,comdat
	.align 2
	.p2align 4
	.weak	_ZN11denseMatrixC2EiPf
	.type	_ZN11denseMatrixC2EiPf, @function
_ZN11denseMatrixC2EiPf:
.LFB3390:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA3390
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pxor	%xmm0, %xmm0
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rdi, %rbx
	movl	%esi, %edi
	imull	%esi, %edi
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdx, 56(%rbx)
	movl	%edi, 48(%rbx)
	movslq	%edi, %rdi
	leaq	12(%rsp), %r12
	movl	%esi, 12(%rsp)
	movl	$4, %esi
	movups	%xmm0, (%rbx)
	movups	%xmm0, 16(%rbx)
	movups	%xmm0, 32(%rbx)
	call	calloc@PLT
	movq	%r12, %rdx
	xorl	%esi, %esi
	movq	%rbx, %rdi
	movq	%rax, 64(%rbx)
.LEHB51:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%rbx), %rsi
	leaq	24(%rbx), %rbp
	cmpq	16(%rbx), %rsi
	je	.L785
	movl	12(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	40(%rbx), %rax
	movq	%rsi, 8(%rbx)
	movq	32(%rbx), %rsi
	cmpq	%rax, %rsi
	je	.L787
.L802:
	movl	12(%rsp), %edx
	addq	$4, %rsi
	movl	%edx, -4(%rsi)
	movq	%rsi, 32(%rbx)
	cmpq	%rax, %rsi
	je	.L789
.L803:
	movl	12(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 32(%rbx)
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L785:
	.cfi_restore_state
	movq	%r12, %rdx
	movq	%rbx, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%rbx), %rsi
	movq	40(%rbx), %rax
	cmpq	%rax, %rsi
	jne	.L802
	.p2align 4,,10
	.p2align 3
.L787:
	movq	%r12, %rdx
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%rbx), %rsi
	movq	40(%rbx), %rax
	cmpq	%rax, %rsi
	jne	.L803
	.p2align 4,,10
	.p2align 3
.L789:
	movq	%r12, %rdx
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE51:
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L794:
	.cfi_restore_state
	endbr64
	movq	%rax, %rbp
.L791:
	movq	24(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L792
	call	_ZdlPv@PLT
.L792:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L793
	call	_ZdlPv@PLT
.L793:
	movq	%rbp, %rdi
.LEHB52:
	call	_Unwind_Resume@PLT
.LEHE52:
	.cfi_endproc
.LFE3390:
	.section	.gcc_except_table
.LLSDA3390:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3390-.LLSDACSB3390
.LLSDACSB3390:
	.uleb128 .LEHB51-.LFB3390
	.uleb128 .LEHE51-.LEHB51
	.uleb128 .L794-.LFB3390
	.uleb128 0
	.uleb128 .LEHB52-.LFB3390
	.uleb128 .LEHE52-.LEHB52
	.uleb128 0
	.uleb128 0
.LLSDACSE3390:
	.section	.text._ZN11denseMatrixC2EiPf,"axG",@progbits,_ZN11denseMatrixC5EiPf,comdat
	.size	_ZN11denseMatrixC2EiPf, .-_ZN11denseMatrixC2EiPf
	.weak	_ZN11denseMatrixC1EiPf
	.set	_ZN11denseMatrixC1EiPf,_ZN11denseMatrixC2EiPf
	.section	.text._ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_,"axG",@progbits,_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	.type	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_, @function
_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_:
.LFB9254:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	leaq	8(%rdi), %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movq	16(%rdi), %r12
	testq	%r12, %r12
	je	.L805
	movl	(%rsi), %ebp
	jmp	.L806
	.p2align 4,,10
	.p2align 3
.L822:
	movq	16(%r12), %rax
	movl	$1, %edx
	testq	%rax, %rax
	je	.L807
.L823:
	movq	%rax, %r12
.L806:
	movl	32(%r12), %ecx
	cmpl	%ecx, %ebp
	jl	.L822
	movq	24(%r12), %rax
	xorl	%edx, %edx
	testq	%rax, %rax
	jne	.L823
.L807:
	testb	%dl, %dl
	jne	.L824
	cmpl	%ecx, %ebp
	jle	.L815
.L814:
	movl	$1, %r15d
	cmpq	%r12, %r14
	jne	.L825
.L812:
	movl	$64, %edi
	call	_Znwm@PLT
	movq	%r12, %rdx
	movq	%r14, %rcx
	movl	%r15d, %edi
	movdqu	0(%r13), %xmm0
	movdqu	16(%r13), %xmm1
	movq	%rax, %rsi
	movq	%rax, %rbp
	movups	%xmm0, 32(%rax)
	movups	%xmm1, 48(%rax)
	call	_ZSt29_Rb_tree_insert_and_rebalancebPSt18_Rb_tree_node_baseS0_RS_@PLT
	addq	$1, 40(%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%rbp, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	movl	$1, %edx
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L824:
	.cfi_restore_state
	cmpq	24(%rbx), %r12
	je	.L814
.L816:
	movq	%r12, %rdi
	call	_ZSt18_Rb_tree_decrementPSt18_Rb_tree_node_base@PLT
	cmpl	32(%rax), %ebp
	jg	.L814
	movq	%rax, %r12
.L815:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	xorl	%edx, %edx
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L825:
	.cfi_restore_state
	xorl	%r15d, %r15d
	cmpl	32(%r12), %ebp
	setl	%r15b
	jmp	.L812
	.p2align 4,,10
	.p2align 3
.L805:
	movq	%r14, %r12
	cmpq	24(%rdi), %r14
	je	.L818
	movl	(%rsi), %ebp
	jmp	.L816
	.p2align 4,,10
	.p2align 3
.L818:
	movl	$1, %r15d
	jmp	.L812
	.cfi_endproc
.LFE9254:
	.size	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_, .-_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	.section	.text._ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_,"axG",@progbits,_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	.type	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_, @function
_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_:
.LFB9289:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	8(%rdi), %rdx
	cmpq	16(%rdi), %rdx
	je	.L827
	movl	(%rsi), %eax
	addq	$4, %rdx
	movl	%eax, -4(%rdx)
	movq	%rdx, 8(%rdi)
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L827:
	.cfi_restore_state
	movq	(%rdi), %r14
	subq	%r14, %rdx
	movq	%rdx, %rax
	movq	%rdx, %r12
	movabsq	$2305843009213693951, %rdx
	sarq	$2, %rax
	cmpq	%rdx, %rax
	je	.L842
	testq	%rax, %rax
	je	.L835
	movabsq	$9223372036854775804, %r13
	leaq	(%rax,%rax), %rcx
	cmpq	%rcx, %rax
	jbe	.L843
.L830:
	movq	%r13, %rdi
	movq	%rsi, 8(%rsp)
	call	_Znwm@PLT
	movq	8(%rsp), %rsi
	movq	%rax, %rbp
	addq	%rax, %r13
.L831:
	movl	(%rsi), %eax
	leaq	4(%rbp,%r12), %r15
	movl	%eax, 0(%rbp,%r12)
	testq	%r12, %r12
	jg	.L844
	testq	%r14, %r14
	jne	.L833
.L834:
	movq	%rbp, %xmm0
	movq	%r15, %xmm1
	movq	%r13, 16(%rbx)
	punpcklqdq	%xmm1, %xmm0
	movups	%xmm0, (%rbx)
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L844:
	.cfi_restore_state
	movq	%r12, %rdx
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	memmove@PLT
.L833:
	movq	%r14, %rdi
	call	_ZdlPv@PLT
	jmp	.L834
	.p2align 4,,10
	.p2align 3
.L843:
	testq	%rcx, %rcx
	jne	.L845
	xorl	%r13d, %r13d
	xorl	%ebp, %ebp
	jmp	.L831
	.p2align 4,,10
	.p2align 3
.L835:
	movl	$4, %r13d
	jmp	.L830
.L842:
	leaq	.LC27(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.L845:
	cmpq	%rdx, %rcx
	cmovbe	%rcx, %rdx
	leaq	0(,%rdx,4), %r13
	jmp	.L830
	.cfi_endproc
.LFE9289:
	.size	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_, .-_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	.section	.rodata._ZN19quantumSparseMatrix17getMatrixPositionEii.str1.1,"aMS",@progbits,1
.LC30:
	.string	"diagonal pos ("
.LC31:
	.string	") in matrix of size ("
.LC32:
	.string	"got pos ("
.LC33:
	.string	"out of matrix"
	.section	.text._ZN19quantumSparseMatrix17getMatrixPositionEii,"axG",@progbits,_ZN19quantumSparseMatrix17getMatrixPositionEii,comdat
	.align 2
	.p2align 4
	.weak	_ZN19quantumSparseMatrix17getMatrixPositionEii
	.type	_ZN19quantumSparseMatrix17getMatrixPositionEii, @function
_ZN19quantumSparseMatrix17getMatrixPositionEii:
.LFB3382:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA3382
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pxor	%xmm0, %xmm0
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movl	%edx, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rsi, %rbx
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movl	%ecx, 12(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	$0, 16(%rdi)
	movups	%xmm0, (%rdi)
	testl	%edx, %edx
	je	.L873
	js	.L874
	leaq	20(%rsp), %r13
	movl	$0, 20(%rsp)
	movq	%r13, %rsi
.LEHB53:
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	%r13, %rsi
	movq	%r12, %rdi
	movl	%ebp, 20(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.L851:
	movq	(%r12), %rax
	movl	12(%rsp), %edx
	addl	(%rax), %edx
	movl	%edx, (%rax)
	movl	12(%rsp), %ecx
	addl	%ecx, 4(%rax)
.L849:
	movq	(%rbx), %rcx
	cmpl	%edx, (%rcx)
	jle	.L852
	movl	4(%rcx), %ecx
	cmpl	%ecx, 4(%rax)
	jge	.L852
	movq	24(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L875
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L874:
	.cfi_restore_state
	movl	%edx, %eax
	leaq	20(%rsp), %r13
	negl	%eax
	movq	%r13, %rsi
	movl	%eax, 20(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	%r13, %rsi
	movq	%r12, %rdi
	movl	$0, 20(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	jmp	.L851
	.p2align 4,,10
	.p2align 3
.L852:
	movl	$14, %edx
	leaq	.LC30(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%ebp, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	12(%rsp), %esi
	movq	%rbp, %rdi
	call	_ZNSolsEi@PLT
	movl	$21, %edx
	leaq	.LC31(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%rbx), %rax
	movq	%rbp, %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%rbx), %rax
	movq	%rbp, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %r13
	testq	%r13, %r13
	je	.L876
	cmpb	$0, 56(%r13)
	je	.L856
	movsbl	67(%r13), %esi
.L857:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movl	$9, %edx
	leaq	.LC32(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%r12), %rax
	leaq	_ZSt4cout(%rip), %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%r12), %rax
	movq	%rbp, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$21, %edx
	leaq	.LC31(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%rbx), %rax
	movq	%rbp, %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%rbx), %rax
	movq	%rbp, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %r13
	testq	%r13, %r13
	je	.L877
	cmpb	$0, 56(%r13)
	je	.L859
	movsbl	67(%r13), %esi
.L860:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
.LEHE53:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC33(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
.LEHB54:
	call	_ZNSt12length_errorC1EPKc@PLT
.LEHE54:
	movq	_ZNSt12length_errorD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt12length_error(%rip), %rsi
	movq	%r13, %rdi
.LEHB55:
	call	__cxa_throw@PLT
	.p2align 4,,10
	.p2align 3
.L856:
	movq	%r13, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%r13), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L857
	movq	%r13, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L857
	.p2align 4,,10
	.p2align 3
.L859:
	movq	%r13, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%r13), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L860
	movq	%r13, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L860
	.p2align 4,,10
	.p2align 3
.L873:
	leaq	12(%rsp), %r13
	xorl	%esi, %esi
	movq	%r13, %rdx
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%r12), %rsi
	cmpq	16(%r12), %rsi
	je	.L848
	movl	12(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	(%r12), %rax
	movq	%rsi, 8(%r12)
	movl	(%rax), %edx
	jmp	.L849
	.p2align 4,,10
	.p2align 3
.L848:
	movq	%r13, %rdx
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	(%r12), %rax
	movl	(%rax), %edx
	jmp	.L849
.L877:
	call	_ZSt16__throw_bad_castv@PLT
.L876:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE55:
.L875:
	call	__stack_chk_fail@PLT
.L868:
	endbr64
	movq	%rax, %rbp
	jmp	.L861
.L867:
	endbr64
	movq	%rax, %rbp
	jmp	.L862
.L861:
	movq	%r13, %rdi
	call	__cxa_free_exception@PLT
.L862:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L863
	call	_ZdlPv@PLT
.L863:
	movq	%rbp, %rdi
.LEHB56:
	call	_Unwind_Resume@PLT
.LEHE56:
	.cfi_endproc
.LFE3382:
	.section	.gcc_except_table
.LLSDA3382:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3382-.LLSDACSB3382
.LLSDACSB3382:
	.uleb128 .LEHB53-.LFB3382
	.uleb128 .LEHE53-.LEHB53
	.uleb128 .L867-.LFB3382
	.uleb128 0
	.uleb128 .LEHB54-.LFB3382
	.uleb128 .LEHE54-.LEHB54
	.uleb128 .L868-.LFB3382
	.uleb128 0
	.uleb128 .LEHB55-.LFB3382
	.uleb128 .LEHE55-.LEHB55
	.uleb128 .L867-.LFB3382
	.uleb128 0
	.uleb128 .LEHB56-.LFB3382
	.uleb128 .LEHE56-.LEHB56
	.uleb128 0
	.uleb128 0
.LLSDACSE3382:
	.section	.text._ZN19quantumSparseMatrix17getMatrixPositionEii,"axG",@progbits,_ZN19quantumSparseMatrix17getMatrixPositionEii,comdat
	.size	_ZN19quantumSparseMatrix17getMatrixPositionEii, .-_ZN19quantumSparseMatrix17getMatrixPositionEii
	.section	.text._ZN19quantumSparseMatrix17getTensorPositionEii,"axG",@progbits,_ZN19quantumSparseMatrix17getTensorPositionEii,comdat
	.align 2
	.p2align 4
	.weak	_ZN19quantumSparseMatrix17getTensorPositionEii
	.type	_ZN19quantumSparseMatrix17getTensorPositionEii, @function
_ZN19quantumSparseMatrix17getTensorPositionEii:
.LFB3383:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA3383
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rdi
.LEHB57:
	call	_ZN19quantumSparseMatrix17getMatrixPositionEii
.LEHE57:
	movq	0(%r13), %rax
	movq	32(%r13), %r14
	movabsq	$2305843009213693951, %rdx
	subq	24(%r13), %r14
	movq	16(%rsp), %r9
	movl	4(%rax), %ebx
	movl	(%rax), %ebp
	sarq	$2, %r14
	movslq	%r14d, %rax
	imull	%ebx, %ebp
	imull	(%r9), %ebx
	addl	4(%r9), %ebx
	cmpq	%rdx, %rax
	ja	.L900
	pxor	%xmm0, %xmm0
	leaq	0(,%rax,4), %r15
	movq	$0, 16(%r12)
	movups	%xmm0, (%r12)
	testq	%rax, %rax
	je	.L886
	movq	%r15, %rdi
.LEHB58:
	call	_Znwm@PLT
	leaq	(%rax,%r15), %rcx
	movq	%rax, (%r12)
	movq	%r15, %rdx
	xorl	%esi, %esi
	movq	%rcx, 16(%r12)
	movq	%rax, %rdi
	movq	%rcx, 8(%rsp)
	call	memset@PLT
	movq	8(%rsp), %rcx
	movq	16(%rsp), %r9
	movq	%rax, %r8
	movq	%rcx, 8(%r12)
	testl	%r14d, %r14d
	jle	.L881
	movq	24(%r13), %r10
	leal	-1(%r14), %r11d
	xorl	%esi, %esi
	movl	$1, %edi
	.p2align 4,,10
	.p2align 3
.L882:
	movl	(%r10,%rsi,4), %r13d
	movl	%ebp, %eax
	cltd
	imull	%r13d, %edi
	idivl	%edi
	movl	%eax, %ecx
	movl	%ebx, %eax
	cltd
	idivl	%ecx
	cltd
	idivl	%r13d
	movq	%rsi, %rax
	imull	%edx, %ecx
	movl	%edx, (%r8,%rsi,4)
	addq	$1, %rsi
	subl	%ecx, %ebx
	cmpq	%rax, %r11
	jne	.L882
.L881:
	testq	%r9, %r9
	jne	.L886
.L878:
	movq	40(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L901
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L886:
	.cfi_restore_state
	movq	%r9, %rdi
	call	_ZdlPv@PLT
	jmp	.L878
.L900:
	leaq	.LC2(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE58:
.L901:
	call	__stack_chk_fail@PLT
.L888:
	endbr64
	movq	%rax, %rbp
.L884:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L885
	call	_ZdlPv@PLT
.L885:
	movq	%rbp, %rdi
.LEHB59:
	call	_Unwind_Resume@PLT
.LEHE59:
	.cfi_endproc
.LFE3383:
	.section	.gcc_except_table
.LLSDA3383:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3383-.LLSDACSB3383
.LLSDACSB3383:
	.uleb128 .LEHB57-.LFB3383
	.uleb128 .LEHE57-.LEHB57
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB58-.LFB3383
	.uleb128 .LEHE58-.LEHB58
	.uleb128 .L888-.LFB3383
	.uleb128 0
	.uleb128 .LEHB59-.LFB3383
	.uleb128 .LEHE59-.LEHB59
	.uleb128 0
	.uleb128 0
.LLSDACSE3383:
	.section	.text._ZN19quantumSparseMatrix17getTensorPositionEii,"axG",@progbits,_ZN19quantumSparseMatrix17getTensorPositionEii,comdat
	.size	_ZN19quantumSparseMatrix17getTensorPositionEii, .-_ZN19quantumSparseMatrix17getTensorPositionEii
	.section	.text.unlikely
.LCOLDB35:
	.text
.LHOTB35:
	.p2align 4
	.type	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE._omp_fn.0, @function
_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE._omp_fn.0:
.LFB9911:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA9911
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$168, %rsp
	.cfi_def_cfa_offset 224
	movq	8(%rdi), %r14
	movq	%fs:40, %rax
	movq	%rax, 152(%rsp)
	xorl	%eax, %eax
	movq	(%r14), %rbx
	movl	(%rbx), %eax
	testl	%eax, %eax
	jle	.L902
	movq	%rdi, %r13
	call	omp_get_num_threads@PLT
	movl	%eax, 60(%rsp)
	call	omp_get_thread_num@PLT
	movl	$0, 16(%rsp)
	movl	%eax, 56(%rsp)
	jmp	.L933
	.p2align 4,,10
	.p2align 3
.L905:
	call	GOMP_barrier@PLT
	movq	(%r14), %rbx
	addl	$1, 16(%rsp)
	movl	16(%rsp), %eax
	cmpl	%eax, (%rbx)
	jle	.L902
.L933:
	movl	4(%rbx), %eax
	cltd
	idivl	60(%rsp)
	cmpl	%edx, 56(%rsp)
	jl	.L904
.L935:
	movl	56(%rsp), %ebx
	imull	%eax, %ebx
	addl	%edx, %ebx
	addl	%ebx, %eax
	movl	%eax, 20(%rsp)
	cmpl	%eax, %ebx
	jge	.L905
	movl	16(%rsp), %eax
	movq	%rax, 24(%rsp)
	.p2align 4,,10
	.p2align 3
.L936:
	movq	%rbx, %r12
	movl	$8, %edi
	salq	$32, %r12
	orq	24(%rsp), %r12
.LEHB60:
	call	_Znwm@PLT
.LEHE60:
	movq	%r12, (%rax)
	movl	$8, %edi
	movq	%rax, %rbp
	call	_Znwm@PLT
	movq	16(%r13), %r15
	movl	$8, %edi
	movq	%rax, %r12
	movq	0(%rbp), %rax
	movq	%rax, (%r12)
	call	_Znwm@PLT
	movq	24(%r15), %r9
	movq	32(%r15), %r8
	movq	%rax, %rdi
	movq	(%r12), %rax
	subq	%r9, %r8
	movq	%r8, %rsi
	movq	%rax, (%rdi)
	sarq	$2, %rsi
	je	.L954
	leaq	-1(%rsi), %rax
	cmpq	$28, %rax
	jbe	.L938
	movq	%rsi, %rax
	movdqa	.LC34(%rip), %xmm0
	movq	%r9, %rdx
	shrq	$2, %rax
	salq	$4, %rax
	addq	%r9, %rax
	.p2align 4,,10
	.p2align 3
.L910:
	movdqu	(%rdx), %xmm2
	movdqu	(%rdx), %xmm1
	addq	$16, %rdx
	pmuludq	%xmm0, %xmm2
	psrlq	$32, %xmm1
	psrlq	$32, %xmm0
	pmuludq	%xmm0, %xmm1
	pshufd	$8, %xmm2, %xmm0
	pshufd	$8, %xmm1, %xmm1
	punpckldq	%xmm1, %xmm0
	cmpq	%rdx, %rax
	jne	.L910
	movdqa	%xmm0, %xmm1
	movq	%rsi, %rdx
	psrldq	$8, %xmm1
	andq	$-4, %rdx
	movdqa	%xmm1, %xmm2
	psrlq	$32, %xmm1
	movslq	%edx, %rax
	pmuludq	%xmm0, %xmm2
	psrlq	$32, %xmm0
	pmuludq	%xmm1, %xmm0
	pshufd	$8, %xmm2, %xmm1
	pshufd	$8, %xmm0, %xmm0
	punpckldq	%xmm0, %xmm1
	movdqa	%xmm1, %xmm0
	psrldq	$4, %xmm1
	pmuludq	%xmm1, %xmm0
	movd	%xmm0, %ecx
	cmpq	%rsi, %rdx
	je	.L911
.L909:
	addq	$1, %rax
	.p2align 4,,10
	.p2align 3
.L912:
	imull	(%r9,%rdx,4), %ecx
	movq	%rax, %rdx
	addq	$1, %rax
	cmpq	%rsi, %rdx
	jb	.L912
.L911:
	xorl	%esi, %esi
	xorl	%r10d, %r10d
	movl	$1, %r11d
	.p2align 4,,10
	.p2align 3
.L913:
	imull	(%r9,%rsi), %r11d
	movl	%ecx, %eax
	cltd
	idivl	%r11d
	imull	(%rdi,%rsi), %eax
	addq	$4, %rsi
	addl	%eax, %r10d
	cmpq	%rsi, %r8
	jne	.L913
.L907:
	movl	%r10d, 8(%rsp)
	call	_ZdlPv@PLT
	movl	8(%rsp), %r10d
	movq	(%r15), %rcx
	xorl	%esi, %esi
	leaq	80(%rsp), %r15
	pxor	%xmm0, %xmm0
	movl	%r10d, %eax
	movq	%r15, %rdi
	cltd
	idivl	4(%rcx)
	movaps	%xmm0, 80(%rsp)
	movq	$0, 96(%rsp)
	movl	%edx, 72(%rsp)
	subl	%eax, %edx
	movl	%edx, 76(%rsp)
	leaq	76(%rsp), %rdx
.LEHB61:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movl	76(%rsp), %eax
	testl	%eax, %eax
	jle	.L955
	movl	72(%rsp), %ecx
	leaq	112(%rsp), %rsi
	movq	%r15, %rdi
	subl	%eax, %ecx
	movl	%ecx, 112(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE61:
.L916:
	movq	%r12, %rdi
	call	_ZdlPv@PLT
	movq	0(%r13), %rax
	movl	16(%rsp), %ecx
	movq	64(%r14), %rdx
	movq	80(%rsp), %rdi
	movq	(%rax), %rax
	movq	16(%r13), %r15
	imull	4(%rax), %ecx
	movl	%ecx, %eax
	addl	%ebx, %eax
	cltq
	movss	(%rdx,%rax,4), %xmm0
	movq	56(%r14), %rdx
	movss	(%rdx,%rax,4), %xmm1
	movl	(%rdi), %edx
	testl	%edx, %edx
	js	.L956
	movq	(%r15), %rcx
	movl	(%rcx), %r8d
	movl	4(%rcx), %eax
	je	.L923
	subl	%edx, %eax
.L922:
	cmpl	%r8d, %eax
	jg	.L924
	cmpl	%eax, 4(%rcx)
	cmovle	4(%rcx), %eax
	movl	%eax, %r8d
.L924:
	movq	72(%r15), %rax
	movslq	4(%rdi), %r12
	leaq	64(%r15), %rsi
	testq	%rax, %rax
	je	.L925
	movq	%rsi, %rcx
	jmp	.L926
	.p2align 4,,10
	.p2align 3
.L957:
	movq	%rax, %rcx
	movq	16(%rax), %rax
	testq	%rax, %rax
	je	.L927
.L926:
	cmpl	32(%rax), %edx
	jle	.L957
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L926
.L927:
	cmpq	%rcx, %rsi
	je	.L925
	cmpl	32(%rcx), %edx
	jge	.L930
.L925:
	movslq	%r8d, %rdi
	movl	$4, %esi
	movl	%edx, 52(%rsp)
	movl	%r8d, 40(%rsp)
	movss	%xmm1, 48(%rsp)
	movss	%xmm0, 44(%rsp)
	movq	%rdi, 32(%rsp)
	call	calloc@PLT
	movq	32(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, 8(%rsp)
	call	calloc@PLT
	movq	8(%rsp), %rcx
	movss	44(%rsp), %xmm0
	leaq	56(%r15), %rdi
	movss	48(%rsp), %xmm1
	movl	52(%rsp), %edx
	movq	%rax, %xmm3
	leaq	112(%rsp), %rsi
	movl	40(%rsp), %r8d
	movss	%xmm0, (%rax,%r12,4)
	movq	%rcx, %xmm0
	punpcklqdq	%xmm3, %xmm0
	movss	%xmm1, (%rcx,%r12,4)
	movl	%edx, 112(%rsp)
	movl	%edx, 120(%rsp)
	movl	%r8d, 124(%rsp)
	movaps	%xmm0, 128(%rsp)
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	movq	80(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L931
.L932:
	movq	%rbp, %rdi
	addl	$1, %ebx
	call	_ZdlPv@PLT
	cmpl	%ebx, 20(%rsp)
	jne	.L936
	jmp	.L905
	.p2align 4,,10
	.p2align 3
.L930:
	movq	56(%rcx), %rax
	movq	48(%rcx), %rdx
	movss	%xmm1, (%rdx,%r12,4)
	movss	%xmm0, (%rax,%r12,4)
.L931:
	call	_ZdlPv@PLT
	jmp	.L932
	.p2align 4,,10
	.p2align 3
.L956:
	movq	(%r15), %rcx
	movl	(%rcx), %r8d
	leal	(%rdx,%r8), %eax
	jmp	.L922
	.p2align 4,,10
	.p2align 3
.L955:
	movq	88(%rsp), %rsi
	cmpq	96(%rsp), %rsi
	je	.L915
	movl	72(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 88(%rsp)
	jmp	.L916
	.p2align 4,,10
	.p2align 3
.L923:
	cmpl	%eax, %r8d
	cmovle	%r8d, %eax
	jmp	.L922
	.p2align 4,,10
	.p2align 3
.L954:
	xorl	%r10d, %r10d
	jmp	.L907
	.p2align 4,,10
	.p2align 3
.L904:
	addl	$1, %eax
	xorl	%edx, %edx
	jmp	.L935
	.p2align 4,,10
	.p2align 3
.L938:
	movl	$1, %ecx
	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	.L909
	.p2align 4,,10
	.p2align 3
.L915:
	leaq	72(%rsp), %rdx
	movq	%r15, %rdi
.LEHB62:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE62:
	jmp	.L916
	.p2align 4,,10
	.p2align 3
.L902:
	movq	152(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L958
	addq	$168, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L958:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
.L939:
	endbr64
	jmp	.L919
.L940:
	endbr64
	jmp	.L921
	.section	.gcc_except_table
.LLSDA9911:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE9911-.LLSDACSB9911
.LLSDACSB9911:
	.uleb128 .LEHB60-.LFB9911
	.uleb128 .LEHE60-.LEHB60
	.uleb128 .L940-.LFB9911
	.uleb128 0
	.uleb128 .LEHB61-.LFB9911
	.uleb128 .LEHE61-.LEHB61
	.uleb128 .L939-.LFB9911
	.uleb128 0
	.uleb128 .LEHB62-.LFB9911
	.uleb128 .LEHE62-.LEHB62
	.uleb128 .L939-.LFB9911
	.uleb128 0
.LLSDACSE9911:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC9911
	.type	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE._omp_fn.0.cold, @function
_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE._omp_fn.0.cold:
.LFSB9911:
.L919:
	.cfi_def_cfa_offset 224
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	80(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L921
	call	_ZdlPv@PLT
.L921:
	call	_ZSt9terminatev@PLT
	.cfi_endproc
.LFE9911:
	.section	.gcc_except_table
.LLSDAC9911:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC9911-.LLSDACSBC9911
.LLSDACSBC9911:
.LLSDACSEC9911:
	.section	.text.unlikely
	.text
	.size	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE._omp_fn.0, .-_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE._omp_fn.0
	.section	.text.unlikely
	.size	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE._omp_fn.0.cold, .-_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE._omp_fn.0.cold
.LCOLDE35:
	.text
.LHOTE35:
	.section	.text.unlikely
.LCOLDB36:
	.text
.LHOTB36:
	.p2align 4
	.type	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0, @function
_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0:
.LFB9908:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA9908
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$184, %rsp
	.cfi_def_cfa_offset 240
	movq	%fs:40, %rax
	movq	%rax, 168(%rsp)
	xorl	%eax, %eax
	movq	16(%rdi), %rax
	movq	(%rax), %r12
	call	omp_get_num_threads@PLT
	movl	%eax, %ebx
	call	omp_get_thread_num@PLT
	movl	%eax, %ecx
	movl	44(%r12), %eax
	cltd
	idivl	%ebx
	cmpl	%edx, %ecx
	jl	.L960
.L1021:
	imull	%eax, %ecx
	addl	%ecx, %edx
	addl	%edx, %eax
	movl	%eax, 28(%rsp)
	cmpl	%eax, %edx
	jge	.L959
	movq	32(%rbp), %rax
	leaq	96(%rsp), %r14
	movq	%rax, 32(%rsp)
	movq	24(%rbp), %rax
	movq	%rax, 40(%rsp)
	movslq	%edx, %rax
	movq	%rax, 8(%rsp)
	leaq	128(%rsp), %rax
	movq	%rax, 16(%rsp)
.L1020:
	movl	32(%r12), %r12d
	movl	8(%rsp), %eax
	pxor	%xmm3, %xmm3
	movq	$0, 144(%rsp)
	movq	0(%rbp), %r13
	movaps	%xmm3, 128(%rsp)
	movl	%eax, 92(%rsp)
	testl	%r12d, %r12d
	je	.L1058
	js	.L1059
	movq	16(%rsp), %rbx
	movq	%r14, %rsi
	movl	$0, 96(%rsp)
	movq	%rbx, %rdi
.LEHB63:
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	%r14, %rsi
	movq	%rbx, %rdi
	movl	%r12d, 96(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE63:
.L966:
	movq	128(%rsp), %r9
	movl	92(%rsp), %eax
	addl	(%r9), %eax
	movl	%eax, (%r9)
	movl	92(%rsp), %edx
	addl	%edx, 4(%r9)
.L964:
	movq	0(%r13), %rdx
	cmpl	%eax, (%rdx)
	jle	.L967
	movl	4(%r9), %eax
	movl	4(%rdx), %ebx
	cmpl	%ebx, %eax
	jge	.L967
	movl	(%rdx), %r12d
	movq	32(%r13), %rdx
	subq	24(%r13), %rdx
	imull	%ebx, %r12d
	movq	%rdx, %rcx
	imull	(%r9), %ebx
	sarq	$2, %rcx
	movslq	%ecx, %r15
	movq	%rcx, 56(%rsp)
	addl	%eax, %ebx
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %r15
	ja	.L1060
	testq	%r15, %r15
	je	.L1025
	leaq	0(,%r15,4), %rax
	movq	%rax, %rdi
	movq	%rax, 48(%rsp)
.LEHB64:
	call	_Znwm@PLT
.LEHE64:
	movq	48(%rsp), %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, %r15
	call	memset@PLT
	movq	48(%rsp), %rax
	movq	128(%rsp), %r9
	addq	%r15, %rax
	movq	%rax, 48(%rsp)
	movq	56(%rsp), %rax
	testl	%eax, %eax
	jle	.L980
	movq	24(%r13), %r11
	leal	-1(%rax), %r10d
	xorl	%esi, %esi
	movl	$1, %edi
	.p2align 4,,10
	.p2align 3
.L981:
	movl	(%r11,%rsi,4), %r8d
	movl	%r12d, %eax
	cltd
	imull	%r8d, %edi
	idivl	%edi
	movl	%eax, %ecx
	movl	%ebx, %eax
	cltd
	idivl	%ecx
	cltd
	idivl	%r8d
	movq	%rsi, %rax
	imull	%edx, %ecx
	movl	%edx, (%r15,%rsi,4)
	addq	$1, %rsi
	subl	%ecx, %ebx
	cmpq	%rax, %r10
	jne	.L981
.L980:
	testq	%r9, %r9
	jne	.L979
.L982:
	movq	48(%rsp), %r13
	subq	%r15, %r13
	movq	%r13, %rax
	sarq	$2, %rax
	je	.L1061
	movabsq	$2305843009213693951, %rbx
	cmpq	%rbx, %rax
	ja	.L1004
	movq	%r13, %rdi
	call	_Znwm@PLT
	movq	%rax, %r12
.L984:
	cmpq	%r15, 48(%rsp)
	je	.L989
	movq	%r13, %rdx
	movq	%r15, %rsi
	movq	%r12, %rdi
	call	memcpy@PLT
.L989:
	movq	0(%rbp), %rax
	movq	24(%rax), %r9
	movq	32(%rax), %r10
	subq	%r9, %r10
	movq	%r10, %rcx
	sarq	$2, %rcx
	je	.L1026
	leaq	-1(%rcx), %rax
	cmpq	$28, %rax
	jbe	.L1027
	movq	%rcx, %rdx
	movdqa	.LC34(%rip), %xmm1
	movq	%r9, %rax
	shrq	$2, %rdx
	salq	$4, %rdx
	addq	%r9, %rdx
	.p2align 4,,10
	.p2align 3
.L992:
	movdqu	(%rax), %xmm2
	movdqu	(%rax), %xmm0
	addq	$16, %rax
	pmuludq	%xmm1, %xmm2
	psrlq	$32, %xmm0
	psrlq	$32, %xmm1
	pmuludq	%xmm1, %xmm0
	pshufd	$8, %xmm2, %xmm1
	pshufd	$8, %xmm0, %xmm0
	punpckldq	%xmm0, %xmm1
	cmpq	%rax, %rdx
	jne	.L992
	movdqa	%xmm1, %xmm0
	movq	%rcx, %rdx
	psrldq	$8, %xmm0
	andq	$-4, %rdx
	movdqa	%xmm0, %xmm2
	psrlq	$32, %xmm0
	movslq	%edx, %rax
	pmuludq	%xmm1, %xmm2
	psrlq	$32, %xmm1
	pmuludq	%xmm0, %xmm1
	pshufd	$8, %xmm2, %xmm0
	pshufd	$8, %xmm1, %xmm1
	punpckldq	%xmm1, %xmm0
	movdqa	%xmm0, %xmm1
	psrldq	$4, %xmm1
	pmuludq	%xmm1, %xmm0
	movd	%xmm0, %edi
	cmpq	%rdx, %rcx
	je	.L993
.L991:
	addq	$1, %rax
	.p2align 4,,10
	.p2align 3
.L994:
	imull	(%r9,%rdx,4), %edi
	movq	%rax, %rdx
	addq	$1, %rax
	cmpq	%rcx, %rdx
	jb	.L994
.L993:
	xorl	%ecx, %ecx
	xorl	%r8d, %r8d
	movl	$1, %esi
	.p2align 4,,10
	.p2align 3
.L995:
	imull	(%r9,%rcx), %esi
	movl	%edi, %eax
	cltd
	idivl	%esi
	imull	(%r12,%rcx), %eax
	addq	$4, %rcx
	addl	%eax, %r8d
	cmpq	%rcx, %r10
	jne	.L995
.L990:
	movq	8(%rbp), %rax
	pxor	%xmm4, %xmm4
	xorl	%esi, %esi
	movq	%r14, %rdi
	movq	(%rax), %rbx
	movl	%r8d, %eax
	cltd
	idivl	4(%rbx)
	movaps	%xmm4, 96(%rsp)
	movq	$0, 112(%rsp)
	movl	%edx, 84(%rsp)
	subl	%eax, %edx
	movl	%edx, 88(%rsp)
	leaq	88(%rsp), %rdx
.LEHB65:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movl	88(%rsp), %eax
	testl	%eax, %eax
	jle	.L1062
	movl	84(%rsp), %ebx
	movq	16(%rsp), %rsi
	movq	%r14, %rdi
	subl	%eax, %ebx
	movl	%ebx, 128(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE65:
.L998:
	testq	%r12, %r12
	je	.L1000
	movq	%r12, %rdi
	call	_ZdlPv@PLT
.L1000:
	movq	8(%rbp), %rbx
	movq	8(%rbx), %rax
	movq	(%rbx), %rsi
	movq	%rax, %rdx
	subq	%rsi, %rdx
	movq	%rdx, %rcx
	sarq	$2, %rcx
	je	.L1028
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L1004
	movq	%rdx, %rdi
	call	_Znwm@PLT
	movq	(%rbx), %rsi
	movq	%rax, %rdi
	movq	8(%rbx), %rax
	movq	%rax, %rdx
	subq	%rsi, %rdx
.L1003:
	cmpq	%rsi, %rax
	je	.L1005
	call	memmove@PLT
	movq	%rax, %rdi
.L1005:
	movq	96(%rsp), %rax
	movl	(%rdi), %r12d
	movl	(%rax), %edx
	leal	(%rdx,%r12), %eax
	testl	%edx, %edx
	js	.L1007
	movl	4(%rdi), %eax
	je	.L1008
	subl	%edx, %eax
.L1007:
	cmpl	%r12d, %eax
	jg	.L1009
	cmpl	%eax, 4(%rdi)
	cmovle	4(%rdi), %eax
	movl	%eax, %r12d
.L1009:
	call	_ZdlPv@PLT
	movq	8(%rsp), %rax
	movq	32(%rsp), %rbx
	movq	96(%rsp), %rdi
	movss	(%rbx,%rax,4), %xmm0
	movq	40(%rsp), %rbx
	movl	4(%rdi), %esi
	movl	(%rdi), %r13d
	movss	(%rbx,%rax,4), %xmm1
	movq	8(%rbp), %rbx
	movq	72(%rbx), %rax
	leaq	64(%rbx), %rcx
	movq	%rcx, %rdx
	testq	%rax, %rax
	jne	.L1010
	jmp	.L1063
	.p2align 4,,10
	.p2align 3
.L1064:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	je	.L1012
.L1010:
	cmpl	32(%rax), %r13d
	jle	.L1064
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1010
.L1012:
	movslq	%esi, %rax
	leaq	0(,%rax,4), %r8
	cmpq	%rdx, %rcx
	je	.L1011
	cmpl	32(%rdx), %r13d
	jge	.L1015
.L1011:
	movslq	%r12d, %rdi
	movl	$4, %esi
	movq	%r8, 72(%rsp)
	movss	%xmm1, 68(%rsp)
	movss	%xmm0, 64(%rsp)
	movq	%rdi, 56(%rsp)
	call	calloc@PLT
	movq	56(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, 48(%rsp)
	call	calloc@PLT
	movq	48(%rsp), %rcx
	movq	72(%rsp), %r8
	leaq	56(%rbx), %rdi
	movss	64(%rsp), %xmm0
	movss	68(%rsp), %xmm1
	movq	%rax, %xmm5
	movl	%r13d, 128(%rsp)
	movq	16(%rsp), %rsi
	movl	%r13d, 136(%rsp)
	movss	%xmm0, (%rax,%r8)
	movq	%rcx, %xmm0
	punpcklqdq	%xmm5, %xmm0
	movss	%xmm1, (%rcx,%r8)
	movl	%r12d, 140(%rsp)
	movaps	%xmm0, 144(%rsp)
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1016
.L1017:
	testq	%r15, %r15
	je	.L1018
	movq	%r15, %rdi
	call	_ZdlPv@PLT
	addq	$1, 8(%rsp)
	movq	8(%rsp), %rax
	cmpl	%eax, 28(%rsp)
	jle	.L959
.L1019:
	movq	16(%rbp), %rax
	movq	(%rax), %r12
	jmp	.L1020
	.p2align 4,,10
	.p2align 3
.L1018:
	addq	$1, 8(%rsp)
	movq	8(%rsp), %rax
	cmpl	%eax, 28(%rsp)
	jg	.L1019
	.p2align 4,,10
	.p2align 3
.L959:
	movq	168(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1065
	addq	$184, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L967:
	.cfi_restore_state
	movl	$14, %edx
	leaq	.LC30(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB66:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%r12d, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	92(%rsp), %esi
	movq	%rbp, %rdi
	call	_ZNSolsEi@PLT
	movl	$21, %edx
	leaq	.LC31(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%r13), %rax
	movq	%rbp, %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%r13), %rax
	movq	%rbp, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r12
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%r12), %rax
	movq	-24(%rax), %rax
	movq	240(%r12,%rax), %rbp
	testq	%rbp, %rbp
	je	.L1066
	cmpb	$0, 56(%rbp)
	je	.L970
	movsbl	67(%rbp), %esi
.L971:
	movq	%r12, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movl	$9, %edx
	leaq	.LC32(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	128(%rsp), %rax
	leaq	_ZSt4cout(%rip), %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	128(%rsp), %rax
	movq	%rbp, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$21, %edx
	leaq	.LC31(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%r13), %rax
	movq	%rbp, %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%r13), %rax
	movq	%rbp, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %r12
	testq	%r12, %r12
	je	.L1067
	cmpb	$0, 56(%r12)
	je	.L973
	movsbl	67(%r12), %esi
.L974:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	jmp	.L1053
	.p2align 4,,10
	.p2align 3
.L960:
	addl	$1, %eax
	xorl	%edx, %edx
	jmp	.L1021
	.p2align 4,,10
	.p2align 3
.L973:
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L974
	movq	%r12, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L974
	.p2align 4,,10
	.p2align 3
.L970:
	movq	%rbp, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%rbp), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L971
	movq	%rbp, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L971
	.p2align 4,,10
	.p2align 3
.L1025:
	movq	$0, 48(%rsp)
	xorl	%r15d, %r15d
.L979:
	movq	%r9, %rdi
	call	_ZdlPv@PLT
	jmp	.L982
	.p2align 4,,10
	.p2align 3
.L1015:
	movq	56(%rdx), %rcx
	movq	48(%rdx), %rdx
	movss	%xmm1, (%rdx,%rax,4)
	movss	%xmm0, (%rcx,%rax,4)
.L1016:
	call	_ZdlPv@PLT
	jmp	.L1017
	.p2align 4,,10
	.p2align 3
.L1059:
	movq	16(%rsp), %rbx
	movl	%r12d, %eax
	movq	%r14, %rsi
	negl	%eax
	movq	%rbx, %rdi
	movl	%eax, 96(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	%r14, %rsi
	movq	%rbx, %rdi
	movl	$0, 96(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	jmp	.L966
	.p2align 4,,10
	.p2align 3
.L1062:
	movq	104(%rsp), %rsi
	cmpq	112(%rsp), %rsi
	je	.L997
	movl	84(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 104(%rsp)
	jmp	.L998
	.p2align 4,,10
	.p2align 3
.L1008:
	cmpl	%eax, %r12d
	cmovle	%r12d, %eax
	jmp	.L1007
	.p2align 4,,10
	.p2align 3
.L1028:
	xorl	%edi, %edi
	jmp	.L1003
	.p2align 4,,10
	.p2align 3
.L1061:
	xorl	%r12d, %r12d
	jmp	.L984
	.p2align 4,,10
	.p2align 3
.L1058:
	leaq	92(%rsp), %r15
	movq	16(%rsp), %rdi
	xorl	%esi, %esi
	movq	%r15, %rdx
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	136(%rsp), %rsi
	cmpq	144(%rsp), %rsi
	je	.L963
	movl	92(%rsp), %eax
	movq	128(%rsp), %r9
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movl	(%r9), %eax
	movq	%rsi, 136(%rsp)
	jmp	.L964
.L963:
	movq	16(%rsp), %rdi
	movq	%r15, %rdx
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE66:
	movq	128(%rsp), %r9
	movl	(%r9), %eax
	jmp	.L964
.L1063:
	movslq	%esi, %rax
	leaq	0(,%rax,4), %r8
	jmp	.L1011
.L1026:
	xorl	%r8d, %r8d
	jmp	.L990
.L1027:
	movl	$1, %edi
	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	.L991
.L997:
	leaq	84(%rsp), %rdx
	movq	%r14, %rdi
.LEHB67:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE67:
	jmp	.L998
.L1060:
	leaq	.LC2(%rip), %rdi
.LEHB68:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE68:
.L1004:
	call	_ZSt17__throw_bad_allocv@PLT
.L1067:
.LEHB69:
	call	_ZSt16__throw_bad_castv@PLT
.L1065:
	call	__stack_chk_fail@PLT
.L1066:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE69:
.L1031:
	endbr64
	jmp	.L976
.L1051:
	endbr64
	jmp	.L976
.L1030:
	endbr64
	jmp	.L1001
	.section	.gcc_except_table
.LLSDA9908:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE9908-.LLSDACSB9908
.LLSDACSB9908:
	.uleb128 .LEHB63-.LFB9908
	.uleb128 .LEHE63-.LEHB63
	.uleb128 .L1051-.LFB9908
	.uleb128 0
	.uleb128 .LEHB64-.LFB9908
	.uleb128 .LEHE64-.LEHB64
	.uleb128 .L1031-.LFB9908
	.uleb128 0
	.uleb128 .LEHB65-.LFB9908
	.uleb128 .LEHE65-.LEHB65
	.uleb128 .L1030-.LFB9908
	.uleb128 0
	.uleb128 .LEHB66-.LFB9908
	.uleb128 .LEHE66-.LEHB66
	.uleb128 .L1051-.LFB9908
	.uleb128 0
	.uleb128 .LEHB67-.LFB9908
	.uleb128 .LEHE67-.LEHB67
	.uleb128 .L1030-.LFB9908
	.uleb128 0
	.uleb128 .LEHB68-.LFB9908
	.uleb128 .LEHE68-.LEHB68
	.uleb128 .L1031-.LFB9908
	.uleb128 0
	.uleb128 .LEHB69-.LFB9908
	.uleb128 .LEHE69-.LEHB69
	.uleb128 .L1051-.LFB9908
	.uleb128 0
.LLSDACSE9908:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC9908
	.type	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0.cold, @function
_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0.cold:
.LFSB9908:
	nop
.L1032:
	.cfi_def_cfa_offset 240
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	endbr64
.L976:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L987
.L1056:
	call	_ZdlPv@PLT
.L987:
	call	_ZSt9terminatev@PLT
.L1053:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC33(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
.LEHB70:
	call	_ZNSt12length_errorC1EPKc@PLT
.LEHE70:
	movq	_ZNSt12length_errorD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt12length_error(%rip), %rsi
	movq	%rbp, %rdi
.LEHB71:
	call	__cxa_throw@PLT
.LEHE71:
.L1033:
	endbr64
	movq	%rbp, %rdi
	call	__cxa_free_exception@PLT
	jmp	.L976
.L1001:
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1056
	jmp	.L987
	.cfi_endproc
.LFE9908:
	.section	.gcc_except_table
.LLSDAC9908:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC9908-.LLSDACSBC9908
.LLSDACSBC9908:
	.uleb128 .LEHB70-.LCOLDB36
	.uleb128 .LEHE70-.LEHB70
	.uleb128 .L1033-.LCOLDB36
	.uleb128 0
	.uleb128 .LEHB71-.LCOLDB36
	.uleb128 .LEHE71-.LEHB71
	.uleb128 .L1032-.LCOLDB36
	.uleb128 0
.LLSDACSEC9908:
	.section	.text.unlikely
	.text
	.size	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0, .-_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0
	.section	.text.unlikely
	.size	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0.cold, .-_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0.cold
.LCOLDE36:
	.text
.LHOTE36:
	.section	.text.unlikely
.LCOLDB37:
	.text
.LHOTB37:
	.p2align 4
	.type	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0, @function
_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0:
.LFB9909:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA9909
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$216, %rsp
	.cfi_def_cfa_offset 272
	movq	%fs:40, %rax
	movq	%rax, 200(%rsp)
	xorl	%eax, %eax
	movq	32(%rdi), %rax
	movq	(%rax), %r12
	call	omp_get_num_threads@PLT
	movl	%eax, %ebx
	call	omp_get_thread_num@PLT
	movl	%eax, %ecx
	movl	44(%r12), %eax
	cltd
	idivl	%ebx
	cmpl	%edx, %ecx
	jl	.L1069
.L1141:
	imull	%eax, %ecx
	addl	%ecx, %edx
	addl	%edx, %eax
	movl	%eax, 20(%rsp)
	cmpl	%eax, %edx
	jge	.L1068
	movq	48(%rbp), %rax
	movq	%rax, 32(%rsp)
	movq	40(%rbp), %rax
	movq	%rax, 40(%rsp)
	movslq	%edx, %rax
	movq	%rax, 8(%rsp)
	leaq	160(%rsp), %rax
	movq	%rax, 24(%rsp)
	leaq	96(%rsp), %rax
	movq	%rax, 48(%rsp)
.L1137:
	movl	32(%r12), %r14d
	movl	8(%rsp), %eax
	pxor	%xmm0, %xmm0
	movq	$0, 176(%rsp)
	movq	0(%rbp), %r13
	movaps	%xmm0, 160(%rsp)
	movl	%eax, 84(%rsp)
	testl	%r14d, %r14d
	je	.L1190
	js	.L1191
	movq	24(%rsp), %rbx
	leaq	128(%rsp), %r12
	movl	$0, 128(%rsp)
	movq	%r12, %rsi
	movq	%rbx, %rdi
.LEHB72:
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	%r12, %rsi
	movq	%rbx, %rdi
	movl	%r14d, 128(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE72:
.L1075:
	movq	160(%rsp), %r8
	movl	84(%rsp), %eax
	addl	(%r8), %eax
	movl	%eax, (%r8)
	movl	84(%rsp), %edx
	addl	%edx, 4(%r8)
.L1073:
	movq	0(%r13), %rdx
	cmpl	%eax, (%rdx)
	jle	.L1076
	movl	4(%r8), %eax
	movl	4(%rdx), %ebx
	cmpl	%ebx, %eax
	jge	.L1076
	movl	(%rdx), %r12d
	movq	32(%r13), %r14
	subq	24(%r13), %r14
	imull	%ebx, %r12d
	sarq	$2, %r14
	imull	(%r8), %ebx
	movslq	%r14d, %r15
	addl	%eax, %ebx
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %r15
	ja	.L1192
	testq	%r15, %r15
	je	.L1147
	leaq	0(,%r15,4), %rax
	movq	%rax, %rdi
	movq	%rax, 56(%rsp)
.LEHB73:
	call	_Znwm@PLT
.LEHE73:
	movq	56(%rsp), %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, %r15
	call	memset@PLT
	movq	160(%rsp), %r8
	testl	%r14d, %r14d
	jle	.L1089
	movq	24(%r13), %r10
	leal	-1(%r14), %r9d
	xorl	%esi, %esi
	movl	$1, %edi
	.p2align 4,,10
	.p2align 3
.L1090:
	movl	(%r10,%rsi,4), %r11d
	movl	%r12d, %eax
	cltd
	imull	%r11d, %edi
	idivl	%edi
	movl	%eax, %ecx
	movl	%ebx, %eax
	cltd
	idivl	%ecx
	cltd
	idivl	%r11d
	movq	%rsi, %rax
	imull	%edx, %ecx
	movl	%edx, (%r15,%rsi,4)
	addq	$1, %rsi
	subl	%ecx, %ebx
	cmpq	%rax, %r9
	jne	.L1090
.L1089:
	testq	%r8, %r8
	jne	.L1088
.L1091:
	movq	8(%rbp), %rcx
	pxor	%xmm0, %xmm0
	movq	48(%rsp), %r12
	xorl	%ebx, %ebx
	movq	$0, 112(%rsp)
	xorl	%eax, %eax
	xorl	%esi, %esi
	movq	(%rcx), %rdx
	movaps	%xmm0, 96(%rsp)
	cmpq	8(%rcx), %rdx
	jne	.L1092
	jmp	.L1193
	.p2align 4,,10
	.p2align 3
.L1194:
	movl	(%rdx), %eax
	movq	(%rcx), %rdx
	addq	$4, %rsi
	addq	$1, %rbx
	movl	%eax, -4(%rsi)
	movq	8(%rcx), %rax
	movq	%rsi, 104(%rsp)
	subq	%rdx, %rax
	sarq	$2, %rax
	cmpq	%rax, %rbx
	jnb	.L1140
.L1139:
	movq	112(%rsp), %rax
.L1092:
	movslq	(%rdx,%rbx,4), %rdx
	leaq	(%r15,%rdx,4), %rdx
	cmpq	%rax, %rsi
	jne	.L1194
	movq	%r12, %rdi
	addq	$1, %rbx
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%rbp), %rcx
	movq	104(%rsp), %rsi
	movq	(%rcx), %rdx
	movq	8(%rcx), %rax
	subq	%rdx, %rax
	sarq	$2, %rax
	cmpq	%rbx, %rax
	ja	.L1139
.L1140:
	movq	96(%rsp), %r8
	movq	%rsi, %rdi
	subq	%r8, %rdi
	movq	%rdi, %rcx
	sarq	$2, %rcx
	je	.L1097
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L1102
	call	_Znwm@PLT
	movq	96(%rsp), %r8
	movq	24(%rbp), %rbx
	movq	%rax, %r13
	movq	104(%rsp), %rax
	movq	%rax, %r14
	subq	%r8, %r14
	movq	%r14, %rcx
	sarq	$2, %rcx
	cmpq	%r8, %rax
	je	.L1100
.L1142:
	movq	%r14, %rdx
	movq	%r8, %rsi
	movq	%r13, %rdi
	movq	%rcx, 56(%rsp)
	call	memmove@PLT
	movq	56(%rsp), %rcx
.L1100:
	leaq	0(%r13,%r14), %r12
	testq	%rcx, %rcx
	je	.L1149
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L1102
	movq	%r14, %rdi
	call	_Znwm@PLT
	movq	%rax, %r9
.L1101:
	cmpq	%r12, %r13
	je	.L1103
	movq	%r9, %rdi
	movq	%r14, %rdx
	movq	%r13, %rsi
	call	memcpy@PLT
	movq	24(%rbx), %r10
	movq	32(%rbx), %r8
	movq	%rax, %r9
	subq	%r10, %r8
	sarq	$2, %r8
	je	.L1195
.L1104:
	leaq	-1(%r8), %rax
	cmpq	$28, %rax
	jbe	.L1150
	movq	%r8, %rdx
	movdqa	.LC34(%rip), %xmm1
	movq	%r10, %rax
	shrq	$2, %rdx
	salq	$4, %rdx
	addq	%r10, %rdx
	.p2align 4,,10
	.p2align 3
.L1108:
	movdqu	(%rax), %xmm2
	movdqu	(%rax), %xmm0
	addq	$16, %rax
	pmuludq	%xmm1, %xmm2
	psrlq	$32, %xmm0
	psrlq	$32, %xmm1
	pmuludq	%xmm1, %xmm0
	pshufd	$8, %xmm2, %xmm1
	pshufd	$8, %xmm0, %xmm0
	punpckldq	%xmm0, %xmm1
	cmpq	%rax, %rdx
	jne	.L1108
	movdqa	%xmm1, %xmm0
	movq	%r8, %rdx
	psrldq	$8, %xmm0
	andq	$-4, %rdx
	movdqa	%xmm0, %xmm2
	psrlq	$32, %xmm0
	movslq	%edx, %rax
	pmuludq	%xmm1, %xmm2
	psrlq	$32, %xmm1
	pmuludq	%xmm0, %xmm1
	pshufd	$8, %xmm2, %xmm2
	pshufd	$8, %xmm1, %xmm0
	punpckldq	%xmm0, %xmm2
	movdqa	%xmm2, %xmm1
	movdqa	%xmm2, %xmm0
	psrldq	$4, %xmm1
	pmuludq	%xmm1, %xmm0
	movd	%xmm0, %edi
	cmpq	%rdx, %r8
	je	.L1109
.L1107:
	addq	$1, %rax
	.p2align 4,,10
	.p2align 3
.L1110:
	imull	(%r10,%rdx,4), %edi
	movq	%rax, %rdx
	addq	$1, %rax
	cmpq	%r8, %rdx
	jb	.L1110
.L1109:
	salq	$2, %r8
	xorl	%ecx, %ecx
	xorl	%r12d, %r12d
	movl	$1, %esi
	.p2align 4,,10
	.p2align 3
.L1111:
	imull	(%r10,%rcx), %esi
	movl	%edi, %eax
	cltd
	idivl	%esi
	imull	(%r9,%rcx), %eax
	addq	$4, %rcx
	addl	%eax, %r12d
	cmpq	%rcx, %r8
	jne	.L1111
.L1105:
	movq	%r9, %rdi
	call	_ZdlPv@PLT
.L1112:
	movl	%r12d, %eax
	movq	(%rbx), %rbx
	leaq	128(%rsp), %r12
	xorl	%esi, %esi
	cltd
	pxor	%xmm0, %xmm0
	movq	%r12, %rdi
	idivl	4(%rbx)
	movaps	%xmm0, 128(%rsp)
	movq	$0, 144(%rsp)
	movl	%edx, 88(%rsp)
	subl	%eax, %edx
	movl	%edx, 92(%rsp)
	leaq	92(%rsp), %rdx
.LEHB74:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movl	92(%rsp), %eax
	testl	%eax, %eax
	jle	.L1196
	movl	88(%rsp), %ebx
	movq	24(%rsp), %rsi
	movq	%r12, %rdi
	subl	%eax, %ebx
	movl	%ebx, 160(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE74:
.L1115:
	testq	%r13, %r13
	je	.L1117
	movq	%r13, %rdi
	call	_ZdlPv@PLT
.L1117:
	movq	16(%rbp), %rbx
	movq	8(%rbx), %rax
	movq	(%rbx), %rsi
	movq	%rax, %rdi
	subq	%rsi, %rdi
	movq	%rdi, %rdx
	sarq	$2, %rdx
	je	.L1152
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L1102
	call	_Znwm@PLT
	movq	(%rbx), %rsi
	movq	%rax, %r8
	movq	8(%rbx), %rax
	movq	%rax, %rdi
	subq	%rsi, %rdi
.L1120:
	cmpq	%rsi, %rax
	je	.L1121
	movq	%rdi, %rdx
	movq	%r8, %rdi
	call	memmove@PLT
	movq	%rax, %r8
.L1121:
	movq	128(%rsp), %rax
	movl	(%r8), %r13d
	movl	(%rax), %edx
	leal	(%rdx,%r13), %eax
	testl	%edx, %edx
	js	.L1123
	movl	4(%r8), %eax
	je	.L1124
	subl	%edx, %eax
.L1123:
	cmpl	%r13d, %eax
	jg	.L1125
	cmpl	%eax, 4(%r8)
	cmovle	4(%r8), %eax
	movl	%eax, %r13d
.L1125:
	movq	%r8, %rdi
	call	_ZdlPv@PLT
	movq	8(%rsp), %rax
	movq	32(%rsp), %rbx
	movq	24(%rbp), %r14
	movq	128(%rsp), %rdi
	movss	(%rbx,%rax,4), %xmm0
	movq	40(%rsp), %rbx
	leaq	64(%r14), %rcx
	movl	4(%rdi), %esi
	movl	(%rdi), %r12d
	movss	(%rbx,%rax,4), %xmm1
	movq	72(%r14), %rax
	movq	%rcx, %rdx
	testq	%rax, %rax
	jne	.L1126
	jmp	.L1197
	.p2align 4,,10
	.p2align 3
.L1198:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	je	.L1128
.L1126:
	cmpl	32(%rax), %r12d
	jle	.L1198
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1126
.L1128:
	movslq	%esi, %rax
	leaq	0(,%rax,4), %rbx
	cmpq	%rdx, %rcx
	je	.L1127
	cmpl	32(%rdx), %r12d
	jge	.L1131
.L1127:
	movslq	%r13d, %rdi
	movl	$4, %esi
	movss	%xmm1, 76(%rsp)
	movss	%xmm0, 72(%rsp)
	movq	%rdi, 64(%rsp)
	call	calloc@PLT
	movq	64(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, 56(%rsp)
	call	calloc@PLT
	movq	56(%rsp), %rcx
	movss	72(%rsp), %xmm0
	leaq	56(%r14), %rdi
	movss	76(%rsp), %xmm1
	movq	%rax, %xmm3
	movq	24(%rsp), %rsi
	movl	%r12d, 160(%rsp)
	movss	%xmm0, (%rax,%rbx)
	movq	%rcx, %xmm0
	punpcklqdq	%xmm3, %xmm0
	movss	%xmm1, (%rcx,%rbx)
	movl	%r12d, 168(%rsp)
	movl	%r13d, 172(%rsp)
	movaps	%xmm0, 176(%rsp)
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1132
.L1133:
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1134
	call	_ZdlPv@PLT
.L1134:
	testq	%r15, %r15
	je	.L1135
	movq	%r15, %rdi
	call	_ZdlPv@PLT
	addq	$1, 8(%rsp)
	movq	8(%rsp), %rax
	cmpl	%eax, 20(%rsp)
	jle	.L1068
.L1136:
	movq	32(%rbp), %rax
	movq	(%rax), %r12
	jmp	.L1137
.L1135:
	addq	$1, 8(%rsp)
	movq	8(%rsp), %rax
	cmpl	%eax, 20(%rsp)
	jg	.L1136
	.p2align 4,,10
	.p2align 3
.L1068:
	movq	200(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1199
	addq	$216, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1076:
	.cfi_restore_state
	movl	$14, %edx
	leaq	.LC30(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB75:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%r14d, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	84(%rsp), %esi
	movq	%rbp, %rdi
	call	_ZNSolsEi@PLT
	movl	$21, %edx
	leaq	.LC31(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%r13), %rax
	movq	%rbp, %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%r13), %rax
	movq	%rbp, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r12
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%r12), %rax
	movq	-24(%rax), %rax
	movq	240(%r12,%rax), %rbp
	testq	%rbp, %rbp
	je	.L1200
	cmpb	$0, 56(%rbp)
	je	.L1079
	movsbl	67(%rbp), %esi
.L1080:
	movq	%r12, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movl	$9, %edx
	leaq	.LC32(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	160(%rsp), %rax
	leaq	_ZSt4cout(%rip), %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	160(%rsp), %rax
	movq	%rbp, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$21, %edx
	leaq	.LC31(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%r13), %rax
	movq	%rbp, %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%r13), %rax
	movq	%rbp, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %r12
	testq	%r12, %r12
	je	.L1201
	cmpb	$0, 56(%r12)
	je	.L1082
	movsbl	67(%r12), %esi
.L1083:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	jmp	.L1182
	.p2align 4,,10
	.p2align 3
.L1069:
	addl	$1, %eax
	xorl	%edx, %edx
	jmp	.L1141
.L1082:
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L1083
	movq	%r12, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L1083
.L1079:
	movq	%rbp, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%rbp), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L1080
	movq	%rbp, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L1080
.L1147:
	xorl	%r15d, %r15d
.L1088:
	movq	%r8, %rdi
	call	_ZdlPv@PLT
	jmp	.L1091
.L1131:
	movq	56(%rdx), %rcx
	movq	48(%rdx), %rdx
	movss	%xmm1, (%rdx,%rax,4)
	movss	%xmm0, (%rcx,%rax,4)
.L1132:
	call	_ZdlPv@PLT
	jmp	.L1133
.L1191:
	movq	24(%rsp), %rbx
	movl	%r14d, %eax
	leaq	128(%rsp), %r12
	negl	%eax
	movq	%r12, %rsi
	movq	%rbx, %rdi
	movl	%eax, 128(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	%r12, %rsi
	movq	%rbx, %rdi
	movl	$0, 128(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	jmp	.L1075
.L1103:
	movq	24(%rbx), %r10
	movq	32(%rbx), %r8
	subq	%r10, %r8
	sarq	$2, %r8
	jne	.L1104
	xorl	%r12d, %r12d
	testq	%r9, %r9
	je	.L1112
	jmp	.L1105
	.p2align 4,,10
	.p2align 3
.L1196:
	movq	136(%rsp), %rsi
	cmpq	144(%rsp), %rsi
	je	.L1114
	movl	88(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 136(%rsp)
	jmp	.L1115
.L1124:
	cmpl	%eax, %r13d
	cmovle	%r13d, %eax
	jmp	.L1123
.L1152:
	xorl	%r8d, %r8d
	jmp	.L1120
.L1190:
	leaq	84(%rsp), %r12
	movq	24(%rsp), %rdi
	xorl	%esi, %esi
	movq	%r12, %rdx
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	168(%rsp), %rsi
	cmpq	176(%rsp), %rsi
	je	.L1072
	movl	84(%rsp), %eax
	movq	160(%rsp), %r8
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movl	(%r8), %eax
	movq	%rsi, 168(%rsp)
	jmp	.L1073
.L1072:
	movq	24(%rsp), %rdi
	movq	%r12, %rdx
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE75:
	movq	160(%rsp), %r8
	movl	(%r8), %eax
	jmp	.L1073
.L1097:
	movq	24(%rbp), %rbx
	movq	%rdi, %r14
	xorl	%r13d, %r13d
	cmpq	%r8, %rsi
	jne	.L1142
.L1143:
	movq	%rdi, %r12
	xorl	%r13d, %r13d
	xorl	%r9d, %r9d
	jmp	.L1101
.L1149:
	xorl	%r9d, %r9d
	jmp	.L1101
.L1193:
	movq	24(%rbp), %rbx
	xorl	%r14d, %r14d
	xorl	%edi, %edi
	jmp	.L1143
.L1197:
	movslq	%esi, %rax
	leaq	0(,%rax,4), %rbx
	jmp	.L1127
.L1150:
	movl	$1, %edi
	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	.L1107
.L1114:
	leaq	88(%rsp), %rdx
	movq	%r12, %rdi
.LEHB76:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE76:
	jmp	.L1115
.L1102:
	call	_ZSt17__throw_bad_allocv@PLT
.L1195:
	xorl	%r12d, %r12d
	jmp	.L1105
.L1200:
.LEHB77:
	call	_ZSt16__throw_bad_castv@PLT
.L1201:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE77:
.L1199:
	call	__stack_chk_fail@PLT
.L1192:
	leaq	.LC2(%rip), %rdi
.LEHB78:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE78:
.L1158:
	endbr64
	jmp	.L1118
.L1155:
	endbr64
	jmp	.L1085
.L1180:
	endbr64
	jmp	.L1085
	.section	.gcc_except_table
.LLSDA9909:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE9909-.LLSDACSB9909
.LLSDACSB9909:
	.uleb128 .LEHB72-.LFB9909
	.uleb128 .LEHE72-.LEHB72
	.uleb128 .L1180-.LFB9909
	.uleb128 0
	.uleb128 .LEHB73-.LFB9909
	.uleb128 .LEHE73-.LEHB73
	.uleb128 .L1155-.LFB9909
	.uleb128 0
	.uleb128 .LEHB74-.LFB9909
	.uleb128 .LEHE74-.LEHB74
	.uleb128 .L1158-.LFB9909
	.uleb128 0
	.uleb128 .LEHB75-.LFB9909
	.uleb128 .LEHE75-.LEHB75
	.uleb128 .L1180-.LFB9909
	.uleb128 0
	.uleb128 .LEHB76-.LFB9909
	.uleb128 .LEHE76-.LEHB76
	.uleb128 .L1158-.LFB9909
	.uleb128 0
	.uleb128 .LEHB77-.LFB9909
	.uleb128 .LEHE77-.LEHB77
	.uleb128 .L1180-.LFB9909
	.uleb128 0
	.uleb128 .LEHB78-.LFB9909
	.uleb128 .LEHE78-.LEHB78
	.uleb128 .L1155-.LFB9909
	.uleb128 0
.LLSDACSE9909:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC9909
	.type	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0.cold, @function
_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0.cold:
.LFSB9909:
.L1118:
	.cfi_def_cfa_offset 272
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1096
.L1188:
	call	_ZdlPv@PLT
.L1096:
	call	_ZSt9terminatev@PLT
.L1156:
	endbr64
.L1085:
	movq	160(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1188
	jmp	.L1096
.L1182:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC33(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
.LEHB79:
	call	_ZNSt12length_errorC1EPKc@PLT
.LEHE79:
	movq	_ZNSt12length_errorD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt12length_error(%rip), %rsi
	movq	%rbp, %rdi
.LEHB80:
	call	__cxa_throw@PLT
.LEHE80:
.L1157:
	endbr64
	movq	%rbp, %rdi
	call	__cxa_free_exception@PLT
	jmp	.L1085
	.cfi_endproc
.LFE9909:
	.section	.gcc_except_table
.LLSDAC9909:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC9909-.LLSDACSBC9909
.LLSDACSBC9909:
	.uleb128 .LEHB79-.LCOLDB37
	.uleb128 .LEHE79-.LEHB79
	.uleb128 .L1157-.LCOLDB37
	.uleb128 0
	.uleb128 .LEHB80-.LCOLDB37
	.uleb128 .LEHE80-.LEHB80
	.uleb128 .L1156-.LCOLDB37
	.uleb128 0
.LLSDACSEC9909:
	.section	.text.unlikely
	.text
	.size	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0, .-_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0
	.section	.text.unlikely
	.size	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0.cold, .-_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0.cold
.LCOLDE37:
	.text
.LHOTE37:
	.section	.text._ZNSt6vectorI11denseMatrixSaIS0_EE17_M_realloc_insertIJRKS0_EEEvN9__gnu_cxx17__normal_iteratorIPS0_S2_EEDpOT_,"axG",@progbits,_ZNSt6vectorI11denseMatrixSaIS0_EE17_M_realloc_insertIJRKS0_EEEvN9__gnu_cxx17__normal_iteratorIPS0_S2_EEDpOT_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorI11denseMatrixSaIS0_EE17_M_realloc_insertIJRKS0_EEEvN9__gnu_cxx17__normal_iteratorIPS0_S2_EEDpOT_
	.type	_ZNSt6vectorI11denseMatrixSaIS0_EE17_M_realloc_insertIJRKS0_EEEvN9__gnu_cxx17__normal_iteratorIPS0_S2_EEDpOT_, @function
_ZNSt6vectorI11denseMatrixSaIS0_EE17_M_realloc_insertIJRKS0_EEEvN9__gnu_cxx17__normal_iteratorIPS0_S2_EEDpOT_:
.LFB9377:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA9377
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdx, %r12
	movabsq	$-8198552921648689607, %rdx
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	8(%rdi), %r13
	movq	(%rdi), %r14
	movq	%r13, %rax
	subq	%r14, %rax
	sarq	$3, %rax
	imulq	%rdx, %rax
	movabsq	$128102389400760775, %rdx
	cmpq	%rdx, %rax
	je	.L1244
	movq	%rsi, %rbp
	movq	%rdi, %r15
	movq	%rsi, %rbx
	subq	%r14, %rbp
	testq	%rax, %rax
	je	.L1229
	leaq	(%rax,%rax), %rsi
	movq	%rsi, 16(%rsp)
	cmpq	%rsi, %rax
	jbe	.L1245
	movabsq	$9223372036854775800, %rax
	movq	%rax, 16(%rsp)
.L1204:
	movq	16(%rsp), %rdi
.LEHB81:
	call	_Znwm@PLT
.LEHE81:
	movq	%rax, 8(%rsp)
.L1228:
	movq	8(%r12), %rdx
	movq	(%r12), %rsi
	pxor	%xmm0, %xmm0
	addq	8(%rsp), %rbp
	movq	%rdx, %rax
	movq	$0, 16(%rbp)
	subq	%rsi, %rax
	movups	%xmm0, 0(%rbp)
	movq	%rax, 24(%rsp)
	sarq	$2, %rax
	je	.L1246
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1247
	movq	24(%rsp), %rdi
.LEHB82:
	call	_Znwm@PLT
.LEHE82:
	movq	8(%r12), %rdx
	movq	(%r12), %rsi
	movq	%rax, %rcx
	movq	%rdx, %r8
	subq	%rsi, %r8
.L1207:
	movq	24(%rsp), %rax
	movq	%rcx, %xmm0
	punpcklqdq	%xmm0, %xmm0
	addq	%rcx, %rax
	movups	%xmm0, 0(%rbp)
	movq	%rax, 16(%rbp)
	cmpq	%rsi, %rdx
	je	.L1209
	movq	%r8, %rdx
	movq	%rcx, %rdi
	movq	%r8, 24(%rsp)
	call	memmove@PLT
	movq	24(%rsp), %r8
	movq	%rax, %rcx
.L1209:
	movq	32(%r12), %rdx
	movq	24(%r12), %rsi
	addq	%r8, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%rbp)
	movq	%rdx, %rax
	movq	$0, 40(%rbp)
	subq	%rsi, %rax
	movups	%xmm0, 24(%rbp)
	movq	%rax, 24(%rsp)
	sarq	$2, %rax
	je	.L1248
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1249
	movq	24(%rsp), %rdi
.LEHB83:
	call	_Znwm@PLT
	movq	32(%r12), %rdx
	movq	24(%r12), %rsi
	movq	%rax, %rcx
	movq	%rdx, %r8
	subq	%rsi, %r8
.L1211:
	movq	24(%rsp), %rax
	movq	%rcx, %xmm0
	punpcklqdq	%xmm0, %xmm0
	addq	%rcx, %rax
	movups	%xmm0, 24(%rbp)
	movq	%rax, 40(%rbp)
	cmpq	%rsi, %rdx
	je	.L1213
	movq	%r8, %rdx
	movq	%rcx, %rdi
	movq	%r8, 24(%rsp)
	call	memmove@PLT
	movq	24(%rsp), %r8
	movq	%rax, %rcx
.L1213:
	movl	48(%r12), %eax
	movdqu	56(%r12), %xmm6
	addq	%r8, %rcx
	movq	%rcx, 32(%rbp)
	movl	%eax, 48(%rbp)
	movups	%xmm6, 56(%rbp)
	cmpq	%r14, %rbx
	je	.L1231
	movq	8(%rsp), %r12
	movq	%r14, %rbp
	pxor	%xmm0, %xmm0
	.p2align 4,,10
	.p2align 3
.L1215:
	movq	0(%rbp), %rax
	movdqu	56(%rbp), %xmm1
	movq	%rax, (%r12)
	movq	8(%rbp), %rax
	movq	%rax, 8(%r12)
	movq	16(%rbp), %rax
	movq	%rax, 16(%r12)
	movq	24(%rbp), %rax
	movups	%xmm0, 0(%rbp)
	movq	$0, 16(%rbp)
	movq	%rax, 24(%r12)
	movq	32(%rbp), %rax
	movq	%rax, 32(%r12)
	movq	40(%rbp), %rax
	movq	%rax, 40(%r12)
	movl	48(%rbp), %eax
	movq	0(%rbp), %rdi
	movups	%xmm1, 56(%r12)
	movl	%eax, 48(%r12)
	testq	%rdi, %rdi
	je	.L1219
	call	_ZdlPv@PLT
	addq	$72, %rbp
	addq	$72, %r12
	pxor	%xmm0, %xmm0
	cmpq	%rbp, %rbx
	jne	.L1215
.L1220:
	leaq	-72(%rbx), %rax
	movq	8(%rsp), %rsi
	subq	%r14, %rax
	shrq	$3, %rax
	leaq	72(%rsi,%rax,8), %rbp
.L1214:
	addq	$72, %rbp
	cmpq	%r13, %rbx
	je	.L1222
	movq	%rbx, %rax
	movq	%rbp, %rdx
	.p2align 4,,10
	.p2align 3
.L1223:
	movdqu	(%rax), %xmm2
	movl	48(%rax), %ecx
	addq	$72, %rax
	addq	$72, %rdx
	movdqu	-56(%rax), %xmm3
	movdqu	-40(%rax), %xmm4
	movdqu	-16(%rax), %xmm5
	movups	%xmm2, -72(%rdx)
	movups	%xmm3, -56(%rdx)
	movups	%xmm4, -40(%rdx)
	movl	%ecx, -24(%rdx)
	movups	%xmm5, -16(%rdx)
	cmpq	%r13, %rax
	jne	.L1223
	subq	%rbx, %rax
	subq	$72, %rax
	shrq	$3, %rax
	leaq	72(%rbp,%rax,8), %rbp
.L1222:
	testq	%r14, %r14
	je	.L1224
	movq	%r14, %rdi
	call	_ZdlPv@PLT
.L1224:
	movq	8(%rsp), %rax
	movq	%rbp, %xmm7
	movq	%rax, %xmm0
	addq	16(%rsp), %rax
	punpcklqdq	%xmm7, %xmm0
	movq	%rax, 16(%r15)
	movups	%xmm0, (%r15)
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1245:
	.cfi_restore_state
	testq	%rsi, %rsi
	jne	.L1205
	movq	$0, 8(%rsp)
	jmp	.L1228
	.p2align 4,,10
	.p2align 3
.L1219:
	addq	$72, %rbp
	addq	$72, %r12
	cmpq	%rbp, %rbx
	jne	.L1215
	jmp	.L1220
	.p2align 4,,10
	.p2align 3
.L1229:
	movq	$72, 16(%rsp)
	jmp	.L1204
	.p2align 4,,10
	.p2align 3
.L1246:
	movq	24(%rsp), %r8
	xorl	%ecx, %ecx
	jmp	.L1207
	.p2align 4,,10
	.p2align 3
.L1248:
	movq	24(%rsp), %r8
	xorl	%ecx, %ecx
	jmp	.L1211
	.p2align 4,,10
	.p2align 3
.L1231:
	movq	8(%rsp), %rbp
	jmp	.L1214
.L1249:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE83:
.L1205:
	movq	16(%rsp), %rax
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	imulq	$72, %rdx, %rax
	movq	%rax, 16(%rsp)
	jmp	.L1204
.L1244:
	leaq	.LC27(%rip), %rdi
.LEHB84:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE84:
.L1247:
.LEHB85:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE85:
.L1232:
	endbr64
	movq	%rax, %rdi
	jmp	.L1218
.L1234:
	endbr64
	movq	%rax, %rbx
.L1216:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L1217
	call	_ZdlPv@PLT
.L1217:
	movq	%rbx, %rdi
.L1218:
	call	__cxa_begin_catch@PLT
	cmpq	$0, 8(%rsp)
	je	.L1250
	movq	8(%rsp), %rdi
	call	_ZdlPv@PLT
.L1227:
.LEHB86:
	call	__cxa_rethrow@PLT
.LEHE86:
.L1250:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	jmp	.L1227
.L1233:
	endbr64
	movq	%rax, %rbp
.L1226:
	call	__cxa_end_catch@PLT
	movq	%rbp, %rdi
.LEHB87:
	call	_Unwind_Resume@PLT
.LEHE87:
	.cfi_endproc
.LFE9377:
	.section	.gcc_except_table
	.align 4
.LLSDA9377:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT9377-.LLSDATTD9377
.LLSDATTD9377:
	.byte	0x1
	.uleb128 .LLSDACSE9377-.LLSDACSB9377
.LLSDACSB9377:
	.uleb128 .LEHB81-.LFB9377
	.uleb128 .LEHE81-.LEHB81
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB82-.LFB9377
	.uleb128 .LEHE82-.LEHB82
	.uleb128 .L1232-.LFB9377
	.uleb128 0x1
	.uleb128 .LEHB83-.LFB9377
	.uleb128 .LEHE83-.LEHB83
	.uleb128 .L1234-.LFB9377
	.uleb128 0x3
	.uleb128 .LEHB84-.LFB9377
	.uleb128 .LEHE84-.LEHB84
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB85-.LFB9377
	.uleb128 .LEHE85-.LEHB85
	.uleb128 .L1232-.LFB9377
	.uleb128 0x1
	.uleb128 .LEHB86-.LFB9377
	.uleb128 .LEHE86-.LEHB86
	.uleb128 .L1233-.LFB9377
	.uleb128 0
	.uleb128 .LEHB87-.LFB9377
	.uleb128 .LEHE87-.LEHB87
	.uleb128 0
	.uleb128 0
.LLSDACSE9377:
	.byte	0x1
	.byte	0
	.byte	0
	.byte	0x7d
	.align 4
	.long	0

.LLSDATT9377:
	.section	.text._ZNSt6vectorI11denseMatrixSaIS0_EE17_M_realloc_insertIJRKS0_EEEvN9__gnu_cxx17__normal_iteratorIPS0_S2_EEDpOT_,"axG",@progbits,_ZNSt6vectorI11denseMatrixSaIS0_EE17_M_realloc_insertIJRKS0_EEEvN9__gnu_cxx17__normal_iteratorIPS0_S2_EEDpOT_,comdat
	.size	_ZNSt6vectorI11denseMatrixSaIS0_EE17_M_realloc_insertIJRKS0_EEEvN9__gnu_cxx17__normal_iteratorIPS0_S2_EEDpOT_, .-_ZNSt6vectorI11denseMatrixSaIS0_EE17_M_realloc_insertIJRKS0_EEEvN9__gnu_cxx17__normal_iteratorIPS0_S2_EEDpOT_
	.section	.text._ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_,"axG",@progbits,_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	.type	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_, @function
_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_:
.LFB9130:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA9130
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movq	%rdi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	8(%rdi), %rbp
	cmpq	16(%rdi), %rbp
	je	.L1252
	movq	8(%rsi), %rbx
	subq	(%rsi), %rbx
	pxor	%xmm0, %xmm0
	movq	$0, 16(%rbp)
	movq	%rbx, %rax
	movups	%xmm0, 0(%rbp)
	sarq	$2, %rax
	je	.L1272
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1273
	movq	%rbx, %rdi
.LEHB88:
	call	_Znwm@PLT
.LEHE88:
	movq	%rax, %rcx
.L1254:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 16(%rbp)
	movups	%xmm0, 0(%rbp)
	movq	8(%r12), %rax
	movq	(%r12), %rsi
	movq	%rax, %rbx
	subq	%rsi, %rbx
	cmpq	%rsi, %rax
	je	.L1257
	movq	%rcx, %rdi
	movq	%rbx, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1257:
	addq	%rbx, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%rbp)
	movq	32(%r12), %rbx
	subq	24(%r12), %rbx
	movq	$0, 40(%rbp)
	movq	%rbx, %rax
	movups	%xmm0, 24(%rbp)
	sarq	$2, %rax
	je	.L1274
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1275
	movq	%rbx, %rdi
.LEHB89:
	call	_Znwm@PLT
.LEHE89:
	movq	%rax, %rcx
.L1259:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 40(%rbp)
	movups	%xmm0, 24(%rbp)
	movq	32(%r12), %rax
	movq	24(%r12), %rsi
	movq	%rax, %rbx
	subq	%rsi, %rbx
	cmpq	%rsi, %rax
	je	.L1262
	movq	%rcx, %rdi
	movq	%rbx, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1262:
	movl	48(%r12), %eax
	movdqu	56(%r12), %xmm1
	addq	%rbx, %rcx
	movq	%rcx, 32(%rbp)
	movl	%eax, 48(%rbp)
	movups	%xmm1, 56(%rbp)
	addq	$72, 8(%r13)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1272:
	.cfi_restore_state
	xorl	%ecx, %ecx
	jmp	.L1254
	.p2align 4,,10
	.p2align 3
.L1252:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movq	%rsi, %rdx
	movq	%rbp, %rsi
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
.LEHB90:
	jmp	_ZNSt6vectorI11denseMatrixSaIS0_EE17_M_realloc_insertIJRKS0_EEEvN9__gnu_cxx17__normal_iteratorIPS0_S2_EEDpOT_
	.p2align 4,,10
	.p2align 3
.L1274:
	.cfi_restore_state
	xorl	%ecx, %ecx
	jmp	.L1259
.L1273:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE90:
.L1275:
.LEHB91:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE91:
.L1266:
	endbr64
	movq	%rax, %r12
.L1264:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L1265
	call	_ZdlPv@PLT
.L1265:
	movq	%r12, %rdi
.LEHB92:
	call	_Unwind_Resume@PLT
.LEHE92:
	.cfi_endproc
.LFE9130:
	.section	.gcc_except_table
.LLSDA9130:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE9130-.LLSDACSB9130
.LLSDACSB9130:
	.uleb128 .LEHB88-.LFB9130
	.uleb128 .LEHE88-.LEHB88
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB89-.LFB9130
	.uleb128 .LEHE89-.LEHB89
	.uleb128 .L1266-.LFB9130
	.uleb128 0
	.uleb128 .LEHB90-.LFB9130
	.uleb128 .LEHE90-.LEHB90
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB91-.LFB9130
	.uleb128 .LEHE91-.LEHB91
	.uleb128 .L1266-.LFB9130
	.uleb128 0
	.uleb128 .LEHB92-.LFB9130
	.uleb128 .LEHE92-.LEHB92
	.uleb128 0
	.uleb128 0
.LLSDACSE9130:
	.section	.text._ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_,"axG",@progbits,_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_,comdat
	.size	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_, .-_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	.section	.text._ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE17_M_realloc_insertIJRKS2_EEEvN9__gnu_cxx17__normal_iteratorIPS2_S4_EEDpOT_,"axG",@progbits,_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE17_M_realloc_insertIJRKS2_EEEvN9__gnu_cxx17__normal_iteratorIPS2_S4_EEDpOT_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE17_M_realloc_insertIJRKS2_EEEvN9__gnu_cxx17__normal_iteratorIPS2_S4_EEDpOT_
	.type	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE17_M_realloc_insertIJRKS2_EEEvN9__gnu_cxx17__normal_iteratorIPS2_S4_EEDpOT_, @function
_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE17_M_realloc_insertIJRKS2_EEEvN9__gnu_cxx17__normal_iteratorIPS2_S4_EEDpOT_:
.LFB9383:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA9383
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdx, %rbp
	movabsq	$-6148914691236517205, %rdx
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	movq	8(%rdi), %rax
	movq	(%rdi), %r13
	movq	%rdi, 56(%rsp)
	movq	%rax, 48(%rsp)
	subq	%r13, %rax
	sarq	$3, %rax
	movq	%rsi, 32(%rsp)
	imulq	%rdx, %rax
	movabsq	$384307168202282325, %rdx
	cmpq	%rdx, %rax
	je	.L1350
	movq	%rsi, %r15
	movq	%rsi, %r12
	subq	%r13, %r15
	testq	%rax, %rax
	je	.L1318
	leaq	(%rax,%rax), %rsi
	movq	%rsi, 24(%rsp)
	cmpq	%rsi, %rax
	jbe	.L1351
	movabsq	$9223372036854775800, %rax
	movq	%rax, 24(%rsp)
.L1278:
	movq	24(%rsp), %rdi
.LEHB93:
	call	_Znwm@PLT
.LEHE93:
	movq	%rax, 16(%rsp)
.L1317:
	movq	8(%rbp), %rax
	movq	0(%rbp), %rbx
	pxor	%xmm0, %xmm0
	movabsq	$-8198552921648689607, %rdx
	addq	16(%rsp), %r15
	movq	%rax, %r14
	movq	%rax, (%rsp)
	subq	%rbx, %r14
	movq	$0, 16(%r15)
	movq	%r14, %rax
	movups	%xmm0, (%r15)
	sarq	$3, %rax
	imulq	%rdx, %rax
	testq	%rax, %rax
	je	.L1352
	movabsq	$128102389400760775, %rdx
	cmpq	%rdx, %rax
	ja	.L1353
	movq	%r14, %rdi
.LEHB94:
	call	_Znwm@PLT
.LEHE94:
	movq	%rax, 40(%rsp)
	movq	8(%rbp), %rax
	movq	0(%rbp), %rbx
	movq	%rax, (%rsp)
.L1281:
	movq	40(%rsp), %rbp
	movq	%rbp, %xmm0
	addq	%rbp, %r14
	punpcklqdq	%xmm0, %xmm0
	movq	%r14, 16(%r15)
	movups	%xmm0, (%r15)
	cmpq	%rbx, (%rsp)
	jne	.L1294
	jmp	.L1283
	.p2align 4,,10
	.p2align 3
.L1284:
	movabsq	$2305843009213693951, %rdi
	cmpq	%rdi, %rax
	ja	.L1354
	movq	%r14, %rdi
.LEHB95:
	call	_Znwm@PLT
.LEHE95:
	movq	%rax, %rcx
.L1285:
	movq	%rcx, %xmm0
	addq	%rcx, %r14
	punpcklqdq	%xmm0, %xmm0
	movq	%r14, 16(%rbp)
	movups	%xmm0, 0(%rbp)
	movq	8(%rbx), %rax
	movq	(%rbx), %rsi
	movq	%rax, %r14
	subq	%rsi, %r14
	cmpq	%rsi, %rax
	je	.L1288
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1288:
	addq	%r14, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%rbp)
	movq	32(%rbx), %r14
	subq	24(%rbx), %r14
	movq	$0, 40(%rbp)
	movq	%r14, %rax
	movups	%xmm0, 24(%rbp)
	sarq	$2, %rax
	je	.L1355
	movabsq	$2305843009213693951, %rdi
	cmpq	%rdi, %rax
	ja	.L1356
	movq	%r14, %rdi
.LEHB96:
	call	_Znwm@PLT
	movq	%rax, %rcx
.L1290:
	movq	%rcx, %xmm0
	addq	%rcx, %r14
	punpcklqdq	%xmm0, %xmm0
	movq	%r14, 40(%rbp)
	movups	%xmm0, 24(%rbp)
	movq	32(%rbx), %rax
	movq	24(%rbx), %rsi
	movq	%rax, %r14
	subq	%rsi, %r14
	cmpq	%rsi, %rax
	je	.L1293
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1293:
	movl	48(%rbx), %eax
	movdqu	56(%rbx), %xmm2
	addq	%r14, %rcx
	addq	$72, %rbp
	movq	%rcx, -40(%rbp)
	addq	$72, %rbx
	movl	%eax, -24(%rbp)
	movups	%xmm2, -16(%rbp)
	cmpq	%rbx, (%rsp)
	je	.L1283
.L1294:
	movq	8(%rbx), %r14
	subq	(%rbx), %r14
	pxor	%xmm0, %xmm0
	movq	$0, 16(%rbp)
	movq	%r14, %rax
	movups	%xmm0, 0(%rbp)
	sarq	$2, %rax
	jne	.L1284
	xorl	%ecx, %ecx
	jmp	.L1285
	.p2align 4,,10
	.p2align 3
.L1351:
	testq	%rsi, %rsi
	jne	.L1279
	movq	$0, 16(%rsp)
	jmp	.L1317
	.p2align 4,,10
	.p2align 3
.L1355:
	xorl	%ecx, %ecx
	jmp	.L1290
	.p2align 4,,10
	.p2align 3
.L1283:
	movq	%rbp, 8(%r15)
	cmpq	%r13, %r12
	je	.L1357
	leaq	-24(%r12), %rax
	movq	16(%rsp), %rbx
	movq	%r13, %rdx
	movabsq	$768614336404564651, %rcx
	subq	%r13, %rax
	shrq	$3, %rax
	imulq	%rcx, %rax
	leaq	47(%rbx), %rcx
	subq	%r13, %rcx
	cmpq	$94, %rcx
	jbe	.L1322
	movabsq	$2305843009213693950, %rcx
	testq	%rcx, %rax
	je	.L1322
	movabsq	$2305843009213693951, %rsi
	movq	%rbx, %rcx
	andq	%rax, %rsi
	addq	$1, %rsi
	movq	%rsi, %rdi
	shrq	%rdi
	leaq	(%rdi,%rdi,2), %rdi
	salq	$4, %rdi
	addq	%r13, %rdi
	.p2align 4,,10
	.p2align 3
.L1306:
	movdqu	16(%rdx), %xmm1
	movdqu	(%rdx), %xmm3
	addq	$48, %rdx
	addq	$48, %rcx
	movdqu	-16(%rdx), %xmm0
	movups	%xmm3, -48(%rcx)
	movups	%xmm1, -32(%rcx)
	movups	%xmm0, -16(%rcx)
	cmpq	%rdi, %rdx
	jne	.L1306
	movq	%rsi, %rcx
	andq	$-2, %rcx
	leaq	(%rcx,%rcx,2), %rdx
	salq	$3, %rdx
	leaq	0(%r13,%rdx), %rdi
	addq	16(%rsp), %rdx
	cmpq	%rcx, %rsi
	je	.L1308
	movq	16(%rdi), %rcx
	movdqu	(%rdi), %xmm4
	movq	%rcx, 16(%rdx)
	movups	%xmm4, (%rdx)
.L1308:
	movq	16(%rsp), %rbx
	leaq	(%rax,%rax,2), %rax
	leaq	24(%rbx,%rax,8), %rbx
.L1298:
	movq	48(%rsp), %rax
	addq	$24, %rbx
	cmpq	%rax, %r12
	je	.L1309
	movabsq	$768614336404564651, %rcx
	subq	%r12, %rax
	movq	%r12, %rdx
	subq	$24, %rax
	shrq	$3, %rax
	imulq	%rcx, %rax
	movabsq	$2305843009213693951, %rcx
	andq	%rcx, %rax
	leaq	1(%rax), %rcx
	movq	%rbx, %rax
	je	.L1310
	movq	%rcx, %rsi
	shrq	%rsi
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%r12, %rsi
	.p2align 4,,10
	.p2align 3
.L1311:
	movdqu	(%rdx), %xmm6
	movdqu	16(%rdx), %xmm7
	addq	$48, %rdx
	addq	$48, %rax
	movdqu	-16(%rdx), %xmm1
	movups	%xmm6, -48(%rax)
	movups	%xmm7, -32(%rax)
	movups	%xmm1, -16(%rax)
	cmpq	%rsi, %rdx
	jne	.L1311
	movq	%rcx, %rdx
	andq	$-2, %rdx
	leaq	(%rdx,%rdx,2), %rax
	salq	$3, %rax
	leaq	(%r12,%rax), %rdi
	addq	%rbx, %rax
	movq	%rdi, 32(%rsp)
	cmpq	%rcx, %rdx
	je	.L1312
.L1310:
	movq	32(%rsp), %rdi
	movq	16(%rdi), %rdx
	movdqu	(%rdi), %xmm2
	movq	%rdx, 16(%rax)
	movaps	%xmm2, (%rsp)
	movups	%xmm2, (%rax)
.L1312:
	leaq	(%rcx,%rcx,2), %rax
	leaq	(%rbx,%rax,8), %rbx
.L1309:
	testq	%r13, %r13
	je	.L1313
	movq	%r13, %rdi
	call	_ZdlPv@PLT
.L1313:
	movq	16(%rsp), %rax
	movq	%rbx, %xmm4
	movq	56(%rsp), %rbx
	movq	%rax, %xmm0
	addq	24(%rsp), %rax
	punpcklqdq	%xmm4, %xmm0
	movq	%rax, 16(%rbx)
	movups	%xmm0, (%rbx)
	addq	$72, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1318:
	.cfi_restore_state
	movq	$24, 24(%rsp)
	jmp	.L1278
	.p2align 4,,10
	.p2align 3
.L1352:
	movq	$0, 40(%rsp)
	jmp	.L1281
	.p2align 4,,10
	.p2align 3
.L1322:
	movq	16(%rsp), %rcx
	movq	%r13, %rdx
	.p2align 4,,10
	.p2align 3
.L1305:
	movdqu	(%rdx), %xmm5
	addq	$24, %rdx
	addq	$24, %rcx
	movups	%xmm5, -24(%rcx)
	movq	-8(%rdx), %rsi
	movq	%rsi, -8(%rcx)
	cmpq	%rdx, %r12
	jne	.L1305
	jmp	.L1308
	.p2align 4,,10
	.p2align 3
.L1357:
	movq	16(%rsp), %rbx
	jmp	.L1298
.L1356:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE96:
.L1354:
.LEHB97:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE97:
.L1350:
	leaq	.LC27(%rip), %rdi
.LEHB98:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE98:
.L1353:
.LEHB99:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE99:
.L1279:
	movq	24(%rsp), %rax
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	imulq	$24, %rdx, %rax
	movq	%rax, 24(%rsp)
	jmp	.L1278
.L1324:
	endbr64
	movq	%rax, %rdi
	jmp	.L1304
.L1327:
	endbr64
	movq	%rax, %rdi
	jmp	.L1297
.L1328:
	endbr64
	movq	%rax, %rbx
	jmp	.L1295
.L1302:
	call	__cxa_end_catch@PLT
	movq	(%r15), %rdi
	testq	%rdi, %rdi
	je	.L1303
	call	_ZdlPv@PLT
.L1303:
	movq	%rbx, %rdi
.L1304:
	call	__cxa_begin_catch@PLT
	cmpq	$0, 16(%rsp)
	je	.L1358
	movq	16(%rsp), %rdi
	call	_ZdlPv@PLT
.L1316:
.LEHB100:
	call	__cxa_rethrow@PLT
.LEHE100:
.L1295:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L1296
	call	_ZdlPv@PLT
.L1296:
	movq	%rbx, %rdi
.L1297:
	call	__cxa_begin_catch@PLT
	movq	40(%rsp), %rbx
.L1301:
	cmpq	%rbx, %rbp
	jne	.L1359
.LEHB101:
	call	__cxa_rethrow@PLT
.LEHE101:
.L1358:
	movq	%r15, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	jmp	.L1316
.L1325:
	endbr64
	movq	%rax, %rbp
	jmp	.L1315
.L1359:
	movq	%rbx, %rdi
	addq	$72, %rbx
	call	_ZN11denseMatrixD1Ev
	jmp	.L1301
.L1315:
	call	__cxa_end_catch@PLT
	movq	%rbp, %rdi
.LEHB102:
	call	_Unwind_Resume@PLT
.LEHE102:
.L1326:
	endbr64
	movq	%rax, %rbx
	jmp	.L1302
	.cfi_endproc
.LFE9383:
	.section	.gcc_except_table
	.align 4
.LLSDA9383:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT9383-.LLSDATTD9383
.LLSDATTD9383:
	.byte	0x1
	.uleb128 .LLSDACSE9383-.LLSDACSB9383
.LLSDACSB9383:
	.uleb128 .LEHB93-.LFB9383
	.uleb128 .LEHE93-.LEHB93
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB94-.LFB9383
	.uleb128 .LEHE94-.LEHB94
	.uleb128 .L1324-.LFB9383
	.uleb128 0x1
	.uleb128 .LEHB95-.LFB9383
	.uleb128 .LEHE95-.LEHB95
	.uleb128 .L1327-.LFB9383
	.uleb128 0x1
	.uleb128 .LEHB96-.LFB9383
	.uleb128 .LEHE96-.LEHB96
	.uleb128 .L1328-.LFB9383
	.uleb128 0x1
	.uleb128 .LEHB97-.LFB9383
	.uleb128 .LEHE97-.LEHB97
	.uleb128 .L1327-.LFB9383
	.uleb128 0x1
	.uleb128 .LEHB98-.LFB9383
	.uleb128 .LEHE98-.LEHB98
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB99-.LFB9383
	.uleb128 .LEHE99-.LEHB99
	.uleb128 .L1324-.LFB9383
	.uleb128 0x1
	.uleb128 .LEHB100-.LFB9383
	.uleb128 .LEHE100-.LEHB100
	.uleb128 .L1325-.LFB9383
	.uleb128 0
	.uleb128 .LEHB101-.LFB9383
	.uleb128 .LEHE101-.LEHB101
	.uleb128 .L1326-.LFB9383
	.uleb128 0x3
	.uleb128 .LEHB102-.LFB9383
	.uleb128 .LEHE102-.LEHB102
	.uleb128 0
	.uleb128 0
.LLSDACSE9383:
	.byte	0x1
	.byte	0
	.byte	0
	.byte	0x7d
	.align 4
	.long	0

.LLSDATT9383:
	.section	.text._ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE17_M_realloc_insertIJRKS2_EEEvN9__gnu_cxx17__normal_iteratorIPS2_S4_EEDpOT_,"axG",@progbits,_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE17_M_realloc_insertIJRKS2_EEEvN9__gnu_cxx17__normal_iteratorIPS2_S4_EEDpOT_,comdat
	.size	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE17_M_realloc_insertIJRKS2_EEEvN9__gnu_cxx17__normal_iteratorIPS2_S4_EEDpOT_, .-_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE17_M_realloc_insertIJRKS2_EEEvN9__gnu_cxx17__normal_iteratorIPS2_S4_EEDpOT_
	.section	.text._ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_,"axG",@progbits,_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	.type	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_, @function
_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_:
.LFB9131:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA9131
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rdi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	8(%rdi), %r14
	cmpq	16(%rdi), %r14
	je	.L1361
	movq	8(%rsi), %rbx
	subq	(%rsi), %rbx
	pxor	%xmm0, %xmm0
	movabsq	$-8198552921648689607, %rdx
	movq	%rbx, %rax
	movq	$0, 16(%r14)
	sarq	$3, %rax
	movups	%xmm0, (%r14)
	imulq	%rdx, %rax
	testq	%rax, %rax
	je	.L1398
	movabsq	$128102389400760775, %rdx
	cmpq	%rdx, %rax
	ja	.L1399
	movq	%rbx, %rdi
.LEHB103:
	call	_Znwm@PLT
.LEHE103:
	movq	%rax, 8(%rsp)
.L1363:
	movq	8(%rsp), %rbp
	movq	%rbp, %xmm0
	addq	%rbp, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 16(%r14)
	movups	%xmm0, (%r14)
	movq	8(%r12), %rax
	movq	(%r12), %rbx
	movq	%rax, (%rsp)
	cmpq	%rbx, %rax
	je	.L1365
	movabsq	$2305843009213693951, %r15
	jmp	.L1376
	.p2align 4,,10
	.p2align 3
.L1366:
	cmpq	%r15, %rax
	ja	.L1400
	movq	%r12, %rdi
.LEHB104:
	call	_Znwm@PLT
.LEHE104:
	movq	%rax, %rcx
.L1367:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 16(%rbp)
	movups	%xmm0, 0(%rbp)
	movq	8(%rbx), %rax
	movq	(%rbx), %rsi
	movq	%rax, %r12
	subq	%rsi, %r12
	cmpq	%rsi, %rax
	je	.L1370
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1370:
	addq	%r12, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%rbp)
	movq	32(%rbx), %r12
	subq	24(%rbx), %r12
	movq	$0, 40(%rbp)
	movq	%r12, %rax
	movups	%xmm0, 24(%rbp)
	sarq	$2, %rax
	je	.L1401
	cmpq	%r15, %rax
	ja	.L1402
	movq	%r12, %rdi
.LEHB105:
	call	_Znwm@PLT
.LEHE105:
	movq	%rax, %rcx
.L1372:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 40(%rbp)
	movups	%xmm0, 24(%rbp)
	movq	32(%rbx), %rax
	movq	24(%rbx), %rsi
	movq	%rax, %r12
	subq	%rsi, %r12
	cmpq	%rsi, %rax
	je	.L1375
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1375:
	movl	48(%rbx), %eax
	movdqu	56(%rbx), %xmm1
	addq	%r12, %rcx
	addq	$72, %rbp
	movq	%rcx, -40(%rbp)
	addq	$72, %rbx
	movl	%eax, -24(%rbp)
	movups	%xmm1, -16(%rbp)
	cmpq	%rbx, (%rsp)
	je	.L1365
.L1376:
	movq	8(%rbx), %r12
	subq	(%rbx), %r12
	pxor	%xmm0, %xmm0
	movq	$0, 16(%rbp)
	movq	%r12, %rax
	movups	%xmm0, 0(%rbp)
	sarq	$2, %rax
	jne	.L1366
	xorl	%ecx, %ecx
	jmp	.L1367
	.p2align 4,,10
	.p2align 3
.L1398:
	movq	$0, 8(%rsp)
	jmp	.L1363
	.p2align 4,,10
	.p2align 3
.L1401:
	xorl	%ecx, %ecx
	jmp	.L1372
	.p2align 4,,10
	.p2align 3
.L1365:
	movq	%rbp, 8(%r14)
	addq	$24, 8(%r13)
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1361:
	.cfi_restore_state
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%rsi, %rdx
	movq	%r14, %rsi
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
.LEHB106:
	jmp	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE17_M_realloc_insertIJRKS2_EEEvN9__gnu_cxx17__normal_iteratorIPS2_S4_EEDpOT_
.LEHE106:
.L1400:
	.cfi_restore_state
.LEHB107:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE107:
.L1402:
.LEHB108:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE108:
.L1399:
.LEHB109:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE109:
.L1388:
	endbr64
	movq	%rax, %rbx
	jmp	.L1377
.L1387:
	endbr64
	movq	%rax, %rdi
	jmp	.L1379
.L1377:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L1378
	call	_ZdlPv@PLT
.L1378:
	movq	%rbx, %rdi
.L1379:
	call	__cxa_begin_catch@PLT
.L1382:
	cmpq	8(%rsp), %rbp
	jne	.L1403
.LEHB110:
	call	__cxa_rethrow@PLT
.LEHE110:
.L1403:
	movq	8(%rsp), %rbx
	movq	%rbx, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	%rbx, %rax
	addq	$72, %rax
	movq	%rax, 8(%rsp)
	jmp	.L1382
.L1386:
	endbr64
	movq	%rax, %rbp
.L1383:
	call	__cxa_end_catch@PLT
	movq	(%r14), %rdi
	testq	%rdi, %rdi
	je	.L1384
	call	_ZdlPv@PLT
.L1384:
	movq	%rbp, %rdi
.LEHB111:
	call	_Unwind_Resume@PLT
.LEHE111:
	.cfi_endproc
.LFE9131:
	.section	.gcc_except_table
	.align 4
.LLSDA9131:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT9131-.LLSDATTD9131
.LLSDATTD9131:
	.byte	0x1
	.uleb128 .LLSDACSE9131-.LLSDACSB9131
.LLSDACSB9131:
	.uleb128 .LEHB103-.LFB9131
	.uleb128 .LEHE103-.LEHB103
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB104-.LFB9131
	.uleb128 .LEHE104-.LEHB104
	.uleb128 .L1387-.LFB9131
	.uleb128 0x1
	.uleb128 .LEHB105-.LFB9131
	.uleb128 .LEHE105-.LEHB105
	.uleb128 .L1388-.LFB9131
	.uleb128 0x1
	.uleb128 .LEHB106-.LFB9131
	.uleb128 .LEHE106-.LEHB106
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB107-.LFB9131
	.uleb128 .LEHE107-.LEHB107
	.uleb128 .L1387-.LFB9131
	.uleb128 0x1
	.uleb128 .LEHB108-.LFB9131
	.uleb128 .LEHE108-.LEHB108
	.uleb128 .L1388-.LFB9131
	.uleb128 0x1
	.uleb128 .LEHB109-.LFB9131
	.uleb128 .LEHE109-.LEHB109
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB110-.LFB9131
	.uleb128 .LEHE110-.LEHB110
	.uleb128 .L1386-.LFB9131
	.uleb128 0
	.uleb128 .LEHB111-.LFB9131
	.uleb128 .LEHE111-.LEHB111
	.uleb128 0
	.uleb128 0
.LLSDACSE9131:
	.byte	0x1
	.byte	0
	.align 4
	.long	0

.LLSDATT9131:
	.section	.text._ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_,"axG",@progbits,_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_,comdat
	.size	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_, .-_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	.section	.text._ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_,"axG",@progbits,_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
	.type	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_, @function
_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_:
.LFB9428:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA9428
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdi, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rcx, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdx, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rsi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movq	8(%rcx), %r13
	testq	%r13, %r13
	je	.L1405
	movq	8(%r13), %rax
	movq	%rax, 8(%rcx)
	testq	%rax, %rax
	je	.L1406
	cmpq	24(%rax), %r13
	je	.L1462
	movq	$0, 16(%rax)
.L1411:
	movdqu	32(%rbx), %xmm4
	movups	%xmm4, 32(%r13)
	movdqu	48(%rbx), %xmm5
	movups	%xmm5, 48(%r13)
.L1427:
	movl	(%rbx), %eax
	movq	$0, 16(%r13)
	movq	$0, 24(%r13)
	movq	%rbp, 8(%r13)
	movq	24(%rbx), %rsi
	movl	%eax, 0(%r13)
	testq	%rsi, %rsi
	je	.L1412
	movq	%r12, %rcx
	movq	%r13, %rdx
	movq	%r15, %rdi
.LEHB112:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
	movq	%rax, 24(%r13)
.L1412:
	movq	16(%rbx), %rbp
	movq	%r13, %r14
	testq	%rbp, %rbp
	je	.L1404
	movq	8(%r12), %rbx
	testq	%rbx, %rbx
	je	.L1414
.L1464:
	movq	8(%rbx), %rax
	movq	%rax, 8(%r12)
	testq	%rax, %rax
	je	.L1415
	cmpq	24(%rax), %rbx
	je	.L1463
	movq	$0, 16(%rax)
.L1420:
	movdqu	32(%rbp), %xmm0
	movups	%xmm0, 32(%rbx)
	movdqu	48(%rbp), %xmm1
	movups	%xmm1, 48(%rbx)
.L1425:
	movl	0(%rbp), %eax
	movq	$0, 16(%rbx)
	movq	$0, 24(%rbx)
	movl	%eax, (%rbx)
	movq	%rbx, 16(%r14)
	movq	%r14, 8(%rbx)
	movq	24(%rbp), %rsi
	testq	%rsi, %rsi
	je	.L1421
	movq	%r12, %rcx
	movq	%rbx, %rdx
	movq	%r15, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
	movq	%rax, 24(%rbx)
.L1421:
	movq	16(%rbp), %rbp
	testq	%rbp, %rbp
	je	.L1404
	movq	%rbx, %r14
	movq	8(%r12), %rbx
	testq	%rbx, %rbx
	jne	.L1464
.L1414:
	movl	$64, %edi
	call	_Znwm@PLT
.LEHE112:
	movdqu	32(%rbp), %xmm2
	movq	%rax, %rbx
	movups	%xmm2, 32(%rax)
	movdqu	48(%rbp), %xmm3
	movups	%xmm3, 48(%rax)
	jmp	.L1425
	.p2align 4,,10
	.p2align 3
.L1404:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r13, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1415:
	.cfi_restore_state
	movq	$0, (%r12)
	jmp	.L1420
	.p2align 4,,10
	.p2align 3
.L1463:
	movq	16(%rax), %rdx
	movq	$0, 24(%rax)
	testq	%rdx, %rdx
	je	.L1420
	movq	24(%rdx), %rax
	movq	%rdx, 8(%r12)
	testq	%rax, %rax
	je	.L1418
	.p2align 4,,10
	.p2align 3
.L1419:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1419
	movq	%rdx, 8(%r12)
.L1418:
	movq	16(%rdx), %rax
	testq	%rax, %rax
	je	.L1420
	movq	%rax, 8(%r12)
	jmp	.L1420
	.p2align 4,,10
	.p2align 3
.L1405:
	movl	$64, %edi
.LEHB113:
	call	_Znwm@PLT
.LEHE113:
	movdqu	32(%rbx), %xmm6
	movdqu	48(%rbx), %xmm7
	movq	%rax, %r13
	movups	%xmm6, 32(%rax)
	movups	%xmm7, 48(%rax)
	jmp	.L1427
	.p2align 4,,10
	.p2align 3
.L1406:
	movq	$0, (%rcx)
	jmp	.L1411
	.p2align 4,,10
	.p2align 3
.L1462:
	movq	16(%rax), %rdx
	movq	$0, 24(%rax)
	testq	%rdx, %rdx
	je	.L1411
	movq	24(%rdx), %rax
	movq	%rdx, 8(%rcx)
	testq	%rax, %rax
	je	.L1409
	.p2align 4,,10
	.p2align 3
.L1410:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1410
	movq	%rdx, 8(%r12)
.L1409:
	movq	16(%rdx), %rax
	testq	%rax, %rax
	je	.L1411
	movq	%rax, 8(%r12)
	jmp	.L1411
.L1429:
	endbr64
	movq	%rax, %rdi
.L1423:
	call	__cxa_begin_catch@PLT
	movq	%r13, %rsi
	movq	%r15, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.LEHB114:
	call	__cxa_rethrow@PLT
.LEHE114:
.L1430:
	endbr64
	movq	%rax, %rbp
.L1424:
	call	__cxa_end_catch@PLT
	movq	%rbp, %rdi
.LEHB115:
	call	_Unwind_Resume@PLT
.LEHE115:
	.cfi_endproc
.LFE9428:
	.section	.gcc_except_table
	.align 4
.LLSDA9428:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT9428-.LLSDATTD9428
.LLSDATTD9428:
	.byte	0x1
	.uleb128 .LLSDACSE9428-.LLSDACSB9428
.LLSDACSB9428:
	.uleb128 .LEHB112-.LFB9428
	.uleb128 .LEHE112-.LEHB112
	.uleb128 .L1429-.LFB9428
	.uleb128 0x1
	.uleb128 .LEHB113-.LFB9428
	.uleb128 .LEHE113-.LEHB113
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB114-.LFB9428
	.uleb128 .LEHE114-.LEHB114
	.uleb128 .L1430-.LFB9428
	.uleb128 0
	.uleb128 .LEHB115-.LFB9428
	.uleb128 .LEHE115-.LEHB115
	.uleb128 0
	.uleb128 0
.LLSDACSE9428:
	.byte	0x1
	.byte	0
	.align 4
	.long	0

.LLSDATT9428:
	.section	.text._ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_,"axG",@progbits,_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_,comdat
	.size	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_, .-_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
	.section	.text._ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_,"axG",@progbits,_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_
	.type	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_, @function
_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_:
.LFB8998:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8998
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$32, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	cmpq	%rsi, %rdi
	je	.L1466
	movq	16(%rdi), %rbx
	movq	32(%rdi), %rax
	movq	%rdi, 16(%rsp)
	movq	%rsi, %rbp
	leaq	8(%rdi), %rdx
	movq	%rbx, (%rsp)
	movq	%rax, 8(%rsp)
	testq	%rbx, %rbx
	je	.L1467
	movq	16(%rax), %rax
	movq	$0, 8(%rbx)
	testq	%rax, %rax
	je	.L1468
	movq	%rax, 8(%rsp)
.L1468:
	movq	$0, 16(%r12)
	movq	%rdx, 24(%r12)
	movq	%rdx, 32(%r12)
	movq	16(%rbp), %rsi
	movq	$0, 40(%r12)
	testq	%rsi, %rsi
	je	.L1491
.L1469:
	movq	%rsp, %rcx
	movq	%r12, %rdi
.LEHB116:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE116:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1470:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1470
	movq	%rcx, 24(%r12)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1471:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1471
	movq	40(%rbp), %rdx
	movq	(%rsp), %rbx
	movq	%rcx, 32(%r12)
	movq	%rax, 16(%r12)
	movq	%rdx, 40(%r12)
	testq	%rbx, %rbx
	je	.L1466
	movq	16(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L1473:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1473
.L1466:
	movq	24(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1492
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1467:
	.cfi_restore_state
	movq	%rdx, 24(%rdi)
	movq	%rdx, 32(%rdi)
	movq	16(%rsi), %rsi
	movq	$0, 8(%rsp)
	movq	$0, 40(%rdi)
	testq	%rsi, %rsi
	jne	.L1469
	jmp	.L1466
	.p2align 4,,10
	.p2align 3
.L1491:
	movq	%r12, %rbp
	jmp	.L1473
.L1492:
	call	__stack_chk_fail@PLT
.L1477:
	endbr64
	movq	%rax, %rbp
.L1474:
	movq	16(%rsp), %rdi
	movq	(%rsp), %rsi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
.LEHB117:
	call	_Unwind_Resume@PLT
.LEHE117:
	.cfi_endproc
.LFE8998:
	.section	.gcc_except_table
.LLSDA8998:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8998-.LLSDACSB8998
.LLSDACSB8998:
	.uleb128 .LEHB116-.LFB8998
	.uleb128 .LEHE116-.LEHB116
	.uleb128 .L1477-.LFB8998
	.uleb128 0
	.uleb128 .LEHB117-.LFB8998
	.uleb128 .LEHE117-.LEHB117
	.uleb128 0
	.uleb128 0
.LLSDACSE8998:
	.section	.text._ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_,"axG",@progbits,_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_,comdat
	.size	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_, .-_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_
	.section	.text._ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_,"axG",@progbits,_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
	.type	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_, @function
_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_:
.LFB9648:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA9648
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rcx, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rdi, %r14
	movl	$64, %edi
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdx, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rsi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
.LEHB118:
	call	_Znwm@PLT
.LEHE118:
	movdqu	32(%rbx), %xmm2
	movdqu	48(%rbx), %xmm3
	movq	%rax, %r12
	movq	24(%rbx), %rsi
	movups	%xmm2, 32(%rax)
	movups	%xmm3, 48(%rax)
	movl	(%rbx), %eax
	movq	$0, 16(%r12)
	movl	%eax, (%r12)
	movq	$0, 24(%r12)
	movq	%rbp, 8(%r12)
	testq	%rsi, %rsi
	je	.L1494
	movq	%r15, %rcx
	movq	%r12, %rdx
	movq	%r14, %rdi
.LEHB119:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
	movq	%rax, 24(%r12)
.L1494:
	movq	16(%rbx), %rbp
	testq	%rbp, %rbp
	je	.L1493
	movq	%r12, %rbx
.L1497:
	movl	$64, %edi
	movq	%rbx, %r13
	call	_Znwm@PLT
	movdqu	32(%rbp), %xmm0
	movq	%rax, %rbx
	movups	%xmm0, 32(%rax)
	movdqu	48(%rbp), %xmm1
	movups	%xmm1, 48(%rax)
	movl	0(%rbp), %eax
	movq	$0, 16(%rbx)
	movq	$0, 24(%rbx)
	movl	%eax, (%rbx)
	movq	%rbx, 16(%r13)
	movq	%r13, 8(%rbx)
	movq	24(%rbp), %rsi
	testq	%rsi, %rsi
	je	.L1496
	movq	%r15, %rcx
	movq	%rbx, %rdx
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE119:
	movq	%rax, 24(%rbx)
.L1496:
	movq	16(%rbp), %rbp
	testq	%rbp, %rbp
	jne	.L1497
.L1493:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L1500:
	.cfi_restore_state
	endbr64
	movq	%rax, %rdi
.L1498:
	call	__cxa_begin_catch@PLT
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.LEHB120:
	call	__cxa_rethrow@PLT
.LEHE120:
.L1501:
	endbr64
	movq	%rax, %rbp
.L1499:
	call	__cxa_end_catch@PLT
	movq	%rbp, %rdi
.LEHB121:
	call	_Unwind_Resume@PLT
.LEHE121:
	.cfi_endproc
.LFE9648:
	.section	.gcc_except_table
	.align 4
.LLSDA9648:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT9648-.LLSDATTD9648
.LLSDATTD9648:
	.byte	0x1
	.uleb128 .LLSDACSE9648-.LLSDACSB9648
.LLSDACSB9648:
	.uleb128 .LEHB118-.LFB9648
	.uleb128 .LEHE118-.LEHB118
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB119-.LFB9648
	.uleb128 .LEHE119-.LEHB119
	.uleb128 .L1500-.LFB9648
	.uleb128 0x1
	.uleb128 .LEHB120-.LFB9648
	.uleb128 .LEHE120-.LEHB120
	.uleb128 .L1501-.LFB9648
	.uleb128 0
	.uleb128 .LEHB121-.LFB9648
	.uleb128 .LEHE121-.LEHB121
	.uleb128 0
	.uleb128 0
.LLSDACSE9648:
	.byte	0x1
	.byte	0
	.align 4
	.long	0

.LLSDATT9648:
	.section	.text._ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_,"axG",@progbits,_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_,comdat
	.size	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_, .-_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
	.section	.text.unlikely
.LCOLDB38:
	.text
.LHOTB38:
	.p2align 4
	.globl	_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE
	.type	_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE, @function
_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE:
.LFB8757:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8757
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rsi, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$136, %rsp
	.cfi_def_cfa_offset 192
	movq	16(%rsi), %rsi
	movq	%fs:40, %rax
	movq	%rax, 120(%rsp)
	xorl	%eax, %eax
	leaq	72(%rsp), %rbx
	leaq	64(%rsp), %r13
	movl	$0, 72(%rsp)
	movq	$0, 80(%rsp)
	movq	%rbx, %rbp
	movq	%rbx, 88(%rsp)
	movq	%rbx, 96(%rsp)
	movq	$0, 104(%rsp)
	testq	%rsi, %rsi
	je	.L1514
	leaq	32(%rsp), %r14
	movq	%rbx, %rdx
	movq	%r13, %rdi
	movq	%r13, 32(%rsp)
	movq	%r14, %rcx
.LEHB122:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE122:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1515:
	movq	%rdx, %rbp
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1515
	movq	%rbp, 88(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1516:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1516
	movq	40(%r15), %rdx
	movq	%rcx, 96(%rsp)
	movq	%rax, 80(%rsp)
	movq	%rdx, 104(%rsp)
.L1514:
	leaq	24(%r12), %rax
	pxor	%xmm0, %xmm0
	movl	$6, 28(%rsp)
	movq	%rax, 8(%rsp)
	leaq	64(%r12), %rax
	movl	$0, 64(%r12)
	movq	$0, 72(%r12)
	movq	%rax, 80(%r12)
	movq	%rax, 88(%r12)
	movq	$0, 96(%r12)
	movups	%xmm0, (%r12)
	movups	%xmm0, 16(%r12)
	movups	%xmm0, 32(%r12)
	cmpq	%rbx, %rbp
	je	.L1517
	leaq	56(%r12), %r15
	leaq	32(%rsp), %r14
	.p2align 4,,10
	.p2align 3
.L1518:
	movl	32(%rbp), %eax
	movdqu	40(%rbp), %xmm1
	movq	%r14, %rsi
	movq	%r15, %rdi
	movl	%eax, 32(%rsp)
	movups	%xmm1, 40(%rsp)
	movq	56(%rbp), %rax
	movq	%rax, 56(%rsp)
.LEHB123:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
.LEHE123:
	movq	%rbp, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %rbp
	cmpq	%rbx, %rax
	jne	.L1518
	movl	28(%rsp), %eax
	movq	8(%r12), %rsi
	movq	16(%r12), %r8
	movl	%eax, 48(%r12)
	cmpq	%r8, %rsi
	je	.L1519
	movl	%eax, (%rsi)
	addq	$4, %rsi
	movq	%rsi, 8(%r12)
	cmpq	%rsi, %r8
	je	.L1521
.L1556:
	movl	28(%rsp), %eax
	addq	$4, %rsi
	movq	40(%r12), %r8
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
	movq	32(%r12), %rsi
	cmpq	%r8, %rsi
	je	.L1523
.L1557:
	movl	28(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 32(%r12)
	cmpq	%rsi, %r8
	je	.L1525
.L1558:
	movl	28(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 32(%r12)
.L1526:
	movq	80(%rsp), %rbx
	testq	%rbx, %rbx
	je	.L1532
.L1527:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1527
.L1532:
	movq	%r12, %rdi
.LEHB124:
	call	_ZN19quantumSparseMatrix5printEv
.LEHE124:
	movq	120(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1555
	addq	$136, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1517:
	.cfi_restore_state
	movl	$6, 48(%r12)
	xorl	%esi, %esi
.L1519:
	leaq	28(%rsp), %rdx
	movq	%r12, %rdi
	leaq	56(%r12), %r15
.LEHB125:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%r12), %rsi
	movq	16(%r12), %r8
	cmpq	%rsi, %r8
	jne	.L1556
	.p2align 4,,10
	.p2align 3
.L1521:
	leaq	28(%rsp), %rdx
	movq	%r8, %rsi
	leaq	56(%r12), %r15
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%r12), %rsi
	movq	40(%r12), %r8
	cmpq	%r8, %rsi
	jne	.L1557
	.p2align 4,,10
	.p2align 3
.L1523:
	movq	8(%rsp), %rdi
	leaq	28(%rsp), %rdx
	leaq	56(%r12), %r15
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%r12), %rsi
	movq	40(%r12), %r8
	cmpq	%rsi, %r8
	jne	.L1558
	.p2align 4,,10
	.p2align 3
.L1525:
	movq	8(%rsp), %rdi
	leaq	28(%rsp), %rdx
	movq	%r8, %rsi
	leaq	56(%r12), %r15
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE125:
	jmp	.L1526
.L1555:
	call	__stack_chk_fail@PLT
.L1537:
	endbr64
	movq	%rax, %rbp
	jmp	.L1529
.L1536:
	endbr64
	movq	%rax, %rbp
	jmp	.L1533
	.section	.gcc_except_table
.LLSDA8757:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8757-.LLSDACSB8757
.LLSDACSB8757:
	.uleb128 .LEHB122-.LFB8757
	.uleb128 .LEHE122-.LEHB122
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB123-.LFB8757
	.uleb128 .LEHE123-.LEHB123
	.uleb128 .L1537-.LFB8757
	.uleb128 0
	.uleb128 .LEHB124-.LFB8757
	.uleb128 .LEHE124-.LEHB124
	.uleb128 .L1536-.LFB8757
	.uleb128 0
	.uleb128 .LEHB125-.LFB8757
	.uleb128 .LEHE125-.LEHB125
	.uleb128 .L1537-.LFB8757
	.uleb128 0
.LLSDACSE8757:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8757
	.type	_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE.cold, @function
_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE.cold:
.LFSB8757:
.L1529:
	.cfi_def_cfa_offset 192
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	72(%r12), %rsi
	movq	%r15, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	24(%r12), %rdi
	testq	%rdi, %rdi
	je	.L1530
	call	_ZdlPv@PLT
.L1530:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L1531
	call	_ZdlPv@PLT
.L1531:
	movq	80(%rsp), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
.LEHB126:
	call	_Unwind_Resume@PLT
.L1533:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE126:
	.cfi_endproc
.LFE8757:
	.section	.gcc_except_table
.LLSDAC8757:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8757-.LLSDACSBC8757
.LLSDACSBC8757:
	.uleb128 .LEHB126-.LCOLDB38
	.uleb128 .LEHE126-.LEHB126
	.uleb128 0
	.uleb128 0
.LLSDACSEC8757:
	.section	.text.unlikely
	.text
	.size	_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE, .-_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE
	.section	.text.unlikely
	.size	_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE.cold, .-_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE.cold
.LCOLDE38:
	.text
.LHOTE38:
	.section	.text._ZN19quantumSparseMatrixC2ERKS_,"axG",@progbits,_ZN19quantumSparseMatrixC5ERKS_,comdat
	.align 2
	.p2align 4
	.weak	_ZN19quantumSparseMatrixC2ERKS_
	.type	_ZN19quantumSparseMatrixC2ERKS_, @function
_ZN19quantumSparseMatrixC2ERKS_:
.LFB8708:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8708
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pxor	%xmm0, %xmm0
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rdi, %rbx
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movq	8(%rsi), %r12
	subq	(%rsi), %r12
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movq	%r12, %rax
	movq	$0, 16(%rdi)
	sarq	$2, %rax
	movups	%xmm0, (%rdi)
	je	.L1592
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1593
	movq	%r12, %rdi
.LEHB127:
	call	_Znwm@PLT
.LEHE127:
	movq	%rax, %rcx
.L1561:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 16(%rbx)
	movups	%xmm0, (%rbx)
	movq	8(%rbp), %rax
	movq	0(%rbp), %rsi
	movq	%rax, %r12
	subq	%rsi, %r12
	cmpq	%rsi, %rax
	je	.L1564
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1564:
	addq	%r12, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%rbx)
	movq	32(%rbp), %r12
	subq	24(%rbp), %r12
	movq	$0, 40(%rbx)
	movq	%r12, %rax
	movups	%xmm0, 24(%rbx)
	sarq	$2, %rax
	je	.L1594
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1595
	movq	%r12, %rdi
.LEHB128:
	call	_Znwm@PLT
.LEHE128:
	movq	%rax, %rcx
.L1566:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 40(%rbx)
	movups	%xmm0, 24(%rbx)
	movq	32(%rbp), %rax
	movq	24(%rbp), %rsi
	movq	%rax, %r12
	subq	%rsi, %r12
	cmpq	%rsi, %rax
	je	.L1569
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1569:
	leaq	64(%rbx), %rdx
	movl	48(%rbp), %eax
	movq	$0, 72(%rbx)
	addq	%r12, %rcx
	movq	%rdx, 80(%rbx)
	movq	%rdx, 88(%rbx)
	movq	72(%rbp), %rsi
	movq	%rcx, 32(%rbx)
	movl	%eax, 48(%rbx)
	movl	$0, 64(%rbx)
	movq	$0, 96(%rbx)
	testq	%rsi, %rsi
	je	.L1559
	leaq	56(%rbx), %rdi
	movq	%rsp, %rcx
	movq	%rdi, (%rsp)
.LEHB129:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE129:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1571:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1571
	movq	%rcx, 80(%rbx)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1572:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1572
	movq	96(%rbp), %rdx
	movq	%rcx, 88(%rbx)
	movq	%rax, 72(%rbx)
	movq	%rdx, 96(%rbx)
.L1559:
	movq	8(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1596
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1592:
	.cfi_restore_state
	xorl	%ecx, %ecx
	jmp	.L1561
	.p2align 4,,10
	.p2align 3
.L1594:
	xorl	%ecx, %ecx
	jmp	.L1566
.L1596:
	call	__stack_chk_fail@PLT
.L1593:
.LEHB130:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE130:
.L1595:
.LEHB131:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE131:
.L1579:
	endbr64
	movq	%rax, %rbp
	jmp	.L1573
.L1578:
	endbr64
	movq	%rax, %rbp
	jmp	.L1575
.L1573:
	movq	24(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L1575
	call	_ZdlPv@PLT
.L1575:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L1576
	call	_ZdlPv@PLT
.L1576:
	movq	%rbp, %rdi
.LEHB132:
	call	_Unwind_Resume@PLT
.LEHE132:
	.cfi_endproc
.LFE8708:
	.section	.gcc_except_table
.LLSDA8708:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8708-.LLSDACSB8708
.LLSDACSB8708:
	.uleb128 .LEHB127-.LFB8708
	.uleb128 .LEHE127-.LEHB127
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB128-.LFB8708
	.uleb128 .LEHE128-.LEHB128
	.uleb128 .L1578-.LFB8708
	.uleb128 0
	.uleb128 .LEHB129-.LFB8708
	.uleb128 .LEHE129-.LEHB129
	.uleb128 .L1579-.LFB8708
	.uleb128 0
	.uleb128 .LEHB130-.LFB8708
	.uleb128 .LEHE130-.LEHB130
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB131-.LFB8708
	.uleb128 .LEHE131-.LEHB131
	.uleb128 .L1578-.LFB8708
	.uleb128 0
	.uleb128 .LEHB132-.LFB8708
	.uleb128 .LEHE132-.LEHB132
	.uleb128 0
	.uleb128 0
.LLSDACSE8708:
	.section	.text._ZN19quantumSparseMatrixC2ERKS_,"axG",@progbits,_ZN19quantumSparseMatrixC5ERKS_,comdat
	.size	_ZN19quantumSparseMatrixC2ERKS_, .-_ZN19quantumSparseMatrixC2ERKS_
	.weak	_ZN19quantumSparseMatrixC1ERKS_
	.set	_ZN19quantumSparseMatrixC1ERKS_,_ZN19quantumSparseMatrixC2ERKS_
	.text
	.p2align 4
	.globl	_Z5trace19quantumSparseMatrix
	.type	_Z5trace19quantumSparseMatrix, @function
_Z5trace19quantumSparseMatrix:
.LFB8722:
	.cfi_startproc
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$104, %rsp
	.cfi_def_cfa_offset 144
	movq	72(%rdi), %rsi
	movq	%fs:40, %rax
	movq	%rax, 88(%rsp)
	xorl	%eax, %eax
	leaq	40(%rsp), %r12
	movl	$0, 40(%rsp)
	movq	$0, 48(%rsp)
	movq	%r12, 56(%rsp)
	movq	%r12, 64(%rsp)
	movq	$0, 72(%rsp)
	testq	%rsi, %rsi
	je	.L1598
	leaq	32(%rsp), %rbp
	movq	%rdi, %r13
	leaq	24(%rsp), %rcx
	movq	%r12, %rdx
	movq	%rbp, %rdi
	movq	%rbp, 24(%rsp)
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
	movq	%rax, %rbx
	.p2align 4,,10
	.p2align 3
.L1599:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L1599
	movq	%rdx, 56(%rsp)
	movq	%rbx, %rax
	.p2align 4,,10
	.p2align 3
.L1600:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1600
	movq	96(%r13), %rax
	movq	%rdx, 64(%rsp)
	movq	%rbx, 48(%rsp)
	movq	%rax, 72(%rsp)
	testq	%rbx, %rbx
	je	.L1601
	movq	%rbx, %rdx
	movq	%r12, %rax
	jmp	.L1602
	.p2align 4,,10
	.p2align 3
.L1626:
	movq	%rdx, %rax
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	je	.L1603
.L1602:
	movl	32(%rdx), %ecx
	testl	%ecx, %ecx
	jns	.L1626
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1602
.L1603:
	cmpq	%r12, %rax
	je	.L1606
	movl	32(%rax), %edx
	testl	%edx, %edx
	jg	.L1606
	movl	44(%rax), %edi
	testl	%edi, %edi
	jle	.L1616
	movq	48(%rax), %rsi
	movq	56(%rax), %rcx
	leal	-1(%rdi), %eax
	cmpl	$2, %eax
	jbe	.L1617
	movl	%edi, %edx
	pxor	%xmm2, %xmm2
	xorl	%eax, %eax
	shrl	$2, %edx
	movaps	%xmm2, %xmm3
	salq	$4, %rdx
	.p2align 4,,10
	.p2align 3
.L1609:
	movups	(%rsi,%rax), %xmm1
	movups	(%rcx,%rax), %xmm0
	addq	$16, %rax
	movaps	%xmm1, %xmm5
	movaps	%xmm1, %xmm4
	addss	%xmm0, %xmm2
	addss	%xmm3, %xmm5
	shufps	$85, %xmm1, %xmm4
	movaps	%xmm4, %xmm3
	movaps	%xmm1, %xmm4
	unpckhps	%xmm1, %xmm4
	shufps	$255, %xmm1, %xmm1
	addss	%xmm5, %xmm3
	addss	%xmm4, %xmm3
	addss	%xmm1, %xmm3
	movaps	%xmm0, %xmm1
	shufps	$85, %xmm0, %xmm1
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	unpckhps	%xmm0, %xmm1
	shufps	$255, %xmm0, %xmm0
	addss	%xmm1, %xmm2
	addss	%xmm0, %xmm2
	cmpq	%rdx, %rax
	jne	.L1609
	movl	%edi, %eax
	andl	$-4, %eax
	testb	$3, %dil
	je	.L1607
.L1608:
	movslq	%eax, %rdx
	addss	(%rsi,%rdx,4), %xmm3
	addss	(%rcx,%rdx,4), %xmm2
	leal	1(%rax), %edx
	cmpl	%edx, %edi
	jle	.L1607
	movslq	%edx, %rdx
	addl	$2, %eax
	addss	(%rsi,%rdx,4), %xmm3
	addss	(%rcx,%rdx,4), %xmm2
	cmpl	%eax, %edi
	jle	.L1607
	cltq
	addss	(%rsi,%rax,4), %xmm3
	addss	(%rcx,%rax,4), %xmm2
.L1607:
	movss	%xmm3, (%rsp)
	movss	%xmm2, 4(%rsp)
	.p2align 4,,10
	.p2align 3
.L1614:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1614
.L1613:
	movss	(%rsp), %xmm6
	movss	4(%rsp), %xmm7
	movss	%xmm6, 8(%rsp)
	movss	%xmm7, 12(%rsp)
	movq	8(%rsp), %xmm0
	movq	88(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1627
	addq	$104, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1606:
	.cfi_restore_state
	pxor	%xmm7, %xmm7
	movss	%xmm7, (%rsp)
	movss	%xmm7, 4(%rsp)
	jmp	.L1614
	.p2align 4,,10
	.p2align 3
.L1598:
	pxor	%xmm6, %xmm6
	movss	%xmm6, (%rsp)
	movss	%xmm6, 4(%rsp)
	jmp	.L1613
.L1616:
	pxor	%xmm2, %xmm2
	movaps	%xmm2, %xmm3
	jmp	.L1607
.L1617:
	pxor	%xmm2, %xmm2
	xorl	%eax, %eax
	movaps	%xmm2, %xmm3
	jmp	.L1608
.L1601:
	pxor	%xmm7, %xmm7
	movss	%xmm7, (%rsp)
	movss	%xmm7, 4(%rsp)
	jmp	.L1613
.L1627:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8722:
	.size	_Z5trace19quantumSparseMatrix, .-_Z5trace19quantumSparseMatrix
	.section	.text.unlikely
	.align 2
.LCOLDB39:
	.text
.LHOTB39:
	.align 2
	.p2align 4
	.globl	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
	.type	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE, @function
_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE:
.LFB8744:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8744
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pxor	%xmm0, %xmm0
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	leaq	24(%rdi), %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdx, %rbx
	subq	$168, %rsp
	.cfi_def_cfa_offset 224
	movq	%rsi, 24(%rsp)
	movq	%rdx, %rsi
	movq	%rdx, 40(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 152(%rsp)
	xorl	%eax, %eax
	leaq	56(%rsp), %rax
	movups	%xmm0, (%rdi)
	movq	%rax, 72(%rsp)
	movq	%rax, 80(%rsp)
	leaq	104(%rsp), %rax
	movq	%rax, 120(%rsp)
	movq	%rax, 128(%rsp)
	leaq	64(%rdi), %rax
	movl	$0, 64(%rdi)
	movq	$0, 72(%rdi)
	movq	%rax, 80(%rdi)
	movq	%rax, 88(%rdi)
	movq	$0, 96(%rdi)
	movups	%xmm0, 16(%rdi)
	movups	%xmm0, 32(%rdi)
	movl	$0, 56(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, 88(%rsp)
	movl	$0, 104(%rsp)
	movq	$0, 112(%rsp)
	movq	$0, 136(%rsp)
	movq	%r14, 32(%rsp)
	movq	%rax, 16(%rsp)
.LEHB133:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	(%r12), %rax
	movq	%rbx, %rsi
	movq	%r14, %rdi
	movl	(%rax), %eax
	movl	%eax, 48(%r12)
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE133:
	movq	112(%rsp), %rbx
	leaq	96(%rsp), %rbp
	testq	%rbx, %rbx
	je	.L1637
.L1634:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1634
.L1637:
	movq	(%r12), %rax
	leaq	56(%r12), %r14
	movl	(%rax), %r15d
	movl	4(%rax), %eax
	movl	%r15d, %ebx
	negl	%ebx
	cmpl	%eax, %ebx
	jl	.L1642
	jmp	.L1636
	.p2align 4,,10
	.p2align 3
.L1743:
	movl	%eax, %ecx
	subl	%ebx, %ecx
.L1639:
	cmpl	%r15d, %ecx
	jg	.L1641
	cmpl	%ecx, %eax
	cmovle	%eax, %ecx
	movl	%ecx, %r15d
.L1641:
	movslq	%r15d, %r13
	movl	$4, %esi
	movq	%r13, %rdi
	call	calloc@PLT
	movl	$4, %esi
	movq	%r13, %rdi
	movq	%rax, 8(%rsp)
	call	calloc@PLT
	movq	%rbp, %rsi
	movq	%r14, %rdi
	movl	%ebx, 96(%rsp)
	movq	8(%rsp), %xmm0
	movq	%rax, %xmm3
	movl	%ebx, 104(%rsp)
	movl	%r15d, 108(%rsp)
	punpcklqdq	%xmm3, %xmm0
	movaps	%xmm0, 112(%rsp)
.LEHB134:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	movq	(%r12), %rdx
	addl	$1, %ebx
	movl	4(%rdx), %eax
	cmpl	%ebx, %eax
	jle	.L1636
	movl	(%rdx), %r15d
.L1642:
	leal	(%rbx,%r15), %ecx
	testl	%ebx, %ebx
	js	.L1639
	jne	.L1743
	cmpl	%r15d, %eax
	movl	%r15d, %ecx
	cmovle	%eax, %ecx
	jmp	.L1639
	.p2align 4,,10
	.p2align 3
.L1636:
	movq	40(%rsp), %xmm0
	xorl	%ecx, %ecx
	movq	%rbp, %rsi
	xorl	%r15d, %r15d
	movl	$16, %edx
	leaq	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE._omp_fn.0(%rip), %rdi
	movq	%r12, 112(%rsp)
	movhps	24(%rsp), %xmm0
	movaps	%xmm0, 96(%rsp)
	call	GOMP_parallel@PLT
	pxor	%xmm0, %xmm0
	movq	80(%r12), %r14
	movq	$0, 112(%rsp)
	movaps	%xmm0, 96(%rsp)
	cmpq	%r14, 16(%rsp)
	je	.L1644
	.p2align 4,,10
	.p2align 3
.L1643:
	movl	44(%r14), %ecx
	movq	48(%r14), %rdi
	movq	56(%r14), %r8
	testl	%ecx, %ecx
	jle	.L1683
	leal	-1(%rcx), %edx
	movl	$1, %eax
	addq	$2, %rdx
	jmp	.L1651
	.p2align 4,,10
	.p2align 3
.L1744:
	jne	.L1648
	ucomiss	-4(%r8,%rax,4), %xmm1
	jp	.L1648
	jne	.L1648
	movl	%eax, %r9d
	addq	$1, %rax
	cmpq	%rdx, %rax
	je	.L1647
.L1651:
	pxor	%xmm1, %xmm1
	ucomiss	-4(%rdi,%rax,4), %xmm1
	jnp	.L1744
.L1648:
	movq	%r14, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %r14
	cmpq	%rax, 16(%rsp)
	jne	.L1643
	movq	96(%rsp), %r9
	cmpq	%r15, %r9
	je	.L1745
	leaq	56(%r12), %rax
	xorl	%ebp, %ebp
	movq	%rax, 16(%rsp)
	.p2align 4,,10
	.p2align 3
.L1674:
	movq	72(%r12), %r8
	leaq	(%r9,%rbp,4), %rax
	testq	%r8, %r8
	je	.L1654
	movl	(%rax), %edi
	movq	%r14, %r13
	movq	%r8, %rbx
	jmp	.L1655
	.p2align 4,,10
	.p2align 3
.L1747:
	movq	24(%rbx), %rax
	testq	%rax, %rax
	je	.L1746
.L1684:
	movq	%rax, %rbx
.L1655:
	cmpl	%edi, 32(%rbx)
	jl	.L1747
	movq	16(%rbx), %rax
	jle	.L1748
	movq	%rbx, %r13
	testq	%rax, %rax
	jne	.L1684
.L1746:
	cmpq	%r13, 80(%r12)
	jne	.L1672
	cmpq	%r13, %r14
	je	.L1670
	.p2align 4,,10
	.p2align 3
.L1672:
	movq	%r15, %rax
	addq	$1, %rbp
	subq	%r9, %rax
	sarq	$2, %rax
	cmpq	%rbp, %rax
	ja	.L1674
.L1646:
	testq	%r9, %r9
	je	.L1644
	movq	%r9, %rdi
	call	_ZdlPv@PLT
.L1644:
	movq	24(%rsp), %rsi
	movq	32(%rsp), %rdi
	addq	$24, %rsi
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE134:
	movq	64(%rsp), %rbx
	leaq	48(%rsp), %rbp
	testq	%rbx, %rbx
	je	.L1628
.L1679:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1679
.L1628:
	movq	152(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1749
	addq	$168, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1670:
	.cfi_restore_state
	movq	24(%r8), %rsi
	movq	16(%rsp), %rdi
	movq	%r8, 8(%rsp)
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	8(%rsp), %r8
	movq	%r8, %rdi
	movq	16(%r8), %r8
	movq	%r8, 8(%rsp)
	call	_ZdlPv@PLT
	movq	8(%rsp), %r8
	testq	%r8, %r8
	jne	.L1670
	movq	96(%rsp), %r9
	movq	104(%rsp), %r15
.L1671:
	movq	$0, 72(%r12)
	movq	%r14, 80(%r12)
	movq	%r14, 88(%r12)
	movq	$0, 96(%r12)
	jmp	.L1672
	.p2align 4,,10
	.p2align 3
.L1683:
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L1647:
	cmpl	%ecx, %r9d
	jne	.L1648
	cmpq	%r15, 112(%rsp)
	je	.L1652
	movl	32(%r14), %eax
	addq	$4, %r15
	movl	%eax, -4(%r15)
	movq	%r15, 104(%rsp)
	jmp	.L1648
	.p2align 4,,10
	.p2align 3
.L1748:
	movq	24(%rbx), %rdx
	testq	%rdx, %rdx
	jne	.L1662
	jmp	.L1668
	.p2align 4,,10
	.p2align 3
.L1750:
	movq	%rdx, %r13
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	je	.L1668
.L1662:
	cmpl	32(%rdx), %edi
	jl	.L1750
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1662
	.p2align 4,,10
	.p2align 3
.L1668:
	testq	%rax, %rax
	je	.L1663
.L1751:
	cmpl	32(%rax), %edi
	jg	.L1667
	movq	%rax, %rbx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L1751
.L1663:
	cmpq	%rbx, 80(%r12)
	jne	.L1669
	cmpq	%r14, %r13
	je	.L1670
.L1669:
	cmpq	%rbx, %r13
	je	.L1672
	.p2align 4,,10
	.p2align 3
.L1673:
	movq	%rbx, %rdi
	movq	%rbx, %r15
	call	_ZSt18_Rb_tree_incrementPKSt18_Rb_tree_node_base@PLT
	movq	%r14, %rsi
	movq	%r15, %rdi
	movq	%rax, %rbx
	call	_ZSt28_Rb_tree_rebalance_for_erasePSt18_Rb_tree_node_baseRS_@PLT
	movq	%rax, %rdi
	call	_ZdlPv@PLT
	subq	$1, 96(%r12)
	cmpq	%rbx, %r13
	jne	.L1673
	movq	96(%rsp), %r9
	movq	104(%rsp), %r15
	jmp	.L1672
	.p2align 4,,10
	.p2align 3
.L1667:
	movq	24(%rax), %rax
	jmp	.L1668
	.p2align 4,,10
	.p2align 3
.L1654:
	cmpq	80(%r12), %r14
	jne	.L1672
	jmp	.L1671
	.p2align 4,,10
	.p2align 3
.L1652:
	leaq	32(%r14), %rdx
	movq	%r15, %rsi
	movq	%rbp, %rdi
.LEHB135:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE135:
	movq	104(%rsp), %r15
	jmp	.L1648
.L1745:
	movq	%r15, %r9
	jmp	.L1646
.L1749:
	call	__stack_chk_fail@PLT
.L1686:
	endbr64
	movq	%rax, %rbp
	jmp	.L1678
.L1687:
	endbr64
	movq	%rax, %rbp
	jmp	.L1630
.L1688:
	endbr64
	movq	%rax, %rbp
	jmp	.L1676
	.section	.gcc_except_table
.LLSDA8744:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8744-.LLSDACSB8744
.LLSDACSB8744:
	.uleb128 .LEHB133-.LFB8744
	.uleb128 .LEHE133-.LEHB133
	.uleb128 .L1687-.LFB8744
	.uleb128 0
	.uleb128 .LEHB134-.LFB8744
	.uleb128 .LEHE134-.LEHB134
	.uleb128 .L1686-.LFB8744
	.uleb128 0
	.uleb128 .LEHB135-.LFB8744
	.uleb128 .LEHE135-.LEHB135
	.uleb128 .L1688-.LFB8744
	.uleb128 0
.LLSDACSE8744:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8744
	.type	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE.cold, @function
_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE.cold:
.LFSB8744:
.L1676:
	.cfi_def_cfa_offset 224
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1678
	call	_ZdlPv@PLT
.L1678:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L1633:
	movq	64(%rsp), %rsi
	leaq	48(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
.LEHB136:
	call	_Unwind_Resume@PLT
.LEHE136:
.L1630:
	movq	72(%r12), %rsi
	leaq	56(%r12), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	24(%r12), %rdi
	testq	%rdi, %rdi
	je	.L1631
	call	_ZdlPv@PLT
.L1631:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L1632
	call	_ZdlPv@PLT
.L1632:
	movq	112(%rsp), %rsi
	leaq	96(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	jmp	.L1633
	.cfi_endproc
.LFE8744:
	.section	.gcc_except_table
.LLSDAC8744:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8744-.LLSDACSBC8744
.LLSDACSBC8744:
	.uleb128 .LEHB136-.LCOLDB39
	.uleb128 .LEHE136-.LEHB136
	.uleb128 0
	.uleb128 0
.LLSDACSEC8744:
	.section	.text.unlikely
	.text
	.size	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE, .-_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
	.section	.text.unlikely
	.size	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE.cold, .-_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE.cold
.LCOLDE39:
	.text
.LHOTE39:
	.section	.text.unlikely
.LCOLDB40:
	.text
.LHOTB40:
	.p2align 4
	.globl	_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE
	.type	_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE, @function
_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE:
.LFB8745:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8745
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rdx, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rsi, %rbx
	subq	$200, %rsp
	.cfi_def_cfa_offset 256
	movq	8(%rsi), %rbp
	subq	(%rsi), %rbp
	movq	%fs:40, %rax
	movq	%rax, 184(%rsp)
	xorl	%eax, %eax
	sarq	$3, %rbp
	leaq	112(%rsp), %r13
	salq	$2, %rbp
	movq	%rbp, %rdi
	call	malloc@PLT
	movq	%rbp, %rdi
	movq	%rax, (%rsp)
	call	malloc@PLT
	movq	%rbx, %xmm0
	movq	%r13, %rsi
	xorl	%ecx, %ecx
	movhps	(%rsp), %xmm0
	movl	$16, %edx
	movq	%rax, %rbp
	movq	%rax, 128(%rsp)
	leaq	_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE._omp_fn.0(%rip), %rdi
	movaps	%xmm0, 112(%rsp)
	call	GOMP_parallel@PLT
	movq	8(%r14), %rdx
	movq	(%r14), %rsi
	pxor	%xmm0, %xmm0
	movq	%rdx, %r15
	subq	%rsi, %r15
	movq	%r15, %rax
	sarq	$2, %rax
	cmpl	$2, %eax
	jle	.L1753
	movq	$0, 32(%rsp)
	movaps	%xmm0, 16(%rsp)
	testq	%rax, %rax
	je	.L1871
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1872
	movq	%r15, %rdi
.LEHB137:
	call	_Znwm@PLT
.LEHE137:
	movq	8(%r14), %rdx
	movq	(%r14), %rsi
	movq	%rax, %rcx
	movq	%rdx, %r8
	subq	%rsi, %r8
	movq	%r8, %rbx
	sarq	$2, %rbx
.L1755:
	movq	%rcx, %xmm0
	addq	%rcx, %r15
	punpcklqdq	%xmm0, %xmm0
	movq	%r15, 32(%rsp)
	movaps	%xmm0, 16(%rsp)
	cmpq	%rdx, %rsi
	je	.L1757
	movq	%r8, %rdx
	movq	%rcx, %rdi
	movq	%r8, 8(%rsp)
	call	memmove@PLT
	movq	8(%rsp), %r8
	movq	%rax, %rcx
.L1757:
	addq	%r8, %rcx
	pxor	%xmm0, %xmm0
	movl	$8, %edi
	movq	$0, 64(%rsp)
	movq	%rcx, 24(%rsp)
	movaps	%xmm0, 48(%rsp)
.LEHB138:
	call	_Znwm@PLT
.LEHE138:
	movl	%ebx, %esi
	leaq	8(%rax), %rdx
	movq	%rax, 48(%rsp)
	movabsq	$4294967297, %rcx
	shrl	$31, %esi
	movq	%rdx, 64(%rsp)
	addl	%ebx, %esi
	movq	%rcx, (%rax)
	movq	%rdx, 56(%rsp)
	sarl	%esi
	cmpl	$1, %ebx
	jle	.L1758
	movq	(%r14), %rdi
	movl	(%rax), %ecx
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L1765:
	imull	(%rdi,%rdx,4), %ecx
	addq	$1, %rdx
	movl	%ecx, (%rax)
	cmpl	%edx, %esi
	jg	.L1765
.L1758:
	cmpl	%ebx, %esi
	jge	.L1766
	subl	$1, %ebx
	movslq	%esi, %r8
	movq	(%r14), %rdi
	movl	4(%rax), %ecx
	subl	%esi, %ebx
	addq	%r8, %rbx
	leaq	(%rdi,%r8,4), %rdx
	leaq	4(%rdi,%rbx,4), %rsi
	.p2align 4,,10
	.p2align 3
.L1767:
	imull	(%rdx), %ecx
	addq	$4, %rdx
	movl	%ecx, 4(%rax)
	cmpq	%rdx, %rsi
	jne	.L1767
.L1766:
	pxor	%xmm0, %xmm0
	movq	%rbp, %xmm2
	leaq	48(%rsp), %rsi
	movq	%r13, %rdi
	movaps	%xmm0, 112(%rsp)
	movaps	%xmm0, 128(%rsp)
	movaps	%xmm0, 144(%rsp)
	movq	(%rsp), %xmm0
	punpcklqdq	%xmm2, %xmm0
	movups	%xmm0, 168(%rsp)
.LEHB139:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	112(%rsp), %rdx
	leaq	16(%rsp), %rsi
	leaq	136(%rsp), %rdi
	movl	(%rdx), %eax
	imull	4(%rdx), %eax
	movl	%eax, 160(%rsp)
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE139:
	movq	56(%rsp), %rdx
	movq	48(%rsp), %rsi
	pxor	%xmm0, %xmm0
	movq	$0, 96(%rsp)
	movaps	%xmm0, 80(%rsp)
	movq	%rdx, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rax
	sarq	$2, %rax
	je	.L1873
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1874
	movq	%rbx, %rdi
.LEHB140:
	call	_Znwm@PLT
.LEHE140:
	movq	56(%rsp), %rdx
	movq	48(%rsp), %rsi
	movq	%rax, %rcx
	movq	%rdx, %rbp
	subq	%rsi, %rbp
.L1774:
	movq	%rcx, %xmm0
	leaq	(%rcx,%rbx), %rax
	punpcklqdq	%xmm0, %xmm0
	movq	%rax, 96(%rsp)
	movaps	%xmm0, 80(%rsp)
	cmpq	%rsi, %rdx
	je	.L1776
	movq	%rcx, %rdi
	movq	%rbp, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1776:
	addq	%rbp, %rcx
	leaq	80(%rsp), %rdx
	movq	%r13, %rsi
	movq	%r12, %rdi
	movq	%rcx, 88(%rsp)
.LEHB141:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE141:
	movq	80(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1777
	call	_ZdlPv@PLT
.L1777:
	movq	136(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1778
	call	_ZdlPv@PLT
.L1778:
	movq	112(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1779
	call	_ZdlPv@PLT
.L1779:
	movq	48(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1780
	call	_ZdlPv@PLT
.L1780:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1752
.L1867:
	call	_ZdlPv@PLT
.L1752:
	movq	184(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1875
	addq	$200, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1753:
	.cfi_restore_state
	movaps	%xmm0, 112(%rsp)
	movq	%rbp, %xmm1
	movq	%r14, %rsi
	movq	%r13, %rdi
	movaps	%xmm0, 128(%rsp)
	movaps	%xmm0, 144(%rsp)
	movq	(%rsp), %xmm0
	punpcklqdq	%xmm1, %xmm0
	movups	%xmm0, 168(%rsp)
.LEHB142:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	112(%rsp), %rdx
	leaq	136(%rsp), %rdi
	movq	%r14, %rsi
	movl	(%rdx), %eax
	imull	4(%rdx), %eax
	movl	%eax, 160(%rsp)
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE142:
	movq	8(%r14), %rdx
	movq	(%r14), %rsi
	pxor	%xmm0, %xmm0
	movq	$0, 96(%rsp)
	movaps	%xmm0, 80(%rsp)
	movq	%rdx, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rax
	sarq	$2, %rax
	je	.L1876
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1877
	movq	%rbx, %rdi
.LEHB143:
	call	_Znwm@PLT
.LEHE143:
	movq	8(%r14), %rdx
	movq	(%r14), %rsi
	movq	%rax, %rcx
	movq	%rdx, %rbp
	subq	%rsi, %rbp
.L1788:
	movq	%rcx, %xmm0
	leaq	(%rcx,%rbx), %rax
	punpcklqdq	%xmm0, %xmm0
	movq	%rax, 96(%rsp)
	movaps	%xmm0, 80(%rsp)
	cmpq	%rdx, %rsi
	je	.L1790
	movq	%rcx, %rdi
	movq	%rbp, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1790:
	addq	%rbp, %rcx
	leaq	80(%rsp), %rdx
	movq	%r13, %rsi
	movq	%r12, %rdi
	movq	%rcx, 88(%rsp)
.LEHB144:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE144:
	movq	80(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1791
	call	_ZdlPv@PLT
.L1791:
	movq	136(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1792
	call	_ZdlPv@PLT
.L1792:
	movq	112(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1867
	jmp	.L1752
	.p2align 4,,10
	.p2align 3
.L1871:
	movq	%r15, %r8
	xorl	%ebx, %ebx
	xorl	%ecx, %ecx
	jmp	.L1755
	.p2align 4,,10
	.p2align 3
.L1873:
	movq	%rbx, %rbp
	xorl	%ecx, %ecx
	jmp	.L1774
	.p2align 4,,10
	.p2align 3
.L1876:
	movq	%rbx, %rbp
	xorl	%ecx, %ecx
	jmp	.L1788
.L1875:
	call	__stack_chk_fail@PLT
.L1872:
.LEHB145:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE145:
.L1874:
.LEHB146:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE146:
.L1877:
.LEHB147:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE147:
.L1806:
	endbr64
	movq	%rax, %rbp
	jmp	.L1799
.L1803:
	endbr64
	movq	%rax, %rbp
	jmp	.L1796
.L1804:
	endbr64
	movq	%rax, %rbp
	jmp	.L1794
.L1809:
	endbr64
	movq	%rax, %rbp
	jmp	.L1784
.L1805:
	endbr64
	movq	%rax, %rbp
	jmp	.L1801
.L1807:
	endbr64
	movq	%rax, %rbp
	jmp	.L1772
.L1808:
	endbr64
	movq	%rax, %rbp
	jmp	.L1769
	.section	.gcc_except_table
.LLSDA8745:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8745-.LLSDACSB8745
.LLSDACSB8745:
	.uleb128 .LEHB137-.LFB8745
	.uleb128 .LEHE137-.LEHB137
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB138-.LFB8745
	.uleb128 .LEHE138-.LEHB138
	.uleb128 .L1807-.LFB8745
	.uleb128 0
	.uleb128 .LEHB139-.LFB8745
	.uleb128 .LEHE139-.LEHB139
	.uleb128 .L1808-.LFB8745
	.uleb128 0
	.uleb128 .LEHB140-.LFB8745
	.uleb128 .LEHE140-.LEHB140
	.uleb128 .L1803-.LFB8745
	.uleb128 0
	.uleb128 .LEHB141-.LFB8745
	.uleb128 .LEHE141-.LEHB141
	.uleb128 .L1804-.LFB8745
	.uleb128 0
	.uleb128 .LEHB142-.LFB8745
	.uleb128 .LEHE142-.LEHB142
	.uleb128 .L1809-.LFB8745
	.uleb128 0
	.uleb128 .LEHB143-.LFB8745
	.uleb128 .LEHE143-.LEHB143
	.uleb128 .L1805-.LFB8745
	.uleb128 0
	.uleb128 .LEHB144-.LFB8745
	.uleb128 .LEHE144-.LEHB144
	.uleb128 .L1806-.LFB8745
	.uleb128 0
	.uleb128 .LEHB145-.LFB8745
	.uleb128 .LEHE145-.LEHB145
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB146-.LFB8745
	.uleb128 .LEHE146-.LEHB146
	.uleb128 .L1803-.LFB8745
	.uleb128 0
	.uleb128 .LEHB147-.LFB8745
	.uleb128 .LEHE147-.LEHB147
	.uleb128 .L1805-.LFB8745
	.uleb128 0
.LLSDACSE8745:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8745
	.type	_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE.cold, @function
_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE.cold:
.LFSB8745:
.L1799:
	.cfi_def_cfa_offset 256
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	80(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1878
.L1801:
	movq	%r13, %rdi
	call	_ZN11denseMatrixD1Ev
.L1868:
	movq	%rbp, %rdi
.LEHB148:
	call	_Unwind_Resume@PLT
.LEHE148:
.L1794:
	movq	80(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1796
	call	_ZdlPv@PLT
.L1796:
	movq	%r13, %rdi
	call	_ZN11denseMatrixD1Ev
.L1772:
	movq	48(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1762
	call	_ZdlPv@PLT
.L1762:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1868
.L1870:
	call	_ZdlPv@PLT
	jmp	.L1868
.L1784:
	movq	136(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1785
	call	_ZdlPv@PLT
.L1785:
	movq	112(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1870
	jmp	.L1868
.L1878:
	call	_ZdlPv@PLT
	jmp	.L1801
.L1769:
	movq	136(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1770
	call	_ZdlPv@PLT
.L1770:
	movq	112(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1772
	call	_ZdlPv@PLT
	jmp	.L1772
	.cfi_endproc
.LFE8745:
	.section	.gcc_except_table
.LLSDAC8745:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8745-.LLSDACSBC8745
.LLSDACSBC8745:
	.uleb128 .LEHB148-.LCOLDB40
	.uleb128 .LEHE148-.LEHB148
	.uleb128 0
	.uleb128 0
.LLSDACSEC8745:
	.section	.text.unlikely
	.text
	.size	_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE, .-_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE
	.section	.text.unlikely
	.size	_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE.cold, .-_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE.cold
.LCOLDE40:
	.text
.LHOTE40:
	.section	.rodata.str1.1
.LC41:
	.string	"!="
	.section	.rodata.str1.8
	.align 8
.LC42:
	.string	"cannot reshape into given shape"
	.section	.text.unlikely
.LCOLDB43:
	.text
.LHOTB43:
	.p2align 4
	.globl	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE
	.type	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE, @function
_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE:
.LFB8723:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8723
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rsi, %rax
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdx, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$264, %rsp
	.cfi_def_cfa_offset 320
	movq	24(%rax), %rdi
	movq	32(%rax), %rax
	movq	%rsi, 40(%rsp)
	movq	%rax, %rcx
	subq	%rdi, %rcx
	movq	%fs:40, %rsi
	movq	%rsi, 248(%rsp)
	xorl	%esi, %esi
	sarq	$2, %rcx
	movq	%rax, (%rsp)
	je	.L2001
	leaq	-1(%rcx), %rax
	cmpq	$28, %rax
	jbe	.L1943
	movq	%rcx, %rdx
	movdqa	.LC34(%rip), %xmm1
	movq	%rdi, %rax
	shrq	$2, %rdx
	salq	$4, %rdx
	addq	%rdi, %rdx
	.p2align 4,,10
	.p2align 3
.L1884:
	movdqu	(%rax), %xmm2
	movdqu	(%rax), %xmm0
	addq	$16, %rax
	pmuludq	%xmm1, %xmm2
	psrlq	$32, %xmm0
	psrlq	$32, %xmm1
	pmuludq	%xmm1, %xmm0
	pshufd	$8, %xmm2, %xmm1
	pshufd	$8, %xmm0, %xmm0
	punpckldq	%xmm0, %xmm1
	cmpq	%rdx, %rax
	jne	.L1884
	movdqa	%xmm1, %xmm2
	movdqa	%xmm1, %xmm0
	movq	%rcx, %rdx
	psrldq	$8, %xmm2
	psrlq	$32, %xmm1
	andq	$-4, %rdx
	pmuludq	%xmm2, %xmm0
	psrlq	$32, %xmm2
	movslq	%edx, %rax
	pmuludq	%xmm2, %xmm1
	pshufd	$8, %xmm0, %xmm0
	pshufd	$8, %xmm1, %xmm1
	punpckldq	%xmm1, %xmm0
	movdqa	%xmm0, %xmm1
	psrldq	$4, %xmm1
	pmuludq	%xmm1, %xmm0
	movd	%xmm0, %esi
	cmpq	%rcx, %rdx
	je	.L1887
.L1883:
	addq	$1, %rax
	.p2align 4,,10
	.p2align 3
.L1888:
	imull	(%rdi,%rdx,4), %esi
	movq	%rax, %rdx
	addq	$1, %rax
	cmpq	%rdx, %rcx
	ja	.L1888
.L1887:
	movq	0(%rbp), %rcx
	movq	8(%rbp), %rbx
	subq	%rcx, %rbx
	sarq	$2, %rbx
	movq	%rbx, %rdi
	je	.L2002
.L1881:
	leaq	-1(%rbx), %rax
	cmpq	$28, %rax
	jbe	.L1944
	movq	%rbx, %rdx
	movdqa	.LC34(%rip), %xmm1
	movq	%rcx, %rax
	shrq	$2, %rdx
	salq	$4, %rdx
	addq	%rcx, %rdx
	.p2align 4,,10
	.p2align 3
.L1890:
	movdqu	(%rax), %xmm2
	movdqu	(%rax), %xmm0
	addq	$16, %rax
	pmuludq	%xmm1, %xmm2
	psrlq	$32, %xmm0
	psrlq	$32, %xmm1
	pmuludq	%xmm1, %xmm0
	pshufd	$8, %xmm2, %xmm1
	pshufd	$8, %xmm0, %xmm0
	punpckldq	%xmm0, %xmm1
	cmpq	%rdx, %rax
	jne	.L1890
	movdqa	%xmm1, %xmm0
	movq	%rbx, %rdx
	psrldq	$8, %xmm0
	andq	$-4, %rdx
	movdqa	%xmm0, %xmm2
	psrlq	$32, %xmm0
	movslq	%edx, %rax
	pmuludq	%xmm1, %xmm2
	psrlq	$32, %xmm1
	pmuludq	%xmm0, %xmm1
	pshufd	$8, %xmm2, %xmm0
	pshufd	$8, %xmm1, %xmm1
	punpckldq	%xmm1, %xmm0
	movdqa	%xmm0, %xmm1
	psrldq	$4, %xmm1
	pmuludq	%xmm1, %xmm0
	movd	%xmm0, %r13d
	cmpq	%rbx, %rdx
	je	.L1891
.L1889:
	addq	$1, %rax
	.p2align 4,,10
	.p2align 3
.L1892:
	imull	(%rcx,%rdx,4), %r13d
	movq	%rax, %rdx
	addq	$1, %rax
	cmpq	%rdx, %rdi
	ja	.L1892
.L1891:
	cmpl	%r13d, %esi
	jne	.L1938
	movq	$0, 80(%rsp)
	pxor	%xmm0, %xmm0
	movl	%ebx, %r13d
	movaps	%xmm0, 64(%rsp)
	cmpl	$2, %ebx
	jle	.L1894
	movl	$8, %edi
	movaps	%xmm0, 192(%rsp)
	movq	$0, 208(%rsp)
.LEHB149:
	call	_Znwm@PLT
.LEHE149:
	movabsq	$4294967297, %rsi
	leaq	192(%rsp), %r14
	leaq	8(%rax), %rdx
	movq	%rax, 192(%rsp)
	movq	%rsi, (%rax)
	leaq	64(%rsp), %r15
	movq	%r14, %rsi
	movq	%r15, %rdi
	movq	%rdx, 208(%rsp)
	movq	%rdx, 200(%rsp)
.LEHB150:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE150:
	movq	0(%rbp), %r9
	movq	64(%rsp), %rsi
	movl	%ebx, %r8d
	sarl	%r8d
	leaq	4(%r9), %rdi
	leal	-1(%r8), %ecx
	movl	(%rsi), %edx
	movq	%r9, %rax
	leaq	(%rdi,%rcx,4), %rcx
	.p2align 4,,10
	.p2align 3
.L1899:
	imull	(%rax), %edx
	addq	$4, %rax
	movl	%edx, (%rsi)
	cmpq	%rcx, %rax
	jne	.L1899
	cmpl	%r8d, %r13d
	jle	.L1903
	subl	$1, %ebx
	movslq	%r8d, %rcx
	movl	4(%rsi), %edx
	subl	%r8d, %ebx
	leaq	(%r9,%rcx,4), %rax
	addq	%rbx, %rcx
	leaq	(%rdi,%rcx,4), %rcx
	.p2align 4,,10
	.p2align 3
.L1904:
	imull	(%rax), %edx
	addq	$4, %rax
	movl	%edx, 4(%rsi)
	cmpq	%rax, %rcx
	jne	.L1904
.L1903:
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1905
	call	_ZdlPv@PLT
.L1905:
	leaq	152(%rsp), %rax
	pxor	%xmm0, %xmm0
	movl	$0, 64(%r12)
	movq	%r15, %rsi
	movq	%rax, 168(%rsp)
	movq	%r12, %rdi
	leaq	24(%r12), %r13
	movq	%rax, 176(%rsp)
	leaq	200(%rsp), %rax
	movq	%rax, 32(%rsp)
	movq	%rax, 216(%rsp)
	movq	%rax, 224(%rsp)
	leaq	64(%r12), %rax
	movq	$0, 72(%r12)
	movq	%rax, 80(%r12)
	movq	%rax, 88(%r12)
	movq	$0, 96(%r12)
	movups	%xmm0, (%r12)
	movups	%xmm0, 16(%r12)
	movups	%xmm0, 32(%r12)
	movl	$0, 152(%rsp)
	movq	$0, 160(%rsp)
	movq	$0, 184(%rsp)
	movl	$0, 200(%rsp)
	movq	$0, 208(%rsp)
	movq	$0, 232(%rsp)
.LEHB151:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	%rbp, %rsi
	movq	%r13, %rdi
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE151:
	movq	(%r12), %rax
	movq	208(%rsp), %rbx
	movl	(%rax), %eax
	movl	%eax, 48(%r12)
	testq	%rbx, %rbx
	je	.L1913
.L1906:
	movq	24(%rbx), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1906
.L1913:
	movl	$0, 200(%rsp)
	movq	32(%rsp), %rax
	movq	$0, 208(%rsp)
	movq	%rax, 216(%rsp)
	movq	%rax, 224(%rsp)
	movq	40(%rsp), %rax
	movq	$0, 232(%rsp)
	movq	72(%rax), %rsi
	testq	%rsi, %rsi
	je	.L2003
	leaq	96(%rsp), %rbp
	movq	32(%rsp), %rdx
	movq	%r14, %rdi
	movq	%r14, 96(%rsp)
	movq	%rbp, %rcx
.LEHB152:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE152:
	movq	%rax, %rsi
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1914:
	movq	%rdx, %rax
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1914
	movq	%rax, 216(%rsp)
	movq	%rsi, %rdx
	.p2align 4,,10
	.p2align 3
.L1915:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1915
	movq	%rcx, 224(%rsp)
	movq	40(%rsp), %rcx
	movq	%rsi, 208(%rsp)
	movq	$0, 56(%rsp)
	movq	96(%rcx), %rdx
	movq	(%r12), %rcx
	movq	%rdx, 232(%rsp)
	movl	(%rcx), %r13d
	movl	4(%rcx), %ecx
	movl	%r13d, %ebx
	negl	%ebx
	cmpl	%ecx, %ebx
	jge	.L1916
.L1939:
	leaq	56(%r12), %r15
	jmp	.L1922
	.p2align 4,,10
	.p2align 3
.L2005:
	movl	%ecx, %eax
	subl	%ebx, %eax
.L1918:
	cmpl	%r13d, %eax
	jg	.L1920
	cmpl	%eax, %ecx
	cmovle	%ecx, %eax
	movl	%eax, %r13d
.L1920:
	movslq	%r13d, %rdi
	movl	$4, %esi
	movq	%rdi, 24(%rsp)
	call	calloc@PLT
	movq	24(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, (%rsp)
	call	calloc@PLT
	movq	%rbp, %rsi
	movq	%r15, %rdi
	movl	%ebx, 96(%rsp)
	movq	(%rsp), %xmm0
	movq	%rax, %xmm3
	movl	%ebx, 104(%rsp)
	movl	%r13d, 108(%rsp)
	punpcklqdq	%xmm3, %xmm0
	movaps	%xmm0, 112(%rsp)
.LEHB153:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
.LEHE153:
	movq	(%r12), %rax
	addl	$1, %ebx
	movl	4(%rax), %ecx
	cmpl	%ebx, %ecx
	jle	.L2004
	movl	(%rax), %r13d
.L1922:
	leal	(%rbx,%r13), %eax
	testl	%ebx, %ebx
	js	.L1918
	jne	.L2005
	cmpl	%r13d, %ecx
	movl	%r13d, %eax
	cmovle	%ecx, %eax
	jmp	.L1918
	.p2align 4,,10
	.p2align 3
.L2002:
	cmpl	$1, %esi
	jne	.L2006
.L1882:
	movq	$0, 80(%rsp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, 64(%rsp)
.L1894:
	leaq	64(%rsp), %r15
	movq	%rbp, %rsi
	movq	%r15, %rdi
.LEHB154:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE154:
	leaq	192(%rsp), %r14
	jmp	.L1905
	.p2align 4,,10
	.p2align 3
.L2004:
	movq	216(%rsp), %rax
.L1916:
	movq	%r12, %xmm6
	movq	%rax, 56(%rsp)
	movq	40(%rsp), %xmm5
	leaq	56(%rsp), %r15
	leaq	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0(%rip), %rbx
	punpcklqdq	%xmm6, %xmm5
	movaps	%xmm5, (%rsp)
	cmpq	32(%rsp), %rax
	je	.L1925
	.p2align 4,,10
	.p2align 3
.L1923:
	movq	48(%rax), %rdx
	movdqa	(%rsp), %xmm4
	xorl	%ecx, %ecx
	movq	%rbp, %rsi
	movq	56(%rax), %rax
	movq	%rbx, %rdi
	movq	%r15, 112(%rsp)
	movq	%rdx, 120(%rsp)
	movl	$16, %edx
	movq	%rax, 128(%rsp)
	movaps	%xmm4, 96(%rsp)
	call	GOMP_parallel@PLT
	movq	56(%rsp), %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, 56(%rsp)
	cmpq	32(%rsp), %rax
	jne	.L1923
.L1925:
	movq	%r12, %rdi
.LEHB155:
	call	_ZN19quantumSparseMatrix11pruneMatrixEv
.LEHE155:
	movq	208(%rsp), %rbx
	testq	%rbx, %rbx
	je	.L1929
.L1926:
	movq	24(%rbx), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1926
.L1929:
	movq	160(%rsp), %rbx
	leaq	144(%rsp), %rbp
	testq	%rbx, %rbx
	je	.L1927
.L1928:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1928
.L1927:
	movq	64(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1879
	call	_ZdlPv@PLT
.L1879:
	movq	248(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L2007
	addq	$264, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2003:
	.cfi_restore_state
	movq	(%r12), %rax
	leaq	96(%rsp), %rbp
	movq	$0, 56(%rsp)
	movl	(%rax), %r13d
	movl	4(%rax), %ecx
	movl	%r13d, %ebx
	negl	%ebx
	cmpl	%ecx, %ebx
	jl	.L1939
	movq	32(%rsp), %rax
	movq	%rax, 56(%rsp)
	jmp	.L1925
	.p2align 4,,10
	.p2align 3
.L2001:
	movq	(%rdx), %rcx
	movq	8(%rdx), %rbx
	movl	$1, %esi
	subq	%rcx, %rbx
	sarq	$2, %rbx
	movq	%rbx, %rdi
	jne	.L1881
	jmp	.L1882
.L1944:
	xorl	%eax, %eax
	movl	$1, %r13d
	xorl	%edx, %edx
	jmp	.L1889
.L1943:
	xorl	%eax, %eax
	movl	$1, %esi
	xorl	%edx, %edx
	jmp	.L1883
.L2006:
	movl	$1, %r13d
.L1938:
	leaq	_ZSt4cout(%rip), %rdi
.LEHB156:
	call	_ZNSolsEi@PLT
	movl	$2, %edx
	leaq	.LC41(%rip), %rsi
	movq	%rax, %rbp
	movq	%rax, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%r13d, %esi
	movq	%rbp, %rdi
	call	_ZNSolsEi@PLT
	movq	%rax, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE156:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC42(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
.LEHB157:
	call	_ZNSt16invalid_argumentC1EPKc@PLT
.LEHE157:
	jmp	.L1993
.L2007:
	call	__stack_chk_fail@PLT
.L1946:
	endbr64
	movq	%rax, %r12
	jmp	.L1932
.L1949:
	endbr64
	movq	%rax, %rbp
	jmp	.L1936
.L1950:
	endbr64
	movq	%rax, %rbp
	jmp	.L1935
.L1947:
	endbr64
	movq	%rax, %rbp
	jmp	.L1933
.L1952:
	endbr64
	movq	%rax, %rbp
	jmp	.L1909
.L1951:
	endbr64
	movq	%rax, %rbp
	jmp	.L1896
.L1948:
	endbr64
	movq	%rax, %rbp
	jmp	.L1898
	.section	.gcc_except_table
.LLSDA8723:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8723-.LLSDACSB8723
.LLSDACSB8723:
	.uleb128 .LEHB149-.LFB8723
	.uleb128 .LEHE149-.LEHB149
	.uleb128 .L1951-.LFB8723
	.uleb128 0
	.uleb128 .LEHB150-.LFB8723
	.uleb128 .LEHE150-.LEHB150
	.uleb128 .L1947-.LFB8723
	.uleb128 0
	.uleb128 .LEHB151-.LFB8723
	.uleb128 .LEHE151-.LEHB151
	.uleb128 .L1952-.LFB8723
	.uleb128 0
	.uleb128 .LEHB152-.LFB8723
	.uleb128 .LEHE152-.LEHB152
	.uleb128 .L1949-.LFB8723
	.uleb128 0
	.uleb128 .LEHB153-.LFB8723
	.uleb128 .LEHE153-.LEHB153
	.uleb128 .L1950-.LFB8723
	.uleb128 0
	.uleb128 .LEHB154-.LFB8723
	.uleb128 .LEHE154-.LEHB154
	.uleb128 .L1948-.LFB8723
	.uleb128 0
	.uleb128 .LEHB155-.LFB8723
	.uleb128 .LEHE155-.LEHB155
	.uleb128 .L1950-.LFB8723
	.uleb128 0
	.uleb128 .LEHB156-.LFB8723
	.uleb128 .LEHE156-.LEHB156
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB157-.LFB8723
	.uleb128 .LEHE157-.LEHB157
	.uleb128 .L1946-.LFB8723
	.uleb128 0
.LLSDACSE8723:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8723
	.type	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE.cold, @function
_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE.cold:
.LFSB8723:
.L1993:
	.cfi_def_cfa_offset 320
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	_ZNSt16invalid_argumentD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt16invalid_argument(%rip), %rsi
	movq	%rbp, %rdi
.LEHB158:
	call	__cxa_throw@PLT
.L1932:
	movq	%rbp, %rdi
	call	__cxa_free_exception@PLT
	movq	%r12, %rdi
	call	_Unwind_Resume@PLT
.L1935:
	movq	208(%rsp), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L1936:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L1912:
	movq	160(%rsp), %rsi
	leaq	144(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L1898:
	movq	64(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1937
	call	_ZdlPv@PLT
.L1937:
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE158:
.L1933:
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1898
	call	_ZdlPv@PLT
	jmp	.L1898
.L1909:
	movq	72(%r12), %rsi
	leaq	56(%r12), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	24(%r12), %rdi
	testq	%rdi, %rdi
	je	.L1910
	call	_ZdlPv@PLT
.L1910:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L1911
	call	_ZdlPv@PLT
.L1911:
	movq	208(%rsp), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	jmp	.L1912
.L1896:
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1898
	call	_ZdlPv@PLT
	jmp	.L1898
	.cfi_endproc
.LFE8723:
	.section	.gcc_except_table
.LLSDAC8723:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8723-.LLSDACSBC8723
.LLSDACSBC8723:
	.uleb128 .LEHB158-.LCOLDB43
	.uleb128 .LEHE158-.LEHB158
	.uleb128 0
	.uleb128 0
.LLSDACSEC8723:
	.section	.text.unlikely
	.text
	.size	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE, .-_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE
	.section	.text.unlikely
	.size	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE.cold, .-_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE.cold
.LCOLDE43:
	.text
.LHOTE43:
	.section	.text.unlikely
.LCOLDB45:
	.text
.LHOTB45:
	.p2align 4
	.globl	_Z11checkResultB5cxx1119quantumSparseMatrixS_
	.type	_Z11checkResultB5cxx1119quantumSparseMatrixS_, @function
_Z11checkResultB5cxx1119quantumSparseMatrixS_:
.LFB8758:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8758
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$152, %rsp
	.cfi_def_cfa_offset 208
	movq	%fs:40, %rax
	movq	%rax, 136(%rsp)
	xorl	%eax, %eax
	movl	48(%rdx), %eax
	cmpl	%eax, 48(%rsi)
	je	.L2009
	leaq	16(%rdi), %rax
	movb	$49, 24(%rdi)
	movabsq	$2318545003265941862, %rbx
	movq	%rax, (%rdi)
	movq	%rbx, 16(%rdi)
	movq	$9, 8(%rdi)
	movb	$0, 25(%rdi)
.L2008:
	movq	136(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L2070
	addq	$152, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2009:
	.cfi_restore_state
	movq	%rsi, %rbp
	movq	72(%rsi), %rsi
	movq	%rdx, %r15
	leaq	40(%rsp), %rdx
	movl	$0, 40(%rsp)
	leaq	32(%rsp), %r13
	movq	$0, 48(%rsp)
	movq	%rdx, 8(%rsp)
	movq	%rdx, 56(%rsp)
	movq	%rdx, 64(%rsp)
	movq	$0, 72(%rsp)
	testq	%rsi, %rsi
	je	.L2042
	leaq	80(%rsp), %rbx
	movq	%r13, %rdi
	movq	%r13, 80(%rsp)
	movq	%rbx, %rcx
.LEHB159:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE159:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2012:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2012
	movq	%rcx, 56(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2013:
	movq	%rdx, %rsi
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2013
	movq	96(%rbp), %rdx
	movq	%rsi, 64(%rsp)
	movq	%rax, 48(%rsp)
	movq	%rdx, 72(%rsp)
.L2011:
	movq	72(%r15), %r14
	leaq	88(%rsp), %rbp
	movl	$0, 88(%rsp)
	movq	$0, 96(%rsp)
	movq	%rbp, 104(%rsp)
	movq	%rbp, 112(%rsp)
	movq	$0, 120(%rsp)
	testq	%r14, %r14
	je	.L2014
	leaq	24(%rsp), %rcx
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movq	%rbx, %rdi
	movq	%rbx, 24(%rsp)
.LEHB160:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE160:
	movq	%rax, %r14
	.p2align 4,,10
	.p2align 3
.L2015:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2015
	movq	%rdx, 104(%rsp)
	movq	%r14, %rax
	.p2align 4,,10
	.p2align 3
.L2016:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2016
	movq	96(%r15), %rax
	movq	56(%rsp), %rdi
	movq	%rdx, 112(%rsp)
	movq	%r14, 96(%rsp)
	movq	%rax, 120(%rsp)
	cmpq	8(%rsp), %rdi
	je	.L2032
	movsd	.LC44(%rip), %xmm1
.L2017:
	testq	%r14, %r14
	je	.L2019
	movl	32(%rdi), %eax
	movq	%r14, %rdx
	movq	%rbp, %rcx
	jmp	.L2020
	.p2align 4,,10
	.p2align 3
.L2071:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	je	.L2021
.L2020:
	cmpl	32(%rdx), %eax
	jle	.L2071
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2020
.L2021:
	cmpq	%rbp, %rcx
	je	.L2019
	cmpl	%eax, 32(%rcx)
	jle	.L2072
.L2019:
	leaq	16(%r12), %rax
	movb	$50, 24(%r12)
	movabsq	$2318545003265941862, %rcx
	movq	%rax, (%r12)
	movq	%rcx, 16(%r12)
	movq	$9, 8(%r12)
	movb	$0, 25(%r12)
.L2018:
	testq	%r14, %r14
	jne	.L2037
.L2036:
	movq	48(%rsp), %rbx
	testq	%rbx, %rbx
	je	.L2008
.L2035:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2035
	jmp	.L2008
	.p2align 4,,10
	.p2align 3
.L2042:
	movq	%rdx, %rcx
	leaq	80(%rsp), %rbx
	jmp	.L2011
	.p2align 4,,10
	.p2align 3
.L2072:
	movl	44(%rdi), %edx
	cmpl	%edx, 44(%rcx)
	jne	.L2073
	testl	%edx, %edx
	jle	.L2026
	subl	$1, %edx
	movq	48(%rcx), %r10
	movq	48(%rdi), %rax
	leaq	4(,%rdx,4), %r11
	xorl	%edx, %edx
	jmp	.L2031
	.p2align 4,,10
	.p2align 3
.L2066:
	movq	56(%rcx), %r8
	movq	56(%rdi), %rsi
	movss	(%r8,%rdx), %xmm0
	subss	(%rsi,%rdx), %xmm0
	cvtss2sd	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	ja	.L2074
	addq	$4, %rdx
	cmpq	%r11, %rdx
	je	.L2026
.L2031:
	movss	(%r10,%rdx), %xmm0
	subss	(%rax,%rdx), %xmm0
	cvtss2sd	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L2066
	leaq	16(%r12), %rax
	movb	$52, 24(%r12)
	movabsq	$2318545003265941862, %rcx
	movq	%rax, (%r12)
	movq	%rcx, 16(%r12)
	movq	$9, 8(%r12)
	movb	$0, 25(%r12)
	.p2align 4,,10
	.p2align 3
.L2037:
	movq	24(%r14), %rsi
	movq	%rbx, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r14, %rdi
	movq	16(%r14), %r14
	call	_ZdlPv@PLT
	testq	%r14, %r14
	jne	.L2037
	jmp	.L2036
	.p2align 4,,10
	.p2align 3
.L2026:
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	cmpq	8(%rsp), %rax
	movq	%rax, %rdi
	movq	.LC44(%rip), %rax
	movq	%rax, %xmm1
	jne	.L2017
	jmp	.L2032
	.p2align 4,,10
	.p2align 3
.L2014:
	cmpq	8(%rsp), %rcx
	jne	.L2019
.L2032:
	leaq	16(%r12), %rax
	movb	$0, 20(%r12)
	movq	%rax, (%r12)
	movl	$1702195828, 16(%r12)
	movq	$4, 8(%r12)
	jmp	.L2018
	.p2align 4,,10
	.p2align 3
.L2074:
	leaq	16(%r12), %rax
	movb	$53, 24(%r12)
	movabsq	$2318545003265941862, %rcx
	movq	%rax, (%r12)
	movq	%rcx, 16(%r12)
	movq	$9, 8(%r12)
	movb	$0, 25(%r12)
	jmp	.L2037
.L2073:
	leaq	16(%r12), %rax
	movb	$51, 24(%r12)
	movabsq	$2318545003265941862, %rcx
	movq	%rax, (%r12)
	movq	%rcx, 16(%r12)
	movq	$9, 8(%r12)
	movb	$0, 25(%r12)
	jmp	.L2037
.L2070:
	call	__stack_chk_fail@PLT
.L2043:
	endbr64
	movq	%rax, %rbp
	jmp	.L2038
	.section	.gcc_except_table
.LLSDA8758:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8758-.LLSDACSB8758
.LLSDACSB8758:
	.uleb128 .LEHB159-.LFB8758
	.uleb128 .LEHE159-.LEHB159
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB160-.LFB8758
	.uleb128 .LEHE160-.LEHB160
	.uleb128 .L2043-.LFB8758
	.uleb128 0
.LLSDACSE8758:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8758
	.type	_Z11checkResultB5cxx1119quantumSparseMatrixS_.cold, @function
_Z11checkResultB5cxx1119quantumSparseMatrixS_.cold:
.LFSB8758:
.L2038:
	.cfi_def_cfa_offset 208
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	48(%rsp), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
.LEHB161:
	call	_Unwind_Resume@PLT
.LEHE161:
	.cfi_endproc
.LFE8758:
	.section	.gcc_except_table
.LLSDAC8758:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8758-.LLSDACSBC8758
.LLSDACSBC8758:
	.uleb128 .LEHB161-.LCOLDB45
	.uleb128 .LEHE161-.LEHB161
	.uleb128 0
	.uleb128 0
.LLSDACSEC8758:
	.section	.text.unlikely
	.text
	.size	_Z11checkResultB5cxx1119quantumSparseMatrixS_, .-_Z11checkResultB5cxx1119quantumSparseMatrixS_
	.section	.text.unlikely
	.size	_Z11checkResultB5cxx1119quantumSparseMatrixS_.cold, .-_Z11checkResultB5cxx1119quantumSparseMatrixS_.cold
.LCOLDE45:
	.text
.LHOTE45:
	.section	.text.unlikely
.LCOLDB46:
	.text
.LHOTB46:
	.p2align 4
	.globl	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
	.type	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE, @function
_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE:
.LFB8729:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8729
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rdi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$456, %rsp
	.cfi_def_cfa_offset 512
	movq	32(%rsi), %r14
	movq	24(%rsi), %r12
	movq	%rsi, 40(%rsp)
	movq	%rdx, 56(%rsp)
	movq	%r14, %rbx
	subq	%r12, %rbx
	movq	%fs:40, %rcx
	movq	%rcx, 440(%rsp)
	xorl	%ecx, %ecx
	cmpq	$8, %rbx
	je	.L2269
	movq	(%rdx), %rsi
	movq	8(%rdx), %rdx
	cmpq	%rdx, %rsi
	je	.L2270
.L2096:
	movq	%rdx, %r15
	pxor	%xmm0, %xmm0
	movq	$0, 336(%rsp)
	subq	%rsi, %r15
	movaps	%xmm0, 320(%rsp)
	movq	%r15, %rax
	sarq	$2, %rax
	je	.L2271
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L2272
	movq	%r15, %rdi
.LEHB162:
	call	_Znwm@PLT
.LEHE162:
	movq	%rax, %rcx
	movq	40(%rsp), %rax
	movq	24(%rax), %r12
	movq	32(%rax), %r14
	movq	56(%rsp), %rax
	movq	%r14, %rbx
	movq	8(%rax), %rdx
	movq	(%rax), %rsi
	subq	%r12, %rbx
	movq	%rdx, %rbp
	subq	%rsi, %rbp
.L2099:
	movq	%rcx, %xmm0
	addq	%rcx, %r15
	punpcklqdq	%xmm0, %xmm0
	movq	%r15, 336(%rsp)
	movaps	%xmm0, 320(%rsp)
	cmpq	%rdx, %rsi
	je	.L2101
	movq	%rcx, %rdi
	movq	%rbp, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2101:
	movq	%rbx, %rax
	addq	%rbp, %rcx
	pxor	%xmm0, %xmm0
	movq	$0, 272(%rsp)
	sarq	$2, %rax
	movq	%rcx, 328(%rsp)
	movaps	%xmm0, 256(%rsp)
	je	.L2273
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L2274
	movq	%rbx, %rdi
.LEHB163:
	call	_Znwm@PLT
.LEHE163:
	movq	%rax, %rcx
	movq	40(%rsp), %rax
	movq	32(%rax), %r14
	movq	24(%rax), %r12
	movq	%r14, %r15
	subq	%r12, %r15
.L2103:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 272(%rsp)
	movaps	%xmm0, 256(%rsp)
	cmpq	%r14, %r12
	je	.L2105
	movq	%rcx, %rdi
	movq	%r15, %rdx
	movq	%r12, %rsi
	call	memmove@PLT
	movq	%rax, %rcx
.L2105:
	addq	%r15, %rcx
	leaq	96(%rsp), %rax
	leaq	320(%rsp), %r15
	leaq	256(%rsp), %r12
	movq	%r15, %rdx
	movq	%rax, %rdi
	movq	%rcx, 264(%rsp)
	movq	%r12, %rsi
	movq	%rax, (%rsp)
.LEHB164:
	call	_Z17modifyTensorShapeSt6vectorIiSaIiEES1_
.LEHE164:
	movq	256(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2106
	call	_ZdlPv@PLT
.L2106:
	movq	320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2107
	call	_ZdlPv@PLT
.L2107:
	movq	104(%rsp), %rbx
	pxor	%xmm0, %xmm0
	subq	96(%rsp), %rbx
	movl	$8, %edi
	movq	$0, 144(%rsp)
	sarq	$2, %rbx
	movaps	%xmm0, 128(%rsp)
.LEHB165:
	call	_Znwm@PLT
.LEHE165:
	movl	%ebx, %esi
	leaq	8(%rax), %rdx
	movabsq	$4294967297, %rcx
	movq	%rax, 128(%rsp)
	shrl	$31, %esi
	movq	%rdx, 144(%rsp)
	addl	%ebx, %esi
	movq	%rcx, (%rax)
	movq	%rdx, 136(%rsp)
	sarl	%esi
	cmpl	$1, %ebx
	jle	.L2108
	movq	96(%rsp), %rdi
	movl	(%rax), %ecx
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L2115:
	imull	(%rdi,%rdx,4), %ecx
	addq	$1, %rdx
	movl	%ecx, (%rax)
	cmpl	%edx, %esi
	jg	.L2115
.L2108:
	cmpl	%esi, %ebx
	jle	.L2116
	subl	$1, %ebx
	movslq	%esi, %r8
	movq	96(%rsp), %rdi
	movl	4(%rax), %ecx
	subl	%esi, %ebx
	addq	%r8, %rbx
	leaq	(%rdi,%r8,4), %rdx
	leaq	4(%rdi,%rbx,4), %rsi
	.p2align 4,,10
	.p2align 3
.L2117:
	imull	(%rdx), %ecx
	addq	$4, %rdx
	movl	%ecx, 4(%rax)
	cmpq	%rdx, %rsi
	jne	.L2117
.L2116:
	leaq	168(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%r15, %rdi
	movl	$0, 168(%rsp)
	movq	%rax, 184(%rsp)
	movq	%rax, 192(%rsp)
	leaq	264(%rsp), %rax
	movq	%rax, 280(%rsp)
	movq	%rax, 288(%rsp)
	leaq	384(%rsp), %rax
	movq	%rax, 72(%rsp)
	movq	%rax, 400(%rsp)
	movq	%rax, 408(%rsp)
	leaq	128(%rsp), %rax
	movq	%rax, %rsi
	movq	%rax, 64(%rsp)
	movq	$0, 176(%rsp)
	movq	$0, 200(%rsp)
	movl	$0, 264(%rsp)
	movq	$0, 272(%rsp)
	movq	$0, 296(%rsp)
	movl	$0, 384(%rsp)
	movq	$0, 392(%rsp)
	movq	$0, 416(%rsp)
	movaps	%xmm0, 320(%rsp)
	movaps	%xmm0, 336(%rsp)
	movaps	%xmm0, 352(%rsp)
.LEHB166:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	(%rsp), %rsi
	leaq	344(%rsp), %rdi
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE166:
	movq	320(%rsp), %rax
	movq	272(%rsp), %rbx
	movl	(%rax), %eax
	movl	%eax, 368(%rsp)
	testq	%rbx, %rbx
	je	.L2125
.L2118:
	movq	24(%rbx), %rsi
	movq	%r12, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2118
.L2125:
	leaq	208(%rsp), %rax
	movq	$0, 88(%rsp)
	movq	%rax, 48(%rsp)
	leaq	216(%rsp), %rax
	movq	%rax, 32(%rsp)
	movq	%rax, 232(%rsp)
	movq	%rax, 240(%rsp)
	movq	40(%rsp), %rax
	movl	$0, 216(%rsp)
	movq	$0, 224(%rsp)
	movq	72(%rax), %rsi
	movq	$0, 248(%rsp)
	testq	%rsi, %rsi
	je	.L2275
	movq	48(%rsp), %rax
	movq	32(%rsp), %rdx
	movq	%r12, %rcx
	movq	%rax, %rdi
	movq	%rax, 256(%rsp)
.LEHB167:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE167:
	movq	%rax, %rsi
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2126:
	movq	%rdx, %rax
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2126
	movq	%rax, 232(%rsp)
	movq	%rsi, %rdx
	.p2align 4,,10
	.p2align 3
.L2127:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2127
	movq	%rcx, 240(%rsp)
	movq	40(%rsp), %rcx
	movq	%rsi, 224(%rsp)
	movq	96(%rcx), %rdx
	movq	320(%rsp), %rcx
	movl	(%rcx), %ebp
	movl	4(%rcx), %ecx
	movq	%rdx, 248(%rsp)
	movl	%ebp, %ebx
	negl	%ebx
	cmpl	%ecx, %ebx
	jge	.L2128
.L2162:
	leaq	376(%rsp), %r14
	jmp	.L2134
	.p2align 4,,10
	.p2align 3
.L2277:
	movl	%ecx, %eax
	subl	%ebx, %eax
.L2130:
	cmpl	%ebp, %eax
	jg	.L2132
	cmpl	%eax, %ecx
	cmovle	%ecx, %eax
	movl	%eax, %ebp
.L2132:
	movslq	%ebp, %rdi
	movl	$4, %esi
	movq	%rdi, 16(%rsp)
	call	calloc@PLT
	movq	16(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, (%rsp)
	call	calloc@PLT
	movq	(%rsp), %xmm0
	movq	%r12, %rsi
	movq	%r14, %rdi
	movq	%rax, %xmm1
	movl	%ebx, 256(%rsp)
	punpcklqdq	%xmm1, %xmm0
	movl	%ebx, 264(%rsp)
	movl	%ebp, 268(%rsp)
	movaps	%xmm0, 272(%rsp)
.LEHB168:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	movq	320(%rsp), %rax
	addl	$1, %ebx
	movl	4(%rax), %ecx
	cmpl	%ebx, %ecx
	jle	.L2276
	movl	(%rax), %ebp
.L2134:
	leal	(%rbx,%rbp), %eax
	testl	%ebx, %ebx
	js	.L2130
	jne	.L2277
	cmpl	%ebp, %ecx
	movl	%ebp, %eax
	cmovle	%ecx, %eax
	jmp	.L2130
	.p2align 4,,10
	.p2align 3
.L2275:
	movq	320(%rsp), %rax
	movl	(%rax), %ebp
	movl	4(%rax), %ecx
	movl	%ebp, %ebx
	negl	%ebx
	cmpl	%ebx, %ecx
	jg	.L2162
	movq	32(%rsp), %rax
	movq	%rax, 88(%rsp)
	.p2align 4,,10
	.p2align 3
.L2136:
	movq	%r15, %rdi
	call	_ZN19quantumSparseMatrix11pruneMatrixEv
.LEHE168:
	movq	320(%rsp), %rax
	pxor	%xmm0, %xmm0
	leaq	64(%r13), %rdx
	movq	%rax, 0(%r13)
	movq	328(%rsp), %rax
	movaps	%xmm0, 320(%rsp)
	movq	%rax, 8(%r13)
	movq	336(%rsp), %rax
	movq	%rax, 16(%r13)
	movq	344(%rsp), %rax
	movaps	%xmm0, 336(%rsp)
	movq	%rax, 24(%r13)
	movq	352(%rsp), %rax
	movq	%rax, 32(%r13)
	movq	360(%rsp), %rax
	movaps	%xmm0, 352(%rsp)
	movq	%rax, 40(%r13)
	movl	368(%rsp), %eax
	movl	%eax, 48(%r13)
	movq	392(%rsp), %rax
	testq	%rax, %rax
	je	.L2138
	movl	384(%rsp), %ecx
	movq	%rax, 72(%r13)
	movl	%ecx, 64(%r13)
	movq	400(%rsp), %rcx
	movq	%rcx, 80(%r13)
	movq	408(%rsp), %rcx
	movq	%rcx, 88(%r13)
	movq	%rdx, 8(%rax)
	movq	416(%rsp), %rax
	movq	224(%rsp), %rbx
	movq	$0, 392(%rsp)
	movq	%rax, 96(%r13)
	movq	72(%rsp), %rax
	movq	$0, 416(%rsp)
	movq	%rax, 400(%rsp)
	movq	%rax, 408(%rsp)
	testq	%rbx, %rbx
	je	.L2140
	.p2align 4,,10
	.p2align 3
.L2142:
	movq	24(%rbx), %rsi
	movq	48(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2142
	movq	392(%rsp), %rbx
	testq	%rbx, %rbx
	je	.L2140
	leaq	376(%rsp), %r14
.L2143:
	movq	24(%rbx), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2143
.L2140:
	movq	344(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2145
	call	_ZdlPv@PLT
.L2145:
	movq	320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2146
	call	_ZdlPv@PLT
.L2146:
	movq	176(%rsp), %rbp
	leaq	160(%rsp), %rbx
	testq	%rbp, %rbp
	je	.L2150
.L2147:
	movq	24(%rbp), %rsi
	movq	%rbx, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
	movq	16(%rbp), %rbp
	call	_ZdlPv@PLT
	testq	%rbp, %rbp
	jne	.L2147
.L2150:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2149
	call	_ZdlPv@PLT
.L2149:
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2075
.L2265:
	call	_ZdlPv@PLT
.L2075:
	movq	440(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L2278
	addq	$456, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r13, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2276:
	.cfi_restore_state
	movq	232(%rsp), %rax
.L2128:
	movq	%r15, %xmm6
	movq	%rax, 88(%rsp)
	leaq	88(%rsp), %rbx
	movq	40(%rsp), %xmm4
	movq	64(%rsp), %xmm5
	movhps	56(%rsp), %xmm4
	punpcklqdq	%xmm6, %xmm5
	movaps	%xmm4, 16(%rsp)
	movaps	%xmm5, (%rsp)
	cmpq	32(%rsp), %rax
	je	.L2136
	.p2align 4,,10
	.p2align 3
.L2135:
	movq	48(%rax), %rdx
	movdqa	16(%rsp), %xmm2
	xorl	%ecx, %ecx
	movq	%r12, %rsi
	movq	56(%rax), %rax
	movdqa	(%rsp), %xmm3
	leaq	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE._omp_fn.0(%rip), %rdi
	movq	%rbx, 288(%rsp)
	movq	%rdx, 296(%rsp)
	movl	$16, %edx
	movq	%rax, 304(%rsp)
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm3, 272(%rsp)
	call	GOMP_parallel@PLT
	movq	88(%rsp), %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, 88(%rsp)
	cmpq	32(%rsp), %rax
	jne	.L2135
	jmp	.L2136
	.p2align 4,,10
	.p2align 3
.L2138:
	movq	224(%rsp), %rbx
	movl	$0, 64(%r13)
	movq	$0, 72(%r13)
	movq	%rdx, 80(%r13)
	movq	%rdx, 88(%r13)
	movq	$0, 96(%r13)
	testq	%rbx, %rbx
	jne	.L2142
	jmp	.L2140
	.p2align 4,,10
	.p2align 3
.L2270:
	movq	%rbx, %rax
	sarq	$2, %rax
	testq	%rbx, %rbx
	je	.L2096
	xorl	%ebp, %ebp
	leaq	320(%rsp), %r15
	.p2align 4,,10
	.p2align 3
.L2097:
	movq	56(%rsp), %rdi
	subl	$1, %eax
	movq	%r15, %rsi
	subl	%ebp, %eax
	addq	$1, %rbp
	movl	%eax, 320(%rsp)
.LEHB169:
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	40(%rsp), %rax
	movq	32(%rax), %r14
	movq	24(%rax), %r12
	movq	%r14, %rbx
	subq	%r12, %rbx
	movq	%rbx, %rax
	sarq	$2, %rax
	cmpq	%rbp, %rax
	ja	.L2097
	movq	56(%rsp), %rax
	movq	(%rax), %rsi
	movq	8(%rax), %rdx
	jmp	.L2096
	.p2align 4,,10
	.p2align 3
.L2271:
	movq	%r15, %rbp
	xorl	%ecx, %ecx
	jmp	.L2099
	.p2align 4,,10
	.p2align 3
.L2273:
	movq	%rbx, %r15
	xorl	%ecx, %ecx
	jmp	.L2103
	.p2align 4,,10
	.p2align 3
.L2269:
	movq	(%rsi), %rax
	movq	%rsi, %r15
	leaq	432(%rsp), %rsi
	leaq	168(%rsp), %r14
	leaq	160(%rsp), %rbx
	movl	4(%rax), %edx
	movl	%edx, 432(%rsp)
	movl	(%rax), %eax
	movl	$2, %edx
	movl	%eax, 436(%rsp)
	leaq	96(%rsp), %rax
	movq	%rax, %rdi
	movq	%rax, (%rsp)
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE169:
	movq	72(%r15), %rsi
	movl	$0, 168(%rsp)
	movq	$0, 176(%rsp)
	movq	%r14, 184(%rsp)
	movq	%r14, 192(%rsp)
	movq	$0, 200(%rsp)
	testq	%rsi, %rsi
	je	.L2077
	leaq	320(%rsp), %r15
	movq	%r14, %rdx
	movq	%rbx, %rdi
	movq	%rbx, 320(%rsp)
	movq	%r15, %rcx
.LEHB170:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE170:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2078:
	movq	%rdx, %r12
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2078
	movq	%r12, 184(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2079:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2079
	movq	%rcx, 192(%rsp)
	movq	40(%rsp), %rcx
	movq	%rax, 176(%rsp)
	leaq	216(%rsp), %rax
	movq	96(%rcx), %rdx
	movq	%rax, 232(%rsp)
	movl	$0, 216(%rsp)
	movq	%rdx, 200(%rsp)
	movq	$0, 224(%rsp)
	movq	%rax, 240(%rsp)
	movq	$0, 248(%rsp)
	cmpq	%r14, %r12
	je	.L2164
	leaq	208(%rsp), %rax
	movq	%rax, 48(%rsp)
	.p2align 4,,10
	.p2align 3
.L2080:
	movl	40(%r12), %eax
	movq	48(%rsp), %rdi
	movq	%r15, %rsi
	negl	%eax
	movl	%eax, 40(%r12)
	movdqu	40(%r12), %xmm6
	movl	%eax, 320(%rsp)
	movups	%xmm6, 328(%rsp)
	movq	56(%r12), %rax
	movq	%rax, 344(%rsp)
.LEHB171:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	movq	%r12, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %r12
	cmpq	%r14, %rax
	jne	.L2080
	movq	224(%rsp), %rsi
	leaq	264(%rsp), %rdx
	movl	$0, 264(%rsp)
	leaq	256(%rsp), %r12
	movq	$0, 272(%rsp)
	movq	%rdx, 16(%rsp)
	movq	%rdx, 280(%rsp)
	movq	%rdx, 288(%rsp)
	movq	$0, 296(%rsp)
	testq	%rsi, %rsi
	je	.L2166
	movq	%r15, %rcx
	movq	%r12, %rdi
	movq	%r12, 320(%rsp)
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE171:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2082:
	movq	%rdx, %rbp
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2082
	movq	%rbp, 280(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2083:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2083
	movq	248(%rsp), %rdx
	movq	%rcx, 288(%rsp)
	movq	%rax, 272(%rsp)
	movq	%rdx, 296(%rsp)
.L2081:
	leaq	384(%rsp), %rax
	pxor	%xmm0, %xmm0
	movl	$0, 384(%rsp)
	leaq	376(%rsp), %r14
	movq	%rax, 72(%rsp)
	movq	%rax, 400(%rsp)
	movq	%rax, 408(%rsp)
	leaq	128(%rsp), %rax
	movq	$0, 392(%rsp)
	movq	$0, 416(%rsp)
	movq	%rax, 64(%rsp)
	movaps	%xmm0, 320(%rsp)
	movaps	%xmm0, 336(%rsp)
	movaps	%xmm0, 352(%rsp)
	cmpq	16(%rsp), %rbp
	je	.L2086
	.p2align 4,,10
	.p2align 3
.L2084:
	movl	32(%rbp), %eax
	movdqu	40(%rbp), %xmm7
	movq	%r14, %rdi
	movq	64(%rsp), %rsi
	movl	%eax, 128(%rsp)
	movups	%xmm7, 136(%rsp)
	movq	56(%rbp), %rax
	movq	%rax, 152(%rsp)
.LEHB172:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	movq	%rbp, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %rbp
	cmpq	16(%rsp), %rax
	jne	.L2084
.L2086:
	leaq	320(%rsp), %r15
	movq	(%rsp), %rsi
	leaq	376(%rsp), %r14
	movq	%r15, %rdi
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	(%rsp), %rsi
	leaq	344(%rsp), %rdi
	leaq	376(%rsp), %r14
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE172:
	movq	320(%rsp), %rax
	movq	272(%rsp), %rsi
	movq	%r12, %rdi
	movl	(%rax), %eax
	movl	%eax, 368(%rsp)
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r15, %rdi
.LEHB173:
	call	_ZN19quantumSparseMatrix11pruneMatrixEv
.LEHE173:
	movq	320(%rsp), %rax
	pxor	%xmm0, %xmm0
	leaq	64(%r13), %rdx
	movq	%rax, 0(%r13)
	movq	328(%rsp), %rax
	movaps	%xmm0, 320(%rsp)
	movq	%rax, 8(%r13)
	movq	336(%rsp), %rax
	movq	%rax, 16(%r13)
	movq	344(%rsp), %rax
	movaps	%xmm0, 336(%rsp)
	movq	%rax, 24(%r13)
	movq	352(%rsp), %rax
	movq	%rax, 32(%r13)
	movq	360(%rsp), %rax
	movaps	%xmm0, 352(%rsp)
	movq	%rax, 40(%r13)
	movl	368(%rsp), %eax
	movl	%eax, 48(%r13)
	movq	392(%rsp), %rax
	testq	%rax, %rax
	je	.L2092
	movl	384(%rsp), %ecx
	movq	%rax, 72(%r13)
	movl	%ecx, 64(%r13)
	movq	400(%rsp), %rcx
	movq	%rcx, 80(%r13)
	movq	408(%rsp), %rcx
	movq	%rcx, 88(%r13)
	movq	%rdx, 8(%rax)
	movq	416(%rsp), %rax
	movq	$0, 392(%rsp)
	movq	%rax, 96(%r13)
	movq	72(%rsp), %rax
	movq	$0, 416(%rsp)
	movq	%rax, 400(%rsp)
	movq	%rax, 408(%rsp)
.L2093:
	movq	%r15, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	224(%rsp), %rsi
	movq	48(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	176(%rsp), %rsi
	movq	%rbx, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L2265
	jmp	.L2075
.L2166:
	movq	%rdx, %rbp
	jmp	.L2081
.L2092:
	movl	$0, 64(%r13)
	movq	$0, 72(%r13)
	movq	%rdx, 80(%r13)
	movq	%rdx, 88(%r13)
	movq	$0, 96(%r13)
	jmp	.L2093
	.p2align 4,,10
	.p2align 3
.L2077:
	leaq	216(%rsp), %rax
	movl	$0, 216(%rsp)
	movq	$0, 224(%rsp)
	movq	%rax, 232(%rsp)
	movq	%rax, 240(%rsp)
	movq	$0, 248(%rsp)
.L2164:
	leaq	264(%rsp), %rax
	movl	$0, 264(%rsp)
	leaq	256(%rsp), %r12
	movq	%rax, 280(%rsp)
	movq	%rax, %rbp
	movq	%rax, 288(%rsp)
	movq	%rax, 16(%rsp)
	leaq	208(%rsp), %rax
	movq	$0, 272(%rsp)
	movq	$0, 296(%rsp)
	movq	%rax, 48(%rsp)
	jmp	.L2081
.L2278:
	call	__stack_chk_fail@PLT
.L2272:
.LEHB174:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE174:
.L2274:
.LEHB175:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE175:
.L2174:
	endbr64
	movq	%rax, %rbp
	jmp	.L2088
.L2168:
	endbr64
	movq	%rax, %rbp
	jmp	.L2091
.L2169:
	endbr64
	movq	%rax, %rbp
	jmp	.L2151
.L2167:
	endbr64
	movq	%rax, %rbp
	jmp	.L2152
.L2171:
	endbr64
	movq	%rax, %rbp
	jmp	.L2154
.L2176:
	endbr64
	movq	%rax, %rbx
	jmp	.L2121
.L2175:
	endbr64
	movq	%rax, %rbx
	jmp	.L2268
.L2172:
	endbr64
	movq	%rax, %rbx
	jmp	.L2159
.L2170:
	endbr64
	movq	%rax, %rbp
	jmp	.L2156
.L2173:
	endbr64
	movq	%rax, %rbx
	jmp	.L2158
	.section	.gcc_except_table
.LLSDA8729:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8729-.LLSDACSB8729
.LLSDACSB8729:
	.uleb128 .LEHB162-.LFB8729
	.uleb128 .LEHE162-.LEHB162
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB163-.LFB8729
	.uleb128 .LEHE163-.LEHB163
	.uleb128 .L2170-.LFB8729
	.uleb128 0
	.uleb128 .LEHB164-.LFB8729
	.uleb128 .LEHE164-.LEHB164
	.uleb128 .L2171-.LFB8729
	.uleb128 0
	.uleb128 .LEHB165-.LFB8729
	.uleb128 .LEHE165-.LEHB165
	.uleb128 .L2175-.LFB8729
	.uleb128 0
	.uleb128 .LEHB166-.LFB8729
	.uleb128 .LEHE166-.LEHB166
	.uleb128 .L2176-.LFB8729
	.uleb128 0
	.uleb128 .LEHB167-.LFB8729
	.uleb128 .LEHE167-.LEHB167
	.uleb128 .L2172-.LFB8729
	.uleb128 0
	.uleb128 .LEHB168-.LFB8729
	.uleb128 .LEHE168-.LEHB168
	.uleb128 .L2173-.LFB8729
	.uleb128 0
	.uleb128 .LEHB169-.LFB8729
	.uleb128 .LEHE169-.LEHB169
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB170-.LFB8729
	.uleb128 .LEHE170-.LEHB170
	.uleb128 .L2167-.LFB8729
	.uleb128 0
	.uleb128 .LEHB171-.LFB8729
	.uleb128 .LEHE171-.LEHB171
	.uleb128 .L2168-.LFB8729
	.uleb128 0
	.uleb128 .LEHB172-.LFB8729
	.uleb128 .LEHE172-.LEHB172
	.uleb128 .L2174-.LFB8729
	.uleb128 0
	.uleb128 .LEHB173-.LFB8729
	.uleb128 .LEHE173-.LEHB173
	.uleb128 .L2169-.LFB8729
	.uleb128 0
	.uleb128 .LEHB174-.LFB8729
	.uleb128 .LEHE174-.LEHB174
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB175-.LFB8729
	.uleb128 .LEHE175-.LEHB175
	.uleb128 .L2170-.LFB8729
	.uleb128 0
.LLSDACSE8729:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8729
	.type	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE.cold, @function
_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE.cold:
.LFSB8729:
.L2088:
	.cfi_def_cfa_offset 512
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	392(%rsp), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	344(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2089
	call	_ZdlPv@PLT
.L2089:
	movq	320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2090
	call	_ZdlPv@PLT
.L2090:
	movq	272(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2091:
	movq	224(%rsp), %rsi
	movq	48(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	176(%rsp), %rsi
	movq	%rbx, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2152:
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2157
.L2266:
	call	_ZdlPv@PLT
.L2157:
	movq	%rbp, %rdi
.LEHB176:
	call	_Unwind_Resume@PLT
.L2151:
	movq	%r15, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L2091
.L2154:
	movq	256(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2156
	call	_ZdlPv@PLT
.L2156:
	movq	320(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L2266
	jmp	.L2157
.L2121:
	movq	392(%rsp), %rsi
	leaq	376(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	344(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2122
	call	_ZdlPv@PLT
.L2122:
	movq	320(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L2279
.L2123:
	movq	272(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2124:
	movq	176(%rsp), %rsi
	leaq	160(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2268:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2112
	call	_ZdlPv@PLT
.L2112:
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2161
	call	_ZdlPv@PLT
.L2161:
	movq	%rbx, %rdi
	call	_Unwind_Resume@PLT
.LEHE176:
.L2279:
	call	_ZdlPv@PLT
	jmp	.L2123
.L2158:
	movq	224(%rsp), %rsi
	movq	48(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2159:
	movq	%r15, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L2124
	.cfi_endproc
.LFE8729:
	.section	.gcc_except_table
.LLSDAC8729:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8729-.LLSDACSBC8729
.LLSDACSBC8729:
	.uleb128 .LEHB176-.LCOLDB46
	.uleb128 .LEHE176-.LEHB176
	.uleb128 0
	.uleb128 0
.LLSDACSEC8729:
	.section	.text.unlikely
	.text
	.size	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE, .-_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
	.section	.text.unlikely
	.size	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE.cold, .-_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE.cold
.LCOLDE46:
	.text
.LHOTE46:
	.section	.rodata.str1.8
	.align 8
.LC47:
	.string	"input matrices are of different dimensions, not compatible"
	.section	.text.unlikely
.LCOLDB48:
	.text
.LHOTB48:
	.p2align 4
	.globl	_Z3add19quantumSparseMatrixS_
	.type	_Z3add19quantumSparseMatrixS_, @function
_Z3add19quantumSparseMatrixS_:
.LFB8721:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8721
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$232, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rsi, -264(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	movl	48(%rsi), %eax
	cmpl	48(%rdx), %eax
	jne	.L2432
	movq	%rdi, %r13
	movl	$104, %edi
	movl	%eax, %r14d
	movq	%rdx, %rbx
.LEHB177:
	call	_Znwm@PLT
.LEHE177:
	pxor	%xmm0, %xmm0
	leaq	-104(%rbp), %r15
	movl	%r14d, -160(%rbp)
	movq	%rax, %r12
	leaq	24(%rax), %rax
	leaq	-112(%rbp), %r14
	movl	$0, -104(%rbp)
	movq	%rax, -232(%rbp)
	leaq	64(%r12), %rax
	movq	%r14, %rsi
	movq	%rax, 80(%r12)
	movq	%rax, 88(%r12)
	movl	$0, 64(%r12)
	movq	$0, 72(%r12)
	movq	$0, 96(%r12)
	movq	%rax, -240(%rbp)
	leaq	56(%r12), %rax
	movups	%xmm0, (%r12)
	movq	%rax, %rdi
	movups	%xmm0, 16(%r12)
	movups	%xmm0, 32(%r12)
	movq	$0, -96(%rbp)
	movq	%r15, -88(%rbp)
	movq	%r15, -80(%rbp)
	movq	$0, -72(%rbp)
	movq	%rax, -272(%rbp)
.LEHB178:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_
.LEHE178:
	movl	-160(%rbp), %edx
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
	movl	%edx, 48(%r12)
	cmpq	%rax, %rsi
	je	.L2282
	movl	%edx, (%rsi)
	leaq	-160(%rbp), %rcx
	addq	$4, %rsi
	movq	%rsi, 8(%r12)
	movq	%rcx, -256(%rbp)
	cmpq	%rax, %rsi
	je	.L2284
.L2450:
	movl	-160(%rbp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	40(%r12), %rax
	movq	%rsi, 8(%r12)
	movq	32(%r12), %rsi
	cmpq	%rax, %rsi
	je	.L2286
.L2451:
	movl	-160(%rbp), %edx
	addq	$4, %rsi
	movl	%edx, -4(%rsi)
	movq	%rsi, 32(%r12)
.L2287:
	cmpq	%rax, %rsi
	je	.L2288
	movl	-160(%rbp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 32(%r12)
.L2289:
	movq	-96(%rbp), %rax
	testq	%rax, %rax
	je	.L2293
	movq	%rax, -232(%rbp)
.L2290:
	movq	-232(%rbp), %rax
	movq	%r14, %rdi
	movq	24(%rax), %rsi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	-232(%rbp), %rax
	movq	%rax, %rdi
	movq	16(%rax), %rax
	movq	%rax, -232(%rbp)
	call	_ZdlPv@PLT
	cmpq	$0, -232(%rbp)
	jne	.L2290
.L2293:
	leaq	-152(%rbp), %rax
	movq	$0, -120(%rbp)
	movq	%rax, -248(%rbp)
	movq	%rax, -136(%rbp)
	movq	%rax, -128(%rbp)
	movq	-264(%rbp), %rax
	movl	$0, -152(%rbp)
	movq	$0, -144(%rbp)
	movq	72(%rax), %rsi
	testq	%rsi, %rsi
	je	.L2440
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%r14, %rcx
	movq	%rax, %rdi
	movq	%rax, -112(%rbp)
.LEHB179:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE179:
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2297:
	movq	%rax, %rdi
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2297
	movq	%rdi, -136(%rbp)
	movq	%rcx, %rax
	.p2align 4,,10
	.p2align 3
.L2298:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2298
	movq	-264(%rbp), %rax
	movq	72(%rbx), %rsi
	movq	%rdx, -128(%rbp)
	movq	%rdi, -232(%rbp)
	movq	96(%rax), %rax
	movq	%rcx, -144(%rbp)
	movl	$0, -104(%rbp)
	movq	%rax, -120(%rbp)
	movq	$0, -96(%rbp)
	movq	%r15, -88(%rbp)
	movq	%r15, -80(%rbp)
	movq	$0, -72(%rbp)
	testq	%rsi, %rsi
	jne	.L2361
.L2299:
	movq	-248(%rbp), %rcx
	cmpq	%rcx, -232(%rbp)
	je	.L2302
	.p2align 4,,10
	.p2align 3
.L2336:
	movq	-232(%rbp), %rbx
	movl	32(%rbx), %eax
	testq	%rsi, %rsi
	je	.L2303
	movq	%r15, %rdx
	movq	%rbx, %rdi
	jmp	.L2304
	.p2align 4,,10
	.p2align 3
.L2441:
	movq	%rsi, %rdx
	movq	16(%rsi), %rsi
	testq	%rsi, %rsi
	je	.L2305
.L2304:
	cmpl	%eax, 32(%rsi)
	jge	.L2441
	movq	24(%rsi), %rsi
	testq	%rsi, %rsi
	jne	.L2304
.L2305:
	movq	%rdi, -232(%rbp)
	movq	%rdi, %rcx
	cmpq	%r15, %rdx
	je	.L2303
	cmpl	%eax, 32(%rdx)
	jle	.L2442
.L2303:
	movq	-232(%rbp), %rbx
	movq	72(%r12), %rdx
	movq	48(%rbx), %rcx
	movq	56(%rbx), %rsi
	testq	%rdx, %rdx
	je	.L2312
	movq	-240(%rbp), %r8
	movq	%rbx, %rdi
	jmp	.L2359
	.p2align 4,,10
	.p2align 3
.L2443:
	movq	%rdx, %r8
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	je	.L2309
.L2359:
	cmpl	%eax, 32(%rdx)
	jge	.L2443
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2359
.L2309:
	movq	%rdi, -232(%rbp)
	cmpq	%r8, -240(%rbp)
	je	.L2312
	cmpl	%eax, 32(%r8)
	jle	.L2313
.L2312:
	movq	-232(%rbp), %rbx
	movq	%rsi, %xmm7
	movq	%rcx, %xmm0
	movq	-272(%rbp), %rdi
	punpcklqdq	%xmm7, %xmm0
	leaq	-192(%rbp), %rsi
	movq	40(%rbx), %rdx
	movl	%eax, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	movq	%rdx, -184(%rbp)
.LEHB180:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
.LEHE180:
	jmp	.L2314
.L2440:
	movq	72(%rbx), %rsi
	movl	$0, -104(%rbp)
	movq	$0, -96(%rbp)
	movq	%r15, -88(%rbp)
	movq	%r15, -80(%rbp)
	movq	$0, -72(%rbp)
	testq	%rsi, %rsi
	je	.L2302
.L2361:
	leaq	-192(%rbp), %rcx
	movq	%r15, %rdx
	movq	%r14, %rdi
	movq	%r14, -192(%rbp)
.LEHB181:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE181:
	movq	%rax, %rsi
	.p2align 4,,10
	.p2align 3
.L2300:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2300
	movq	%rdx, -88(%rbp)
	movq	%rsi, %rax
	.p2align 4,,10
	.p2align 3
.L2301:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2301
	movq	96(%rbx), %rax
	movq	%rdx, -80(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%rax, -72(%rbp)
	movq	-136(%rbp), %rax
	movq	%rax, -232(%rbp)
	jmp	.L2299
	.p2align 4,,10
	.p2align 3
.L2442:
	pushq	56(%rdx)
	movq	%rdi, %rbx
	leaq	-224(%rbp), %rdi
	pushq	48(%rdx)
	pushq	40(%rdx)
	pushq	56(%rcx)
	pushq	48(%rcx)
	pushq	40(%rcx)
.LEHB182:
	.cfi_escape 0x2e,0x30
	call	_Z11addElements8diagonalS_
	movq	72(%r12), %rax
	movl	32(%rbx), %edx
	addq	$48, %rsp
	movq	-216(%rbp), %rcx
	movq	-208(%rbp), %rsi
	testq	%rax, %rax
	je	.L2324
	movq	-240(%rbp), %rdi
	movq	-232(%rbp), %rbx
	jmp	.L2325
	.p2align 4,,10
	.p2align 3
.L2444:
	movq	%rax, %rdi
	movq	16(%rax), %rax
	testq	%rax, %rax
	je	.L2326
.L2325:
	cmpl	32(%rax), %edx
	jle	.L2444
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2325
.L2326:
	movq	%rbx, -232(%rbp)
	cmpq	-240(%rbp), %rdi
	je	.L2324
	cmpl	32(%rdi), %edx
	jge	.L2329
.L2324:
	movq	%rsi, %xmm6
	movq	-224(%rbp), %rax
	movq	%rcx, %xmm0
	movq	-272(%rbp), %rdi
	punpcklqdq	%xmm6, %xmm0
	leaq	-192(%rbp), %rsi
	movl	%edx, -192(%rbp)
	movq	%rax, -184(%rbp)
	movaps	%xmm0, -176(%rbp)
	.cfi_escape 0x2e,0
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	.p2align 4,,10
	.p2align 3
.L2314:
	movq	-232(%rbp), %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	-248(%rbp), %rcx
	movq	%rax, -232(%rbp)
	cmpq	%rcx, %rax
	je	.L2302
	movq	-96(%rbp), %rsi
	jmp	.L2336
	.p2align 4,,10
	.p2align 3
.L2329:
	movl	44(%rdi), %r8d
	testl	%r8d, %r8d
	jle	.L2314
	movq	56(%rdi), %rax
	movq	48(%rdi), %rdx
	leal	-1(%r8), %edi
	leaq	15(%rax), %r9
	leaq	15(%rdx), %r10
	movq	%r9, %r11
	movq	%r9, %rbx
	subq	%rsi, %r11
	cmpq	$30, %r11
	seta	%r11b
	subq	%rdx, %rbx
	cmpq	$30, %rbx
	seta	%bl
	andl	%r11d, %ebx
	cmpl	$2, %edi
	seta	%r11b
	subq	%rcx, %r9
	andl	%ebx, %r11d
	cmpq	$30, %r9
	movq	%r10, %r9
	seta	%bl
	subq	%rsi, %r9
	andl	%ebx, %r11d
	cmpq	$30, %r9
	seta	%r9b
	testb	%r9b, %r11b
	je	.L2330
	subq	%rcx, %r10
	cmpq	$30, %r10
	jbe	.L2330
	movl	%r8d, %r9d
	movq	-232(%rbp), %rbx
	xorl	%edi, %edi
	shrl	$2, %r9d
	salq	$4, %r9
	.p2align 4,,10
	.p2align 3
.L2331:
	movups	(%rsi,%rdi), %xmm0
	movups	(%rax,%rdi), %xmm2
	movups	(%rcx,%rdi), %xmm1
	movups	(%rdx,%rdi), %xmm3
	addps	%xmm2, %xmm0
	addps	%xmm3, %xmm1
	movups	%xmm1, (%rdx,%rdi)
	movups	%xmm0, (%rax,%rdi)
	addq	$16, %rdi
	cmpq	%r9, %rdi
	jne	.L2331
	movl	%r8d, %r9d
	movq	%rbx, -232(%rbp)
	andl	$-4, %r9d
	testb	$3, %r8b
	je	.L2314
	movl	%r9d, %r10d
	leaq	0(,%r10,4), %rdi
	movss	(%rsi,%r10,4), %xmm0
	leaq	(%rax,%rdi), %r11
	leaq	(%rdx,%rdi), %rbx
	movss	(%rbx), %xmm1
	addss	(%r11), %xmm0
	addss	(%rcx,%r10,4), %xmm1
	leal	1(%r9), %r10d
	movss	%xmm1, (%rbx)
	movss	%xmm0, (%r11)
	cmpl	%r10d, %r8d
	jle	.L2314
	leaq	4(%rdi), %r10
	movss	4(%rsi,%rdi), %xmm0
	addl	$2, %r9d
	leaq	(%rax,%r10), %r11
	addq	%rdx, %r10
	movss	(%r10), %xmm1
	addss	(%r11), %xmm0
	addss	4(%rcx,%rdi), %xmm1
	movss	%xmm1, (%r10)
	movss	%xmm0, (%r11)
	cmpl	%r8d, %r9d
	jge	.L2314
	leaq	8(%rdi), %r8
	movss	8(%rsi,%rdi), %xmm0
	addq	%r8, %rax
	addq	%r8, %rdx
	movss	(%rdx), %xmm1
	addss	(%rax), %xmm0
	addss	8(%rcx,%rdi), %xmm1
	movss	%xmm1, (%rdx)
	movss	%xmm0, (%rax)
	jmp	.L2314
	.p2align 4,,10
	.p2align 3
.L2302:
	movq	8(%r12), %rax
	movq	(%r12), %rsi
	pxor	%xmm0, %xmm0
	movq	$0, 16(%r13)
	movups	%xmm0, 0(%r13)
	movq	%rax, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2445
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2446
	movq	%rbx, %rdi
	call	_Znwm@PLT
.LEHE182:
	movq	%rax, %rcx
	movq	8(%r12), %rax
	movq	(%r12), %rsi
	movq	%rax, %rdi
	subq	%rsi, %rdi
	movq	%rdi, %r15
.L2338:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 16(%r13)
	movups	%xmm0, 0(%r13)
	cmpq	%rsi, %rax
	je	.L2340
	movq	%rcx, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2340:
	movq	32(%r12), %rax
	movq	24(%r12), %rsi
	addq	%r15, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%r13)
	movq	%rax, %rbx
	movq	$0, 40(%r13)
	subq	%rsi, %rbx
	movups	%xmm0, 24(%r13)
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2447
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2448
	movq	%rbx, %rdi
.LEHB183:
	call	_Znwm@PLT
.LEHE183:
	movq	%rax, %rcx
	movq	32(%r12), %rax
	movq	24(%r12), %rsi
	movq	%rax, %rdi
	subq	%rsi, %rdi
	movq	%rdi, %r15
.L2342:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 40(%r13)
	movups	%xmm0, 24(%r13)
	cmpq	%rsi, %rax
	je	.L2344
	movq	%rcx, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2344:
	movl	48(%r12), %eax
	movq	72(%r12), %rsi
	leaq	64(%r13), %rdx
	addq	%r15, %rcx
	movq	%rcx, 32(%r13)
	movl	%eax, 48(%r13)
	movl	$0, 64(%r13)
	movq	$0, 72(%r13)
	movq	%rdx, 80(%r13)
	movq	%rdx, 88(%r13)
	movq	$0, 96(%r13)
	testq	%rsi, %rsi
	je	.L2345
	leaq	56(%r13), %rdi
	leaq	-192(%rbp), %rcx
	movq	%rdi, -192(%rbp)
.LEHB184:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE184:
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2346:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2346
	movq	%rdx, 80(%r13)
	movq	%rcx, %rax
	.p2align 4,,10
	.p2align 3
.L2347:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2347
	movq	96(%r12), %rax
	movq	%rdx, 88(%r13)
	movq	%rcx, 72(%r13)
	movq	%rax, 96(%r13)
.L2345:
	movq	-96(%rbp), %rbx
	testq	%rbx, %rbx
	je	.L2356
.L2348:
	movq	24(%rbx), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2348
.L2356:
	movq	-144(%rbp), %rbx
	testq	%rbx, %rbx
	je	.L2280
	movq	-256(%rbp), %rax
	movq	%rax, %r14
.L2350:
	movq	24(%rbx), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2350
.L2280:
	movq	-56(%rbp), %rax
	xorq	%fs:40, %rax
	jne	.L2449
	leaq	-40(%rbp), %rsp
	movq	%r13, %rax
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L2313:
	.cfi_restore_state
	movl	44(%r8), %edi
	testl	%edi, %edi
	jle	.L2314
	movq	56(%r8), %rax
	movq	48(%r8), %rdx
	leal	-1(%rdi), %ebx
	leaq	15(%rax), %r8
	leaq	15(%rdx), %r9
	movq	%r8, %r10
	movq	%r8, %r11
	subq	%rsi, %r10
	cmpq	$30, %r10
	seta	%r10b
	subq	%rdx, %r11
	cmpq	$30, %r11
	seta	%r11b
	andl	%r10d, %r11d
	cmpl	$2, %ebx
	seta	%r10b
	subq	%rcx, %r8
	andl	%r11d, %r10d
	cmpq	$30, %r8
	movq	%r9, %r8
	seta	%r11b
	subq	%rsi, %r8
	andl	%r11d, %r10d
	cmpq	$30, %r8
	seta	%r8b
	testb	%r8b, %r10b
	je	.L2316
	subq	%rcx, %r9
	cmpq	$30, %r9
	jbe	.L2316
	movl	%edi, %r9d
	movq	-232(%rbp), %rbx
	xorl	%r8d, %r8d
	shrl	$2, %r9d
	salq	$4, %r9
	.p2align 4,,10
	.p2align 3
.L2317:
	movups	(%rsi,%r8), %xmm0
	movups	(%rax,%r8), %xmm4
	movups	(%rcx,%r8), %xmm1
	movups	(%rdx,%r8), %xmm5
	addps	%xmm4, %xmm0
	addps	%xmm5, %xmm1
	movups	%xmm1, (%rdx,%r8)
	movups	%xmm0, (%rax,%r8)
	addq	$16, %r8
	cmpq	%r8, %r9
	jne	.L2317
	movq	%rbx, -232(%rbp)
	movl	%edi, %ebx
	andl	$-4, %ebx
	testb	$3, %dil
	je	.L2314
	movl	%ebx, %r9d
	leaq	0(,%r9,4), %r8
	movss	(%rsi,%r9,4), %xmm0
	leaq	(%rax,%r8), %r10
	leaq	(%rdx,%r8), %r11
	movss	(%r11), %xmm1
	addss	(%r10), %xmm0
	addss	(%rcx,%r9,4), %xmm1
	leal	1(%rbx), %r9d
	movss	%xmm1, (%r11)
	movss	%xmm0, (%r10)
	cmpl	%edi, %r9d
	jge	.L2314
	leaq	4(%r8), %r9
	movss	4(%rsi,%r8), %xmm0
	addl	$2, %ebx
	leaq	(%rax,%r9), %r10
	addq	%rdx, %r9
	movss	(%r9), %xmm1
	addss	(%r10), %xmm0
	addss	4(%rcx,%r8), %xmm1
	movss	%xmm1, (%r9)
	movss	%xmm0, (%r10)
	cmpl	%ebx, %edi
	jle	.L2314
	leaq	8(%r8), %rdi
	movss	8(%rsi,%r8), %xmm0
	addq	%rdi, %rax
	addq	%rdi, %rdx
	movss	(%rdx), %xmm1
	addss	(%rax), %xmm0
	addss	8(%rcx,%r8), %xmm1
	movss	%xmm1, (%rdx)
	movss	%xmm0, (%rax)
	jmp	.L2314
.L2330:
	movq	-232(%rbp), %rbx
	xorl	%r8d, %r8d
	.p2align 4,,10
	.p2align 3
.L2334:
	movss	(%rsi,%r8,4), %xmm0
	movss	(%rdx,%r8,4), %xmm1
	movq	%r8, %r9
	addss	(%rax,%r8,4), %xmm0
	addss	(%rcx,%r8,4), %xmm1
	movss	%xmm1, (%rdx,%r8,4)
	movss	%xmm0, (%rax,%r8,4)
	addq	$1, %r8
	cmpq	%rdi, %r9
	jne	.L2334
	movq	%rbx, -232(%rbp)
	jmp	.L2314
.L2445:
	movq	%rbx, %r15
	xorl	%ecx, %ecx
	jmp	.L2338
.L2447:
	movq	%rbx, %r15
	xorl	%ecx, %ecx
	jmp	.L2342
.L2288:
	movq	-256(%rbp), %rdx
	leaq	24(%r12), %rdi
.LEHB185:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	jmp	.L2289
.L2282:
	leaq	-160(%rbp), %rax
	movq	%r12, %rdi
	movq	%rax, %rdx
	movq	%rax, -256(%rbp)
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
	cmpq	%rax, %rsi
	jne	.L2450
.L2284:
	movq	-256(%rbp), %rdx
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%r12), %rsi
	movq	40(%r12), %rax
	cmpq	%rax, %rsi
	jne	.L2451
.L2286:
	movq	-256(%rbp), %rdx
	leaq	24(%r12), %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE185:
	movq	32(%r12), %rsi
	movq	40(%r12), %rax
	jmp	.L2287
.L2316:
	movq	-232(%rbp), %r10
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L2321:
	movss	(%rsi,%rdi,4), %xmm0
	movss	(%rdx,%rdi,4), %xmm1
	movq	%rdi, %r8
	addss	(%rax,%rdi,4), %xmm0
	addss	(%rcx,%rdi,4), %xmm1
	movss	%xmm1, (%rdx,%rdi,4)
	movss	%xmm0, (%rax,%rdi,4)
	addq	$1, %rdi
	cmpq	%rbx, %r8
	jne	.L2321
	movq	%r10, -232(%rbp)
	jmp	.L2314
.L2448:
.LEHB186:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE186:
.L2449:
	call	__stack_chk_fail@PLT
.L2446:
.LEHB187:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE187:
.L2368:
	endbr64
	movq	%rax, %rbx
	jmp	.L2351
.L2365:
	endbr64
	movq	%rax, %rbx
	jmp	.L2355
.L2367:
	endbr64
	movq	%rax, %rbx
	jmp	.L2353
.L2364:
	endbr64
	movq	%rax, %rbx
	jmp	.L2358
.L2366:
	endbr64
	movq	%rax, %rbx
	jmp	.L2294
	.section	.gcc_except_table
.LLSDA8721:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8721-.LLSDACSB8721
.LLSDACSB8721:
	.uleb128 .LEHB177-.LFB8721
	.uleb128 .LEHE177-.LEHB177
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB178-.LFB8721
	.uleb128 .LEHE178-.LEHB178
	.uleb128 .L2366-.LFB8721
	.uleb128 0
	.uleb128 .LEHB179-.LFB8721
	.uleb128 .LEHE179-.LEHB179
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB180-.LFB8721
	.uleb128 .LEHE180-.LEHB180
	.uleb128 .L2365-.LFB8721
	.uleb128 0
	.uleb128 .LEHB181-.LFB8721
	.uleb128 .LEHE181-.LEHB181
	.uleb128 .L2364-.LFB8721
	.uleb128 0
	.uleb128 .LEHB182-.LFB8721
	.uleb128 .LEHE182-.LEHB182
	.uleb128 .L2365-.LFB8721
	.uleb128 0
	.uleb128 .LEHB183-.LFB8721
	.uleb128 .LEHE183-.LEHB183
	.uleb128 .L2367-.LFB8721
	.uleb128 0
	.uleb128 .LEHB184-.LFB8721
	.uleb128 .LEHE184-.LEHB184
	.uleb128 .L2368-.LFB8721
	.uleb128 0
	.uleb128 .LEHB185-.LFB8721
	.uleb128 .LEHE185-.LEHB185
	.uleb128 .L2366-.LFB8721
	.uleb128 0
	.uleb128 .LEHB186-.LFB8721
	.uleb128 .LEHE186-.LEHB186
	.uleb128 .L2367-.LFB8721
	.uleb128 0
	.uleb128 .LEHB187-.LFB8721
	.uleb128 .LEHE187-.LEHB187
	.uleb128 .L2365-.LFB8721
	.uleb128 0
.LLSDACSE8721:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8721
	.type	_Z3add19quantumSparseMatrixS_.cold, @function
_Z3add19quantumSparseMatrixS_.cold:
.LFSB8721:
.L2351:
	.cfi_def_cfa 6, 16
	.cfi_offset 3, -56
	.cfi_offset 6, -16
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -24
	movq	24(%r13), %rdi
	testq	%rdi, %rdi
	je	.L2353
	call	_ZdlPv@PLT
.L2353:
	movq	0(%r13), %rdi
	testq	%rdi, %rdi
	jne	.L2452
.L2355:
	movq	-96(%rbp), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2358:
	movq	-256(%rbp), %rdi
	movq	-144(%rbp), %rsi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
.LEHB188:
	call	_Unwind_Resume@PLT
.LEHE188:
.L2452:
	call	_ZdlPv@PLT
	jmp	.L2355
.L2432:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC47(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbx
.LEHB189:
	call	_ZNSt16invalid_argumentC1EPKc@PLT
.LEHE189:
	movq	_ZNSt16invalid_argumentD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt16invalid_argument(%rip), %rsi
	movq	%rbx, %rdi
.LEHB190:
	call	__cxa_throw@PLT
.L2294:
	movq	-96(%rbp), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	-272(%rbp), %rdi
	movq	72(%r12), %rsi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	24(%r12), %rdi
	testq	%rdi, %rdi
	je	.L2295
	call	_ZdlPv@PLT
.L2295:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L2296
	call	_ZdlPv@PLT
.L2296:
	movq	%r12, %rdi
	call	_ZdlPv@PLT
	movq	%rbx, %rdi
	call	_Unwind_Resume@PLT
.L2363:
	endbr64
	movq	%rax, %r12
	movq	%rbx, %rdi
	call	__cxa_free_exception@PLT
	movq	%r12, %rdi
	call	_Unwind_Resume@PLT
.LEHE190:
	.cfi_endproc
.LFE8721:
	.section	.gcc_except_table
.LLSDAC8721:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8721-.LLSDACSBC8721
.LLSDACSBC8721:
	.uleb128 .LEHB188-.LCOLDB48
	.uleb128 .LEHE188-.LEHB188
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB189-.LCOLDB48
	.uleb128 .LEHE189-.LEHB189
	.uleb128 .L2363-.LCOLDB48
	.uleb128 0
	.uleb128 .LEHB190-.LCOLDB48
	.uleb128 .LEHE190-.LEHB190
	.uleb128 0
	.uleb128 0
.LLSDACSEC8721:
	.section	.text.unlikely
	.text
	.size	_Z3add19quantumSparseMatrixS_, .-_Z3add19quantumSparseMatrixS_
	.section	.text.unlikely
	.size	_Z3add19quantumSparseMatrixS_.cold, .-_Z3add19quantumSparseMatrixS_.cold
.LCOLDE48:
	.text
.LHOTE48:
	.section	.text.unlikely
.LCOLDB49:
	.text
.LHOTB49:
	.p2align 4
	.globl	_ZplRK19quantumSparseMatrixS1_
	.type	_ZplRK19quantumSparseMatrixS1_, @function
_ZplRK19quantumSparseMatrixS1_:
.LFB8742:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8742
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pxor	%xmm0, %xmm0
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdx, %rbx
	subq	$240, %rsp
	.cfi_def_cfa_offset 288
	movq	(%rdx), %rsi
	movq	%fs:40, %rax
	movq	%rax, 232(%rsp)
	xorl	%eax, %eax
	movq	8(%rdx), %rax
	movaps	%xmm0, 128(%rsp)
	movq	$0, 144(%rsp)
	movq	%rax, %r13
	subq	%rsi, %r13
	movq	%r13, %rdx
	sarq	$2, %rdx
	je	.L2544
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2545
	movq	%r13, %rdi
.LEHB191:
	call	_Znwm@PLT
.LEHE191:
	movq	(%rbx), %rsi
	movq	%rax, %rcx
	movq	8(%rbx), %rax
	movq	%rax, %r14
	subq	%rsi, %r14
.L2455:
	movq	%rcx, %xmm0
	addq	%rcx, %r13
	punpcklqdq	%xmm0, %xmm0
	movq	%r13, 144(%rsp)
	movaps	%xmm0, 128(%rsp)
	cmpq	%rsi, %rax
	je	.L2457
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2457:
	movq	32(%rbx), %rax
	movq	24(%rbx), %rsi
	addq	%r14, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 136(%rsp)
	movq	%rax, %r13
	movups	%xmm0, 152(%rsp)
	movq	$0, 168(%rsp)
	subq	%rsi, %r13
	movq	%r13, %rdx
	sarq	$2, %rdx
	je	.L2546
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2547
	movq	%r13, %rdi
.LEHB192:
	call	_Znwm@PLT
.LEHE192:
	movq	%rax, %rcx
	movq	32(%rbx), %rax
	movq	24(%rbx), %rsi
	movq	%rax, %r14
	subq	%rsi, %r14
.L2459:
	movq	%rcx, %xmm0
	addq	%rcx, %r13
	punpcklqdq	%xmm0, %xmm0
	movq	%r13, 168(%rsp)
	movups	%xmm0, 152(%rsp)
	cmpq	%rsi, %rax
	je	.L2461
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2461:
	movl	48(%rbx), %eax
	movq	72(%rbx), %rsi
	leaq	192(%rsp), %rdx
	addq	%r14, %rcx
	movq	%rcx, 160(%rsp)
	movl	%eax, 176(%rsp)
	movl	$0, 192(%rsp)
	movq	$0, 200(%rsp)
	movq	%rdx, 208(%rsp)
	movq	%rdx, 216(%rsp)
	movq	$0, 224(%rsp)
	testq	%rsi, %rsi
	je	.L2462
	leaq	184(%rsp), %r13
	leaq	16(%rsp), %rcx
	movq	%r13, %rdi
	movq	%r13, 16(%rsp)
.LEHB193:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE193:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2463:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2463
	movq	%rcx, 208(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2464:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2464
	movq	96(%rbx), %rdx
	movq	%rcx, 216(%rsp)
	movq	%rax, 200(%rsp)
	movq	%rdx, 224(%rsp)
.L2462:
	movq	8(%rbp), %rax
	movq	0(%rbp), %rsi
	pxor	%xmm0, %xmm0
	movq	$0, 32(%rsp)
	movaps	%xmm0, 16(%rsp)
	movq	%rax, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2548
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2549
	movq	%rbx, %rdi
.LEHB194:
	call	_Znwm@PLT
.LEHE194:
	movq	%rax, %rcx
	movq	8(%rbp), %rax
	movq	0(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2466:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 32(%rsp)
	movaps	%xmm0, 16(%rsp)
	cmpq	%rsi, %rax
	je	.L2472
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2472:
	movq	32(%rbp), %rax
	movq	24(%rbp), %rsi
	addq	%r13, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 24(%rsp)
	movq	%rax, %rbx
	movups	%xmm0, 40(%rsp)
	movq	$0, 56(%rsp)
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2550
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2551
	movq	%rbx, %rdi
.LEHB195:
	call	_Znwm@PLT
.LEHE195:
	movq	%rax, %rcx
	movq	32(%rbp), %rax
	movq	24(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2474:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 56(%rsp)
	movups	%xmm0, 40(%rsp)
	cmpq	%rsi, %rax
	je	.L2476
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2476:
	movl	48(%rbp), %eax
	movq	72(%rbp), %rsi
	leaq	80(%rsp), %rdx
	addq	%r13, %rcx
	movq	%rcx, 48(%rsp)
	movl	%eax, 64(%rsp)
	movl	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	movq	%rdx, 96(%rsp)
	movq	%rdx, 104(%rsp)
	movq	$0, 112(%rsp)
	testq	%rsi, %rsi
	je	.L2477
	leaq	72(%rsp), %r13
	leaq	8(%rsp), %rcx
	movq	%r13, %rdi
	movq	%r13, 8(%rsp)
.LEHB196:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE196:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2478:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2478
	movq	%rcx, 96(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2479:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2479
	movq	96(%rbp), %rdx
	movq	%rcx, 104(%rsp)
	movq	%rax, 88(%rsp)
	movq	%rdx, 112(%rsp)
.L2477:
	leaq	128(%rsp), %rbp
	leaq	16(%rsp), %r13
	movq	%r12, %rdi
	movq	%rbp, %rdx
	movq	%r13, %rsi
.LEHB197:
	call	_Z3add19quantumSparseMatrixS_
.LEHE197:
	movq	88(%rsp), %rbx
	leaq	72(%rsp), %r13
	testq	%rbx, %rbx
	je	.L2489
.L2486:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2486
.L2489:
	movq	40(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2488
	call	_ZdlPv@PLT
.L2488:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2490
	call	_ZdlPv@PLT
.L2490:
	movq	200(%rsp), %rbx
	leaq	184(%rsp), %r13
	testq	%rbx, %rbx
	je	.L2494
.L2491:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2491
.L2494:
	movq	152(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2493
	call	_ZdlPv@PLT
.L2493:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2453
	call	_ZdlPv@PLT
.L2453:
	movq	232(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L2552
	addq	$240, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2544:
	.cfi_restore_state
	movq	%r13, %r14
	xorl	%ecx, %ecx
	jmp	.L2455
	.p2align 4,,10
	.p2align 3
.L2546:
	movq	%r13, %r14
	xorl	%ecx, %ecx
	jmp	.L2459
	.p2align 4,,10
	.p2align 3
.L2550:
	movq	%rbx, %r13
	xorl	%ecx, %ecx
	jmp	.L2474
	.p2align 4,,10
	.p2align 3
.L2548:
	movq	%rbx, %r13
	xorl	%ecx, %ecx
	jmp	.L2466
.L2552:
	call	__stack_chk_fail@PLT
.L2549:
.LEHB198:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE198:
.L2547:
.LEHB199:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE199:
.L2545:
.LEHB200:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE200:
.L2551:
.LEHB201:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE201:
.L2501:
	endbr64
	movq	%rax, %r12
	jmp	.L2481
.L2500:
	endbr64
	movq	%rax, %r12
	jmp	.L2483
.L2498:
	endbr64
	movq	%rax, %r12
	leaq	128(%rsp), %rbp
	jmp	.L2485
.L2502:
	endbr64
	movq	%rax, %rbp
	jmp	.L2469
.L2503:
	endbr64
	movq	%rax, %rbp
	jmp	.L2467
.L2499:
	endbr64
	movq	%rax, %r12
	jmp	.L2496
	.section	.gcc_except_table
.LLSDA8742:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8742-.LLSDACSB8742
.LLSDACSB8742:
	.uleb128 .LEHB191-.LFB8742
	.uleb128 .LEHE191-.LEHB191
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB192-.LFB8742
	.uleb128 .LEHE192-.LEHB192
	.uleb128 .L2502-.LFB8742
	.uleb128 0
	.uleb128 .LEHB193-.LFB8742
	.uleb128 .LEHE193-.LEHB193
	.uleb128 .L2503-.LFB8742
	.uleb128 0
	.uleb128 .LEHB194-.LFB8742
	.uleb128 .LEHE194-.LEHB194
	.uleb128 .L2498-.LFB8742
	.uleb128 0
	.uleb128 .LEHB195-.LFB8742
	.uleb128 .LEHE195-.LEHB195
	.uleb128 .L2500-.LFB8742
	.uleb128 0
	.uleb128 .LEHB196-.LFB8742
	.uleb128 .LEHE196-.LEHB196
	.uleb128 .L2501-.LFB8742
	.uleb128 0
	.uleb128 .LEHB197-.LFB8742
	.uleb128 .LEHE197-.LEHB197
	.uleb128 .L2499-.LFB8742
	.uleb128 0
	.uleb128 .LEHB198-.LFB8742
	.uleb128 .LEHE198-.LEHB198
	.uleb128 .L2498-.LFB8742
	.uleb128 0
	.uleb128 .LEHB199-.LFB8742
	.uleb128 .LEHE199-.LEHB199
	.uleb128 .L2502-.LFB8742
	.uleb128 0
	.uleb128 .LEHB200-.LFB8742
	.uleb128 .LEHE200-.LEHB200
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB201-.LFB8742
	.uleb128 .LEHE201-.LEHB201
	.uleb128 .L2500-.LFB8742
	.uleb128 0
.LLSDACSE8742:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8742
	.type	_ZplRK19quantumSparseMatrixS1_.cold, @function
_ZplRK19quantumSparseMatrixS1_.cold:
.LFSB8742:
.L2481:
	.cfi_def_cfa_offset 288
	.cfi_offset 3, -48
	.cfi_offset 6, -40
	.cfi_offset 12, -32
	.cfi_offset 13, -24
	.cfi_offset 14, -16
	movq	40(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2483
	call	_ZdlPv@PLT
.L2483:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2484
	call	_ZdlPv@PLT
.L2484:
	leaq	128(%rsp), %rbp
.L2485:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r12, %rdi
.LEHB202:
	call	_Unwind_Resume@PLT
.L2467:
	movq	152(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2469
	call	_ZdlPv@PLT
.L2469:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2470
	call	_ZdlPv@PLT
.L2470:
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE202:
.L2496:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L2485
	.cfi_endproc
.LFE8742:
	.section	.gcc_except_table
.LLSDAC8742:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8742-.LLSDACSBC8742
.LLSDACSBC8742:
	.uleb128 .LEHB202-.LCOLDB49
	.uleb128 .LEHE202-.LEHB202
	.uleb128 0
	.uleb128 0
.LLSDACSEC8742:
	.section	.text.unlikely
	.text
	.size	_ZplRK19quantumSparseMatrixS1_, .-_ZplRK19quantumSparseMatrixS1_
	.section	.text.unlikely
	.size	_ZplRK19quantumSparseMatrixS1_.cold, .-_ZplRK19quantumSparseMatrixS1_.cold
.LCOLDE49:
	.text
.LHOTE49:
	.section	.text.unlikely
.LCOLDB50:
	.text
.LHOTB50:
	.p2align 4
	.globl	_Z7product19quantumSparseMatrixS_
	.type	_Z7product19quantumSparseMatrixS_, @function
_Z7product19quantumSparseMatrixS_:
.LFB8697:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8697
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	movq	%rdx, %r12
	pushq	%rbx
	subq	$360, %rsp
	.cfi_offset 3, -56
	movq	%rsi, -304(%rbp)
	movq	(%rsi), %rdx
	movq	%rdi, -376(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	movq	(%r12), %rax
	movl	(%rax), %esi
	cmpl	%esi, 4(%rdx)
	jne	.L2713
	movl	4(%rax), %ebx
	pxor	%xmm0, %xmm0
	movl	$8, %edi
	movq	$0, -272(%rbp)
	movaps	%xmm0, -288(%rbp)
	movq	%rbx, %rax
	movl	(%rdx), %ebx
	salq	$32, %rax
	orq	%rax, %rbx
.LEHB203:
	call	_Znwm@PLT
.LEHE203:
	movq	%rbx, (%rax)
	leaq	8(%rax), %rdx
	movl	$104, %edi
	movq	%rax, -288(%rbp)
	movq	%rdx, -272(%rbp)
	movq	%rdx, -280(%rbp)
.LEHB204:
	call	_Znwm@PLT
.LEHE204:
	leaq	64(%rax), %rsi
	pxor	%xmm0, %xmm0
	leaq	-104(%rbp), %rdi
	movl	$0, 64(%rax)
	movq	%rsi, 80(%rax)
	leaq	24(%rax), %r13
	movq	%rsi, 88(%rax)
	movq	$0, 72(%rax)
	movq	$0, 96(%rax)
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	%rax, -352(%rbp)
	addq	$56, %rax
	movq	%rsi, -360(%rbp)
	leaq	-112(%rbp), %rsi
	movq	%rdi, -320(%rbp)
	movq	%rdi, -88(%rbp)
	movq	%rdi, -80(%rbp)
	movq	%rax, %rdi
	movl	$0, -104(%rbp)
	movq	$0, -96(%rbp)
	movq	%rsi, -384(%rbp)
	movq	$0, -72(%rbp)
	movq	%rax, -400(%rbp)
.LEHB205:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_
	movq	-352(%rbp), %rbx
	leaq	-288(%rbp), %r15
	movq	%r15, %rsi
	movq	%rbx, %rdi
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	(%rbx), %rax
	movq	%r15, %rsi
	movq	%r13, %rdi
	movl	(%rax), %eax
	movl	%eax, 48(%rbx)
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE205:
	movq	-96(%rbp), %rbx
	testq	%rbx, %rbx
	je	.L2561
	movq	-384(%rbp), %rax
	movq	%rax, %r15
.L2558:
	movq	24(%rbx), %rsi
	movq	%r15, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2558
.L2561:
	leaq	-160(%rbp), %rax
	movq	$0, -120(%rbp)
	movq	%rax, -392(%rbp)
	leaq	-152(%rbp), %rax
	movq	%rax, -368(%rbp)
	movq	%rax, -136(%rbp)
	movq	%rax, -128(%rbp)
	movq	-304(%rbp), %rax
	movl	$0, -152(%rbp)
	movq	$0, -144(%rbp)
	movq	72(%rax), %rsi
	testq	%rsi, %rsi
	je	.L2721
	movq	-392(%rbp), %rax
	movq	-384(%rbp), %rcx
	movq	-368(%rbp), %rdx
	movq	%rax, %rdi
	movq	%rax, -112(%rbp)
.LEHB206:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE206:
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2566:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2566
	movq	%rdx, -312(%rbp)
	movq	%rcx, %rax
	movq	%rdx, -136(%rbp)
	.p2align 4,,10
	.p2align 3
.L2567:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2567
	movq	-304(%rbp), %rax
	movq	72(%r12), %rsi
	movq	%rdx, -128(%rbp)
	movq	%rcx, -144(%rbp)
	movq	96(%rax), %rax
	movl	$0, -104(%rbp)
	movq	$0, -96(%rbp)
	movq	%rax, -120(%rbp)
	movq	-320(%rbp), %rax
	movq	$0, -72(%rbp)
	movq	%rax, -88(%rbp)
	movq	%rax, -80(%rbp)
	movq	%rax, -296(%rbp)
	testq	%rsi, %rsi
	jne	.L2633
.L2568:
	movq	-368(%rbp), %rsi
	cmpq	%rsi, -312(%rbp)
	je	.L2571
	.p2align 4,,10
	.p2align 3
.L2602:
	movq	-312(%rbp), %rax
	movq	-320(%rbp), %rsi
	addq	$32, %rax
	movq	%rax, -328(%rbp)
	leaq	-256(%rbp), %rax
	movq	%rax, -336(%rbp)
	cmpq	%rsi, -296(%rbp)
	je	.L2601
	.p2align 4,,10
	.p2align 3
.L2600:
	movq	-296(%rbp), %rax
	movq	(%r12), %rsi
	pxor	%xmm4, %xmm4
	movl	32(%rax), %r15d
	leaq	32(%rax), %r13
	movq	-312(%rbp), %rax
	movl	32(%rax), %r14d
	movq	8(%r12), %rax
	movaps	%xmm4, -192(%rbp)
	movq	$0, -176(%rbp)
	movq	%rax, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2722
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2723
	movq	%rbx, %rdi
.LEHB207:
	call	_Znwm@PLT
.LEHE207:
	movq	%rax, %rcx
	movq	8(%r12), %rax
	movq	(%r12), %rsi
	movq	%rax, %rdx
	subq	%rsi, %rdx
.L2575:
	addq	%rcx, %rbx
	movq	%rcx, -192(%rbp)
	movq	%rbx, -176(%rbp)
	cmpq	%rsi, %rax
	je	.L2577
	movq	%rcx, %rdi
	movq	%rdx, -344(%rbp)
	call	memcpy@PLT
	movq	-344(%rbp), %rdx
	movq	%rax, %rcx
.L2577:
	movq	-304(%rbp), %rax
	addq	%rdx, %rcx
	pxor	%xmm5, %xmm5
	movq	$0, -208(%rbp)
	movq	%rcx, -184(%rbp)
	movq	(%rax), %rsi
	movq	8(%rax), %rax
	movaps	%xmm5, -224(%rbp)
	movq	%rax, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2724
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2725
	movq	%rbx, %rdi
.LEHB208:
	call	_Znwm@PLT
.LEHE208:
	movq	-304(%rbp), %rdi
	movq	%rax, %rcx
	movq	8(%rdi), %rax
	movq	(%rdi), %rsi
	movq	%rax, %rdx
	subq	%rsi, %rdx
.L2579:
	addq	%rcx, %rbx
	movq	%rcx, -224(%rbp)
	movq	%rbx, -208(%rbp)
	cmpq	%rsi, %rax
	je	.L2581
	movq	%rcx, %rdi
	movq	%rdx, -344(%rbp)
	call	memcpy@PLT
	movq	-344(%rbp), %rdx
	movq	%rax, %rcx
.L2581:
	movq	-328(%rbp), %rax
	pushq	24(%r13)
	addq	%rdx, %rcx
	leaq	-192(%rbp), %rbx
	pushq	16(%r13)
	movl	%r15d, %r8d
	movq	%rbx, %rdx
	leaq	-224(%rbp), %rsi
	movq	-336(%rbp), %rdi
	pushq	8(%r13)
	pushq	24(%rax)
	pushq	16(%rax)
	pushq	8(%rax)
	movq	%rcx, -216(%rbp)
	movl	%r14d, %ecx
.LEHB209:
	.cfi_escape 0x2e,0x30
	call	_Z17multiplyDiagonalsSt6vectorIiSaIiEES1_ii8diagonalS2_
.LEHE209:
	movq	-224(%rbp), %rdi
	movl	-252(%rbp), %r15d
	addq	$48, %rsp
	movq	-248(%rbp), %r13
	movq	-240(%rbp), %r14
	testq	%rdi, %rdi
	je	.L2582
	call	_ZdlPv@PLT
.L2582:
	movq	-192(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2583
	call	_ZdlPv@PLT
.L2583:
	testl	%r15d, %r15d
	jle	.L2584
	movq	-296(%rbp), %rsi
	leal	-1(%r15), %ecx
	xorl	%eax, %eax
	movq	%rsi, %rdi
	jmp	.L2586
	.p2align 4,,10
	.p2align 3
.L2726:
	ucomiss	(%r14,%rax,4), %xmm2
	jp	.L2585
	jne	.L2585
	leaq	1(%rax), %rdx
	cmpq	%rax, %rcx
	je	.L2717
	movq	%rdx, %rax
.L2586:
	pxor	%xmm2, %xmm2
	ucomiss	0(%r13,%rax,4), %xmm2
	jp	.L2585
	je	.L2726
.L2585:
	movq	-312(%rbp), %rax
	movl	32(%rdi), %edx
	movq	%rdi, -296(%rbp)
	addl	32(%rax), %edx
	movq	-352(%rbp), %rax
	movq	72(%rax), %rax
	testq	%rax, %rax
	je	.L2590
	movq	-360(%rbp), %rsi
	jmp	.L2632
	.p2align 4,,10
	.p2align 3
.L2727:
	movq	%rax, %rsi
	movq	16(%rax), %rax
	testq	%rax, %rax
	je	.L2587
.L2632:
	cmpl	32(%rax), %edx
	jle	.L2727
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2632
.L2587:
	movq	%rdi, -296(%rbp)
	cmpq	%rsi, -360(%rbp)
	je	.L2590
	cmpl	32(%rsi), %edx
	jge	.L2591
.L2590:
	movl	-256(%rbp), %eax
	movq	%r13, %xmm0
	movq	%r14, %xmm6
	movq	-400(%rbp), %rdi
	punpcklqdq	%xmm6, %xmm0
	movq	%rbx, %rsi
	movl	%edx, -192(%rbp)
	movl	%eax, -184(%rbp)
	movl	%r15d, -180(%rbp)
	movaps	%xmm0, -176(%rbp)
.LEHB210:
	.cfi_escape 0x2e,0
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
.LEHE210:
	.p2align 4,,10
	.p2align 3
.L2584:
	movq	-296(%rbp), %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	-320(%rbp), %rdi
	movq	%rax, -296(%rbp)
	cmpq	%rdi, %rax
	jne	.L2600
.L2601:
	movq	-312(%rbp), %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	-368(%rbp), %rsi
	movq	%rax, -312(%rbp)
	cmpq	%rsi, %rax
	je	.L2571
	movq	-88(%rbp), %rax
	movq	%rax, -296(%rbp)
	jmp	.L2602
.L2721:
	movq	-320(%rbp), %rax
	movq	72(%r12), %rsi
	movl	$0, -104(%rbp)
	movq	$0, -96(%rbp)
	movq	%rax, -88(%rbp)
	movq	%rax, -80(%rbp)
	movq	$0, -72(%rbp)
	testq	%rsi, %rsi
	je	.L2571
.L2633:
	movq	-384(%rbp), %rdi
	movq	-320(%rbp), %rdx
	leaq	-192(%rbp), %rcx
	movq	%rdi, -192(%rbp)
.LEHB211:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE211:
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2569:
	movq	%rax, %rdi
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2569
	movq	%rdi, -88(%rbp)
	movq	%rcx, %rax
	.p2align 4,,10
	.p2align 3
.L2570:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2570
	movq	96(%r12), %rax
	movq	%rdi, -296(%rbp)
	movq	%rdx, -80(%rbp)
	movq	%rax, -72(%rbp)
	movq	-136(%rbp), %rax
	movq	%rcx, -96(%rbp)
	movq	%rax, -312(%rbp)
	jmp	.L2568
	.p2align 4,,10
	.p2align 3
.L2722:
	movq	%rbx, %rdx
	xorl	%ecx, %ecx
	jmp	.L2575
	.p2align 4,,10
	.p2align 3
.L2724:
	movq	%rbx, %rdx
	xorl	%ecx, %ecx
	jmp	.L2579
.L2593:
	movq	-296(%rbp), %rsi
	xorl	%ecx, %ecx
	movq	%rsi, %rdi
	.p2align 4,,10
	.p2align 3
.L2598:
	movss	(%r14,%rcx,4), %xmm0
	movss	(%rdx,%rcx,4), %xmm1
	movq	%rcx, %rsi
	addss	(%rax,%rcx,4), %xmm0
	addss	0(%r13,%rcx,4), %xmm1
	movss	%xmm1, (%rdx,%rcx,4)
	movss	%xmm0, (%rax,%rcx,4)
	addq	$1, %rcx
	cmpq	%rsi, %r10
	jne	.L2598
	.p2align 4,,10
	.p2align 3
.L2717:
	movq	%rdi, -296(%rbp)
	jmp	.L2584
	.p2align 4,,10
	.p2align 3
.L2591:
	movl	44(%rsi), %ecx
	testl	%ecx, %ecx
	jle	.L2584
	movq	56(%rsi), %rax
	movq	48(%rsi), %rdx
	leal	-1(%rcx), %r10d
	leaq	15(%rax), %rsi
	leaq	15(%rdx), %rdi
	movq	%rsi, %r8
	movq	%rsi, %r9
	subq	%r13, %r8
	cmpq	$30, %r8
	seta	%r8b
	subq	%rdx, %r9
	cmpq	$30, %r9
	seta	%r9b
	andl	%r8d, %r9d
	cmpl	$2, %r10d
	seta	%r8b
	subq	%r14, %rsi
	andl	%r9d, %r8d
	cmpq	$30, %rsi
	movq	%rdi, %rsi
	seta	%r9b
	subq	%r13, %rsi
	andl	%r9d, %r8d
	cmpq	$30, %rsi
	seta	%sil
	testb	%sil, %r8b
	je	.L2593
	subq	%r14, %rdi
	cmpq	$30, %rdi
	jbe	.L2593
	movl	%ecx, %edi
	movq	-296(%rbp), %rbx
	xorl	%esi, %esi
	shrl	$2, %edi
	salq	$4, %rdi
	.p2align 4,,10
	.p2align 3
.L2594:
	movups	(%r14,%rsi), %xmm0
	movups	(%rax,%rsi), %xmm6
	movups	0(%r13,%rsi), %xmm1
	movups	(%rdx,%rsi), %xmm7
	addps	%xmm6, %xmm0
	addps	%xmm7, %xmm1
	movups	%xmm1, (%rdx,%rsi)
	movups	%xmm0, (%rax,%rsi)
	addq	$16, %rsi
	cmpq	%rsi, %rdi
	jne	.L2594
	movl	%ecx, %r10d
	movq	%rbx, -296(%rbp)
	andl	$-4, %r10d
	testb	$3, %cl
	je	.L2584
	movl	%r10d, %edi
	leaq	0(,%rdi,4), %rsi
	movss	(%r14,%rdi,4), %xmm0
	leaq	(%rax,%rsi), %r8
	leaq	(%rdx,%rsi), %r9
	movss	(%r9), %xmm1
	addss	(%r8), %xmm0
	addss	0(%r13,%rdi,4), %xmm1
	leal	1(%r10), %edi
	movss	%xmm1, (%r9)
	movss	%xmm0, (%r8)
	cmpl	%edi, %ecx
	jle	.L2584
	leaq	4(%rsi), %rdi
	movss	4(%r14,%rsi), %xmm0
	addl	$2, %r10d
	leaq	(%rax,%rdi), %r8
	addq	%rdx, %rdi
	movss	(%rdi), %xmm1
	addss	(%r8), %xmm0
	addss	4(%r13,%rsi), %xmm1
	movss	%xmm1, (%rdi)
	movss	%xmm0, (%r8)
	cmpl	%r10d, %ecx
	jle	.L2584
	leaq	8(%rsi), %rcx
	movss	8(%r14,%rsi), %xmm0
	addq	%rcx, %rax
	addq	%rcx, %rdx
	movss	(%rdx), %xmm1
	addss	(%rax), %xmm0
	addss	8(%r13,%rsi), %xmm1
	movss	%xmm1, (%rdx)
	movss	%xmm0, (%rax)
	jmp	.L2584
.L2571:
	movq	-352(%rbp), %rbx
	movq	%rbx, %rdi
.LEHB212:
	call	_ZN19quantumSparseMatrix11pruneMatrixEv
	movq	8(%rbx), %rax
	movq	(%rbx), %rsi
	pxor	%xmm0, %xmm0
	movq	-376(%rbp), %rdi
	movq	%rax, %rbx
	subq	%rsi, %rbx
	movq	$0, 16(%rdi)
	movq	%rbx, %rdx
	movups	%xmm0, (%rdi)
	sarq	$2, %rdx
	je	.L2728
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2729
	movq	%rbx, %rdi
	call	_Znwm@PLT
.LEHE212:
	movq	-352(%rbp), %rsi
	movq	%rax, %rcx
	movq	8(%rsi), %rax
	movq	(%rsi), %rsi
	movq	%rax, %rdi
	subq	%rsi, %rdi
	movq	%rdi, %r15
.L2604:
	movq	-376(%rbp), %rdi
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 16(%rdi)
	movups	%xmm0, (%rdi)
	cmpq	%rsi, %rax
	je	.L2606
	movq	%rcx, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2606:
	movq	-352(%rbp), %rax
	movq	-376(%rbp), %rdi
	addq	%r15, %rcx
	pxor	%xmm0, %xmm0
	movq	24(%rax), %rsi
	movq	32(%rax), %rax
	movq	%rcx, 8(%rdi)
	movq	$0, 40(%rdi)
	movq	%rax, %rbx
	movups	%xmm0, 24(%rdi)
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2730
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2731
	movq	%rbx, %rdi
.LEHB213:
	call	_Znwm@PLT
.LEHE213:
	movq	-352(%rbp), %rsi
	movq	%rax, %rcx
	movq	32(%rsi), %rax
	movq	24(%rsi), %rsi
	movq	%rax, %rdi
	subq	%rsi, %rdi
	movq	%rdi, %r15
.L2608:
	movq	-376(%rbp), %rdi
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 40(%rdi)
	movups	%xmm0, 24(%rdi)
	cmpq	%rsi, %rax
	je	.L2610
	movq	%rcx, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2610:
	movq	-352(%rbp), %rdi
	movq	-376(%rbp), %rsi
	addq	%r15, %rcx
	movl	48(%rdi), %eax
	leaq	64(%rsi), %rdx
	movq	%rcx, 32(%rsi)
	movl	$0, 64(%rsi)
	movl	%eax, 48(%rsi)
	movq	%rsi, %rax
	movq	$0, 72(%rsi)
	movq	%rdx, 80(%rsi)
	movq	%rdx, 88(%rsi)
	movq	$0, 96(%rsi)
	movq	72(%rdi), %rsi
	testq	%rsi, %rsi
	je	.L2611
	leaq	56(%rax), %rdi
	leaq	-192(%rbp), %rcx
	movq	%rdi, -192(%rbp)
.LEHB214:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE214:
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2612:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2612
	movq	-376(%rbp), %rax
	movq	%rdx, 80(%rax)
	movq	%rcx, %rax
	.p2align 4,,10
	.p2align 3
.L2613:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2613
	movq	-352(%rbp), %rax
	movq	-376(%rbp), %rsi
	movq	96(%rax), %rax
	movq	%rdx, 88(%rsi)
	movq	%rcx, 72(%rsi)
	movq	%rax, 96(%rsi)
.L2611:
	movq	-96(%rbp), %rbx
	testq	%rbx, %rbx
	je	.L2622
	movq	-384(%rbp), %rax
	movq	%rax, %r15
.L2614:
	movq	24(%rbx), %rsi
	movq	%r15, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2614
.L2622:
	movq	-144(%rbp), %rbx
	testq	%rbx, %rbx
	je	.L2615
	movq	-392(%rbp), %rax
	movq	%rax, %r15
.L2616:
	movq	24(%rbx), %rsi
	movq	%r15, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2616
.L2615:
	movq	-288(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2553
	call	_ZdlPv@PLT
.L2553:
	movq	-56(%rbp), %rax
	xorq	%fs:40, %rax
	jne	.L2732
	movq	-376(%rbp), %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L2728:
	.cfi_restore_state
	movq	%rbx, %r15
	xorl	%ecx, %ecx
	jmp	.L2604
.L2730:
	movq	%rbx, %r15
	xorl	%ecx, %ecx
	jmp	.L2608
.L2725:
.LEHB215:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE215:
.L2723:
.LEHB216:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE216:
.L2732:
	call	__stack_chk_fail@PLT
.L2731:
.LEHB217:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE217:
.L2729:
.LEHB218:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE218:
.L2644:
	endbr64
	movq	%rax, %rbx
	jmp	.L2619
.L2639:
	endbr64
	movq	%rax, %rbx
	jmp	.L2628
.L2641:
	endbr64
	movq	%rax, %rbx
	jmp	.L2621
.L2645:
	endbr64
	movq	%rax, %rbx
	jmp	.L2617
.L2642:
	endbr64
	movq	%rax, %rbx
	jmp	.L2556
.L2643:
	endbr64
	movq	%rax, %r15
	jmp	.L2562
.L2637:
	endbr64
	movq	%rax, %rbx
	jmp	.L2565
.L2638:
	endbr64
	movq	%rax, %rbx
	jmp	.L2630
.L2640:
	endbr64
	movq	%rax, %rbx
	jmp	.L2626
	.section	.gcc_except_table
.LLSDA8697:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8697-.LLSDACSB8697
.LLSDACSB8697:
	.uleb128 .LEHB203-.LFB8697
	.uleb128 .LEHE203-.LEHB203
	.uleb128 .L2642-.LFB8697
	.uleb128 0
	.uleb128 .LEHB204-.LFB8697
	.uleb128 .LEHE204-.LEHB204
	.uleb128 .L2637-.LFB8697
	.uleb128 0
	.uleb128 .LEHB205-.LFB8697
	.uleb128 .LEHE205-.LEHB205
	.uleb128 .L2643-.LFB8697
	.uleb128 0
	.uleb128 .LEHB206-.LFB8697
	.uleb128 .LEHE206-.LEHB206
	.uleb128 .L2637-.LFB8697
	.uleb128 0
	.uleb128 .LEHB207-.LFB8697
	.uleb128 .LEHE207-.LEHB207
	.uleb128 .L2641-.LFB8697
	.uleb128 0
	.uleb128 .LEHB208-.LFB8697
	.uleb128 .LEHE208-.LEHB208
	.uleb128 .L2639-.LFB8697
	.uleb128 0
	.uleb128 .LEHB209-.LFB8697
	.uleb128 .LEHE209-.LEHB209
	.uleb128 .L2640-.LFB8697
	.uleb128 0
	.uleb128 .LEHB210-.LFB8697
	.uleb128 .LEHE210-.LEHB210
	.uleb128 .L2641-.LFB8697
	.uleb128 0
	.uleb128 .LEHB211-.LFB8697
	.uleb128 .LEHE211-.LEHB211
	.uleb128 .L2638-.LFB8697
	.uleb128 0
	.uleb128 .LEHB212-.LFB8697
	.uleb128 .LEHE212-.LEHB212
	.uleb128 .L2641-.LFB8697
	.uleb128 0
	.uleb128 .LEHB213-.LFB8697
	.uleb128 .LEHE213-.LEHB213
	.uleb128 .L2644-.LFB8697
	.uleb128 0
	.uleb128 .LEHB214-.LFB8697
	.uleb128 .LEHE214-.LEHB214
	.uleb128 .L2645-.LFB8697
	.uleb128 0
	.uleb128 .LEHB215-.LFB8697
	.uleb128 .LEHE215-.LEHB215
	.uleb128 .L2639-.LFB8697
	.uleb128 0
	.uleb128 .LEHB216-.LFB8697
	.uleb128 .LEHE216-.LEHB216
	.uleb128 .L2641-.LFB8697
	.uleb128 0
	.uleb128 .LEHB217-.LFB8697
	.uleb128 .LEHE217-.LEHB217
	.uleb128 .L2644-.LFB8697
	.uleb128 0
	.uleb128 .LEHB218-.LFB8697
	.uleb128 .LEHE218-.LEHB218
	.uleb128 .L2641-.LFB8697
	.uleb128 0
.LLSDACSE8697:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8697
	.type	_Z7product19quantumSparseMatrixS_.cold, @function
_Z7product19quantumSparseMatrixS_.cold:
.LFSB8697:
.L2617:
	.cfi_def_cfa 6, 16
	.cfi_offset 3, -56
	.cfi_offset 6, -16
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -24
	movq	-376(%rbp), %rax
	movq	24(%rax), %rdi
	testq	%rdi, %rdi
	je	.L2619
	call	_ZdlPv@PLT
.L2619:
	movq	-376(%rbp), %rax
	movq	(%rax), %rdi
	testq	%rdi, %rdi
	jne	.L2733
.L2621:
	movq	-96(%rbp), %rsi
	movq	-384(%rbp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2630:
	movq	-144(%rbp), %rsi
	movq	-392(%rbp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2565:
	movq	-288(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2631
	call	_ZdlPv@PLT
.L2631:
	movq	%rbx, %rdi
.LEHB219:
	call	_Unwind_Resume@PLT
.LEHE219:
.L2626:
	movq	-224(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2628
	call	_ZdlPv@PLT
.L2628:
	movq	-192(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2621
	call	_ZdlPv@PLT
	jmp	.L2621
.L2733:
	call	_ZdlPv@PLT
	jmp	.L2621
.L2713:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC23(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbx
.LEHB220:
	call	_ZNSt16invalid_argumentC1EPKc@PLT
.LEHE220:
	movq	_ZNSt16invalid_argumentD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt16invalid_argument(%rip), %rsi
	movq	%rbx, %rdi
.LEHB221:
	call	__cxa_throw@PLT
.L2556:
	movq	-288(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2557
	call	_ZdlPv@PLT
.L2557:
	movq	%rbx, %rdi
	call	_Unwind_Resume@PLT
.L2636:
	endbr64
	movq	%rax, %r12
	movq	%rbx, %rdi
	call	__cxa_free_exception@PLT
	movq	%r12, %rdi
	call	_Unwind_Resume@PLT
.LEHE221:
.L2562:
	movq	-96(%rbp), %rsi
	movq	-384(%rbp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	-352(%rbp), %rbx
	movq	-400(%rbp), %rdi
	movq	72(%rbx), %rsi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	24(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L2563
	call	_ZdlPv@PLT
.L2563:
	movq	-352(%rbp), %rax
	movq	(%rax), %rdi
	testq	%rdi, %rdi
	je	.L2564
	call	_ZdlPv@PLT
.L2564:
	movq	-352(%rbp), %rdi
	movq	%r15, %rbx
	call	_ZdlPv@PLT
	jmp	.L2565
	.cfi_endproc
.LFE8697:
	.section	.gcc_except_table
.LLSDAC8697:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8697-.LLSDACSBC8697
.LLSDACSBC8697:
	.uleb128 .LEHB219-.LCOLDB50
	.uleb128 .LEHE219-.LEHB219
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB220-.LCOLDB50
	.uleb128 .LEHE220-.LEHB220
	.uleb128 .L2636-.LCOLDB50
	.uleb128 0
	.uleb128 .LEHB221-.LCOLDB50
	.uleb128 .LEHE221-.LEHB221
	.uleb128 0
	.uleb128 0
.LLSDACSEC8697:
	.section	.text.unlikely
	.text
	.size	_Z7product19quantumSparseMatrixS_, .-_Z7product19quantumSparseMatrixS_
	.section	.text.unlikely
	.size	_Z7product19quantumSparseMatrixS_.cold, .-_Z7product19quantumSparseMatrixS_.cold
.LCOLDE50:
	.text
.LHOTE50:
	.section	.text.unlikely
.LCOLDB51:
	.text
.LHOTB51:
	.p2align 4
	.globl	_ZmlRK19quantumSparseMatrixS1_
	.type	_ZmlRK19quantumSparseMatrixS1_, @function
_ZmlRK19quantumSparseMatrixS1_:
.LFB8741:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8741
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pxor	%xmm0, %xmm0
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdx, %rbx
	subq	$240, %rsp
	.cfi_def_cfa_offset 288
	movq	(%rdx), %rsi
	movq	%fs:40, %rax
	movq	%rax, 232(%rsp)
	xorl	%eax, %eax
	movq	8(%rdx), %rax
	movaps	%xmm0, 128(%rsp)
	movq	$0, 144(%rsp)
	movq	%rax, %r13
	subq	%rsi, %r13
	movq	%r13, %rdx
	sarq	$2, %rdx
	je	.L2825
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2826
	movq	%r13, %rdi
.LEHB222:
	call	_Znwm@PLT
.LEHE222:
	movq	(%rbx), %rsi
	movq	%rax, %rcx
	movq	8(%rbx), %rax
	movq	%rax, %r14
	subq	%rsi, %r14
.L2736:
	movq	%rcx, %xmm0
	addq	%rcx, %r13
	punpcklqdq	%xmm0, %xmm0
	movq	%r13, 144(%rsp)
	movaps	%xmm0, 128(%rsp)
	cmpq	%rsi, %rax
	je	.L2738
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2738:
	movq	32(%rbx), %rax
	movq	24(%rbx), %rsi
	addq	%r14, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 136(%rsp)
	movq	%rax, %r13
	movups	%xmm0, 152(%rsp)
	movq	$0, 168(%rsp)
	subq	%rsi, %r13
	movq	%r13, %rdx
	sarq	$2, %rdx
	je	.L2827
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2828
	movq	%r13, %rdi
.LEHB223:
	call	_Znwm@PLT
.LEHE223:
	movq	%rax, %rcx
	movq	32(%rbx), %rax
	movq	24(%rbx), %rsi
	movq	%rax, %r14
	subq	%rsi, %r14
.L2740:
	movq	%rcx, %xmm0
	addq	%rcx, %r13
	punpcklqdq	%xmm0, %xmm0
	movq	%r13, 168(%rsp)
	movups	%xmm0, 152(%rsp)
	cmpq	%rsi, %rax
	je	.L2742
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2742:
	movl	48(%rbx), %eax
	movq	72(%rbx), %rsi
	leaq	192(%rsp), %rdx
	addq	%r14, %rcx
	movq	%rcx, 160(%rsp)
	movl	%eax, 176(%rsp)
	movl	$0, 192(%rsp)
	movq	$0, 200(%rsp)
	movq	%rdx, 208(%rsp)
	movq	%rdx, 216(%rsp)
	movq	$0, 224(%rsp)
	testq	%rsi, %rsi
	je	.L2743
	leaq	184(%rsp), %r13
	leaq	16(%rsp), %rcx
	movq	%r13, %rdi
	movq	%r13, 16(%rsp)
.LEHB224:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE224:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2744:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2744
	movq	%rcx, 208(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2745:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2745
	movq	96(%rbx), %rdx
	movq	%rcx, 216(%rsp)
	movq	%rax, 200(%rsp)
	movq	%rdx, 224(%rsp)
.L2743:
	movq	8(%rbp), %rax
	movq	0(%rbp), %rsi
	pxor	%xmm0, %xmm0
	movq	$0, 32(%rsp)
	movaps	%xmm0, 16(%rsp)
	movq	%rax, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2829
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2830
	movq	%rbx, %rdi
.LEHB225:
	call	_Znwm@PLT
.LEHE225:
	movq	%rax, %rcx
	movq	8(%rbp), %rax
	movq	0(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2747:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 32(%rsp)
	movaps	%xmm0, 16(%rsp)
	cmpq	%rsi, %rax
	je	.L2753
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2753:
	movq	32(%rbp), %rax
	movq	24(%rbp), %rsi
	addq	%r13, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 24(%rsp)
	movq	%rax, %rbx
	movups	%xmm0, 40(%rsp)
	movq	$0, 56(%rsp)
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2831
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2832
	movq	%rbx, %rdi
.LEHB226:
	call	_Znwm@PLT
.LEHE226:
	movq	%rax, %rcx
	movq	32(%rbp), %rax
	movq	24(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2755:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 56(%rsp)
	movups	%xmm0, 40(%rsp)
	cmpq	%rsi, %rax
	je	.L2757
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2757:
	movl	48(%rbp), %eax
	movq	72(%rbp), %rsi
	leaq	80(%rsp), %rdx
	addq	%r13, %rcx
	movq	%rcx, 48(%rsp)
	movl	%eax, 64(%rsp)
	movl	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	movq	%rdx, 96(%rsp)
	movq	%rdx, 104(%rsp)
	movq	$0, 112(%rsp)
	testq	%rsi, %rsi
	je	.L2758
	leaq	72(%rsp), %r13
	leaq	8(%rsp), %rcx
	movq	%r13, %rdi
	movq	%r13, 8(%rsp)
.LEHB227:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE227:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2759:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2759
	movq	%rcx, 96(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2760:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2760
	movq	96(%rbp), %rdx
	movq	%rcx, 104(%rsp)
	movq	%rax, 88(%rsp)
	movq	%rdx, 112(%rsp)
.L2758:
	leaq	128(%rsp), %rbp
	leaq	16(%rsp), %r13
	movq	%r12, %rdi
	movq	%rbp, %rdx
	movq	%r13, %rsi
.LEHB228:
	call	_Z7product19quantumSparseMatrixS_
.LEHE228:
	movq	88(%rsp), %rbx
	leaq	72(%rsp), %r13
	testq	%rbx, %rbx
	je	.L2770
.L2767:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2767
.L2770:
	movq	40(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2769
	call	_ZdlPv@PLT
.L2769:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2771
	call	_ZdlPv@PLT
.L2771:
	movq	200(%rsp), %rbx
	leaq	184(%rsp), %r13
	testq	%rbx, %rbx
	je	.L2775
.L2772:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2772
.L2775:
	movq	152(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2774
	call	_ZdlPv@PLT
.L2774:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2734
	call	_ZdlPv@PLT
.L2734:
	movq	232(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L2833
	addq	$240, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2825:
	.cfi_restore_state
	movq	%r13, %r14
	xorl	%ecx, %ecx
	jmp	.L2736
	.p2align 4,,10
	.p2align 3
.L2827:
	movq	%r13, %r14
	xorl	%ecx, %ecx
	jmp	.L2740
	.p2align 4,,10
	.p2align 3
.L2831:
	movq	%rbx, %r13
	xorl	%ecx, %ecx
	jmp	.L2755
	.p2align 4,,10
	.p2align 3
.L2829:
	movq	%rbx, %r13
	xorl	%ecx, %ecx
	jmp	.L2747
.L2833:
	call	__stack_chk_fail@PLT
.L2830:
.LEHB229:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE229:
.L2828:
.LEHB230:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE230:
.L2826:
.LEHB231:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE231:
.L2832:
.LEHB232:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE232:
.L2782:
	endbr64
	movq	%rax, %r12
	jmp	.L2762
.L2781:
	endbr64
	movq	%rax, %r12
	jmp	.L2764
.L2779:
	endbr64
	movq	%rax, %r12
	leaq	128(%rsp), %rbp
	jmp	.L2766
.L2783:
	endbr64
	movq	%rax, %rbp
	jmp	.L2750
.L2784:
	endbr64
	movq	%rax, %rbp
	jmp	.L2748
.L2780:
	endbr64
	movq	%rax, %r12
	jmp	.L2777
	.section	.gcc_except_table
.LLSDA8741:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8741-.LLSDACSB8741
.LLSDACSB8741:
	.uleb128 .LEHB222-.LFB8741
	.uleb128 .LEHE222-.LEHB222
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB223-.LFB8741
	.uleb128 .LEHE223-.LEHB223
	.uleb128 .L2783-.LFB8741
	.uleb128 0
	.uleb128 .LEHB224-.LFB8741
	.uleb128 .LEHE224-.LEHB224
	.uleb128 .L2784-.LFB8741
	.uleb128 0
	.uleb128 .LEHB225-.LFB8741
	.uleb128 .LEHE225-.LEHB225
	.uleb128 .L2779-.LFB8741
	.uleb128 0
	.uleb128 .LEHB226-.LFB8741
	.uleb128 .LEHE226-.LEHB226
	.uleb128 .L2781-.LFB8741
	.uleb128 0
	.uleb128 .LEHB227-.LFB8741
	.uleb128 .LEHE227-.LEHB227
	.uleb128 .L2782-.LFB8741
	.uleb128 0
	.uleb128 .LEHB228-.LFB8741
	.uleb128 .LEHE228-.LEHB228
	.uleb128 .L2780-.LFB8741
	.uleb128 0
	.uleb128 .LEHB229-.LFB8741
	.uleb128 .LEHE229-.LEHB229
	.uleb128 .L2779-.LFB8741
	.uleb128 0
	.uleb128 .LEHB230-.LFB8741
	.uleb128 .LEHE230-.LEHB230
	.uleb128 .L2783-.LFB8741
	.uleb128 0
	.uleb128 .LEHB231-.LFB8741
	.uleb128 .LEHE231-.LEHB231
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB232-.LFB8741
	.uleb128 .LEHE232-.LEHB232
	.uleb128 .L2781-.LFB8741
	.uleb128 0
.LLSDACSE8741:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8741
	.type	_ZmlRK19quantumSparseMatrixS1_.cold, @function
_ZmlRK19quantumSparseMatrixS1_.cold:
.LFSB8741:
.L2762:
	.cfi_def_cfa_offset 288
	.cfi_offset 3, -48
	.cfi_offset 6, -40
	.cfi_offset 12, -32
	.cfi_offset 13, -24
	.cfi_offset 14, -16
	movq	40(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2764
	call	_ZdlPv@PLT
.L2764:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2765
	call	_ZdlPv@PLT
.L2765:
	leaq	128(%rsp), %rbp
.L2766:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r12, %rdi
.LEHB233:
	call	_Unwind_Resume@PLT
.L2748:
	movq	152(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2750
	call	_ZdlPv@PLT
.L2750:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2751
	call	_ZdlPv@PLT
.L2751:
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE233:
.L2777:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L2766
	.cfi_endproc
.LFE8741:
	.section	.gcc_except_table
.LLSDAC8741:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8741-.LLSDACSBC8741
.LLSDACSBC8741:
	.uleb128 .LEHB233-.LCOLDB51
	.uleb128 .LEHE233-.LEHB233
	.uleb128 0
	.uleb128 0
.LLSDACSEC8741:
	.section	.text.unlikely
	.text
	.size	_ZmlRK19quantumSparseMatrixS1_, .-_ZmlRK19quantumSparseMatrixS1_
	.section	.text.unlikely
	.size	_ZmlRK19quantumSparseMatrixS1_.cold, .-_ZmlRK19quantumSparseMatrixS1_.cold
.LCOLDE51:
	.text
.LHOTE51:
	.section	.rodata.str1.8
	.align 8
.LC52:
	.string	"axes_1_product != axes_0_product i.e. "
	.section	.rodata.str1.1
.LC53:
	.string	" != "
	.section	.rodata.str1.8
	.align 8
.LC54:
	.string	"invalid axes, can't perform tensordot"
	.section	.text.unlikely
.LCOLDB55:
	.text
.LHOTB55:
	.p2align 4
	.globl	_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE
	.type	_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE, @function
_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE:
.LFB8730:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8730
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pxor	%xmm0, %xmm0
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rsi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdx, %rbx
	subq	$840, %rsp
	.cfi_def_cfa_offset 896
	movq	%rcx, 8(%rsp)
	leaq	704(%rsp), %rsi
	movq	%fs:40, %rax
	movq	%rax, 824(%rsp)
	xorl	%eax, %eax
	leaq	64(%rdi), %rax
	movups	%xmm0, (%rdi)
	movq	%rax, 80(%rdi)
	movq	%rax, 88(%rdi)
	movl	$0, 64(%rdi)
	movq	$0, 72(%rdi)
	movq	%rax, 40(%rsp)
	leaq	712(%rsp), %rax
	movq	$0, 96(%rdi)
	movq	%rax, 728(%rsp)
	movq	%rax, 736(%rsp)
	leaq	56(%rdi), %rax
	movups	%xmm0, 16(%rdi)
	movups	%xmm0, 32(%rdi)
	movq	%rax, %rdi
	movl	$0, 592(%rsp)
	movl	$0, 712(%rsp)
	movq	$0, 720(%rsp)
	movq	%rsi, (%rsp)
	movq	$0, 744(%rsp)
	movq	%rax, 48(%rsp)
.LEHB234:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_
.LEHE234:
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
	leaq	24(%r12), %rbp
	movl	592(%rsp), %edx
	movl	%edx, 48(%r12)
	cmpq	%rax, %rsi
	je	.L2835
	movl	%edx, (%rsi)
	addq	$4, %rsi
	movq	%rsi, 8(%r12)
	cmpq	%rax, %rsi
	je	.L2837
.L3292:
	movl	592(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
.L2838:
	movq	32(%r12), %rsi
	movq	40(%r12), %rax
	cmpq	%rax, %rsi
	je	.L2839
	movl	592(%rsp), %edx
	addq	$4, %rsi
	movl	%edx, -4(%rsi)
	movq	%rsi, 32(%r12)
	cmpq	%rax, %rsi
	je	.L2841
.L3291:
	movl	592(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 32(%r12)
.L2842:
	movq	720(%rsp), %rbp
	movq	(%rsp), %r13
	testq	%rbp, %rbp
	je	.L2846
.L2843:
	movq	24(%rbp), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
	movq	16(%rbp), %rbp
	call	_ZdlPv@PLT
	testq	%rbp, %rbp
	jne	.L2843
.L2846:
	movq	8(%rsp), %rax
	pxor	%xmm0, %xmm0
	xorl	%ebp, %ebp
	xorl	%esi, %esi
	movq	$0, 80(%rsp)
	leaq	96(%rsp), %r13
	movq	(%rax), %rdi
	movaps	%xmm0, 64(%rsp)
	xorl	%eax, %eax
	movq	$0, 112(%rsp)
	movq	24(%rdi), %rdx
	movaps	%xmm0, 96(%rsp)
	cmpq	%rdx, 32(%rdi)
	jne	.L2844
	jmp	.L2845
	.p2align 4,,10
	.p2align 3
.L3269:
	movl	(%rdx), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 104(%rsp)
.L2851:
	movq	24(%rdi), %rdx
	movq	32(%rdi), %rax
	addq	$1, %rbp
	subq	%rdx, %rax
	sarq	$2, %rax
	cmpq	%rbp, %rax
	jbe	.L2845
	movq	104(%rsp), %rsi
	movq	112(%rsp), %rax
.L2844:
	leaq	(%rdx,%rbp,4), %rdx
	cmpq	%rax, %rsi
	jne	.L3269
	movq	%r13, %rdi
.LEHB235:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%rsp), %rax
	movq	(%rax), %rdi
	jmp	.L2851
	.p2align 4,,10
	.p2align 3
.L2845:
	movq	24(%r14), %r9
	movq	32(%r14), %r8
	movl	$0, 704(%rsp)
	cmpq	%r9, %r8
	je	.L2852
	xorl	%ecx, %ecx
	leaq	64(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L2856:
	movq	(%rdi), %rsi
	movq	8(%rdi), %rdx
	subq	%rsi, %rdx
	sarq	$2, %rdx
	je	.L2853
	xorl	%eax, %eax
	jmp	.L2855
	.p2align 4,,10
	.p2align 3
.L3270:
	addq	$1, %rax
	cmpq	%rax, %rdx
	je	.L2853
.L2855:
	cmpl	%ecx, (%rsi,%rax,4)
	jne	.L3270
.L2854:
	movq	%r8, %rax
	addl	$1, %ecx
	subq	%r9, %rax
	movslq	%ecx, %rdx
	movl	%ecx, 704(%rsp)
	sarq	$2, %rax
	cmpq	%rax, %rdx
	jb	.L2856
.L2852:
	movq	24(%rbx), %r9
	movq	32(%rbx), %r8
	movl	$0, 704(%rsp)
	cmpq	%r9, %r8
	je	.L2857
	xorl	%ecx, %ecx
	leaq	96(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L2861:
	movq	24(%rdi), %rsi
	movq	32(%rdi), %rdx
	subq	%rsi, %rdx
	sarq	$2, %rdx
	je	.L2858
	xorl	%eax, %eax
	jmp	.L2860
	.p2align 4,,10
	.p2align 3
.L3271:
	addq	$1, %rax
	cmpq	%rdx, %rax
	je	.L2858
.L2860:
	cmpl	%ecx, (%rsi,%rax,4)
	jne	.L3271
.L2859:
	movq	%r8, %rax
	addl	$1, %ecx
	subq	%r9, %rax
	movslq	%ecx, %rdx
	movl	%ecx, 704(%rsp)
	sarq	$2, %rax
	cmpq	%rax, %rdx
	jb	.L2861
.L2857:
	movq	(%rdi), %rax
	movq	72(%rsp), %rsi
	xorl	%ebp, %ebp
	leaq	64(%rsp), %r13
	cmpq	%rax, 8(%rdi)
	jne	.L2862
	jmp	.L3267
	.p2align 4,,10
	.p2align 3
.L3273:
	movl	(%rdx), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 72(%rsp)
.L2866:
	movq	(%rdi), %rax
	movq	8(%rdi), %rdx
	addq	$1, %rbp
	subq	%rax, %rdx
	movq	%rdx, %rcx
	sarq	$2, %rcx
	cmpq	%rbp, %rcx
	jbe	.L3272
.L2862:
	leaq	(%rax,%rbp,4), %rdx
	cmpq	%rsi, 80(%rsp)
	jne	.L3273
	movq	%r13, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%rsp), %rax
	movq	72(%rsp), %rsi
	movq	(%rax), %rdi
	jmp	.L2866
	.p2align 4,,10
	.p2align 3
.L2853:
	movq	72(%rsp), %rsi
	cmpq	80(%rsp), %rsi
	je	.L3274
	movl	%ecx, (%rsi)
	addq	$4, %rsi
	movl	704(%rsp), %ecx
	movq	%rsi, 72(%rsp)
	jmp	.L2854
	.p2align 4,,10
	.p2align 3
.L2858:
	movq	104(%rsp), %rsi
	cmpq	112(%rsp), %rsi
	je	.L3275
	movl	%ecx, (%rsi)
	addq	$4, %rsi
	movl	704(%rsp), %ecx
	movq	%rsi, 104(%rsp)
	jmp	.L2859
	.p2align 4,,10
	.p2align 3
.L3272:
	testq	%rcx, %rcx
	je	.L3267
	movq	24(%r14), %r8
	addq	%rax, %rdx
	movl	$1, %r13d
	.p2align 4,,10
	.p2align 3
.L2870:
	movslq	(%rax), %rcx
	addq	$4, %rax
	imull	(%r8,%rcx,4), %r13d
	cmpq	%rdx, %rax
	jne	.L2870
.L2863:
	movq	24(%rdi), %rax
	movq	32(%rdi), %rcx
	subq	%rax, %rcx
	movq	%rcx, %rdi
	shrq	$2, %rdi
	je	.L3276
	movq	24(%rbx), %rdi
	addq	%rax, %rcx
	movl	$1, %edx
	.p2align 4,,10
	.p2align 3
.L2871:
	movslq	(%rax), %r8
	addq	$4, %rax
	imull	(%rdi,%r8,4), %edx
	cmpq	%rcx, %rax
	jne	.L2871
	movl	%edx, 24(%rsp)
.L2869:
	movq	64(%rsp), %r8
	movq	%rsi, %rbp
	pxor	%xmm0, %xmm0
	movq	$0, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	subq	%r8, %rbp
	movq	%rbp, %rax
	sarq	$2, %rax
	je	.L3277
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L3278
	movq	%rbp, %rdi
	call	_Znwm@PLT
.LEHE235:
	movq	72(%rsp), %rsi
	movq	64(%rsp), %r8
	movq	%rax, %rcx
	movq	%rsi, %r15
	subq	%r8, %r15
.L2873:
	movq	%rcx, %xmm0
	addq	%rcx, %rbp
	punpcklqdq	%xmm0, %xmm0
	movq	%rbp, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	cmpq	%r8, %rsi
	je	.L2875
	movq	%rcx, %rdi
	movq	%r15, %rdx
	movq	%r8, %rsi
	call	memmove@PLT
	movq	%rax, %rcx
.L2875:
	addq	%r15, %rcx
	movq	(%rsp), %r15
	movq	%r14, %rsi
	movq	%rcx, 600(%rsp)
	movq	%r15, %rdi
.LEHB236:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE236:
	leaq	480(%rsp), %rax
	leaq	592(%rsp), %rcx
	movq	%r15, %rsi
	movq	%rcx, %rdx
	movq	%rax, %rdi
	movq	%rax, 32(%rsp)
	movq	%rcx, 16(%rsp)
.LEHB237:
	call	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE237:
	movdqa	480(%rsp), %xmm1
	movq	496(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 496(%rsp)
	movq	(%r14), %rdi
	movaps	%xmm0, 480(%rsp)
	movq	%rax, 16(%r14)
	movups	%xmm1, (%r14)
	testq	%rdi, %rdi
	je	.L2876
	call	_ZdlPv@PLT
.L2876:
	movq	520(%rsp), %rax
	movq	24(%r14), %rdi
	pxor	%xmm0, %xmm0
	movq	$0, 520(%rsp)
	movdqu	504(%rsp), %xmm2
	movups	%xmm0, 504(%rsp)
	movq	%rax, 40(%r14)
	movups	%xmm2, 24(%r14)
	testq	%rdi, %rdi
	je	.L2877
	call	_ZdlPv@PLT
.L2877:
	movl	528(%rsp), %eax
	movq	72(%r14), %r15
	leaq	56(%r14), %rbp
	movl	%eax, 48(%r14)
	testq	%r15, %r15
	je	.L2881
.L2878:
	movq	24(%r15), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r15, %rdi
	movq	16(%r15), %r15
	call	_ZdlPv@PLT
	testq	%r15, %r15
	jne	.L2878
.L2881:
	movq	552(%rsp), %rdx
	leaq	64(%r14), %rax
	movq	$0, 72(%r14)
	movq	%rax, 80(%r14)
	movq	%rax, 88(%r14)
	movq	$0, 96(%r14)
	testq	%rdx, %rdx
	je	.L2880
	movl	544(%rsp), %ecx
	movq	%rdx, 72(%r14)
	movl	%ecx, 64(%r14)
	movq	560(%rsp), %rcx
	movq	%rcx, 80(%r14)
	movq	568(%rsp), %rcx
	movq	%rcx, 88(%r14)
	movq	%rax, 8(%rdx)
	movq	576(%rsp), %rax
	movq	%rax, 96(%r14)
.L2880:
	movq	504(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3017
	call	_ZdlPv@PLT
.L3017:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2882
	call	_ZdlPv@PLT
.L2882:
	movq	776(%rsp), %r15
	leaq	760(%rsp), %rbp
	testq	%r15, %r15
	je	.L2886
.L2883:
	movq	24(%r15), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r15, %rdi
	movq	16(%r15), %r15
	call	_ZdlPv@PLT
	testq	%r15, %r15
	jne	.L2883
.L2886:
	movq	728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2885
	call	_ZdlPv@PLT
.L2885:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2887
	call	_ZdlPv@PLT
.L2887:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2888
	call	_ZdlPv@PLT
.L2888:
	movq	104(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	96(%rsp), %rsi
	movq	$0, 496(%rsp)
	movaps	%xmm0, 480(%rsp)
	movq	%rax, %rbp
	subq	%rsi, %rbp
	movq	%rbp, %rdx
	sarq	$2, %rdx
	je	.L3279
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L3280
	movq	%rbp, %rdi
.LEHB238:
	call	_Znwm@PLT
.LEHE238:
	movq	%rax, %rcx
	movq	104(%rsp), %rax
	movq	96(%rsp), %rsi
	movq	%rax, %r15
	subq	%rsi, %r15
.L2890:
	movq	%rcx, %xmm0
	addq	%rcx, %rbp
	punpcklqdq	%xmm0, %xmm0
	movq	%rbp, 496(%rsp)
	movaps	%xmm0, 480(%rsp)
	cmpq	%rsi, %rax
	je	.L2892
	movq	%rcx, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2892:
	addq	%r15, %rcx
	movq	(%rsp), %r15
	movq	%rbx, %rsi
	movq	%rcx, 488(%rsp)
	movq	%r15, %rdi
.LEHB239:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE239:
	movq	32(%rsp), %rdx
	movq	16(%rsp), %rdi
	movq	%r15, %rsi
.LEHB240:
	call	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE240:
	movdqa	592(%rsp), %xmm3
	movq	608(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 608(%rsp)
	movq	(%rbx), %rdi
	movaps	%xmm0, 592(%rsp)
	movq	%rax, 16(%rbx)
	movups	%xmm3, (%rbx)
	testq	%rdi, %rdi
	je	.L2893
	call	_ZdlPv@PLT
.L2893:
	movq	632(%rsp), %rax
	movq	24(%rbx), %rdi
	pxor	%xmm0, %xmm0
	movq	$0, 632(%rsp)
	movdqu	616(%rsp), %xmm4
	movups	%xmm0, 616(%rsp)
	movq	%rax, 40(%rbx)
	movups	%xmm4, 24(%rbx)
	testq	%rdi, %rdi
	je	.L2894
	call	_ZdlPv@PLT
.L2894:
	movl	640(%rsp), %eax
	movq	72(%rbx), %r15
	leaq	56(%rbx), %rbp
	movl	%eax, 48(%rbx)
	testq	%r15, %r15
	je	.L2898
.L2895:
	movq	24(%r15), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r15, %rdi
	movq	16(%r15), %r15
	call	_ZdlPv@PLT
	testq	%r15, %r15
	jne	.L2895
.L2898:
	movq	664(%rsp), %rdx
	leaq	64(%rbx), %rax
	movq	$0, 72(%rbx)
	movq	%rax, 80(%rbx)
	movq	%rax, 88(%rbx)
	movq	$0, 96(%rbx)
	testq	%rdx, %rdx
	je	.L2897
	movl	656(%rsp), %ecx
	movq	%rdx, 72(%rbx)
	movl	%ecx, 64(%rbx)
	movq	672(%rsp), %rcx
	movq	%rcx, 80(%rbx)
	movq	680(%rsp), %rcx
	movq	%rcx, 88(%rbx)
	movq	%rax, 8(%rdx)
	movq	688(%rsp), %rax
	movq	%rax, 96(%rbx)
.L2897:
	movq	616(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3015
	call	_ZdlPv@PLT
.L3015:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2899
	call	_ZdlPv@PLT
.L2899:
	movq	776(%rsp), %r15
	leaq	760(%rsp), %rbp
	testq	%r15, %r15
	je	.L2903
.L2900:
	movq	24(%r15), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r15, %rdi
	movq	16(%r15), %r15
	call	_ZdlPv@PLT
	testq	%r15, %r15
	jne	.L2900
.L2903:
	movq	728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2902
	call	_ZdlPv@PLT
.L2902:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2904
	call	_ZdlPv@PLT
.L2904:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2905
	call	_ZdlPv@PLT
.L2905:
	movl	24(%rsp), %r15d
	cmpl	%r13d, %r15d
	je	.L2906
	movl	$38, %edx
	leaq	.LC52(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB241:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%r15d, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$4, %edx
	leaq	.LC53(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%r13d, %esi
	movq	%rbp, %rdi
	call	_ZNSolsEi@PLT
	movq	%rax, %rbp
	movq	(%rax), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %r13
	testq	%r13, %r13
	je	.L3281
	cmpb	$0, 56(%r13)
	je	.L2908
	movsbl	67(%r13), %esi
.L2909:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	jmp	.L3248
	.p2align 4,,10
	.p2align 3
.L2908:
	movq	%r13, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%r13), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L2909
	movq	%r13, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L2909
.L3275:
	movq	(%rsp), %rdx
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%rsp), %rax
	movl	704(%rsp), %ecx
	movq	24(%rbx), %r9
	movq	32(%rbx), %r8
	movq	(%rax), %rdi
	jmp	.L2859
.L3274:
	movq	(%rsp), %rdx
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%rsp), %rax
	movl	704(%rsp), %ecx
	movq	24(%r14), %r9
	movq	32(%r14), %r8
	movq	(%rax), %rdi
	jmp	.L2854
.L2906:
	movq	(%r14), %rdx
	movq	(%rbx), %rax
	movl	%r15d, %edi
	leaq	816(%rsp), %rbp
	movq	%rbp, %rsi
	movl	(%rax), %r13d
	movl	4(%rax), %r15d
	movl	(%rdx), %eax
	imull	4(%rdx), %eax
	movl	%edi, 820(%rsp)
	cltd
	idivl	%edi
	leaq	128(%rsp), %rdi
	movl	$2, %edx
	movl	%eax, 816(%rsp)
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE241:
	movl	%r13d, %eax
	movl	24(%rsp), %edi
	movq	%rbp, %rsi
	imull	%r15d, %eax
	movl	%edi, 816(%rsp)
	cltd
	idivl	%edi
	leaq	160(%rsp), %rdi
	movl	$2, %edx
	movl	%eax, 820(%rsp)
.LEHB242:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE242:
	movq	136(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	128(%rsp), %rsi
	movq	$0, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	movq	%rax, %rbp
	subq	%rsi, %rbp
	movq	%rbp, %rdx
	sarq	$2, %rdx
	je	.L3282
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L3283
	movq	%rbp, %rdi
.LEHB243:
	call	_Znwm@PLT
.LEHE243:
	movq	%rax, %rcx
	movq	136(%rsp), %rax
	movq	128(%rsp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2911:
	movq	%rcx, %xmm0
	addq	%rcx, %rbp
	punpcklqdq	%xmm0, %xmm0
	movq	%rbp, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	cmpq	%rsi, %rax
	je	.L2913
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2913:
	movq	(%rsp), %r15
	addq	%r13, %rcx
	movq	%r14, %rsi
	movq	%rcx, 600(%rsp)
	movq	%r15, %rdi
.LEHB244:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE244:
	leaq	256(%rsp), %rax
	movq	16(%rsp), %rdx
	movq	%r15, %rsi
	movq	%rax, %rdi
	movq	%rax, 56(%rsp)
.LEHB245:
	call	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE245:
	movq	776(%rsp), %r13
	leaq	760(%rsp), %rbp
	testq	%r13, %r13
	je	.L2917
.L2914:
	movq	24(%r13), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r13, %rdi
	movq	16(%r13), %r13
	call	_ZdlPv@PLT
	testq	%r13, %r13
	jne	.L2914
.L2917:
	movq	728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2916
	call	_ZdlPv@PLT
.L2916:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2918
	call	_ZdlPv@PLT
.L2918:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2919
	call	_ZdlPv@PLT
.L2919:
	movq	168(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	160(%rsp), %rsi
	movq	$0, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	movq	%rax, %rbp
	subq	%rsi, %rbp
	movq	%rbp, %rdx
	sarq	$2, %rdx
	je	.L3284
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L3285
	movq	%rbp, %rdi
.LEHB246:
	call	_Znwm@PLT
.LEHE246:
	movq	%rax, %rcx
	movq	168(%rsp), %rax
	movq	160(%rsp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2921:
	movq	%rcx, %xmm0
	addq	%rcx, %rbp
	punpcklqdq	%xmm0, %xmm0
	movq	%rbp, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	cmpq	%rsi, %rax
	je	.L2923
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2923:
	movq	(%rsp), %rbp
	addq	%r13, %rcx
	movq	%rbx, %rsi
	movq	%rcx, 600(%rsp)
	movq	%rbp, %rdi
.LEHB247:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE247:
	leaq	368(%rsp), %r15
	movq	16(%rsp), %rdx
	movq	%rbp, %rsi
	movq	%r15, %rdi
.LEHB248:
	call	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE248:
	movq	776(%rsp), %r13
	leaq	760(%rsp), %rbp
	testq	%r13, %r13
	je	.L2927
.L2924:
	movq	24(%r13), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r13, %rdi
	movq	16(%r13), %r13
	call	_ZdlPv@PLT
	testq	%r13, %r13
	jne	.L2924
.L2927:
	movq	728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2926
	call	_ZdlPv@PLT
.L2926:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2928
	call	_ZdlPv@PLT
.L2928:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2929
	call	_ZdlPv@PLT
.L2929:
	movq	16(%rsp), %r13
	movq	%r15, %rsi
	movq	%r13, %rdi
.LEHB249:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE249:
	movq	32(%rsp), %rbp
	movq	56(%rsp), %rsi
	movq	%rbp, %rdi
.LEHB250:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE250:
	movq	(%rsp), %rdi
	movq	%r13, %rdx
	movq	%rbp, %rsi
.LEHB251:
	call	_Z7product19quantumSparseMatrixS_
.LEHE251:
	movq	720(%rsp), %rax
	movq	(%r12), %rdi
	pxor	%xmm0, %xmm0
	movq	$0, 720(%rsp)
	movdqa	704(%rsp), %xmm5
	movaps	%xmm0, 704(%rsp)
	movq	%rax, 16(%r12)
	movups	%xmm5, (%r12)
	testq	%rdi, %rdi
	je	.L2930
	call	_ZdlPv@PLT
.L2930:
	movdqu	728(%rsp), %xmm6
	movq	744(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 744(%rsp)
	movq	24(%r12), %rdi
	movups	%xmm0, 728(%rsp)
	movq	%rax, 40(%r12)
	movups	%xmm6, 24(%r12)
	testq	%rdi, %rdi
	je	.L2931
	call	_ZdlPv@PLT
.L2931:
	movl	752(%rsp), %eax
	movq	72(%r12), %rbp
	movq	48(%rsp), %r13
	movl	%eax, 48(%r12)
	testq	%rbp, %rbp
	je	.L2935
.L2932:
	movq	24(%rbp), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
	movq	16(%rbp), %rbp
	call	_ZdlPv@PLT
	testq	%rbp, %rbp
	jne	.L2932
.L2935:
	movq	$0, 72(%r12)
	movq	40(%rsp), %rax
	movq	$0, 96(%r12)
	movq	%rax, 80(%r12)
	movq	%rax, 88(%r12)
	movq	776(%rsp), %rax
	testq	%rax, %rax
	je	.L2934
	movl	768(%rsp), %edx
	movq	40(%rsp), %rdi
	movq	%rax, 72(%r12)
	movl	%edx, 64(%r12)
	movq	784(%rsp), %rdx
	movq	%rdx, 80(%r12)
	movq	792(%rsp), %rdx
	movq	%rdx, 88(%r12)
	movq	%rdi, 8(%rax)
	movq	800(%rsp), %rax
	movq	%rax, 96(%r12)
.L2934:
	movq	728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3013
	call	_ZdlPv@PLT
.L3013:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2936
	call	_ZdlPv@PLT
.L2936:
	movq	552(%rsp), %r13
	leaq	536(%rsp), %rbp
	testq	%r13, %r13
	je	.L2940
.L2937:
	movq	24(%r13), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r13, %rdi
	movq	16(%r13), %r13
	call	_ZdlPv@PLT
	testq	%r13, %r13
	jne	.L2937
.L2940:
	movq	504(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2939
	call	_ZdlPv@PLT
.L2939:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2941
	call	_ZdlPv@PLT
.L2941:
	movq	664(%rsp), %r13
	leaq	648(%rsp), %rbp
	testq	%r13, %r13
	je	.L2945
.L2942:
	movq	24(%r13), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r13, %rdi
	movq	16(%r13), %r13
	call	_ZdlPv@PLT
	testq	%r13, %r13
	jne	.L2942
.L2945:
	movq	616(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2944
	call	_ZdlPv@PLT
.L2944:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2946
	call	_ZdlPv@PLT
.L2946:
	movq	8(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 720(%rsp)
	movaps	%xmm0, 704(%rsp)
	movq	(%rax), %rbp
	movq	32(%rbp), %rdx
	movq	24(%rbp), %rsi
	movq	%rdx, %rax
	subq	%rsi, %rax
	movq	%rax, 24(%rsp)
	sarq	$2, %rax
	je	.L3286
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L3287
	movq	24(%rsp), %rdi
.LEHB252:
	call	_Znwm@PLT
.LEHE252:
	movq	32(%rbp), %rdx
	movq	%rax, %rcx
	movq	8(%rsp), %rax
	movq	24(%rbp), %rsi
	movq	%rdx, %r8
	movq	(%rax), %r13
	subq	%rsi, %r8
.L2948:
	movq	24(%rsp), %rax
	movq	%rcx, %xmm0
	punpcklqdq	%xmm0, %xmm0
	addq	%rcx, %rax
	movaps	%xmm0, 704(%rsp)
	movq	%rax, 720(%rsp)
	cmpq	%rsi, %rdx
	je	.L2950
	movq	%r8, %rdx
	movq	%rcx, %rdi
	movq	%r8, 8(%rsp)
	call	memmove@PLT
	movq	8(%rsp), %r8
	movq	%rax, %rcx
.L2950:
	movq	8(%r13), %rax
	movq	0(%r13), %rsi
	addq	%r8, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 712(%rsp)
	movq	%rax, %rbp
	movaps	%xmm0, 592(%rsp)
	movq	$0, 608(%rsp)
	subq	%rsi, %rbp
	movq	%rbp, %rdx
	sarq	$2, %rdx
	je	.L3288
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L3289
	movq	%rbp, %rdi
.LEHB253:
	call	_Znwm@PLT
.LEHE253:
	movq	%rax, %rcx
	movq	8(%r13), %rax
	movq	0(%r13), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2952:
	movq	%rcx, %xmm0
	addq	%rcx, %rbp
	punpcklqdq	%xmm0, %xmm0
	movq	%rbp, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	cmpq	%rsi, %rax
	je	.L2954
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2954:
	leaq	24(%rbx), %rsi
	movq	32(%rsp), %rbx
	addq	%r13, %rcx
	movq	%rcx, 600(%rsp)
	movq	%rbx, %rdi
.LEHB254:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE254:
	leaq	192(%rsp), %rbp
	leaq	24(%r14), %rsi
	movq	%rbp, %rdi
.LEHB255:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE255:
	movq	(%rsp), %r8
	movq	16(%rsp), %rcx
	movq	%rbx, %rdx
	movq	%rbp, %rsi
	leaq	224(%rsp), %rdi
.LEHB256:
	call	_Z14newTensorShapeSt6vectorIiSaIiEES1_S1_S1_
.LEHE256:
	movdqa	224(%rsp), %xmm7
	movq	240(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 240(%rsp)
	movq	24(%r12), %rdi
	movaps	%xmm0, 224(%rsp)
	movq	%rax, 40(%r12)
	movups	%xmm7, 24(%r12)
	testq	%rdi, %rdi
	je	.L2956
	call	_ZdlPv@PLT
	movq	224(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2956
	call	_ZdlPv@PLT
.L2956:
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2958
	call	_ZdlPv@PLT
.L2958:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2959
	call	_ZdlPv@PLT
.L2959:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2960
	call	_ZdlPv@PLT
.L2960:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2961
	call	_ZdlPv@PLT
.L2961:
	movq	%r12, %rdi
.LEHB257:
	call	_ZN19quantumSparseMatrix11pruneMatrixEv
.LEHE257:
	movq	440(%rsp), %rbx
	leaq	424(%rsp), %rbp
	testq	%rbx, %rbx
	je	.L2965
.L2962:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2962
.L2965:
	movq	392(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2964
	call	_ZdlPv@PLT
.L2964:
	movq	368(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2966
	call	_ZdlPv@PLT
.L2966:
	movq	328(%rsp), %rbx
	leaq	312(%rsp), %rbp
	testq	%rbx, %rbx
	je	.L2970
.L2967:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2967
.L2970:
	movq	280(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2969
	call	_ZdlPv@PLT
.L2969:
	movq	256(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2971
	call	_ZdlPv@PLT
.L2971:
	movq	160(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2972
	call	_ZdlPv@PLT
.L2972:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2973
	call	_ZdlPv@PLT
.L2973:
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2974
	call	_ZdlPv@PLT
.L2974:
	movq	64(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2834
	call	_ZdlPv@PLT
.L2834:
	movq	824(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L3290
	addq	$840, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L3277:
	.cfi_restore_state
	movq	%rbp, %r15
	xorl	%ecx, %ecx
	jmp	.L2873
.L3279:
	movq	%rbp, %r15
	xorl	%ecx, %ecx
	jmp	.L2890
.L2839:
	leaq	592(%rsp), %rdx
	movq	%rbp, %rdi
.LEHB258:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%r12), %rsi
	movq	40(%r12), %rax
	cmpq	%rax, %rsi
	jne	.L3291
.L2841:
	leaq	592(%rsp), %rdx
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	jmp	.L2842
.L2835:
	leaq	592(%rsp), %rdx
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
	cmpq	%rax, %rsi
	jne	.L3292
.L2837:
	leaq	592(%rsp), %rdx
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE258:
	jmp	.L2838
.L3267:
	movl	$1, %r13d
	jmp	.L2863
.L3276:
	movl	$1, 24(%rsp)
	jmp	.L2869
.L3282:
	movq	%rbp, %r13
	xorl	%ecx, %ecx
	jmp	.L2911
.L3288:
	movq	%rbp, %r13
	xorl	%ecx, %ecx
	jmp	.L2952
.L3286:
	movq	24(%rsp), %r8
	movq	%rbp, %r13
	xorl	%ecx, %ecx
	jmp	.L2948
.L3284:
	movq	%rbp, %r13
	xorl	%ecx, %ecx
	jmp	.L2921
.L3285:
.LEHB259:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE259:
.L3278:
.LEHB260:
	call	_ZSt17__throw_bad_allocv@PLT
.L3281:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE260:
.L3283:
.LEHB261:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE261:
.L3290:
	call	__stack_chk_fail@PLT
.L3280:
.LEHB262:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE262:
.L3287:
.LEHB263:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE263:
.L3289:
.LEHB264:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE264:
.L3029:
	endbr64
	movq	%rax, %rbx
	jmp	.L2987
.L3033:
	endbr64
	movq	%rax, %rbx
	jmp	.L2989
.L3036:
	endbr64
	movq	%rax, %rbx
	jmp	.L2993
.L3034:
	endbr64
	movq	%rax, %rbx
	jmp	.L2988
.L3037:
	endbr64
	movq	%rax, %rbx
	jmp	.L2992
.L3032:
	endbr64
	movq	%rax, %rbx
	jmp	.L2991
.L3035:
	endbr64
	movq	%rax, %rbx
	jmp	.L2994
.L3023:
	endbr64
	movq	%rax, %rbp
	jmp	.L2977
.L3042:
	endbr64
	movq	%rax, %rbp
	jmp	.L2847
.L3030:
	endbr64
	movq	%rax, %rbx
	jmp	.L2985
.L3031:
	endbr64
	movq	%rax, %rbx
	jmp	.L2984
.L3040:
	endbr64
	movq	%rax, %rbx
	jmp	.L2997
.L3041:
	endbr64
	movq	%rax, %rbx
	jmp	.L2995
.L3028:
	endbr64
	movq	%rax, %rbx
	jmp	.L3004
.L3026:
	endbr64
	movq	%rax, %rbp
	jmp	.L2980
.L3025:
	endbr64
	movq	%rax, %rbp
	jmp	.L2981
.L3024:
	endbr64
	movq	%rax, %rbp
	jmp	.L2976
.L3246:
	endbr64
	jmp	.L3247
.L3039:
	endbr64
	movq	%rax, %rbx
	jmp	.L2999
.L3038:
	endbr64
	movq	%rax, %rbx
	jmp	.L3001
	.section	.gcc_except_table
.LLSDA8730:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8730-.LLSDACSB8730
.LLSDACSB8730:
	.uleb128 .LEHB234-.LFB8730
	.uleb128 .LEHE234-.LEHB234
	.uleb128 .L3042-.LFB8730
	.uleb128 0
	.uleb128 .LEHB235-.LFB8730
	.uleb128 .LEHE235-.LEHB235
	.uleb128 .L3246-.LFB8730
	.uleb128 0
	.uleb128 .LEHB236-.LFB8730
	.uleb128 .LEHE236-.LEHB236
	.uleb128 .L3023-.LFB8730
	.uleb128 0
	.uleb128 .LEHB237-.LFB8730
	.uleb128 .LEHE237-.LEHB237
	.uleb128 .L3024-.LFB8730
	.uleb128 0
	.uleb128 .LEHB238-.LFB8730
	.uleb128 .LEHE238-.LEHB238
	.uleb128 .L3246-.LFB8730
	.uleb128 0
	.uleb128 .LEHB239-.LFB8730
	.uleb128 .LEHE239-.LEHB239
	.uleb128 .L3025-.LFB8730
	.uleb128 0
	.uleb128 .LEHB240-.LFB8730
	.uleb128 .LEHE240-.LEHB240
	.uleb128 .L3026-.LFB8730
	.uleb128 0
	.uleb128 .LEHB241-.LFB8730
	.uleb128 .LEHE241-.LEHB241
	.uleb128 .L3246-.LFB8730
	.uleb128 0
	.uleb128 .LEHB242-.LFB8730
	.uleb128 .LEHE242-.LEHB242
	.uleb128 .L3028-.LFB8730
	.uleb128 0
	.uleb128 .LEHB243-.LFB8730
	.uleb128 .LEHE243-.LEHB243
	.uleb128 .L3029-.LFB8730
	.uleb128 0
	.uleb128 .LEHB244-.LFB8730
	.uleb128 .LEHE244-.LEHB244
	.uleb128 .L3030-.LFB8730
	.uleb128 0
	.uleb128 .LEHB245-.LFB8730
	.uleb128 .LEHE245-.LEHB245
	.uleb128 .L3031-.LFB8730
	.uleb128 0
	.uleb128 .LEHB246-.LFB8730
	.uleb128 .LEHE246-.LEHB246
	.uleb128 .L3032-.LFB8730
	.uleb128 0
	.uleb128 .LEHB247-.LFB8730
	.uleb128 .LEHE247-.LEHB247
	.uleb128 .L3033-.LFB8730
	.uleb128 0
	.uleb128 .LEHB248-.LFB8730
	.uleb128 .LEHE248-.LEHB248
	.uleb128 .L3034-.LFB8730
	.uleb128 0
	.uleb128 .LEHB249-.LFB8730
	.uleb128 .LEHE249-.LEHB249
	.uleb128 .L3035-.LFB8730
	.uleb128 0
	.uleb128 .LEHB250-.LFB8730
	.uleb128 .LEHE250-.LEHB250
	.uleb128 .L3036-.LFB8730
	.uleb128 0
	.uleb128 .LEHB251-.LFB8730
	.uleb128 .LEHE251-.LEHB251
	.uleb128 .L3037-.LFB8730
	.uleb128 0
	.uleb128 .LEHB252-.LFB8730
	.uleb128 .LEHE252-.LEHB252
	.uleb128 .L3035-.LFB8730
	.uleb128 0
	.uleb128 .LEHB253-.LFB8730
	.uleb128 .LEHE253-.LEHB253
	.uleb128 .L3038-.LFB8730
	.uleb128 0
	.uleb128 .LEHB254-.LFB8730
	.uleb128 .LEHE254-.LEHB254
	.uleb128 .L3039-.LFB8730
	.uleb128 0
	.uleb128 .LEHB255-.LFB8730
	.uleb128 .LEHE255-.LEHB255
	.uleb128 .L3040-.LFB8730
	.uleb128 0
	.uleb128 .LEHB256-.LFB8730
	.uleb128 .LEHE256-.LEHB256
	.uleb128 .L3041-.LFB8730
	.uleb128 0
	.uleb128 .LEHB257-.LFB8730
	.uleb128 .LEHE257-.LEHB257
	.uleb128 .L3035-.LFB8730
	.uleb128 0
	.uleb128 .LEHB258-.LFB8730
	.uleb128 .LEHE258-.LEHB258
	.uleb128 .L3042-.LFB8730
	.uleb128 0
	.uleb128 .LEHB259-.LFB8730
	.uleb128 .LEHE259-.LEHB259
	.uleb128 .L3032-.LFB8730
	.uleb128 0
	.uleb128 .LEHB260-.LFB8730
	.uleb128 .LEHE260-.LEHB260
	.uleb128 .L3246-.LFB8730
	.uleb128 0
	.uleb128 .LEHB261-.LFB8730
	.uleb128 .LEHE261-.LEHB261
	.uleb128 .L3029-.LFB8730
	.uleb128 0
	.uleb128 .LEHB262-.LFB8730
	.uleb128 .LEHE262-.LEHB262
	.uleb128 .L3246-.LFB8730
	.uleb128 0
	.uleb128 .LEHB263-.LFB8730
	.uleb128 .LEHE263-.LEHB263
	.uleb128 .L3035-.LFB8730
	.uleb128 0
	.uleb128 .LEHB264-.LFB8730
	.uleb128 .LEHE264-.LEHB264
	.uleb128 .L3038-.LFB8730
	.uleb128 0
.LLSDACSE8730:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8730
	.type	_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE.cold, @function
_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE.cold:
.LFSB8730:
.L2984:
	.cfi_def_cfa_offset 896
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2985:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2987
	call	_ZdlPv@PLT
.L2987:
	movq	160(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3004
	call	_ZdlPv@PLT
.L3004:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3005
	call	_ZdlPv@PLT
.L3005:
	movq	%rbx, %rbp
.L2979:
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3006
	call	_ZdlPv@PLT
.L3006:
	movq	64(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3007
	call	_ZdlPv@PLT
.L3007:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
.LEHB265:
	call	_Unwind_Resume@PLT
.L2988:
	movq	(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2989:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2991
	call	_ZdlPv@PLT
.L2991:
	movq	56(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L2987
.L2992:
	movq	32(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2993:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2994:
	movq	%r15, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L2991
.L2976:
	movq	(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2977:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2979
.L3268:
	call	_ZdlPv@PLT
	jmp	.L2979
.L2847:
	movq	720(%rsp), %rsi
	movq	(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	48(%rsp), %rdi
	movq	72(%r12), %rsi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	24(%r12), %rdi
	testq	%rdi, %rdi
	je	.L2848
	call	_ZdlPv@PLT
.L2848:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L2849
	call	_ZdlPv@PLT
.L2849:
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE265:
.L2995:
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2997
	call	_ZdlPv@PLT
.L2997:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2999
	call	_ZdlPv@PLT
.L2999:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3001
	call	_ZdlPv@PLT
.L3001:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2994
	call	_ZdlPv@PLT
	jmp	.L2994
.L3248:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC54(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
.LEHB266:
	call	_ZNSt16invalid_argumentC1EPKc@PLT
.LEHE266:
	movq	_ZNSt16invalid_argumentD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt16invalid_argument(%rip), %rsi
	movq	%r13, %rdi
.LEHB267:
	call	__cxa_throw@PLT
.LEHE267:
.L3022:
	endbr64
.L3247:
	movq	%rax, %rbp
	jmp	.L2979
.L3027:
	endbr64
	movq	%r13, %rdi
	movq	%rax, %rbp
	call	__cxa_free_exception@PLT
	jmp	.L2979
.L2980:
	movq	(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2981:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L3268
	jmp	.L2979
	.cfi_endproc
.LFE8730:
	.section	.gcc_except_table
.LLSDAC8730:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8730-.LLSDACSBC8730
.LLSDACSBC8730:
	.uleb128 .LEHB265-.LCOLDB55
	.uleb128 .LEHE265-.LEHB265
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB266-.LCOLDB55
	.uleb128 .LEHE266-.LEHB266
	.uleb128 .L3027-.LCOLDB55
	.uleb128 0
	.uleb128 .LEHB267-.LCOLDB55
	.uleb128 .LEHE267-.LEHB267
	.uleb128 .L3022-.LCOLDB55
	.uleb128 0
.LLSDACSEC8730:
	.section	.text.unlikely
	.text
	.size	_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE, .-_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE
	.section	.text.unlikely
	.size	_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE.cold, .-_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE.cold
.LCOLDE55:
	.text
.LHOTE55:
	.section	.rodata.str1.1
.LC116:
	.string	"test case - "
.LC117:
	.string	" = "
.LC118:
	.string	"1"
.LC119:
	.string	" -- "
.LC120:
	.string	"2"
.LC121:
	.string	"3"
	.section	.rodata.str1.8
	.align 8
.LC122:
	.string	"getting element in diagonal idx = "
	.section	.rodata.str1.1
.LC123:
	.string	" position = "
.LC124:
	.string	"matrix position - "
.LC125:
	.string	"tensor position - "
	.section	.rodata.str1.8
	.align 8
.LC126:
	.string	"reading element from dense version: "
	.section	.rodata.str1.1
.LC127:
	.string	"4"
.LC128:
	.string	" --example1-- "
.LC129:
	.string	" --example2-- "
.LC131:
	.string	"5"
.LC132:
	.string	"30"
.LC133:
	.string	"stoi"
.LC134:
	.string	" ---- dense product ---- "
.LC135:
	.string	" ---- correct answer ---- "
.LC136:
	.string	" -- first -- "
.LC137:
	.string	" -- second -- "
.LC138:
	.string	" -- qp -- "
.LC139:
	.string	"test"
	.section	.text.unlikely
.LCOLDB140:
	.section	.text.startup,"ax",@progbits
.LHOTB140:
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB8759:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8759
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	leaq	-32768(%rsp), %r11
	.cfi_def_cfa 11, 32824
.LPSRL0:
	subq	$4096, %rsp
	orq	$0, (%rsp)
	cmpq	%r11, %rsp
	jne	.LPSRL0
	.cfi_def_cfa_register 7
	subq	$2552, %rsp
	.cfi_def_cfa_offset 35376
	movl	$12, %ecx
	pxor	%xmm0, %xmm0
	movq	%fs:40, %rax
	movq	%rax, 35304(%rsp)
	xorl	%eax, %eax
	movl	%edi, %ebx
	leaq	15232(%rsp), %rdi
	movq	%rsi, %r13
	leaq	4336(%rsp), %rbp
	leaq	15232(%rsp), %rdx
	movl	$5, %esi
	movq	$0, 1216(%rsp)
	movq	%rbp, 720(%rsp)
	movaps	%xmm0, 1200(%rsp)
	rep stosq
	movl	$0x3f800000, 15272(%rsp)
	movl	$0x3f800000, 15296(%rsp)
	movl	$0x3f800000, 15320(%rsp)
	movl	$0, (%rdi)
	movq	%rbp, %rdi
.LEHB268:
	call	_ZN11denseMatrixC1EiPf
.LEHE268:
	leaq	15344(%rsp), %rdi
	movl	$12, %ecx
	xorl	%eax, %eax
	movl	$5, %esi
	rep stosq
	leaq	4416(%rsp), %r12
	leaq	15344(%rsp), %rdx
	movl	$0x40000000, 15344(%rsp)
	movq	%r12, %rdi
	movl	$0x40400000, 15368(%rsp)
	movl	$0x40800000, 15392(%rsp)
	movl	$0x40a00000, 15416(%rsp)
	movl	$0x40c00000, 15440(%rsp)
	movq	%r12, 760(%rsp)
.LEHB269:
	call	_ZN11denseMatrixC1EiPf
.LEHE269:
	leaq	1232(%rsp), %r14
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1248(%rsp)
	movq	%r14, %rdi
	movq	%r14, 592(%rsp)
	leaq	1200(%rsp), %r15
	movaps	%xmm0, 1232(%rsp)
.LEHB270:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	leaq	1200(%rsp), %r15
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	leaq	1200(%rsp), %r15
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	15456(%rsp), %rdi
	movl	$12, %ecx
	xorl	%eax, %eax
	movl	$5, %esi
	rep stosq
	leaq	4496(%rsp), %rbp
	leaq	15456(%rsp), %rdx
	movl	$0x3f800000, 15496(%rsp)
	movl	$0x3f800000, 15520(%rsp)
	movl	$0x3f800000, 15544(%rsp)
	movq	%rbp, 792(%rsp)
	movl	$0, (%rdi)
	movq	%rbp, %rdi
	call	_ZN11denseMatrixC1EiPf
.LEHE270:
	leaq	15568(%rsp), %rdi
	movl	$12, %ecx
	xorl	%eax, %eax
	movl	$5, %esi
	rep stosq
	leaq	4576(%rsp), %r12
	leaq	15568(%rsp), %rdx
	movl	$0x40000000, 15576(%rsp)
	movl	$0x40400000, 15600(%rsp)
	movl	$0x40800000, 15624(%rsp)
	movq	%r12, 832(%rsp)
	movl	$0, (%rdi)
	movq	%r12, %rdi
.LEHB271:
	call	_ZN11denseMatrixC1EiPf
.LEHE271:
	leaq	1264(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1280(%rsp)
	movq	%rax, %rdi
	movq	%rax, 600(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1264(%rsp)
.LEHB272:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	15680(%rsp), %rdi
	movl	$12, %ecx
	xorl	%eax, %eax
	movl	$5, %esi
	rep stosq
	leaq	4656(%rsp), %rbp
	leaq	15680(%rsp), %rdx
	movl	$0x3f800000, 15720(%rsp)
	movl	$0x3f800000, 15744(%rsp)
	movl	$0x3f800000, 15768(%rsp)
	movq	%rbp, 864(%rsp)
	movl	$0, (%rdi)
	movq	%rbp, %rdi
	call	_ZN11denseMatrixC1EiPf
.LEHE272:
	leaq	15792(%rsp), %rdi
	movl	$12, %ecx
	xorl	%eax, %eax
	movl	$5, %esi
	rep stosq
	leaq	4736(%rsp), %r12
	leaq	15792(%rsp), %rdx
	movl	$0x3f800000, 15812(%rsp)
	movl	$0x40000000, 15836(%rsp)
	movl	$0x40400000, 15860(%rsp)
	movl	$0x40800000, 15884(%rsp)
	movq	%r12, 904(%rsp)
	movl	$0, (%rdi)
	movq	%r12, %rdi
.LEHB273:
	call	_ZN11denseMatrixC1EiPf
.LEHE273:
	leaq	1296(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1312(%rsp)
	movq	%rax, %rdi
	movq	%rax, 616(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1296(%rsp)
.LEHB274:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	15904(%rsp), %rdi
	movl	$12, %ecx
	xorl	%eax, %eax
	movl	$5, %esi
	rep stosq
	leaq	4816(%rsp), %rbp
	leaq	15904(%rsp), %rdx
	movl	$0x3f800000, 15924(%rsp)
	movl	$0x3f800000, 15948(%rsp)
	movl	$0x3f800000, 15972(%rsp)
	movl	$0x3f800000, 15996(%rsp)
	movq	%rbp, 936(%rsp)
	movl	$0, (%rdi)
	movq	%rbp, %rdi
	call	_ZN11denseMatrixC1EiPf
.LEHE274:
	leaq	16016(%rsp), %rdi
	movl	$12, %ecx
	xorl	%eax, %eax
	movl	$5, %esi
	rep stosq
	leaq	4896(%rsp), %r12
	leaq	16016(%rsp), %rdx
	movl	$0x3f800000, 16036(%rsp)
	movl	$0x40000000, 16060(%rsp)
	movl	$0x40400000, 16084(%rsp)
	movl	$0x40800000, 16108(%rsp)
	movq	%r12, 960(%rsp)
	movl	$0, (%rdi)
	movq	%r12, %rdi
.LEHB275:
	call	_ZN11denseMatrixC1EiPf
.LEHE275:
	leaq	1328(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1344(%rsp)
	movq	%rax, %rdi
	movq	%rax, 632(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1328(%rsp)
.LEHB276:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	16128(%rsp), %rdi
	movl	$12, %ecx
	xorl	%eax, %eax
	movl	$5, %esi
	rep stosq
	leaq	4976(%rsp), %rbp
	leaq	16128(%rsp), %rdx
	movl	$0x3f800000, 16136(%rsp)
	movl	$0x3f800000, 16160(%rsp)
	movl	$0x3f800000, 16184(%rsp)
	movq	%rbp, 984(%rsp)
	movl	$0, (%rdi)
	movq	%rbp, %rdi
	call	_ZN11denseMatrixC1EiPf
.LEHE276:
	leaq	16240(%rsp), %rdi
	movl	$12, %ecx
	xorl	%eax, %eax
	movl	$5, %esi
	rep stosq
	leaq	5056(%rsp), %r12
	leaq	16240(%rsp), %rdx
	movl	$0x40000000, 16240(%rsp)
	movq	%r12, %rdi
	movl	$0x40400000, 16264(%rsp)
	movl	$0x40800000, 16288(%rsp)
	movl	$0x40a00000, 16312(%rsp)
	movl	$0x40c00000, 16336(%rsp)
	movq	%r12, 1008(%rsp)
.LEHB277:
	call	_ZN11denseMatrixC1EiPf
.LEHE277:
	leaq	1360(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1376(%rsp)
	movq	%rax, %rdi
	movq	%rax, 640(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1360(%rsp)
.LEHB278:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	5136(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	16352(%rsp), %rdi
	leaq	16352(%rsp), %rdx
	movq	%rbp, 1024(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 16352(%rsp)
	movl	$0x3f800000, 16396(%rsp)
	movl	$0x3f800000, 16424(%rsp)
	movl	$0x3f800000, 16452(%rsp)
	movl	$0x3f800000, 16496(%rsp)
	movl	$0x3f800000, 16540(%rsp)
	movl	$0x3f800000, 16568(%rsp)
	movl	$0x3f800000, 16596(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE278:
	leaq	5216(%rsp), %r12
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	16608(%rsp), %rdi
	leaq	16608(%rsp), %rdx
	movq	%r12, 1048(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x3f800000, 16608(%rsp)
	movl	$0x3f800000, 16644(%rsp)
	movl	$0x3f800000, 16696(%rsp)
	movl	$0x3f800000, 16732(%rsp)
	movl	$0x3f800000, 16752(%rsp)
	movl	$0x3f800000, 16788(%rsp)
	movl	$0x3f800000, 16808(%rsp)
	movl	$0x3f800000, 16844(%rsp)
.LEHB279:
	call	_ZN11denseMatrixC1EiPf
.LEHE279:
	leaq	1392(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1408(%rsp)
	movq	%rax, %rdi
	movq	%rax, 664(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1392(%rsp)
.LEHB280:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	5296(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	16864(%rsp), %rdi
	leaq	16864(%rsp), %rdx
	movq	%rbp, 1072(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 16864(%rsp)
	movl	$0x3f800000, 16900(%rsp)
	movl	$0x3f800000, 17008(%rsp)
	movl	$0x3f800000, 17044(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE280:
	leaq	5376(%rsp), %r12
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	17120(%rsp), %rdi
	leaq	17120(%rsp), %rdx
	movq	%r12, 1096(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x3f800000, 17220(%rsp)
	movl	$0x3f800000, 17364(%rsp)
.LEHB281:
	call	_ZN11denseMatrixC1EiPf
.LEHE281:
	leaq	1424(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1440(%rsp)
	movq	%rax, %rdi
	movq	%rax, 672(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1424(%rsp)
.LEHB282:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	5456(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	17376(%rsp), %rdi
	leaq	17376(%rsp), %rdx
	movq	%rbp, 1112(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x40000000, 17384(%rsp)
	movl	$0x40400000, 17420(%rsp)
	movl	$0x40800000, 17456(%rsp)
	movl	$0x40a00000, 17492(%rsp)
	movl	$0x40c00000, 17528(%rsp)
	movl	$0x40e00000, 17564(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE282:
	leaq	5536(%rsp), %r12
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	17632(%rsp), %rdi
	leaq	17632(%rsp), %rdx
	movq	%r12, 1128(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x41000000, 17648(%rsp)
	movl	$0x41100000, 17684(%rsp)
	movl	$0x41200000, 17720(%rsp)
	movl	$0x41300000, 17756(%rsp)
.LEHB283:
	call	_ZN11denseMatrixC1EiPf
.LEHE283:
	leaq	1456(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1472(%rsp)
	movq	%rax, %rdi
	movq	%rax, 680(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1456(%rsp)
.LEHB284:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	5616(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	17888(%rsp), %rdi
	leaq	17888(%rsp), %rdx
	movq	%rbp, 1136(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x40000000, 17952(%rsp)
	movl	$0x40400000, 17988(%rsp)
	movl	$0x40800000, 18024(%rsp)
	movl	$0x40a00000, 18060(%rsp)
	movl	$0x40c00000, 18096(%rsp)
	movl	$0x40e00000, 18132(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE284:
	leaq	18144(%rsp), %rdi
	movl	$31, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	rep stosq
	leaq	5696(%rsp), %r12
	leaq	18144(%rsp), %rdx
	movq	%r12, 392(%rsp)
	movl	$0, (%rdi)
	movq	%r12, %rdi
	movl	$0x41000000, 18144(%rsp)
	movl	$0x41100000, 18180(%rsp)
	movl	$0x41200000, 18216(%rsp)
	movl	$0x41300000, 18252(%rsp)
	movl	$0x41400000, 18288(%rsp)
	movl	$0x41500000, 18324(%rsp)
	movl	$0x41600000, 18360(%rsp)
	movl	$0x41700000, 18396(%rsp)
.LEHB285:
	call	_ZN11denseMatrixC1EiPf
.LEHE285:
	leaq	1488(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1504(%rsp)
	movq	%rax, %rdi
	movq	%rax, 704(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1488(%rsp)
.LEHB286:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	5776(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	18400(%rsp), %rdi
	leaq	18400(%rsp), %rdx
	movq	%rbp, 1160(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 18528(%rsp)
	movl	$0x40000000, 18564(%rsp)
	movl	$0x40400000, 18600(%rsp)
	movl	$0x40800000, 18636(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE286:
	leaq	5856(%rsp), %r12
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	18656(%rsp), %rdi
	leaq	18656(%rsp), %rdx
	movq	%r12, 1176(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x40a00000, 18664(%rsp)
	movl	$0x40c00000, 18700(%rsp)
	movl	$0x40e00000, 18736(%rsp)
	movl	$0x41000000, 18772(%rsp)
	movl	$0x41100000, 18808(%rsp)
	movl	$0x41200000, 18844(%rsp)
.LEHB287:
	call	_ZN11denseMatrixC1EiPf
.LEHE287:
	leaq	1520(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1536(%rsp)
	movq	%rax, %rdi
	movq	%rax, 712(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1520(%rsp)
.LEHB288:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	5936(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	18912(%rsp), %rdi
	leaq	18912(%rsp), %r12
	movq	%rbp, 1192(%rsp)
	rep stosq
	movq	%r12, %rdx
	movq	%rbp, %rdi
	movl	$0x3f800000, 18920(%rsp)
	movl	$0x40000000, 18956(%rsp)
	movl	$0x40400000, 18992(%rsp)
	movl	$0x40800000, 19028(%rsp)
	movl	$0x40a00000, 19064(%rsp)
	movl	$0x40c00000, 19100(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE288:
	xorl	%eax, %eax
	movl	$32, %ecx
	movq	%r12, %rdx
	movl	$8, %esi
	leaq	19168(%rsp), %rdi
	rep stosq
	leaq	6016(%rsp), %rax
	movl	$0x40e00000, 19296(%rsp)
	movq	%rax, %rdi
	movq	%rax, %r12
	movl	$0x41000000, 19332(%rsp)
	movl	$0x41100000, 19368(%rsp)
	movl	$0x41200000, 19404(%rsp)
	movq	%rax, 416(%rsp)
.LEHB289:
	call	_ZN11denseMatrixC1EiPf
.LEHE289:
	leaq	1552(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1568(%rsp)
	movq	%rax, %rdi
	movq	%rax, 736(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1552(%rsp)
.LEHB290:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	19424(%rsp), %rdi
	movl	$31, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	rep stosq
	leaq	6096(%rsp), %rbp
	leaq	19424(%rsp), %rdx
	movq	%rbp, 432(%rsp)
	movl	$0, (%rdi)
	movq	%rbp, %rdi
	movl	$0x3f800000, 19424(%rsp)
	movl	$0x40000000, 19460(%rsp)
	movl	$0x40400000, 19496(%rsp)
	movl	$0x40800000, 19532(%rsp)
	movl	$0x40a00000, 19568(%rsp)
	movl	$0x40c00000, 19604(%rsp)
	movl	$0x40e00000, 19640(%rsp)
	movl	$0x41000000, 19676(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE290:
	leaq	6176(%rsp), %r12
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	19680(%rsp), %rdi
	leaq	19680(%rsp), %rdx
	movq	%r12, 448(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x41100000, 19808(%rsp)
	movl	$0x41200000, 19844(%rsp)
	movl	$0x41300000, 19880(%rsp)
	movl	$0x41400000, 19916(%rsp)
.LEHB291:
	call	_ZN11denseMatrixC1EiPf
.LEHE291:
	leaq	1584(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1600(%rsp)
	movq	%rax, %rdi
	movq	%rax, 744(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1584(%rsp)
.LEHB292:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	6256(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	19936(%rsp), %rdi
	leaq	19936(%rsp), %rdx
	movq	%rbp, 472(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 19936(%rsp)
	movl	$0x3f800000, 19980(%rsp)
	movl	$0x3f800000, 20008(%rsp)
	movl	$0x3f800000, 20036(%rsp)
	movl	$0x3f800000, 20080(%rsp)
	movl	$0x3f800000, 20124(%rsp)
	movl	$0x3f800000, 20152(%rsp)
	movl	$0x3f800000, 20180(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE292:
	leaq	6336(%rsp), %r12
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	20192(%rsp), %rdi
	leaq	20192(%rsp), %rdx
	movq	%r12, 488(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x3f800000, 20192(%rsp)
	movl	$0x3f800000, 20236(%rsp)
	movl	$0x3f800000, 20264(%rsp)
	movl	$0x3f800000, 20292(%rsp)
	movl	$0x3f800000, 20336(%rsp)
	movl	$0x3f800000, 20380(%rsp)
	movl	$0x3f800000, 20408(%rsp)
	movl	$0x3f800000, 20436(%rsp)
.LEHB293:
	call	_ZN11denseMatrixC1EiPf
.LEHE293:
	leaq	1616(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1632(%rsp)
	movq	%rax, %rdi
	movq	%rax, 752(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1616(%rsp)
.LEHB294:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	6416(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	20448(%rsp), %rdi
	leaq	20448(%rsp), %rdx
	movq	%rbp, 512(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 20456(%rsp)
	movl	$0x40000000, 20492(%rsp)
	movl	$0x40400000, 20528(%rsp)
	movl	$0x40800000, 20564(%rsp)
	movl	$0x40a00000, 20600(%rsp)
	movl	$0x40c00000, 20636(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE294:
	leaq	6496(%rsp), %r12
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	20704(%rsp), %rdi
	leaq	20704(%rsp), %rdx
	movq	%r12, 528(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x40e00000, 20768(%rsp)
	movl	$0x41000000, 20804(%rsp)
	movl	$0x41100000, 20840(%rsp)
	movl	$0x41200000, 20876(%rsp)
	movl	$0x41300000, 20912(%rsp)
	movl	$0x41400000, 20948(%rsp)
.LEHB295:
	call	_ZN11denseMatrixC1EiPf
.LEHE295:
	leaq	1648(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1664(%rsp)
	movq	%rax, %rdi
	movq	%rax, 776(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1648(%rsp)
.LEHB296:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	6576(%rsp), %rbp
	movl	$128, %ecx
	xorl	%eax, %eax
	movl	$16, %esi
	leaq	29152(%rsp), %rdi
	leaq	29152(%rsp), %rdx
	movq	%rbp, 536(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 29152(%rsp)
	movl	$0x3f800000, 29220(%rsp)
	movl	$0x3f800000, 29304(%rsp)
	movl	$0x3f800000, 29372(%rsp)
	movl	$0x3f800000, 29424(%rsp)
	movl	$0x3f800000, 29492(%rsp)
	movl	$0x3f800000, 29544(%rsp)
	movl	$0x3f800000, 29612(%rsp)
	movl	$0x3f800000, 29696(%rsp)
	movl	$0x3f800000, 29764(%rsp)
	movl	$0x3f800000, 29848(%rsp)
	movl	$0x3f800000, 29916(%rsp)
	movl	$0x3f800000, 29968(%rsp)
	movl	$0x3f800000, 30036(%rsp)
	movl	$0x3f800000, 30088(%rsp)
	movl	$0x3f800000, 30156(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE296:
	leaq	6656(%rsp), %r12
	movl	$128, %ecx
	xorl	%eax, %eax
	movl	$16, %esi
	leaq	30176(%rsp), %rdi
	leaq	30176(%rsp), %rdx
	movq	%r12, 552(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x3f800000, 30176(%rsp)
	movl	$0x3f800000, 30252(%rsp)
	movl	$0x3f800000, 30312(%rsp)
	movl	$0x3f800000, 30372(%rsp)
	movl	$0x3f800000, 30448(%rsp)
	movl	$0x3f800000, 30524(%rsp)
	movl	$0x3f800000, 30584(%rsp)
	movl	$0x3f800000, 30644(%rsp)
	movl	$0x3f800000, 30720(%rsp)
	movl	$0x3f800000, 30796(%rsp)
	movl	$0x3f800000, 30856(%rsp)
	movl	$0x3f800000, 30916(%rsp)
	movl	$0x3f800000, 30992(%rsp)
	movl	$0x3f800000, 31068(%rsp)
	movl	$0x3f800000, 31128(%rsp)
	movl	$0x3f800000, 31188(%rsp)
.LEHB297:
	call	_ZN11denseMatrixC1EiPf
.LEHE297:
	leaq	1680(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1696(%rsp)
	movq	%rax, %rdi
	movq	%rax, 784(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1680(%rsp)
.LEHB298:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	6736(%rsp), %rbp
	movl	$128, %ecx
	xorl	%eax, %eax
	movl	$16, %esi
	leaq	31200(%rsp), %rdi
	leaq	31200(%rsp), %rdx
	movq	%rbp, 568(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 31200(%rsp)
	movl	$0x40000000, 31268(%rsp)
	movl	$0x40400000, 31336(%rsp)
	movl	$0x40800000, 31404(%rsp)
	movl	$0x40a00000, 31472(%rsp)
	movl	$0x40c00000, 31540(%rsp)
	movl	$0x40e00000, 31608(%rsp)
	movl	$0x41000000, 31676(%rsp)
	movl	$0x41100000, 31744(%rsp)
	movl	$0x41200000, 31812(%rsp)
	movl	$0x41300000, 31880(%rsp)
	movl	$0x41400000, 31948(%rsp)
	movl	$0x41500000, 32016(%rsp)
	movl	$0x41600000, 32084(%rsp)
	movl	$0x41700000, 32152(%rsp)
	movl	$0x41800000, 32220(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE298:
	leaq	6816(%rsp), %r12
	movl	$128, %ecx
	xorl	%eax, %eax
	movl	$16, %esi
	leaq	32224(%rsp), %rdi
	leaq	32224(%rsp), %rdx
	movq	%r12, 584(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x41880000, 32232(%rsp)
	movl	$0x41900000, 32300(%rsp)
	movl	$0x41980000, 32368(%rsp)
	movl	$0x41a00000, 32436(%rsp)
	movl	$0x41a80000, 32504(%rsp)
	movl	$0x41b00000, 32572(%rsp)
	movl	$0x41b80000, 32640(%rsp)
	movl	$0x41c00000, 32708(%rsp)
	movl	$0x41c80000, 32776(%rsp)
	movl	$0x41d00000, 32844(%rsp)
	movl	$0x41d80000, 32912(%rsp)
	movl	$0x41e00000, 32980(%rsp)
	movl	$0x41e80000, 33048(%rsp)
	movl	$0x41f00000, 33116(%rsp)
.LEHB299:
	call	_ZN11denseMatrixC1EiPf
.LEHE299:
	leaq	1712(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1728(%rsp)
	movq	%rax, %rdi
	movq	%rax, 808(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1712(%rsp)
.LEHB300:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	6896(%rsp), %rbp
	movl	$128, %ecx
	xorl	%eax, %eax
	movl	$16, %esi
	leaq	33248(%rsp), %rdi
	leaq	33248(%rsp), %rdx
	movq	%rbp, 624(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 33264(%rsp)
	movl	$0x40000000, 33332(%rsp)
	movl	$0x40400000, 33400(%rsp)
	movl	$0x40800000, 33468(%rsp)
	movl	$0x40a00000, 33536(%rsp)
	movl	$0x40c00000, 33604(%rsp)
	movl	$0x40e00000, 33672(%rsp)
	movl	$0x41000000, 33740(%rsp)
	movl	$0x41100000, 33808(%rsp)
	movl	$0x41200000, 33876(%rsp)
	movl	$0x41300000, 33944(%rsp)
	movl	$0x41400000, 34012(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE300:
	leaq	6976(%rsp), %r12
	movl	$128, %ecx
	xorl	%eax, %eax
	movl	$16, %esi
	leaq	34272(%rsp), %rdi
	leaq	34272(%rsp), %rdx
	movq	%r12, 656(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x41500000, 34400(%rsp)
	movl	$0x41600000, 34468(%rsp)
	movl	$0x41700000, 34536(%rsp)
	movl	$0x41800000, 34604(%rsp)
	movl	$0x41880000, 34672(%rsp)
	movl	$0x41900000, 34740(%rsp)
	movl	$0x41980000, 34808(%rsp)
	movl	$0x41a00000, 34876(%rsp)
	movl	$0x41a80000, 34944(%rsp)
	movl	$0x41b00000, 35012(%rsp)
	movl	$0x41b80000, 35080(%rsp)
	movl	$0x41c00000, 35148(%rsp)
	movl	$0x41c80000, 35216(%rsp)
	movl	$0x41d00000, 35284(%rsp)
.LEHB301:
	call	_ZN11denseMatrixC1EiPf
.LEHE301:
	leaq	1744(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1760(%rsp)
	movq	%rax, %rdi
	movq	%rax, 816(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1744(%rsp)
.LEHB302:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	7056(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	20960(%rsp), %rdi
	leaq	20960(%rsp), %rdx
	movq	%rbp, 688(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 20960(%rsp)
	movl	$0x3f800000, 20996(%rsp)
	movl	$0x3f800000, 21032(%rsp)
	movl	$0x3f800000, 21068(%rsp)
	movl	$0x3f800000, 21108(%rsp)
	movl	$0x3f800000, 21136(%rsp)
	movl	$0x3f800000, 21180(%rsp)
	movl	$0x3f800000, 21208(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE302:
	movaps	.LC86(%rip), %xmm4
	movaps	.LC87(%rip), %xmm3
	leaq	7136(%rsp), %r12
	pxor	%xmm0, %xmm0
	movaps	.LC88(%rip), %xmm2
	movaps	.LC89(%rip), %xmm1
	movl	$8, %esi
	movq	%r12, %rdi
	leaq	21216(%rsp), %rdx
	movq	%r12, 728(%rsp)
	movaps	%xmm4, 21216(%rsp)
	movaps	%xmm0, 21232(%rsp)
	movaps	%xmm0, 21248(%rsp)
	movaps	%xmm3, 21264(%rsp)
	movaps	%xmm2, 21280(%rsp)
	movaps	%xmm0, 21296(%rsp)
	movaps	%xmm0, 21312(%rsp)
	movaps	%xmm1, 21328(%rsp)
	movaps	%xmm0, 21344(%rsp)
	movaps	%xmm4, 21360(%rsp)
	movaps	%xmm3, 21376(%rsp)
	movaps	%xmm0, 21392(%rsp)
	movaps	%xmm0, 21408(%rsp)
	movaps	%xmm2, 21424(%rsp)
	movaps	%xmm1, 21440(%rsp)
	movaps	%xmm0, 21456(%rsp)
.LEHB303:
	call	_ZN11denseMatrixC1EiPf
.LEHE303:
	leaq	1776(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1792(%rsp)
	movq	%rax, %rdi
	movq	%rax, 824(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1776(%rsp)
.LEHB304:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	7216(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	21472(%rsp), %rdi
	leaq	21472(%rsp), %rdx
	movq	%rbp, 768(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 21504(%rsp)
	movl	$0x40000000, 21540(%rsp)
	movl	$0x40400000, 21576(%rsp)
	movl	$0x40800000, 21612(%rsp)
	movl	$0x40a00000, 21648(%rsp)
	movl	$0x40c00000, 21684(%rsp)
	movl	$0x40e00000, 21720(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE304:
	leaq	7296(%rsp), %r12
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	21728(%rsp), %rdi
	leaq	21728(%rsp), %rdx
	movq	%r12, 800(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x41000000, 21752(%rsp)
	movl	$0x41100000, 21788(%rsp)
.LEHB305:
	call	_ZN11denseMatrixC1EiPf
.LEHE305:
	leaq	1808(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1824(%rsp)
	movq	%rax, %rdi
	movq	%rax, 848(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1808(%rsp)
.LEHB306:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	7376(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	21984(%rsp), %rdi
	leaq	21984(%rsp), %rdx
	movq	%rbp, 840(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 22000(%rsp)
	movl	$0x40000000, 22036(%rsp)
	movl	$0x40400000, 22072(%rsp)
	movl	$0x40800000, 22108(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE306:
	leaq	7456(%rsp), %r12
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	22240(%rsp), %rdi
	leaq	22240(%rsp), %rdx
	movq	%r12, 872(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x40a00000, 22368(%rsp)
	movl	$0x40c00000, 22404(%rsp)
	movl	$0x40e00000, 22440(%rsp)
	movl	$0x41000000, 22476(%rsp)
.LEHB307:
	call	_ZN11denseMatrixC1EiPf
.LEHE307:
	leaq	1840(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1856(%rsp)
	movq	%rax, %rdi
	movq	%rax, 856(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1840(%rsp)
.LEHB308:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	7536(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	22496(%rsp), %rdi
	leaq	22496(%rsp), %rdx
	movq	%rbp, 912(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 22720(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE308:
	leaq	22752(%rsp), %rdi
	movl	$31, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	rep stosq
	leaq	7616(%rsp), %r12
	leaq	22752(%rsp), %rdx
	movq	%r12, 944(%rsp)
	movl	$0, (%rdi)
	movq	%r12, %rdi
	movl	$0x41100000, 22752(%rsp)
	movl	$0x41200000, 22788(%rsp)
	movl	$0x41300000, 22824(%rsp)
	movl	$0x41400000, 22860(%rsp)
	movl	$0x41500000, 22896(%rsp)
	movl	$0x41600000, 22932(%rsp)
	movl	$0x41700000, 22968(%rsp)
	movl	$0x41800000, 23004(%rsp)
.LEHB309:
	call	_ZN11denseMatrixC1EiPf
.LEHE309:
	leaq	1872(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1888(%rsp)
	movq	%rax, %rdi
	movq	%rax, 880(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1872(%rsp)
.LEHB310:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	7696(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	23008(%rsp), %rdi
	leaq	23008(%rsp), %rdx
	movq	%rbp, 968(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 23136(%rsp)
	movl	$0x40000000, 23172(%rsp)
	movl	$0x40400000, 23208(%rsp)
	movl	$0x40800000, 23244(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE310:
	leaq	7776(%rsp), %r12
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	23264(%rsp), %rdi
	leaq	23264(%rsp), %rdx
	movq	%r12, 992(%rsp)
	rep stosq
	movq	%r12, %rdi
	movl	$0x40a00000, 23280(%rsp)
	movl	$0x40c00000, 23316(%rsp)
	movl	$0x40e00000, 23352(%rsp)
	movl	$0x41000000, 23388(%rsp)
.LEHB311:
	call	_ZN11denseMatrixC1EiPf
.LEHE311:
	leaq	1904(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1920(%rsp)
	movq	%rax, %rdi
	movq	%rax, 888(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1904(%rsp)
.LEHB312:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	7856(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	23520(%rsp), %rdi
	leaq	23520(%rsp), %rdx
	movq	%rbp, 1016(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 23520(%rsp)
	movl	$0x40000000, 23556(%rsp)
	movl	$0x40400000, 23592(%rsp)
	movl	$0x40800000, 23628(%rsp)
	movl	$0x40a00000, 23668(%rsp)
	movl	$0x40c00000, 23696(%rsp)
	movl	$0x40e00000, 23740(%rsp)
	movl	$0x41000000, 23768(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE312:
	movaps	.LC90(%rip), %xmm4
	movaps	.LC92(%rip), %xmm6
	leaq	7936(%rsp), %r12
	pxor	%xmm0, %xmm0
	movaps	.LC93(%rip), %xmm7
	movaps	.LC94(%rip), %xmm5
	movl	$8, %esi
	movq	%r12, %rdi
	movaps	%xmm4, 23776(%rsp)
	movaps	.LC91(%rip), %xmm4
	leaq	23776(%rsp), %rdx
	movaps	%xmm6, 23840(%rsp)
	movaps	.LC96(%rip), %xmm6
	movaps	%xmm4, 23824(%rsp)
	movaps	.LC95(%rip), %xmm4
	movaps	%xmm7, 23888(%rsp)
	movaps	.LC97(%rip), %xmm7
	movq	%r12, 1032(%rsp)
	movaps	%xmm0, 23792(%rsp)
	movaps	%xmm0, 23808(%rsp)
	movaps	%xmm0, 23856(%rsp)
	movaps	%xmm0, 23872(%rsp)
	movaps	%xmm0, 23904(%rsp)
	movaps	%xmm5, 23920(%rsp)
	movaps	%xmm4, 23936(%rsp)
	movaps	%xmm0, 23952(%rsp)
	movaps	%xmm0, 23968(%rsp)
	movaps	%xmm6, 23984(%rsp)
	movaps	%xmm7, 24000(%rsp)
	movaps	%xmm0, 24016(%rsp)
.LEHB313:
	call	_ZN11denseMatrixC1EiPf
.LEHE313:
	leaq	1936(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1952(%rsp)
	movq	%rax, %rdi
	movq	%rax, 896(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1936(%rsp)
.LEHB314:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	8016(%rsp), %rbp
	movl	$32, %ecx
	xorl	%eax, %eax
	movl	$8, %esi
	leaq	24032(%rsp), %rdi
	leaq	24032(%rsp), %rdx
	movq	%rbp, 1056(%rsp)
	rep stosq
	movq	%rbp, %rdi
	movl	$0x3f800000, 24032(%rsp)
	movl	$0x40000000, 24068(%rsp)
	movl	$0x40400000, 24120(%rsp)
	movl	$0x40800000, 24156(%rsp)
	movl	$0x40a00000, 24176(%rsp)
	movl	$0x40c00000, 24212(%rsp)
	movl	$0x40e00000, 24232(%rsp)
	movl	$0x41000000, 24268(%rsp)
	call	_ZN11denseMatrixC1EiPf
.LEHE314:
	movaps	.LC90(%rip), %xmm5
	leaq	8096(%rsp), %r12
	movaps	.LC91(%rip), %xmm1
	pxor	%xmm0, %xmm0
	movaps	.LC92(%rip), %xmm2
	movaps	.LC93(%rip), %xmm3
	leaq	24288(%rsp), %rdx
	movl	$8, %esi
	movaps	.LC94(%rip), %xmm4
	movaps	.LC95(%rip), %xmm6
	movq	%r12, %rdi
	movaps	%xmm5, 24288(%rsp)
	movaps	.LC96(%rip), %xmm7
	movaps	.LC97(%rip), %xmm5
	movq	%r12, 1080(%rsp)
	movaps	%xmm0, 24304(%rsp)
	movaps	%xmm0, 24320(%rsp)
	movaps	%xmm1, 24336(%rsp)
	movaps	%xmm0, 24352(%rsp)
	movaps	%xmm2, 24368(%rsp)
	movaps	%xmm3, 24384(%rsp)
	movaps	%xmm0, 24400(%rsp)
	movaps	%xmm0, 24416(%rsp)
	movaps	%xmm4, 24432(%rsp)
	movaps	%xmm6, 24448(%rsp)
	movaps	%xmm0, 24464(%rsp)
	movaps	%xmm7, 24480(%rsp)
	movaps	%xmm0, 24496(%rsp)
	movaps	%xmm0, 24512(%rsp)
	movaps	%xmm5, 24528(%rsp)
.LEHB315:
	call	_ZN11denseMatrixC1EiPf
.LEHE315:
	leaq	1968(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1984(%rsp)
	movq	%rax, %rdi
	movq	%rax, 928(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1968(%rsp)
.LEHB316:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	28896(%rsp), %rbp
	leaq	2000(%rsp), %r12
	movl	$2, %edx
	movabsq	$25769803779, %r14
	movq	%rbp, %rsi
	movq	%r12, %rdi
	movq	%r14, 28896(%rsp)
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE316:
	movabsq	$4724276010211082240, %rax
	movaps	.LC98(%rip), %xmm1
	movaps	.LC99(%rip), %xmm2
	leaq	13056(%rsp), %rdx
	movq	%rax, 13120(%rsp)
	movaps	.LC100(%rip), %xmm3
	leaq	8176(%rsp), %rax
	movq	%r12, %rsi
	movaps	.LC101(%rip), %xmm0
	movq	%rax, %rdi
	movq	%rax, 48(%rsp)
	movaps	%xmm1, 13056(%rsp)
	movaps	%xmm2, 13072(%rsp)
	movaps	%xmm3, 13088(%rsp)
	movaps	%xmm0, 13104(%rsp)
.LEHB317:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE317:
	leaq	2032(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$8589934598, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB318:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE318:
	leaq	8256(%rsp), %r9
	movaps	.LC98(%rip), %xmm4
	movaps	.LC99(%rip), %xmm6
	leaq	12848(%rsp), %rdx
	movaps	.LC100(%rip), %xmm7
	movq	%r12, %rsi
	movq	%r9, %rdi
	movq	%r9, 280(%rsp)
	movaps	%xmm4, 12848(%rsp)
	movaps	%xmm6, 12864(%rsp)
	movaps	%xmm7, 12880(%rsp)
.LEHB319:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE319:
	leaq	2064(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	48(%rsp), %rsi
	movq	$0, 2080(%rsp)
	movq	%rax, %rdi
	movq	%rax, 952(%rsp)
	movq	%rax, %r12
	movaps	%xmm0, 2064(%rsp)
.LEHB320:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	280(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	2096(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE320:
	movaps	.LC102(%rip), %xmm0
	leaq	8336(%rsp), %rsi
	movabsq	$4726527810025291776, %rdx
	movaps	.LC98(%rip), %xmm5
	movq	%rsi, %rdi
	movq	%rdx, 13200(%rsp)
	movq	%r12, %rsi
	leaq	13136(%rsp), %rdx
	movaps	%xmm0, 13152(%rsp)
	movaps	.LC103(%rip), %xmm0
	movq	%rdi, 296(%rsp)
	movaps	%xmm0, 13168(%rsp)
	movaps	.LC104(%rip), %xmm0
	movaps	%xmm5, 13136(%rsp)
	movaps	%xmm0, 13184(%rsp)
.LEHB321:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE321:
	leaq	2128(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB322:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE322:
	movaps	.LC105(%rip), %xmm0
	leaq	8416(%rsp), %r10
	leaq	14176(%rsp), %rdx
	movq	%r12, %rsi
	movq	%r10, %rdi
	movq	%r10, 312(%rsp)
	movaps	%xmm0, 14176(%rsp)
	movaps	.LC106(%rip), %xmm0
	movaps	%xmm0, 14192(%rsp)
	movaps	.LC107(%rip), %xmm0
	movaps	%xmm0, 14208(%rsp)
	movaps	.LC108(%rip), %xmm0
	movaps	%xmm0, 14224(%rsp)
	movaps	.LC109(%rip), %xmm0
	movaps	%xmm0, 14240(%rsp)
	movaps	.LC110(%rip), %xmm0
	movaps	%xmm0, 14256(%rsp)
.LEHB323:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE323:
	leaq	2160(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	296(%rsp), %rsi
	movq	$0, 2176(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 976(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2160(%rsp)
.LEHB324:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	312(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	2192(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE324:
	leaq	8496(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	13216(%rsp), %rdx
	movl	$0, 13280(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 13216(%rsp)
	movaps	%xmm0, 13248(%rsp)
	movl	$0x3f800000, 13228(%rsp)
	movl	$0x40000000, 13256(%rsp)
	movl	$0x40400000, 13284(%rsp)
	movq	%rdi, 328(%rsp)
	movaps	%xmm0, 13232(%rsp)
	movaps	%xmm0, 13264(%rsp)
.LEHB325:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE325:
	leaq	2224(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB326:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE326:
	leaq	8576(%rsp), %r11
	leaq	14272(%rsp), %rdi
	xorl	%eax, %eax
	movq	%r12, %rsi
	movl	$12, %ecx
	leaq	14272(%rsp), %rdx
	movq	%r11, 344(%rsp)
	rep stosq
	movq	%r11, %rdi
	movl	$0x40800000, 14276(%rsp)
	movl	$0x40a00000, 14296(%rsp)
	movl	$0x40c00000, 14316(%rsp)
.LEHB327:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE327:
	leaq	2256(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	328(%rsp), %rsi
	movq	$0, 2272(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1000(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2256(%rsp)
.LEHB328:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	344(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	2288(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE328:
	leaq	8656(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	13296(%rsp), %rdx
	movl	$0, 13360(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 13296(%rsp)
	movaps	%xmm0, 13328(%rsp)
	movl	$0x3f800000, 13308(%rsp)
	movl	$0x40000000, 13336(%rsp)
	movl	$0x40400000, 13364(%rsp)
	movq	%rdi, 360(%rsp)
	movaps	%xmm0, 13312(%rsp)
	movaps	%xmm0, 13344(%rsp)
.LEHB329:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE329:
	leaq	2320(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB330:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE330:
	leaq	14368(%rsp), %rdi
	movl	$11, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	8736(%rsp), %r8
	leaq	14368(%rsp), %rdx
	movq	%r8, 376(%rsp)
	movl	$0, (%rdi)
	movq	%r8, %rdi
	movl	$0x40800000, 14400(%rsp)
	movl	$0x40a00000, 14420(%rsp)
	movl	$0x40c00000, 14440(%rsp)
	movl	$0x40e00000, 14460(%rsp)
.LEHB331:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE331:
	leaq	2352(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	360(%rsp), %rsi
	movq	$0, 2368(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1040(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2352(%rsp)
.LEHB332:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	376(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	2384(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE332:
	leaq	8816(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	13376(%rsp), %rdx
	movl	$0, 13440(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 13376(%rsp)
	movaps	%xmm0, 13408(%rsp)
	movl	$0x3f800000, 13388(%rsp)
	movl	$0x40000000, 13416(%rsp)
	movl	$0x40400000, 13444(%rsp)
	movq	%rdi, 56(%rsp)
	movaps	%xmm0, 13392(%rsp)
	movaps	%xmm0, 13424(%rsp)
.LEHB333:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE333:
	leaq	2416(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB334:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE334:
	leaq	8896(%rsp), %r9
	leaq	14464(%rsp), %rdi
	xorl	%eax, %eax
	movq	%r12, %rsi
	movl	$12, %ecx
	leaq	14464(%rsp), %rdx
	movq	%r9, 64(%rsp)
	rep stosq
	movq	%r9, %rdi
	movl	$0x40800000, 14464(%rsp)
	movl	$0x40a00000, 14484(%rsp)
	movl	$0x40c00000, 14504(%rsp)
	movl	$0x40e00000, 14524(%rsp)
.LEHB335:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE335:
	leaq	2448(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	56(%rsp), %rsi
	movq	$0, 2464(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1064(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2448(%rsp)
.LEHB336:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	64(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	2480(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE336:
	leaq	8976(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	13456(%rsp), %rdx
	movq	$0, 13520(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 13472(%rsp)
	movaps	%xmm0, 13504(%rsp)
	movl	$0x3f800000, 13480(%rsp)
	movl	$0x40000000, 13508(%rsp)
	movq	%rdi, 80(%rsp)
	movaps	%xmm0, 13456(%rsp)
	movaps	%xmm0, 13488(%rsp)
.LEHB337:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE337:
	leaq	2512(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB338:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE338:
	leaq	9056(%rsp), %r10
	leaq	14560(%rsp), %rdi
	xorl	%eax, %eax
	movq	%r12, %rsi
	movl	$12, %ecx
	leaq	14560(%rsp), %rdx
	movq	%r10, 88(%rsp)
	rep stosq
	movq	%r10, %rdi
	movl	$0x40800000, 14564(%rsp)
	movl	$0x40a00000, 14584(%rsp)
	movl	$0x40c00000, 14604(%rsp)
.LEHB339:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE339:
	leaq	2544(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	80(%rsp), %rsi
	movq	$0, 2560(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1088(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2544(%rsp)
.LEHB340:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	88(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	2576(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE340:
	leaq	9136(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	13536(%rsp), %rdx
	movq	$0, 13600(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 13552(%rsp)
	movaps	%xmm0, 13584(%rsp)
	movl	$0x3f800000, 13560(%rsp)
	movl	$0x40000000, 13588(%rsp)
	movq	%rdi, 96(%rsp)
	movaps	%xmm0, 13536(%rsp)
	movaps	%xmm0, 13568(%rsp)
.LEHB341:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE341:
	leaq	2608(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB342:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE342:
	leaq	14656(%rsp), %rdi
	movl	$11, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	9216(%rsp), %r11
	leaq	14656(%rsp), %rdx
	movq	%r11, 104(%rsp)
	movl	$0, (%rdi)
	movq	%r11, %rdi
	movl	$0x40800000, 14688(%rsp)
	movl	$0x40a00000, 14708(%rsp)
	movl	$0x40c00000, 14728(%rsp)
	movl	$0x40e00000, 14748(%rsp)
.LEHB343:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE343:
	leaq	2640(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	96(%rsp), %rsi
	movq	$0, 2656(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1104(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2640(%rsp)
.LEHB344:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	104(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	2672(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE344:
	leaq	9296(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	13616(%rsp), %rdx
	movq	$0, 13680(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 13632(%rsp)
	movaps	%xmm0, 13664(%rsp)
	movl	$0x3f800000, 13640(%rsp)
	movl	$0x40000000, 13668(%rsp)
	movq	%rdi, 112(%rsp)
	movaps	%xmm0, 13616(%rsp)
	movaps	%xmm0, 13648(%rsp)
.LEHB345:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE345:
	leaq	2704(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB346:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE346:
	leaq	9376(%rsp), %r8
	leaq	14752(%rsp), %rdi
	xorl	%eax, %eax
	movq	%r12, %rsi
	movl	$12, %ecx
	leaq	14752(%rsp), %rdx
	movq	%r8, 120(%rsp)
	rep stosq
	movq	%r8, %rdi
	movl	$0x40800000, 14752(%rsp)
	movl	$0x40a00000, 14772(%rsp)
	movl	$0x40c00000, 14792(%rsp)
	movl	$0x40e00000, 14812(%rsp)
.LEHB347:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE347:
	leaq	2736(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	112(%rsp), %rsi
	movq	$0, 2752(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1120(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2736(%rsp)
.LEHB348:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	120(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	2768(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE348:
	leaq	9456(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	13696(%rsp), %rdx
	movq	$0, 13760(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 13696(%rsp)
	movaps	%xmm0, 13712(%rsp)
	movaps	%xmm0, 13744(%rsp)
	movl	$0x3f800000, 13696(%rsp)
	movl	$0x40000000, 13724(%rsp)
	movl	$0x40400000, 13752(%rsp)
	movq	%rdi, 128(%rsp)
	movaps	%xmm0, 13728(%rsp)
.LEHB349:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE349:
	leaq	2800(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB350:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE350:
	leaq	9536(%rsp), %r9
	leaq	14848(%rsp), %rdi
	xorl	%eax, %eax
	movq	%r12, %rsi
	movl	$12, %ecx
	leaq	14848(%rsp), %rdx
	movq	%r9, 136(%rsp)
	rep stosq
	movq	%r9, %rdi
	movl	$0x40800000, 14852(%rsp)
	movl	$0x40a00000, 14872(%rsp)
	movl	$0x40c00000, 14892(%rsp)
.LEHB351:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE351:
	leaq	2832(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	128(%rsp), %rsi
	movq	$0, 2848(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1144(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2832(%rsp)
.LEHB352:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	136(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	2864(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE352:
	leaq	9616(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	13776(%rsp), %rdx
	movq	$0, 13840(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 13776(%rsp)
	movaps	%xmm0, 13792(%rsp)
	movaps	%xmm0, 13824(%rsp)
	movl	$0x3f800000, 13776(%rsp)
	movl	$0x40000000, 13804(%rsp)
	movl	$0x40400000, 13832(%rsp)
	movq	%rdi, 144(%rsp)
	movaps	%xmm0, 13808(%rsp)
.LEHB353:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE353:
	leaq	2896(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB354:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE354:
	leaq	14944(%rsp), %rdi
	movl	$11, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	9696(%rsp), %r10
	leaq	14944(%rsp), %rdx
	movq	%r10, 152(%rsp)
	movl	$0, (%rdi)
	movq	%r10, %rdi
	movl	$0x40800000, 14976(%rsp)
	movl	$0x40a00000, 14996(%rsp)
	movl	$0x40c00000, 15016(%rsp)
	movl	$0x40e00000, 15036(%rsp)
.LEHB355:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE355:
	leaq	2928(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	144(%rsp), %rsi
	movq	$0, 2944(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1152(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2928(%rsp)
.LEHB356:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	152(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	2960(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE356:
	leaq	9776(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	13856(%rsp), %rdx
	movq	$0, 13920(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 13856(%rsp)
	movaps	%xmm0, 13872(%rsp)
	movaps	%xmm0, 13904(%rsp)
	movl	$0x3f800000, 13856(%rsp)
	movl	$0x40000000, 13884(%rsp)
	movl	$0x40400000, 13912(%rsp)
	movq	%rdi, 160(%rsp)
	movaps	%xmm0, 13888(%rsp)
.LEHB357:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE357:
	leaq	2992(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB358:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE358:
	leaq	9856(%rsp), %r11
	leaq	15040(%rsp), %rdi
	xorl	%eax, %eax
	movq	%r12, %rsi
	movl	$12, %ecx
	leaq	15040(%rsp), %rdx
	movq	%r11, 168(%rsp)
	rep stosq
	movq	%r11, %rdi
	movl	$0x40800000, 15040(%rsp)
	movl	$0x40a00000, 15060(%rsp)
	movl	$0x40c00000, 15080(%rsp)
	movl	$0x40e00000, 15100(%rsp)
.LEHB359:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE359:
	leaq	3024(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	160(%rsp), %rsi
	movq	$0, 3040(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1168(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3024(%rsp)
.LEHB360:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	168(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	3056(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE360:
	leaq	9936(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	13936(%rsp), %rdx
	movq	$0, 14000(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 13952(%rsp)
	movaps	%xmm0, 13968(%rsp)
	movl	$0x40a00000, 13952(%rsp)
	movl	$0x40c00000, 13980(%rsp)
	movq	%rdi, 176(%rsp)
	movaps	%xmm0, 13936(%rsp)
	movaps	%xmm0, 13984(%rsp)
.LEHB361:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE361:
	leaq	3088(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$8589934598, %rcx
	movq	%r12, %rdi
	movq	%rcx, 28896(%rsp)
.LEHB362:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE362:
	leaq	10016(%rsp), %r8
	pxor	%xmm0, %xmm0
	leaq	12896(%rsp), %rdx
	movq	%r12, %rsi
	movq	%r8, %rdi
	movaps	%xmm0, 12928(%rsp)
	movq	%r8, 184(%rsp)
	movl	$0x40800000, 12936(%rsp)
	movaps	%xmm0, 12896(%rsp)
	movaps	%xmm0, 12912(%rsp)
.LEHB363:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE363:
	leaq	3120(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	176(%rsp), %rsi
	movq	$0, 3136(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1184(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3120(%rsp)
.LEHB364:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	184(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	3152(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE364:
	leaq	10096(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	14016(%rsp), %rdx
	movq	$0, 14080(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 14064(%rsp)
	movq	%rdi, 192(%rsp)
	movl	$0x40a00000, 14064(%rsp)
	movaps	%xmm0, 14016(%rsp)
	movaps	%xmm0, 14032(%rsp)
	movaps	%xmm0, 14048(%rsp)
.LEHB365:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE365:
	leaq	3184(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB366:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE366:
	leaq	10176(%rsp), %r9
	leaq	15136(%rsp), %rdi
	xorl	%eax, %eax
	movq	%r12, %rsi
	movl	$12, %ecx
	leaq	15136(%rsp), %rdx
	movq	%r9, 200(%rsp)
	rep stosq
	movq	%r9, %rdi
	movl	$0x41200000, 15148(%rsp)
.LEHB367:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE367:
	leaq	3216(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	192(%rsp), %rsi
	movq	$0, 3232(%rsp)
	movq	%rax, %rdi
	movq	%rax, 408(%rsp)
	movq	%rax, %r12
	movaps	%xmm0, 3216(%rsp)
.LEHB368:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	200(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	3248(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE368:
	leaq	10256(%rsp), %rsi
	pxor	%xmm0, %xmm0
	leaq	14096(%rsp), %rdx
	movq	$0, 14160(%rsp)
	movq	%rsi, %rdi
	movq	%r12, %rsi
	movaps	%xmm0, 14144(%rsp)
	movq	%rdi, 208(%rsp)
	movl	$0x3f800000, 14144(%rsp)
	movaps	%xmm0, 14096(%rsp)
	movaps	%xmm0, 14112(%rsp)
	movaps	%xmm0, 14128(%rsp)
.LEHB369:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE369:
	leaq	3280(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$8589934598, %rcx
	movq	%r12, %rdi
	movq	%rcx, 28896(%rsp)
.LEHB370:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE370:
	leaq	10336(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%r12, %rsi
	leaq	12944(%rsp), %rdx
	movq	%rax, %rdi
	movaps	%xmm0, 12944(%rsp)
	movq	%rax, %r12
	movl	$0x40000000, 12948(%rsp)
	movq	%rax, 920(%rsp)
	movaps	%xmm0, 12960(%rsp)
	movaps	%xmm0, 12976(%rsp)
.LEHB371:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE371:
	leaq	3312(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	208(%rsp), %rsi
	movq	$0, 3328(%rsp)
	movq	%rax, %rdi
	movq	%rax, 440(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 3312(%rsp)
.LEHB372:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	3344(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869200, %r14
	movq	%r12, %rdi
	movq	%r14, 28896(%rsp)
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE372:
	xorl	%eax, %eax
	movl	$31, %ecx
	movq	%r12, %rsi
	leaq	24544(%rsp), %rdi
	leaq	24544(%rsp), %rdx
	rep stosq
	leaq	10416(%rsp), %rax
	movq	%rax, 216(%rsp)
	movl	$0, (%rdi)
	movq	%rax, %rdi
	movl	$0x41000000, 24544(%rsp)
	movl	$0x41100000, 24580(%rsp)
	movl	$0x41200000, 24616(%rsp)
	movl	$0x41300000, 24652(%rsp)
	movl	$0x41400000, 24688(%rsp)
	movl	$0x41500000, 24724(%rsp)
	movl	$0x41600000, 24760(%rsp)
	movl	$0x41700000, 24796(%rsp)
.LEHB373:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE373:
	leaq	3376(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB374:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE374:
	leaq	24800(%rsp), %rdi
	movl	$31, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	10496(%rsp), %rcx
	leaq	24800(%rsp), %rdx
	movq	%rcx, 224(%rsp)
	movl	$0, (%rdi)
	movq	%rcx, %rdi
	movl	$0x41000000, 24800(%rsp)
	movl	$0x41100000, 24836(%rsp)
	movl	$0x41200000, 24872(%rsp)
	movl	$0x41300000, 24908(%rsp)
	movl	$0x41400000, 24944(%rsp)
	movl	$0x41500000, 24980(%rsp)
	movl	$0x41600000, 25016(%rsp)
	movl	$0x41700000, 25052(%rsp)
.LEHB375:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE375:
	leaq	3408(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	216(%rsp), %rsi
	movq	$0, 3424(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 464(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3408(%rsp)
.LEHB376:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	224(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	3440(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE376:
	leaq	25056(%rsp), %rdi
	movl	$31, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	10576(%rsp), %rcx
	leaq	25056(%rsp), %rdx
	movq	%rcx, 232(%rsp)
	movl	$0, (%rdi)
	movq	%rcx, %rdi
	movl	$0x41700000, 25308(%rsp)
.LEHB377:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE377:
	leaq	3472(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB378:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE378:
	leaq	25312(%rsp), %rdi
	movl	$32, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	10656(%rsp), %rcx
	leaq	25312(%rsp), %rdx
	movl	$0x41600000, 25528(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 240(%rsp)
.LEHB379:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE379:
	leaq	3504(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	232(%rsp), %rsi
	movq	$0, 3520(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 480(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3504(%rsp)
.LEHB380:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	240(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	3536(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE380:
	leaq	25568(%rsp), %rdi
	movl	$32, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	10736(%rsp), %rcx
	leaq	25568(%rsp), %rdx
	movl	$0x41500000, 25748(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 248(%rsp)
.LEHB381:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE381:
	leaq	3568(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB382:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE382:
	leaq	25824(%rsp), %rdi
	movl	$32, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	10816(%rsp), %rcx
	leaq	25824(%rsp), %rdx
	movl	$0x41200000, 25896(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 256(%rsp)
.LEHB383:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE383:
	leaq	3600(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	248(%rsp), %rsi
	movq	$0, 3616(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 504(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3600(%rsp)
.LEHB384:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	256(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	3632(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE384:
	leaq	26080(%rsp), %rdi
	movl	$32, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	10896(%rsp), %rcx
	leaq	26080(%rsp), %rdx
	movl	$0x41400000, 26224(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 264(%rsp)
.LEHB385:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE385:
	leaq	3664(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB386:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE386:
	leaq	26336(%rsp), %rdi
	movl	$32, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	10976(%rsp), %rcx
	leaq	26336(%rsp), %rdx
	movl	$0x41000000, 26336(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 272(%rsp)
.LEHB387:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE387:
	leaq	3696(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	264(%rsp), %rsi
	movq	$0, 3712(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 520(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3696(%rsp)
.LEHB388:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	272(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	3728(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE388:
	leaq	26592(%rsp), %rdi
	movl	$32, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	11056(%rsp), %rcx
	leaq	26592(%rsp), %rdx
	movl	$0x41300000, 26700(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 288(%rsp)
.LEHB389:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE389:
	leaq	3760(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB390:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE390:
	leaq	26848(%rsp), %rdi
	movl	$31, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	11136(%rsp), %rcx
	leaq	26848(%rsp), %rdx
	movq	%rcx, 304(%rsp)
	movl	$0, (%rdi)
	movq	%rcx, %rdi
	movl	$0x41700000, 27100(%rsp)
.LEHB391:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE391:
	leaq	3792(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	288(%rsp), %rsi
	movq	$0, 3808(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 544(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3792(%rsp)
.LEHB392:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	304(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	3824(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE392:
	leaq	27104(%rsp), %rdi
	movl	$32, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	11216(%rsp), %rcx
	leaq	27104(%rsp), %rdx
	movl	$0x41200000, 27176(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 320(%rsp)
.LEHB393:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE393:
	leaq	3856(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB394:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE394:
	leaq	27360(%rsp), %rdi
	movl	$32, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	11296(%rsp), %rcx
	leaq	27360(%rsp), %rdx
	movl	$0x41500000, 27540(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 336(%rsp)
.LEHB395:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE395:
	leaq	3888(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	320(%rsp), %rsi
	movq	$0, 3904(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 560(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3888(%rsp)
.LEHB396:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	336(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	3920(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE396:
	leaq	27616(%rsp), %rdi
	movl	$32, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	11376(%rsp), %rcx
	leaq	27616(%rsp), %rdx
	movl	$0x41100000, 27652(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 352(%rsp)
.LEHB397:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE397:
	leaq	3952(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB398:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE398:
	leaq	27872(%rsp), %rdi
	movl	$32, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	11456(%rsp), %rcx
	leaq	27872(%rsp), %rdx
	movl	$0x41300000, 27980(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 368(%rsp)
.LEHB399:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE399:
	leaq	3984(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	352(%rsp), %rsi
	movq	$0, 4000(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 576(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3984(%rsp)
.LEHB400:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	368(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	4016(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r14, 28896(%rsp)
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE400:
	leaq	28128(%rsp), %rdi
	movl	$32, %ecx
	xorl	%eax, %eax
	movq	%r12, %rsi
	rep stosq
	leaq	11536(%rsp), %rcx
	leaq	28128(%rsp), %rdx
	movl	$0x41000000, 28128(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 384(%rsp)
.LEHB401:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE401:
	leaq	4048(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB402:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE402:
	xorl	%eax, %eax
	leaq	28384(%rsp), %rdi
	movl	$32, %ecx
	movq	%r12, %rsi
	rep stosq
	leaq	11616(%rsp), %rax
	leaq	28384(%rsp), %rdx
	movl	$0x41100000, 28420(%rsp)
	movq	%rax, %rdi
	movq	%rax, 424(%rsp)
	movq	%rax, %r12
.LEHB403:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE403:
	leaq	4080(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	384(%rsp), %rsi
	movq	$0, 4096(%rsp)
	movq	%rax, %rdi
	movq	%rax, 608(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 4080(%rsp)
.LEHB404:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	4112(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$8589934624, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE404:
	xorl	%eax, %eax
	movl	$32, %ecx
	movq	%r12, %rsi
	leaq	28640(%rsp), %rdi
	leaq	28640(%rsp), %rdx
	rep stosq
	leaq	11696(%rsp), %rax
	movl	$0x3f800000, 28640(%rsp)
	movq	%rax, %rdi
	movq	%rax, 72(%rsp)
	movl	$0x3f800000, 28696(%rsp)
	movl	$0x3f800000, 28708(%rsp)
	movl	$0x3f800000, 28764(%rsp)
	movl	$0x3f800000, 28780(%rsp)
	movl	$0x3f800000, 28820(%rsp)
	movl	$0x3f800000, 28840(%rsp)
	movl	$0x3f800000, 28880(%rsp)
.LEHB405:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE405:
	leaq	4144(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$34359738370, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB406:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE406:
	xorl	%eax, %eax
	movq	%rbp, %rdi
	movl	$32, %ecx
	movq	%r12, %rsi
	leaq	11776(%rsp), %rbp
	leaq	28896(%rsp), %rdx
	rep stosq
	movq	%rbp, %rdi
	movq	%rbp, 456(%rsp)
	movabsq	$4575657222473777152, %rax
	movl	$0x3f800000, 28896(%rsp)
	movl	$0x3f800000, 28908(%rsp)
	movq	%rax, 28948(%rsp)
.LEHB407:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE407:
	leaq	4176(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	72(%rsp), %rsi
	movq	$0, 4192(%rsp)
	movq	%rax, %rdi
	movq	%rax, 648(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 4176(%rsp)
.LEHB408:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%rbp, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	leaq	12992(%rsp), %r12
	leaq	4208(%rsp), %rbp
	movl	$2, %edx
	movabsq	$8589934600, %rax
	movq	%r12, %rsi
	movq	%rbp, %rdi
	movq	%rax, 12992(%rsp)
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE408:
	movss	.LC111(%rip), %xmm0
	leaq	11856(%rsp), %rax
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movaps	%xmm0, 12992(%rsp)
	movaps	.LC112(%rip), %xmm0
	movq	%rax, %rdi
	movq	%rax, %r12
	movq	%rax, 400(%rsp)
	movaps	%xmm0, 13008(%rsp)
	movaps	.LC113(%rip), %xmm0
	movaps	%xmm0, 13024(%rsp)
	movaps	.LC114(%rip), %xmm0
	movaps	%xmm0, 13040(%rsp)
.LEHB409:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE409:
	movabsq	$8589934594, %rax
	leaq	4240(%rsp), %rbp
	movl	$2, %edx
	movq	%rax, 12816(%rsp)
	leaq	12816(%rsp), %rax
	movq	%rbp, %rdi
	movq	%rax, %rsi
	movq	%rax, 40(%rsp)
.LEHB410:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE410:
	leaq	11936(%rsp), %rax
	movaps	.LC115(%rip), %xmm0
	movq	%rbp, %rsi
	leaq	12768(%rsp), %rdx
	movq	%rax, %rdi
	movq	%rax, 496(%rsp)
	movq	%rax, %rbp
	movaps	%xmm0, 12768(%rsp)
.LEHB411:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE411:
	leaq	4272(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%r12, %rsi
	movq	$0, 4288(%rsp)
	movq	%rax, %rdi
	movq	%rax, 696(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 4272(%rsp)
.LEHB412:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%rbp, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	cmpl	$1, %ebx
	je	.L4503
	movq	8(%r13), %rbp
	leaq	.LC118(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L4504
	leaq	.LC120(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L4505
	leaq	.LC121(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L4506
	leaq	.LC127(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L4507
	leaq	.LC131(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L4508
	leaq	.LC139(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L3296
	movq	16(%r13), %rsi
	leaq	12784(%rsp), %rdi
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.isra.0
.LEHE412:
	movq	12784(%rsp), %rdx
	movq	strtol@GOTPCREL(%rip), %rdi
	movl	$10, %r8d
	xorl	%ecx, %ecx
	leaq	.LC133(%rip), %rsi
.LEHB413:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	movl	$12, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	movslq	%eax, %rbx
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%ebx, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	imulq	$24, %rbx, %rbx
	movq	1200(%rsp), %rax
	leaq	12656(%rsp), %rbp
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %rsi
	addq	$72, %rsi
	call	_ZN11denseMatrixC1ERKS_
.LEHE413:
	movq	1200(%rsp), %rax
	leaq	12544(%rsp), %r12
	movq	%r12, %rdi
	movq	(%rax,%rbx), %rsi
.LEHB414:
	call	_ZN11denseMatrixC1ERKS_
.LEHE414:
	leaq	12016(%rsp), %r14
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%r14, %rdi
	movq	%r14, 32(%rsp)
.LEHB415:
	call	_Z12denseProduct11denseMatrixS_
.LEHE415:
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	leaq	_ZSt4cout(%rip), %rdi
.LEHB416:
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movl	$25, %edx
	leaq	.LC134(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	%r13, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN11denseMatrix5printEv
	movl	$25, %edx
	leaq	.LC134(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE416:
	leaq	12096(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movq	%rax, %rdi
	movq	%rax, 24(%rsp)
.LEHB417:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE417:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3383
	call	_ZdlPv@PLT
.L3383:
	movl	$26, %edx
	leaq	.LC135(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB418:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$26, %edx
	leaq	.LC135(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	1200(%rsp), %rax
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %r13
	movq	%r13, %rsi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE418:
	leaq	12208(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%rax, %rdi
	movq	%rax, 16(%rsp)
.LEHB419:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE419:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3384
	call	_ZdlPv@PLT
.L3384:
	movl	$13, %edx
	leaq	.LC136(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB420:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$13, %edx
	leaq	.LC136(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	1200(%rsp), %rax
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %r13
	addq	$72, %r13
	movq	%r13, %rsi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE420:
	leaq	12320(%rsp), %r14
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%r14, %rdi
.LEHB421:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE421:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3385
	call	_ZdlPv@PLT
.L3385:
	movl	$14, %edx
	leaq	.LC137(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB422:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$14, %edx
	leaq	.LC137(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE422:
	movq	16(%rsp), %rsi
	movq	%r12, %rdi
.LEHB423:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE423:
	leaq	12432(%rsp), %r13
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%r13, %rdi
.LEHB424:
	call	_Z7product19quantumSparseMatrixS_
.LEHE424:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movl	$10, %edx
	leaq	.LC138(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB425:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$10, %edx
	leaq	.LC138(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE425:
	movq	24(%rsp), %rsi
	movq	%r12, %rdi
.LEHB426:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE426:
	movq	40(%rsp), %rdi
	movq	%rbp, %rdx
	movq	%r12, %rsi
.LEHB427:
	call	_Z11checkResultB5cxx1119quantumSparseMatrixS_
.LEHE427:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movl	$3, %edx
	leaq	.LC117(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB428:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	12824(%rsp), %rdx
	movq	12816(%rsp), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	%rax, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE428:
.L4502:
	movq	12816(%rsp), %rdi
	leaq	12832(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3386
	call	_ZdlPv@PLT
.L3386:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	32(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	12784(%rsp), %rdi
	leaq	12800(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3296
.L4494:
	call	_ZdlPv@PLT
.L3296:
	movq	696(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	496(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4240(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3388
	call	_ZdlPv@PLT
.L3388:
	movq	400(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4208(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3389
	call	_ZdlPv@PLT
.L3389:
	movq	648(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	456(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4144(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3390
	call	_ZdlPv@PLT
.L3390:
	movq	72(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4112(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3391
	call	_ZdlPv@PLT
.L3391:
	movq	608(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	424(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4048(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3392
	call	_ZdlPv@PLT
.L3392:
	movq	384(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4016(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3393
	call	_ZdlPv@PLT
.L3393:
	movq	576(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	368(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3952(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3394
	call	_ZdlPv@PLT
.L3394:
	movq	352(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3920(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3395
	call	_ZdlPv@PLT
.L3395:
	movq	560(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	336(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3856(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3396
	call	_ZdlPv@PLT
.L3396:
	movq	320(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3824(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3397
	call	_ZdlPv@PLT
.L3397:
	movq	544(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	304(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3760(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3398
	call	_ZdlPv@PLT
.L3398:
	movq	288(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3399
	call	_ZdlPv@PLT
.L3399:
	movq	520(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	272(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3664(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3400
	call	_ZdlPv@PLT
.L3400:
	movq	264(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3632(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3401
	call	_ZdlPv@PLT
.L3401:
	movq	504(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	256(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3568(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3402
	call	_ZdlPv@PLT
.L3402:
	movq	248(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3536(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3403
	call	_ZdlPv@PLT
.L3403:
	movq	480(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	240(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3472(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3404
	call	_ZdlPv@PLT
.L3404:
	movq	232(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3440(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3405
	call	_ZdlPv@PLT
.L3405:
	movq	464(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	224(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3376(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3406
	call	_ZdlPv@PLT
.L3406:
	movq	216(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3344(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3407
	call	_ZdlPv@PLT
.L3407:
	movq	440(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	920(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3280(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3408
	call	_ZdlPv@PLT
.L3408:
	movq	208(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3248(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3409
	call	_ZdlPv@PLT
.L3409:
	movq	408(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	200(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3184(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3410
	call	_ZdlPv@PLT
.L3410:
	movq	192(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3152(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3411
	call	_ZdlPv@PLT
.L3411:
	movq	1184(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	184(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3088(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3412
	call	_ZdlPv@PLT
.L3412:
	movq	176(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3056(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3413
	call	_ZdlPv@PLT
.L3413:
	movq	1168(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	168(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2992(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3414
	call	_ZdlPv@PLT
.L3414:
	movq	160(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2960(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3415
	call	_ZdlPv@PLT
.L3415:
	movq	1152(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	152(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2896(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3416
	call	_ZdlPv@PLT
.L3416:
	movq	144(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2864(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3417
	call	_ZdlPv@PLT
.L3417:
	movq	1144(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	136(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2800(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3418
	call	_ZdlPv@PLT
.L3418:
	movq	128(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2768(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3419
	call	_ZdlPv@PLT
.L3419:
	movq	1120(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	120(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3420
	call	_ZdlPv@PLT
.L3420:
	movq	112(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2672(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3421
	call	_ZdlPv@PLT
.L3421:
	movq	1104(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	104(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2608(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3422
	call	_ZdlPv@PLT
.L3422:
	movq	96(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2576(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3423
	call	_ZdlPv@PLT
.L3423:
	movq	1088(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	88(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2512(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3424
	call	_ZdlPv@PLT
.L3424:
	movq	80(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3425
	call	_ZdlPv@PLT
.L3425:
	movq	1064(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	64(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2416(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3426
	call	_ZdlPv@PLT
.L3426:
	movq	56(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2384(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3427
	call	_ZdlPv@PLT
.L3427:
	movq	1040(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	376(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3428
	call	_ZdlPv@PLT
.L3428:
	movq	360(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2288(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3429
	call	_ZdlPv@PLT
.L3429:
	movq	1000(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	344(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2224(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3430
	call	_ZdlPv@PLT
.L3430:
	movq	328(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3431
	call	_ZdlPv@PLT
.L3431:
	movq	976(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	312(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3432
	call	_ZdlPv@PLT
.L3432:
	movq	296(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3433
	call	_ZdlPv@PLT
.L3433:
	movq	952(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	280(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2032(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3434
	call	_ZdlPv@PLT
.L3434:
	movq	48(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2000(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3435
	call	_ZdlPv@PLT
.L3435:
	movq	928(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1080(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	1056(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	896(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1032(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	1016(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	888(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	992(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	968(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	880(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	944(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	912(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	856(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	872(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	840(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	848(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	800(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	768(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	824(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	728(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	688(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	816(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	656(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	624(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	808(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	584(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	568(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	784(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	552(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	536(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	776(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	528(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	512(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	752(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	488(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	472(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	744(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	448(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	432(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	736(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	416(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	1192(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	712(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1176(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	1160(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	704(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	392(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	1136(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	680(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1128(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	1112(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	672(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1096(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	1072(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	664(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1048(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	1024(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	640(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1008(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	984(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	632(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	960(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	936(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	616(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	904(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	864(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	600(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	832(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	792(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	592(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	760(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	720(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED1Ev
	movq	35304(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L4509
	addq	$35320, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L4504:
	.cfi_restore_state
	movq	392(%rsp), %r14
	movq	%r14, %rdi
.LEHB429:
	call	_ZN11denseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movabsq	$34359738376, %rax
	movq	40(%rsp), %rsi
	movl	$2, %edx
	movq	%rax, 12816(%rsp)
	leaq	12096(%rsp), %rax
	movq	%rax, %rdi
	movq	%rax, %rbx
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE429:
	leaq	12656(%rsp), %rbp
	movq	%rbx, %rsi
	movq	%rbp, %rdi
.LEHB430:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE430:
	leaq	12432(%rsp), %r13
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movq	%r13, %rdi
.LEHB431:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE431:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3338
	call	_ZdlPv@PLT
.L3338:
	movq	%r13, %rdi
.LEHB432:
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movabsq	$68719476740, %rax
	movq	40(%rsp), %rsi
	movl	$2, %edx
	movq	%rax, 12816(%rsp)
	leaq	12208(%rsp), %rax
	movq	%rax, %rdi
	movq	%rax, %rbx
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE432:
	leaq	12320(%rsp), %r14
	movq	%rbx, %rsi
	movq	%r14, %rdi
.LEHB433:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE433:
	movq	%r13, %rsi
	movq	%rbp, %rdi
.LEHB434:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE434:
	leaq	12544(%rsp), %r12
	movq	%r14, %rdx
	movq	%rbp, %rsi
	movq	%r12, %rdi
.LEHB435:
	call	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE435:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3339
	call	_ZdlPv@PLT
.L3339:
	movq	%r12, %rdi
.LEHB436:
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE436:
.L4500:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12208(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3346
	call	_ZdlPv@PLT
.L3346:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4494
	jmp	.L3296
.L4503:
	movq	$0, 8(%rsp)
	movq	1200(%rsp), %rax
	xorl	%ebx, %ebx
	cmpq	%rax, 1208(%rsp)
	je	.L3296
	.p2align 4,,10
	.p2align 3
.L3295:
	movl	$12, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB437:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	8(%rsp), %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movq	1200(%rsp), %rax
	pxor	%xmm5, %xmm5
	movq	(%rax,%rbx), %rbp
	movq	80(%rbp), %rax
	movq	72(%rbp), %rsi
	movaps	%xmm5, 12656(%rsp)
	movq	$0, 12672(%rsp)
	movq	%rax, %r12
	subq	%rsi, %r12
	movq	%r12, %rdx
	sarq	$2, %rdx
	je	.L4510
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L4511
	movq	%r12, %rdi
	call	_Znwm@PLT
.LEHE437:
	movq	%rax, %rcx
	movq	80(%rbp), %rax
	movq	72(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L3298:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 12672(%rsp)
	movaps	%xmm0, 12656(%rsp)
	cmpq	%rsi, %rax
	je	.L3300
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L3300:
	addq	%r13, %rcx
	pxor	%xmm6, %xmm6
	movq	%rcx, 12664(%rsp)
	movq	104(%rbp), %rax
	movq	96(%rbp), %rsi
	movups	%xmm6, 12680(%rsp)
	movq	$0, 12696(%rsp)
	movq	%rax, %r12
	subq	%rsi, %r12
	movq	%r12, %rdx
	sarq	$2, %rdx
	je	.L4512
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L4513
	movq	%r12, %rdi
.LEHB438:
	call	_Znwm@PLT
.LEHE438:
	movq	%rax, %rcx
	movq	104(%rbp), %rax
	movq	96(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L3302:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 12696(%rsp)
	movups	%xmm0, 12680(%rsp)
	cmpq	%rsi, %rax
	je	.L3304
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L3304:
	movl	120(%rbp), %eax
	movdqu	128(%rbp), %xmm7
	addq	%r13, %rcx
	pxor	%xmm1, %xmm1
	movq	%rcx, 12688(%rsp)
	movl	%eax, 12704(%rsp)
	movq	1200(%rsp), %rax
	movups	%xmm7, 12712(%rsp)
	movq	(%rax,%rbx), %rbp
	movq	8(%rbp), %r12
	subq	0(%rbp), %r12
	movaps	%xmm1, 12544(%rsp)
	movq	$0, 12560(%rsp)
	movq	%r12, %rax
	sarq	$2, %rax
	je	.L4514
	movabsq	$2305843009213693951, %rcx
	cmpq	%rcx, %rax
	ja	.L4515
	movq	%r12, %rdi
.LEHB439:
	call	_Znwm@PLT
.LEHE439:
	movq	%rax, %rcx
.L3306:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 12560(%rsp)
	movaps	%xmm0, 12544(%rsp)
	movq	8(%rbp), %rax
	movq	0(%rbp), %rsi
	movq	%rax, %r12
	subq	%rsi, %r12
	cmpq	%rsi, %rax
	je	.L3312
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L3312:
	addq	%r12, %rcx
	pxor	%xmm2, %xmm2
	movq	%rcx, 12552(%rsp)
	movq	32(%rbp), %r12
	subq	24(%rbp), %r12
	movups	%xmm2, 12568(%rsp)
	movq	$0, 12584(%rsp)
	movq	%r12, %rax
	sarq	$2, %rax
	je	.L4516
	movabsq	$2305843009213693951, %rcx
	cmpq	%rcx, %rax
	ja	.L4517
	movq	%r12, %rdi
.LEHB440:
	call	_Znwm@PLT
.LEHE440:
	movq	%rax, %rcx
.L3314:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 12584(%rsp)
	movups	%xmm0, 12568(%rsp)
	movq	32(%rbp), %rax
	movq	24(%rbp), %rsi
	movq	%rax, %r12
	subq	%rsi, %r12
	cmpq	%rsi, %rax
	je	.L3317
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L3317:
	movl	48(%rbp), %eax
	movdqu	56(%rbp), %xmm3
	addq	%r12, %rcx
	leaq	12656(%rsp), %rbp
	leaq	12544(%rsp), %r12
	movq	%rbp, %rdx
	movq	%rcx, 12576(%rsp)
	movl	%eax, 12592(%rsp)
	leaq	12016(%rsp), %rax
	movq	%r12, %rsi
	movq	%rax, %rdi
	movq	%rax, 32(%rsp)
	movups	%xmm3, 12600(%rsp)
.LEHB441:
	call	_Z12denseProduct11denseMatrixS_
.LEHE441:
	movq	12568(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3322
	call	_ZdlPv@PLT
.L3322:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3323
	call	_ZdlPv@PLT
.L3323:
	movq	12680(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3324
	call	_ZdlPv@PLT
.L3324:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3325
	call	_ZdlPv@PLT
.L3325:
	movq	32(%rsp), %r14
	movq	%rbp, %rdi
	movq	%r14, %rsi
.LEHB442:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE442:
	leaq	12096(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movq	%rax, %rdi
	movq	%rax, 24(%rsp)
.LEHB443:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE443:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3326
	call	_ZdlPv@PLT
.L3326:
	movq	1200(%rsp), %rax
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %r13
	movq	%r13, %rsi
.LEHB444:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE444:
	leaq	12208(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%rax, %rdi
	movq	%rax, 16(%rsp)
.LEHB445:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE445:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3327
	call	_ZdlPv@PLT
.L3327:
	movq	1200(%rsp), %rax
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %r13
	addq	$72, %r13
	movq	%r13, %rsi
.LEHB446:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE446:
	leaq	12320(%rsp), %r14
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%r14, %rdi
.LEHB447:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE447:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3328
	call	_ZdlPv@PLT
.L3328:
	movq	%r14, %rsi
	movq	%rbp, %rdi
.LEHB448:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE448:
	movq	16(%rsp), %rsi
	movq	%r12, %rdi
.LEHB449:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE449:
	leaq	12432(%rsp), %r13
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%r13, %rdi
.LEHB450:
	call	_Z7product19quantumSparseMatrixS_
.LEHE450:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r13, %rsi
	movq	%rbp, %rdi
.LEHB451:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE451:
	movq	24(%rsp), %rsi
	movq	%r12, %rdi
.LEHB452:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE452:
	movq	40(%rsp), %rdi
	movq	%rbp, %rdx
	movq	%r12, %rsi
.LEHB453:
	call	_Z11checkResultB5cxx1119quantumSparseMatrixS_
.LEHE453:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movl	$3, %edx
	leaq	.LC117(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB454:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	12824(%rsp), %rdx
	movq	12816(%rsp), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	%rax, %rbp
	movq	(%rax), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %r12
	testq	%r12, %r12
	je	.L4518
	cmpb	$0, 56(%r12)
	je	.L3330
	movsbl	67(%r12), %esi
.L3331:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movq	12816(%rsp), %rdi
	leaq	12832(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3332
	call	_ZdlPv@PLT
.L3332:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12040(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3333
	call	_ZdlPv@PLT
.L3333:
	movq	12016(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3334
	call	_ZdlPv@PLT
	addq	$1, 8(%rsp)
	movq	8(%rsp), %rcx
	movabsq	$-6148914691236517205, %rdx
	movq	1208(%rsp), %rax
	subq	1200(%rsp), %rax
	addq	$24, %rbx
	sarq	$3, %rax
	imulq	%rdx, %rax
	cmpq	%rax, %rcx
	jb	.L3295
	jmp	.L3296
	.p2align 4,,10
	.p2align 3
.L3330:
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rcx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rcx, %rax
	je	.L3331
	movq	%r12, %rdi
	call	*%rax
.LEHE454:
	movsbl	%al, %esi
	jmp	.L3331
	.p2align 4,,10
	.p2align 3
.L3334:
	movq	1208(%rsp), %rax
	subq	1200(%rsp), %rax
	addq	$24, %rbx
	movabsq	$-6148914691236517205, %rdx
	sarq	$3, %rax
	addq	$1, 8(%rsp)
	movq	8(%rsp), %rcx
	imulq	%rdx, %rax
	cmpq	%rcx, %rax
	ja	.L3295
	jmp	.L3296
	.p2align 4,,10
	.p2align 3
.L4512:
	movq	%r12, %r13
	xorl	%ecx, %ecx
	jmp	.L3302
	.p2align 4,,10
	.p2align 3
.L4510:
	movq	%r12, %r13
	xorl	%ecx, %ecx
	jmp	.L3298
	.p2align 4,,10
	.p2align 3
.L4514:
	xorl	%ecx, %ecx
	jmp	.L3306
	.p2align 4,,10
	.p2align 3
.L4516:
	xorl	%ecx, %ecx
	jmp	.L3314
.L4506:
	leaq	12432(%rsp), %r13
	movq	40(%rsp), %rsi
	movl	$3, %edx
	movabsq	$12884901891, %rax
	movq	%r13, %rdi
	movq	%rax, 12816(%rsp)
	movl	$2, 12824(%rsp)
.LEHB455:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1
	movdqa	12432(%rsp), %xmm1
	movq	12448(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 12448(%rsp)
	movq	8200(%rsp), %rdi
	movaps	%xmm0, 12432(%rsp)
	movq	%rax, 8216(%rsp)
	movups	%xmm1, 8200(%rsp)
	testq	%rdi, %rdi
	je	.L3350
	call	_ZdlPv@PLT
	movq	12432(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3350
	call	_ZdlPv@PLT
.L3350:
	movq	48(%rsp), %r14
	movq	%r14, %rdi
	call	_ZN11denseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movabsq	$25769803779, %rax
	movq	40(%rsp), %rsi
	movl	$2, %edx
	movq	%rax, 12816(%rsp)
	leaq	12208(%rsp), %rax
	movq	%rax, %rdi
	movq	%rax, %rbx
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE455:
	leaq	12544(%rsp), %r12
	movq	%rbx, %rsi
	movq	%r12, %rdi
.LEHB456:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE456:
	leaq	12656(%rsp), %rbp
	movq	%r12, %rdx
	movq	%r14, %rsi
	movq	%rbp, %rdi
.LEHB457:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE457:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3352
	call	_ZdlPv@PLT
.L3352:
	movq	%rbp, %rdi
.LEHB458:
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movl	$34, %edx
	leaq	.LC122(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	$2, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$12, %edx
	leaq	.LC123(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r14
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	$2, %esi
	movq	%r14, %rdi
	call	_ZNSolsEi@PLT
	movq	%rax, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	leaq	12320(%rsp), %rdi
	movl	$2, %ecx
	movl	$2, %edx
	movq	%rbp, %rsi
	call	_ZN19quantumSparseMatrix17getMatrixPositionEii
.LEHE458:
	movl	$18, %edx
	leaq	.LC124(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB459:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	12320(%rsp), %rax
	leaq	_ZSt4cout(%rip), %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r14
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	12320(%rsp), %rax
	movq	%r14, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movq	%rax, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movl	$2, %ecx
	movl	$2, %edx
	movq	%rbp, %rsi
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrix17getTensorPositionEii
.LEHE459:
	movl	$18, %edx
	leaq	.LC125(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB460:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	12432(%rsp), %rax
	leaq	_ZSt4cout(%rip), %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r14
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	12432(%rsp), %rax
	movq	%r14, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r14
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	12432(%rsp), %rax
	movq	%r14, %rdi
	movl	8(%rax), %esi
	call	_ZNSolsEi@PLT
	movq	%rax, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movl	$36, %edx
	leaq	.LC126(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE460:
	movq	48(%rsp), %rdi
	movq	%r12, %rsi
.LEHB461:
	call	_ZN11denseMatrix7getItemESt6vectorIiSaIiEE
	leaq	12096(%rsp), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	movq	%xmm0, 12096(%rsp)
	call	_ZStlsIfcSt11char_traitsIcEERSt13basic_ostreamIT0_T1_ES6_RKSt7complexIT_E@PLT
	movq	%rax, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE461:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3353
	call	_ZdlPv@PLT
.L3353:
	movq	12432(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3354
	call	_ZdlPv@PLT
.L3354:
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3355
	call	_ZdlPv@PLT
.L3355:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12208(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4494
	jmp	.L3296
.L4505:
	movq	48(%rsp), %r14
	movq	%r14, %rdi
.LEHB462:
	call	_ZN11denseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movabsq	$25769803779, %rax
	movq	40(%rsp), %rsi
	movl	$2, %edx
	movq	%rax, 12816(%rsp)
	leaq	12096(%rsp), %rax
	movq	%rax, %rdi
	movq	%rax, %rbx
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE462:
	leaq	12656(%rsp), %rbp
	movq	%rbx, %rsi
	movq	%rbp, %rdi
.LEHB463:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE463:
	leaq	12432(%rsp), %r13
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movq	%r13, %rdi
.LEHB464:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE464:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3343
	call	_ZdlPv@PLT
.L3343:
	movq	%r13, %rdi
.LEHB465:
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE465:
	leaq	12320(%rsp), %r14
	pxor	%xmm0, %xmm0
	leaq	12208(%rsp), %rsi
	movq	$0, 12224(%rsp)
	movq	%r14, %rdi
	movaps	%xmm0, 12208(%rsp)
.LEHB466:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE466:
	movq	%r13, %rsi
	movq	%rbp, %rdi
.LEHB467:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE467:
	leaq	12544(%rsp), %r12
	movq	%r14, %rdx
	movq	%rbp, %rsi
	movq	%r12, %rdi
.LEHB468:
	call	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE468:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3344
	call	_ZdlPv@PLT
.L3344:
	movq	%r12, %rdi
.LEHB469:
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE469:
	movq	%r14, %rdx
	movq	%r12, %rsi
	movq	%rbp, %rdi
.LEHB470:
	call	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE
.LEHE470:
	movq	%rbp, %rdi
.LEHB471:
	call	_ZN11denseMatrix5printEv
.LEHE471:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3345
	call	_ZdlPv@PLT
.L3345:
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB472:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE472:
	jmp	.L4500
.L4507:
	movl	$14, %edx
	leaq	.LC128(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB473:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	48(%rsp), %rbx
	movq	%rbx, %rdi
	call	_ZN11denseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	leaq	4304(%rsp), %r12
	movq	40(%rsp), %rsi
	movl	$2, %edx
	movabsq	$25769803779, %rax
	movq	%r12, %rdi
	movq	%rax, 12816(%rsp)
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE473:
	leaq	12656(%rsp), %rbp
	movq	%r12, %rsi
	movq	%rbp, %rdi
.LEHB474:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE474:
	leaq	12208(%rsp), %rax
	movq	%rbp, %rdx
	movq	%rbx, %rsi
	movq	%rax, %rdi
	movq	%rax, 16(%rsp)
.LEHB475:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE475:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3358
	call	_ZdlPv@PLT
.L3358:
	movabsq	$12884901891, %rax
	movq	40(%rsp), %rsi
	movl	$3, %edx
	movl	$2, 12824(%rsp)
	movq	%rax, 12816(%rsp)
	leaq	12096(%rsp), %rax
	movq	%rax, %rdi
	movq	%rax, 24(%rsp)
.LEHB476:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1
	movdqa	12096(%rsp), %xmm2
	movq	12112(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 12112(%rsp)
	movq	12232(%rsp), %rdi
	movaps	%xmm0, 12096(%rsp)
	movq	%rax, 12248(%rsp)
	movups	%xmm2, 12232(%rsp)
	testq	%rdi, %rdi
	je	.L3360
	call	_ZdlPv@PLT
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3360
	call	_ZdlPv@PLT
.L3360:
	movq	16(%rsp), %rbx
	movq	%rbx, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE476:
	leaq	12016(%rsp), %rax
	pxor	%xmm0, %xmm0
	leaq	12544(%rsp), %r12
	movq	$0, 12032(%rsp)
	movq	%rax, %rsi
	movq	%r12, %rdi
	movq	%rax, 32(%rsp)
	movaps	%xmm0, 12016(%rsp)
.LEHB477:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE477:
	movq	%rbx, %rsi
	movq	%rbp, %rdi
.LEHB478:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE478:
	leaq	12320(%rsp), %r14
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movq	%r14, %rdi
.LEHB479:
	call	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE479:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3362
	call	_ZdlPv@PLT
.L3362:
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB480:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE480:
	movq	%r12, %rdx
	movq	%r14, %rsi
	movq	%rbp, %rdi
.LEHB481:
	call	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE
.LEHE481:
	movq	%rbp, %rdi
.LEHB482:
	call	_ZN11denseMatrix5printEv
.LEHE482:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3363
	call	_ZdlPv@PLT
.L3363:
	movl	$14, %edx
	leaq	.LC129(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB483:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	400(%rsp), %rbx
	movq	%rbx, %rdi
	call	_ZN11denseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE483:
	leaq	12432(%rsp), %r13
	movq	%rbp, %rdx
	movq	%rbx, %rsi
	movq	%r13, %rdi
.LEHB484:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE484:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3364
	call	_ZdlPv@PLT
.L3364:
	movdqa	.LC130(%rip), %xmm0
	movq	40(%rsp), %rsi
	movl	$4, %edx
	movq	%r12, %rdi
	movaps	%xmm0, 12816(%rsp)
.LEHB485:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1
	movdqa	12544(%rsp), %xmm3
	movq	12560(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 12560(%rsp)
	movq	12456(%rsp), %rdi
	movaps	%xmm0, 12544(%rsp)
	movq	%rax, 12472(%rsp)
	movups	%xmm3, 12456(%rsp)
	testq	%rdi, %rdi
	je	.L3366
	call	_ZdlPv@PLT
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3366
	call	_ZdlPv@PLT
.L3366:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	24(%rsp), %rbx
	movq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE485:
	movq	%r13, %rsi
	movq	%r12, %rdi
.LEHB486:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE486:
	movq	%rbx, %rdx
	movq	%r12, %rsi
	movq	%rbp, %rdi
.LEHB487:
	call	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE487:
	movdqa	12656(%rsp), %xmm2
	movq	12672(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 12672(%rsp)
	movq	12320(%rsp), %rdi
	movaps	%xmm0, 12656(%rsp)
	movq	%rax, 12336(%rsp)
	movaps	%xmm2, 12320(%rsp)
	testq	%rdi, %rdi
	je	.L3368
	call	_ZdlPv@PLT
.L3368:
	movdqu	12680(%rsp), %xmm3
	movq	12696(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 12696(%rsp)
	movq	12344(%rsp), %rdi
	movups	%xmm0, 12680(%rsp)
	movq	%rax, 12360(%rsp)
	movups	%xmm3, 12344(%rsp)
	testq	%rdi, %rdi
	je	.L3369
	call	_ZdlPv@PLT
.L3369:
	movl	12704(%rsp), %eax
	movq	12392(%rsp), %r8
	movq	%r14, 8(%rsp)
	leaq	12376(%rsp), %rbx
	movq	%rbp, 24(%rsp)
	movl	%eax, 12368(%rsp)
	movq	%r8, %rbp
.L3371:
	testq	%rbp, %rbp
	je	.L3370
	movq	24(%rbp), %rsi
	movq	%rbx, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	16(%rbp), %r14
	movq	%rbp, %rdi
	call	_ZdlPv@PLT
	movq	%r14, %rbp
	jmp	.L3371
.L3370:
	movq	12728(%rsp), %rdx
	leaq	12384(%rsp), %rax
	movq	$0, 12392(%rsp)
	movq	%rax, 12400(%rsp)
	movq	8(%rsp), %r14
	movq	%rax, 12408(%rsp)
	movq	24(%rsp), %rbp
	movq	$0, 12416(%rsp)
	testq	%rdx, %rdx
	je	.L3372
	movl	12720(%rsp), %ecx
	movq	%rdx, 12392(%rsp)
	movl	%ecx, 12384(%rsp)
	movq	12736(%rsp), %rcx
	movq	%rcx, 12400(%rsp)
	movq	12744(%rsp), %rcx
	movq	%rcx, 12408(%rsp)
	movq	%rax, 8(%rdx)
	movq	12752(%rsp), %rax
	movq	$0, 12728(%rsp)
	movq	%rax, 12416(%rsp)
	leaq	12720(%rsp), %rax
	movq	%rax, 12736(%rsp)
	movq	%rax, 12744(%rsp)
	movq	$0, 12752(%rsp)
.L3372:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3373
	call	_ZdlPv@PLT
.L3373:
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB488:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE488:
	movq	%r12, %rdx
	movq	%r14, %rsi
	movq	%rbp, %rdi
.LEHB489:
	call	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE
.LEHE489:
	movq	%rbp, %rdi
.LEHB490:
	call	_ZN11denseMatrix5printEv
.LEHE490:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3374
	call	_ZdlPv@PLT
.L3374:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12016(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3375
	call	_ZdlPv@PLT
.L3375:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	4304(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4494
	jmp	.L3296
.L4508:
	leaq	12784(%rsp), %rdi
	leaq	.LC132(%rip), %rsi
.LEHB491:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.isra.0
.LEHE491:
	movq	12784(%rsp), %rdx
	movq	strtol@GOTPCREL(%rip), %rdi
	movl	$10, %r8d
	xorl	%ecx, %ecx
	leaq	.LC133(%rip), %rsi
.LEHB492:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	movl	$12, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	movslq	%eax, %rbx
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%ebx, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	imulq	$24, %rbx, %rbx
	movq	1200(%rsp), %rax
	leaq	12656(%rsp), %rbp
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %rsi
	addq	$72, %rsi
	call	_ZN11denseMatrixC1ERKS_
.LEHE492:
	movq	1200(%rsp), %rax
	leaq	12544(%rsp), %r12
	movq	%r12, %rdi
	movq	(%rax,%rbx), %rsi
.LEHB493:
	call	_ZN11denseMatrixC1ERKS_
.LEHE493:
	leaq	12016(%rsp), %r14
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%r14, %rdi
	movq	%r14, 32(%rsp)
.LEHB494:
	call	_Z12denseProduct11denseMatrixS_
.LEHE494:
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	leaq	_ZSt4cout(%rip), %rdi
.LEHB495:
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movl	$25, %edx
	leaq	.LC134(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	%r13, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN11denseMatrix5printEv
	movl	$25, %edx
	leaq	.LC134(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE495:
	leaq	12096(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movq	%rax, %rdi
	movq	%rax, 24(%rsp)
.LEHB496:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE496:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3378
	call	_ZdlPv@PLT
.L3378:
	movl	$26, %edx
	leaq	.LC135(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB497:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$26, %edx
	leaq	.LC135(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	1200(%rsp), %rax
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %r13
	movq	%r13, %rsi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE497:
	leaq	12208(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%rax, %rdi
	movq	%rax, 16(%rsp)
.LEHB498:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE498:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3379
	call	_ZdlPv@PLT
.L3379:
	movl	$13, %edx
	leaq	.LC136(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB499:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$13, %edx
	leaq	.LC136(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	1200(%rsp), %rax
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %r13
	addq	$72, %r13
	movq	%r13, %rsi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE499:
	leaq	12320(%rsp), %r14
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%r14, %rdi
.LEHB500:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE500:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3380
	call	_ZdlPv@PLT
.L3380:
	movl	$14, %edx
	leaq	.LC137(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB501:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$14, %edx
	leaq	.LC137(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	leaq	12432(%rsp), %r13
	movq	16(%rsp), %rsi
	movq	%r14, %rdx
	movq	%r13, %rdi
	call	_ZmlRK19quantumSparseMatrixS1_
.LEHE501:
	movl	$10, %edx
	leaq	.LC138(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB502:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$10, %edx
	leaq	.LC138(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE502:
	movq	24(%rsp), %rsi
	movq	%r12, %rdi
.LEHB503:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE503:
	movq	40(%rsp), %rdi
	movq	%rbp, %rdx
	movq	%r12, %rsi
.LEHB504:
	call	_Z11checkResultB5cxx1119quantumSparseMatrixS_
.LEHE504:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movl	$3, %edx
	leaq	.LC117(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB505:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	12824(%rsp), %rdx
	movq	12816(%rsp), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	%rax, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE505:
	jmp	.L4502
.L4518:
.LEHB506:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE506:
.L4515:
.LEHB507:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE507:
.L4511:
.LEHB508:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE508:
.L4517:
.LEHB509:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE509:
.L4513:
.LEHB510:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE510:
.L4509:
	call	__stack_chk_fail@PLT
.L3893:
	endbr64
	movq	%rax, %rbx
	leaq	12656(%rsp), %rbp
	jmp	.L3321
.L3749:
	endbr64
	movq	%rax, %rbp
	leaq	1200(%rsp), %r15
	jmp	.L3743
.L3911:
	endbr64
	movq	%rax, %rbx
	jmp	.L3460
.L3748:
	endbr64
	movq	%rax, %rbp
	leaq	1200(%rsp), %r15
	jmp	.L3744
.L3912:
	endbr64
	movq	%rax, %rbx
	jmp	.L3458
.L3953:
	endbr64
	movq	%rax, %rbx
	jmp	.L3522
.L3952:
	endbr64
	movq	%rax, %rbx
	jmp	.L3524
.L3934:
	endbr64
	movq	%rax, %rbx
	jmp	.L3494
.L3933:
	endbr64
	movq	%rax, %rbx
	jmp	.L3496
.L3951:
	endbr64
	movq	%rax, %rbx
	jmp	.L3519
.L3950:
	endbr64
	movq	%rax, %rbx
	jmp	.L3521
.L3949:
	endbr64
	movq	%rax, %rbx
	jmp	.L3516
.L3948:
	endbr64
	movq	%rax, %rbx
	jmp	.L3518
.L3960:
	endbr64
	movq	%rax, %rbx
	jmp	.L3533
.L3957:
	endbr64
	movq	%rax, %rbx
	jmp	.L3525
.L3944:
	endbr64
	movq	%rax, %rbx
	jmp	.L3507
.L3955:
	endbr64
	movq	%rax, %rbx
	jmp	.L3527
.L3959:
	endbr64
	movq	%rax, %rbx
	jmp	.L3534
.L3956:
	endbr64
	movq	%rax, %rbx
	jmp	.L3526
.L3958:
	endbr64
	movq	%rax, %rbx
	jmp	.L3528
.L3954:
	endbr64
	movq	%rax, %rbx
	jmp	.L3530
.L3947:
	endbr64
	movq	%rax, %rbx
	jmp	.L3513
.L3946:
	endbr64
	movq	%rax, %rbx
	jmp	.L3514
.L3945:
	endbr64
	movq	%rax, %rbx
	jmp	.L3515
.L3943:
	endbr64
	movq	%rax, %rbx
	jmp	.L3508
.L3972:
	endbr64
	movq	%rax, %rbx
	jmp	.L3548
.L3971:
	endbr64
	movq	%rax, %rbx
	jmp	.L3549
.L3970:
	endbr64
	movq	%rax, %rbx
	jmp	.L3544
.L3969:
	endbr64
	movq	%rax, %rbx
	jmp	.L3545
.L3968:
	endbr64
	movq	%rax, %rbx
	jmp	.L3546
.L3967:
	endbr64
	movq	%rax, %rbx
	jmp	.L3541
.L3966:
	endbr64
	movq	%rax, %rbx
	jmp	.L3543
.L3965:
	endbr64
	movq	%rax, %rbx
	jmp	.L3538
.L3964:
	endbr64
	movq	%rax, %rbx
	jmp	.L3540
.L3963:
	endbr64
	movq	%rax, %rbx
	jmp	.L3535
.L3962:
	endbr64
	movq	%rax, %rbx
	jmp	.L3537
.L3961:
	endbr64
	movq	%rax, %rbx
	jmp	.L3532
.L3974:
	endbr64
	movq	%rax, %rbx
	jmp	.L3550
.L3973:
	endbr64
	movq	%rax, %rbx
	jmp	.L3547
.L3925:
	endbr64
	movq	%rax, %rbx
	jmp	.L3479
.L3924:
	endbr64
	movq	%rax, %rbx
	jmp	.L3481
.L3861:
	endbr64
	movq	%rax, %rbx
	jmp	.L3598
.L3860:
	endbr64
	movq	%rax, %rbx
	jmp	.L3600
.L3859:
	endbr64
	movq	%rax, %rbx
	jmp	.L3601
.L3858:
	endbr64
	movq	%rax, %rbx
	jmp	.L3603
.L3918:
	endbr64
	movq	%rax, %rbx
	jmp	.L3471
.L3917:
	endbr64
	movq	%rax, %rbx
	jmp	.L3477
.L3916:
	endbr64
	movq	%rax, %rbx
	jmp	.L3465
.L3915:
	endbr64
	movq	%rax, %rbx
	jmp	.L3467
.L3929:
	endbr64
	movq	%rax, %rbx
	jmp	.L3482
.L3927:
	endbr64
	movq	%rax, %rbx
	jmp	.L3486
.L3928:
	endbr64
	movq	%rax, %rbx
	jmp	.L3484
.L3926:
	endbr64
	movq	%rax, %rbx
	jmp	.L3488
.L3857:
	endbr64
	movq	%rax, %rbx
	jmp	.L3604
.L3856:
	endbr64
	movq	%rax, %rbx
	jmp	.L3606
.L3855:
	endbr64
	movq	%rax, %rbx
	jmp	.L3607
.L3854:
	endbr64
	movq	%rax, %rbx
	jmp	.L3609
.L3853:
	endbr64
	movq	%rax, %rbx
	jmp	.L3610
.L3852:
	endbr64
	movq	%rax, %rbx
	jmp	.L3612
.L3851:
	endbr64
	movq	%rax, %rbx
	jmp	.L3613
.L3850:
	endbr64
	movq	%rax, %rbx
	jmp	.L3615
.L3849:
	endbr64
	movq	%rax, %rbx
	jmp	.L3616
.L3848:
	endbr64
	movq	%rax, %rbx
	jmp	.L3618
.L3847:
	endbr64
	movq	%rax, %rbx
	jmp	.L3619
.L3846:
	endbr64
	movq	%rax, %rbx
	jmp	.L3621
.L3845:
	endbr64
	movq	%rax, %rbx
	jmp	.L3622
.L3844:
	endbr64
	movq	%rax, %rbx
	jmp	.L3624
.L3843:
	endbr64
	movq	%rax, %rbx
	jmp	.L3625
.L3842:
	endbr64
	movq	%rax, %rbx
	jmp	.L3627
.L3841:
	endbr64
	movq	%rax, %rbx
	jmp	.L3628
.L3840:
	endbr64
	movq	%rax, %rbx
	jmp	.L3630
.L3839:
	endbr64
	movq	%rax, %rbx
	jmp	.L3631
.L3838:
	endbr64
	movq	%rax, %rbx
	jmp	.L3633
.L3837:
	endbr64
	movq	%rax, %rbx
	jmp	.L3634
.L3836:
	endbr64
	movq	%rax, %rbx
	jmp	.L3636
.L3835:
	endbr64
	movq	%rax, %rbx
	jmp	.L3637
.L3834:
	endbr64
	movq	%rax, %rbx
	jmp	.L3639
.L3833:
	endbr64
	movq	%rax, %rbx
	jmp	.L3640
.L3832:
	endbr64
	movq	%rax, %rbx
	jmp	.L3642
.L3831:
	endbr64
	movq	%rax, %rbx
	jmp	.L3643
.L3830:
	endbr64
	movq	%rax, %rbx
	jmp	.L3645
.L3829:
	endbr64
	movq	%rax, %rbx
	jmp	.L3646
.L3828:
	endbr64
	movq	%rax, %rbx
	jmp	.L3648
.L3827:
	endbr64
	movq	%rax, %rbx
	jmp	.L3649
.L3826:
	endbr64
	movq	%rax, %rbx
	jmp	.L3651
.L3825:
	endbr64
	movq	%rax, %rbx
	jmp	.L3652
.L3824:
	endbr64
	movq	%rax, %rbx
	jmp	.L3654
.L3823:
	endbr64
	movq	%rax, %rbx
	jmp	.L3655
.L3822:
	endbr64
	movq	%rax, %rbx
	jmp	.L3657
.L3821:
	endbr64
	movq	%rax, %rbx
	jmp	.L3658
.L3820:
	endbr64
	movq	%rax, %rbx
	jmp	.L3660
.L3819:
	endbr64
	movq	%rax, %rbx
	jmp	.L3661
.L3818:
	endbr64
	movq	%rax, %rbx
	jmp	.L3663
.L3817:
	endbr64
	movq	%rax, %rbx
	jmp	.L3664
.L3816:
	endbr64
	movq	%rax, %rbx
	jmp	.L3666
.L3815:
	endbr64
	movq	%rax, %rbx
	jmp	.L3667
.L3814:
	endbr64
	movq	%rax, %rbx
	jmp	.L3669
.L3813:
	endbr64
	movq	%rax, %rbx
	jmp	.L3670
.L3812:
	endbr64
	movq	%rax, %rbx
	jmp	.L3672
.L3811:
	endbr64
	movq	%rax, %rbx
	jmp	.L3673
.L3810:
	endbr64
	movq	%rax, %rbx
	jmp	.L3675
.L3932:
	endbr64
	movq	%rax, %rbx
	jmp	.L3511
.L3931:
	endbr64
	movq	%rax, %rbx
	jmp	.L3490
.L3930:
	endbr64
	movq	%rax, %rbx
	jmp	.L3492
.L3923:
	endbr64
	movq	%rax, %rbx
	jmp	.L3472
.L3922:
	endbr64
	movq	%rax, %rbx
	jmp	.L3473
.L3921:
	endbr64
	movq	%rax, %rbx
	jmp	.L3475
.L3920:
	endbr64
	movq	%rax, %rbx
	jmp	.L3468
.L3919:
	endbr64
	movq	%rax, %rbx
	jmp	.L3469
.L3942:
	endbr64
	movq	%rax, %rbx
	jmp	.L3503
.L3938:
	endbr64
	movq	%rax, %rbx
	jmp	.L3497
.L3940:
	endbr64
	movq	%rax, %rbx
	jmp	.L3506
.L3937:
	endbr64
	movq	%rax, %rbx
	jmp	.L3498
.L3936:
	endbr64
	movq	%rax, %rbx
	jmp	.L3500
.L3935:
	endbr64
	movq	%rax, %rbx
	jmp	.L3493
.L3941:
	endbr64
	movq	%rax, %rbx
	jmp	.L3504
.L3939:
	endbr64
	movq	%rax, %rbx
	jmp	.L3501
.L3777:
	endbr64
	movq	%rax, %rbp
	jmp	.L3715
.L3769:
	endbr64
	movq	%rax, %rbp
	jmp	.L3723
.L3768:
	endbr64
	movq	%rax, %rbp
	jmp	.L3724
.L3767:
	endbr64
	movq	%rax, %rbp
	jmp	.L3725
.L3766:
	endbr64
	movq	%rax, %rbp
	jmp	.L3726
.L3908:
	endbr64
	movq	%rax, %rbx
	jmp	.L3456
.L3909:
	endbr64
	movq	%rax, %rbx
	jmp	.L3454
.L3910:
	endbr64
	movq	%rax, %rbx
	jmp	.L3463
.L3913:
	endbr64
	movq	%rax, %rbx
	jmp	.L3457
.L3773:
	endbr64
	movq	%rax, %rbp
	jmp	.L3719
.L3772:
	endbr64
	movq	%rax, %rbp
	jmp	.L3720
.L3771:
	endbr64
	movq	%rax, %rbp
	jmp	.L3721
.L3770:
	endbr64
	movq	%rax, %rbp
	jmp	.L3722
.L3775:
	endbr64
	movq	%rax, %rbp
	jmp	.L3717
.L3774:
	endbr64
	movq	%rax, %rbp
	jmp	.L3718
.L3776:
	endbr64
	movq	%rax, %rbp
	jmp	.L3716
.L3904:
	endbr64
	movq	%rax, %rbx
	jmp	.L3451
.L3905:
	endbr64
	movq	%rax, %rbx
	jmp	.L3450
.L3906:
	endbr64
	movq	%rax, %rbx
	jmp	.L3449
.L3907:
	endbr64
	movq	%rax, %rbx
	jmp	.L3452
.L3896:
	endbr64
	movq	%rax, %rbx
	jmp	.L3437
.L3898:
	endbr64
	movq	%rax, %rbx
	jmp	.L3440
.L3897:
	endbr64
	movq	%rax, %rbx
	jmp	.L3442
.L3899:
	endbr64
	movq	%rax, %rbx
	jmp	.L3445
.L3894:
	endbr64
	movq	%rax, %rbx
	jmp	.L3436
.L3895:
	endbr64
	movq	%rax, %rbx
	jmp	.L3439
.L3976:
	endbr64
	movq	%rax, %rbx
	jmp	.L3319
.L3975:
	endbr64
	movq	%rax, %rbx
	jmp	.L3307
.L3797:
	endbr64
	movq	%rax, %rbx
	jmp	.L3694
.L3796:
	endbr64
	movq	%rax, %rbp
	jmp	.L3696
.L3795:
	endbr64
	movq	%rax, %rbp
	jmp	.L3697
.L3794:
	endbr64
	movq	%rax, %rbp
	jmp	.L3698
.L3793:
	endbr64
	movq	%rax, %rbp
	jmp	.L3699
.L3792:
	endbr64
	movq	%rax, %rbp
	jmp	.L3700
.L3791:
	endbr64
	movq	%rax, %rbp
	jmp	.L3701
.L3790:
	endbr64
	movq	%rax, %rbp
	jmp	.L3702
.L3789:
	endbr64
	movq	%rax, %rbp
	jmp	.L3703
.L3788:
	endbr64
	movq	%rax, %rbp
	jmp	.L3704
.L3787:
	endbr64
	movq	%rax, %rbp
	jmp	.L3705
.L3786:
	endbr64
	movq	%rax, %rbp
	jmp	.L3706
.L3785:
	endbr64
	movq	%rax, %rbp
	jmp	.L3707
.L3784:
	endbr64
	movq	%rax, %rbp
	jmp	.L3708
.L3783:
	endbr64
	movq	%rax, %rbp
	jmp	.L3709
.L3782:
	endbr64
	movq	%rax, %rbp
	jmp	.L3710
.L3781:
	endbr64
	movq	%rax, %rbp
	jmp	.L3711
.L3780:
	endbr64
	movq	%rax, %rbp
	jmp	.L3712
.L3779:
	endbr64
	movq	%rax, %rbp
	jmp	.L3713
.L3778:
	endbr64
	movq	%rax, %rbp
	jmp	.L3714
.L3809:
	endbr64
	movq	%rax, %rbx
	jmp	.L3676
.L3808:
	endbr64
	movq	%rax, %rbx
	jmp	.L3678
.L3807:
	endbr64
	movq	%rax, %rbx
	jmp	.L3679
.L3806:
	endbr64
	movq	%rax, %rbx
	jmp	.L3681
.L3805:
	endbr64
	movq	%rax, %rbx
	jmp	.L3682
.L3804:
	endbr64
	movq	%rax, %rbx
	jmp	.L3684
.L3803:
	endbr64
	movq	%rax, %rbx
	jmp	.L3685
.L3802:
	endbr64
	movq	%rax, %rbx
	jmp	.L3687
.L3801:
	endbr64
	movq	%rax, %rbx
	jmp	.L3688
.L3800:
	endbr64
	movq	%rax, %rbx
	jmp	.L3690
.L3799:
	endbr64
	movq	%rax, %rbx
	jmp	.L3691
.L3798:
	endbr64
	movq	%rax, %rbx
	jmp	.L3693
.L3877:
	endbr64
	movq	%rax, %rbx
	jmp	.L3574
.L3876:
	endbr64
	movq	%rax, %rbx
	jmp	.L3576
.L3875:
	endbr64
	movq	%rax, %rbx
	jmp	.L3577
.L3874:
	endbr64
	movq	%rax, %rbx
	jmp	.L3579
.L3873:
	endbr64
	movq	%rax, %rbx
	jmp	.L3580
.L3872:
	endbr64
	movq	%rax, %rbx
	jmp	.L3582
.L3871:
	endbr64
	movq	%rax, %rbx
	jmp	.L3583
.L3870:
	endbr64
	movq	%rax, %rbx
	jmp	.L3585
.L3869:
	endbr64
	movq	%rax, %rbx
	jmp	.L3586
.L3868:
	endbr64
	movq	%rax, %rbx
	jmp	.L3588
.L3867:
	endbr64
	movq	%rax, %rbx
	jmp	.L3589
.L3866:
	endbr64
	movq	%rax, %rbx
	jmp	.L3591
.L3865:
	endbr64
	movq	%rax, %rbx
	jmp	.L3592
.L3864:
	endbr64
	movq	%rax, %rbx
	jmp	.L3594
.L3863:
	endbr64
	movq	%rax, %rbx
	jmp	.L3595
.L3862:
	endbr64
	movq	%rax, %rbx
	jmp	.L3597
.L3885:
	endbr64
	movq	%rax, %rbx
	jmp	.L3562
.L3884:
	endbr64
	movq	%rax, %rbx
	jmp	.L3564
.L3883:
	endbr64
	movq	%rax, %rbx
	jmp	.L3565
.L3882:
	endbr64
	movq	%rax, %rbx
	jmp	.L3567
.L3881:
	endbr64
	movq	%rax, %rbx
	jmp	.L3568
.L3880:
	endbr64
	movq	%rax, %rbx
	jmp	.L3570
.L3879:
	endbr64
	movq	%rax, %rbx
	jmp	.L3571
.L3878:
	endbr64
	movq	%rax, %rbx
	jmp	.L3573
.L3889:
	endbr64
	movq	%rax, %rbx
	jmp	.L3556
.L3888:
	endbr64
	movq	%rax, %rbx
	jmp	.L3558
.L3887:
	endbr64
	movq	%rax, %rbx
	jmp	.L3559
.L3886:
	endbr64
	movq	%rax, %rbx
	jmp	.L3561
.L3891:
	endbr64
	movq	%rax, %rbx
	jmp	.L3553
.L3890:
	endbr64
	movq	%rax, %rbx
	jmp	.L3555
.L3892:
	endbr64
	movq	%rax, %rbx
	jmp	.L3309
.L3914:
	endbr64
	movq	%rax, %rbx
	jmp	.L3461
.L3765:
	endbr64
	movq	%rax, %rbp
	jmp	.L3727
.L3763:
	endbr64
	movq	%rax, %rbp
	jmp	.L3729
.L3762:
	endbr64
	movq	%rax, %rbp
	jmp	.L3730
.L3764:
	endbr64
	movq	%rax, %rbp
	jmp	.L3728
.L3761:
	endbr64
	movq	%rax, %rbp
	jmp	.L3731
.L3760:
	endbr64
	movq	%rax, %rbp
	jmp	.L3732
.L3759:
	endbr64
	movq	%rax, %rbp
	jmp	.L3733
.L3758:
	endbr64
	movq	%rax, %rbp
	jmp	.L3734
.L3757:
	endbr64
	movq	%rax, %rbp
	jmp	.L3735
.L3756:
	endbr64
	movq	%rax, %rbp
	jmp	.L3736
.L3755:
	endbr64
	movq	%rax, %rbp
	jmp	.L3737
.L3754:
	endbr64
	movq	%rax, %rbp
	jmp	.L3738
.L3753:
	endbr64
	movq	%rax, %rbp
	jmp	.L3739
.L3752:
	endbr64
	movq	%rax, %rbp
	jmp	.L3740
.L3751:
	endbr64
	movq	%rax, %rbp
	jmp	.L3741
.L3750:
	endbr64
	movq	%rax, %rbp
	jmp	.L3742
.L3900:
	endbr64
	movq	%rax, %rbx
	jmp	.L3443
.L3901:
	endbr64
	movq	%rax, %rbx
	jmp	.L3448
.L3902:
	endbr64
	movq	%rax, %rbx
	jmp	.L3447
.L3903:
	endbr64
	movq	%rax, %rbx
	jmp	.L3446
	.section	.gcc_except_table
.LLSDA8759:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8759-.LLSDACSB8759
.LLSDACSB8759:
	.uleb128 .LEHB268-.LFB8759
	.uleb128 .LEHE268-.LEHB268
	.uleb128 .L3748-.LFB8759
	.uleb128 0
	.uleb128 .LEHB269-.LFB8759
	.uleb128 .LEHE269-.LEHB269
	.uleb128 .L3749-.LFB8759
	.uleb128 0
	.uleb128 .LEHB270-.LFB8759
	.uleb128 .LEHE270-.LEHB270
	.uleb128 .L3750-.LFB8759
	.uleb128 0
	.uleb128 .LEHB271-.LFB8759
	.uleb128 .LEHE271-.LEHB271
	.uleb128 .L3751-.LFB8759
	.uleb128 0
	.uleb128 .LEHB272-.LFB8759
	.uleb128 .LEHE272-.LEHB272
	.uleb128 .L3752-.LFB8759
	.uleb128 0
	.uleb128 .LEHB273-.LFB8759
	.uleb128 .LEHE273-.LEHB273
	.uleb128 .L3753-.LFB8759
	.uleb128 0
	.uleb128 .LEHB274-.LFB8759
	.uleb128 .LEHE274-.LEHB274
	.uleb128 .L3754-.LFB8759
	.uleb128 0
	.uleb128 .LEHB275-.LFB8759
	.uleb128 .LEHE275-.LEHB275
	.uleb128 .L3755-.LFB8759
	.uleb128 0
	.uleb128 .LEHB276-.LFB8759
	.uleb128 .LEHE276-.LEHB276
	.uleb128 .L3756-.LFB8759
	.uleb128 0
	.uleb128 .LEHB277-.LFB8759
	.uleb128 .LEHE277-.LEHB277
	.uleb128 .L3757-.LFB8759
	.uleb128 0
	.uleb128 .LEHB278-.LFB8759
	.uleb128 .LEHE278-.LEHB278
	.uleb128 .L3758-.LFB8759
	.uleb128 0
	.uleb128 .LEHB279-.LFB8759
	.uleb128 .LEHE279-.LEHB279
	.uleb128 .L3759-.LFB8759
	.uleb128 0
	.uleb128 .LEHB280-.LFB8759
	.uleb128 .LEHE280-.LEHB280
	.uleb128 .L3760-.LFB8759
	.uleb128 0
	.uleb128 .LEHB281-.LFB8759
	.uleb128 .LEHE281-.LEHB281
	.uleb128 .L3761-.LFB8759
	.uleb128 0
	.uleb128 .LEHB282-.LFB8759
	.uleb128 .LEHE282-.LEHB282
	.uleb128 .L3762-.LFB8759
	.uleb128 0
	.uleb128 .LEHB283-.LFB8759
	.uleb128 .LEHE283-.LEHB283
	.uleb128 .L3763-.LFB8759
	.uleb128 0
	.uleb128 .LEHB284-.LFB8759
	.uleb128 .LEHE284-.LEHB284
	.uleb128 .L3764-.LFB8759
	.uleb128 0
	.uleb128 .LEHB285-.LFB8759
	.uleb128 .LEHE285-.LEHB285
	.uleb128 .L3765-.LFB8759
	.uleb128 0
	.uleb128 .LEHB286-.LFB8759
	.uleb128 .LEHE286-.LEHB286
	.uleb128 .L3766-.LFB8759
	.uleb128 0
	.uleb128 .LEHB287-.LFB8759
	.uleb128 .LEHE287-.LEHB287
	.uleb128 .L3767-.LFB8759
	.uleb128 0
	.uleb128 .LEHB288-.LFB8759
	.uleb128 .LEHE288-.LEHB288
	.uleb128 .L3768-.LFB8759
	.uleb128 0
	.uleb128 .LEHB289-.LFB8759
	.uleb128 .LEHE289-.LEHB289
	.uleb128 .L3769-.LFB8759
	.uleb128 0
	.uleb128 .LEHB290-.LFB8759
	.uleb128 .LEHE290-.LEHB290
	.uleb128 .L3770-.LFB8759
	.uleb128 0
	.uleb128 .LEHB291-.LFB8759
	.uleb128 .LEHE291-.LEHB291
	.uleb128 .L3771-.LFB8759
	.uleb128 0
	.uleb128 .LEHB292-.LFB8759
	.uleb128 .LEHE292-.LEHB292
	.uleb128 .L3772-.LFB8759
	.uleb128 0
	.uleb128 .LEHB293-.LFB8759
	.uleb128 .LEHE293-.LEHB293
	.uleb128 .L3773-.LFB8759
	.uleb128 0
	.uleb128 .LEHB294-.LFB8759
	.uleb128 .LEHE294-.LEHB294
	.uleb128 .L3774-.LFB8759
	.uleb128 0
	.uleb128 .LEHB295-.LFB8759
	.uleb128 .LEHE295-.LEHB295
	.uleb128 .L3775-.LFB8759
	.uleb128 0
	.uleb128 .LEHB296-.LFB8759
	.uleb128 .LEHE296-.LEHB296
	.uleb128 .L3776-.LFB8759
	.uleb128 0
	.uleb128 .LEHB297-.LFB8759
	.uleb128 .LEHE297-.LEHB297
	.uleb128 .L3777-.LFB8759
	.uleb128 0
	.uleb128 .LEHB298-.LFB8759
	.uleb128 .LEHE298-.LEHB298
	.uleb128 .L3778-.LFB8759
	.uleb128 0
	.uleb128 .LEHB299-.LFB8759
	.uleb128 .LEHE299-.LEHB299
	.uleb128 .L3779-.LFB8759
	.uleb128 0
	.uleb128 .LEHB300-.LFB8759
	.uleb128 .LEHE300-.LEHB300
	.uleb128 .L3780-.LFB8759
	.uleb128 0
	.uleb128 .LEHB301-.LFB8759
	.uleb128 .LEHE301-.LEHB301
	.uleb128 .L3781-.LFB8759
	.uleb128 0
	.uleb128 .LEHB302-.LFB8759
	.uleb128 .LEHE302-.LEHB302
	.uleb128 .L3782-.LFB8759
	.uleb128 0
	.uleb128 .LEHB303-.LFB8759
	.uleb128 .LEHE303-.LEHB303
	.uleb128 .L3783-.LFB8759
	.uleb128 0
	.uleb128 .LEHB304-.LFB8759
	.uleb128 .LEHE304-.LEHB304
	.uleb128 .L3784-.LFB8759
	.uleb128 0
	.uleb128 .LEHB305-.LFB8759
	.uleb128 .LEHE305-.LEHB305
	.uleb128 .L3785-.LFB8759
	.uleb128 0
	.uleb128 .LEHB306-.LFB8759
	.uleb128 .LEHE306-.LEHB306
	.uleb128 .L3786-.LFB8759
	.uleb128 0
	.uleb128 .LEHB307-.LFB8759
	.uleb128 .LEHE307-.LEHB307
	.uleb128 .L3787-.LFB8759
	.uleb128 0
	.uleb128 .LEHB308-.LFB8759
	.uleb128 .LEHE308-.LEHB308
	.uleb128 .L3788-.LFB8759
	.uleb128 0
	.uleb128 .LEHB309-.LFB8759
	.uleb128 .LEHE309-.LEHB309
	.uleb128 .L3789-.LFB8759
	.uleb128 0
	.uleb128 .LEHB310-.LFB8759
	.uleb128 .LEHE310-.LEHB310
	.uleb128 .L3790-.LFB8759
	.uleb128 0
	.uleb128 .LEHB311-.LFB8759
	.uleb128 .LEHE311-.LEHB311
	.uleb128 .L3791-.LFB8759
	.uleb128 0
	.uleb128 .LEHB312-.LFB8759
	.uleb128 .LEHE312-.LEHB312
	.uleb128 .L3792-.LFB8759
	.uleb128 0
	.uleb128 .LEHB313-.LFB8759
	.uleb128 .LEHE313-.LEHB313
	.uleb128 .L3793-.LFB8759
	.uleb128 0
	.uleb128 .LEHB314-.LFB8759
	.uleb128 .LEHE314-.LEHB314
	.uleb128 .L3794-.LFB8759
	.uleb128 0
	.uleb128 .LEHB315-.LFB8759
	.uleb128 .LEHE315-.LEHB315
	.uleb128 .L3795-.LFB8759
	.uleb128 0
	.uleb128 .LEHB316-.LFB8759
	.uleb128 .LEHE316-.LEHB316
	.uleb128 .L3796-.LFB8759
	.uleb128 0
	.uleb128 .LEHB317-.LFB8759
	.uleb128 .LEHE317-.LEHB317
	.uleb128 .L3797-.LFB8759
	.uleb128 0
	.uleb128 .LEHB318-.LFB8759
	.uleb128 .LEHE318-.LEHB318
	.uleb128 .L3798-.LFB8759
	.uleb128 0
	.uleb128 .LEHB319-.LFB8759
	.uleb128 .LEHE319-.LEHB319
	.uleb128 .L3799-.LFB8759
	.uleb128 0
	.uleb128 .LEHB320-.LFB8759
	.uleb128 .LEHE320-.LEHB320
	.uleb128 .L3800-.LFB8759
	.uleb128 0
	.uleb128 .LEHB321-.LFB8759
	.uleb128 .LEHE321-.LEHB321
	.uleb128 .L3801-.LFB8759
	.uleb128 0
	.uleb128 .LEHB322-.LFB8759
	.uleb128 .LEHE322-.LEHB322
	.uleb128 .L3802-.LFB8759
	.uleb128 0
	.uleb128 .LEHB323-.LFB8759
	.uleb128 .LEHE323-.LEHB323
	.uleb128 .L3803-.LFB8759
	.uleb128 0
	.uleb128 .LEHB324-.LFB8759
	.uleb128 .LEHE324-.LEHB324
	.uleb128 .L3804-.LFB8759
	.uleb128 0
	.uleb128 .LEHB325-.LFB8759
	.uleb128 .LEHE325-.LEHB325
	.uleb128 .L3805-.LFB8759
	.uleb128 0
	.uleb128 .LEHB326-.LFB8759
	.uleb128 .LEHE326-.LEHB326
	.uleb128 .L3806-.LFB8759
	.uleb128 0
	.uleb128 .LEHB327-.LFB8759
	.uleb128 .LEHE327-.LEHB327
	.uleb128 .L3807-.LFB8759
	.uleb128 0
	.uleb128 .LEHB328-.LFB8759
	.uleb128 .LEHE328-.LEHB328
	.uleb128 .L3808-.LFB8759
	.uleb128 0
	.uleb128 .LEHB329-.LFB8759
	.uleb128 .LEHE329-.LEHB329
	.uleb128 .L3809-.LFB8759
	.uleb128 0
	.uleb128 .LEHB330-.LFB8759
	.uleb128 .LEHE330-.LEHB330
	.uleb128 .L3810-.LFB8759
	.uleb128 0
	.uleb128 .LEHB331-.LFB8759
	.uleb128 .LEHE331-.LEHB331
	.uleb128 .L3811-.LFB8759
	.uleb128 0
	.uleb128 .LEHB332-.LFB8759
	.uleb128 .LEHE332-.LEHB332
	.uleb128 .L3812-.LFB8759
	.uleb128 0
	.uleb128 .LEHB333-.LFB8759
	.uleb128 .LEHE333-.LEHB333
	.uleb128 .L3813-.LFB8759
	.uleb128 0
	.uleb128 .LEHB334-.LFB8759
	.uleb128 .LEHE334-.LEHB334
	.uleb128 .L3814-.LFB8759
	.uleb128 0
	.uleb128 .LEHB335-.LFB8759
	.uleb128 .LEHE335-.LEHB335
	.uleb128 .L3815-.LFB8759
	.uleb128 0
	.uleb128 .LEHB336-.LFB8759
	.uleb128 .LEHE336-.LEHB336
	.uleb128 .L3816-.LFB8759
	.uleb128 0
	.uleb128 .LEHB337-.LFB8759
	.uleb128 .LEHE337-.LEHB337
	.uleb128 .L3817-.LFB8759
	.uleb128 0
	.uleb128 .LEHB338-.LFB8759
	.uleb128 .LEHE338-.LEHB338
	.uleb128 .L3818-.LFB8759
	.uleb128 0
	.uleb128 .LEHB339-.LFB8759
	.uleb128 .LEHE339-.LEHB339
	.uleb128 .L3819-.LFB8759
	.uleb128 0
	.uleb128 .LEHB340-.LFB8759
	.uleb128 .LEHE340-.LEHB340
	.uleb128 .L3820-.LFB8759
	.uleb128 0
	.uleb128 .LEHB341-.LFB8759
	.uleb128 .LEHE341-.LEHB341
	.uleb128 .L3821-.LFB8759
	.uleb128 0
	.uleb128 .LEHB342-.LFB8759
	.uleb128 .LEHE342-.LEHB342
	.uleb128 .L3822-.LFB8759
	.uleb128 0
	.uleb128 .LEHB343-.LFB8759
	.uleb128 .LEHE343-.LEHB343
	.uleb128 .L3823-.LFB8759
	.uleb128 0
	.uleb128 .LEHB344-.LFB8759
	.uleb128 .LEHE344-.LEHB344
	.uleb128 .L3824-.LFB8759
	.uleb128 0
	.uleb128 .LEHB345-.LFB8759
	.uleb128 .LEHE345-.LEHB345
	.uleb128 .L3825-.LFB8759
	.uleb128 0
	.uleb128 .LEHB346-.LFB8759
	.uleb128 .LEHE346-.LEHB346
	.uleb128 .L3826-.LFB8759
	.uleb128 0
	.uleb128 .LEHB347-.LFB8759
	.uleb128 .LEHE347-.LEHB347
	.uleb128 .L3827-.LFB8759
	.uleb128 0
	.uleb128 .LEHB348-.LFB8759
	.uleb128 .LEHE348-.LEHB348
	.uleb128 .L3828-.LFB8759
	.uleb128 0
	.uleb128 .LEHB349-.LFB8759
	.uleb128 .LEHE349-.LEHB349
	.uleb128 .L3829-.LFB8759
	.uleb128 0
	.uleb128 .LEHB350-.LFB8759
	.uleb128 .LEHE350-.LEHB350
	.uleb128 .L3830-.LFB8759
	.uleb128 0
	.uleb128 .LEHB351-.LFB8759
	.uleb128 .LEHE351-.LEHB351
	.uleb128 .L3831-.LFB8759
	.uleb128 0
	.uleb128 .LEHB352-.LFB8759
	.uleb128 .LEHE352-.LEHB352
	.uleb128 .L3832-.LFB8759
	.uleb128 0
	.uleb128 .LEHB353-.LFB8759
	.uleb128 .LEHE353-.LEHB353
	.uleb128 .L3833-.LFB8759
	.uleb128 0
	.uleb128 .LEHB354-.LFB8759
	.uleb128 .LEHE354-.LEHB354
	.uleb128 .L3834-.LFB8759
	.uleb128 0
	.uleb128 .LEHB355-.LFB8759
	.uleb128 .LEHE355-.LEHB355
	.uleb128 .L3835-.LFB8759
	.uleb128 0
	.uleb128 .LEHB356-.LFB8759
	.uleb128 .LEHE356-.LEHB356
	.uleb128 .L3836-.LFB8759
	.uleb128 0
	.uleb128 .LEHB357-.LFB8759
	.uleb128 .LEHE357-.LEHB357
	.uleb128 .L3837-.LFB8759
	.uleb128 0
	.uleb128 .LEHB358-.LFB8759
	.uleb128 .LEHE358-.LEHB358
	.uleb128 .L3838-.LFB8759
	.uleb128 0
	.uleb128 .LEHB359-.LFB8759
	.uleb128 .LEHE359-.LEHB359
	.uleb128 .L3839-.LFB8759
	.uleb128 0
	.uleb128 .LEHB360-.LFB8759
	.uleb128 .LEHE360-.LEHB360
	.uleb128 .L3840-.LFB8759
	.uleb128 0
	.uleb128 .LEHB361-.LFB8759
	.uleb128 .LEHE361-.LEHB361
	.uleb128 .L3841-.LFB8759
	.uleb128 0
	.uleb128 .LEHB362-.LFB8759
	.uleb128 .LEHE362-.LEHB362
	.uleb128 .L3842-.LFB8759
	.uleb128 0
	.uleb128 .LEHB363-.LFB8759
	.uleb128 .LEHE363-.LEHB363
	.uleb128 .L3843-.LFB8759
	.uleb128 0
	.uleb128 .LEHB364-.LFB8759
	.uleb128 .LEHE364-.LEHB364
	.uleb128 .L3844-.LFB8759
	.uleb128 0
	.uleb128 .LEHB365-.LFB8759
	.uleb128 .LEHE365-.LEHB365
	.uleb128 .L3845-.LFB8759
	.uleb128 0
	.uleb128 .LEHB366-.LFB8759
	.uleb128 .LEHE366-.LEHB366
	.uleb128 .L3846-.LFB8759
	.uleb128 0
	.uleb128 .LEHB367-.LFB8759
	.uleb128 .LEHE367-.LEHB367
	.uleb128 .L3847-.LFB8759
	.uleb128 0
	.uleb128 .LEHB368-.LFB8759
	.uleb128 .LEHE368-.LEHB368
	.uleb128 .L3848-.LFB8759
	.uleb128 0
	.uleb128 .LEHB369-.LFB8759
	.uleb128 .LEHE369-.LEHB369
	.uleb128 .L3849-.LFB8759
	.uleb128 0
	.uleb128 .LEHB370-.LFB8759
	.uleb128 .LEHE370-.LEHB370
	.uleb128 .L3850-.LFB8759
	.uleb128 0
	.uleb128 .LEHB371-.LFB8759
	.uleb128 .LEHE371-.LEHB371
	.uleb128 .L3851-.LFB8759
	.uleb128 0
	.uleb128 .LEHB372-.LFB8759
	.uleb128 .LEHE372-.LEHB372
	.uleb128 .L3852-.LFB8759
	.uleb128 0
	.uleb128 .LEHB373-.LFB8759
	.uleb128 .LEHE373-.LEHB373
	.uleb128 .L3853-.LFB8759
	.uleb128 0
	.uleb128 .LEHB374-.LFB8759
	.uleb128 .LEHE374-.LEHB374
	.uleb128 .L3854-.LFB8759
	.uleb128 0
	.uleb128 .LEHB375-.LFB8759
	.uleb128 .LEHE375-.LEHB375
	.uleb128 .L3855-.LFB8759
	.uleb128 0
	.uleb128 .LEHB376-.LFB8759
	.uleb128 .LEHE376-.LEHB376
	.uleb128 .L3856-.LFB8759
	.uleb128 0
	.uleb128 .LEHB377-.LFB8759
	.uleb128 .LEHE377-.LEHB377
	.uleb128 .L3857-.LFB8759
	.uleb128 0
	.uleb128 .LEHB378-.LFB8759
	.uleb128 .LEHE378-.LEHB378
	.uleb128 .L3858-.LFB8759
	.uleb128 0
	.uleb128 .LEHB379-.LFB8759
	.uleb128 .LEHE379-.LEHB379
	.uleb128 .L3859-.LFB8759
	.uleb128 0
	.uleb128 .LEHB380-.LFB8759
	.uleb128 .LEHE380-.LEHB380
	.uleb128 .L3860-.LFB8759
	.uleb128 0
	.uleb128 .LEHB381-.LFB8759
	.uleb128 .LEHE381-.LEHB381
	.uleb128 .L3861-.LFB8759
	.uleb128 0
	.uleb128 .LEHB382-.LFB8759
	.uleb128 .LEHE382-.LEHB382
	.uleb128 .L3862-.LFB8759
	.uleb128 0
	.uleb128 .LEHB383-.LFB8759
	.uleb128 .LEHE383-.LEHB383
	.uleb128 .L3863-.LFB8759
	.uleb128 0
	.uleb128 .LEHB384-.LFB8759
	.uleb128 .LEHE384-.LEHB384
	.uleb128 .L3864-.LFB8759
	.uleb128 0
	.uleb128 .LEHB385-.LFB8759
	.uleb128 .LEHE385-.LEHB385
	.uleb128 .L3865-.LFB8759
	.uleb128 0
	.uleb128 .LEHB386-.LFB8759
	.uleb128 .LEHE386-.LEHB386
	.uleb128 .L3866-.LFB8759
	.uleb128 0
	.uleb128 .LEHB387-.LFB8759
	.uleb128 .LEHE387-.LEHB387
	.uleb128 .L3867-.LFB8759
	.uleb128 0
	.uleb128 .LEHB388-.LFB8759
	.uleb128 .LEHE388-.LEHB388
	.uleb128 .L3868-.LFB8759
	.uleb128 0
	.uleb128 .LEHB389-.LFB8759
	.uleb128 .LEHE389-.LEHB389
	.uleb128 .L3869-.LFB8759
	.uleb128 0
	.uleb128 .LEHB390-.LFB8759
	.uleb128 .LEHE390-.LEHB390
	.uleb128 .L3870-.LFB8759
	.uleb128 0
	.uleb128 .LEHB391-.LFB8759
	.uleb128 .LEHE391-.LEHB391
	.uleb128 .L3871-.LFB8759
	.uleb128 0
	.uleb128 .LEHB392-.LFB8759
	.uleb128 .LEHE392-.LEHB392
	.uleb128 .L3872-.LFB8759
	.uleb128 0
	.uleb128 .LEHB393-.LFB8759
	.uleb128 .LEHE393-.LEHB393
	.uleb128 .L3873-.LFB8759
	.uleb128 0
	.uleb128 .LEHB394-.LFB8759
	.uleb128 .LEHE394-.LEHB394
	.uleb128 .L3874-.LFB8759
	.uleb128 0
	.uleb128 .LEHB395-.LFB8759
	.uleb128 .LEHE395-.LEHB395
	.uleb128 .L3875-.LFB8759
	.uleb128 0
	.uleb128 .LEHB396-.LFB8759
	.uleb128 .LEHE396-.LEHB396
	.uleb128 .L3876-.LFB8759
	.uleb128 0
	.uleb128 .LEHB397-.LFB8759
	.uleb128 .LEHE397-.LEHB397
	.uleb128 .L3877-.LFB8759
	.uleb128 0
	.uleb128 .LEHB398-.LFB8759
	.uleb128 .LEHE398-.LEHB398
	.uleb128 .L3878-.LFB8759
	.uleb128 0
	.uleb128 .LEHB399-.LFB8759
	.uleb128 .LEHE399-.LEHB399
	.uleb128 .L3879-.LFB8759
	.uleb128 0
	.uleb128 .LEHB400-.LFB8759
	.uleb128 .LEHE400-.LEHB400
	.uleb128 .L3880-.LFB8759
	.uleb128 0
	.uleb128 .LEHB401-.LFB8759
	.uleb128 .LEHE401-.LEHB401
	.uleb128 .L3881-.LFB8759
	.uleb128 0
	.uleb128 .LEHB402-.LFB8759
	.uleb128 .LEHE402-.LEHB402
	.uleb128 .L3882-.LFB8759
	.uleb128 0
	.uleb128 .LEHB403-.LFB8759
	.uleb128 .LEHE403-.LEHB403
	.uleb128 .L3883-.LFB8759
	.uleb128 0
	.uleb128 .LEHB404-.LFB8759
	.uleb128 .LEHE404-.LEHB404
	.uleb128 .L3884-.LFB8759
	.uleb128 0
	.uleb128 .LEHB405-.LFB8759
	.uleb128 .LEHE405-.LEHB405
	.uleb128 .L3885-.LFB8759
	.uleb128 0
	.uleb128 .LEHB406-.LFB8759
	.uleb128 .LEHE406-.LEHB406
	.uleb128 .L3886-.LFB8759
	.uleb128 0
	.uleb128 .LEHB407-.LFB8759
	.uleb128 .LEHE407-.LEHB407
	.uleb128 .L3887-.LFB8759
	.uleb128 0
	.uleb128 .LEHB408-.LFB8759
	.uleb128 .LEHE408-.LEHB408
	.uleb128 .L3888-.LFB8759
	.uleb128 0
	.uleb128 .LEHB409-.LFB8759
	.uleb128 .LEHE409-.LEHB409
	.uleb128 .L3889-.LFB8759
	.uleb128 0
	.uleb128 .LEHB410-.LFB8759
	.uleb128 .LEHE410-.LEHB410
	.uleb128 .L3890-.LFB8759
	.uleb128 0
	.uleb128 .LEHB411-.LFB8759
	.uleb128 .LEHE411-.LEHB411
	.uleb128 .L3891-.LFB8759
	.uleb128 0
	.uleb128 .LEHB412-.LFB8759
	.uleb128 .LEHE412-.LEHB412
	.uleb128 .L3892-.LFB8759
	.uleb128 0
	.uleb128 .LEHB413-.LFB8759
	.uleb128 .LEHE413-.LEHB413
	.uleb128 .L3959-.LFB8759
	.uleb128 0
	.uleb128 .LEHB414-.LFB8759
	.uleb128 .LEHE414-.LEHB414
	.uleb128 .L3960-.LFB8759
	.uleb128 0
	.uleb128 .LEHB415-.LFB8759
	.uleb128 .LEHE415-.LEHB415
	.uleb128 .L3961-.LFB8759
	.uleb128 0
	.uleb128 .LEHB416-.LFB8759
	.uleb128 .LEHE416-.LEHB416
	.uleb128 .L3962-.LFB8759
	.uleb128 0
	.uleb128 .LEHB417-.LFB8759
	.uleb128 .LEHE417-.LEHB417
	.uleb128 .L3963-.LFB8759
	.uleb128 0
	.uleb128 .LEHB418-.LFB8759
	.uleb128 .LEHE418-.LEHB418
	.uleb128 .L3964-.LFB8759
	.uleb128 0
	.uleb128 .LEHB419-.LFB8759
	.uleb128 .LEHE419-.LEHB419
	.uleb128 .L3965-.LFB8759
	.uleb128 0
	.uleb128 .LEHB420-.LFB8759
	.uleb128 .LEHE420-.LEHB420
	.uleb128 .L3966-.LFB8759
	.uleb128 0
	.uleb128 .LEHB421-.LFB8759
	.uleb128 .LEHE421-.LEHB421
	.uleb128 .L3967-.LFB8759
	.uleb128 0
	.uleb128 .LEHB422-.LFB8759
	.uleb128 .LEHE422-.LEHB422
	.uleb128 .L3968-.LFB8759
	.uleb128 0
	.uleb128 .LEHB423-.LFB8759
	.uleb128 .LEHE423-.LEHB423
	.uleb128 .L3969-.LFB8759
	.uleb128 0
	.uleb128 .LEHB424-.LFB8759
	.uleb128 .LEHE424-.LEHB424
	.uleb128 .L3970-.LFB8759
	.uleb128 0
	.uleb128 .LEHB425-.LFB8759
	.uleb128 .LEHE425-.LEHB425
	.uleb128 .L3971-.LFB8759
	.uleb128 0
	.uleb128 .LEHB426-.LFB8759
	.uleb128 .LEHE426-.LEHB426
	.uleb128 .L3972-.LFB8759
	.uleb128 0
	.uleb128 .LEHB427-.LFB8759
	.uleb128 .LEHE427-.LEHB427
	.uleb128 .L3973-.LFB8759
	.uleb128 0
	.uleb128 .LEHB428-.LFB8759
	.uleb128 .LEHE428-.LEHB428
	.uleb128 .L3974-.LFB8759
	.uleb128 0
	.uleb128 .LEHB429-.LFB8759
	.uleb128 .LEHE429-.LEHB429
	.uleb128 .L3892-.LFB8759
	.uleb128 0
	.uleb128 .LEHB430-.LFB8759
	.uleb128 .LEHE430-.LEHB430
	.uleb128 .L3908-.LFB8759
	.uleb128 0
	.uleb128 .LEHB431-.LFB8759
	.uleb128 .LEHE431-.LEHB431
	.uleb128 .L3909-.LFB8759
	.uleb128 0
	.uleb128 .LEHB432-.LFB8759
	.uleb128 .LEHE432-.LEHB432
	.uleb128 .L3910-.LFB8759
	.uleb128 0
	.uleb128 .LEHB433-.LFB8759
	.uleb128 .LEHE433-.LEHB433
	.uleb128 .L3911-.LFB8759
	.uleb128 0
	.uleb128 .LEHB434-.LFB8759
	.uleb128 .LEHE434-.LEHB434
	.uleb128 .L3912-.LFB8759
	.uleb128 0
	.uleb128 .LEHB435-.LFB8759
	.uleb128 .LEHE435-.LEHB435
	.uleb128 .L3913-.LFB8759
	.uleb128 0
	.uleb128 .LEHB436-.LFB8759
	.uleb128 .LEHE436-.LEHB436
	.uleb128 .L3914-.LFB8759
	.uleb128 0
	.uleb128 .LEHB437-.LFB8759
	.uleb128 .LEHE437-.LEHB437
	.uleb128 .L3892-.LFB8759
	.uleb128 0
	.uleb128 .LEHB438-.LFB8759
	.uleb128 .LEHE438-.LEHB438
	.uleb128 .L3975-.LFB8759
	.uleb128 0
	.uleb128 .LEHB439-.LFB8759
	.uleb128 .LEHE439-.LEHB439
	.uleb128 .L3893-.LFB8759
	.uleb128 0
	.uleb128 .LEHB440-.LFB8759
	.uleb128 .LEHE440-.LEHB440
	.uleb128 .L3976-.LFB8759
	.uleb128 0
	.uleb128 .LEHB441-.LFB8759
	.uleb128 .LEHE441-.LEHB441
	.uleb128 .L3894-.LFB8759
	.uleb128 0
	.uleb128 .LEHB442-.LFB8759
	.uleb128 .LEHE442-.LEHB442
	.uleb128 .L3895-.LFB8759
	.uleb128 0
	.uleb128 .LEHB443-.LFB8759
	.uleb128 .LEHE443-.LEHB443
	.uleb128 .L3896-.LFB8759
	.uleb128 0
	.uleb128 .LEHB444-.LFB8759
	.uleb128 .LEHE444-.LEHB444
	.uleb128 .L3897-.LFB8759
	.uleb128 0
	.uleb128 .LEHB445-.LFB8759
	.uleb128 .LEHE445-.LEHB445
	.uleb128 .L3898-.LFB8759
	.uleb128 0
	.uleb128 .LEHB446-.LFB8759
	.uleb128 .LEHE446-.LEHB446
	.uleb128 .L3899-.LFB8759
	.uleb128 0
	.uleb128 .LEHB447-.LFB8759
	.uleb128 .LEHE447-.LEHB447
	.uleb128 .L3900-.LFB8759
	.uleb128 0
	.uleb128 .LEHB448-.LFB8759
	.uleb128 .LEHE448-.LEHB448
	.uleb128 .L3901-.LFB8759
	.uleb128 0
	.uleb128 .LEHB449-.LFB8759
	.uleb128 .LEHE449-.LEHB449
	.uleb128 .L3902-.LFB8759
	.uleb128 0
	.uleb128 .LEHB450-.LFB8759
	.uleb128 .LEHE450-.LEHB450
	.uleb128 .L3903-.LFB8759
	.uleb128 0
	.uleb128 .LEHB451-.LFB8759
	.uleb128 .LEHE451-.LEHB451
	.uleb128 .L3904-.LFB8759
	.uleb128 0
	.uleb128 .LEHB452-.LFB8759
	.uleb128 .LEHE452-.LEHB452
	.uleb128 .L3905-.LFB8759
	.uleb128 0
	.uleb128 .LEHB453-.LFB8759
	.uleb128 .LEHE453-.LEHB453
	.uleb128 .L3906-.LFB8759
	.uleb128 0
	.uleb128 .LEHB454-.LFB8759
	.uleb128 .LEHE454-.LEHB454
	.uleb128 .L3907-.LFB8759
	.uleb128 0
	.uleb128 .LEHB455-.LFB8759
	.uleb128 .LEHE455-.LEHB455
	.uleb128 .L3892-.LFB8759
	.uleb128 0
	.uleb128 .LEHB456-.LFB8759
	.uleb128 .LEHE456-.LEHB456
	.uleb128 .L3924-.LFB8759
	.uleb128 0
	.uleb128 .LEHB457-.LFB8759
	.uleb128 .LEHE457-.LEHB457
	.uleb128 .L3925-.LFB8759
	.uleb128 0
	.uleb128 .LEHB458-.LFB8759
	.uleb128 .LEHE458-.LEHB458
	.uleb128 .L3926-.LFB8759
	.uleb128 0
	.uleb128 .LEHB459-.LFB8759
	.uleb128 .LEHE459-.LEHB459
	.uleb128 .L3927-.LFB8759
	.uleb128 0
	.uleb128 .LEHB460-.LFB8759
	.uleb128 .LEHE460-.LEHB460
	.uleb128 .L3928-.LFB8759
	.uleb128 0
	.uleb128 .LEHB461-.LFB8759
	.uleb128 .LEHE461-.LEHB461
	.uleb128 .L3929-.LFB8759
	.uleb128 0
	.uleb128 .LEHB462-.LFB8759
	.uleb128 .LEHE462-.LEHB462
	.uleb128 .L3892-.LFB8759
	.uleb128 0
	.uleb128 .LEHB463-.LFB8759
	.uleb128 .LEHE463-.LEHB463
	.uleb128 .L3915-.LFB8759
	.uleb128 0
	.uleb128 .LEHB464-.LFB8759
	.uleb128 .LEHE464-.LEHB464
	.uleb128 .L3916-.LFB8759
	.uleb128 0
	.uleb128 .LEHB465-.LFB8759
	.uleb128 .LEHE465-.LEHB465
	.uleb128 .L3917-.LFB8759
	.uleb128 0
	.uleb128 .LEHB466-.LFB8759
	.uleb128 .LEHE466-.LEHB466
	.uleb128 .L3918-.LFB8759
	.uleb128 0
	.uleb128 .LEHB467-.LFB8759
	.uleb128 .LEHE467-.LEHB467
	.uleb128 .L3919-.LFB8759
	.uleb128 0
	.uleb128 .LEHB468-.LFB8759
	.uleb128 .LEHE468-.LEHB468
	.uleb128 .L3920-.LFB8759
	.uleb128 0
	.uleb128 .LEHB469-.LFB8759
	.uleb128 .LEHE469-.LEHB469
	.uleb128 .L3921-.LFB8759
	.uleb128 0
	.uleb128 .LEHB470-.LFB8759
	.uleb128 .LEHE470-.LEHB470
	.uleb128 .L3922-.LFB8759
	.uleb128 0
	.uleb128 .LEHB471-.LFB8759
	.uleb128 .LEHE471-.LEHB471
	.uleb128 .L3923-.LFB8759
	.uleb128 0
	.uleb128 .LEHB472-.LFB8759
	.uleb128 .LEHE472-.LEHB472
	.uleb128 .L3921-.LFB8759
	.uleb128 0
	.uleb128 .LEHB473-.LFB8759
	.uleb128 .LEHE473-.LEHB473
	.uleb128 .L3892-.LFB8759
	.uleb128 0
	.uleb128 .LEHB474-.LFB8759
	.uleb128 .LEHE474-.LEHB474
	.uleb128 .L3930-.LFB8759
	.uleb128 0
	.uleb128 .LEHB475-.LFB8759
	.uleb128 .LEHE475-.LEHB475
	.uleb128 .L3931-.LFB8759
	.uleb128 0
	.uleb128 .LEHB476-.LFB8759
	.uleb128 .LEHE476-.LEHB476
	.uleb128 .L3932-.LFB8759
	.uleb128 0
	.uleb128 .LEHB477-.LFB8759
	.uleb128 .LEHE477-.LEHB477
	.uleb128 .L3933-.LFB8759
	.uleb128 0
	.uleb128 .LEHB478-.LFB8759
	.uleb128 .LEHE478-.LEHB478
	.uleb128 .L3934-.LFB8759
	.uleb128 0
	.uleb128 .LEHB479-.LFB8759
	.uleb128 .LEHE479-.LEHB479
	.uleb128 .L3935-.LFB8759
	.uleb128 0
	.uleb128 .LEHB480-.LFB8759
	.uleb128 .LEHE480-.LEHB480
	.uleb128 .L3936-.LFB8759
	.uleb128 0
	.uleb128 .LEHB481-.LFB8759
	.uleb128 .LEHE481-.LEHB481
	.uleb128 .L3937-.LFB8759
	.uleb128 0
	.uleb128 .LEHB482-.LFB8759
	.uleb128 .LEHE482-.LEHB482
	.uleb128 .L3938-.LFB8759
	.uleb128 0
	.uleb128 .LEHB483-.LFB8759
	.uleb128 .LEHE483-.LEHB483
	.uleb128 .L3936-.LFB8759
	.uleb128 0
	.uleb128 .LEHB484-.LFB8759
	.uleb128 .LEHE484-.LEHB484
	.uleb128 .L3939-.LFB8759
	.uleb128 0
	.uleb128 .LEHB485-.LFB8759
	.uleb128 .LEHE485-.LEHB485
	.uleb128 .L3940-.LFB8759
	.uleb128 0
	.uleb128 .LEHB486-.LFB8759
	.uleb128 .LEHE486-.LEHB486
	.uleb128 .L3941-.LFB8759
	.uleb128 0
	.uleb128 .LEHB487-.LFB8759
	.uleb128 .LEHE487-.LEHB487
	.uleb128 .L3942-.LFB8759
	.uleb128 0
	.uleb128 .LEHB488-.LFB8759
	.uleb128 .LEHE488-.LEHB488
	.uleb128 .L3940-.LFB8759
	.uleb128 0
	.uleb128 .LEHB489-.LFB8759
	.uleb128 .LEHE489-.LEHB489
	.uleb128 .L3943-.LFB8759
	.uleb128 0
	.uleb128 .LEHB490-.LFB8759
	.uleb128 .LEHE490-.LEHB490
	.uleb128 .L3944-.LFB8759
	.uleb128 0
	.uleb128 .LEHB491-.LFB8759
	.uleb128 .LEHE491-.LEHB491
	.uleb128 .L3892-.LFB8759
	.uleb128 0
	.uleb128 .LEHB492-.LFB8759
	.uleb128 .LEHE492-.LEHB492
	.uleb128 .L3945-.LFB8759
	.uleb128 0
	.uleb128 .LEHB493-.LFB8759
	.uleb128 .LEHE493-.LEHB493
	.uleb128 .L3946-.LFB8759
	.uleb128 0
	.uleb128 .LEHB494-.LFB8759
	.uleb128 .LEHE494-.LEHB494
	.uleb128 .L3947-.LFB8759
	.uleb128 0
	.uleb128 .LEHB495-.LFB8759
	.uleb128 .LEHE495-.LEHB495
	.uleb128 .L3948-.LFB8759
	.uleb128 0
	.uleb128 .LEHB496-.LFB8759
	.uleb128 .LEHE496-.LEHB496
	.uleb128 .L3949-.LFB8759
	.uleb128 0
	.uleb128 .LEHB497-.LFB8759
	.uleb128 .LEHE497-.LEHB497
	.uleb128 .L3950-.LFB8759
	.uleb128 0
	.uleb128 .LEHB498-.LFB8759
	.uleb128 .LEHE498-.LEHB498
	.uleb128 .L3951-.LFB8759
	.uleb128 0
	.uleb128 .LEHB499-.LFB8759
	.uleb128 .LEHE499-.LEHB499
	.uleb128 .L3952-.LFB8759
	.uleb128 0
	.uleb128 .LEHB500-.LFB8759
	.uleb128 .LEHE500-.LEHB500
	.uleb128 .L3953-.LFB8759
	.uleb128 0
	.uleb128 .LEHB501-.LFB8759
	.uleb128 .LEHE501-.LEHB501
	.uleb128 .L3954-.LFB8759
	.uleb128 0
	.uleb128 .LEHB502-.LFB8759
	.uleb128 .LEHE502-.LEHB502
	.uleb128 .L3955-.LFB8759
	.uleb128 0
	.uleb128 .LEHB503-.LFB8759
	.uleb128 .LEHE503-.LEHB503
	.uleb128 .L3956-.LFB8759
	.uleb128 0
	.uleb128 .LEHB504-.LFB8759
	.uleb128 .LEHE504-.LEHB504
	.uleb128 .L3957-.LFB8759
	.uleb128 0
	.uleb128 .LEHB505-.LFB8759
	.uleb128 .LEHE505-.LEHB505
	.uleb128 .L3958-.LFB8759
	.uleb128 0
	.uleb128 .LEHB506-.LFB8759
	.uleb128 .LEHE506-.LEHB506
	.uleb128 .L3907-.LFB8759
	.uleb128 0
	.uleb128 .LEHB507-.LFB8759
	.uleb128 .LEHE507-.LEHB507
	.uleb128 .L3893-.LFB8759
	.uleb128 0
	.uleb128 .LEHB508-.LFB8759
	.uleb128 .LEHE508-.LEHB508
	.uleb128 .L3892-.LFB8759
	.uleb128 0
	.uleb128 .LEHB509-.LFB8759
	.uleb128 .LEHE509-.LEHB509
	.uleb128 .L3976-.LFB8759
	.uleb128 0
	.uleb128 .LEHB510-.LFB8759
	.uleb128 .LEHE510-.LEHB510
	.uleb128 .L3975-.LFB8759
	.uleb128 0
.LLSDACSE8759:
	.section	.text.startup
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8759
	.type	main.cold, @function
main.cold:
.LFSB8759:
.L3319:
	.cfi_def_cfa_offset 35376
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3320
	call	_ZdlPv@PLT
.L3320:
	leaq	12656(%rsp), %rbp
.L3321:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
.L3309:
	movq	696(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	496(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3553:
	movq	4240(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4519
.L3555:
	movq	400(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3556:
	movq	4208(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4520
.L3558:
	movq	648(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	456(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3559:
	movq	4144(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4521
.L3561:
	movq	72(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3562:
	movq	4112(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4522
.L3564:
	movq	608(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	424(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3565:
	movq	4048(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4523
.L3567:
	movq	384(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3568:
	movq	4016(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4524
.L3570:
	movq	576(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	368(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3571:
	movq	3952(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4525
.L3573:
	movq	352(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3574:
	movq	3920(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4526
.L3576:
	movq	560(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	336(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3577:
	movq	3856(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4527
.L3579:
	movq	320(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3580:
	movq	3824(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4528
.L3582:
	movq	544(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	304(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3583:
	movq	3760(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4529
.L3585:
	movq	288(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3586:
	movq	3728(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4530
.L3588:
	movq	520(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	272(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3589:
	movq	3664(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4531
.L3591:
	movq	264(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3592:
	movq	3632(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4532
.L3594:
	movq	504(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	256(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3595:
	movq	3568(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4533
.L3597:
	movq	248(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3598:
	movq	3536(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4534
.L3600:
	movq	480(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	240(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3601:
	movq	3472(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4535
.L3603:
	movq	232(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3604:
	movq	3440(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4536
.L3606:
	movq	464(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	224(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3607:
	movq	3376(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4537
.L3609:
	movq	216(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3610:
	movq	3344(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4538
.L3612:
	movq	440(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	920(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3613:
	movq	3280(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4539
.L3615:
	movq	208(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3616:
	movq	3248(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4540
.L3618:
	movq	408(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	200(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3619:
	movq	3184(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4541
.L3621:
	movq	192(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3622:
	movq	3152(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4542
.L3624:
	movq	1184(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	184(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3625:
	movq	3088(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4543
.L3627:
	movq	176(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3628:
	movq	3056(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4544
.L3630:
	movq	1168(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	168(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3631:
	movq	2992(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4545
.L3633:
	movq	160(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3634:
	movq	2960(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4546
.L3636:
	movq	1152(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	152(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3637:
	movq	2896(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4547
.L3639:
	movq	144(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3640:
	movq	2864(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4548
.L3642:
	movq	1144(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	136(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3643:
	movq	2800(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4549
.L3645:
	movq	128(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3646:
	movq	2768(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4550
.L3648:
	movq	1120(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	120(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3649:
	movq	2704(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4551
.L3651:
	movq	112(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3652:
	movq	2672(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4552
.L3654:
	movq	1104(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	104(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3655:
	movq	2608(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4553
.L3657:
	movq	96(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3658:
	movq	2576(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4554
.L3660:
	movq	1088(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	88(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3661:
	movq	2512(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4555
.L3663:
	movq	80(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3664:
	movq	2480(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4556
.L3666:
	movq	1064(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	64(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3667:
	movq	2416(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4557
.L3669:
	movq	56(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3670:
	movq	2384(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4558
.L3672:
	movq	1040(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	376(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3673:
	movq	2320(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4559
.L3675:
	movq	360(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3676:
	movq	2288(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4560
.L3678:
	movq	1000(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	344(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3679:
	movq	2224(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4561
.L3681:
	movq	328(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3682:
	movq	2192(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4562
.L3684:
	movq	976(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	312(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3685:
	movq	2128(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4563
.L3687:
	movq	296(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3688:
	movq	2096(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4564
.L3690:
	movq	952(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	280(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3691:
	movq	2032(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4565
.L3693:
	movq	48(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3694:
	movq	2000(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3695
	call	_ZdlPv@PLT
.L3695:
	movq	%rbx, %rbp
.L3696:
	movq	928(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1080(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3697:
	movq	1056(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3698:
	movq	896(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1032(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3699:
	movq	1016(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3700:
	movq	888(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	992(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3701:
	movq	968(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3702:
	movq	880(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	944(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3703:
	movq	912(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3704:
	movq	856(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	872(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3705:
	movq	840(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3706:
	movq	848(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	800(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3707:
	movq	768(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3708:
	movq	824(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	728(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3709:
	movq	688(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3710:
	movq	816(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	656(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3711:
	movq	624(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3712:
	movq	808(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	584(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3713:
	movq	568(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3714:
	movq	784(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	552(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3715:
	movq	536(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3716:
	movq	776(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	528(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3717:
	movq	512(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3718:
	movq	752(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	488(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3719:
	movq	472(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3720:
	movq	744(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	448(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3721:
	movq	432(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3722:
	movq	736(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	416(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3723:
	movq	1192(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3724:
	movq	712(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1176(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3725:
	movq	1160(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3726:
	movq	704(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	392(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3727:
	movq	1136(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3728:
	movq	680(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1128(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3729:
	movq	1112(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3730:
	movq	672(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1096(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3731:
	movq	1072(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3732:
	movq	664(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1048(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3733:
	movq	1024(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3734:
	movq	640(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1008(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3735:
	movq	984(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3736:
	movq	632(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	960(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3737:
	movq	936(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3738:
	movq	616(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	904(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3739:
	movq	864(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3740:
	movq	600(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	832(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3741:
	movq	792(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3742:
	movq	592(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	760(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3743:
	movq	720(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3744:
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED1Ev
	movq	%rbp, %rdi
.LEHB511:
	call	_Unwind_Resume@PLT
.LEHE511:
.L3457:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3458:
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3460
	call	_ZdlPv@PLT
.L3460:
	movq	12208(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4566
.L3463:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3456:
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3309
	call	_ZdlPv@PLT
	jmp	.L3309
.L4566:
	call	_ZdlPv@PLT
	jmp	.L3463
.L4519:
	call	_ZdlPv@PLT
	jmp	.L3555
.L4520:
	call	_ZdlPv@PLT
	jmp	.L3558
.L4521:
	call	_ZdlPv@PLT
	jmp	.L3561
.L4522:
	call	_ZdlPv@PLT
	jmp	.L3564
.L4523:
	call	_ZdlPv@PLT
	jmp	.L3567
.L4524:
	call	_ZdlPv@PLT
	jmp	.L3570
.L4525:
	call	_ZdlPv@PLT
	jmp	.L3573
.L4526:
	call	_ZdlPv@PLT
	jmp	.L3576
.L4527:
	call	_ZdlPv@PLT
	jmp	.L3579
.L4528:
	call	_ZdlPv@PLT
	jmp	.L3582
.L4529:
	call	_ZdlPv@PLT
	jmp	.L3585
.L4530:
	call	_ZdlPv@PLT
	jmp	.L3588
.L4531:
	call	_ZdlPv@PLT
	jmp	.L3591
.L4532:
	call	_ZdlPv@PLT
	jmp	.L3594
.L4533:
	call	_ZdlPv@PLT
	jmp	.L3597
.L4534:
	call	_ZdlPv@PLT
	jmp	.L3600
.L4535:
	call	_ZdlPv@PLT
	jmp	.L3603
.L4536:
	call	_ZdlPv@PLT
	jmp	.L3606
.L4537:
	call	_ZdlPv@PLT
	jmp	.L3609
.L4538:
	call	_ZdlPv@PLT
	jmp	.L3612
.L4539:
	call	_ZdlPv@PLT
	jmp	.L3615
.L4540:
	call	_ZdlPv@PLT
	jmp	.L3618
.L4541:
	call	_ZdlPv@PLT
	jmp	.L3621
.L4542:
	call	_ZdlPv@PLT
	jmp	.L3624
.L4543:
	call	_ZdlPv@PLT
	jmp	.L3627
.L4544:
	call	_ZdlPv@PLT
	jmp	.L3630
.L4545:
	call	_ZdlPv@PLT
	jmp	.L3633
.L4546:
	call	_ZdlPv@PLT
	jmp	.L3636
.L4547:
	call	_ZdlPv@PLT
	jmp	.L3639
.L4548:
	call	_ZdlPv@PLT
	jmp	.L3642
.L4549:
	call	_ZdlPv@PLT
	jmp	.L3645
.L4550:
	call	_ZdlPv@PLT
	jmp	.L3648
.L4551:
	call	_ZdlPv@PLT
	jmp	.L3651
.L4552:
	call	_ZdlPv@PLT
	jmp	.L3654
.L4553:
	call	_ZdlPv@PLT
	jmp	.L3657
.L4554:
	call	_ZdlPv@PLT
	jmp	.L3660
.L4555:
	call	_ZdlPv@PLT
	jmp	.L3663
.L4556:
	call	_ZdlPv@PLT
	jmp	.L3666
.L4557:
	call	_ZdlPv@PLT
	jmp	.L3669
.L4558:
	call	_ZdlPv@PLT
	jmp	.L3672
.L4559:
	call	_ZdlPv@PLT
	jmp	.L3675
.L4560:
	call	_ZdlPv@PLT
	jmp	.L3678
.L4561:
	call	_ZdlPv@PLT
	jmp	.L3681
.L4562:
	call	_ZdlPv@PLT
	jmp	.L3684
.L4563:
	call	_ZdlPv@PLT
	jmp	.L3687
.L4564:
	call	_ZdlPv@PLT
	jmp	.L3690
.L4565:
	call	_ZdlPv@PLT
	jmp	.L3693
.L3522:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4567
.L3524:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3521:
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3518:
	movq	32(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3515:
	movq	12784(%rsp), %rdi
	leaq	12800(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3309
	call	_ZdlPv@PLT
	jmp	.L3309
.L4567:
	call	_ZdlPv@PLT
	jmp	.L3524
.L3493:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3494:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3496
	call	_ZdlPv@PLT
.L3496:
	movq	12016(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4568
.L3511:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3492:
	movq	4304(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3309
	call	_ZdlPv@PLT
	jmp	.L3309
.L4568:
	call	_ZdlPv@PLT
	jmp	.L3511
.L3519:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3521
	call	_ZdlPv@PLT
	jmp	.L3521
.L3516:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3518
	call	_ZdlPv@PLT
	jmp	.L3518
.L3532:
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
.L3533:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
.L3534:
	movq	12784(%rsp), %rdi
	leaq	12800(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3309
	call	_ZdlPv@PLT
	jmp	.L3309
.L3507:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
.L3508:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4569
.L3506:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3500:
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3496
.L3528:
	movq	12816(%rsp), %rdi
	leaq	12832(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3527
	call	_ZdlPv@PLT
.L3527:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3530:
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3524
.L3525:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3526:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3527
.L4569:
	call	_ZdlPv@PLT
	jmp	.L3506
.L3513:
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
.L3514:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	jmp	.L3515
.L3547:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3548:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3549:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3546:
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3543:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3540:
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3537:
	movq	32(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	jmp	.L3534
.L3544:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3545:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3546
.L3541:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3543
	call	_ZdlPv@PLT
	jmp	.L3543
.L3538:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3540
	call	_ZdlPv@PLT
	jmp	.L3540
.L3535:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3537
	call	_ZdlPv@PLT
	jmp	.L3537
.L3550:
	movq	12816(%rsp), %rdi
	leaq	12832(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3549
	call	_ZdlPv@PLT
	jmp	.L3549
.L3479:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3481
	call	_ZdlPv@PLT
.L3481:
	movq	12208(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3309
	call	_ZdlPv@PLT
	jmp	.L3309
.L3468:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3469:
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3471
	call	_ZdlPv@PLT
.L3471:
	movq	12208(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4570
.L3477:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3467:
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3309
	call	_ZdlPv@PLT
	jmp	.L3309
.L4570:
	call	_ZdlPv@PLT
	jmp	.L3477
.L3465:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3467
	call	_ZdlPv@PLT
	jmp	.L3467
.L3482:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3484
	call	_ZdlPv@PLT
.L3484:
	movq	12432(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3486
	call	_ZdlPv@PLT
.L3486:
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3488
	call	_ZdlPv@PLT
.L3488:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3481
.L3490:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3492
	call	_ZdlPv@PLT
	jmp	.L3492
.L3472:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
.L3473:
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3475
	call	_ZdlPv@PLT
.L3475:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3471
.L3497:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
.L3498:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3500
	call	_ZdlPv@PLT
	jmp	.L3500
.L3503:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3504:
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3506
	call	_ZdlPv@PLT
	jmp	.L3506
.L3501:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3500
	call	_ZdlPv@PLT
	jmp	.L3500
.L3454:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3456
	call	_ZdlPv@PLT
	jmp	.L3456
.L3449:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3450:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3451:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3448:
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3445:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3442:
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3439:
	movq	32(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	jmp	.L3309
.L3452:
	movq	12816(%rsp), %rdi
	leaq	12832(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3451
	call	_ZdlPv@PLT
	jmp	.L3451
.L3437:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3439
	call	_ZdlPv@PLT
	jmp	.L3439
.L3440:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3442
	call	_ZdlPv@PLT
	jmp	.L3442
.L3436:
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
	jmp	.L3321
.L3307:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3309
	call	_ZdlPv@PLT
	jmp	.L3309
.L3461:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3460
.L3443:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3445
	call	_ZdlPv@PLT
	jmp	.L3445
.L3446:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3447:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3448
	.cfi_endproc
.LFE8759:
	.section	.gcc_except_table
.LLSDAC8759:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8759-.LLSDACSBC8759
.LLSDACSBC8759:
	.uleb128 .LEHB511-.LCOLDB140
	.uleb128 .LEHE511-.LEHB511
	.uleb128 0
	.uleb128 0
.LLSDACSEC8759:
	.section	.text.unlikely
	.section	.text.startup
	.size	main, .-main
	.section	.text.unlikely
	.size	main.cold, .-main.cold
.LCOLDE140:
	.section	.text.startup
.LHOTE140:
	.p2align 4
	.type	_GLOBAL__sub_I__Z12load_partialiPKf, @function
_GLOBAL__sub_I__Z12load_partialiPKf:
.LFB9906:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	leaq	_ZStL8__ioinit(%rip), %rdi
	call	_ZNSt8ios_base4InitC1Ev@PLT
	movq	_ZNSt8ios_base4InitD1Ev@GOTPCREL(%rip), %rdi
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	leaq	__dso_handle(%rip), %rdx
	leaq	_ZStL8__ioinit(%rip), %rsi
	jmp	__cxa_atexit@PLT
	.cfi_endproc
.LFE9906:
	.size	_GLOBAL__sub_I__Z12load_partialiPKf, .-_GLOBAL__sub_I__Z12load_partialiPKf
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I__Z12load_partialiPKf
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC18:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 16
.LC34:
	.long	1
	.long	1
	.long	1
	.long	1
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC44:
	.long	2296604913
	.long	1056241845
	.section	.rodata.cst16
	.align 16
.LC86:
	.long	1073741824
	.long	1077936128
	.long	0
	.long	0
	.align 16
.LC87:
	.long	0
	.long	0
	.long	1077936128
	.long	1073741824
	.align 16
.LC88:
	.long	0
	.long	0
	.long	1073741824
	.long	1077936128
	.align 16
.LC89:
	.long	1077936128
	.long	1073741824
	.long	0
	.long	0
	.align 16
.LC90:
	.long	1091567616
	.long	1092616192
	.long	0
	.long	0
	.align 16
.LC91:
	.long	0
	.long	0
	.long	1093664768
	.long	1094713344
	.align 16
.LC92:
	.long	0
	.long	0
	.long	1095761920
	.long	1096810496
	.align 16
.LC93:
	.long	1097859072
	.long	1098907648
	.long	0
	.long	0
	.align 16
.LC94:
	.long	1099431936
	.long	1099956224
	.long	0
	.long	0
	.align 16
.LC95:
	.long	0
	.long	0
	.long	1100480512
	.long	1101004800
	.align 16
.LC96:
	.long	0
	.long	0
	.long	1101529088
	.long	1102053376
	.align 16
.LC97:
	.long	1102577664
	.long	1103101952
	.long	0
	.long	0
	.align 16
.LC98:
	.long	1065353216
	.long	1073741824
	.long	1077936128
	.long	1082130432
	.align 16
.LC99:
	.long	1084227584
	.long	1086324736
	.long	1088421888
	.long	1090519040
	.align 16
.LC100:
	.long	1091567616
	.long	1092616192
	.long	1093664768
	.long	1094713344
	.align 16
.LC101:
	.long	1095761920
	.long	1096810496
	.long	1097859072
	.long	1098907648
	.align 16
.LC102:
	.long	1086324736
	.long	1088421888
	.long	1090519040
	.long	1091567616
	.align 16
.LC103:
	.long	1092616192
	.long	1093664768
	.long	1094713344
	.long	1095761920
	.align 16
.LC104:
	.long	1096810496
	.long	1097859072
	.long	1098907648
	.long	1099431936
	.align 16
.LC105:
	.long	1101004800
	.long	1101529088
	.long	1102053376
	.long	1102577664
	.align 16
.LC106:
	.long	1103101952
	.long	1103626240
	.long	1104150528
	.long	1104674816
	.align 16
.LC107:
	.long	1105199104
	.long	1105723392
	.long	1106247680
	.long	1106771968
	.align 16
.LC108:
	.long	1107296256
	.long	1107558400
	.long	1107820544
	.long	1108082688
	.align 16
.LC109:
	.long	1108344832
	.long	1108606976
	.long	1108869120
	.long	1109131264
	.align 16
.LC110:
	.long	1109393408
	.long	1109655552
	.long	1109917696
	.long	1110179840
	.align 16
.LC111:
	.long	1060439287
	.long	0
	.long	0
	.long	0
	.align 16
.LC112:
	.long	0
	.long	1060439287
	.long	0
	.long	0
	.align 16
.LC113:
	.long	0
	.long	0
	.long	0
	.long	1060439287
	.align 16
.LC114:
	.long	0
	.long	0
	.long	1060439287
	.long	0
	.align 16
.LC115:
	.long	1060439287
	.long	0
	.long	0
	.long	3207922935
	.align 16
.LC130:
	.long	2
	.long	2
	.long	2
	.long	2
	.hidden	DW.ref.__gxx_personality_v0
	.weak	DW.ref.__gxx_personality_v0
	.section	.data.rel.local.DW.ref.__gxx_personality_v0,"awG",@progbits,DW.ref.__gxx_personality_v0,comdat
	.align 8
	.type	DW.ref.__gxx_personality_v0, @object
	.size	DW.ref.__gxx_personality_v0, 8
DW.ref.__gxx_personality_v0:
	.quad	__gxx_personality_v0
	.hidden	__dso_handle
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
