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
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"basic_string::_M_construct null not valid"
	.text
	.align 2
	.p2align 4
	.type	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.isra.0, @function
_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.isra.0:
.LFB10035:
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
	je	.L32
	movq	%rdi, %rbx
	movq	%rsi, %rdi
	movq	%rsi, %rbp
	call	strlen@PLT
	movq	%rax, (%rsp)
	movq	%rax, %r12
	cmpq	$15, %rax
	ja	.L33
	cmpq	$1, %rax
	jne	.L25
	movzbl	0(%rbp), %eax
	movb	%al, 16(%rbx)
.L26:
	movq	(%rsp), %rax
	movq	(%rbx), %rdx
	movq	%rax, 8(%rbx)
	movb	$0, (%rdx,%rax)
	movq	8(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L34
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
.L25:
	.cfi_restore_state
	testq	%rax, %rax
	je	.L26
	jmp	.L24
.L33:
	movq	%rsp, %rsi
	xorl	%edx, %edx
	movq	%rbx, %rdi
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm@PLT
	movq	%rax, (%rbx)
	movq	%rax, %r13
	movq	(%rsp), %rax
	movq	%rax, 16(%rbx)
.L24:
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movq	%r13, %rdi
	call	memcpy@PLT
	jmp	.L26
.L32:
	leaq	.LC0(%rip), %rdi
	call	_ZSt19__throw_logic_errorPKc@PLT
.L34:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE10035:
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
.LFB10122:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10122
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
.L38:
	.cfi_restore_state
	endbr64
	movq	%rax, %rbp
	jmp	.L36
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA10122:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10122-.LLSDACSB10122
.LLSDACSB10122:
	.uleb128 .LEHB0-.LFB10122
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L38-.LFB10122
	.uleb128 0
.LLSDACSE10122:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC10122
	.type	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0.cold, @function
_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0.cold:
.LFSB10122:
.L36:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -24
	.cfi_offset 6, -16
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L37
	call	_ZdlPv@PLT
.L37:
	movq	%rbp, %rdi
.LEHB1:
	call	_Unwind_Resume@PLT
.LEHE1:
	.cfi_endproc
.LFE10122:
	.section	.gcc_except_table
.LLSDAC10122:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC10122-.LLSDACSBC10122
.LLSDACSBC10122:
	.uleb128 .LEHB1-.LCOLDB1
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
.LLSDACSEC10122:
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
.LFB10121:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10121
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
	ja	.L60
	movq	%rsi, %rbp
	testq	%rax, %rax
	je	.L50
	movq	%r12, %rdi
.LEHB2:
	call	_Znwm@PLT
	movq	%rax, %rdi
.L46:
	leaq	(%rdi,%r12), %r13
	movq	%rdi, (%rbx)
	movq	%r13, 16(%rbx)
	testq	%r12, %r12
	je	.L47
	movq	%r12, %rdx
	movq	%rbp, %rsi
	call	memcpy@PLT
.L47:
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
.L50:
	.cfi_restore_state
	xorl	%edi, %edi
	jmp	.L46
.L60:
	leaq	.LC2(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE2:
.L51:
	endbr64
	movq	%rax, %rbp
	jmp	.L48
	.section	.gcc_except_table
.LLSDA10121:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10121-.LLSDACSB10121
.LLSDACSB10121:
	.uleb128 .LEHB2-.LFB10121
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L51-.LFB10121
	.uleb128 0
.LLSDACSE10121:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC10121
	.type	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1.cold, @function
_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.1.cold:
.LFSB10121:
.L48:
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -40
	.cfi_offset 6, -32
	.cfi_offset 12, -24
	.cfi_offset 13, -16
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L49
	call	_ZdlPv@PLT
.L49:
	movq	%rbp, %rdi
.LEHB3:
	call	_Unwind_Resume@PLT
.LEHE3:
	.cfi_endproc
.LFE10121:
	.section	.gcc_except_table
.LLSDAC10121:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC10121-.LLSDACSBC10121
.LLSDACSBC10121:
	.uleb128 .LEHB3-.LCOLDB3
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
.LLSDACSEC10121:
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
	je	.L62
	xorl	%ebp, %ebp
	leaq	_ZSt4cout(%rip), %r12
	.p2align 4,,10
	.p2align 3
.L63:
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
	ja	.L63
.L62:
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
	je	.L69
	cmpb	$0, 56(%r12)
	je	.L65
	movsbl	67(%r12), %esi
.L66:
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
	je	.L67
	xorl	%ebp, %ebp
	leaq	_ZSt4cout(%rip), %r12
	.p2align 4,,10
	.p2align 3
.L68:
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
	ja	.L68
.L67:
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
	je	.L69
	cmpb	$0, 56(%r12)
	je	.L70
	movsbl	67(%r12), %esi
.L71:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
.LEHE4:
	movq	80(%rbx), %rbp
	leaq	64(%rbx), %rax
	movq	%rax, 8(%rsp)
	cmpq	%rax, %rbp
	je	.L61
	leaq	32(%rsp), %r15
	leaq	.LC12(%rip), %r14
	.p2align 4,,10
	.p2align 3
.L82:
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
	jle	.L75
	leal	-2(%rbx), %eax
	xorl	%r12d, %r12d
	leaq	4(,%rax,4), %rax
	movq	%rax, (%rsp)
	.p2align 4,,10
	.p2align 3
.L76:
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
	jne	.L76
.L75:
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
	je	.L103
	cmpb	$0, 56(%r12)
	je	.L78
	movsbl	67(%r12), %esi
.L79:
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movq	16(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.L80
	call	_ZdlPv@PLT
.L80:
	movq	%rbp, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %rbp
	cmpq	8(%rsp), %rax
	jne	.L82
.L61:
	movq	56(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L104
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
.L78:
	.cfi_restore_state
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rcx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rcx, %rax
	je	.L79
	movq	%r12, %rdi
	call	*%rax
.LEHE5:
	movsbl	%al, %esi
	jmp	.L79
	.p2align 4,,10
	.p2align 3
.L65:
	movq	%r12, %rdi
.LEHB6:
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	movl	$10, %esi
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L66
	movq	%r12, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L66
	.p2align 4,,10
	.p2align 3
.L70:
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	movl	$10, %esi
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L71
	movq	%r12, %rdi
	call	*%rax
.LEHE6:
	movsbl	%al, %esi
	jmp	.L71
.L103:
.LEHB7:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE7:
.L69:
.LEHB8:
	call	_ZSt16__throw_bad_castv@PLT
.L104:
	call	__stack_chk_fail@PLT
.L89:
	endbr64
	movq	%rax, %rbp
.L83:
	movq	16(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.L84
	call	_ZdlPv@PLT
.L84:
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
	.uleb128 .L89-.LFB3372
	.uleb128 0
	.uleb128 .LEHB6-.LFB3372
	.uleb128 .LEHE6-.LEHB6
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB7-.LFB3372
	.uleb128 .LEHE7-.LEHB7
	.uleb128 .L89-.LFB3372
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
	je	.L123
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L143
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
.L106:
	cmpq	%r14, %r8
	je	.L108
	movq	%r9, %rdx
	movq	%r14, %rsi
	movq	%rbp, %rdi
	movq	%r8, 16(%rsp)
	movq	%r9, (%rsp)
	call	memcpy@PLT
	movq	16(%rsp), %r8
	movq	(%rsp), %r9
.L108:
	movq	24(%rbx), %r13
	movq	32(%rbx), %r11
	subq	%r13, %r11
	movq	%r11, %rax
	sarq	$2, %rax
	movq	%rax, (%rsp)
	je	.L109
	movl	48(%rbx), %r10d
	xorl	%ecx, %ecx
	xorl	%edi, %edi
	movl	$1, %esi
	.p2align 4,,10
	.p2align 3
.L110:
	imull	0(%r13,%rcx), %esi
	movl	%r10d, %eax
	cltd
	idivl	%esi
	imull	0(%rbp,%rcx), %eax
	addq	$4, %rcx
	addl	%eax, %edi
	cmpq	%rcx, %r11
	jne	.L110
	movslq	%edi, %rdi
	leaq	(%r15,%rdi,4), %r15
.L109:
	movss	(%r15), %xmm1
	movq	8(%rsp), %rdx
	movq	64(%rbx), %r15
	movss	%xmm1, 16(%rsp)
	testq	%rdx, %rdx
	je	.L124
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L144
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
.L111:
	cmpq	%r14, %r8
	je	.L113
	movq	%r9, %rdx
	movq	%r14, %rsi
	call	memcpy@PLT
	cmpq	$0, (%rsp)
	movq	%rax, %rdi
	je	.L145
.L114:
	movq	(%rsp), %r10
	movl	48(%rbx), %r9d
	xorl	%ecx, %ecx
	xorl	%r8d, %r8d
	movl	$1, %esi
	salq	$2, %r10
	.p2align 4,,10
	.p2align 3
.L117:
	imull	0(%r13,%rcx), %esi
	movl	%r9d, %eax
	cltd
	idivl	%esi
	imull	(%rdi,%rcx), %eax
	addq	$4, %rcx
	addl	%eax, %r8d
	cmpq	%rcx, %r10
	jne	.L117
	movslq	%r8d, %r8
	movss	(%r15,%r8,4), %xmm0
.L118:
	movss	%xmm0, (%rsp)
	call	_ZdlPv@PLT
	movss	(%rsp), %xmm0
.L119:
	testq	%rbp, %rbp
	je	.L120
	movq	%rbp, %rdi
	movss	%xmm0, (%rsp)
	call	_ZdlPv@PLT
	movss	(%rsp), %xmm0
.L120:
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
.L113:
	.cfi_restore_state
	cmpq	$0, (%rsp)
	jne	.L114
	movss	(%r15), %xmm0
	testq	%rdi, %rdi
	je	.L119
	jmp	.L118
	.p2align 4,,10
	.p2align 3
.L124:
	xorl	%edi, %edi
	jmp	.L111
	.p2align 4,,10
	.p2align 3
.L123:
	xorl	%ebp, %ebp
	jmp	.L106
.L143:
.LEHB11:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE11:
.L145:
	movss	(%r15), %xmm0
	jmp	.L118
.L144:
.LEHB12:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE12:
.L125:
	endbr64
	movq	%rax, %r12
.L121:
	testq	%rbp, %rbp
	je	.L122
	movq	%rbp, %rdi
	call	_ZdlPv@PLT
.L122:
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
	.uleb128 .L125-.LFB3417
	.uleb128 0
	.uleb128 .LEHB11-.LFB3417
	.uleb128 .LEHE11-.LEHB11
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB12-.LFB3417
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L125-.LFB3417
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
	je	.L147
	xorl	%ebp, %ebp
	leaq	_ZSt4cout(%rip), %r12
	.p2align 4,,10
	.p2align 3
.L148:
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
	ja	.L148
.L147:
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
	je	.L154
	cmpb	$0, 56(%r12)
	je	.L150
	movsbl	67(%r12), %esi
.L151:
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
	je	.L152
	xorl	%ebp, %ebp
	leaq	_ZSt4cout(%rip), %r12
	.p2align 4,,10
	.p2align 3
.L153:
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
	ja	.L153
.L152:
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
	je	.L154
	cmpb	$0, 56(%r12)
	je	.L155
	movsbl	67(%r12), %esi
.L156:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movl	48(%rbx), %eax
	testl	%eax, %eax
	jle	.L146
	xorl	%ebp, %ebp
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %r13
	jmp	.L158
	.p2align 4,,10
	.p2align 3
.L181:
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
	je	.L154
	cmpb	$0, 56(%r14)
	je	.L160
	movsbl	67(%r14), %esi
.L161:
	movq	%r12, %rdi
	addq	$1, %rbp
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	cmpl	%ebp, 48(%rbx)
	jle	.L146
.L158:
	leal	1(%rbp), %eax
	movq	(%rbx), %rcx
	leaq	.LC12(%rip), %rsi
	cltd
	leaq	_ZSt4cout(%rip), %rdi
	idivl	4(%rcx)
	testl	%edx, %edx
	movl	$1, %edx
	je	.L181
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
	jg	.L158
.L146:
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
.L160:
	.cfi_restore_state
	movq	%r14, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r14), %rax
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%r13, %rax
	je	.L161
	movq	%r14, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L161
	.p2align 4,,10
	.p2align 3
.L155:
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	movl	$10, %esi
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L156
	movq	%r12, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L156
	.p2align 4,,10
	.p2align 3
.L150:
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	movl	$10, %esi
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L151
	movq	%r12, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L151
.L154:
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
	je	.L183
	jg	.L184
	cmpl	$1, %edi
	je	.L185
	cmpl	$2, %edi
	jne	.L189
	movq	(%rsi), %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L184:
	cmpl	$4, %edi
	jne	.L189
	movups	(%rsi), %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L189:
	pxor	%xmm0, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L185:
	movss	(%rsi), %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L183:
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
	jle	.L190
	movq	%rsi, %r8
	leal	-1(%rdi), %eax
	movq	%rsp, %rsi
	leaq	4(,%rax,4), %rdx
	movq	%r8, %rdi
	call	memcpy@PLT
.L190:
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
	js	.L198
	movl	4(%rcx), %edx
	jne	.L199
	cmpl	%edx, %eax
	cmovle	%eax, %edx
	movl	%edx, %edi
.L195:
	cmpl	%eax, %edi
	jg	.L193
	cmpl	%edi, 4(%rcx)
	movl	%edi, %eax
	cmovle	4(%rcx), %eax
.L193:
	ret
	.p2align 4,,10
	.p2align 3
.L199:
	subl	%edi, %edx
	movl	%edx, %edi
	jmp	.L195
	.p2align 4,,10
	.p2align 3
.L198:
	addl	%eax, %edi
	jmp	.L195
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
	leal	(%rcx,%r8), %r13d
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
	movq	(%rdx), %rax
	movl	4(%rax), %r15d
	cmpl	%r15d, %r13d
	jge	.L232
	movq	(%rsi), %rax
	movl	(%rax), %eax
	movl	%eax, %edx
	negl	%edx
	cmpl	%edx, %r13d
	jg	.L203
	movq	$0, (%rdi)
	movl	$4, %esi
	xorl	%edi, %edi
	call	calloc@PLT
	movl	$4, %esi
	xorl	%edi, %edi
	movq	%rax, (%rsp)
	call	calloc@PLT
	movq	(%rsp), %xmm0
	movq	%rax, %xmm6
	punpcklqdq	%xmm6, %xmm0
	movups	%xmm0, 8(%r12)
.L200:
	movq	40(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L233
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
.L203:
	.cfi_restore_state
	movl	%ecx, %ebp
	movl	140(%rsp), %ecx
	salq	$32, %r15
	movl	%r8d, %ebx
	movl	$8, %edi
	orq	%rax, %r15
	movl	116(%rsp), %r14d
	movl	%ecx, 12(%rsp)
.LEHB14:
	call	_Znwm@PLT
.LEHE14:
	movl	$8, %edi
	movq	%r15, (%rax)
	movq	%rax, (%rsp)
.LEHB15:
	call	_Znwm@PLT
.LEHE15:
	movq	%rax, %rdi
	movq	(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, (%rdi)
	movl	(%rdi), %r15d
	leal	0(%r13,%r15), %eax
	testl	%r13d, %r13d
	js	.L205
	movl	4(%rdi), %eax
	je	.L206
	subl	%r13d, %eax
.L205:
	cmpl	%eax, %r15d
	jge	.L234
.L207:
	call	_ZdlPv@PLT
	movslq	%r15d, %rdi
	movl	$4, %esi
	movq	%rdi, 24(%rsp)
	call	calloc@PLT
	movq	24(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, 16(%rsp)
	call	calloc@PLT
	movl	%ebx, %edx
	movq	%rax, 24(%rsp)
	movl	%ebp, %eax
	sarl	$31, %edx
	sarl	$31, %eax
	movl	%eax, %r10d
	xorl	%ebp, %r10d
	subl	%eax, %r10d
	movl	%edx, %eax
	xorl	%ebx, %eax
	subl	%edx, %eax
	testl	%ebp, %ebp
	jle	.L208
	testl	%ebx, %ebx
	js	.L235
.L230:
	xorl	%ebx, %ebx
	xorl	%ebp, %ebp
.L209:
	movq	120(%rsp), %rsi
	movq	128(%rsp), %r11
	movq	144(%rsp), %rdi
	movq	152(%rsp), %r9
	cmpl	%r15d, %ebp
	jge	.L216
	cmpl	%ebx, %r14d
	jle	.L216
	cmpl	%r10d, 12(%rsp)
	jle	.L216
	movslq	%r10d, %rax
	movslq	%ebx, %rcx
	leal	-1(%r15), %edx
	addl	$1, %ebx
	movq	%rax, %r8
	subl	%ebp, %edx
	movslq	%ebp, %rbp
	subl	%r10d, %ebx
	negq	%r8
	movl	12(%rsp), %r10d
	addq	%rax, %rdx
	salq	$2, %r8
	leaq	(%r8,%rcx,4), %rcx
	addq	%rcx, %rsi
	addq	%r11, %rcx
	leaq	(%r8,%rbp,4), %r11
	movq	16(%rsp), %r8
	leaq	(%r8,%r11), %rbp
	addq	24(%rsp), %r11
	jmp	.L217
	.p2align 4,,10
	.p2align 3
.L226:
	leal	(%rbx,%rax), %r8d
	cmpl	%r8d, %r14d
	jle	.L216
	addq	$1, %rax
	cmpl	%eax, %r10d
	jle	.L216
.L217:
	movss	(%rsi,%rax,4), %xmm0
	movss	(%rcx,%rax,4), %xmm3
	movss	(%rdi,%rax,4), %xmm1
	movss	(%r9,%rax,4), %xmm4
	movaps	%xmm0, %xmm2
	movaps	%xmm3, %xmm5
	mulss	%xmm1, %xmm2
	mulss	%xmm4, %xmm5
	mulss	%xmm4, %xmm0
	mulss	%xmm3, %xmm1
	subss	%xmm5, %xmm2
	addss	%xmm1, %xmm0
	movss	%xmm2, 0(%rbp,%rax,4)
	movss	%xmm0, (%r11,%rax,4)
	cmpq	%rax, %rdx
	jne	.L226
.L216:
	movq	16(%rsp), %xmm0
	movq	(%rsp), %rdi
	movl	%r13d, (%r12)
	movl	%r15d, 4(%r12)
	movhps	24(%rsp), %xmm0
	movups	%xmm0, 8(%r12)
	call	_ZdlPv@PLT
	jmp	.L200
	.p2align 4,,10
	.p2align 3
.L232:
	movq	$0, (%rdi)
	movl	$4, %esi
	xorl	%edi, %edi
	call	calloc@PLT
	movl	$4, %esi
	xorl	%edi, %edi
	movq	%rax, (%rsp)
	call	calloc@PLT
	movq	(%rsp), %xmm0
	movq	%rax, %xmm7
	punpcklqdq	%xmm7, %xmm0
	movups	%xmm0, 8(%r12)
	jmp	.L200
	.p2align 4,,10
	.p2align 3
.L234:
	cmpl	%eax, 4(%rdi)
	cmovle	4(%rdi), %eax
	movl	%eax, %r15d
	jmp	.L207
	.p2align 4,,10
	.p2align 3
.L208:
	je	.L210
	testl	%ebx, %ebx
	jle	.L211
	movl	12(%rsp), %ebx
	cmpl	%ebx, %r14d
	jle	.L212
	movl	%r15d, %ebp
	subl	%ebx, %ebp
.L213:
	xorl	%r10d, %r10d
	xorl	%ebx, %ebx
	jmp	.L209
	.p2align 4,,10
	.p2align 3
.L206:
	cmpl	%eax, %r15d
	cmovle	%r15d, %eax
	jmp	.L205
	.p2align 4,,10
	.p2align 3
.L210:
	xorl	%r10d, %r10d
	testl	%ebx, %ebx
	js	.L236
	xorl	%ebx, %ebx
	jmp	.L209
.L211:
	cmovne	%eax, %ebx
.L231:
	xorl	%r10d, %r10d
	xorl	%ebp, %ebp
	jmp	.L209
	.p2align 4,,10
	.p2align 3
.L235:
	movl	%r13d, %edx
	sarl	$31, %edx
	movl	%edx, %ebx
	xorl	%r13d, %ebx
	subl	%edx, %ebx
	cmpl	%eax, %r10d
	jle	.L231
	movl	%ebx, %r10d
	jmp	.L230
.L212:
	jge	.L214
	movl	%r15d, %ebp
	subl	%r14d, %ebp
	jmp	.L213
.L236:
	movl	%eax, %ebx
	jmp	.L209
.L214:
	testl	%r13d, %r13d
	cmovs	%eax, %r10d
	movl	%r10d, %ebp
	jmp	.L213
.L233:
	call	__stack_chk_fail@PLT
.L225:
	endbr64
	movq	%rax, %rbp
	jmp	.L219
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
	.uleb128 .L225-.LFB8696
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
.L219:
	.cfi_def_cfa_offset 112
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	(%rsp), %rdi
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
	je	.L238
	call	_ZdlPv@PLT
.L238:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L237
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	jmp	_ZdlPv@PLT
	.p2align 4,,10
	.p2align 3
.L237:
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
	jne	.L249
	movq	%rdi, %r12
	movl	$4, %esi
	movq	%rbp, %rdi
	call	calloc@PLT
	movq	%rbp, %rdi
	movl	$4, %esi
	movq	%rax, 8(%rsp)
	call	calloc@PLT
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	leaq	16(%rsp), %rsi
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
	jne	.L252
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
.L252:
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
.L249:
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
.L248:
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
	.uleb128 .L248-.LCOLDB16
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
	je	.L254
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
.L254:
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
	je	.L264
	cmpb	$0, 56(%r13)
	je	.L258
	movsbl	67(%r13), %esi
.L259:
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
	je	.L260
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
.L258:
	.cfi_restore_state
	movq	%r13, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%r13), %rax
	movl	$10, %esi
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L259
	movq	%r13, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L259
	.p2align 4,,10
	.p2align 3
.L260:
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
.L264:
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
	je	.L273
	movq	8(%rdi), %rbx
	pxor	%xmm9, %xmm9
	salq	$4, %rbp
	movq	.LC18(%rip), %xmm8
	movapd	%xmm9, %xmm6
	movapd	%xmm9, %xmm5
	addq	%rbx, %rbp
	.p2align 4,,10
	.p2align 3
.L270:
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
	jp	.L276
	addq	$16, %rbx
	addsd	%xmm4, %xmm5
	addsd	%xmm2, %xmm6
	cmpq	%rbp, %rbx
	jne	.L270
.L269:
	ucomisd	%xmm9, %xmm6
	jp	.L274
	jne	.L274
	ucomisd	%xmm5, %xmm9
	movapd	%xmm5, %xmm1
	sqrtsd	%xmm1, %xmm1
	ja	.L277
.L265:
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
.L273:
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
.L276:
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
	jne	.L270
	jmp	.L269
.L277:
	movapd	%xmm5, %xmm0
	movsd	%xmm1, (%rsp)
	call	sqrt@PLT
	movsd	(%rsp), %xmm1
	jmp	.L265
.L274:
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
	je	.L297
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L298
	movq	%r12, %rdi
.LEHB19:
	call	_Znwm@PLT
.LEHE19:
	movq	%rax, %rcx
.L280:
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
	je	.L283
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L283:
	addq	%r12, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%rbx)
	movq	32(%rbp), %r12
	subq	24(%rbp), %r12
	movq	$0, 40(%rbx)
	movq	%r12, %rax
	movups	%xmm0, 24(%rbx)
	sarq	$2, %rax
	je	.L299
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L300
	movq	%r12, %rdi
.LEHB20:
	call	_Znwm@PLT
.LEHE20:
	movq	%rax, %rcx
.L285:
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
	je	.L288
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L288:
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
.L297:
	.cfi_restore_state
	xorl	%ecx, %ecx
	jmp	.L280
	.p2align 4,,10
	.p2align 3
.L299:
	xorl	%ecx, %ecx
	jmp	.L285
.L298:
.LEHB21:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE21:
.L300:
.LEHB22:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE22:
.L291:
	endbr64
	movq	%rax, %rbp
.L289:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L290
	call	_ZdlPv@PLT
.L290:
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
	.uleb128 .L291-.LFB8779
	.uleb128 0
	.uleb128 .LEHB21-.LFB8779
	.uleb128 .LEHE21-.LEHB21
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB22-.LFB8779
	.uleb128 .LEHE22-.LEHB22
	.uleb128 .L291-.LFB8779
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
	je	.L318
	movl	(%rbx), %esi
	cmpl	$34, %esi
	je	.L303
	movl	$2147483648, %ecx
	movl	$4294967295, %edi
	addq	%rax, %rcx
	cmpq	%rdi, %rcx
	ja	.L303
	testq	%r12, %r12
	je	.L305
	subq	%rbp, %rdx
	movq	%rdx, (%r12)
.L305:
	testl	%esi, %esi
	je	.L319
.L301:
	movq	24(%rsp), %rbx
	xorq	%fs:40, %rbx
	jne	.L320
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
.L319:
	.cfi_restore_state
	movl	%r14d, (%rbx)
	jmp	.L301
.L303:
	movq	8(%rsp), %rdi
	call	_ZSt20__throw_out_of_rangePKc@PLT
.L318:
	movq	8(%rsp), %rdi
	call	_ZSt24__throw_invalid_argumentPKc@PLT
.LEHE24:
.L320:
	call	__stack_chk_fail@PLT
.L310:
	endbr64
	movq	%rax, %rdi
.L307:
	cmpl	$0, (%rbx)
	jne	.L308
	movl	%r14d, (%rbx)
.L308:
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
	.uleb128 .L310-.LFB8782
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
	je	.L322
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
	ja	.L342
	movq	8(%rdi), %rdi
	movq	%rdi, %rsi
	subq	%r14, %rsi
	movq	%rsi, %rax
	sarq	$2, %rax
	cmpq	%rax, %rcx
	ja	.L330
	cmpq	%r15, %r13
	je	.L341
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%r14, %rdi
	call	memmove@PLT
	addq	(%r12), %rbp
	movq	%rbp, 8(%r12)
.L322:
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
.L342:
	.cfi_restore_state
	xorl	%ebx, %ebx
	testq	%rcx, %rcx
	je	.L325
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L343
	movq	%rbp, %rdi
	call	_Znwm@PLT
	movq	(%r12), %r14
	movq	%rax, %rbx
.L325:
	cmpq	%r15, %r13
	je	.L327
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
.L327:
	testq	%r14, %r14
	je	.L328
	movq	%r14, %rdi
	call	_ZdlPv@PLT
.L328:
	addq	%rbx, %rbp
	movq	%rbx, (%r12)
	movq	%rbp, 16(%r12)
	jmp	.L329
	.p2align 4,,10
	.p2align 3
.L330:
	movq	%rsi, %rdx
	testq	%rsi, %rsi
	je	.L332
	movq	%r14, %rdi
	movq	%r13, %rsi
	call	memmove@PLT
	movq	8(%r12), %rdi
	movq	(%r12), %r14
	movq	8(%rbx), %r15
	movq	(%rbx), %r13
	movq	%rdi, %rdx
	subq	%r14, %rdx
.L332:
	leaq	0(%r13,%rdx), %rsi
	cmpq	%r15, %rsi
	jne	.L333
.L341:
	addq	%r14, %rbp
.L329:
	movq	%rbp, 8(%r12)
	jmp	.L322
	.p2align 4,,10
	.p2align 3
.L333:
	movq	%r15, %rdx
	subq	%rsi, %rdx
	call	memmove@PLT
	addq	(%r12), %rbp
	jmp	.L329
.L343:
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
	je	.L379
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L406
	movq	%rdx, %rdi
.LEHB26:
	call	_Znwm@PLT
.LEHE26:
	movq	(%r14), %rsi
	movq	%rax, 32(%rsp)
	movq	8(%r14), %rax
	movq	%rax, %rdx
	subq	%rsi, %rdx
.L345:
	cmpq	%rsi, %rax
	je	.L347
	movq	32(%rsp), %rdi
	call	memcpy@PLT
.L347:
	movq	8(%r15), %rax
	movq	(%r15), %rbx
	movq	%rax, %rdx
	subq	%rbx, %rdx
	movq	%rdx, %rcx
	sarq	$2, %rcx
	je	.L380
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L407
	movq	%rdx, %rdi
.LEHB27:
	call	_Znwm@PLT
.LEHE27:
	movq	%rax, 40(%rsp)
	movq	8(%r15), %rax
	movq	(%r15), %rbx
	movq	%rax, %rdx
	subq	%rbx, %rdx
.L348:
	cmpq	%rax, %rbx
	je	.L350
	movq	40(%rsp), %rdi
	movq	%rbx, %rsi
	call	memcpy@PLT
.L350:
	movq	40(%rsp), %rsi
	movq	32(%rsp), %rax
	movl	(%rsi), %esi
	cmpl	%esi, 4(%rax)
	jne	.L401
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
	jle	.L367
	movq	40(%rsp), %rsi
	movl	4(%rsi), %eax
	testl	%eax, %eax
	jle	.L367
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
.L373:
	movl	16(%rsp), %edi
	movq	24(%rsp), %rax
	xorl	%r15d, %r15d
	imull	%r8d, %edi
	movslq	%edi, %rdi
	salq	$2, %rdi
	leaq	(%rax,%rdi), %r9
	addq	8(%rsp), %rdi
	testl	%r10d, %r10d
	jle	.L381
	.p2align 4,,10
	.p2align 3
.L410:
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
.L369:
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
	jp	.L408
	addq	$4, %rbx
	addss	%xmm4, %xmm7
	addss	%xmm0, %xmm6
	addq	%r14, %r13
	addq	%r14, %r12
	addq	$4, %rbp
	cmpq	%rbx, %rax
	jne	.L369
.L368:
	movss	%xmm7, (%r9,%r15,4)
	leaq	1(%r15), %rax
	movss	%xmm6, (%rdi,%r15,4)
	cmpq	%r15, %r11
	je	.L409
	movq	%rax, %r15
	testl	%r10d, %r10d
	jg	.L410
.L381:
	movaps	%xmm9, %xmm6
	movaps	%xmm9, %xmm7
	jmp	.L368
	.p2align 4,,10
	.p2align 3
.L409:
	addl	$1, %r8d
	cmpl	20(%rsp), %r8d
	jne	.L373
.L367:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L364
	call	_ZdlPv@PLT
.L364:
	movq	40(%rsp), %rdi
	call	_ZdlPv@PLT
	movq	32(%rsp), %rdi
	call	_ZdlPv@PLT
	movq	152(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L411
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
.L379:
	.cfi_restore_state
	movq	$0, 32(%rsp)
	jmp	.L345
.L380:
	movq	$0, 40(%rsp)
	jmp	.L348
.L408:
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
	jne	.L369
	jmp	.L368
.L411:
	call	__stack_chk_fail@PLT
.L406:
.LEHB30:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE30:
.L407:
.LEHB31:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE31:
.L386:
	endbr64
	movq	%rax, %rbx
	jmp	.L357
.L387:
	endbr64
	movq	%rax, %rbx
	jmp	.L376
.L385:
	endbr64
	movq	%rax, %rbx
	jmp	.L359
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
	.uleb128 .L387-.LFB8713
	.uleb128 0
	.uleb128 .LEHB28-.LFB8713
	.uleb128 .LEHE28-.LEHB28
	.uleb128 .L385-.LFB8713
	.uleb128 0
	.uleb128 .LEHB29-.LFB8713
	.uleb128 .LEHE29-.LEHB29
	.uleb128 .L386-.LFB8713
	.uleb128 0
	.uleb128 .LEHB30-.LFB8713
	.uleb128 .LEHE30-.LEHB30
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB31-.LFB8713
	.uleb128 .LEHE31-.LEHB31
	.uleb128 .L387-.LFB8713
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
.L357:
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
	je	.L358
	call	_ZdlPv@PLT
.L358:
	movq	48(%rsp), %rax
	movq	(%rax), %rdi
	testq	%rdi, %rdi
	je	.L359
	call	_ZdlPv@PLT
.L359:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L412
.L355:
	movq	40(%rsp), %rdi
	call	_ZdlPv@PLT
.L375:
	movq	32(%rsp), %rdi
	call	_ZdlPv@PLT
.L377:
	movq	%rbx, %rdi
.LEHB32:
	call	_Unwind_Resume@PLT
.LEHE32:
.L376:
	cmpq	$0, 32(%rsp)
	jne	.L375
	jmp	.L377
.L412:
	call	_ZdlPv@PLT
	jmp	.L355
.L401:
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
.L383:
	endbr64
	movq	%rbp, %rdi
	movq	%rax, %rbx
	call	__cxa_free_exception@PLT
	jmp	.L355
.L384:
	endbr64
	movq	%rax, %rbx
	jmp	.L355
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
	.uleb128 .L383-.LCOLDB24
	.uleb128 0
	.uleb128 .LEHB34-.LCOLDB24
	.uleb128 .LEHE34-.LEHB34
	.uleb128 .L384-.LCOLDB24
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
.L417:
	.cfi_restore_state
	endbr64
	movq	%rax, %rbp
.L414:
	movq	24(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L415
	call	_ZdlPv@PLT
.L415:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L416
	call	_ZdlPv@PLT
.L416:
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
	.uleb128 .L417-.LFB3396
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
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	leaq	64(%rbp), %rbx
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	(%rsi), %r15
	movl	$4, %esi
	movq	%rdx, 8(%rsp)
	movl	(%r15), %edi
	imull	4(%r15), %edi
	movslq	%edi, %rdi
	call	calloc@PLT
	movl	(%r15), %edi
	imull	4(%r15), %edi
	movl	$4, %esi
	movq	%rax, %r14
	movslq	%edi, %rdi
	call	calloc@PLT
	movq	80(%rbp), %rdi
	movq	%rax, %r13
	cmpq	%rbx, %rdi
	je	.L427
	.p2align 4,,10
	.p2align 3
.L431:
	movslq	32(%rdi), %rsi
	movq	48(%rdi), %rax
	xorl	%r10d, %r10d
	movq	56(%rdi), %r8
	testl	%esi, %esi
	je	.L428
	jg	.L428
	negl	%esi
	movl	%esi, %r10d
	xorl	%esi, %esi
.L428:
	movl	44(%rdi), %edx
	testl	%edx, %edx
	jle	.L429
	movslq	4(%r15), %r11
	movq	%r11, %rcx
	leaq	4(,%r11,4), %r11
	imull	%r10d, %ecx
	leal	-1(%rdx), %r10d
	xorl	%edx, %edx
	movslq	%ecx, %rcx
	addq	%rsi, %rcx
	salq	$2, %rcx
	.p2align 4,,10
	.p2align 3
.L430:
	movss	(%rax,%rdx,4), %xmm0
	movq	%rdx, %rsi
	movss	%xmm0, (%r14,%rcx)
	movss	(%r8,%rdx,4), %xmm0
	addq	$1, %rdx
	movss	%xmm0, 0(%r13,%rcx)
	addq	%r11, %rcx
	cmpq	%rsi, %r10
	jne	.L430
.L429:
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %rdi
	cmpq	%rbx, %rax
	jne	.L431
.L427:
	pxor	%xmm0, %xmm0
	movq	8(%rsp), %rbx
	movq	%r13, %xmm1
	movq	%r12, %rdi
	movups	%xmm0, (%r12)
	leaq	24(%r12), %r15
	movups	%xmm0, 16(%r12)
	movq	%rbx, %rsi
	movups	%xmm0, 32(%r12)
	movq	%r14, %xmm0
	punpcklqdq	%xmm1, %xmm0
	movups	%xmm0, 56(%r12)
.LEHB37:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	(%r12), %rdx
	movq	%rbx, %rsi
	movq	%r15, %rdi
	movl	(%rdx), %eax
	imull	4(%rdx), %eax
	movl	%eax, 48(%r12)
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE37:
	leaq	24(%rbp), %rsi
	movq	%r15, %rdi
.LEHB38:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE38:
	addq	$24, %rsp
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
.L440:
	.cfi_restore_state
	endbr64
	movq	%rax, %rbp
	jmp	.L433
.L439:
	endbr64
	movq	%rax, %rbp
	jmp	.L436
	.section	.gcc_except_table
.LLSDA8743:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8743-.LLSDACSB8743
.LLSDACSB8743:
	.uleb128 .LEHB37-.LFB8743
	.uleb128 .LEHE37-.LEHB37
	.uleb128 .L440-.LFB8743
	.uleb128 0
	.uleb128 .LEHB38-.LFB8743
	.uleb128 .LEHE38-.LEHB38
	.uleb128 .L439-.LFB8743
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
.L433:
	.cfi_def_cfa_offset 80
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	24(%r12), %rdi
	testq	%rdi, %rdi
	je	.L434
	call	_ZdlPv@PLT
.L434:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L435
	call	_ZdlPv@PLT
.L435:
	movq	%rbp, %rdi
.LEHB39:
	call	_Unwind_Resume@PLT
.L436:
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
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
	je	.L495
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L496
	movq	%rbx, %rdi
.LEHB40:
	call	_Znwm@PLT
.LEHE40:
	movq	0(%rbp), %rsi
	movq	%rax, %rcx
	movq	8(%rbp), %rax
	movq	%rax, %r13
	subq	%rsi, %r13
.L455:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 16(%rsp)
	movaps	%xmm0, (%rsp)
	cmpq	%rsi, %rax
	je	.L457
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L457:
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
	je	.L458
	call	_ZdlPv@PLT
.L458:
	movabsq	$1152921504606846975, %rdx
	movslq	80(%rsp), %rax
	cmpq	%rdx, %rax
	ja	.L497
	pxor	%xmm0, %xmm0
	leaq	0(,%rax,8), %r13
	movq	$0, 16(%r12)
	movups	%xmm0, (%r12)
	testq	%rax, %rax
	je	.L460
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
	jle	.L467
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
	je	.L464
	cmpl	$2, %r8d
	jbe	.L464
	movl	%ebx, %edi
	xorl	%eax, %eax
	shrl	$2, %edi
	salq	$4, %rdi
	.p2align 4,,10
	.p2align 3
.L466:
	movups	(%rdx,%rax), %xmm0
	movups	(%rsi,%rax), %xmm1
	movaps	%xmm0, %xmm2
	unpckhps	%xmm1, %xmm0
	unpcklps	%xmm1, %xmm2
	movups	%xmm0, 16(%rcx,%rax,2)
	movups	%xmm2, (%rcx,%rax,2)
	addq	$16, %rax
	cmpq	%rax, %rdi
	jne	.L466
	movl	%ebx, %eax
	andl	$-4, %eax
	testb	$3, %bl
	je	.L467
	movl	%eax, %edi
	movss	(%rdx,%rdi,4), %xmm1
	movss	(%rsi,%rdi,4), %xmm0
	leaq	(%rcx,%rdi,8), %rdi
	movss	%xmm1, (%rdi)
	movss	%xmm0, 4(%rdi)
	leal	1(%rax), %edi
	cmpl	%ebx, %edi
	jge	.L467
	movslq	%edi, %rdi
	addl	$2, %eax
	movss	(%rdx,%rdi,4), %xmm1
	movss	(%rsi,%rdi,4), %xmm0
	leaq	(%rcx,%rdi,8), %rdi
	movss	%xmm1, (%rdi)
	movss	%xmm0, 4(%rdi)
	cmpl	%eax, %ebx
	jle	.L467
	cltq
	movss	(%rdx,%rax,4), %xmm1
	movss	(%rsi,%rax,4), %xmm0
	leaq	(%rcx,%rax,8), %rax
	movss	%xmm1, (%rax)
	movss	%xmm0, 4(%rax)
.L467:
	movq	56(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L463
	call	_ZdlPv@PLT
.L463:
	movq	32(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L453
	call	_ZdlPv@PLT
.L453:
	movq	104(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L498
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
.L495:
	.cfi_restore_state
	movq	%rbx, %r13
	xorl	%ecx, %ecx
	jmp	.L455
	.p2align 4,,10
	.p2align 3
.L464:
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L470:
	movss	(%rdx,%rax,4), %xmm1
	movss	(%rsi,%rax,4), %xmm0
	movq	%rax, %rdi
	movss	%xmm1, (%rcx,%rax,8)
	movss	%xmm0, 4(%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rdi, %r8
	jne	.L470
	jmp	.L467
	.p2align 4,,10
	.p2align 3
.L460:
	movq	$0, 8(%r12)
	jmp	.L467
.L497:
	leaq	.LC2(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE42:
.L498:
	call	__stack_chk_fail@PLT
.L496:
.LEHB43:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE43:
.L477:
	endbr64
	movq	%rax, %rbp
	jmp	.L474
.L476:
	endbr64
	movq	%rax, %rbp
	jmp	.L472
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
	.uleb128 .L476-.LFB8746
	.uleb128 0
	.uleb128 .LEHB42-.LFB8746
	.uleb128 .LEHE42-.LEHB42
	.uleb128 .L477-.LFB8746
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
.L474:
	.cfi_def_cfa_offset 160
	.cfi_offset 3, -48
	.cfi_offset 6, -40
	.cfi_offset 12, -32
	.cfi_offset 13, -24
	.cfi_offset 14, -16
	movq	%r14, %rdi
	call	_ZN11denseMatrixD1Ev
.L494:
	movq	%rbp, %rdi
.LEHB44:
	call	_Unwind_Resume@PLT
.LEHE44:
.L472:
	movq	(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L494
	call	_ZdlPv@PLT
	jmp	.L494
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
	je	.L506
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L507
	movq	%rbx, %rdi
	call	_Znwm@PLT
	movq	%rax, %rcx
.L501:
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
	je	.L504
	movq	%rcx, %rdi
	movq	%rbx, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L504:
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
.L506:
	.cfi_restore_state
	xorl	%ecx, %ecx
	jmp	.L501
.L507:
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
	je	.L509
	.p2align 4,,10
	.p2align 3
.L519:
	movq	8(%r12), %rbx
	movq	(%r12), %rbp
	cmpq	%rbp, %rbx
	je	.L510
	.p2align 4,,10
	.p2align 3
.L515:
	movq	24(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L511
	call	_ZdlPv@PLT
.L511:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L512
	call	_ZdlPv@PLT
	addq	$72, %rbp
	cmpq	%rbx, %rbp
	jne	.L515
.L513:
	movq	(%r12), %rbp
.L510:
	testq	%rbp, %rbp
	je	.L516
	movq	%rbp, %rdi
	addq	$24, %r12
	call	_ZdlPv@PLT
	cmpq	%r12, %r13
	jne	.L519
.L517:
	movq	(%r14), %r12
.L509:
	testq	%r12, %r12
	je	.L508
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
.L512:
	.cfi_restore_state
	addq	$72, %rbp
	cmpq	%rbp, %rbx
	jne	.L515
	jmp	.L513
	.p2align 4,,10
	.p2align 3
.L516:
	addq	$24, %r12
	cmpq	%r12, %r13
	jne	.L519
	jmp	.L517
	.p2align 4,,10
	.p2align 3
.L508:
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
	je	.L526
	.p2align 4,,10
	.p2align 3
.L531:
	movq	24(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L527
	call	_ZdlPv@PLT
.L527:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L528
	call	_ZdlPv@PLT
	addq	$72, %rbp
	cmpq	%rbp, %rbx
	jne	.L531
.L529:
	movq	(%r12), %rbp
.L526:
	testq	%rbp, %rbp
	je	.L525
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
.L528:
	.cfi_restore_state
	addq	$72, %rbp
	cmpq	%rbp, %rbx
	jne	.L531
	jmp	.L529
	.p2align 4,,10
	.p2align 3
.L525:
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
	je	.L545
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
.L539:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L539
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L545:
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
	je	.L549
	leaq	56(%rdi), %r12
.L550:
	movq	24(%rbp), %rsi
	movq	%r12, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
	movq	16(%rbp), %rbp
	call	_ZdlPv@PLT
	testq	%rbp, %rbp
	jne	.L550
.L549:
	movq	24(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L551
	call	_ZdlPv@PLT
.L551:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L548
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
.L548:
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
	je	.L575
	movq	%rdx, %r15
	movq	%rsi, %rdx
	movq	%rdi, %rbp
	movq	%rsi, %r13
	subq	%r8, %rdx
	testq	%rax, %rax
	je	.L571
	movabsq	$9223372036854775804, %r14
	leaq	(%rax,%rax), %rsi
	cmpq	%rsi, %rax
	jbe	.L576
.L563:
	movq	%r14, %rdi
	movq	%rdx, 8(%rsp)
	movq	%r8, (%rsp)
	call	_Znwm@PLT
	movq	(%rsp), %r8
	movq	8(%rsp), %rdx
	movq	%rax, %rbx
	addq	%rax, %r14
.L570:
	movl	(%r15), %eax
	subq	%r13, %r12
	leaq	4(%rbx,%rdx), %r15
	movl	%eax, (%rbx,%rdx)
	leaq	(%r15,%r12), %rax
	movq	%rax, (%rsp)
	testq	%rdx, %rdx
	jg	.L577
	testq	%r12, %r12
	jg	.L566
	testq	%r8, %r8
	jne	.L569
.L567:
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
.L577:
	.cfi_restore_state
	movq	%r8, %rsi
	movq	%rbx, %rdi
	movq	%r8, 8(%rsp)
	call	memmove@PLT
	testq	%r12, %r12
	movq	8(%rsp), %r8
	jg	.L566
.L569:
	movq	%r8, %rdi
	call	_ZdlPv@PLT
	jmp	.L567
	.p2align 4,,10
	.p2align 3
.L576:
	testq	%rsi, %rsi
	jne	.L564
	xorl	%r14d, %r14d
	xorl	%ebx, %ebx
	jmp	.L570
	.p2align 4,,10
	.p2align 3
.L566:
	movq	%r12, %rdx
	movq	%r13, %rsi
	movq	%r15, %rdi
	movq	%r8, 8(%rsp)
	call	memcpy@PLT
	movq	8(%rsp), %r8
	testq	%r8, %r8
	je	.L567
	jmp	.L569
	.p2align 4,,10
	.p2align 3
.L571:
	movl	$4, %r14d
	jmp	.L563
.L575:
	leaq	.LC27(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.L564:
	cmpq	%rcx, %rsi
	cmovbe	%rsi, %rcx
	movq	%rcx, %r14
	salq	$2, %r14
	jmp	.L563
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
	je	.L597
	xorl	%ebx, %ebx
	xorl	%eax, %eax
	xorl	%esi, %esi
	jmp	.L579
	.p2align 4,,10
	.p2align 3
.L598:
	movl	(%r8), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
.L585:
	movq	8(%rbp), %rax
	addq	$1, %rbx
	subq	%rdx, %rax
	sarq	$2, %rax
	cmpq	%rbx, %rax
	jbe	.L578
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
.L579:
	movslq	(%rdx,%rbx,4), %rdi
	movq	0(%r13), %rcx
	leaq	(%rcx,%rdi,4), %r8
	cmpq	%rax, %rsi
	jne	.L598
	movq	%r8, %rdx
	movq	%r12, %rdi
.LEHB45:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	0(%rbp), %rdx
	jmp	.L585
	.p2align 4,,10
	.p2align 3
.L578:
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
.L597:
	.cfi_restore_state
	movq	(%rsi), %rdx
	movq	8(%rsi), %rbx
	subq	%rdx, %rbx
	sarq	$2, %rbx
	subl	$1, %ebx
	js	.L578
	movslq	%ebx, %rbp
	xorl	%eax, %eax
	xorl	%esi, %esi
	salq	$2, %rbp
	jmp	.L583
	.p2align 4,,10
	.p2align 3
.L599:
	movl	(%rdx), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
.L582:
	subl	$1, %ebx
	subq	$4, %rbp
	cmpl	$-1, %ebx
	je	.L578
	movq	0(%r13), %rdx
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
.L583:
	addq	%rbp, %rdx
	cmpq	%rax, %rsi
	jne	.L599
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE45:
	jmp	.L582
.L589:
	endbr64
	movq	%rax, %rbp
	jmp	.L586
	.section	.gcc_except_table
.LLSDA8728:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8728-.LLSDACSB8728
.LLSDACSB8728:
	.uleb128 .LEHB45-.LFB8728
	.uleb128 .LEHE45-.LEHB45
	.uleb128 .L589-.LFB8728
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
.L586:
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -40
	.cfi_offset 6, -32
	.cfi_offset 12, -24
	.cfi_offset 13, -16
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L587
	call	_ZdlPv@PLT
.L587:
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
	je	.L601
	movq	%rsi, %r15
	movq	%rcx, %r13
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L606:
	movq	0(%r13), %rcx
	movq	8(%r13), %rdx
	xorl	%eax, %eax
	subq	%rcx, %rdx
	sarq	$2, %rdx
	jne	.L602
	jmp	.L603
	.p2align 4,,10
	.p2align 3
.L635:
	addq	$1, %rax
	cmpq	%rax, %rdx
	je	.L603
.L602:
	cmpl	%ebx, (%rcx,%rax,4)
	jne	.L635
.L605:
	movq	%r8, %rax
	addq	$1, %rbx
	subq	%rdi, %rax
	sarq	$2, %rax
	cmpq	%rbx, %rax
	ja	.L606
.L601:
	movq	(%r14), %rdi
	movq	8(%r14), %r8
	xorl	%ebx, %ebx
	cmpq	%rdi, %r8
	je	.L600
	.p2align 4,,10
	.p2align 3
.L604:
	movq	0(%rbp), %rcx
	movq	8(%rbp), %rdx
	subq	%rcx, %rdx
	sarq	$2, %rdx
	je	.L607
	xorl	%eax, %eax
	jmp	.L609
	.p2align 4,,10
	.p2align 3
.L636:
	addq	$1, %rax
	cmpq	%rdx, %rax
	je	.L607
.L609:
	cmpl	%ebx, (%rcx,%rax,4)
	jne	.L636
.L608:
	movq	%r8, %rax
	addq	$1, %rbx
	subq	%rdi, %rax
	sarq	$2, %rax
	cmpq	%rbx, %rax
	ja	.L604
.L600:
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
.L603:
	.cfi_restore_state
	movq	8(%r12), %rsi
	leaq	(%rdi,%rbx,4), %rdx
	cmpq	16(%r12), %rsi
	je	.L637
	movl	(%rdx), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
	jmp	.L605
	.p2align 4,,10
	.p2align 3
.L607:
	movq	8(%r12), %rsi
	leaq	(%rdi,%rbx,4), %rdx
	cmpq	16(%r12), %rsi
	je	.L638
	movl	(%rdx), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
	jmp	.L608
.L637:
	movq	%r12, %rdi
.LEHB47:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	(%r15), %rdi
	movq	8(%r15), %r8
	jmp	.L605
.L638:
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE47:
	movq	(%r14), %rdi
	movq	8(%r14), %r8
	jmp	.L608
.L619:
	endbr64
	movq	%rax, %rbp
	jmp	.L611
	.section	.gcc_except_table
.LLSDA8727:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8727-.LLSDACSB8727
.LLSDACSB8727:
	.uleb128 .LEHB47-.LFB8727
	.uleb128 .LEHE47-.LEHB47
	.uleb128 .L619-.LFB8727
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
.L611:
	.cfi_def_cfa_offset 64
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L612
	call	_ZdlPv@PLT
.L612:
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
	je	.L639
	.p2align 4,,10
	.p2align 3
.L640:
	movl	44(%r13), %r8d
	movq	48(%r13), %rcx
	movq	56(%r13), %rsi
	testl	%r8d, %r8d
	jle	.L676
	leal	-1(%r8), %edx
	movl	$1, %eax
	addq	$2, %rdx
	jmp	.L648
	.p2align 4,,10
	.p2align 3
.L716:
	jne	.L645
	ucomiss	-4(%rsi,%rax,4), %xmm1
	jp	.L645
	jne	.L645
	movl	%eax, %edi
	addq	$1, %rax
	cmpq	%rax, %rdx
	je	.L644
.L648:
	pxor	%xmm1, %xmm1
	ucomiss	-4(%rcx,%rax,4), %xmm1
	jnp	.L716
.L645:
	movq	%r13, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %r13
	cmpq	%r12, %rax
	jne	.L640
.L722:
	movq	32(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.L717
	leaq	56(%rbp), %rax
	xorl	%r13d, %r13d
	movq	%rax, 16(%rsp)
	.p2align 4,,10
	.p2align 3
.L671:
	movq	72(%rbp), %r8
	leaq	(%rdi,%r13,4), %rax
	testq	%r8, %r8
	je	.L651
	movl	(%rax), %edx
	movq	%r12, %r14
	movq	%r8, %rbx
	jmp	.L652
	.p2align 4,,10
	.p2align 3
.L719:
	movq	24(%rbx), %rbx
	testq	%rbx, %rbx
	je	.L718
.L652:
	cmpl	%edx, 32(%rbx)
	jl	.L719
	movq	16(%rbx), %rax
	jle	.L720
	movq	%rbx, %r14
	movq	%rax, %rbx
	testq	%rbx, %rbx
	jne	.L652
.L718:
	cmpq	%r14, 80(%rbp)
	jne	.L669
	cmpq	%r12, %r14
	je	.L667
	.p2align 4,,10
	.p2align 3
.L669:
	movq	%r15, %rax
	addq	$1, %r13
	subq	%rdi, %rax
	sarq	$2, %rax
	cmpq	%r13, %rax
	ja	.L671
.L643:
	testq	%rdi, %rdi
	je	.L639
	call	_ZdlPv@PLT
.L639:
	movq	56(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L721
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
.L667:
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
	jne	.L667
	movq	32(%rsp), %rdi
	movq	40(%rsp), %r15
.L668:
	movq	$0, 72(%rbp)
	movq	%r12, 80(%rbp)
	movq	%r12, 88(%rbp)
	movq	$0, 96(%rbp)
	jmp	.L669
.L676:
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L644:
	cmpl	%r8d, %edi
	jne	.L645
	cmpq	%r15, 48(%rsp)
	je	.L649
	movl	32(%r13), %eax
	movq	%r13, %rdi
	addq	$4, %r15
	movl	%eax, -4(%r15)
	movq	%r15, 40(%rsp)
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %r13
	cmpq	%r12, %rax
	jne	.L640
	jmp	.L722
	.p2align 4,,10
	.p2align 3
.L720:
	movq	24(%rbx), %rsi
	testq	%rsi, %rsi
	jne	.L659
	jmp	.L665
	.p2align 4,,10
	.p2align 3
.L723:
	movq	%rsi, %r14
	movq	16(%rsi), %rsi
	testq	%rsi, %rsi
	je	.L665
.L659:
	cmpl	32(%rsi), %edx
	jl	.L723
	movq	24(%rsi), %rsi
	testq	%rsi, %rsi
	jne	.L659
	.p2align 4,,10
	.p2align 3
.L665:
	testq	%rax, %rax
	je	.L660
.L724:
	cmpl	32(%rax), %edx
	jg	.L664
	movq	%rax, %rbx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L724
.L660:
	cmpq	%rbx, 80(%rbp)
	jne	.L666
	cmpq	%r12, %r14
	je	.L667
.L666:
	cmpq	%r14, %rbx
	je	.L669
	.p2align 4,,10
	.p2align 3
.L670:
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
	jne	.L670
	movq	32(%rsp), %rdi
	movq	40(%rsp), %r15
	jmp	.L669
	.p2align 4,,10
	.p2align 3
.L664:
	movq	24(%rax), %rax
	jmp	.L665
.L651:
	cmpq	%r12, 80(%rbp)
	jne	.L669
	jmp	.L668
.L649:
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
	jne	.L640
	jmp	.L722
.L717:
	movq	%r15, %rdi
	jmp	.L643
.L721:
	call	__stack_chk_fail@PLT
.L678:
	endbr64
	movq	%rax, %rbp
.L672:
	movq	32(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L673
	call	_ZdlPv@PLT
.L673:
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
	.uleb128 .L678-.LFB3388
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
	je	.L726
	movl	12(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	40(%rbx), %rax
	movq	%rsi, 8(%rbx)
	movq	32(%rbx), %rsi
	cmpq	%rax, %rsi
	je	.L728
.L743:
	movl	12(%rsp), %edx
	addq	$4, %rsi
	movl	%edx, -4(%rsi)
	movq	%rsi, 32(%rbx)
	cmpq	%rax, %rsi
	je	.L730
.L744:
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
.L726:
	.cfi_restore_state
	movq	%r12, %rdx
	movq	%rbx, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%rbx), %rsi
	movq	40(%rbx), %rax
	cmpq	%rax, %rsi
	jne	.L743
	.p2align 4,,10
	.p2align 3
.L728:
	movq	%r12, %rdx
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%rbx), %rsi
	movq	40(%rbx), %rax
	cmpq	%rax, %rsi
	jne	.L744
	.p2align 4,,10
	.p2align 3
.L730:
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
.L735:
	.cfi_restore_state
	endbr64
	movq	%rax, %rbp
.L732:
	movq	24(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L733
	call	_ZdlPv@PLT
.L733:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L734
	call	_ZdlPv@PLT
.L734:
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
	.uleb128 .L735-.LFB3390
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
	je	.L746
	movl	(%rsi), %ebp
	jmp	.L747
	.p2align 4,,10
	.p2align 3
.L763:
	movq	16(%r12), %rax
	movl	$1, %edx
	testq	%rax, %rax
	je	.L748
.L764:
	movq	%rax, %r12
.L747:
	movl	32(%r12), %ecx
	cmpl	%ecx, %ebp
	jl	.L763
	movq	24(%r12), %rax
	xorl	%edx, %edx
	testq	%rax, %rax
	jne	.L764
.L748:
	testb	%dl, %dl
	jne	.L765
	cmpl	%ecx, %ebp
	jle	.L756
.L755:
	movl	$1, %r15d
	cmpq	%r12, %r14
	jne	.L766
.L753:
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
.L765:
	.cfi_restore_state
	cmpq	24(%rbx), %r12
	je	.L755
.L757:
	movq	%r12, %rdi
	call	_ZSt18_Rb_tree_decrementPSt18_Rb_tree_node_base@PLT
	cmpl	32(%rax), %ebp
	jg	.L755
	movq	%rax, %r12
.L756:
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
.L766:
	.cfi_restore_state
	xorl	%r15d, %r15d
	cmpl	32(%r12), %ebp
	setl	%r15b
	jmp	.L753
	.p2align 4,,10
	.p2align 3
.L746:
	movq	%r14, %r12
	cmpq	24(%rdi), %r14
	je	.L759
	movl	(%rsi), %ebp
	jmp	.L757
	.p2align 4,,10
	.p2align 3
.L759:
	movl	$1, %r15d
	jmp	.L753
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
	je	.L768
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
.L768:
	.cfi_restore_state
	movq	(%rdi), %r14
	subq	%r14, %rdx
	movq	%rdx, %rax
	movq	%rdx, %r12
	movabsq	$2305843009213693951, %rdx
	sarq	$2, %rax
	cmpq	%rdx, %rax
	je	.L783
	testq	%rax, %rax
	je	.L776
	movabsq	$9223372036854775804, %r13
	leaq	(%rax,%rax), %rcx
	cmpq	%rcx, %rax
	jbe	.L784
.L771:
	movq	%r13, %rdi
	movq	%rsi, 8(%rsp)
	call	_Znwm@PLT
	movq	8(%rsp), %rsi
	movq	%rax, %rbp
	addq	%rax, %r13
.L772:
	movl	(%rsi), %eax
	leaq	4(%rbp,%r12), %r15
	movl	%eax, 0(%rbp,%r12)
	testq	%r12, %r12
	jg	.L785
	testq	%r14, %r14
	jne	.L774
.L775:
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
.L785:
	.cfi_restore_state
	movq	%r12, %rdx
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	memmove@PLT
.L774:
	movq	%r14, %rdi
	call	_ZdlPv@PLT
	jmp	.L775
	.p2align 4,,10
	.p2align 3
.L784:
	testq	%rcx, %rcx
	jne	.L786
	xorl	%r13d, %r13d
	xorl	%ebp, %ebp
	jmp	.L772
	.p2align 4,,10
	.p2align 3
.L776:
	movl	$4, %r13d
	jmp	.L771
.L783:
	leaq	.LC27(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.L786:
	cmpq	%rdx, %rcx
	cmovbe	%rcx, %rdx
	leaq	0(,%rdx,4), %r13
	jmp	.L771
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
	je	.L814
	js	.L815
	leaq	20(%rsp), %r13
	movl	$0, 20(%rsp)
	movq	%r13, %rsi
.LEHB53:
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	%r13, %rsi
	movq	%r12, %rdi
	movl	%ebp, 20(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.L792:
	movq	(%r12), %rax
	movl	12(%rsp), %edx
	addl	(%rax), %edx
	movl	%edx, (%rax)
	movl	12(%rsp), %ecx
	addl	%ecx, 4(%rax)
.L790:
	movq	(%rbx), %rcx
	cmpl	%edx, (%rcx)
	jle	.L793
	movl	4(%rcx), %ecx
	cmpl	%ecx, 4(%rax)
	jge	.L793
	movq	24(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L816
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
.L815:
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
	jmp	.L792
	.p2align 4,,10
	.p2align 3
.L793:
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
	je	.L817
	cmpb	$0, 56(%r13)
	je	.L797
	movsbl	67(%r13), %esi
.L798:
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
	je	.L818
	cmpb	$0, 56(%r13)
	je	.L800
	movsbl	67(%r13), %esi
.L801:
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
.L797:
	movq	%r13, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%r13), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L798
	movq	%r13, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L798
	.p2align 4,,10
	.p2align 3
.L800:
	movq	%r13, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%r13), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L801
	movq	%r13, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L801
	.p2align 4,,10
	.p2align 3
.L814:
	leaq	12(%rsp), %r13
	xorl	%esi, %esi
	movq	%r13, %rdx
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%r12), %rsi
	cmpq	16(%r12), %rsi
	je	.L789
	movl	12(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	(%r12), %rax
	movq	%rsi, 8(%r12)
	movl	(%rax), %edx
	jmp	.L790
	.p2align 4,,10
	.p2align 3
.L789:
	movq	%r13, %rdx
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	(%r12), %rax
	movl	(%rax), %edx
	jmp	.L790
.L818:
	call	_ZSt16__throw_bad_castv@PLT
.L817:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE55:
.L816:
	call	__stack_chk_fail@PLT
.L809:
	endbr64
	movq	%rax, %rbp
	jmp	.L802
.L808:
	endbr64
	movq	%rax, %rbp
	jmp	.L803
.L802:
	movq	%r13, %rdi
	call	__cxa_free_exception@PLT
.L803:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L804
	call	_ZdlPv@PLT
.L804:
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
	.uleb128 .L808-.LFB3382
	.uleb128 0
	.uleb128 .LEHB54-.LFB3382
	.uleb128 .LEHE54-.LEHB54
	.uleb128 .L809-.LFB3382
	.uleb128 0
	.uleb128 .LEHB55-.LFB3382
	.uleb128 .LEHE55-.LEHB55
	.uleb128 .L808-.LFB3382
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
	ja	.L841
	pxor	%xmm0, %xmm0
	leaq	0(,%rax,4), %r15
	movq	$0, 16(%r12)
	movups	%xmm0, (%r12)
	testq	%rax, %rax
	je	.L827
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
	jle	.L822
	movq	24(%r13), %r10
	leal	-1(%r14), %r11d
	xorl	%esi, %esi
	movl	$1, %edi
	.p2align 4,,10
	.p2align 3
.L823:
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
	jne	.L823
.L822:
	testq	%r9, %r9
	jne	.L827
.L819:
	movq	40(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L842
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
.L827:
	.cfi_restore_state
	movq	%r9, %rdi
	call	_ZdlPv@PLT
	jmp	.L819
.L841:
	leaq	.LC2(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE58:
.L842:
	call	__stack_chk_fail@PLT
.L829:
	endbr64
	movq	%rax, %rbp
.L825:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L826
	call	_ZdlPv@PLT
.L826:
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
	.uleb128 .L829-.LFB3383
	.uleb128 0
	.uleb128 .LEHB59-.LFB3383
	.uleb128 .LEHE59-.LEHB59
	.uleb128 0
	.uleb128 0
.LLSDACSE3383:
	.section	.text._ZN19quantumSparseMatrix17getTensorPositionEii,"axG",@progbits,_ZN19quantumSparseMatrix17getTensorPositionEii,comdat
	.size	_ZN19quantumSparseMatrix17getTensorPositionEii, .-_ZN19quantumSparseMatrix17getTensorPositionEii
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
	je	.L885
	movq	%rsi, %rbp
	movq	%rdi, %r15
	movq	%rsi, %rbx
	subq	%r14, %rbp
	testq	%rax, %rax
	je	.L870
	leaq	(%rax,%rax), %rsi
	movq	%rsi, 16(%rsp)
	cmpq	%rsi, %rax
	jbe	.L886
	movabsq	$9223372036854775800, %rax
	movq	%rax, 16(%rsp)
.L845:
	movq	16(%rsp), %rdi
.LEHB60:
	call	_Znwm@PLT
.LEHE60:
	movq	%rax, 8(%rsp)
.L869:
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
	je	.L887
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L888
	movq	24(%rsp), %rdi
.LEHB61:
	call	_Znwm@PLT
.LEHE61:
	movq	8(%r12), %rdx
	movq	(%r12), %rsi
	movq	%rax, %rcx
	movq	%rdx, %r8
	subq	%rsi, %r8
.L848:
	movq	24(%rsp), %rax
	movq	%rcx, %xmm0
	punpcklqdq	%xmm0, %xmm0
	addq	%rcx, %rax
	movups	%xmm0, 0(%rbp)
	movq	%rax, 16(%rbp)
	cmpq	%rsi, %rdx
	je	.L850
	movq	%r8, %rdx
	movq	%rcx, %rdi
	movq	%r8, 24(%rsp)
	call	memmove@PLT
	movq	24(%rsp), %r8
	movq	%rax, %rcx
.L850:
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
	je	.L889
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L890
	movq	24(%rsp), %rdi
.LEHB62:
	call	_Znwm@PLT
	movq	32(%r12), %rdx
	movq	24(%r12), %rsi
	movq	%rax, %rcx
	movq	%rdx, %r8
	subq	%rsi, %r8
.L852:
	movq	24(%rsp), %rax
	movq	%rcx, %xmm0
	punpcklqdq	%xmm0, %xmm0
	addq	%rcx, %rax
	movups	%xmm0, 24(%rbp)
	movq	%rax, 40(%rbp)
	cmpq	%rsi, %rdx
	je	.L854
	movq	%r8, %rdx
	movq	%rcx, %rdi
	movq	%r8, 24(%rsp)
	call	memmove@PLT
	movq	24(%rsp), %r8
	movq	%rax, %rcx
.L854:
	movl	48(%r12), %eax
	movdqu	56(%r12), %xmm6
	addq	%r8, %rcx
	movq	%rcx, 32(%rbp)
	movl	%eax, 48(%rbp)
	movups	%xmm6, 56(%rbp)
	cmpq	%r14, %rbx
	je	.L872
	movq	8(%rsp), %r12
	movq	%r14, %rbp
	pxor	%xmm0, %xmm0
	.p2align 4,,10
	.p2align 3
.L856:
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
	je	.L860
	call	_ZdlPv@PLT
	addq	$72, %rbp
	addq	$72, %r12
	pxor	%xmm0, %xmm0
	cmpq	%rbp, %rbx
	jne	.L856
.L861:
	leaq	-72(%rbx), %rax
	movq	8(%rsp), %rsi
	subq	%r14, %rax
	shrq	$3, %rax
	leaq	72(%rsi,%rax,8), %rbp
.L855:
	addq	$72, %rbp
	cmpq	%r13, %rbx
	je	.L863
	movq	%rbx, %rax
	movq	%rbp, %rdx
	.p2align 4,,10
	.p2align 3
.L864:
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
	jne	.L864
	subq	%rbx, %rax
	subq	$72, %rax
	shrq	$3, %rax
	leaq	72(%rbp,%rax,8), %rbp
.L863:
	testq	%r14, %r14
	je	.L865
	movq	%r14, %rdi
	call	_ZdlPv@PLT
.L865:
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
.L886:
	.cfi_restore_state
	testq	%rsi, %rsi
	jne	.L846
	movq	$0, 8(%rsp)
	jmp	.L869
	.p2align 4,,10
	.p2align 3
.L860:
	addq	$72, %rbp
	addq	$72, %r12
	cmpq	%rbp, %rbx
	jne	.L856
	jmp	.L861
	.p2align 4,,10
	.p2align 3
.L870:
	movq	$72, 16(%rsp)
	jmp	.L845
	.p2align 4,,10
	.p2align 3
.L887:
	movq	24(%rsp), %r8
	xorl	%ecx, %ecx
	jmp	.L848
	.p2align 4,,10
	.p2align 3
.L889:
	movq	24(%rsp), %r8
	xorl	%ecx, %ecx
	jmp	.L852
	.p2align 4,,10
	.p2align 3
.L872:
	movq	8(%rsp), %rbp
	jmp	.L855
.L890:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE62:
.L846:
	movq	16(%rsp), %rax
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	imulq	$72, %rdx, %rax
	movq	%rax, 16(%rsp)
	jmp	.L845
.L885:
	leaq	.LC27(%rip), %rdi
.LEHB63:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE63:
.L888:
.LEHB64:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE64:
.L873:
	endbr64
	movq	%rax, %rdi
	jmp	.L859
.L875:
	endbr64
	movq	%rax, %rbx
.L857:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L858
	call	_ZdlPv@PLT
.L858:
	movq	%rbx, %rdi
.L859:
	call	__cxa_begin_catch@PLT
	cmpq	$0, 8(%rsp)
	je	.L891
	movq	8(%rsp), %rdi
	call	_ZdlPv@PLT
.L868:
.LEHB65:
	call	__cxa_rethrow@PLT
.LEHE65:
.L891:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	jmp	.L868
.L874:
	endbr64
	movq	%rax, %rbp
.L867:
	call	__cxa_end_catch@PLT
	movq	%rbp, %rdi
.LEHB66:
	call	_Unwind_Resume@PLT
.LEHE66:
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
	.uleb128 .LEHB60-.LFB9377
	.uleb128 .LEHE60-.LEHB60
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB61-.LFB9377
	.uleb128 .LEHE61-.LEHB61
	.uleb128 .L873-.LFB9377
	.uleb128 0x1
	.uleb128 .LEHB62-.LFB9377
	.uleb128 .LEHE62-.LEHB62
	.uleb128 .L875-.LFB9377
	.uleb128 0x3
	.uleb128 .LEHB63-.LFB9377
	.uleb128 .LEHE63-.LEHB63
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB64-.LFB9377
	.uleb128 .LEHE64-.LEHB64
	.uleb128 .L873-.LFB9377
	.uleb128 0x1
	.uleb128 .LEHB65-.LFB9377
	.uleb128 .LEHE65-.LEHB65
	.uleb128 .L874-.LFB9377
	.uleb128 0
	.uleb128 .LEHB66-.LFB9377
	.uleb128 .LEHE66-.LEHB66
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
	je	.L893
	movq	8(%rsi), %rbx
	subq	(%rsi), %rbx
	pxor	%xmm0, %xmm0
	movq	$0, 16(%rbp)
	movq	%rbx, %rax
	movups	%xmm0, 0(%rbp)
	sarq	$2, %rax
	je	.L913
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L914
	movq	%rbx, %rdi
.LEHB67:
	call	_Znwm@PLT
.LEHE67:
	movq	%rax, %rcx
.L895:
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
	je	.L898
	movq	%rcx, %rdi
	movq	%rbx, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L898:
	addq	%rbx, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%rbp)
	movq	32(%r12), %rbx
	subq	24(%r12), %rbx
	movq	$0, 40(%rbp)
	movq	%rbx, %rax
	movups	%xmm0, 24(%rbp)
	sarq	$2, %rax
	je	.L915
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L916
	movq	%rbx, %rdi
.LEHB68:
	call	_Znwm@PLT
.LEHE68:
	movq	%rax, %rcx
.L900:
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
	je	.L903
	movq	%rcx, %rdi
	movq	%rbx, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L903:
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
.L913:
	.cfi_restore_state
	xorl	%ecx, %ecx
	jmp	.L895
	.p2align 4,,10
	.p2align 3
.L893:
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
.LEHB69:
	jmp	_ZNSt6vectorI11denseMatrixSaIS0_EE17_M_realloc_insertIJRKS0_EEEvN9__gnu_cxx17__normal_iteratorIPS0_S2_EEDpOT_
	.p2align 4,,10
	.p2align 3
.L915:
	.cfi_restore_state
	xorl	%ecx, %ecx
	jmp	.L900
.L914:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE69:
.L916:
.LEHB70:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE70:
.L907:
	endbr64
	movq	%rax, %r12
.L905:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L906
	call	_ZdlPv@PLT
.L906:
	movq	%r12, %rdi
.LEHB71:
	call	_Unwind_Resume@PLT
.LEHE71:
	.cfi_endproc
.LFE9130:
	.section	.gcc_except_table
.LLSDA9130:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE9130-.LLSDACSB9130
.LLSDACSB9130:
	.uleb128 .LEHB67-.LFB9130
	.uleb128 .LEHE67-.LEHB67
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB68-.LFB9130
	.uleb128 .LEHE68-.LEHB68
	.uleb128 .L907-.LFB9130
	.uleb128 0
	.uleb128 .LEHB69-.LFB9130
	.uleb128 .LEHE69-.LEHB69
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB70-.LFB9130
	.uleb128 .LEHE70-.LEHB70
	.uleb128 .L907-.LFB9130
	.uleb128 0
	.uleb128 .LEHB71-.LFB9130
	.uleb128 .LEHE71-.LEHB71
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
	je	.L991
	movq	%rsi, %r15
	movq	%rsi, %r12
	subq	%r13, %r15
	testq	%rax, %rax
	je	.L959
	leaq	(%rax,%rax), %rsi
	movq	%rsi, 24(%rsp)
	cmpq	%rsi, %rax
	jbe	.L992
	movabsq	$9223372036854775800, %rax
	movq	%rax, 24(%rsp)
.L919:
	movq	24(%rsp), %rdi
.LEHB72:
	call	_Znwm@PLT
.LEHE72:
	movq	%rax, 16(%rsp)
.L958:
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
	je	.L993
	movabsq	$128102389400760775, %rdx
	cmpq	%rdx, %rax
	ja	.L994
	movq	%r14, %rdi
.LEHB73:
	call	_Znwm@PLT
.LEHE73:
	movq	%rax, 40(%rsp)
	movq	8(%rbp), %rax
	movq	0(%rbp), %rbx
	movq	%rax, (%rsp)
.L922:
	movq	40(%rsp), %rbp
	movq	%rbp, %xmm0
	addq	%rbp, %r14
	punpcklqdq	%xmm0, %xmm0
	movq	%r14, 16(%r15)
	movups	%xmm0, (%r15)
	cmpq	%rbx, (%rsp)
	jne	.L935
	jmp	.L924
	.p2align 4,,10
	.p2align 3
.L925:
	movabsq	$2305843009213693951, %rdi
	cmpq	%rdi, %rax
	ja	.L995
	movq	%r14, %rdi
.LEHB74:
	call	_Znwm@PLT
.LEHE74:
	movq	%rax, %rcx
.L926:
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
	je	.L929
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L929:
	addq	%r14, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%rbp)
	movq	32(%rbx), %r14
	subq	24(%rbx), %r14
	movq	$0, 40(%rbp)
	movq	%r14, %rax
	movups	%xmm0, 24(%rbp)
	sarq	$2, %rax
	je	.L996
	movabsq	$2305843009213693951, %rdi
	cmpq	%rdi, %rax
	ja	.L997
	movq	%r14, %rdi
.LEHB75:
	call	_Znwm@PLT
	movq	%rax, %rcx
.L931:
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
	je	.L934
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L934:
	movl	48(%rbx), %eax
	movdqu	56(%rbx), %xmm2
	addq	%r14, %rcx
	addq	$72, %rbp
	movq	%rcx, -40(%rbp)
	addq	$72, %rbx
	movl	%eax, -24(%rbp)
	movups	%xmm2, -16(%rbp)
	cmpq	%rbx, (%rsp)
	je	.L924
.L935:
	movq	8(%rbx), %r14
	subq	(%rbx), %r14
	pxor	%xmm0, %xmm0
	movq	$0, 16(%rbp)
	movq	%r14, %rax
	movups	%xmm0, 0(%rbp)
	sarq	$2, %rax
	jne	.L925
	xorl	%ecx, %ecx
	jmp	.L926
	.p2align 4,,10
	.p2align 3
.L992:
	testq	%rsi, %rsi
	jne	.L920
	movq	$0, 16(%rsp)
	jmp	.L958
	.p2align 4,,10
	.p2align 3
.L996:
	xorl	%ecx, %ecx
	jmp	.L931
	.p2align 4,,10
	.p2align 3
.L924:
	movq	%rbp, 8(%r15)
	cmpq	%r13, %r12
	je	.L998
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
	jbe	.L963
	movabsq	$2305843009213693950, %rcx
	testq	%rcx, %rax
	je	.L963
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
.L947:
	movdqu	16(%rdx), %xmm1
	movdqu	(%rdx), %xmm3
	addq	$48, %rdx
	addq	$48, %rcx
	movdqu	-16(%rdx), %xmm0
	movups	%xmm3, -48(%rcx)
	movups	%xmm1, -32(%rcx)
	movups	%xmm0, -16(%rcx)
	cmpq	%rdi, %rdx
	jne	.L947
	movq	%rsi, %rcx
	andq	$-2, %rcx
	leaq	(%rcx,%rcx,2), %rdx
	salq	$3, %rdx
	leaq	0(%r13,%rdx), %rdi
	addq	16(%rsp), %rdx
	cmpq	%rcx, %rsi
	je	.L949
	movq	16(%rdi), %rcx
	movdqu	(%rdi), %xmm4
	movq	%rcx, 16(%rdx)
	movups	%xmm4, (%rdx)
.L949:
	movq	16(%rsp), %rbx
	leaq	(%rax,%rax,2), %rax
	leaq	24(%rbx,%rax,8), %rbx
.L939:
	movq	48(%rsp), %rax
	addq	$24, %rbx
	cmpq	%rax, %r12
	je	.L950
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
	je	.L951
	movq	%rcx, %rsi
	shrq	%rsi
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%r12, %rsi
	.p2align 4,,10
	.p2align 3
.L952:
	movdqu	(%rdx), %xmm6
	movdqu	16(%rdx), %xmm7
	addq	$48, %rdx
	addq	$48, %rax
	movdqu	-16(%rdx), %xmm1
	movups	%xmm6, -48(%rax)
	movups	%xmm7, -32(%rax)
	movups	%xmm1, -16(%rax)
	cmpq	%rsi, %rdx
	jne	.L952
	movq	%rcx, %rdx
	andq	$-2, %rdx
	leaq	(%rdx,%rdx,2), %rax
	salq	$3, %rax
	leaq	(%r12,%rax), %rdi
	addq	%rbx, %rax
	movq	%rdi, 32(%rsp)
	cmpq	%rcx, %rdx
	je	.L953
.L951:
	movq	32(%rsp), %rdi
	movq	16(%rdi), %rdx
	movdqu	(%rdi), %xmm2
	movq	%rdx, 16(%rax)
	movaps	%xmm2, (%rsp)
	movups	%xmm2, (%rax)
.L953:
	leaq	(%rcx,%rcx,2), %rax
	leaq	(%rbx,%rax,8), %rbx
.L950:
	testq	%r13, %r13
	je	.L954
	movq	%r13, %rdi
	call	_ZdlPv@PLT
.L954:
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
.L959:
	.cfi_restore_state
	movq	$24, 24(%rsp)
	jmp	.L919
	.p2align 4,,10
	.p2align 3
.L993:
	movq	$0, 40(%rsp)
	jmp	.L922
	.p2align 4,,10
	.p2align 3
.L963:
	movq	16(%rsp), %rcx
	movq	%r13, %rdx
	.p2align 4,,10
	.p2align 3
.L946:
	movdqu	(%rdx), %xmm5
	addq	$24, %rdx
	addq	$24, %rcx
	movups	%xmm5, -24(%rcx)
	movq	-8(%rdx), %rsi
	movq	%rsi, -8(%rcx)
	cmpq	%rdx, %r12
	jne	.L946
	jmp	.L949
	.p2align 4,,10
	.p2align 3
.L998:
	movq	16(%rsp), %rbx
	jmp	.L939
.L997:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE75:
.L995:
.LEHB76:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE76:
.L991:
	leaq	.LC27(%rip), %rdi
.LEHB77:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE77:
.L994:
.LEHB78:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE78:
.L920:
	movq	24(%rsp), %rax
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	imulq	$24, %rdx, %rax
	movq	%rax, 24(%rsp)
	jmp	.L919
.L965:
	endbr64
	movq	%rax, %rdi
	jmp	.L945
.L968:
	endbr64
	movq	%rax, %rdi
	jmp	.L938
.L969:
	endbr64
	movq	%rax, %rbx
	jmp	.L936
.L943:
	call	__cxa_end_catch@PLT
	movq	(%r15), %rdi
	testq	%rdi, %rdi
	je	.L944
	call	_ZdlPv@PLT
.L944:
	movq	%rbx, %rdi
.L945:
	call	__cxa_begin_catch@PLT
	cmpq	$0, 16(%rsp)
	je	.L999
	movq	16(%rsp), %rdi
	call	_ZdlPv@PLT
.L957:
.LEHB79:
	call	__cxa_rethrow@PLT
.LEHE79:
.L936:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L937
	call	_ZdlPv@PLT
.L937:
	movq	%rbx, %rdi
.L938:
	call	__cxa_begin_catch@PLT
	movq	40(%rsp), %rbx
.L942:
	cmpq	%rbx, %rbp
	jne	.L1000
.LEHB80:
	call	__cxa_rethrow@PLT
.LEHE80:
.L999:
	movq	%r15, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	jmp	.L957
.L966:
	endbr64
	movq	%rax, %rbp
	jmp	.L956
.L1000:
	movq	%rbx, %rdi
	addq	$72, %rbx
	call	_ZN11denseMatrixD1Ev
	jmp	.L942
.L956:
	call	__cxa_end_catch@PLT
	movq	%rbp, %rdi
.LEHB81:
	call	_Unwind_Resume@PLT
.LEHE81:
.L967:
	endbr64
	movq	%rax, %rbx
	jmp	.L943
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
	.uleb128 .LEHB72-.LFB9383
	.uleb128 .LEHE72-.LEHB72
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB73-.LFB9383
	.uleb128 .LEHE73-.LEHB73
	.uleb128 .L965-.LFB9383
	.uleb128 0x1
	.uleb128 .LEHB74-.LFB9383
	.uleb128 .LEHE74-.LEHB74
	.uleb128 .L968-.LFB9383
	.uleb128 0x1
	.uleb128 .LEHB75-.LFB9383
	.uleb128 .LEHE75-.LEHB75
	.uleb128 .L969-.LFB9383
	.uleb128 0x1
	.uleb128 .LEHB76-.LFB9383
	.uleb128 .LEHE76-.LEHB76
	.uleb128 .L968-.LFB9383
	.uleb128 0x1
	.uleb128 .LEHB77-.LFB9383
	.uleb128 .LEHE77-.LEHB77
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB78-.LFB9383
	.uleb128 .LEHE78-.LEHB78
	.uleb128 .L965-.LFB9383
	.uleb128 0x1
	.uleb128 .LEHB79-.LFB9383
	.uleb128 .LEHE79-.LEHB79
	.uleb128 .L966-.LFB9383
	.uleb128 0
	.uleb128 .LEHB80-.LFB9383
	.uleb128 .LEHE80-.LEHB80
	.uleb128 .L967-.LFB9383
	.uleb128 0x3
	.uleb128 .LEHB81-.LFB9383
	.uleb128 .LEHE81-.LEHB81
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
	je	.L1002
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
	je	.L1039
	movabsq	$128102389400760775, %rdx
	cmpq	%rdx, %rax
	ja	.L1040
	movq	%rbx, %rdi
.LEHB82:
	call	_Znwm@PLT
.LEHE82:
	movq	%rax, 8(%rsp)
.L1004:
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
	je	.L1006
	movabsq	$2305843009213693951, %r15
	jmp	.L1017
	.p2align 4,,10
	.p2align 3
.L1007:
	cmpq	%r15, %rax
	ja	.L1041
	movq	%r12, %rdi
.LEHB83:
	call	_Znwm@PLT
.LEHE83:
	movq	%rax, %rcx
.L1008:
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
	je	.L1011
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1011:
	addq	%r12, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%rbp)
	movq	32(%rbx), %r12
	subq	24(%rbx), %r12
	movq	$0, 40(%rbp)
	movq	%r12, %rax
	movups	%xmm0, 24(%rbp)
	sarq	$2, %rax
	je	.L1042
	cmpq	%r15, %rax
	ja	.L1043
	movq	%r12, %rdi
.LEHB84:
	call	_Znwm@PLT
.LEHE84:
	movq	%rax, %rcx
.L1013:
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
	je	.L1016
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1016:
	movl	48(%rbx), %eax
	movdqu	56(%rbx), %xmm1
	addq	%r12, %rcx
	addq	$72, %rbp
	movq	%rcx, -40(%rbp)
	addq	$72, %rbx
	movl	%eax, -24(%rbp)
	movups	%xmm1, -16(%rbp)
	cmpq	%rbx, (%rsp)
	je	.L1006
.L1017:
	movq	8(%rbx), %r12
	subq	(%rbx), %r12
	pxor	%xmm0, %xmm0
	movq	$0, 16(%rbp)
	movq	%r12, %rax
	movups	%xmm0, 0(%rbp)
	sarq	$2, %rax
	jne	.L1007
	xorl	%ecx, %ecx
	jmp	.L1008
	.p2align 4,,10
	.p2align 3
.L1039:
	movq	$0, 8(%rsp)
	jmp	.L1004
	.p2align 4,,10
	.p2align 3
.L1042:
	xorl	%ecx, %ecx
	jmp	.L1013
	.p2align 4,,10
	.p2align 3
.L1006:
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
.L1002:
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
.LEHB85:
	jmp	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE17_M_realloc_insertIJRKS2_EEEvN9__gnu_cxx17__normal_iteratorIPS2_S4_EEDpOT_
.LEHE85:
.L1041:
	.cfi_restore_state
.LEHB86:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE86:
.L1043:
.LEHB87:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE87:
.L1040:
.LEHB88:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE88:
.L1029:
	endbr64
	movq	%rax, %rbx
	jmp	.L1018
.L1028:
	endbr64
	movq	%rax, %rdi
	jmp	.L1020
.L1018:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L1019
	call	_ZdlPv@PLT
.L1019:
	movq	%rbx, %rdi
.L1020:
	call	__cxa_begin_catch@PLT
.L1023:
	cmpq	8(%rsp), %rbp
	jne	.L1044
.LEHB89:
	call	__cxa_rethrow@PLT
.LEHE89:
.L1044:
	movq	8(%rsp), %rbx
	movq	%rbx, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	%rbx, %rax
	addq	$72, %rax
	movq	%rax, 8(%rsp)
	jmp	.L1023
.L1027:
	endbr64
	movq	%rax, %rbp
.L1024:
	call	__cxa_end_catch@PLT
	movq	(%r14), %rdi
	testq	%rdi, %rdi
	je	.L1025
	call	_ZdlPv@PLT
.L1025:
	movq	%rbp, %rdi
.LEHB90:
	call	_Unwind_Resume@PLT
.LEHE90:
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
	.uleb128 .LEHB82-.LFB9131
	.uleb128 .LEHE82-.LEHB82
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB83-.LFB9131
	.uleb128 .LEHE83-.LEHB83
	.uleb128 .L1028-.LFB9131
	.uleb128 0x1
	.uleb128 .LEHB84-.LFB9131
	.uleb128 .LEHE84-.LEHB84
	.uleb128 .L1029-.LFB9131
	.uleb128 0x1
	.uleb128 .LEHB85-.LFB9131
	.uleb128 .LEHE85-.LEHB85
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB86-.LFB9131
	.uleb128 .LEHE86-.LEHB86
	.uleb128 .L1028-.LFB9131
	.uleb128 0x1
	.uleb128 .LEHB87-.LFB9131
	.uleb128 .LEHE87-.LEHB87
	.uleb128 .L1029-.LFB9131
	.uleb128 0x1
	.uleb128 .LEHB88-.LFB9131
	.uleb128 .LEHE88-.LEHB88
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB89-.LFB9131
	.uleb128 .LEHE89-.LEHB89
	.uleb128 .L1027-.LFB9131
	.uleb128 0
	.uleb128 .LEHB90-.LFB9131
	.uleb128 .LEHE90-.LEHB90
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
	je	.L1046
	movq	8(%r13), %rax
	movq	%rax, 8(%rcx)
	testq	%rax, %rax
	je	.L1047
	cmpq	24(%rax), %r13
	je	.L1103
	movq	$0, 16(%rax)
.L1052:
	movdqu	32(%rbx), %xmm4
	movups	%xmm4, 32(%r13)
	movdqu	48(%rbx), %xmm5
	movups	%xmm5, 48(%r13)
.L1068:
	movl	(%rbx), %eax
	movq	$0, 16(%r13)
	movq	$0, 24(%r13)
	movq	%rbp, 8(%r13)
	movq	24(%rbx), %rsi
	movl	%eax, 0(%r13)
	testq	%rsi, %rsi
	je	.L1053
	movq	%r12, %rcx
	movq	%r13, %rdx
	movq	%r15, %rdi
.LEHB91:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
	movq	%rax, 24(%r13)
.L1053:
	movq	16(%rbx), %rbp
	movq	%r13, %r14
	testq	%rbp, %rbp
	je	.L1045
	movq	8(%r12), %rbx
	testq	%rbx, %rbx
	je	.L1055
.L1105:
	movq	8(%rbx), %rax
	movq	%rax, 8(%r12)
	testq	%rax, %rax
	je	.L1056
	cmpq	24(%rax), %rbx
	je	.L1104
	movq	$0, 16(%rax)
.L1061:
	movdqu	32(%rbp), %xmm0
	movups	%xmm0, 32(%rbx)
	movdqu	48(%rbp), %xmm1
	movups	%xmm1, 48(%rbx)
.L1066:
	movl	0(%rbp), %eax
	movq	$0, 16(%rbx)
	movq	$0, 24(%rbx)
	movl	%eax, (%rbx)
	movq	%rbx, 16(%r14)
	movq	%r14, 8(%rbx)
	movq	24(%rbp), %rsi
	testq	%rsi, %rsi
	je	.L1062
	movq	%r12, %rcx
	movq	%rbx, %rdx
	movq	%r15, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
	movq	%rax, 24(%rbx)
.L1062:
	movq	16(%rbp), %rbp
	testq	%rbp, %rbp
	je	.L1045
	movq	%rbx, %r14
	movq	8(%r12), %rbx
	testq	%rbx, %rbx
	jne	.L1105
.L1055:
	movl	$64, %edi
	call	_Znwm@PLT
.LEHE91:
	movdqu	32(%rbp), %xmm2
	movq	%rax, %rbx
	movups	%xmm2, 32(%rax)
	movdqu	48(%rbp), %xmm3
	movups	%xmm3, 48(%rax)
	jmp	.L1066
	.p2align 4,,10
	.p2align 3
.L1045:
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
.L1056:
	.cfi_restore_state
	movq	$0, (%r12)
	jmp	.L1061
	.p2align 4,,10
	.p2align 3
.L1104:
	movq	16(%rax), %rdx
	movq	$0, 24(%rax)
	testq	%rdx, %rdx
	je	.L1061
	movq	24(%rdx), %rax
	movq	%rdx, 8(%r12)
	testq	%rax, %rax
	je	.L1059
	.p2align 4,,10
	.p2align 3
.L1060:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1060
	movq	%rdx, 8(%r12)
.L1059:
	movq	16(%rdx), %rax
	testq	%rax, %rax
	je	.L1061
	movq	%rax, 8(%r12)
	jmp	.L1061
	.p2align 4,,10
	.p2align 3
.L1046:
	movl	$64, %edi
.LEHB92:
	call	_Znwm@PLT
.LEHE92:
	movdqu	32(%rbx), %xmm6
	movdqu	48(%rbx), %xmm7
	movq	%rax, %r13
	movups	%xmm6, 32(%rax)
	movups	%xmm7, 48(%rax)
	jmp	.L1068
	.p2align 4,,10
	.p2align 3
.L1047:
	movq	$0, (%rcx)
	jmp	.L1052
	.p2align 4,,10
	.p2align 3
.L1103:
	movq	16(%rax), %rdx
	movq	$0, 24(%rax)
	testq	%rdx, %rdx
	je	.L1052
	movq	24(%rdx), %rax
	movq	%rdx, 8(%rcx)
	testq	%rax, %rax
	je	.L1050
	.p2align 4,,10
	.p2align 3
.L1051:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1051
	movq	%rdx, 8(%r12)
.L1050:
	movq	16(%rdx), %rax
	testq	%rax, %rax
	je	.L1052
	movq	%rax, 8(%r12)
	jmp	.L1052
.L1070:
	endbr64
	movq	%rax, %rdi
.L1064:
	call	__cxa_begin_catch@PLT
	movq	%r13, %rsi
	movq	%r15, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.LEHB93:
	call	__cxa_rethrow@PLT
.LEHE93:
.L1071:
	endbr64
	movq	%rax, %rbp
.L1065:
	call	__cxa_end_catch@PLT
	movq	%rbp, %rdi
.LEHB94:
	call	_Unwind_Resume@PLT
.LEHE94:
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
	.uleb128 .LEHB91-.LFB9428
	.uleb128 .LEHE91-.LEHB91
	.uleb128 .L1070-.LFB9428
	.uleb128 0x1
	.uleb128 .LEHB92-.LFB9428
	.uleb128 .LEHE92-.LEHB92
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB93-.LFB9428
	.uleb128 .LEHE93-.LEHB93
	.uleb128 .L1071-.LFB9428
	.uleb128 0
	.uleb128 .LEHB94-.LFB9428
	.uleb128 .LEHE94-.LEHB94
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
	je	.L1107
	movq	16(%rdi), %rbx
	movq	32(%rdi), %rax
	movq	%rdi, 16(%rsp)
	movq	%rsi, %rbp
	leaq	8(%rdi), %rdx
	movq	%rbx, (%rsp)
	movq	%rax, 8(%rsp)
	testq	%rbx, %rbx
	je	.L1108
	movq	16(%rax), %rax
	movq	$0, 8(%rbx)
	testq	%rax, %rax
	je	.L1109
	movq	%rax, 8(%rsp)
.L1109:
	movq	$0, 16(%r12)
	movq	%rdx, 24(%r12)
	movq	%rdx, 32(%r12)
	movq	16(%rbp), %rsi
	movq	$0, 40(%r12)
	testq	%rsi, %rsi
	je	.L1132
.L1110:
	movq	%rsp, %rcx
	movq	%r12, %rdi
.LEHB95:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_20_Reuse_or_alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE95:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1111:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1111
	movq	%rcx, 24(%r12)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1112:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1112
	movq	40(%rbp), %rdx
	movq	(%rsp), %rbx
	movq	%rcx, 32(%r12)
	movq	%rax, 16(%r12)
	movq	%rdx, 40(%r12)
	testq	%rbx, %rbx
	je	.L1107
	movq	16(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L1114:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1114
.L1107:
	movq	24(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1133
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
.L1108:
	.cfi_restore_state
	movq	%rdx, 24(%rdi)
	movq	%rdx, 32(%rdi)
	movq	16(%rsi), %rsi
	movq	$0, 8(%rsp)
	movq	$0, 40(%rdi)
	testq	%rsi, %rsi
	jne	.L1110
	jmp	.L1107
	.p2align 4,,10
	.p2align 3
.L1132:
	movq	%r12, %rbp
	jmp	.L1114
.L1133:
	call	__stack_chk_fail@PLT
.L1118:
	endbr64
	movq	%rax, %rbp
.L1115:
	movq	16(%rsp), %rdi
	movq	(%rsp), %rsi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
.LEHB96:
	call	_Unwind_Resume@PLT
.LEHE96:
	.cfi_endproc
.LFE8998:
	.section	.gcc_except_table
.LLSDA8998:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8998-.LLSDACSB8998
.LLSDACSB8998:
	.uleb128 .LEHB95-.LFB8998
	.uleb128 .LEHE95-.LEHB95
	.uleb128 .L1118-.LFB8998
	.uleb128 0
	.uleb128 .LEHB96-.LFB8998
	.uleb128 .LEHE96-.LEHB96
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
.LEHB97:
	call	_Znwm@PLT
.LEHE97:
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
	je	.L1135
	movq	%r15, %rcx
	movq	%r12, %rdx
	movq	%r14, %rdi
.LEHB98:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
	movq	%rax, 24(%r12)
.L1135:
	movq	16(%rbx), %rbp
	testq	%rbp, %rbp
	je	.L1134
	movq	%r12, %rbx
.L1138:
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
	je	.L1137
	movq	%r15, %rcx
	movq	%rbx, %rdx
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE98:
	movq	%rax, 24(%rbx)
.L1137:
	movq	16(%rbp), %rbp
	testq	%rbp, %rbp
	jne	.L1138
.L1134:
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
.L1141:
	.cfi_restore_state
	endbr64
	movq	%rax, %rdi
.L1139:
	call	__cxa_begin_catch@PLT
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.LEHB99:
	call	__cxa_rethrow@PLT
.LEHE99:
.L1142:
	endbr64
	movq	%rax, %rbp
.L1140:
	call	__cxa_end_catch@PLT
	movq	%rbp, %rdi
.LEHB100:
	call	_Unwind_Resume@PLT
.LEHE100:
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
	.uleb128 .LEHB97-.LFB9648
	.uleb128 .LEHE97-.LEHB97
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB98-.LFB9648
	.uleb128 .LEHE98-.LEHB98
	.uleb128 .L1141-.LFB9648
	.uleb128 0x1
	.uleb128 .LEHB99-.LFB9648
	.uleb128 .LEHE99-.LEHB99
	.uleb128 .L1142-.LFB9648
	.uleb128 0
	.uleb128 .LEHB100-.LFB9648
	.uleb128 .LEHE100-.LEHB100
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
.LCOLDB34:
	.text
.LHOTB34:
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
	je	.L1155
	leaq	32(%rsp), %r14
	movq	%rbx, %rdx
	movq	%r13, %rdi
	movq	%r13, 32(%rsp)
	movq	%r14, %rcx
.LEHB101:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE101:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1156:
	movq	%rdx, %rbp
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1156
	movq	%rbp, 88(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1157:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1157
	movq	40(%r15), %rdx
	movq	%rcx, 96(%rsp)
	movq	%rax, 80(%rsp)
	movq	%rdx, 104(%rsp)
.L1155:
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
	je	.L1158
	leaq	56(%r12), %r15
	leaq	32(%rsp), %r14
	.p2align 4,,10
	.p2align 3
.L1159:
	movl	32(%rbp), %eax
	movdqu	40(%rbp), %xmm1
	movq	%r14, %rsi
	movq	%r15, %rdi
	movl	%eax, 32(%rsp)
	movups	%xmm1, 40(%rsp)
	movq	56(%rbp), %rax
	movq	%rax, 56(%rsp)
.LEHB102:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
.LEHE102:
	movq	%rbp, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %rbp
	cmpq	%rbx, %rax
	jne	.L1159
	movl	28(%rsp), %eax
	movq	8(%r12), %rsi
	movq	16(%r12), %r8
	movl	%eax, 48(%r12)
	cmpq	%r8, %rsi
	je	.L1160
	movl	%eax, (%rsi)
	addq	$4, %rsi
	movq	%rsi, 8(%r12)
	cmpq	%rsi, %r8
	je	.L1162
.L1197:
	movl	28(%rsp), %eax
	addq	$4, %rsi
	movq	40(%r12), %r8
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
	movq	32(%r12), %rsi
	cmpq	%r8, %rsi
	je	.L1164
.L1198:
	movl	28(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 32(%r12)
	cmpq	%rsi, %r8
	je	.L1166
.L1199:
	movl	28(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 32(%r12)
.L1167:
	movq	80(%rsp), %rbx
	testq	%rbx, %rbx
	je	.L1173
.L1168:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1168
.L1173:
	movq	%r12, %rdi
.LEHB103:
	call	_ZN19quantumSparseMatrix5printEv
.LEHE103:
	movq	120(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1196
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
.L1158:
	.cfi_restore_state
	movl	$6, 48(%r12)
	xorl	%esi, %esi
.L1160:
	leaq	28(%rsp), %rdx
	movq	%r12, %rdi
	leaq	56(%r12), %r15
.LEHB104:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%r12), %rsi
	movq	16(%r12), %r8
	cmpq	%rsi, %r8
	jne	.L1197
	.p2align 4,,10
	.p2align 3
.L1162:
	leaq	28(%rsp), %rdx
	movq	%r8, %rsi
	leaq	56(%r12), %r15
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%r12), %rsi
	movq	40(%r12), %r8
	cmpq	%r8, %rsi
	jne	.L1198
	.p2align 4,,10
	.p2align 3
.L1164:
	movq	8(%rsp), %rdi
	leaq	28(%rsp), %rdx
	leaq	56(%r12), %r15
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%r12), %rsi
	movq	40(%r12), %r8
	cmpq	%rsi, %r8
	jne	.L1199
	.p2align 4,,10
	.p2align 3
.L1166:
	movq	8(%rsp), %rdi
	leaq	28(%rsp), %rdx
	movq	%r8, %rsi
	leaq	56(%r12), %r15
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE104:
	jmp	.L1167
.L1196:
	call	__stack_chk_fail@PLT
.L1178:
	endbr64
	movq	%rax, %rbp
	jmp	.L1170
.L1177:
	endbr64
	movq	%rax, %rbp
	jmp	.L1174
	.section	.gcc_except_table
.LLSDA8757:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8757-.LLSDACSB8757
.LLSDACSB8757:
	.uleb128 .LEHB101-.LFB8757
	.uleb128 .LEHE101-.LEHB101
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB102-.LFB8757
	.uleb128 .LEHE102-.LEHB102
	.uleb128 .L1178-.LFB8757
	.uleb128 0
	.uleb128 .LEHB103-.LFB8757
	.uleb128 .LEHE103-.LEHB103
	.uleb128 .L1177-.LFB8757
	.uleb128 0
	.uleb128 .LEHB104-.LFB8757
	.uleb128 .LEHE104-.LEHB104
	.uleb128 .L1178-.LFB8757
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
.L1170:
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
	je	.L1171
	call	_ZdlPv@PLT
.L1171:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L1172
	call	_ZdlPv@PLT
.L1172:
	movq	80(%rsp), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
.LEHB105:
	call	_Unwind_Resume@PLT
.L1174:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE105:
	.cfi_endproc
.LFE8757:
	.section	.gcc_except_table
.LLSDAC8757:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8757-.LLSDACSBC8757
.LLSDACSBC8757:
	.uleb128 .LEHB105-.LCOLDB34
	.uleb128 .LEHE105-.LEHB105
	.uleb128 0
	.uleb128 0
.LLSDACSEC8757:
	.section	.text.unlikely
	.text
	.size	_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE, .-_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE
	.section	.text.unlikely
	.size	_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE.cold, .-_Z23testQuantumSparseMatrixSt3mapIi8diagonalSt4lessIiESaISt4pairIKiS0_EEE.cold
.LCOLDE34:
	.text
.LHOTE34:
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
	je	.L1233
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1234
	movq	%r12, %rdi
.LEHB106:
	call	_Znwm@PLT
.LEHE106:
	movq	%rax, %rcx
.L1202:
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
	je	.L1205
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1205:
	addq	%r12, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 8(%rbx)
	movq	32(%rbp), %r12
	subq	24(%rbp), %r12
	movq	$0, 40(%rbx)
	movq	%r12, %rax
	movups	%xmm0, 24(%rbx)
	sarq	$2, %rax
	je	.L1235
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1236
	movq	%r12, %rdi
.LEHB107:
	call	_Znwm@PLT
.LEHE107:
	movq	%rax, %rcx
.L1207:
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
	je	.L1210
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1210:
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
	je	.L1200
	leaq	56(%rbx), %rdi
	movq	%rsp, %rcx
	movq	%rdi, (%rsp)
.LEHB108:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE108:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1212:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1212
	movq	%rcx, 80(%rbx)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1213:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1213
	movq	96(%rbp), %rdx
	movq	%rcx, 88(%rbx)
	movq	%rax, 72(%rbx)
	movq	%rdx, 96(%rbx)
.L1200:
	movq	8(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1237
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
.L1233:
	.cfi_restore_state
	xorl	%ecx, %ecx
	jmp	.L1202
	.p2align 4,,10
	.p2align 3
.L1235:
	xorl	%ecx, %ecx
	jmp	.L1207
.L1237:
	call	__stack_chk_fail@PLT
.L1234:
.LEHB109:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE109:
.L1236:
.LEHB110:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE110:
.L1220:
	endbr64
	movq	%rax, %rbp
	jmp	.L1214
.L1219:
	endbr64
	movq	%rax, %rbp
	jmp	.L1216
.L1214:
	movq	24(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L1216
	call	_ZdlPv@PLT
.L1216:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L1217
	call	_ZdlPv@PLT
.L1217:
	movq	%rbp, %rdi
.LEHB111:
	call	_Unwind_Resume@PLT
.LEHE111:
	.cfi_endproc
.LFE8708:
	.section	.gcc_except_table
.LLSDA8708:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8708-.LLSDACSB8708
.LLSDACSB8708:
	.uleb128 .LEHB106-.LFB8708
	.uleb128 .LEHE106-.LEHB106
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB107-.LFB8708
	.uleb128 .LEHE107-.LEHB107
	.uleb128 .L1219-.LFB8708
	.uleb128 0
	.uleb128 .LEHB108-.LFB8708
	.uleb128 .LEHE108-.LEHB108
	.uleb128 .L1220-.LFB8708
	.uleb128 0
	.uleb128 .LEHB109-.LFB8708
	.uleb128 .LEHE109-.LEHB109
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB110-.LFB8708
	.uleb128 .LEHE110-.LEHB110
	.uleb128 .L1219-.LFB8708
	.uleb128 0
	.uleb128 .LEHB111-.LFB8708
	.uleb128 .LEHE111-.LEHB111
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
	je	.L1239
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
.L1240:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L1240
	movq	%rdx, 56(%rsp)
	movq	%rbx, %rax
	.p2align 4,,10
	.p2align 3
.L1241:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1241
	movq	96(%r13), %rax
	movq	%rdx, 64(%rsp)
	movq	%rbx, 48(%rsp)
	movq	%rax, 72(%rsp)
	testq	%rbx, %rbx
	je	.L1242
	movq	%rbx, %rdx
	movq	%r12, %rax
	jmp	.L1243
	.p2align 4,,10
	.p2align 3
.L1267:
	movq	%rdx, %rax
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	je	.L1244
.L1243:
	movl	32(%rdx), %ecx
	testl	%ecx, %ecx
	jns	.L1267
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1243
.L1244:
	cmpq	%r12, %rax
	je	.L1247
	movl	32(%rax), %edx
	testl	%edx, %edx
	jg	.L1247
	movl	44(%rax), %edi
	testl	%edi, %edi
	jle	.L1257
	movq	48(%rax), %rsi
	movq	56(%rax), %rcx
	leal	-1(%rdi), %eax
	cmpl	$2, %eax
	jbe	.L1258
	movl	%edi, %edx
	pxor	%xmm2, %xmm2
	xorl	%eax, %eax
	shrl	$2, %edx
	movaps	%xmm2, %xmm3
	salq	$4, %rdx
	.p2align 4,,10
	.p2align 3
.L1250:
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
	jne	.L1250
	movl	%edi, %eax
	andl	$-4, %eax
	testb	$3, %dil
	je	.L1248
.L1249:
	movslq	%eax, %rdx
	addss	(%rsi,%rdx,4), %xmm3
	addss	(%rcx,%rdx,4), %xmm2
	leal	1(%rax), %edx
	cmpl	%edx, %edi
	jle	.L1248
	movslq	%edx, %rdx
	addl	$2, %eax
	addss	(%rsi,%rdx,4), %xmm3
	addss	(%rcx,%rdx,4), %xmm2
	cmpl	%eax, %edi
	jle	.L1248
	cltq
	addss	(%rsi,%rax,4), %xmm3
	addss	(%rcx,%rax,4), %xmm2
.L1248:
	movss	%xmm3, (%rsp)
	movss	%xmm2, 4(%rsp)
	.p2align 4,,10
	.p2align 3
.L1255:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1255
.L1254:
	movss	(%rsp), %xmm6
	movss	4(%rsp), %xmm7
	movss	%xmm6, 8(%rsp)
	movss	%xmm7, 12(%rsp)
	movq	8(%rsp), %xmm0
	movq	88(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1268
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
.L1247:
	.cfi_restore_state
	pxor	%xmm7, %xmm7
	movss	%xmm7, (%rsp)
	movss	%xmm7, 4(%rsp)
	jmp	.L1255
	.p2align 4,,10
	.p2align 3
.L1239:
	pxor	%xmm6, %xmm6
	movss	%xmm6, (%rsp)
	movss	%xmm6, 4(%rsp)
	jmp	.L1254
.L1257:
	pxor	%xmm2, %xmm2
	movaps	%xmm2, %xmm3
	jmp	.L1248
.L1258:
	pxor	%xmm2, %xmm2
	xorl	%eax, %eax
	movaps	%xmm2, %xmm3
	jmp	.L1249
.L1242:
	pxor	%xmm7, %xmm7
	movss	%xmm7, (%rsp)
	movss	%xmm7, 4(%rsp)
	jmp	.L1254
.L1268:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8722:
	.size	_Z5trace19quantumSparseMatrix, .-_Z5trace19quantumSparseMatrix
	.section	.text.unlikely
	.align 2
.LCOLDB36:
	.text
.LHOTB36:
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
	leaq	24(%rdi), %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rsi, %r14
	movq	%rdx, %rsi
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
	movq	%rdx, %rbx
	subq	$248, %rsp
	.cfi_def_cfa_offset 304
	movq	%rdx, 32(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 232(%rsp)
	xorl	%eax, %eax
	leaq	136(%rsp), %rax
	movups	%xmm0, (%rdi)
	movq	%rax, 152(%rsp)
	movq	%rax, 160(%rsp)
	leaq	184(%rsp), %rax
	movq	%rax, 200(%rsp)
	movq	%rax, 208(%rsp)
	leaq	64(%rdi), %rax
	movl	$0, 64(%rdi)
	movq	$0, 72(%rdi)
	movq	%rax, 80(%rdi)
	movq	%rax, 88(%rdi)
	movq	$0, 96(%rdi)
	movups	%xmm0, 16(%rdi)
	movups	%xmm0, 32(%rdi)
	movl	$0, 136(%rsp)
	movq	$0, 144(%rsp)
	movq	$0, 168(%rsp)
	movl	$0, 184(%rsp)
	movq	$0, 192(%rsp)
	movq	$0, 216(%rsp)
	movq	%r15, 72(%rsp)
	movq	%rax, 8(%rsp)
.LEHB112:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	0(%r13), %rax
	movq	%rbx, %rsi
	movq	%r15, %rdi
	movl	(%rax), %eax
	movl	%eax, 48(%r13)
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE112:
	movq	192(%rsp), %rbx
	leaq	176(%rsp), %rbp
	testq	%rbx, %rbx
	je	.L1278
.L1275:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1275
.L1278:
	movq	0(%r13), %rax
	leaq	56(%r13), %r12
	leaq	176(%rsp), %rbp
	movl	(%rax), %r15d
	movl	4(%rax), %eax
	movl	%r15d, %ebx
	negl	%ebx
	cmpl	%eax, %ebx
	jl	.L1285
	jmp	.L1277
	.p2align 4,,10
	.p2align 3
.L1366:
	movl	%eax, %edx
	subl	%ebx, %edx
.L1282:
	cmpl	%edx, %r15d
	jl	.L1284
	cmpl	%eax, %edx
	cmovle	%edx, %eax
	movl	%eax, %r15d
.L1284:
	movslq	%r15d, %rdi
	movl	$4, %esi
	movq	%rdi, 24(%rsp)
	call	calloc@PLT
	movq	24(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, 16(%rsp)
	call	calloc@PLT
	movq	16(%rsp), %xmm0
	movq	%rbp, %rsi
	movq	%r12, %rdi
	movq	%rax, %xmm4
	movl	%ebx, 176(%rsp)
	punpcklqdq	%xmm4, %xmm0
	movl	%ebx, 184(%rsp)
	movl	%r15d, 188(%rsp)
	movaps	%xmm0, 192(%rsp)
.LEHB113:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	movq	0(%r13), %rdx
	addl	$1, %ebx
	movl	4(%rdx), %eax
	cmpl	%ebx, %eax
	jle	.L1277
	movl	(%rdx), %r15d
.L1285:
	leal	(%r15,%rbx), %edx
	testl	%ebx, %ebx
	js	.L1282
	jne	.L1366
	cmpl	%eax, %r15d
	movl	%eax, %edx
	cmovle	%r15d, %edx
	jmp	.L1282
	.p2align 4,,10
	.p2align 3
.L1277:
	movq	(%r14), %rax
	movl	(%rax), %edx
	testl	%edx, %edx
	jle	.L1313
	movl	$0, 16(%rsp)
	movl	4(%rax), %eax
	.p2align 4,,10
	.p2align 3
.L1312:
	testl	%eax, %eax
	jle	.L1286
	movl	16(%rsp), %eax
	xorl	%ebx, %ebx
	movq	%rax, 24(%rsp)
	.p2align 4,,10
	.p2align 3
.L1320:
	movq	%rbx, %r12
	movl	$8, %edi
	salq	$32, %r12
	orq	24(%rsp), %r12
	call	_Znwm@PLT
.LEHE113:
	movq	%r12, (%rax)
	movl	$8, %edi
	movq	%rax, %rbp
.LEHB114:
	call	_Znwm@PLT
.LEHE114:
	movq	%rax, %r12
	movq	0(%rbp), %rax
	movl	$8, %edi
	movq	%rax, (%r12)
.LEHB115:
	call	_Znwm@PLT
.LEHE115:
	movq	24(%r13), %r8
	movq	32(%r13), %rsi
	movq	%rax, %rdi
	movq	(%r12), %rax
	subq	%r8, %rsi
	movq	%rsi, %r9
	movq	%rax, (%rdi)
	sarq	$2, %r9
	je	.L1322
	leaq	-1(%r9), %rax
	cmpq	$28, %rax
	jbe	.L1323
	movq	%r9, %rdx
	movdqa	.LC35(%rip), %xmm0
	movq	%r8, %rax
	shrq	$2, %rdx
	salq	$4, %rdx
	addq	%r8, %rdx
	.p2align 4,,10
	.p2align 3
.L1289:
	movdqu	(%rax), %xmm2
	movdqu	(%rax), %xmm1
	addq	$16, %rax
	pmuludq	%xmm0, %xmm2
	psrlq	$32, %xmm1
	psrlq	$32, %xmm0
	pmuludq	%xmm0, %xmm1
	pshufd	$8, %xmm2, %xmm0
	pshufd	$8, %xmm1, %xmm1
	punpckldq	%xmm1, %xmm0
	cmpq	%rax, %rdx
	jne	.L1289
	movdqa	%xmm0, %xmm1
	movq	%r9, %rdx
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
	cmpq	%r9, %rdx
	je	.L1290
.L1288:
	addq	$1, %rax
	.p2align 4,,10
	.p2align 3
.L1291:
	imull	(%r8,%rdx,4), %ecx
	movq	%rax, %rdx
	addq	$1, %rax
	cmpq	%r9, %rdx
	jb	.L1291
.L1290:
	xorl	%r9d, %r9d
	xorl	%r15d, %r15d
	movl	$1, %r10d
	.p2align 4,,10
	.p2align 3
.L1292:
	imull	(%r8,%r9), %r10d
	movl	%ecx, %eax
	cltd
	idivl	%r10d
	imull	(%rdi,%r9), %eax
	addq	$4, %r9
	addl	%eax, %r15d
	cmpq	%r9, %rsi
	jne	.L1292
.L1287:
	call	_ZdlPv@PLT
	movl	%r15d, %eax
	movq	0(%r13), %rcx
	pxor	%xmm0, %xmm0
	cltd
	leaq	96(%rsp), %r15
	xorl	%esi, %esi
	idivl	4(%rcx)
	movaps	%xmm0, 96(%rsp)
	movq	$0, 112(%rsp)
	movq	%r15, %rdi
	movl	%edx, 88(%rsp)
	subl	%eax, %edx
	movl	%edx, 92(%rsp)
	leaq	92(%rsp), %rdx
.LEHB116:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movl	92(%rsp), %eax
	testl	%eax, %eax
	jle	.L1367
	movl	88(%rsp), %ecx
	leaq	176(%rsp), %rsi
	movq	%r15, %rdi
	subl	%eax, %ecx
	movl	%ecx, 176(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE116:
.L1295:
	movq	%r12, %rdi
	call	_ZdlPv@PLT
	movq	32(%rsp), %rax
	movl	16(%rsp), %ecx
	movq	64(%r14), %rdx
	movq	96(%rsp), %rdi
	movq	(%rax), %rax
	movl	(%rdi), %r15d
	imull	4(%rax), %ecx
	movl	%ecx, %eax
	addl	%ebx, %eax
	cltq
	movss	(%rdx,%rax,4), %xmm0
	movq	56(%r14), %rdx
	movss	(%rdx,%rax,4), %xmm1
	testl	%r15d, %r15d
	js	.L1368
	movq	0(%r13), %rdx
	movl	(%rdx), %ecx
	movl	4(%rdx), %eax
	je	.L1302
	subl	%r15d, %eax
.L1301:
	cmpl	%ecx, %eax
	jg	.L1303
	cmpl	%eax, 4(%rdx)
	cmovle	4(%rdx), %eax
	movl	%eax, %ecx
.L1303:
	movq	72(%r13), %rax
	movslq	4(%rdi), %r12
	testq	%rax, %rax
	je	.L1304
	movq	8(%rsp), %rdx
	jmp	.L1305
	.p2align 4,,10
	.p2align 3
.L1369:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	je	.L1306
.L1305:
	cmpl	32(%rax), %r15d
	jle	.L1369
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1305
.L1306:
	cmpq	%rdx, 8(%rsp)
	je	.L1304
	cmpl	32(%rdx), %r15d
	jge	.L1309
.L1304:
	movslq	%ecx, %rdi
	movl	$4, %esi
	movl	%ecx, 60(%rsp)
	movss	%xmm1, 68(%rsp)
	movss	%xmm0, 64(%rsp)
	movq	%rdi, 48(%rsp)
	call	calloc@PLT
	movq	48(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, 40(%rsp)
	call	calloc@PLT
	movq	40(%rsp), %rsi
	movss	64(%rsp), %xmm0
	leaq	56(%r13), %rdi
	movss	68(%rsp), %xmm1
	movl	60(%rsp), %ecx
	movq	%rax, %xmm3
	movl	%r15d, 176(%rsp)
	movss	%xmm0, (%rax,%r12,4)
	movq	%rsi, %xmm0
	movss	%xmm1, (%rsi,%r12,4)
	punpcklqdq	%xmm3, %xmm0
	leaq	176(%rsp), %rsi
	movl	%r15d, 184(%rsp)
	movl	%ecx, 188(%rsp)
	movaps	%xmm0, 192(%rsp)
.LEHB117:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
.LEHE117:
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1310
.L1311:
	movq	%rbp, %rdi
	addl	$1, %ebx
	call	_ZdlPv@PLT
	movq	(%r14), %rdx
	movl	4(%rdx), %eax
	cmpl	%ebx, %eax
	jg	.L1320
	movl	(%rdx), %edx
.L1286:
	addl	$1, 16(%rsp)
	movl	16(%rsp), %ebx
	cmpl	%edx, %ebx
	jl	.L1312
.L1313:
	movq	%r13, %rdi
.LEHB118:
	call	_ZN19quantumSparseMatrix11pruneMatrixEv
	movq	72(%rsp), %rdi
	leaq	24(%r14), %rsi
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE118:
	movq	144(%rsp), %rbx
	leaq	128(%rsp), %rbp
	testq	%rbx, %rbx
	je	.L1269
.L1314:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1314
.L1269:
	movq	232(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1370
	addq	$248, %rsp
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
.L1309:
	.cfi_restore_state
	movq	56(%rdx), %rax
	movq	48(%rdx), %rdx
	movss	%xmm1, (%rdx,%r12,4)
	movss	%xmm0, (%rax,%r12,4)
.L1310:
	call	_ZdlPv@PLT
	jmp	.L1311
	.p2align 4,,10
	.p2align 3
.L1368:
	movq	0(%r13), %rdx
	movl	(%rdx), %ecx
	leal	(%r15,%rcx), %eax
	jmp	.L1301
	.p2align 4,,10
	.p2align 3
.L1367:
	movq	104(%rsp), %rsi
	cmpq	112(%rsp), %rsi
	je	.L1294
	movl	88(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 104(%rsp)
	jmp	.L1295
	.p2align 4,,10
	.p2align 3
.L1302:
	cmpl	%ecx, %eax
	cmovg	%ecx, %eax
	jmp	.L1301
	.p2align 4,,10
	.p2align 3
.L1322:
	xorl	%r15d, %r15d
	jmp	.L1287
	.p2align 4,,10
	.p2align 3
.L1323:
	movl	$1, %ecx
	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	.L1288
	.p2align 4,,10
	.p2align 3
.L1294:
	leaq	88(%rsp), %rdx
	movq	%r15, %rdi
.LEHB119:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE119:
	jmp	.L1295
.L1370:
	call	__stack_chk_fail@PLT
.L1327:
	endbr64
	movq	%rax, %rbx
	jmp	.L1317
.L1329:
	endbr64
	movq	%rax, %rbx
	jmp	.L1298
.L1326:
	endbr64
	movq	%rax, %rbx
	jmp	.L1300
.L1325:
	endbr64
	movq	%rax, %rbx
	jmp	.L1316
.L1324:
	endbr64
	movq	%rax, %rbx
	jmp	.L1319
.L1328:
	endbr64
	movq	%rax, %rbp
	jmp	.L1271
	.section	.gcc_except_table
.LLSDA8744:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8744-.LLSDACSB8744
.LLSDACSB8744:
	.uleb128 .LEHB112-.LFB8744
	.uleb128 .LEHE112-.LEHB112
	.uleb128 .L1328-.LFB8744
	.uleb128 0
	.uleb128 .LEHB113-.LFB8744
	.uleb128 .LEHE113-.LEHB113
	.uleb128 .L1324-.LFB8744
	.uleb128 0
	.uleb128 .LEHB114-.LFB8744
	.uleb128 .LEHE114-.LEHB114
	.uleb128 .L1325-.LFB8744
	.uleb128 0
	.uleb128 .LEHB115-.LFB8744
	.uleb128 .LEHE115-.LEHB115
	.uleb128 .L1326-.LFB8744
	.uleb128 0
	.uleb128 .LEHB116-.LFB8744
	.uleb128 .LEHE116-.LEHB116
	.uleb128 .L1329-.LFB8744
	.uleb128 0
	.uleb128 .LEHB117-.LFB8744
	.uleb128 .LEHE117-.LEHB117
	.uleb128 .L1327-.LFB8744
	.uleb128 0
	.uleb128 .LEHB118-.LFB8744
	.uleb128 .LEHE118-.LEHB118
	.uleb128 .L1324-.LFB8744
	.uleb128 0
	.uleb128 .LEHB119-.LFB8744
	.uleb128 .LEHE119-.LEHB119
	.uleb128 .L1329-.LFB8744
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
.L1317:
	.cfi_def_cfa_offset 304
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1371
.L1316:
	movq	%rbp, %rdi
	call	_ZdlPv@PLT
.L1319:
	movq	%r13, %rdi
	movq	%rbx, %rbp
	call	_ZN19quantumSparseMatrixD1Ev
.L1274:
	movq	144(%rsp), %rsi
	leaq	128(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
.LEHB120:
	call	_Unwind_Resume@PLT
.LEHE120:
.L1298:
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1300
	call	_ZdlPv@PLT
.L1300:
	movq	%r12, %rdi
	call	_ZdlPv@PLT
	jmp	.L1316
.L1371:
	call	_ZdlPv@PLT
	jmp	.L1316
.L1271:
	movq	72(%r13), %rsi
	leaq	56(%r13), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	24(%r13), %rdi
	testq	%rdi, %rdi
	je	.L1272
	call	_ZdlPv@PLT
.L1272:
	movq	0(%r13), %rdi
	testq	%rdi, %rdi
	je	.L1273
	call	_ZdlPv@PLT
.L1273:
	movq	192(%rsp), %rsi
	leaq	176(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	jmp	.L1274
	.cfi_endproc
.LFE8744:
	.section	.gcc_except_table
.LLSDAC8744:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8744-.LLSDACSBC8744
.LLSDACSBC8744:
	.uleb128 .LEHB120-.LCOLDB36
	.uleb128 .LEHE120-.LEHB120
	.uleb128 0
	.uleb128 0
.LLSDACSEC8744:
	.section	.text.unlikely
	.text
	.size	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE, .-_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
	.section	.text.unlikely
	.size	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE.cold, .-_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE.cold
.LCOLDE36:
	.text
.LHOTE36:
	.section	.text.unlikely
.LCOLDB37:
	.text
.LHOTB37:
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
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rdi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdx, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$200, %rsp
	.cfi_def_cfa_offset 256
	movq	(%rsi), %r14
	movq	8(%rsi), %r15
	movq	%fs:40, %rax
	movq	%rax, 184(%rsp)
	xorl	%eax, %eax
	subq	%r14, %r15
	sarq	$3, %r15
	leaq	0(,%r15,4), %rbp
	movq	%rbp, %rdi
	call	malloc@PLT
	movq	%rbp, %rdi
	movq	%rax, %rbx
	call	malloc@PLT
	movq	%rax, %rbp
	testq	%r15, %r15
	je	.L1379
	leaq	-1(%r15), %rax
	cmpq	$2, %rax
	jbe	.L1430
	movq	%r15, %rdx
	xorl	%eax, %eax
	shrq	$2, %rdx
	salq	$4, %rdx
	.p2align 4,,10
	.p2align 3
.L1377:
	movups	(%r14,%rax,2), %xmm0
	movups	16(%r14,%rax,2), %xmm2
	movaps	%xmm0, %xmm1
	shufps	$221, %xmm2, %xmm0
	movups	%xmm0, 0(%rbp,%rax)
	shufps	$136, %xmm2, %xmm1
	movups	%xmm1, (%rbx,%rax)
	addq	$16, %rax
	cmpq	%rax, %rdx
	jne	.L1377
	movq	%r15, %rdx
	andq	$-4, %rdx
	movl	%edx, %eax
	cmpq	%rdx, %r15
	je	.L1379
.L1376:
	leaq	(%r14,%rdx,8), %rcx
	movss	(%rcx), %xmm0
	movss	%xmm0, (%rbx,%rdx,4)
	movss	4(%rcx), %xmm0
	movss	%xmm0, 0(%rbp,%rdx,4)
	leal	1(%rax), %edx
	movslq	%edx, %rdx
	cmpq	%rdx, %r15
	jbe	.L1379
	leaq	(%r14,%rdx,8), %rcx
	addl	$2, %eax
	movss	(%rcx), %xmm0
	cltq
	movss	%xmm0, (%rbx,%rdx,4)
	movss	4(%rcx), %xmm0
	movss	%xmm0, 0(%rbp,%rdx,4)
	cmpq	%rax, %r15
	jbe	.L1379
	leaq	(%r14,%rax,8), %rdx
	movss	(%rdx), %xmm0
	movss	%xmm0, (%rbx,%rax,4)
	movss	4(%rdx), %xmm0
	movss	%xmm0, 0(%rbp,%rax,4)
.L1379:
	movq	8(%r12), %rax
	movq	(%r12), %rsi
	movq	%rax, %r15
	subq	%rsi, %r15
	movq	%r15, %rdx
	sarq	$2, %rdx
	cmpl	$2, %edx
	jle	.L1500
	movq	$0, 32(%rsp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, 16(%rsp)
	testq	%rdx, %rdx
	je	.L1501
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L1502
	movq	%r15, %rdi
.LEHB121:
	call	_Znwm@PLT
.LEHE121:
	movq	(%r12), %rsi
	movq	%rax, %rcx
	movq	8(%r12), %rax
	movq	%rax, %rdx
	subq	%rsi, %rdx
	movq	%rdx, %r14
	sarq	$2, %r14
.L1382:
	movq	%rcx, %xmm0
	addq	%rcx, %r15
	punpcklqdq	%xmm0, %xmm0
	movq	%r15, 32(%rsp)
	movaps	%xmm0, 16(%rsp)
	cmpq	%rsi, %rax
	je	.L1384
	movq	%rcx, %rdi
	movq	%rdx, 8(%rsp)
	call	memmove@PLT
	movq	8(%rsp), %rdx
	movq	%rax, %rcx
.L1384:
	addq	%rdx, %rcx
	pxor	%xmm0, %xmm0
	movl	$8, %edi
	movq	$0, 64(%rsp)
	movq	%rcx, 24(%rsp)
	movaps	%xmm0, 48(%rsp)
.LEHB122:
	call	_Znwm@PLT
.LEHE122:
	movl	%r14d, %esi
	leaq	8(%rax), %rdx
	movq	%rax, 48(%rsp)
	movabsq	$4294967297, %rdi
	shrl	$31, %esi
	movq	%rdx, 64(%rsp)
	addl	%r14d, %esi
	movq	%rdi, (%rax)
	movq	%rdx, 56(%rsp)
	sarl	%esi
	cmpl	$1, %r14d
	jle	.L1385
	movq	(%r12), %rdi
	movl	(%rax), %ecx
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L1392:
	imull	(%rdi,%rdx,4), %ecx
	addq	$1, %rdx
	movl	%ecx, (%rax)
	cmpl	%edx, %esi
	jg	.L1392
.L1385:
	cmpl	%r14d, %esi
	jge	.L1393
	subl	$1, %r14d
	movq	(%r12), %rdi
	movslq	%esi, %r8
	movl	4(%rax), %ecx
	subl	%esi, %r14d
	leaq	(%r14,%r8), %rsi
	leaq	(%rdi,%r8,4), %rdx
	leaq	4(%rdi,%rsi,4), %rsi
	.p2align 4,,10
	.p2align 3
.L1394:
	imull	(%rdx), %ecx
	addq	$4, %rdx
	movl	%ecx, 4(%rax)
	cmpq	%rdx, %rsi
	jne	.L1394
.L1393:
	pxor	%xmm0, %xmm0
	movq	%rbp, %xmm5
	leaq	112(%rsp), %rbp
	movaps	%xmm0, 112(%rsp)
	leaq	48(%rsp), %rsi
	movq	%rbp, %rdi
	movaps	%xmm0, 128(%rsp)
	movaps	%xmm0, 144(%rsp)
	movq	%rbx, %xmm0
	punpcklqdq	%xmm5, %xmm0
	movups	%xmm0, 168(%rsp)
.LEHB123:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	112(%rsp), %rdx
	leaq	16(%rsp), %rsi
	leaq	136(%rsp), %rdi
	movl	(%rdx), %eax
	imull	4(%rdx), %eax
	movl	%eax, 160(%rsp)
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE123:
	movq	56(%rsp), %rdx
	movq	48(%rsp), %rsi
	pxor	%xmm0, %xmm0
	movq	$0, 96(%rsp)
	movaps	%xmm0, 80(%rsp)
	movq	%rdx, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rax
	sarq	$2, %rax
	je	.L1503
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1504
	movq	%rbx, %rdi
.LEHB124:
	call	_Znwm@PLT
.LEHE124:
	movq	56(%rsp), %rdx
	movq	48(%rsp), %rsi
	movq	%rax, %rcx
	movq	%rdx, %r12
	subq	%rsi, %r12
.L1401:
	movq	%rcx, %xmm0
	leaq	(%rcx,%rbx), %rax
	punpcklqdq	%xmm0, %xmm0
	movq	%rax, 96(%rsp)
	movaps	%xmm0, 80(%rsp)
	cmpq	%rsi, %rdx
	je	.L1403
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1403:
	addq	%r12, %rcx
	leaq	80(%rsp), %rdx
	movq	%rbp, %rsi
	movq	%r13, %rdi
	movq	%rcx, 88(%rsp)
.LEHB125:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE125:
	movq	80(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1404
	call	_ZdlPv@PLT
.L1404:
	movq	136(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1405
	call	_ZdlPv@PLT
.L1405:
	movq	112(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1406
	call	_ZdlPv@PLT
.L1406:
	movq	48(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1407
	call	_ZdlPv@PLT
.L1407:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1497
	jmp	.L1372
	.p2align 4,,10
	.p2align 3
.L1500:
	pxor	%xmm0, %xmm0
	movq	%rbp, %xmm4
	leaq	112(%rsp), %rbp
	movq	%r12, %rsi
	movaps	%xmm0, 112(%rsp)
	movq	%rbp, %rdi
	movaps	%xmm0, 128(%rsp)
	movaps	%xmm0, 144(%rsp)
	movq	%rbx, %xmm0
	punpcklqdq	%xmm4, %xmm0
	movups	%xmm0, 168(%rsp)
.LEHB126:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	112(%rsp), %rdx
	leaq	136(%rsp), %rdi
	movq	%r12, %rsi
	movl	(%rdx), %eax
	imull	4(%rdx), %eax
	movl	%eax, 160(%rsp)
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE126:
	movq	8(%r12), %rdx
	movq	(%r12), %rsi
	pxor	%xmm0, %xmm0
	movq	$0, 96(%rsp)
	movaps	%xmm0, 80(%rsp)
	movq	%rdx, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rax
	sarq	$2, %rax
	je	.L1505
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L1506
	movq	%rbx, %rdi
.LEHB127:
	call	_Znwm@PLT
.LEHE127:
	movq	8(%r12), %rdx
	movq	(%r12), %rsi
	movq	%rax, %rcx
	movq	%rdx, %r12
	subq	%rsi, %r12
.L1415:
	movq	%rcx, %xmm0
	leaq	(%rcx,%rbx), %rax
	punpcklqdq	%xmm0, %xmm0
	movq	%rax, 96(%rsp)
	movaps	%xmm0, 80(%rsp)
	cmpq	%rsi, %rdx
	je	.L1417
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1417:
	addq	%r12, %rcx
	leaq	80(%rsp), %rdx
	movq	%rbp, %rsi
	movq	%r13, %rdi
	movq	%rcx, 88(%rsp)
.LEHB128:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE128:
	movq	80(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1418
	call	_ZdlPv@PLT
.L1418:
	movq	136(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1419
	call	_ZdlPv@PLT
.L1419:
	movq	112(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1372
.L1497:
	call	_ZdlPv@PLT
.L1372:
	movq	184(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1507
	addq	$200, %rsp
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
.L1501:
	.cfi_restore_state
	movq	%r15, %rdx
	xorl	%r14d, %r14d
	xorl	%ecx, %ecx
	jmp	.L1382
	.p2align 4,,10
	.p2align 3
.L1505:
	movq	%rbx, %r12
	xorl	%ecx, %ecx
	jmp	.L1415
	.p2align 4,,10
	.p2align 3
.L1503:
	movq	%rbx, %r12
	xorl	%ecx, %ecx
	jmp	.L1401
.L1430:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L1376
.L1504:
.LEHB129:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE129:
.L1507:
	call	__stack_chk_fail@PLT
.L1502:
.LEHB130:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE130:
.L1506:
.LEHB131:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE131:
.L1437:
	endbr64
	movq	%rax, %rbp
	jmp	.L1411
.L1431:
	endbr64
	movq	%rax, %rbx
	jmp	.L1423
.L1432:
	endbr64
	movq	%rax, %rbx
	jmp	.L1421
.L1435:
	endbr64
	movq	%rax, %rbp
	jmp	.L1399
.L1436:
	endbr64
	movq	%rax, %rbp
	jmp	.L1396
.L1433:
	endbr64
	movq	%rax, %r12
	jmp	.L1428
.L1434:
	endbr64
	movq	%rax, %r12
	jmp	.L1426
	.section	.gcc_except_table
.LLSDA8745:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8745-.LLSDACSB8745
.LLSDACSB8745:
	.uleb128 .LEHB121-.LFB8745
	.uleb128 .LEHE121-.LEHB121
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB122-.LFB8745
	.uleb128 .LEHE122-.LEHB122
	.uleb128 .L1435-.LFB8745
	.uleb128 0
	.uleb128 .LEHB123-.LFB8745
	.uleb128 .LEHE123-.LEHB123
	.uleb128 .L1436-.LFB8745
	.uleb128 0
	.uleb128 .LEHB124-.LFB8745
	.uleb128 .LEHE124-.LEHB124
	.uleb128 .L1431-.LFB8745
	.uleb128 0
	.uleb128 .LEHB125-.LFB8745
	.uleb128 .LEHE125-.LEHB125
	.uleb128 .L1432-.LFB8745
	.uleb128 0
	.uleb128 .LEHB126-.LFB8745
	.uleb128 .LEHE126-.LEHB126
	.uleb128 .L1437-.LFB8745
	.uleb128 0
	.uleb128 .LEHB127-.LFB8745
	.uleb128 .LEHE127-.LEHB127
	.uleb128 .L1433-.LFB8745
	.uleb128 0
	.uleb128 .LEHB128-.LFB8745
	.uleb128 .LEHE128-.LEHB128
	.uleb128 .L1434-.LFB8745
	.uleb128 0
	.uleb128 .LEHB129-.LFB8745
	.uleb128 .LEHE129-.LEHB129
	.uleb128 .L1431-.LFB8745
	.uleb128 0
	.uleb128 .LEHB130-.LFB8745
	.uleb128 .LEHE130-.LEHB130
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB131-.LFB8745
	.uleb128 .LEHE131-.LEHB131
	.uleb128 .L1433-.LFB8745
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
.L1411:
	.cfi_def_cfa_offset 256
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	136(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1412
	call	_ZdlPv@PLT
.L1412:
	movq	112(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1425
.L1499:
	call	_ZdlPv@PLT
.L1425:
	movq	%rbp, %rdi
.LEHB132:
	call	_Unwind_Resume@PLT
.L1421:
	movq	80(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1423
	call	_ZdlPv@PLT
.L1423:
	movq	%rbp, %rdi
	movq	%rbx, %rbp
	call	_ZN11denseMatrixD1Ev
.L1399:
	movq	48(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1389
	call	_ZdlPv@PLT
.L1389:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1499
	jmp	.L1425
.L1396:
	movq	136(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1397
	call	_ZdlPv@PLT
.L1397:
	movq	112(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1399
	call	_ZdlPv@PLT
	jmp	.L1399
.L1426:
	movq	80(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1428
	call	_ZdlPv@PLT
.L1428:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	%r12, %rdi
	call	_Unwind_Resume@PLT
.LEHE132:
	.cfi_endproc
.LFE8745:
	.section	.gcc_except_table
.LLSDAC8745:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8745-.LLSDACSBC8745
.LLSDACSBC8745:
	.uleb128 .LEHB132-.LCOLDB37
	.uleb128 .LEHE132-.LEHB132
	.uleb128 0
	.uleb128 0
.LLSDACSEC8745:
	.section	.text.unlikely
	.text
	.size	_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE, .-_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE
	.section	.text.unlikely
	.size	_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE.cold, .-_Z10from_numpySt6vectorISt7complexIfESaIS1_EES_IiSaIiEE.cold
.LCOLDE37:
	.text
.LHOTE37:
	.section	.rodata.str1.1
.LC38:
	.string	"!="
	.section	.rodata.str1.8
	.align 8
.LC39:
	.string	"cannot reshape into given shape"
	.section	.text.unlikely
.LCOLDB40:
	.text
.LHOTB40:
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
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rdx, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$344, %rsp
	.cfi_def_cfa_offset 400
	movq	24(%rsi), %rdi
	movq	32(%rsi), %rcx
	movq	%fs:40, %rax
	movq	%rax, 328(%rsp)
	xorl	%eax, %eax
	subq	%rdi, %rcx
	sarq	$2, %rcx
	je	.L1739
	leaq	-1(%rcx), %rax
	cmpq	$28, %rax
	jbe	.L1636
	movq	%rcx, %rdx
	movdqa	.LC35(%rip), %xmm1
	movq	%rdi, %rax
	shrq	$2, %rdx
	salq	$4, %rdx
	addq	%rdi, %rdx
	.p2align 4,,10
	.p2align 3
.L1513:
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
	jne	.L1513
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
	pshufd	$8, %xmm2, %xmm2
	pshufd	$8, %xmm1, %xmm0
	punpckldq	%xmm0, %xmm2
	movdqa	%xmm2, %xmm1
	movdqa	%xmm2, %xmm0
	psrldq	$4, %xmm1
	pmuludq	%xmm1, %xmm0
	movd	%xmm0, %esi
	cmpq	%rdx, %rcx
	je	.L1516
.L1512:
	addq	$1, %rax
	.p2align 4,,10
	.p2align 3
.L1517:
	imull	(%rdi,%rdx,4), %esi
	movq	%rax, %rdx
	addq	$1, %rax
	cmpq	%rdx, %rcx
	ja	.L1517
.L1516:
	movq	0(%r13), %rcx
	movq	8(%r13), %rbx
	subq	%rcx, %rbx
	sarq	$2, %rbx
	movq	%rbx, %rdi
	je	.L1740
.L1510:
	leaq	-1(%rbx), %rax
	cmpq	$28, %rax
	jbe	.L1637
	movq	%rbx, %rdx
	movdqa	.LC35(%rip), %xmm1
	movq	%rcx, %rax
	shrq	$2, %rdx
	salq	$4, %rdx
	addq	%rcx, %rdx
	.p2align 4,,10
	.p2align 3
.L1519:
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
	jne	.L1519
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
	pshufd	$8, %xmm2, %xmm2
	pshufd	$8, %xmm1, %xmm0
	punpckldq	%xmm0, %xmm2
	movdqa	%xmm2, %xmm1
	movdqa	%xmm2, %xmm0
	psrldq	$4, %xmm1
	pmuludq	%xmm1, %xmm0
	movd	%xmm0, %r14d
	cmpq	%rbx, %rdx
	je	.L1520
.L1518:
	addq	$1, %rax
	.p2align 4,,10
	.p2align 3
.L1521:
	imull	(%rcx,%rdx,4), %r14d
	movq	%rax, %rdx
	addq	$1, %rax
	cmpq	%rdx, %rdi
	ja	.L1521
.L1520:
	cmpl	%r14d, %esi
	jne	.L1633
	pxor	%xmm0, %xmm0
	movl	%ebx, %r15d
	movq	$0, 144(%rsp)
	movaps	%xmm0, 128(%rsp)
	cmpl	$2, %ebx
	jle	.L1523
	movl	$8, %edi
	movaps	%xmm0, 272(%rsp)
	movq	$0, 288(%rsp)
.LEHB133:
	call	_Znwm@PLT
.LEHE133:
	movabsq	$4294967297, %rcx
	leaq	8(%rax), %rdx
	movq	%rax, 272(%rsp)
	leaq	128(%rsp), %r14
	movq	%rcx, (%rax)
	leaq	272(%rsp), %rax
	movq	%r14, %rdi
	movq	%rax, %rsi
	movq	%rdx, 288(%rsp)
	movq	%rdx, 280(%rsp)
	movq	%rax, 32(%rsp)
.LEHB134:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE134:
	movq	0(%r13), %r9
	movq	128(%rsp), %rsi
	movl	%ebx, %r8d
	sarl	%r8d
	leaq	4(%r9), %rdi
	leal	-1(%r8), %ecx
	movl	(%rsi), %edx
	movq	%r9, %rax
	leaq	(%rdi,%rcx,4), %rcx
	.p2align 4,,10
	.p2align 3
.L1528:
	imull	(%rax), %edx
	addq	$4, %rax
	movl	%edx, (%rsi)
	cmpq	%rax, %rcx
	jne	.L1528
	cmpl	%r8d, %r15d
	jle	.L1532
	subl	$1, %ebx
	movslq	%r8d, %rcx
	movl	4(%rsi), %edx
	subl	%r8d, %ebx
	leaq	(%r9,%rcx,4), %rax
	addq	%rbx, %rcx
	leaq	(%rdi,%rcx,4), %rcx
	.p2align 4,,10
	.p2align 3
.L1533:
	imull	(%rax), %edx
	addq	$4, %rax
	movl	%edx, 4(%rsi)
	cmpq	%rax, %rcx
	jne	.L1533
.L1532:
	movq	272(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1534
	call	_ZdlPv@PLT
.L1534:
	leaq	232(%rsp), %rax
	pxor	%xmm0, %xmm0
	movl	$0, 64(%r12)
	movq	%r14, %rsi
	movq	%rax, 248(%rsp)
	movq	%r12, %rdi
	leaq	24(%r12), %r15
	movq	%rax, 256(%rsp)
	leaq	280(%rsp), %rax
	movq	%rax, 24(%rsp)
	movq	%rax, 296(%rsp)
	movq	%rax, 304(%rsp)
	leaq	64(%r12), %rax
	movq	$0, 72(%r12)
	movq	%rax, 80(%r12)
	movq	%rax, 88(%r12)
	movq	$0, 96(%r12)
	movups	%xmm0, (%r12)
	movups	%xmm0, 16(%r12)
	movups	%xmm0, 32(%r12)
	movl	$0, 232(%rsp)
	movq	$0, 240(%rsp)
	movq	$0, 264(%rsp)
	movl	$0, 280(%rsp)
	movq	$0, 288(%rsp)
	movq	$0, 312(%rsp)
	movq	%rax, 48(%rsp)
.LEHB135:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	movq	%r13, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE135:
	movq	(%r12), %rax
	movq	288(%rsp), %rbx
	movq	32(%rsp), %r13
	movl	(%rax), %eax
	movl	%eax, 48(%r12)
	testq	%rbx, %rbx
	je	.L1542
.L1535:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1535
.L1542:
	movq	24(%rsp), %rax
	movq	72(%rbp), %rsi
	movl	$0, 280(%rsp)
	movq	$0, 288(%rsp)
	movq	%rax, 296(%rsp)
	movq	%rax, 304(%rsp)
	movq	$0, 312(%rsp)
	testq	%rsi, %rsi
	je	.L1741
	movq	32(%rsp), %rdi
	leaq	192(%rsp), %r14
	movq	%rax, %rdx
	movq	%r14, %rcx
	movq	%rdi, 192(%rsp)
.LEHB136:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE136:
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L1543:
	movq	%rax, %r13
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L1543
	movq	%r13, 296(%rsp)
	movq	%rcx, %rax
	.p2align 4,,10
	.p2align 3
.L1544:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1544
	movq	96(%rbp), %rax
	movq	%rdx, 304(%rsp)
	movq	%rcx, 288(%rsp)
	movq	%rax, 312(%rsp)
	movq	(%r12), %rax
	movl	(%rax), %r15d
	movl	4(%rax), %eax
	movl	%r15d, %ebx
	negl	%ebx
	cmpl	%eax, %ebx
	jge	.L1736
.L1632:
	leaq	56(%r12), %r13
	jmp	.L1551
	.p2align 4,,10
	.p2align 3
.L1743:
	movl	%eax, %edx
	subl	%ebx, %edx
.L1547:
	cmpl	%r15d, %edx
	jg	.L1549
	cmpl	%eax, %edx
	cmovle	%edx, %eax
	movl	%eax, %r15d
.L1549:
	movslq	%r15d, %rdi
	movl	$4, %esi
	movq	%rdi, 16(%rsp)
	call	calloc@PLT
	movq	16(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, 8(%rsp)
	call	calloc@PLT
	movq	8(%rsp), %xmm0
	movq	%r14, %rsi
	movq	%r13, %rdi
	movq	%rax, %xmm3
	movl	%ebx, 192(%rsp)
	punpcklqdq	%xmm3, %xmm0
	movl	%ebx, 200(%rsp)
	movl	%r15d, 204(%rsp)
	movaps	%xmm0, 208(%rsp)
.LEHB137:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
.LEHE137:
	movq	(%r12), %rdx
	addl	$1, %ebx
	movl	4(%rdx), %eax
	cmpl	%ebx, %eax
	jle	.L1742
	movl	(%rdx), %r15d
.L1551:
	leal	(%rbx,%r15), %edx
	testl	%ebx, %ebx
	js	.L1547
	jne	.L1743
	cmpl	%r15d, %eax
	movl	%r15d, %edx
	cmovle	%eax, %edx
	jmp	.L1547
.L1740:
	cmpl	$1, %esi
	jne	.L1744
.L1511:
	movq	$0, 144(%rsp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, 128(%rsp)
.L1523:
	leaq	128(%rsp), %r14
	movq	%r13, %rsi
	movq	%r14, %rdi
.LEHB138:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE138:
	leaq	272(%rsp), %rax
	movq	%rax, 32(%rsp)
	jmp	.L1534
.L1608:
	movslq	%esi, %rax
	leaq	0(,%rax,4), %r8
	cmpq	%rdx, 48(%rsp)
	je	.L1607
	cmpl	32(%rdx), %r15d
	jl	.L1607
	movq	56(%rdx), %rcx
	movq	48(%rdx), %rdx
	movss	%xmm1, (%rdx,%rax,4)
	movss	%xmm0, (%rcx,%rax,4)
.L1612:
	call	_ZdlPv@PLT
.L1613:
	movq	40(%rsp), %rax
	testq	%rax, %rax
	je	.L1614
	movq	%rax, %rdi
	call	_ZdlPv@PLT
	addq	$1, 8(%rsp)
	movq	8(%rsp), %rax
	cmpl	%eax, 44(%r13)
	jg	.L1554
.L1616:
	movq	%r13, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %r13
	.p2align 4,,10
	.p2align 3
.L1736:
	cmpq	24(%rsp), %r13
	je	.L1555
	movq	$0, 8(%rsp)
	movq	48(%r13), %rax
	movq	%rax, 56(%rsp)
	movq	56(%r13), %rax
	movq	%rax, 64(%rsp)
	leaq	160(%rsp), %rax
	movq	%rax, 16(%rsp)
	movl	44(%r13), %eax
	testl	%eax, %eax
	jle	.L1616
.L1554:
	movl	32(%r13), %r15d
	movl	8(%rsp), %eax
	pxor	%xmm4, %xmm4
	movq	$0, 208(%rsp)
	movaps	%xmm4, 192(%rsp)
	movl	%eax, 124(%rsp)
	testl	%r15d, %r15d
	je	.L1745
	js	.L1746
	movq	16(%rsp), %rbx
	movq	%r14, %rdi
	movl	$0, 160(%rsp)
	movq	%rbx, %rsi
.LEHB139:
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	%rbx, %rsi
	movq	%r14, %rdi
	movl	%r15d, 160(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE139:
.L1560:
	movq	192(%rsp), %r9
	movl	124(%rsp), %eax
	addl	(%r9), %eax
	movl	%eax, (%r9)
	movl	124(%rsp), %edx
	addl	%edx, 4(%r9)
.L1558:
	movq	0(%rbp), %rdx
	movl	(%rdx), %ecx
	cmpl	%eax, %ecx
	jle	.L1561
	movl	4(%r9), %eax
	movl	4(%rdx), %ebx
	cmpl	%ebx, %eax
	jge	.L1561
	imull	%ebx, %ecx
	movq	32(%rbp), %rdx
	subq	24(%rbp), %rdx
	imull	(%r9), %ebx
	movl	%ecx, 80(%rsp)
	movq	%rdx, %rcx
	sarq	$2, %rcx
	addl	%eax, %ebx
	movabsq	$2305843009213693951, %rax
	movslq	%ecx, %r15
	movq	%rcx, 88(%rsp)
	cmpq	%rax, %r15
	ja	.L1747
	testq	%r15, %r15
	je	.L1641
	salq	$2, %r15
	movq	%r15, %rdi
.LEHB140:
	call	_Znwm@PLT
.LEHE140:
	movq	%r15, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, 40(%rsp)
	call	memset@PLT
	movq	%r15, %rcx
	movq	40(%rsp), %r15
	movq	88(%rsp), %rax
	movq	192(%rsp), %r9
	addq	%r15, %rcx
	movq	%rcx, 72(%rsp)
	testl	%eax, %eax
	jle	.L1575
	movq	%r9, 88(%rsp)
	movq	24(%rbp), %r11
	leal	-1(%rax), %r10d
	xorl	%esi, %esi
	movl	80(%rsp), %r9d
	movl	$1, %edi
	.p2align 4,,10
	.p2align 3
.L1576:
	movl	(%r11,%rsi,4), %r8d
	movl	%r9d, %eax
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
	cmpq	%r10, %rax
	jne	.L1576
	movq	88(%rsp), %r9
.L1575:
	testq	%r9, %r9
	jne	.L1574
.L1577:
	movq	72(%rsp), %r15
	subq	40(%rsp), %r15
	movq	%r15, %rax
	sarq	$2, %rax
	je	.L1748
	movabsq	$2305843009213693951, %rcx
	cmpq	%rcx, %rax
	ja	.L1749
	movq	%r15, %rdi
.LEHB141:
	call	_Znwm@PLT
.LEHE141:
	movq	%rax, %rbx
.L1579:
	movq	40(%rsp), %rax
	movq	72(%rsp), %rcx
	cmpq	%rcx, %rax
	je	.L1583
	movq	%r15, %rdx
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
.L1583:
	movq	24(%rbp), %r9
	movq	32(%rbp), %r10
	subq	%r9, %r10
	movq	%r10, %rcx
	sarq	$2, %rcx
	je	.L1642
	leaq	-1(%rcx), %rax
	cmpq	$28, %rax
	jbe	.L1643
	movq	%rcx, %rdx
	movdqa	.LC35(%rip), %xmm1
	movq	%r9, %rax
	shrq	$2, %rdx
	salq	$4, %rdx
	addq	%r9, %rdx
	.p2align 4,,10
	.p2align 3
.L1586:
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
	jne	.L1586
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
	pshufd	$8, %xmm2, %xmm2
	pshufd	$8, %xmm1, %xmm0
	punpckldq	%xmm0, %xmm2
	movdqa	%xmm2, %xmm1
	movdqa	%xmm2, %xmm0
	psrldq	$4, %xmm1
	pmuludq	%xmm1, %xmm0
	movd	%xmm0, %edi
	cmpq	%rdx, %rcx
	je	.L1587
.L1585:
	addq	$1, %rax
	.p2align 4,,10
	.p2align 3
.L1588:
	imull	(%r9,%rdx,4), %edi
	movq	%rax, %rdx
	addq	$1, %rax
	cmpq	%rdx, %rcx
	ja	.L1588
.L1587:
	xorl	%ecx, %ecx
	xorl	%r8d, %r8d
	movl	$1, %esi
	.p2align 4,,10
	.p2align 3
.L1589:
	imull	(%r9,%rcx), %esi
	movl	%edi, %eax
	cltd
	idivl	%esi
	imull	(%rbx,%rcx), %eax
	addq	$4, %rcx
	addl	%eax, %r8d
	cmpq	%r10, %rcx
	jne	.L1589
.L1584:
	movl	%r8d, %eax
	movq	(%r12), %rcx
	movq	16(%rsp), %rdi
	pxor	%xmm5, %xmm5
	cltd
	xorl	%esi, %esi
	idivl	4(%rcx)
	movaps	%xmm5, 160(%rsp)
	movq	$0, 176(%rsp)
	movl	%edx, 120(%rsp)
	subl	%eax, %edx
	movl	%edx, 124(%rsp)
	leaq	124(%rsp), %rdx
.LEHB142:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movl	124(%rsp), %eax
	testl	%eax, %eax
	jle	.L1750
	movl	120(%rsp), %ecx
	movq	16(%rsp), %rdi
	movq	%r14, %rsi
	subl	%eax, %ecx
	movl	%ecx, 192(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE142:
.L1592:
	testq	%rbx, %rbx
	je	.L1594
	movq	%rbx, %rdi
	call	_ZdlPv@PLT
.L1594:
	movq	8(%r12), %rax
	movq	(%r12), %rsi
	movq	%rax, %rdx
	subq	%rsi, %rdx
	movq	%rdx, %rcx
	sarq	$2, %rcx
	je	.L1644
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L1751
	movq	%rdx, %rdi
.LEHB143:
	call	_Znwm@PLT
.LEHE143:
	movq	%rax, %rdi
	movq	8(%r12), %rax
	movq	(%r12), %rsi
	movq	%rax, %rdx
	subq	%rsi, %rdx
.L1599:
	cmpq	%rsi, %rax
	je	.L1601
	call	memmove@PLT
	movq	%rax, %rdi
.L1601:
	movq	160(%rsp), %rax
	movl	(%rdi), %ebx
	movl	(%rax), %edx
	leal	(%rdx,%rbx), %eax
	testl	%edx, %edx
	js	.L1603
	movl	4(%rdi), %eax
	je	.L1604
	subl	%edx, %eax
.L1603:
	cmpl	%ebx, %eax
	jg	.L1605
	cmpl	%eax, 4(%rdi)
	cmovle	4(%rdi), %eax
	movl	%eax, %ebx
.L1605:
	call	_ZdlPv@PLT
	movq	8(%rsp), %rax
	movq	64(%rsp), %rcx
	movq	160(%rsp), %rdi
	movq	48(%rsp), %rdx
	movss	(%rcx,%rax,4), %xmm0
	movq	56(%rsp), %rcx
	movl	4(%rdi), %esi
	movl	(%rdi), %r15d
	movss	(%rcx,%rax,4), %xmm1
	movq	72(%r12), %rax
	testq	%rax, %rax
	jne	.L1606
	jmp	.L1752
	.p2align 4,,10
	.p2align 3
.L1753:
	movq	%rax, %rdx
	movq	16(%rax), %rax
.L1610:
	testq	%rax, %rax
	je	.L1608
.L1606:
	cmpl	32(%rax), %r15d
	jle	.L1753
	movq	24(%rax), %rax
	jmp	.L1610
	.p2align 4,,10
	.p2align 3
.L1742:
	movq	296(%rsp), %r13
	jmp	.L1736
	.p2align 4,,10
	.p2align 3
.L1561:
	movl	$14, %edx
	leaq	.LC30(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB144:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%r15d, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	124(%rsp), %esi
	movq	%r13, %rdi
	call	_ZNSolsEi@PLT
	movl	$21, %edx
	leaq	.LC31(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	%r13, %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	%r13, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%r13), %rax
	movq	-24(%rax), %rax
	movq	240(%r13,%rax), %r14
	testq	%r14, %r14
	je	.L1754
	cmpb	$0, 56(%r14)
	je	.L1564
	movsbl	67(%r14), %esi
.L1565:
	movq	%r13, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movl	$9, %edx
	leaq	.LC32(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	192(%rsp), %rax
	leaq	_ZSt4cout(%rip), %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	192(%rsp), %rax
	movq	%r13, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$21, %edx
	leaq	.LC31(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	%r13, %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	%r13, %rdi
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
	je	.L1755
	cmpb	$0, 56(%r13)
	je	.L1567
	movsbl	67(%r13), %esi
.L1568:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
.LEHE144:
	jmp	.L1726
	.p2align 4,,10
	.p2align 3
.L1741:
	movq	(%r12), %rax
	leaq	192(%rsp), %r14
	movl	(%rax), %r15d
	movl	4(%rax), %eax
	movl	%r15d, %ebx
	negl	%ebx
	cmpl	%eax, %ebx
	jl	.L1632
.L1555:
	movq	%r12, %rdi
.LEHB145:
	call	_ZN19quantumSparseMatrix11pruneMatrixEv
.LEHE145:
	movq	288(%rsp), %rbx
	movq	32(%rsp), %rbp
	testq	%rbx, %rbx
	je	.L1620
.L1617:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1617
.L1620:
	movq	240(%rsp), %rbx
	leaq	224(%rsp), %rbp
	testq	%rbx, %rbx
	je	.L1618
.L1619:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1619
.L1618:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1508
	call	_ZdlPv@PLT
.L1508:
	movq	328(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1756
	addq	$344, %rsp
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
.L1567:
	.cfi_restore_state
	movq	%r13, %rdi
.LEHB146:
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%r13), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L1568
	movq	%r13, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L1568
.L1564:
	movq	%r14, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r14), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L1565
	movq	%r14, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L1565
.L1746:
	movq	16(%rsp), %rbx
	movl	%r15d, %eax
	movq	%r14, %rdi
	negl	%eax
	movq	%rbx, %rsi
	movl	%eax, 160(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	%rbx, %rsi
	movq	%r14, %rdi
	movl	$0, 160(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE146:
	jmp	.L1560
.L1641:
	movq	$0, 72(%rsp)
	movq	$0, 40(%rsp)
.L1574:
	movq	%r9, %rdi
	call	_ZdlPv@PLT
	jmp	.L1577
.L1614:
	addq	$1, 8(%rsp)
	movq	8(%rsp), %rax
	cmpl	%eax, 44(%r13)
	jg	.L1554
	jmp	.L1616
.L1752:
	movslq	%esi, %rax
	leaq	0(,%rax,4), %r8
.L1607:
	movslq	%ebx, %rdi
	movl	$4, %esi
	movq	%r8, 104(%rsp)
	movss	%xmm1, 100(%rsp)
	movss	%xmm0, 88(%rsp)
	movq	%rdi, 80(%rsp)
	call	calloc@PLT
	movq	80(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, 72(%rsp)
	call	calloc@PLT
	movq	72(%rsp), %rcx
	movq	104(%rsp), %r8
	leaq	56(%r12), %rdi
	movss	88(%rsp), %xmm0
	movss	100(%rsp), %xmm1
	movq	%rax, %xmm6
	movq	%r14, %rsi
	movl	%r15d, 192(%rsp)
	movss	%xmm0, (%rax,%r8)
	movq	%rcx, %xmm0
	punpcklqdq	%xmm6, %xmm0
	movss	%xmm1, (%rcx,%r8)
	movl	%r15d, 200(%rsp)
	movl	%ebx, 204(%rsp)
	movaps	%xmm0, 208(%rsp)
.LEHB147:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
.LEHE147:
	movq	160(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1613
	jmp	.L1612
	.p2align 4,,10
	.p2align 3
.L1604:
	cmpl	%eax, %ebx
	cmovle	%ebx, %eax
	jmp	.L1603
.L1750:
	movq	168(%rsp), %rsi
	cmpq	176(%rsp), %rsi
	je	.L1591
	movl	120(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 168(%rsp)
	jmp	.L1592
.L1644:
	xorl	%edi, %edi
	jmp	.L1599
.L1748:
	xorl	%ebx, %ebx
	jmp	.L1579
.L1739:
	movq	(%rdx), %rcx
	movq	8(%rdx), %rbx
	movl	$1, %esi
	subq	%rcx, %rbx
	sarq	$2, %rbx
	movq	%rbx, %rdi
	jne	.L1510
	jmp	.L1511
.L1637:
	xorl	%eax, %eax
	movl	$1, %r14d
	xorl	%edx, %edx
	jmp	.L1518
.L1636:
	xorl	%eax, %eax
	movl	$1, %esi
	xorl	%edx, %edx
	jmp	.L1512
.L1745:
	leaq	124(%rsp), %rbx
	xorl	%esi, %esi
	movq	%r14, %rdi
	movq	%rbx, %rdx
.LEHB148:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	200(%rsp), %rsi
	cmpq	208(%rsp), %rsi
	je	.L1557
	movl	124(%rsp), %eax
	movq	192(%rsp), %r9
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movl	(%r9), %eax
	movq	%rsi, 200(%rsp)
	jmp	.L1558
.L1557:
	movq	%rbx, %rdx
	movq	%r14, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE148:
	movq	192(%rsp), %r9
	movl	(%r9), %eax
	jmp	.L1558
.L1642:
	xorl	%r8d, %r8d
	jmp	.L1584
.L1643:
	movl	$1, %edi
	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	.L1585
.L1591:
	movq	16(%rsp), %rdi
	leaq	120(%rsp), %rdx
.LEHB149:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE149:
	jmp	.L1592
.L1744:
	movl	$1, %r14d
.L1633:
	leaq	_ZSt4cout(%rip), %rdi
.LEHB150:
	call	_ZNSolsEi@PLT
	movl	$2, %edx
	leaq	.LC38(%rip), %rsi
	movq	%rax, %rbp
	movq	%rax, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%r14d, %esi
	movq	%rbp, %rdi
	call	_ZNSolsEi@PLT
	movq	%rax, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE150:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC39(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
.LEHB151:
	call	_ZNSt16invalid_argumentC1EPKc@PLT
.LEHE151:
	jmp	.L1725
.L1756:
	call	__stack_chk_fail@PLT
.L1754:
.LEHB152:
	call	_ZSt16__throw_bad_castv@PLT
.L1755:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE152:
.L1751:
.LEHB153:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE153:
.L1749:
.LEHB154:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE154:
.L1747:
	leaq	.LC2(%rip), %rdi
.LEHB155:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE155:
.L1647:
	endbr64
	movq	%rax, %r12
	jmp	.L1623
.L1654:
	endbr64
	movq	%rax, %rbp
	jmp	.L1525
.L1656:
	endbr64
	movq	%rax, %rbx
	jmp	.L1580
.L1648:
	endbr64
	movq	%rax, %rbp
	jmp	.L1624
.L1652:
	endbr64
	movq	%rax, %rbx
	jmp	.L1626
.L1659:
	endbr64
	movq	%rax, %rbp
	jmp	.L1595
.L1655:
	endbr64
	movq	%rax, %rbp
	jmp	.L1538
.L1650:
	endbr64
	movq	%rax, %rbp
	jmp	.L1630
.L1651:
	endbr64
	movq	%rax, %rbx
	jmp	.L1572
.L1649:
	endbr64
	movq	%rax, %rbp
	jmp	.L1527
.L1653:
	endbr64
	movq	%rax, %rbx
	jmp	.L1627
.L1723:
	endbr64
	jmp	.L1724
	.section	.gcc_except_table
.LLSDA8723:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8723-.LLSDACSB8723
.LLSDACSB8723:
	.uleb128 .LEHB133-.LFB8723
	.uleb128 .LEHE133-.LEHB133
	.uleb128 .L1654-.LFB8723
	.uleb128 0
	.uleb128 .LEHB134-.LFB8723
	.uleb128 .LEHE134-.LEHB134
	.uleb128 .L1648-.LFB8723
	.uleb128 0
	.uleb128 .LEHB135-.LFB8723
	.uleb128 .LEHE135-.LEHB135
	.uleb128 .L1655-.LFB8723
	.uleb128 0
	.uleb128 .LEHB136-.LFB8723
	.uleb128 .LEHE136-.LEHB136
	.uleb128 .L1650-.LFB8723
	.uleb128 0
	.uleb128 .LEHB137-.LFB8723
	.uleb128 .LEHE137-.LEHB137
	.uleb128 .L1651-.LFB8723
	.uleb128 0
	.uleb128 .LEHB138-.LFB8723
	.uleb128 .LEHE138-.LEHB138
	.uleb128 .L1649-.LFB8723
	.uleb128 0
	.uleb128 .LEHB139-.LFB8723
	.uleb128 .LEHE139-.LEHB139
	.uleb128 .L1723-.LFB8723
	.uleb128 0
	.uleb128 .LEHB140-.LFB8723
	.uleb128 .LEHE140-.LEHB140
	.uleb128 .L1656-.LFB8723
	.uleb128 0
	.uleb128 .LEHB141-.LFB8723
	.uleb128 .LEHE141-.LEHB141
	.uleb128 .L1652-.LFB8723
	.uleb128 0
	.uleb128 .LEHB142-.LFB8723
	.uleb128 .LEHE142-.LEHB142
	.uleb128 .L1659-.LFB8723
	.uleb128 0
	.uleb128 .LEHB143-.LFB8723
	.uleb128 .LEHE143-.LEHB143
	.uleb128 .L1653-.LFB8723
	.uleb128 0
	.uleb128 .LEHB144-.LFB8723
	.uleb128 .LEHE144-.LEHB144
	.uleb128 .L1723-.LFB8723
	.uleb128 0
	.uleb128 .LEHB145-.LFB8723
	.uleb128 .LEHE145-.LEHB145
	.uleb128 .L1651-.LFB8723
	.uleb128 0
	.uleb128 .LEHB146-.LFB8723
	.uleb128 .LEHE146-.LEHB146
	.uleb128 .L1723-.LFB8723
	.uleb128 0
	.uleb128 .LEHB147-.LFB8723
	.uleb128 .LEHE147-.LEHB147
	.uleb128 .L1653-.LFB8723
	.uleb128 0
	.uleb128 .LEHB148-.LFB8723
	.uleb128 .LEHE148-.LEHB148
	.uleb128 .L1723-.LFB8723
	.uleb128 0
	.uleb128 .LEHB149-.LFB8723
	.uleb128 .LEHE149-.LEHB149
	.uleb128 .L1659-.LFB8723
	.uleb128 0
	.uleb128 .LEHB150-.LFB8723
	.uleb128 .LEHE150-.LEHB150
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB151-.LFB8723
	.uleb128 .LEHE151-.LEHB151
	.uleb128 .L1647-.LFB8723
	.uleb128 0
	.uleb128 .LEHB152-.LFB8723
	.uleb128 .LEHE152-.LEHB152
	.uleb128 .L1723-.LFB8723
	.uleb128 0
	.uleb128 .LEHB153-.LFB8723
	.uleb128 .LEHE153-.LEHB153
	.uleb128 .L1653-.LFB8723
	.uleb128 0
	.uleb128 .LEHB154-.LFB8723
	.uleb128 .LEHE154-.LEHB154
	.uleb128 .L1652-.LFB8723
	.uleb128 0
	.uleb128 .LEHB155-.LFB8723
	.uleb128 .LEHE155-.LEHB155
	.uleb128 .L1656-.LFB8723
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
.L1725:
	.cfi_def_cfa_offset 400
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	_ZNSt16invalid_argumentD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt16invalid_argument(%rip), %rsi
	movq	%rbp, %rdi
.LEHB156:
	call	__cxa_throw@PLT
.L1623:
	movq	%rbp, %rdi
	call	__cxa_free_exception@PLT
	movq	%r12, %rdi
	call	_Unwind_Resume@PLT
.L1525:
	movq	272(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1527
	call	_ZdlPv@PLT
.L1527:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1631
	call	_ZdlPv@PLT
.L1631:
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE156:
.L1624:
	movq	272(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1527
	call	_ZdlPv@PLT
	jmp	.L1527
.L1657:
	endbr64
.L1724:
	movq	%rax, %rbx
.L1580:
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1572
.L1737:
	call	_ZdlPv@PLT
.L1572:
	movq	288(%rsp), %rsi
	movq	32(%rsp), %rdi
	movq	%rbx, %rbp
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L1630:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L1541:
	movq	240(%rsp), %rsi
	leaq	224(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	jmp	.L1527
.L1595:
	movq	160(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1596
	call	_ZdlPv@PLT
.L1596:
	testq	%rbx, %rbx
	je	.L1598
	movq	%rbx, %rdi
	call	_ZdlPv@PLT
.L1598:
	movq	%rbp, %rbx
.L1626:
	cmpq	$0, 40(%rsp)
	je	.L1572
	movq	40(%rsp), %rdi
	jmp	.L1737
.L1726:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC33(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
.LEHB157:
	call	_ZNSt12length_errorC1EPKc@PLT
.LEHE157:
	movq	_ZNSt12length_errorD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt12length_error(%rip), %rsi
	movq	%rbp, %rdi
.LEHB158:
	call	__cxa_throw@PLT
.LEHE158:
.L1658:
	endbr64
	movq	%rbp, %rdi
	movq	%rax, %rbx
	call	__cxa_free_exception@PLT
	jmp	.L1580
.L1538:
	movq	72(%r12), %rsi
	leaq	56(%r12), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	24(%r12), %rdi
	testq	%rdi, %rdi
	je	.L1539
	call	_ZdlPv@PLT
.L1539:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L1540
	call	_ZdlPv@PLT
.L1540:
	movq	288(%rsp), %rsi
	movq	32(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	jmp	.L1541
.L1627:
	movq	160(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1626
	call	_ZdlPv@PLT
	jmp	.L1626
	.cfi_endproc
.LFE8723:
	.section	.gcc_except_table
.LLSDAC8723:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8723-.LLSDACSBC8723
.LLSDACSBC8723:
	.uleb128 .LEHB156-.LCOLDB40
	.uleb128 .LEHE156-.LEHB156
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB157-.LCOLDB40
	.uleb128 .LEHE157-.LEHB157
	.uleb128 .L1658-.LCOLDB40
	.uleb128 0
	.uleb128 .LEHB158-.LCOLDB40
	.uleb128 .LEHE158-.LEHB158
	.uleb128 .L1657-.LCOLDB40
	.uleb128 0
.LLSDACSEC8723:
	.section	.text.unlikely
	.text
	.size	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE, .-_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE
	.section	.text.unlikely
	.size	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE.cold, .-_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE.cold
.LCOLDE40:
	.text
.LHOTE40:
	.section	.text.unlikely
.LCOLDB42:
	.text
.LHOTB42:
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
	je	.L1758
	leaq	16(%rdi), %rax
	movb	$49, 24(%rdi)
	movabsq	$2318545003265941862, %rbx
	movq	%rax, (%rdi)
	movq	%rbx, 16(%rdi)
	movq	$9, 8(%rdi)
	movb	$0, 25(%rdi)
.L1757:
	movq	136(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L1819
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
.L1758:
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
	je	.L1791
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
.L1761:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1761
	movq	%rcx, 56(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L1762:
	movq	%rdx, %rsi
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1762
	movq	96(%rbp), %rdx
	movq	%rsi, 64(%rsp)
	movq	%rax, 48(%rsp)
	movq	%rdx, 72(%rsp)
.L1760:
	movq	72(%r15), %r14
	leaq	88(%rsp), %rbp
	movl	$0, 88(%rsp)
	movq	$0, 96(%rsp)
	movq	%rbp, 104(%rsp)
	movq	%rbp, 112(%rsp)
	movq	$0, 120(%rsp)
	testq	%r14, %r14
	je	.L1763
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
.L1764:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L1764
	movq	%rdx, 104(%rsp)
	movq	%r14, %rax
	.p2align 4,,10
	.p2align 3
.L1765:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1765
	movq	96(%r15), %rax
	movq	56(%rsp), %rdi
	movq	%rdx, 112(%rsp)
	movq	%r14, 96(%rsp)
	movq	%rax, 120(%rsp)
	cmpq	8(%rsp), %rdi
	je	.L1781
	movsd	.LC41(%rip), %xmm1
.L1766:
	testq	%r14, %r14
	je	.L1768
	movl	32(%rdi), %eax
	movq	%r14, %rdx
	movq	%rbp, %rcx
	jmp	.L1769
	.p2align 4,,10
	.p2align 3
.L1820:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	je	.L1770
.L1769:
	cmpl	32(%rdx), %eax
	jle	.L1820
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L1769
.L1770:
	cmpq	%rbp, %rcx
	je	.L1768
	cmpl	%eax, 32(%rcx)
	jle	.L1821
.L1768:
	leaq	16(%r12), %rax
	movb	$50, 24(%r12)
	movabsq	$2318545003265941862, %rcx
	movq	%rax, (%r12)
	movq	%rcx, 16(%r12)
	movq	$9, 8(%r12)
	movb	$0, 25(%r12)
.L1767:
	testq	%r14, %r14
	jne	.L1786
.L1785:
	movq	48(%rsp), %rbx
	testq	%rbx, %rbx
	je	.L1757
.L1784:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1784
	jmp	.L1757
	.p2align 4,,10
	.p2align 3
.L1791:
	movq	%rdx, %rcx
	leaq	80(%rsp), %rbx
	jmp	.L1760
	.p2align 4,,10
	.p2align 3
.L1821:
	movl	44(%rdi), %edx
	cmpl	%edx, 44(%rcx)
	jne	.L1822
	testl	%edx, %edx
	jle	.L1775
	subl	$1, %edx
	movq	48(%rcx), %r10
	movq	48(%rdi), %rax
	leaq	4(,%rdx,4), %r11
	xorl	%edx, %edx
	jmp	.L1780
	.p2align 4,,10
	.p2align 3
.L1815:
	movq	56(%rcx), %r8
	movq	56(%rdi), %rsi
	movss	(%r8,%rdx), %xmm0
	subss	(%rsi,%rdx), %xmm0
	cvtss2sd	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	ja	.L1823
	addq	$4, %rdx
	cmpq	%r11, %rdx
	je	.L1775
.L1780:
	movss	(%r10,%rdx), %xmm0
	subss	(%rax,%rdx), %xmm0
	cvtss2sd	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L1815
	leaq	16(%r12), %rax
	movb	$52, 24(%r12)
	movabsq	$2318545003265941862, %rcx
	movq	%rax, (%r12)
	movq	%rcx, 16(%r12)
	movq	$9, 8(%r12)
	movb	$0, 25(%r12)
	.p2align 4,,10
	.p2align 3
.L1786:
	movq	24(%r14), %rsi
	movq	%rbx, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r14, %rdi
	movq	16(%r14), %r14
	call	_ZdlPv@PLT
	testq	%r14, %r14
	jne	.L1786
	jmp	.L1785
	.p2align 4,,10
	.p2align 3
.L1775:
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	cmpq	8(%rsp), %rax
	movq	%rax, %rdi
	movq	.LC41(%rip), %rax
	movq	%rax, %xmm1
	jne	.L1766
	jmp	.L1781
	.p2align 4,,10
	.p2align 3
.L1763:
	cmpq	8(%rsp), %rcx
	jne	.L1768
.L1781:
	leaq	16(%r12), %rax
	movb	$0, 20(%r12)
	movq	%rax, (%r12)
	movl	$1702195828, 16(%r12)
	movq	$4, 8(%r12)
	jmp	.L1767
	.p2align 4,,10
	.p2align 3
.L1823:
	leaq	16(%r12), %rax
	movb	$53, 24(%r12)
	movabsq	$2318545003265941862, %rcx
	movq	%rax, (%r12)
	movq	%rcx, 16(%r12)
	movq	$9, 8(%r12)
	movb	$0, 25(%r12)
	jmp	.L1786
.L1822:
	leaq	16(%r12), %rax
	movb	$51, 24(%r12)
	movabsq	$2318545003265941862, %rcx
	movq	%rax, (%r12)
	movq	%rcx, 16(%r12)
	movq	$9, 8(%r12)
	movb	$0, 25(%r12)
	jmp	.L1786
.L1819:
	call	__stack_chk_fail@PLT
.L1792:
	endbr64
	movq	%rax, %rbp
	jmp	.L1787
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
	.uleb128 .L1792-.LFB8758
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
.L1787:
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
	.uleb128 .LEHB161-.LCOLDB42
	.uleb128 .LEHE161-.LEHB161
	.uleb128 0
	.uleb128 0
.LLSDACSEC8758:
	.section	.text.unlikely
	.text
	.size	_Z11checkResultB5cxx1119quantumSparseMatrixS_, .-_Z11checkResultB5cxx1119quantumSparseMatrixS_
	.section	.text.unlikely
	.size	_Z11checkResultB5cxx1119quantumSparseMatrixS_.cold, .-_Z11checkResultB5cxx1119quantumSparseMatrixS_.cold
.LCOLDE42:
	.text
.LHOTE42:
	.section	.text.unlikely
.LCOLDB43:
	.text
.LHOTB43:
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
	subq	$536, %rsp
	.cfi_def_cfa_offset 592
	movq	32(%rsi), %r12
	movq	24(%rsi), %rbp
	movq	%rdi, 48(%rsp)
	movq	%rdx, 8(%rsp)
	movq	%r12, %rbx
	subq	%rbp, %rbx
	movq	%fs:40, %rax
	movq	%rax, 520(%rsp)
	xorl	%eax, %eax
	cmpq	$8, %rbx
	je	.L2155
	movq	(%rdx), %rsi
	movq	8(%rdx), %rdx
	cmpq	%rdx, %rsi
	je	.L2156
.L1845:
	movq	%rdx, %r13
	pxor	%xmm0, %xmm0
	movq	$0, 416(%rsp)
	subq	%rsi, %r13
	movaps	%xmm0, 400(%rsp)
	movq	%r13, %rcx
	sarq	$2, %rcx
	je	.L2157
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L2158
	movq	%r13, %rdi
.LEHB162:
	call	_Znwm@PLT
.LEHE162:
	movq	32(%r14), %r12
	movq	24(%r14), %rbp
	movq	%rax, %rcx
	movq	8(%rsp), %rax
	movq	%r12, %rbx
	movq	8(%rax), %rdx
	movq	(%rax), %rsi
	subq	%rbp, %rbx
	movq	%rdx, %r15
	subq	%rsi, %r15
.L1848:
	movq	%rcx, %xmm0
	addq	%rcx, %r13
	punpcklqdq	%xmm0, %xmm0
	movq	%r13, 416(%rsp)
	movaps	%xmm0, 400(%rsp)
	cmpq	%rdx, %rsi
	je	.L1850
	movq	%rcx, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L1850:
	movq	%rbx, %rdx
	addq	%r15, %rcx
	pxor	%xmm0, %xmm0
	movq	$0, 368(%rsp)
	sarq	$2, %rdx
	movq	%rcx, 408(%rsp)
	movaps	%xmm0, 352(%rsp)
	je	.L2159
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2160
	movq	%rbx, %rdi
.LEHB163:
	call	_Znwm@PLT
.LEHE163:
	movq	32(%r14), %r12
	movq	24(%r14), %rbp
	movq	%rax, %rcx
	movq	%r12, %r13
	subq	%rbp, %r13
.L1852:
	addq	%rcx, %rbx
	movq	%rcx, 352(%rsp)
	movq	%rbx, 368(%rsp)
	cmpq	%rbp, %r12
	je	.L1854
	movq	%rcx, %rdi
	movq	%r13, %rdx
	movq	%rbp, %rsi
	call	memcpy@PLT
	movq	%rax, %rcx
.L1854:
	leaq	352(%rsp), %rax
	leaq	128(%rsp), %rbp
	addq	%r13, %rcx
	leaq	400(%rsp), %rdx
	movq	%rax, %rsi
	movq	%rbp, %rdi
	movq	%rcx, 360(%rsp)
	movq	%rdx, 16(%rsp)
	movq	%rax, 40(%rsp)
.LEHB164:
	call	_Z17modifyTensorShapeSt6vectorIiSaIiEES1_
.LEHE164:
	movq	352(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1855
	call	_ZdlPv@PLT
.L1855:
	movq	400(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1856
	call	_ZdlPv@PLT
.L1856:
	movq	136(%rsp), %rbx
	pxor	%xmm0, %xmm0
	subq	128(%rsp), %rbx
	movl	$8, %edi
	movq	$0, 176(%rsp)
	sarq	$2, %rbx
	movaps	%xmm0, 160(%rsp)
.LEHB165:
	call	_Znwm@PLT
.LEHE165:
	movq	%rax, %rcx
	movq	%rax, 160(%rsp)
	movabsq	$4294967297, %rsi
	leaq	8(%rax), %rax
	movq	%rsi, (%rcx)
	movl	%ebx, %esi
	shrl	$31, %esi
	movq	%rax, 176(%rsp)
	addl	%ebx, %esi
	movq	%rax, 168(%rsp)
	sarl	%esi
	cmpl	$1, %ebx
	jle	.L1857
	movq	128(%rsp), %rdi
	movl	(%rcx), %edx
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L1864:
	imull	(%rdi,%rax,4), %edx
	addq	$1, %rax
	movl	%edx, (%rcx)
	cmpl	%eax, %esi
	jg	.L1864
.L1857:
	cmpl	%esi, %ebx
	jle	.L1865
	subl	$1, %ebx
	movslq	%esi, %r8
	movq	128(%rsp), %rdi
	movl	4(%rcx), %edx
	movl	%ebx, %r11d
	subl	%esi, %r11d
	leaq	(%rdi,%r8,4), %rax
	movq	%r11, %rsi
	addq	%r8, %rsi
	leaq	4(%rdi,%rsi,4), %rsi
	.p2align 4,,10
	.p2align 3
.L1866:
	imull	(%rax), %edx
	addq	$4, %rax
	movl	%edx, 4(%rcx)
	cmpq	%rax, %rsi
	jne	.L1866
.L1865:
	leaq	312(%rsp), %rax
	movq	16(%rsp), %rdi
	pxor	%xmm0, %xmm0
	leaq	160(%rsp), %rsi
	movq	%rax, 328(%rsp)
	movq	%rax, 336(%rsp)
	leaq	360(%rsp), %rax
	movq	%rax, 24(%rsp)
	movq	%rax, 376(%rsp)
	movq	%rax, 384(%rsp)
	leaq	464(%rsp), %rax
	movl	$0, 312(%rsp)
	movq	$0, 320(%rsp)
	movq	$0, 344(%rsp)
	movl	$0, 360(%rsp)
	movq	$0, 368(%rsp)
	movq	$0, 392(%rsp)
	movl	$0, 464(%rsp)
	movq	$0, 472(%rsp)
	movq	%rax, 56(%rsp)
	movq	%rax, 480(%rsp)
	movq	%rax, 488(%rsp)
	movq	$0, 496(%rsp)
	movaps	%xmm0, 400(%rsp)
	movaps	%xmm0, 416(%rsp)
	movaps	%xmm0, 432(%rsp)
.LEHB166:
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	leaq	424(%rsp), %rdi
	movq	%rbp, %rsi
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE166:
	movq	400(%rsp), %rax
	movq	368(%rsp), %rbx
	movq	40(%rsp), %rbp
	movl	(%rax), %eax
	movl	%eax, 448(%rsp)
	testq	%rbx, %rbx
	je	.L1874
.L1867:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1867
.L1874:
	movq	24(%rsp), %rax
	movq	72(%r14), %rsi
	movl	$0, 360(%rsp)
	movq	$0, 368(%rsp)
	movq	%rax, 376(%rsp)
	movq	%rax, 384(%rsp)
	movq	$0, 392(%rsp)
	testq	%rsi, %rsi
	je	.L2161
	movq	40(%rsp), %rdi
	leaq	256(%rsp), %r12
	movq	%rax, %rdx
	movq	%r12, %rcx
	movq	%rdi, 256(%rsp)
.LEHB167:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE167:
	movq	%rax, %rcx
.L1875:
	movq	%rax, %rbp
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L1875
	movq	%rbp, 376(%rsp)
	movq	%rcx, %rax
.L1876:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1876
	movq	96(%r14), %rax
	movq	%rdx, 384(%rsp)
	movq	%rcx, 368(%rsp)
	movq	%rax, 392(%rsp)
	movq	400(%rsp), %rax
	movl	(%rax), %r15d
	movl	4(%rax), %eax
	movl	%r15d, %ebx
	negl	%ebx
	cmpl	%eax, %ebx
	jge	.L2147
.L1990:
	leaq	456(%rsp), %r13
	jmp	.L1883
.L2163:
	movl	%eax, %edx
	subl	%ebx, %edx
.L1879:
	cmpl	%r15d, %edx
	jg	.L1881
	cmpl	%eax, %edx
	cmovle	%edx, %eax
	movl	%eax, %r15d
.L1881:
	movslq	%r15d, %rbp
	movl	$4, %esi
	movq	%rbp, %rdi
	call	calloc@PLT
	movl	$4, %esi
	movq	%rbp, %rdi
	movq	%rax, (%rsp)
	call	calloc@PLT
	movq	(%rsp), %xmm0
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%rax, %xmm3
	movl	%ebx, 256(%rsp)
	punpcklqdq	%xmm3, %xmm0
	movl	%ebx, 264(%rsp)
	movl	%r15d, 268(%rsp)
	movaps	%xmm0, 272(%rsp)
.LEHB168:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	movq	400(%rsp), %rdx
	addl	$1, %ebx
	movl	4(%rdx), %eax
	cmpl	%ebx, %eax
	jle	.L2162
	movl	(%rdx), %r15d
.L1883:
	leal	(%rbx,%r15), %edx
	testl	%ebx, %ebx
	js	.L1879
	jne	.L2163
	cmpl	%r15d, %eax
	movl	%r15d, %edx
	cmovle	%eax, %edx
	jmp	.L1879
.L2161:
	movq	400(%rsp), %rax
	leaq	256(%rsp), %r12
	movl	(%rax), %r15d
	movl	4(%rax), %eax
	movl	%r15d, %ebx
	negl	%ebx
	cmpl	%ebx, %eax
	jg	.L1990
.L1887:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrix11pruneMatrixEv
.LEHE168:
	movq	48(%rsp), %rsi
	movq	400(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	472(%rsp), %rdx
	movq	%rax, (%rsi)
	movq	408(%rsp), %rax
	movaps	%xmm0, 400(%rsp)
	movq	%rax, 8(%rsi)
	movq	416(%rsp), %rax
	movq	%rax, 16(%rsi)
	movq	424(%rsp), %rax
	movaps	%xmm0, 416(%rsp)
	movq	%rax, 24(%rsi)
	movq	432(%rsp), %rax
	movq	%rax, 32(%rsi)
	movq	440(%rsp), %rax
	movaps	%xmm0, 432(%rsp)
	movq	%rax, 40(%rsi)
	movl	448(%rsp), %eax
	movl	%eax, 48(%rsi)
	leaq	64(%rsi), %rax
	testq	%rdx, %rdx
	je	.L1960
	movl	464(%rsp), %ecx
	movq	%rdx, 72(%rsi)
	movl	%ecx, 64(%rsi)
	movq	480(%rsp), %rcx
	movq	%rcx, 80(%rsi)
	movq	488(%rsp), %rcx
	movq	%rcx, 88(%rsi)
	movq	%rax, 8(%rdx)
	movq	496(%rsp), %rax
	movq	$0, 472(%rsp)
	movq	%rax, 96(%rsi)
	movq	56(%rsp), %rax
	movq	$0, 496(%rsp)
	movq	%rax, 480(%rsp)
	movq	%rax, 488(%rsp)
.L1961:
	movq	368(%rsp), %rsi
	movq	40(%rsp), %rdi
	leaq	456(%rsp), %r13
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	472(%rsp), %rbx
	testq	%rbx, %rbx
	je	.L1965
.L1962:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1962
.L1965:
	movq	424(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1964
	call	_ZdlPv@PLT
.L1964:
	movq	400(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1966
	call	_ZdlPv@PLT
.L1966:
	movq	320(%rsp), %rbx
	leaq	304(%rsp), %r14
	testq	%rbx, %rbx
	je	.L1970
.L1967:
	movq	24(%rbx), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L1967
.L1970:
	movq	160(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1969
	call	_ZdlPv@PLT
.L1969:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L2150
	jmp	.L1824
.L1950:
	movslq	%ecx, %rax
	leaq	0(,%rax,4), %rcx
	cmpq	56(%rsp), %rsi
	je	.L1953
	cmpl	32(%rsi), %r13d
	jge	.L2164
.L1953:
	movslq	%ebx, %rdi
	movl	$4, %esi
	movq	%rcx, 104(%rsp)
	movss	%xmm1, 100(%rsp)
	movss	%xmm0, 96(%rsp)
	movq	%rdi, 88(%rsp)
	call	calloc@PLT
	movq	88(%rsp), %rdi
	movl	$4, %esi
	movq	%rax, (%rsp)
	call	calloc@PLT
	movq	(%rsp), %rsi
	movq	104(%rsp), %rcx
	movl	%r13d, 256(%rsp)
	movss	96(%rsp), %xmm0
	movss	100(%rsp), %xmm1
	movl	%r13d, 264(%rsp)
	movq	%rax, %xmm6
	leaq	456(%rsp), %r13
	movl	%ebx, 268(%rsp)
	movss	%xmm0, (%rax,%rcx)
	movq	%rsi, %xmm0
	movq	%r13, %rdi
	movss	%xmm1, (%rsi,%rcx)
	punpcklqdq	%xmm6, %xmm0
	movq	%r12, %rsi
	movaps	%xmm0, 272(%rsp)
.LEHB169:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
.LEHE169:
	movq	224(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L1986
.L1955:
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1956
	call	_ZdlPv@PLT
.L1956:
	testq	%r15, %r15
	je	.L1957
	movq	%r15, %rdi
	call	_ZdlPv@PLT
	addq	$1, 32(%rsp)
	movq	32(%rsp), %rax
	cmpl	%eax, 44(%rbp)
	jg	.L1886
.L1959:
	movq	%rbp, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %rbp
.L2147:
	cmpq	24(%rsp), %rbp
	je	.L1887
	movq	$0, 32(%rsp)
	movq	48(%rbp), %rax
	movq	%rax, 72(%rsp)
	movq	56(%rbp), %rax
	movq	%rax, 80(%rsp)
	leaq	224(%rsp), %rax
	movq	%rax, 64(%rsp)
	movl	44(%rbp), %eax
	testl	%eax, %eax
	jle	.L1959
.L1886:
	movl	32(%rbp), %r13d
	movl	32(%rsp), %eax
	pxor	%xmm6, %xmm6
	movq	$0, 272(%rsp)
	movaps	%xmm6, 256(%rsp)
	movl	%eax, 192(%rsp)
	testl	%r13d, %r13d
	je	.L2165
	js	.L2166
	movq	64(%rsp), %rbx
	movq	%r12, %rdi
	movl	$0, 224(%rsp)
	movq	%rbx, %rsi
.LEHB170:
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	%r13d, 224(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE170:
.L1892:
	movq	256(%rsp), %r8
	movl	192(%rsp), %eax
	addl	(%r8), %eax
	movl	%eax, (%r8)
	movl	192(%rsp), %edx
	addl	%edx, 4(%r8)
.L1890:
	movq	(%r14), %rcx
	movl	(%rcx), %edx
	cmpl	%eax, %edx
	jle	.L1893
	movl	4(%r8), %ebx
	movl	4(%rcx), %eax
	cmpl	%eax, %ebx
	jge	.L1893
	imull	%eax, %edx
	imull	(%r8), %eax
	movl	%edx, (%rsp)
	movq	32(%r14), %rdx
	subq	24(%r14), %rdx
	addl	%eax, %ebx
	movabsq	$2305843009213693951, %rax
	movq	%rdx, %rcx
	sarq	$2, %rcx
	movslq	%ecx, %r13
	movq	%rcx, 88(%rsp)
	cmpq	%rax, %r13
	ja	.L2167
	testq	%r13, %r13
	je	.L1998
	salq	$2, %r13
	movq	%r13, %rdi
.LEHB171:
	call	_Znwm@PLT
.LEHE171:
	movq	%r13, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, %r15
	call	memset@PLT
	movq	88(%rsp), %rax
	movq	256(%rsp), %r8
	testl	%eax, %eax
	jle	.L1907
	movq	24(%r14), %r10
	movl	(%rsp), %r11d
	leal	-1(%rax), %r9d
	xorl	%esi, %esi
	movl	$1, %edi
.L1908:
	movl	(%r10,%rsi,4), %r13d
	movl	%r11d, %eax
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
	movl	%edx, (%r15,%rsi,4)
	addq	$1, %rsi
	subl	%ecx, %ebx
	cmpq	%r9, %rax
	jne	.L1908
.L1907:
	testq	%r8, %r8
	jne	.L1906
.L1909:
	movq	8(%rsp), %rcx
	pxor	%xmm7, %xmm7
	xorl	%ebx, %ebx
	xorl	%eax, %eax
	movq	$0, 208(%rsp)
	xorl	%esi, %esi
	leaq	192(%rsp), %r13
	movq	(%rcx), %rdx
	movaps	%xmm7, 192(%rsp)
	cmpq	8(%rcx), %rdx
	jne	.L1910
	jmp	.L2168
	.p2align 4,,10
	.p2align 3
.L2169:
	movl	(%r8), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 200(%rsp)
.L1915:
	movq	8(%rsp), %rax
	addq	$1, %rbx
	movq	8(%rax), %rax
	movq	%rax, (%rsp)
	subq	%rdx, %rax
	sarq	$2, %rax
	cmpq	%rbx, %rax
	jbe	.L1916
	movq	208(%rsp), %rax
.L1910:
	movslq	(%rdx,%rbx,4), %rcx
	leaq	(%r15,%rcx,4), %r8
	cmpq	%rax, %rsi
	jne	.L2169
	movq	%r8, %rdx
	movq	%r13, %rdi
.LEHB172:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE172:
	movq	8(%rsp), %rax
	movq	200(%rsp), %rsi
	movq	(%rax), %rdx
	jmp	.L1915
.L1893:
	movl	$14, %edx
	leaq	.LC30(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB173:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%r13d, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	192(%rsp), %esi
	movq	%rbp, %rdi
	call	_ZNSolsEi@PLT
	movl	$21, %edx
	leaq	.LC31(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%r14), %rax
	movq	%rbp, %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%r14), %rax
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
	je	.L2170
	cmpb	$0, 56(%r12)
	je	.L1896
	movsbl	67(%r12), %esi
.L1897:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movl	$9, %edx
	leaq	.LC32(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	256(%rsp), %rax
	leaq	_ZSt4cout(%rip), %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	256(%rsp), %rax
	movq	%rbp, %rdi
	movl	4(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$21, %edx
	leaq	.LC31(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%r14), %rax
	movq	%rbp, %rdi
	movl	(%rax), %esi
	call	_ZNSolsEi@PLT
	movl	$1, %edx
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	(%r14), %rax
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
	je	.L2171
	cmpb	$0, 56(%rbp)
	je	.L1899
	movsbl	67(%rbp), %esi
.L1900:
	movq	%r12, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
.LEHE173:
	jmp	.L2134
	.p2align 4,,10
	.p2align 3
.L2162:
	movq	376(%rsp), %rbp
	jmp	.L2147
.L1916:
	movq	192(%rsp), %r8
	movq	%rsi, %rdi
	subq	%r8, %rdi
	movq	%rdi, %rax
	sarq	$2, %rax
	movq	%rax, %rcx
	je	.L1917
	movabsq	$2305843009213693951, %rbx
	cmpq	%rbx, %rax
	ja	.L2172
.LEHB174:
	call	_Znwm@PLT
.LEHE174:
	movq	%rax, %r13
	movq	200(%rsp), %rax
	movq	192(%rsp), %r8
	movq	%rax, %rbx
	subq	%r8, %rbx
	movq	%rbx, %rcx
	sarq	$2, %rcx
	cmpq	%r8, %rax
	je	.L1919
.L1988:
	movq	%rbx, %rdx
	movq	%r8, %rsi
	movq	%r13, %rdi
	movq	%rcx, (%rsp)
	call	memmove@PLT
	movq	(%rsp), %rcx
.L1919:
	leaq	0(%r13,%rbx), %rax
	movq	%rax, (%rsp)
	testq	%rcx, %rcx
	je	.L2000
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L2173
	movq	%rbx, %rdi
.LEHB175:
	call	_Znwm@PLT
.LEHE175:
	movq	%rax, %r8
.L1920:
	cmpq	(%rsp), %r13
	je	.L1922
	movq	%r8, %rdi
	movq	%rbx, %rdx
	movq	%r13, %rsi
	call	memcpy@PLT
	movq	424(%rsp), %r9
	movq	%rax, %r8
	movq	432(%rsp), %rax
	subq	%r9, %rax
	sarq	$2, %rax
	je	.L2174
.L1923:
	leaq	-1(%rax), %rdx
	cmpq	$28, %rdx
	jbe	.L2001
	movq	%rax, %rcx
	movdqa	.LC35(%rip), %xmm0
	movq	%r9, %rdx
	shrq	$2, %rcx
	salq	$4, %rcx
	addq	%r9, %rcx
.L1927:
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
	cmpq	%rcx, %rdx
	jne	.L1927
	movdqa	%xmm0, %xmm1
	movq	%rax, %rcx
	psrldq	$8, %xmm1
	andq	$-4, %rcx
	movdqa	%xmm1, %xmm2
	psrlq	$32, %xmm1
	movslq	%ecx, %rdx
	pmuludq	%xmm0, %xmm2
	psrlq	$32, %xmm0
	pmuludq	%xmm1, %xmm0
	pshufd	$8, %xmm2, %xmm1
	pshufd	$8, %xmm0, %xmm0
	punpckldq	%xmm0, %xmm1
	movdqa	%xmm1, %xmm0
	psrldq	$4, %xmm1
	pmuludq	%xmm1, %xmm0
	movd	%xmm0, %edi
	cmpq	%rcx, %rax
	je	.L1928
.L1926:
	addq	$1, %rdx
.L1929:
	imull	(%r9,%rcx,4), %edi
	movq	%rdx, %rcx
	addq	$1, %rdx
	cmpq	%rax, %rcx
	jb	.L1929
.L1928:
	leaq	0(,%rax,4), %r10
	xorl	%ecx, %ecx
	xorl	%ebx, %ebx
	movl	$1, %esi
.L1930:
	imull	(%r9,%rcx), %esi
	movl	%edi, %eax
	cltd
	idivl	%esi
	imull	(%r8,%rcx), %eax
	addq	$4, %rcx
	addl	%eax, %ebx
	cmpq	%rcx, %r10
	jne	.L1930
.L1924:
	movq	%r8, %rdi
	call	_ZdlPv@PLT
.L1931:
	movl	%ebx, %eax
	movq	400(%rsp), %rcx
	pxor	%xmm7, %xmm7
	xorl	%esi, %esi
	cltd
	movq	64(%rsp), %rdi
	idivl	4(%rcx)
	movaps	%xmm7, 224(%rsp)
	movq	$0, 240(%rsp)
	movl	%edx, 120(%rsp)
	subl	%eax, %edx
	movl	%edx, 124(%rsp)
	leaq	124(%rsp), %rdx
.LEHB176:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movl	124(%rsp), %eax
	testl	%eax, %eax
	jle	.L2175
	movl	120(%rsp), %ebx
	movq	64(%rsp), %rdi
	movq	%r12, %rsi
	subl	%eax, %ebx
	movl	%ebx, 256(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE176:
.L1934:
	testq	%r13, %r13
	je	.L1936
	movq	%r13, %rdi
	call	_ZdlPv@PLT
.L1936:
	movq	168(%rsp), %rax
	movq	160(%rsp), %rsi
	movq	%rax, %rdx
	subq	%rsi, %rdx
	movq	%rdx, %rcx
	sarq	$2, %rcx
	je	.L2003
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rcx
	ja	.L2176
	movq	%rdx, %rdi
.LEHB177:
	call	_Znwm@PLT
.LEHE177:
	movq	%rax, %rdi
	movq	168(%rsp), %rax
	movq	160(%rsp), %rsi
	movq	%rax, %rdx
	subq	%rsi, %rdx
.L1941:
	cmpq	%rsi, %rax
	je	.L1943
	call	memmove@PLT
	movq	%rax, %rdi
.L1943:
	movq	224(%rsp), %rax
	movl	(%rdi), %ebx
	movl	(%rax), %ecx
	leal	(%rcx,%rbx), %eax
	testl	%ecx, %ecx
	js	.L1945
	movl	4(%rdi), %eax
	je	.L1946
	subl	%ecx, %eax
.L1945:
	cmpl	%ebx, %eax
	jg	.L1947
	cmpl	%eax, 4(%rdi)
	cmovle	4(%rdi), %eax
	movl	%eax, %ebx
.L1947:
	call	_ZdlPv@PLT
	movq	32(%rsp), %rax
	movq	80(%rsp), %rsi
	movq	224(%rsp), %rdi
	movss	(%rsi,%rax,4), %xmm0
	movq	72(%rsp), %rsi
	movl	4(%rdi), %ecx
	movl	(%rdi), %r13d
	movss	(%rsi,%rax,4), %xmm1
	movq	472(%rsp), %rax
	testq	%rax, %rax
	je	.L1948
	movq	56(%rsp), %rsi
	jmp	.L1949
.L2177:
	movq	%rax, %rsi
	movq	16(%rax), %rax
.L1952:
	testq	%rax, %rax
	je	.L1950
.L1949:
	cmpl	32(%rax), %r13d
	jle	.L2177
	movq	24(%rax), %rax
	jmp	.L1952
.L1899:
	movq	%rbp, %rdi
.LEHB178:
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%rbp), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L1900
	movq	%rbp, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L1900
.L1896:
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L1897
	movq	%r12, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L1897
.L2166:
	movq	64(%rsp), %rbx
	movl	%r13d, %eax
	movq	%r12, %rdi
	negl	%eax
	movq	%rbx, %rsi
	movl	%eax, 224(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, 224(%rsp)
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
.LEHE178:
	jmp	.L1892
.L2159:
	movq	%rbx, %r13
	xorl	%ecx, %ecx
	jmp	.L1852
.L2157:
	movq	%r13, %r15
	xorl	%ecx, %ecx
	jmp	.L1848
.L2156:
	movq	%rbx, %rax
	sarq	$2, %rax
	testq	%rbx, %rbx
	je	.L1845
	movq	8(%rsp), %r15
	xorl	%r13d, %r13d
	leaq	400(%rsp), %rbx
.L1846:
	subl	$1, %eax
	movq	%rbx, %rsi
	movq	%r15, %rdi
	subl	%r13d, %eax
	addq	$1, %r13
	movl	%eax, 400(%rsp)
.LEHB179:
	call	_ZNSt6vectorIiSaIiEE12emplace_backIJiEEEvDpOT_
	movq	32(%r14), %r12
	movq	24(%r14), %rbp
	movq	%r12, %rdx
	subq	%rbp, %rdx
	movq	%rdx, %rax
	sarq	$2, %rax
	cmpq	%r13, %rax
	ja	.L1846
	movq	8(%rsp), %rax
	movq	%rdx, %rbx
	movq	(%rax), %rsi
	movq	8(%rax), %rdx
	jmp	.L1845
.L2155:
	movq	(%rsi), %rax
	leaq	192(%rsp), %r15
	leaq	512(%rsp), %rsi
	movq	%r15, %rdi
	leaq	264(%rsp), %rbx
	leaq	256(%rsp), %r12
	movl	4(%rax), %edx
	movl	(%rax), %eax
	movl	%edx, 512(%rsp)
	movl	$2, %edx
	movl	%eax, 516(%rsp)
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE179:
	movq	72(%r14), %rsi
	movl	$0, 264(%rsp)
	movq	$0, 272(%rsp)
	movq	%rbx, 280(%rsp)
	movq	%rbx, 288(%rsp)
	movq	$0, 296(%rsp)
	testq	%rsi, %rsi
	je	.L1826
	leaq	400(%rsp), %rax
	movq	%rbx, %rdx
	movq	%r12, %rdi
	movq	%r12, 400(%rsp)
	movq	%rax, %rcx
	movq	%rax, 16(%rsp)
.LEHB180:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE180:
	movq	%rax, %rdx
.L1827:
	movq	%rax, %rbp
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L1827
	movq	%rbp, 280(%rsp)
	movq	%rdx, %rax
.L1828:
	movq	%rax, %rcx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1828
	movq	96(%r14), %rax
	movq	%rcx, 288(%rsp)
	movq	%rdx, 272(%rsp)
	movq	%rax, 296(%rsp)
	leaq	312(%rsp), %rax
	movl	$0, 312(%rsp)
	movq	$0, 320(%rsp)
	movq	%rax, 328(%rsp)
	movq	%rax, 336(%rsp)
	movq	$0, 344(%rsp)
	cmpq	%rbx, %rbp
	je	.L1991
	leaq	304(%rsp), %r14
.L1829:
	movl	40(%rbp), %eax
	movq	16(%rsp), %rsi
	movq	%r14, %rdi
	negl	%eax
	movl	%eax, 40(%rbp)
	movdqu	40(%rbp), %xmm4
	movl	%eax, 400(%rsp)
	movups	%xmm4, 408(%rsp)
	movq	56(%rbp), %rax
	movq	%rax, 424(%rsp)
.LEHB181:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	movq	%rbp, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %rbp
	cmpq	%rbx, %rax
	jne	.L1829
	movq	320(%rsp), %rsi
	leaq	360(%rsp), %rdx
	leaq	352(%rsp), %rax
	movl	$0, 360(%rsp)
	movq	$0, 368(%rsp)
	movq	%rax, 40(%rsp)
	movq	%rdx, 24(%rsp)
	movq	%rdx, 376(%rsp)
	movq	%rdx, 384(%rsp)
	movq	$0, 392(%rsp)
	testq	%rsi, %rsi
	je	.L1994
	movq	16(%rsp), %rcx
	movq	%rax, %rdi
	movq	%rax, 400(%rsp)
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE181:
	movq	%rax, %rdx
.L1831:
	movq	%rax, %rbp
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L1831
	movq	%rbp, 376(%rsp)
	movq	%rdx, %rax
.L1832:
	movq	%rax, %rcx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L1832
	movq	344(%rsp), %rax
	movq	%rcx, 384(%rsp)
	movq	%rdx, 368(%rsp)
	movq	%rax, 392(%rsp)
.L1830:
	pxor	%xmm0, %xmm0
	leaq	464(%rsp), %rax
	movl	$0, 464(%rsp)
	leaq	224(%rsp), %rbx
	movq	%rax, 56(%rsp)
	leaq	456(%rsp), %r13
	movq	$0, 472(%rsp)
	movq	%rax, 480(%rsp)
	movq	%rax, 488(%rsp)
	movq	$0, 496(%rsp)
	movaps	%xmm0, 400(%rsp)
	movaps	%xmm0, 416(%rsp)
	movaps	%xmm0, 432(%rsp)
	cmpq	24(%rsp), %rbp
	je	.L1835
.L1833:
	movl	32(%rbp), %eax
	movdqu	40(%rbp), %xmm5
	movq	%rbx, %rsi
	movq	%r13, %rdi
	movl	%eax, 224(%rsp)
	movups	%xmm5, 232(%rsp)
	movq	56(%rbp), %rax
	movq	%rax, 248(%rsp)
.LEHB182:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
	movq	%rbp, %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	%rax, %rbp
	cmpq	24(%rsp), %rax
	jne	.L1833
.L1835:
	leaq	400(%rsp), %rax
	movq	%r15, %rsi
	leaq	456(%rsp), %r13
	movq	%rax, %rdi
	movq	%rax, 16(%rsp)
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
	leaq	424(%rsp), %rdi
	movq	%r15, %rsi
	leaq	456(%rsp), %r13
	call	_ZNSt6vectorIiSaIiEEaSERKS1_
.LEHE182:
	movq	400(%rsp), %rax
	movq	40(%rsp), %rdi
	movq	368(%rsp), %rsi
	movl	(%rax), %eax
	movl	%eax, 448(%rsp)
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	16(%rsp), %rdi
.LEHB183:
	call	_ZN19quantumSparseMatrix11pruneMatrixEv
.LEHE183:
	movq	48(%rsp), %rbx
	movq	400(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	472(%rsp), %rdx
	movq	%rax, (%rbx)
	movq	408(%rsp), %rax
	movaps	%xmm0, 400(%rsp)
	movq	%rax, 8(%rbx)
	movq	416(%rsp), %rax
	movq	%rax, 16(%rbx)
	movq	424(%rsp), %rax
	movaps	%xmm0, 416(%rsp)
	movq	%rax, 24(%rbx)
	movq	432(%rsp), %rax
	movq	%rax, 32(%rbx)
	movq	440(%rsp), %rax
	movaps	%xmm0, 432(%rsp)
	movq	%rax, 40(%rbx)
	movl	448(%rsp), %eax
	movl	%eax, 48(%rbx)
	leaq	64(%rbx), %rax
	testq	%rdx, %rdx
	je	.L1841
	movl	464(%rsp), %ecx
	movq	%rdx, 72(%rbx)
	movl	%ecx, 64(%rbx)
	movq	480(%rsp), %rcx
	movq	%rcx, 80(%rbx)
	movq	488(%rsp), %rcx
	movq	%rcx, 88(%rbx)
	movq	%rax, 8(%rdx)
	movq	496(%rsp), %rax
	movq	$0, 472(%rsp)
	movq	%rax, 96(%rbx)
	movq	56(%rsp), %rax
	movq	$0, 496(%rsp)
	movq	%rax, 480(%rsp)
	movq	%rax, 488(%rsp)
.L1842:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	320(%rsp), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	272(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1824
.L2150:
	call	_ZdlPv@PLT
.L1824:
	movq	520(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L2178
	movq	48(%rsp), %rax
	addq	$536, %rsp
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
.L1922:
	.cfi_restore_state
	movq	424(%rsp), %r9
	movq	432(%rsp), %rax
	subq	%r9, %rax
	sarq	$2, %rax
	jne	.L1923
	xorl	%ebx, %ebx
	testq	%r8, %r8
	je	.L1931
	jmp	.L1924
	.p2align 4,,10
	.p2align 3
.L1998:
	xorl	%r15d, %r15d
.L1906:
	movq	%r8, %rdi
	call	_ZdlPv@PLT
	jmp	.L1909
.L2164:
	movq	56(%rsi), %rdx
	movq	48(%rsi), %rcx
	movss	%xmm1, (%rcx,%rax,4)
	movss	%xmm0, (%rdx,%rax,4)
.L1986:
	call	_ZdlPv@PLT
	jmp	.L1955
.L1957:
	addq	$1, 32(%rsp)
	movq	32(%rsp), %rax
	cmpl	%eax, 44(%rbp)
	jg	.L1886
	jmp	.L1959
.L2175:
	movq	232(%rsp), %rsi
	cmpq	240(%rsp), %rsi
	je	.L1933
	movl	120(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 232(%rsp)
	jmp	.L1934
.L2003:
	xorl	%edi, %edi
	jmp	.L1941
.L1946:
	cmpl	%eax, %ebx
	cmovle	%ebx, %eax
	jmp	.L1945
.L2000:
	xorl	%r8d, %r8d
	jmp	.L1920
.L1994:
	movq	%rdx, %rbp
	jmp	.L1830
.L1841:
	movl	$0, 64(%rbx)
	movq	$0, 72(%rbx)
	movq	%rax, 80(%rbx)
	movq	%rax, 88(%rbx)
	movq	$0, 96(%rbx)
	jmp	.L1842
.L2165:
	leaq	192(%rsp), %r15
	xorl	%esi, %esi
	movq	%r12, %rdi
	movq	%r15, %rdx
.LEHB184:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	264(%rsp), %rsi
	cmpq	272(%rsp), %rsi
	je	.L1889
	movl	192(%rsp), %eax
	movq	256(%rsp), %r8
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movl	(%r8), %eax
	movq	%rsi, 264(%rsp)
	jmp	.L1890
.L1917:
	movq	%rdi, %rbx
	xorl	%r13d, %r13d
	cmpq	%rsi, %r8
	jne	.L1988
.L1989:
	movq	%rdi, (%rsp)
	xorl	%r13d, %r13d
	xorl	%r8d, %r8d
	jmp	.L1920
.L1889:
	movq	%r15, %rdx
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE184:
	movq	256(%rsp), %r8
	movl	(%r8), %eax
	jmp	.L1890
.L1826:
	leaq	312(%rsp), %rax
	movl	$0, 312(%rsp)
	movq	$0, 320(%rsp)
	movq	%rax, 328(%rsp)
	movq	%rax, 336(%rsp)
	movq	$0, 344(%rsp)
.L1991:
	leaq	360(%rsp), %rax
	movl	$0, 360(%rsp)
	leaq	304(%rsp), %r14
	movq	%rax, 376(%rsp)
	movq	%rax, %rbp
	movq	%rax, 384(%rsp)
	movq	%rax, 24(%rsp)
	leaq	352(%rsp), %rax
	movq	$0, 368(%rsp)
	movq	$0, 392(%rsp)
	movq	%rax, 40(%rsp)
	jmp	.L1830
.L1948:
	movslq	%ecx, %rax
	leaq	0(,%rax,4), %rcx
	jmp	.L1953
.L2001:
	movl	$1, %edi
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	jmp	.L1926
.L2168:
	xorl	%edi, %edi
	xorl	%ebx, %ebx
	jmp	.L1989
.L1933:
	movq	64(%rsp), %rdi
	leaq	120(%rsp), %rdx
.LEHB185:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE185:
	jmp	.L1934
.L1960:
	movl	$0, 64(%rsi)
	movq	$0, 72(%rsi)
	movq	%rax, 80(%rsi)
	movq	%rax, 88(%rsi)
	movq	$0, 96(%rsi)
	jmp	.L1961
.L2174:
	xorl	%ebx, %ebx
	jmp	.L1924
.L2178:
	call	__stack_chk_fail@PLT
.L2176:
.LEHB186:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE186:
.L2171:
.LEHB187:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE187:
.L2172:
.LEHB188:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE188:
.L2158:
.LEHB189:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE189:
.L2160:
.LEHB190:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE190:
.L2173:
.LEHB191:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE191:
.L2170:
.LEHB192:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE192:
.L2167:
	leaq	.LC2(%rip), %rdi
.LEHB193:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE193:
.L2021:
	endbr64
	movq	%rax, %rbx
	jmp	.L1939
.L2009:
	endbr64
	movq	%rax, %rbp
	jmp	.L1974
.L2007:
	endbr64
	movq	%rax, %rbx
	jmp	.L1971
.L2012:
	endbr64
	movq	%rax, %rbx
	jmp	.L1978
.L2008:
	endbr64
	movq	%rax, %rbp
	jmp	.L1976
.L2005:
	endbr64
	movq	%rax, %rbx
	jmp	.L1972
.L2013:
	endbr64
	movq	%rax, %rbx
	jmp	.L1979
.L2010:
	endbr64
	movq	%rax, %rbx
	jmp	.L1983
.L2011:
	endbr64
	movq	%rax, %rbx
	jmp	.L1904
.L2014:
	endbr64
	movq	%rax, %rbx
	jmp	.L1837
.L2016:
	endbr64
	movq	%rax, %rbx
	jmp	.L1870
.L2006:
	endbr64
	movq	%rax, %rbx
	jmp	.L1840
.L2020:
	endbr64
	movq	%rax, %rbx
	jmp	.L1937
.L2015:
	endbr64
	movq	%rax, %rbx
	jmp	.L2153
.L2017:
	endbr64
	movq	%rax, %rbx
	jmp	.L1912
.L2132:
	endbr64
	jmp	.L2133
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
	.uleb128 .L2008-.LFB8729
	.uleb128 0
	.uleb128 .LEHB164-.LFB8729
	.uleb128 .LEHE164-.LEHB164
	.uleb128 .L2009-.LFB8729
	.uleb128 0
	.uleb128 .LEHB165-.LFB8729
	.uleb128 .LEHE165-.LEHB165
	.uleb128 .L2015-.LFB8729
	.uleb128 0
	.uleb128 .LEHB166-.LFB8729
	.uleb128 .LEHE166-.LEHB166
	.uleb128 .L2016-.LFB8729
	.uleb128 0
	.uleb128 .LEHB167-.LFB8729
	.uleb128 .LEHE167-.LEHB167
	.uleb128 .L2010-.LFB8729
	.uleb128 0
	.uleb128 .LEHB168-.LFB8729
	.uleb128 .LEHE168-.LEHB168
	.uleb128 .L2011-.LFB8729
	.uleb128 0
	.uleb128 .LEHB169-.LFB8729
	.uleb128 .LEHE169-.LEHB169
	.uleb128 .L2013-.LFB8729
	.uleb128 0
	.uleb128 .LEHB170-.LFB8729
	.uleb128 .LEHE170-.LEHB170
	.uleb128 .L2132-.LFB8729
	.uleb128 0
	.uleb128 .LEHB171-.LFB8729
	.uleb128 .LEHE171-.LEHB171
	.uleb128 .L2017-.LFB8729
	.uleb128 0
	.uleb128 .LEHB172-.LFB8729
	.uleb128 .LEHE172-.LEHB172
	.uleb128 .L2012-.LFB8729
	.uleb128 0
	.uleb128 .LEHB173-.LFB8729
	.uleb128 .LEHE173-.LEHB173
	.uleb128 .L2132-.LFB8729
	.uleb128 0
	.uleb128 .LEHB174-.LFB8729
	.uleb128 .LEHE174-.LEHB174
	.uleb128 .L2012-.LFB8729
	.uleb128 0
	.uleb128 .LEHB175-.LFB8729
	.uleb128 .LEHE175-.LEHB175
	.uleb128 .L2021-.LFB8729
	.uleb128 0
	.uleb128 .LEHB176-.LFB8729
	.uleb128 .LEHE176-.LEHB176
	.uleb128 .L2020-.LFB8729
	.uleb128 0
	.uleb128 .LEHB177-.LFB8729
	.uleb128 .LEHE177-.LEHB177
	.uleb128 .L2013-.LFB8729
	.uleb128 0
	.uleb128 .LEHB178-.LFB8729
	.uleb128 .LEHE178-.LEHB178
	.uleb128 .L2132-.LFB8729
	.uleb128 0
	.uleb128 .LEHB179-.LFB8729
	.uleb128 .LEHE179-.LEHB179
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB180-.LFB8729
	.uleb128 .LEHE180-.LEHB180
	.uleb128 .L2005-.LFB8729
	.uleb128 0
	.uleb128 .LEHB181-.LFB8729
	.uleb128 .LEHE181-.LEHB181
	.uleb128 .L2006-.LFB8729
	.uleb128 0
	.uleb128 .LEHB182-.LFB8729
	.uleb128 .LEHE182-.LEHB182
	.uleb128 .L2014-.LFB8729
	.uleb128 0
	.uleb128 .LEHB183-.LFB8729
	.uleb128 .LEHE183-.LEHB183
	.uleb128 .L2007-.LFB8729
	.uleb128 0
	.uleb128 .LEHB184-.LFB8729
	.uleb128 .LEHE184-.LEHB184
	.uleb128 .L2132-.LFB8729
	.uleb128 0
	.uleb128 .LEHB185-.LFB8729
	.uleb128 .LEHE185-.LEHB185
	.uleb128 .L2020-.LFB8729
	.uleb128 0
	.uleb128 .LEHB186-.LFB8729
	.uleb128 .LEHE186-.LEHB186
	.uleb128 .L2013-.LFB8729
	.uleb128 0
	.uleb128 .LEHB187-.LFB8729
	.uleb128 .LEHE187-.LEHB187
	.uleb128 .L2132-.LFB8729
	.uleb128 0
	.uleb128 .LEHB188-.LFB8729
	.uleb128 .LEHE188-.LEHB188
	.uleb128 .L2012-.LFB8729
	.uleb128 0
	.uleb128 .LEHB189-.LFB8729
	.uleb128 .LEHE189-.LEHB189
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB190-.LFB8729
	.uleb128 .LEHE190-.LEHB190
	.uleb128 .L2008-.LFB8729
	.uleb128 0
	.uleb128 .LEHB191-.LFB8729
	.uleb128 .LEHE191-.LEHB191
	.uleb128 .L2021-.LFB8729
	.uleb128 0
	.uleb128 .LEHB192-.LFB8729
	.uleb128 .LEHE192-.LEHB192
	.uleb128 .L2132-.LFB8729
	.uleb128 0
	.uleb128 .LEHB193-.LFB8729
	.uleb128 .LEHE193-.LEHB193
	.uleb128 .L2017-.LFB8729
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
.L2134:
	.cfi_def_cfa_offset 592
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC33(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
.LEHB194:
	call	_ZNSt12length_errorC1EPKc@PLT
.LEHE194:
	movq	_ZNSt12length_errorD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt12length_error(%rip), %rsi
	movq	%rbp, %rdi
.LEHB195:
	call	__cxa_throw@PLT
.LEHE195:
.L1837:
	movq	472(%rsp), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	424(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1838
	call	_ZdlPv@PLT
.L1838:
	movq	400(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1839
	call	_ZdlPv@PLT
.L1839:
	movq	368(%rsp), %rsi
	movq	40(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L1840:
	movq	320(%rsp), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	272(%rsp), %rsi
	movq	%r12, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L1972:
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1985
.L2154:
	call	_ZdlPv@PLT
.L1985:
	movq	%rbx, %rdi
.LEHB196:
	call	_Unwind_Resume@PLT
.L1979:
	movq	224(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1978
	call	_ZdlPv@PLT
.L1978:
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1981
	call	_ZdlPv@PLT
.L1981:
	testq	%r15, %r15
	je	.L1904
	movq	%r15, %rdi
.L2148:
	call	_ZdlPv@PLT
.L1904:
	movq	368(%rsp), %rsi
	movq	40(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L1983:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L1873:
	movq	320(%rsp), %rsi
	leaq	304(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2153:
	movq	160(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1861
	call	_ZdlPv@PLT
.L1861:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L2154
	jmp	.L1985
.L1870:
	movq	472(%rsp), %rsi
	leaq	456(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	424(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1871
	call	_ZdlPv@PLT
.L1871:
	movq	400(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1872
	call	_ZdlPv@PLT
.L1872:
	movq	368(%rsp), %rsi
	movq	40(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	jmp	.L1873
.L1974:
	movq	352(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1976
	call	_ZdlPv@PLT
.L1976:
	movq	400(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1977
	call	_ZdlPv@PLT
.L1977:
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE196:
.L1937:
	movq	224(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L1938
	call	_ZdlPv@PLT
.L1938:
	testq	%r13, %r13
	je	.L1978
.L1939:
	movq	%r13, %rdi
	call	_ZdlPv@PLT
	jmp	.L1978
.L2018:
	endbr64
.L2133:
	movq	%rax, %rbx
	jmp	.L1912
.L2019:
	endbr64
	movq	%rbp, %rdi
	movq	%rax, %rbx
	call	__cxa_free_exception@PLT
.L1912:
	movq	256(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L2148
	jmp	.L1904
.L1971:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L1840
	.cfi_endproc
.LFE8729:
	.section	.gcc_except_table
.LLSDAC8729:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8729-.LLSDACSBC8729
.LLSDACSBC8729:
	.uleb128 .LEHB194-.LCOLDB43
	.uleb128 .LEHE194-.LEHB194
	.uleb128 .L2019-.LCOLDB43
	.uleb128 0
	.uleb128 .LEHB195-.LCOLDB43
	.uleb128 .LEHE195-.LEHB195
	.uleb128 .L2018-.LCOLDB43
	.uleb128 0
	.uleb128 .LEHB196-.LCOLDB43
	.uleb128 .LEHE196-.LEHB196
	.uleb128 0
	.uleb128 0
.LLSDACSEC8729:
	.section	.text.unlikely
	.text
	.size	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE, .-_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
	.section	.text.unlikely
	.size	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE.cold, .-_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE.cold
.LCOLDE43:
	.text
.LHOTE43:
	.section	.rodata.str1.8
	.align 8
.LC44:
	.string	"input matrices are of different dimensions, not compatible"
	.section	.text.unlikely
.LCOLDB45:
	.text
.LHOTB45:
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
	jne	.L2331
	movq	%rdi, %r13
	movl	$104, %edi
	movl	%eax, %r14d
	movq	%rdx, %rbx
.LEHB197:
	call	_Znwm@PLT
.LEHE197:
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
.LEHB198:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_
.LEHE198:
	movl	-160(%rbp), %edx
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
	movl	%edx, 48(%r12)
	cmpq	%rax, %rsi
	je	.L2181
	movl	%edx, (%rsi)
	leaq	-160(%rbp), %rcx
	addq	$4, %rsi
	movq	%rsi, 8(%r12)
	movq	%rcx, -256(%rbp)
	cmpq	%rax, %rsi
	je	.L2183
.L2349:
	movl	-160(%rbp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	40(%r12), %rax
	movq	%rsi, 8(%r12)
	movq	32(%r12), %rsi
	cmpq	%rax, %rsi
	je	.L2185
.L2350:
	movl	-160(%rbp), %edx
	addq	$4, %rsi
	movl	%edx, -4(%rsi)
	movq	%rsi, 32(%r12)
.L2186:
	cmpq	%rax, %rsi
	je	.L2187
	movl	-160(%rbp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 32(%r12)
.L2188:
	movq	-96(%rbp), %rax
	testq	%rax, %rax
	je	.L2192
	movq	%rax, -232(%rbp)
.L2189:
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
	jne	.L2189
.L2192:
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
	je	.L2339
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%r14, %rcx
	movq	%rax, %rdi
	movq	%rax, -112(%rbp)
.LEHB199:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE199:
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2196:
	movq	%rax, %rdi
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2196
	movq	%rdi, -136(%rbp)
	movq	%rcx, %rax
	.p2align 4,,10
	.p2align 3
.L2197:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2197
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
	jne	.L2260
.L2198:
	movq	-248(%rbp), %rcx
	cmpq	%rcx, -232(%rbp)
	je	.L2201
	.p2align 4,,10
	.p2align 3
.L2235:
	movq	-232(%rbp), %rbx
	movl	32(%rbx), %eax
	testq	%rsi, %rsi
	je	.L2202
	movq	%r15, %rdx
	movq	%rbx, %rdi
	jmp	.L2203
	.p2align 4,,10
	.p2align 3
.L2340:
	movq	%rsi, %rdx
	movq	16(%rsi), %rsi
	testq	%rsi, %rsi
	je	.L2204
.L2203:
	cmpl	%eax, 32(%rsi)
	jge	.L2340
	movq	24(%rsi), %rsi
	testq	%rsi, %rsi
	jne	.L2203
.L2204:
	movq	%rdi, -232(%rbp)
	movq	%rdi, %rcx
	cmpq	%r15, %rdx
	je	.L2202
	cmpl	%eax, 32(%rdx)
	jle	.L2341
.L2202:
	movq	-232(%rbp), %rbx
	movq	72(%r12), %rdx
	movq	48(%rbx), %rcx
	movq	56(%rbx), %rsi
	testq	%rdx, %rdx
	je	.L2211
	movq	-240(%rbp), %r8
	movq	%rbx, %rdi
	jmp	.L2258
	.p2align 4,,10
	.p2align 3
.L2342:
	movq	%rdx, %r8
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	je	.L2208
.L2258:
	cmpl	%eax, 32(%rdx)
	jge	.L2342
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2258
.L2208:
	movq	%rdi, -232(%rbp)
	cmpq	%r8, -240(%rbp)
	je	.L2211
	cmpl	%eax, 32(%r8)
	jle	.L2212
.L2211:
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
.LEHB200:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
.LEHE200:
	jmp	.L2213
.L2339:
	movq	72(%rbx), %rsi
	movl	$0, -104(%rbp)
	movq	$0, -96(%rbp)
	movq	%r15, -88(%rbp)
	movq	%r15, -80(%rbp)
	movq	$0, -72(%rbp)
	testq	%rsi, %rsi
	je	.L2201
.L2260:
	leaq	-192(%rbp), %rcx
	movq	%r15, %rdx
	movq	%r14, %rdi
	movq	%r14, -192(%rbp)
.LEHB201:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE201:
	movq	%rax, %rsi
	.p2align 4,,10
	.p2align 3
.L2199:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2199
	movq	%rdx, -88(%rbp)
	movq	%rsi, %rax
	.p2align 4,,10
	.p2align 3
.L2200:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2200
	movq	96(%rbx), %rax
	movq	%rdx, -80(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%rax, -72(%rbp)
	movq	-136(%rbp), %rax
	movq	%rax, -232(%rbp)
	jmp	.L2198
	.p2align 4,,10
	.p2align 3
.L2341:
	pushq	56(%rdx)
	movq	%rdi, %rbx
	leaq	-224(%rbp), %rdi
	pushq	48(%rdx)
	pushq	40(%rdx)
	pushq	56(%rcx)
	pushq	48(%rcx)
	pushq	40(%rcx)
.LEHB202:
	.cfi_escape 0x2e,0x30
	call	_Z11addElements8diagonalS_
	movq	72(%r12), %rax
	movl	32(%rbx), %edx
	addq	$48, %rsp
	movq	-216(%rbp), %rcx
	movq	-208(%rbp), %rsi
	testq	%rax, %rax
	je	.L2223
	movq	-240(%rbp), %rdi
	movq	-232(%rbp), %rbx
	jmp	.L2224
	.p2align 4,,10
	.p2align 3
.L2343:
	movq	%rax, %rdi
	movq	16(%rax), %rax
	testq	%rax, %rax
	je	.L2225
.L2224:
	cmpl	32(%rax), %edx
	jle	.L2343
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2224
.L2225:
	movq	%rbx, -232(%rbp)
	cmpq	-240(%rbp), %rdi
	je	.L2223
	cmpl	32(%rdi), %edx
	jge	.L2228
.L2223:
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
.L2213:
	movq	-232(%rbp), %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	-248(%rbp), %rcx
	movq	%rax, -232(%rbp)
	cmpq	%rcx, %rax
	je	.L2201
	movq	-96(%rbp), %rsi
	jmp	.L2235
	.p2align 4,,10
	.p2align 3
.L2228:
	movl	44(%rdi), %r8d
	testl	%r8d, %r8d
	jle	.L2213
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
	je	.L2229
	subq	%rcx, %r10
	cmpq	$30, %r10
	jbe	.L2229
	movl	%r8d, %r9d
	movq	-232(%rbp), %rbx
	xorl	%edi, %edi
	shrl	$2, %r9d
	salq	$4, %r9
	.p2align 4,,10
	.p2align 3
.L2230:
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
	jne	.L2230
	movl	%r8d, %r9d
	movq	%rbx, -232(%rbp)
	andl	$-4, %r9d
	testb	$3, %r8b
	je	.L2213
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
	jle	.L2213
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
	jge	.L2213
	leaq	8(%rdi), %r8
	movss	8(%rsi,%rdi), %xmm0
	addq	%r8, %rax
	addq	%r8, %rdx
	movss	(%rdx), %xmm1
	addss	(%rax), %xmm0
	addss	8(%rcx,%rdi), %xmm1
	movss	%xmm1, (%rdx)
	movss	%xmm0, (%rax)
	jmp	.L2213
	.p2align 4,,10
	.p2align 3
.L2201:
	movq	8(%r12), %rax
	movq	(%r12), %rsi
	pxor	%xmm0, %xmm0
	movq	$0, 16(%r13)
	movups	%xmm0, 0(%r13)
	movq	%rax, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2344
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2345
	movq	%rbx, %rdi
	call	_Znwm@PLT
.LEHE202:
	movq	%rax, %rcx
	movq	8(%r12), %rax
	movq	(%r12), %rsi
	movq	%rax, %rdi
	subq	%rsi, %rdi
	movq	%rdi, %r15
.L2237:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 16(%r13)
	movups	%xmm0, 0(%r13)
	cmpq	%rsi, %rax
	je	.L2239
	movq	%rcx, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2239:
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
	je	.L2346
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2347
	movq	%rbx, %rdi
.LEHB203:
	call	_Znwm@PLT
.LEHE203:
	movq	%rax, %rcx
	movq	32(%r12), %rax
	movq	24(%r12), %rsi
	movq	%rax, %rdi
	subq	%rsi, %rdi
	movq	%rdi, %r15
.L2241:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 40(%r13)
	movups	%xmm0, 24(%r13)
	cmpq	%rsi, %rax
	je	.L2243
	movq	%rcx, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2243:
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
	je	.L2244
	leaq	56(%r13), %rdi
	leaq	-192(%rbp), %rcx
	movq	%rdi, -192(%rbp)
.LEHB204:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE204:
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2245:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2245
	movq	%rdx, 80(%r13)
	movq	%rcx, %rax
	.p2align 4,,10
	.p2align 3
.L2246:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2246
	movq	96(%r12), %rax
	movq	%rdx, 88(%r13)
	movq	%rcx, 72(%r13)
	movq	%rax, 96(%r13)
.L2244:
	movq	-96(%rbp), %rbx
	testq	%rbx, %rbx
	je	.L2255
.L2247:
	movq	24(%rbx), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2247
.L2255:
	movq	-144(%rbp), %rbx
	testq	%rbx, %rbx
	je	.L2179
	movq	-256(%rbp), %rax
	movq	%rax, %r14
.L2249:
	movq	24(%rbx), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2249
.L2179:
	movq	-56(%rbp), %rax
	xorq	%fs:40, %rax
	jne	.L2348
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
.L2212:
	.cfi_restore_state
	movl	44(%r8), %edi
	testl	%edi, %edi
	jle	.L2213
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
	je	.L2215
	subq	%rcx, %r9
	cmpq	$30, %r9
	jbe	.L2215
	movl	%edi, %r9d
	movq	-232(%rbp), %rbx
	xorl	%r8d, %r8d
	shrl	$2, %r9d
	salq	$4, %r9
	.p2align 4,,10
	.p2align 3
.L2216:
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
	jne	.L2216
	movq	%rbx, -232(%rbp)
	movl	%edi, %ebx
	andl	$-4, %ebx
	testb	$3, %dil
	je	.L2213
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
	jge	.L2213
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
	jle	.L2213
	leaq	8(%r8), %rdi
	movss	8(%rsi,%r8), %xmm0
	addq	%rdi, %rax
	addq	%rdi, %rdx
	movss	(%rdx), %xmm1
	addss	(%rax), %xmm0
	addss	8(%rcx,%r8), %xmm1
	movss	%xmm1, (%rdx)
	movss	%xmm0, (%rax)
	jmp	.L2213
.L2229:
	movq	-232(%rbp), %rbx
	xorl	%r8d, %r8d
	.p2align 4,,10
	.p2align 3
.L2233:
	movss	(%rsi,%r8,4), %xmm0
	movss	(%rdx,%r8,4), %xmm1
	movq	%r8, %r9
	addss	(%rax,%r8,4), %xmm0
	addss	(%rcx,%r8,4), %xmm1
	movss	%xmm1, (%rdx,%r8,4)
	movss	%xmm0, (%rax,%r8,4)
	addq	$1, %r8
	cmpq	%rdi, %r9
	jne	.L2233
	movq	%rbx, -232(%rbp)
	jmp	.L2213
.L2344:
	movq	%rbx, %r15
	xorl	%ecx, %ecx
	jmp	.L2237
.L2346:
	movq	%rbx, %r15
	xorl	%ecx, %ecx
	jmp	.L2241
.L2187:
	movq	-256(%rbp), %rdx
	leaq	24(%r12), %rdi
.LEHB205:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	jmp	.L2188
.L2181:
	leaq	-160(%rbp), %rax
	movq	%r12, %rdi
	movq	%rax, %rdx
	movq	%rax, -256(%rbp)
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
	cmpq	%rax, %rsi
	jne	.L2349
.L2183:
	movq	-256(%rbp), %rdx
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%r12), %rsi
	movq	40(%r12), %rax
	cmpq	%rax, %rsi
	jne	.L2350
.L2185:
	movq	-256(%rbp), %rdx
	leaq	24(%r12), %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE205:
	movq	32(%r12), %rsi
	movq	40(%r12), %rax
	jmp	.L2186
.L2215:
	movq	-232(%rbp), %r10
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L2220:
	movss	(%rsi,%rdi,4), %xmm0
	movss	(%rdx,%rdi,4), %xmm1
	movq	%rdi, %r8
	addss	(%rax,%rdi,4), %xmm0
	addss	(%rcx,%rdi,4), %xmm1
	movss	%xmm1, (%rdx,%rdi,4)
	movss	%xmm0, (%rax,%rdi,4)
	addq	$1, %rdi
	cmpq	%rbx, %r8
	jne	.L2220
	movq	%r10, -232(%rbp)
	jmp	.L2213
.L2347:
.LEHB206:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE206:
.L2348:
	call	__stack_chk_fail@PLT
.L2345:
.LEHB207:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE207:
.L2267:
	endbr64
	movq	%rax, %rbx
	jmp	.L2250
.L2264:
	endbr64
	movq	%rax, %rbx
	jmp	.L2254
.L2266:
	endbr64
	movq	%rax, %rbx
	jmp	.L2252
.L2263:
	endbr64
	movq	%rax, %rbx
	jmp	.L2257
.L2265:
	endbr64
	movq	%rax, %rbx
	jmp	.L2193
	.section	.gcc_except_table
.LLSDA8721:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8721-.LLSDACSB8721
.LLSDACSB8721:
	.uleb128 .LEHB197-.LFB8721
	.uleb128 .LEHE197-.LEHB197
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB198-.LFB8721
	.uleb128 .LEHE198-.LEHB198
	.uleb128 .L2265-.LFB8721
	.uleb128 0
	.uleb128 .LEHB199-.LFB8721
	.uleb128 .LEHE199-.LEHB199
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB200-.LFB8721
	.uleb128 .LEHE200-.LEHB200
	.uleb128 .L2264-.LFB8721
	.uleb128 0
	.uleb128 .LEHB201-.LFB8721
	.uleb128 .LEHE201-.LEHB201
	.uleb128 .L2263-.LFB8721
	.uleb128 0
	.uleb128 .LEHB202-.LFB8721
	.uleb128 .LEHE202-.LEHB202
	.uleb128 .L2264-.LFB8721
	.uleb128 0
	.uleb128 .LEHB203-.LFB8721
	.uleb128 .LEHE203-.LEHB203
	.uleb128 .L2266-.LFB8721
	.uleb128 0
	.uleb128 .LEHB204-.LFB8721
	.uleb128 .LEHE204-.LEHB204
	.uleb128 .L2267-.LFB8721
	.uleb128 0
	.uleb128 .LEHB205-.LFB8721
	.uleb128 .LEHE205-.LEHB205
	.uleb128 .L2265-.LFB8721
	.uleb128 0
	.uleb128 .LEHB206-.LFB8721
	.uleb128 .LEHE206-.LEHB206
	.uleb128 .L2266-.LFB8721
	.uleb128 0
	.uleb128 .LEHB207-.LFB8721
	.uleb128 .LEHE207-.LEHB207
	.uleb128 .L2264-.LFB8721
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
.L2250:
	.cfi_def_cfa 6, 16
	.cfi_offset 3, -56
	.cfi_offset 6, -16
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -24
	movq	24(%r13), %rdi
	testq	%rdi, %rdi
	je	.L2252
	call	_ZdlPv@PLT
.L2252:
	movq	0(%r13), %rdi
	testq	%rdi, %rdi
	jne	.L2351
.L2254:
	movq	-96(%rbp), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2257:
	movq	-256(%rbp), %rdi
	movq	-144(%rbp), %rsi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
.LEHB208:
	call	_Unwind_Resume@PLT
.LEHE208:
.L2351:
	call	_ZdlPv@PLT
	jmp	.L2254
.L2331:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC44(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbx
.LEHB209:
	call	_ZNSt16invalid_argumentC1EPKc@PLT
.LEHE209:
	movq	_ZNSt16invalid_argumentD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt16invalid_argument(%rip), %rsi
	movq	%rbx, %rdi
.LEHB210:
	call	__cxa_throw@PLT
.L2193:
	movq	-96(%rbp), %rsi
	movq	%r14, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	-272(%rbp), %rdi
	movq	72(%r12), %rsi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	24(%r12), %rdi
	testq	%rdi, %rdi
	je	.L2194
	call	_ZdlPv@PLT
.L2194:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L2195
	call	_ZdlPv@PLT
.L2195:
	movq	%r12, %rdi
	call	_ZdlPv@PLT
	movq	%rbx, %rdi
	call	_Unwind_Resume@PLT
.L2262:
	endbr64
	movq	%rax, %r12
	movq	%rbx, %rdi
	call	__cxa_free_exception@PLT
	movq	%r12, %rdi
	call	_Unwind_Resume@PLT
.LEHE210:
	.cfi_endproc
.LFE8721:
	.section	.gcc_except_table
.LLSDAC8721:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8721-.LLSDACSBC8721
.LLSDACSBC8721:
	.uleb128 .LEHB208-.LCOLDB45
	.uleb128 .LEHE208-.LEHB208
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB209-.LCOLDB45
	.uleb128 .LEHE209-.LEHB209
	.uleb128 .L2262-.LCOLDB45
	.uleb128 0
	.uleb128 .LEHB210-.LCOLDB45
	.uleb128 .LEHE210-.LEHB210
	.uleb128 0
	.uleb128 0
.LLSDACSEC8721:
	.section	.text.unlikely
	.text
	.size	_Z3add19quantumSparseMatrixS_, .-_Z3add19quantumSparseMatrixS_
	.section	.text.unlikely
	.size	_Z3add19quantumSparseMatrixS_.cold, .-_Z3add19quantumSparseMatrixS_.cold
.LCOLDE45:
	.text
.LHOTE45:
	.section	.text.unlikely
.LCOLDB46:
	.text
.LHOTB46:
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
	je	.L2443
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2444
	movq	%r13, %rdi
.LEHB211:
	call	_Znwm@PLT
.LEHE211:
	movq	(%rbx), %rsi
	movq	%rax, %rcx
	movq	8(%rbx), %rax
	movq	%rax, %r14
	subq	%rsi, %r14
.L2354:
	movq	%rcx, %xmm0
	addq	%rcx, %r13
	punpcklqdq	%xmm0, %xmm0
	movq	%r13, 144(%rsp)
	movaps	%xmm0, 128(%rsp)
	cmpq	%rsi, %rax
	je	.L2356
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2356:
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
	je	.L2445
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2446
	movq	%r13, %rdi
.LEHB212:
	call	_Znwm@PLT
.LEHE212:
	movq	%rax, %rcx
	movq	32(%rbx), %rax
	movq	24(%rbx), %rsi
	movq	%rax, %r14
	subq	%rsi, %r14
.L2358:
	movq	%rcx, %xmm0
	addq	%rcx, %r13
	punpcklqdq	%xmm0, %xmm0
	movq	%r13, 168(%rsp)
	movups	%xmm0, 152(%rsp)
	cmpq	%rsi, %rax
	je	.L2360
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2360:
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
	je	.L2361
	leaq	184(%rsp), %r13
	leaq	16(%rsp), %rcx
	movq	%r13, %rdi
	movq	%r13, 16(%rsp)
.LEHB213:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE213:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2362:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2362
	movq	%rcx, 208(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2363:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2363
	movq	96(%rbx), %rdx
	movq	%rcx, 216(%rsp)
	movq	%rax, 200(%rsp)
	movq	%rdx, 224(%rsp)
.L2361:
	movq	8(%rbp), %rax
	movq	0(%rbp), %rsi
	pxor	%xmm0, %xmm0
	movq	$0, 32(%rsp)
	movaps	%xmm0, 16(%rsp)
	movq	%rax, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2447
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2448
	movq	%rbx, %rdi
.LEHB214:
	call	_Znwm@PLT
.LEHE214:
	movq	%rax, %rcx
	movq	8(%rbp), %rax
	movq	0(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2365:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 32(%rsp)
	movaps	%xmm0, 16(%rsp)
	cmpq	%rsi, %rax
	je	.L2371
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2371:
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
	je	.L2449
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2450
	movq	%rbx, %rdi
.LEHB215:
	call	_Znwm@PLT
.LEHE215:
	movq	%rax, %rcx
	movq	32(%rbp), %rax
	movq	24(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2373:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 56(%rsp)
	movups	%xmm0, 40(%rsp)
	cmpq	%rsi, %rax
	je	.L2375
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2375:
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
	je	.L2376
	leaq	72(%rsp), %r13
	leaq	8(%rsp), %rcx
	movq	%r13, %rdi
	movq	%r13, 8(%rsp)
.LEHB216:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE216:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2377:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2377
	movq	%rcx, 96(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2378:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2378
	movq	96(%rbp), %rdx
	movq	%rcx, 104(%rsp)
	movq	%rax, 88(%rsp)
	movq	%rdx, 112(%rsp)
.L2376:
	leaq	128(%rsp), %rbp
	leaq	16(%rsp), %r13
	movq	%r12, %rdi
	movq	%rbp, %rdx
	movq	%r13, %rsi
.LEHB217:
	call	_Z3add19quantumSparseMatrixS_
.LEHE217:
	movq	88(%rsp), %rbx
	leaq	72(%rsp), %r13
	testq	%rbx, %rbx
	je	.L2388
.L2385:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2385
.L2388:
	movq	40(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2387
	call	_ZdlPv@PLT
.L2387:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2389
	call	_ZdlPv@PLT
.L2389:
	movq	200(%rsp), %rbx
	leaq	184(%rsp), %r13
	testq	%rbx, %rbx
	je	.L2393
.L2390:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2390
.L2393:
	movq	152(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2392
	call	_ZdlPv@PLT
.L2392:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2352
	call	_ZdlPv@PLT
.L2352:
	movq	232(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L2451
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
.L2443:
	.cfi_restore_state
	movq	%r13, %r14
	xorl	%ecx, %ecx
	jmp	.L2354
	.p2align 4,,10
	.p2align 3
.L2445:
	movq	%r13, %r14
	xorl	%ecx, %ecx
	jmp	.L2358
	.p2align 4,,10
	.p2align 3
.L2449:
	movq	%rbx, %r13
	xorl	%ecx, %ecx
	jmp	.L2373
	.p2align 4,,10
	.p2align 3
.L2447:
	movq	%rbx, %r13
	xorl	%ecx, %ecx
	jmp	.L2365
.L2451:
	call	__stack_chk_fail@PLT
.L2448:
.LEHB218:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE218:
.L2446:
.LEHB219:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE219:
.L2444:
.LEHB220:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE220:
.L2450:
.LEHB221:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE221:
.L2400:
	endbr64
	movq	%rax, %r12
	jmp	.L2380
.L2399:
	endbr64
	movq	%rax, %r12
	jmp	.L2382
.L2397:
	endbr64
	movq	%rax, %r12
	leaq	128(%rsp), %rbp
	jmp	.L2384
.L2401:
	endbr64
	movq	%rax, %rbp
	jmp	.L2368
.L2402:
	endbr64
	movq	%rax, %rbp
	jmp	.L2366
.L2398:
	endbr64
	movq	%rax, %r12
	jmp	.L2395
	.section	.gcc_except_table
.LLSDA8742:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8742-.LLSDACSB8742
.LLSDACSB8742:
	.uleb128 .LEHB211-.LFB8742
	.uleb128 .LEHE211-.LEHB211
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB212-.LFB8742
	.uleb128 .LEHE212-.LEHB212
	.uleb128 .L2401-.LFB8742
	.uleb128 0
	.uleb128 .LEHB213-.LFB8742
	.uleb128 .LEHE213-.LEHB213
	.uleb128 .L2402-.LFB8742
	.uleb128 0
	.uleb128 .LEHB214-.LFB8742
	.uleb128 .LEHE214-.LEHB214
	.uleb128 .L2397-.LFB8742
	.uleb128 0
	.uleb128 .LEHB215-.LFB8742
	.uleb128 .LEHE215-.LEHB215
	.uleb128 .L2399-.LFB8742
	.uleb128 0
	.uleb128 .LEHB216-.LFB8742
	.uleb128 .LEHE216-.LEHB216
	.uleb128 .L2400-.LFB8742
	.uleb128 0
	.uleb128 .LEHB217-.LFB8742
	.uleb128 .LEHE217-.LEHB217
	.uleb128 .L2398-.LFB8742
	.uleb128 0
	.uleb128 .LEHB218-.LFB8742
	.uleb128 .LEHE218-.LEHB218
	.uleb128 .L2397-.LFB8742
	.uleb128 0
	.uleb128 .LEHB219-.LFB8742
	.uleb128 .LEHE219-.LEHB219
	.uleb128 .L2401-.LFB8742
	.uleb128 0
	.uleb128 .LEHB220-.LFB8742
	.uleb128 .LEHE220-.LEHB220
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB221-.LFB8742
	.uleb128 .LEHE221-.LEHB221
	.uleb128 .L2399-.LFB8742
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
.L2380:
	.cfi_def_cfa_offset 288
	.cfi_offset 3, -48
	.cfi_offset 6, -40
	.cfi_offset 12, -32
	.cfi_offset 13, -24
	.cfi_offset 14, -16
	movq	40(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2382
	call	_ZdlPv@PLT
.L2382:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2383
	call	_ZdlPv@PLT
.L2383:
	leaq	128(%rsp), %rbp
.L2384:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r12, %rdi
.LEHB222:
	call	_Unwind_Resume@PLT
.L2366:
	movq	152(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2368
	call	_ZdlPv@PLT
.L2368:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2369
	call	_ZdlPv@PLT
.L2369:
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE222:
.L2395:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L2384
	.cfi_endproc
.LFE8742:
	.section	.gcc_except_table
.LLSDAC8742:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8742-.LLSDACSBC8742
.LLSDACSBC8742:
	.uleb128 .LEHB222-.LCOLDB46
	.uleb128 .LEHE222-.LEHB222
	.uleb128 0
	.uleb128 0
.LLSDACSEC8742:
	.section	.text.unlikely
	.text
	.size	_ZplRK19quantumSparseMatrixS1_, .-_ZplRK19quantumSparseMatrixS1_
	.section	.text.unlikely
	.size	_ZplRK19quantumSparseMatrixS1_.cold, .-_ZplRK19quantumSparseMatrixS1_.cold
.LCOLDE46:
	.text
.LHOTE46:
	.section	.text.unlikely
.LCOLDB47:
	.text
.LHOTB47:
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
	jne	.L2612
	movl	4(%rax), %ebx
	pxor	%xmm0, %xmm0
	movl	$8, %edi
	movq	$0, -272(%rbp)
	movaps	%xmm0, -288(%rbp)
	movq	%rbx, %rax
	movl	(%rdx), %ebx
	salq	$32, %rax
	orq	%rax, %rbx
.LEHB223:
	call	_Znwm@PLT
.LEHE223:
	movq	%rbx, (%rax)
	leaq	8(%rax), %rdx
	movl	$104, %edi
	movq	%rax, -288(%rbp)
	movq	%rdx, -272(%rbp)
	movq	%rdx, -280(%rbp)
.LEHB224:
	call	_Znwm@PLT
.LEHE224:
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
.LEHB225:
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
.LEHE225:
	movq	-96(%rbp), %rbx
	testq	%rbx, %rbx
	je	.L2460
	movq	-384(%rbp), %rax
	movq	%rax, %r15
.L2457:
	movq	24(%rbx), %rsi
	movq	%r15, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2457
.L2460:
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
	je	.L2620
	movq	-392(%rbp), %rax
	movq	-384(%rbp), %rcx
	movq	-368(%rbp), %rdx
	movq	%rax, %rdi
	movq	%rax, -112(%rbp)
.LEHB226:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE226:
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2465:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2465
	movq	%rdx, -312(%rbp)
	movq	%rcx, %rax
	movq	%rdx, -136(%rbp)
	.p2align 4,,10
	.p2align 3
.L2466:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2466
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
	jne	.L2532
.L2467:
	movq	-368(%rbp), %rsi
	cmpq	%rsi, -312(%rbp)
	je	.L2470
	.p2align 4,,10
	.p2align 3
.L2501:
	movq	-312(%rbp), %rax
	movq	-320(%rbp), %rsi
	addq	$32, %rax
	movq	%rax, -328(%rbp)
	leaq	-256(%rbp), %rax
	movq	%rax, -336(%rbp)
	cmpq	%rsi, -296(%rbp)
	je	.L2500
	.p2align 4,,10
	.p2align 3
.L2499:
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
	je	.L2621
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2622
	movq	%rbx, %rdi
.LEHB227:
	call	_Znwm@PLT
.LEHE227:
	movq	%rax, %rcx
	movq	8(%r12), %rax
	movq	(%r12), %rsi
	movq	%rax, %rdx
	subq	%rsi, %rdx
.L2474:
	addq	%rcx, %rbx
	movq	%rcx, -192(%rbp)
	movq	%rbx, -176(%rbp)
	cmpq	%rsi, %rax
	je	.L2476
	movq	%rcx, %rdi
	movq	%rdx, -344(%rbp)
	call	memcpy@PLT
	movq	-344(%rbp), %rdx
	movq	%rax, %rcx
.L2476:
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
	je	.L2623
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2624
	movq	%rbx, %rdi
.LEHB228:
	call	_Znwm@PLT
.LEHE228:
	movq	-304(%rbp), %rdi
	movq	%rax, %rcx
	movq	8(%rdi), %rax
	movq	(%rdi), %rsi
	movq	%rax, %rdx
	subq	%rsi, %rdx
.L2478:
	addq	%rcx, %rbx
	movq	%rcx, -224(%rbp)
	movq	%rbx, -208(%rbp)
	cmpq	%rsi, %rax
	je	.L2480
	movq	%rcx, %rdi
	movq	%rdx, -344(%rbp)
	call	memcpy@PLT
	movq	-344(%rbp), %rdx
	movq	%rax, %rcx
.L2480:
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
.LEHB229:
	.cfi_escape 0x2e,0x30
	call	_Z17multiplyDiagonalsSt6vectorIiSaIiEES1_ii8diagonalS2_
.LEHE229:
	movq	-224(%rbp), %rdi
	movl	-252(%rbp), %r15d
	addq	$48, %rsp
	movq	-248(%rbp), %r13
	movq	-240(%rbp), %r14
	testq	%rdi, %rdi
	je	.L2481
	call	_ZdlPv@PLT
.L2481:
	movq	-192(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2482
	call	_ZdlPv@PLT
.L2482:
	testl	%r15d, %r15d
	jle	.L2483
	movq	-296(%rbp), %rsi
	leal	-1(%r15), %ecx
	xorl	%eax, %eax
	movq	%rsi, %rdi
	jmp	.L2485
	.p2align 4,,10
	.p2align 3
.L2625:
	ucomiss	(%r14,%rax,4), %xmm2
	jp	.L2484
	jne	.L2484
	leaq	1(%rax), %rdx
	cmpq	%rax, %rcx
	je	.L2616
	movq	%rdx, %rax
.L2485:
	pxor	%xmm2, %xmm2
	ucomiss	0(%r13,%rax,4), %xmm2
	jp	.L2484
	je	.L2625
.L2484:
	movq	-312(%rbp), %rax
	movl	32(%rdi), %edx
	movq	%rdi, -296(%rbp)
	addl	32(%rax), %edx
	movq	-352(%rbp), %rax
	movq	72(%rax), %rax
	testq	%rax, %rax
	je	.L2489
	movq	-360(%rbp), %rsi
	jmp	.L2531
	.p2align 4,,10
	.p2align 3
.L2626:
	movq	%rax, %rsi
	movq	16(%rax), %rax
	testq	%rax, %rax
	je	.L2486
.L2531:
	cmpl	32(%rax), %edx
	jle	.L2626
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2531
.L2486:
	movq	%rdi, -296(%rbp)
	cmpq	%rsi, -360(%rbp)
	je	.L2489
	cmpl	32(%rsi), %edx
	jge	.L2490
.L2489:
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
.LEHB230:
	.cfi_escape 0x2e,0
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE16_M_insert_uniqueIS3_EES0_ISt17_Rb_tree_iteratorIS3_EbEOT_
.LEHE230:
	.p2align 4,,10
	.p2align 3
.L2483:
	movq	-296(%rbp), %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	-320(%rbp), %rdi
	movq	%rax, -296(%rbp)
	cmpq	%rdi, %rax
	jne	.L2499
.L2500:
	movq	-312(%rbp), %rdi
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base@PLT
	movq	-368(%rbp), %rsi
	movq	%rax, -312(%rbp)
	cmpq	%rsi, %rax
	je	.L2470
	movq	-88(%rbp), %rax
	movq	%rax, -296(%rbp)
	jmp	.L2501
.L2620:
	movq	-320(%rbp), %rax
	movq	72(%r12), %rsi
	movl	$0, -104(%rbp)
	movq	$0, -96(%rbp)
	movq	%rax, -88(%rbp)
	movq	%rax, -80(%rbp)
	movq	$0, -72(%rbp)
	testq	%rsi, %rsi
	je	.L2470
.L2532:
	movq	-384(%rbp), %rdi
	movq	-320(%rbp), %rdx
	leaq	-192(%rbp), %rcx
	movq	%rdi, -192(%rbp)
.LEHB231:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE231:
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2468:
	movq	%rax, %rdi
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2468
	movq	%rdi, -88(%rbp)
	movq	%rcx, %rax
	.p2align 4,,10
	.p2align 3
.L2469:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2469
	movq	96(%r12), %rax
	movq	%rdi, -296(%rbp)
	movq	%rdx, -80(%rbp)
	movq	%rax, -72(%rbp)
	movq	-136(%rbp), %rax
	movq	%rcx, -96(%rbp)
	movq	%rax, -312(%rbp)
	jmp	.L2467
	.p2align 4,,10
	.p2align 3
.L2621:
	movq	%rbx, %rdx
	xorl	%ecx, %ecx
	jmp	.L2474
	.p2align 4,,10
	.p2align 3
.L2623:
	movq	%rbx, %rdx
	xorl	%ecx, %ecx
	jmp	.L2478
.L2492:
	movq	-296(%rbp), %rsi
	xorl	%ecx, %ecx
	movq	%rsi, %rdi
	.p2align 4,,10
	.p2align 3
.L2497:
	movss	(%r14,%rcx,4), %xmm0
	movss	(%rdx,%rcx,4), %xmm1
	movq	%rcx, %rsi
	addss	(%rax,%rcx,4), %xmm0
	addss	0(%r13,%rcx,4), %xmm1
	movss	%xmm1, (%rdx,%rcx,4)
	movss	%xmm0, (%rax,%rcx,4)
	addq	$1, %rcx
	cmpq	%rsi, %r10
	jne	.L2497
	.p2align 4,,10
	.p2align 3
.L2616:
	movq	%rdi, -296(%rbp)
	jmp	.L2483
	.p2align 4,,10
	.p2align 3
.L2490:
	movl	44(%rsi), %ecx
	testl	%ecx, %ecx
	jle	.L2483
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
	je	.L2492
	subq	%r14, %rdi
	cmpq	$30, %rdi
	jbe	.L2492
	movl	%ecx, %edi
	movq	-296(%rbp), %rbx
	xorl	%esi, %esi
	shrl	$2, %edi
	salq	$4, %rdi
	.p2align 4,,10
	.p2align 3
.L2493:
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
	jne	.L2493
	movl	%ecx, %r10d
	movq	%rbx, -296(%rbp)
	andl	$-4, %r10d
	testb	$3, %cl
	je	.L2483
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
	jle	.L2483
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
	jle	.L2483
	leaq	8(%rsi), %rcx
	movss	8(%r14,%rsi), %xmm0
	addq	%rcx, %rax
	addq	%rcx, %rdx
	movss	(%rdx), %xmm1
	addss	(%rax), %xmm0
	addss	8(%r13,%rsi), %xmm1
	movss	%xmm1, (%rdx)
	movss	%xmm0, (%rax)
	jmp	.L2483
.L2470:
	movq	-352(%rbp), %rbx
	movq	%rbx, %rdi
.LEHB232:
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
	je	.L2627
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2628
	movq	%rbx, %rdi
	call	_Znwm@PLT
.LEHE232:
	movq	-352(%rbp), %rsi
	movq	%rax, %rcx
	movq	8(%rsi), %rax
	movq	(%rsi), %rsi
	movq	%rax, %rdi
	subq	%rsi, %rdi
	movq	%rdi, %r15
.L2503:
	movq	-376(%rbp), %rdi
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 16(%rdi)
	movups	%xmm0, (%rdi)
	cmpq	%rsi, %rax
	je	.L2505
	movq	%rcx, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2505:
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
	je	.L2629
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2630
	movq	%rbx, %rdi
.LEHB233:
	call	_Znwm@PLT
.LEHE233:
	movq	-352(%rbp), %rsi
	movq	%rax, %rcx
	movq	32(%rsi), %rax
	movq	24(%rsi), %rsi
	movq	%rax, %rdi
	subq	%rsi, %rdi
	movq	%rdi, %r15
.L2507:
	movq	-376(%rbp), %rdi
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 40(%rdi)
	movups	%xmm0, 24(%rdi)
	cmpq	%rsi, %rax
	je	.L2509
	movq	%rcx, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2509:
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
	je	.L2510
	leaq	56(%rax), %rdi
	leaq	-192(%rbp), %rcx
	movq	%rdi, -192(%rbp)
.LEHB234:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE234:
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2511:
	movq	%rax, %rdx
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L2511
	movq	-376(%rbp), %rax
	movq	%rdx, 80(%rax)
	movq	%rcx, %rax
	.p2align 4,,10
	.p2align 3
.L2512:
	movq	%rax, %rdx
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L2512
	movq	-352(%rbp), %rax
	movq	-376(%rbp), %rsi
	movq	96(%rax), %rax
	movq	%rdx, 88(%rsi)
	movq	%rcx, 72(%rsi)
	movq	%rax, 96(%rsi)
.L2510:
	movq	-96(%rbp), %rbx
	testq	%rbx, %rbx
	je	.L2521
	movq	-384(%rbp), %rax
	movq	%rax, %r15
.L2513:
	movq	24(%rbx), %rsi
	movq	%r15, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2513
.L2521:
	movq	-144(%rbp), %rbx
	testq	%rbx, %rbx
	je	.L2514
	movq	-392(%rbp), %rax
	movq	%rax, %r15
.L2515:
	movq	24(%rbx), %rsi
	movq	%r15, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2515
.L2514:
	movq	-288(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2452
	call	_ZdlPv@PLT
.L2452:
	movq	-56(%rbp), %rax
	xorq	%fs:40, %rax
	jne	.L2631
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
.L2627:
	.cfi_restore_state
	movq	%rbx, %r15
	xorl	%ecx, %ecx
	jmp	.L2503
.L2629:
	movq	%rbx, %r15
	xorl	%ecx, %ecx
	jmp	.L2507
.L2624:
.LEHB235:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE235:
.L2622:
.LEHB236:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE236:
.L2631:
	call	__stack_chk_fail@PLT
.L2630:
.LEHB237:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE237:
.L2628:
.LEHB238:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE238:
.L2543:
	endbr64
	movq	%rax, %rbx
	jmp	.L2518
.L2538:
	endbr64
	movq	%rax, %rbx
	jmp	.L2527
.L2540:
	endbr64
	movq	%rax, %rbx
	jmp	.L2520
.L2544:
	endbr64
	movq	%rax, %rbx
	jmp	.L2516
.L2541:
	endbr64
	movq	%rax, %rbx
	jmp	.L2455
.L2542:
	endbr64
	movq	%rax, %r15
	jmp	.L2461
.L2536:
	endbr64
	movq	%rax, %rbx
	jmp	.L2464
.L2537:
	endbr64
	movq	%rax, %rbx
	jmp	.L2529
.L2539:
	endbr64
	movq	%rax, %rbx
	jmp	.L2525
	.section	.gcc_except_table
.LLSDA8697:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8697-.LLSDACSB8697
.LLSDACSB8697:
	.uleb128 .LEHB223-.LFB8697
	.uleb128 .LEHE223-.LEHB223
	.uleb128 .L2541-.LFB8697
	.uleb128 0
	.uleb128 .LEHB224-.LFB8697
	.uleb128 .LEHE224-.LEHB224
	.uleb128 .L2536-.LFB8697
	.uleb128 0
	.uleb128 .LEHB225-.LFB8697
	.uleb128 .LEHE225-.LEHB225
	.uleb128 .L2542-.LFB8697
	.uleb128 0
	.uleb128 .LEHB226-.LFB8697
	.uleb128 .LEHE226-.LEHB226
	.uleb128 .L2536-.LFB8697
	.uleb128 0
	.uleb128 .LEHB227-.LFB8697
	.uleb128 .LEHE227-.LEHB227
	.uleb128 .L2540-.LFB8697
	.uleb128 0
	.uleb128 .LEHB228-.LFB8697
	.uleb128 .LEHE228-.LEHB228
	.uleb128 .L2538-.LFB8697
	.uleb128 0
	.uleb128 .LEHB229-.LFB8697
	.uleb128 .LEHE229-.LEHB229
	.uleb128 .L2539-.LFB8697
	.uleb128 0
	.uleb128 .LEHB230-.LFB8697
	.uleb128 .LEHE230-.LEHB230
	.uleb128 .L2540-.LFB8697
	.uleb128 0
	.uleb128 .LEHB231-.LFB8697
	.uleb128 .LEHE231-.LEHB231
	.uleb128 .L2537-.LFB8697
	.uleb128 0
	.uleb128 .LEHB232-.LFB8697
	.uleb128 .LEHE232-.LEHB232
	.uleb128 .L2540-.LFB8697
	.uleb128 0
	.uleb128 .LEHB233-.LFB8697
	.uleb128 .LEHE233-.LEHB233
	.uleb128 .L2543-.LFB8697
	.uleb128 0
	.uleb128 .LEHB234-.LFB8697
	.uleb128 .LEHE234-.LEHB234
	.uleb128 .L2544-.LFB8697
	.uleb128 0
	.uleb128 .LEHB235-.LFB8697
	.uleb128 .LEHE235-.LEHB235
	.uleb128 .L2538-.LFB8697
	.uleb128 0
	.uleb128 .LEHB236-.LFB8697
	.uleb128 .LEHE236-.LEHB236
	.uleb128 .L2540-.LFB8697
	.uleb128 0
	.uleb128 .LEHB237-.LFB8697
	.uleb128 .LEHE237-.LEHB237
	.uleb128 .L2543-.LFB8697
	.uleb128 0
	.uleb128 .LEHB238-.LFB8697
	.uleb128 .LEHE238-.LEHB238
	.uleb128 .L2540-.LFB8697
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
.L2516:
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
	je	.L2518
	call	_ZdlPv@PLT
.L2518:
	movq	-376(%rbp), %rax
	movq	(%rax), %rdi
	testq	%rdi, %rdi
	jne	.L2632
.L2520:
	movq	-96(%rbp), %rsi
	movq	-384(%rbp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2529:
	movq	-144(%rbp), %rsi
	movq	-392(%rbp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
.L2464:
	movq	-288(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2530
	call	_ZdlPv@PLT
.L2530:
	movq	%rbx, %rdi
.LEHB239:
	call	_Unwind_Resume@PLT
.LEHE239:
.L2525:
	movq	-224(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2527
	call	_ZdlPv@PLT
.L2527:
	movq	-192(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2520
	call	_ZdlPv@PLT
	jmp	.L2520
.L2632:
	call	_ZdlPv@PLT
	jmp	.L2520
.L2612:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC23(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbx
.LEHB240:
	call	_ZNSt16invalid_argumentC1EPKc@PLT
.LEHE240:
	movq	_ZNSt16invalid_argumentD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt16invalid_argument(%rip), %rsi
	movq	%rbx, %rdi
.LEHB241:
	call	__cxa_throw@PLT
.L2455:
	movq	-288(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L2456
	call	_ZdlPv@PLT
.L2456:
	movq	%rbx, %rdi
	call	_Unwind_Resume@PLT
.L2535:
	endbr64
	movq	%rax, %r12
	movq	%rbx, %rdi
	call	__cxa_free_exception@PLT
	movq	%r12, %rdi
	call	_Unwind_Resume@PLT
.LEHE241:
.L2461:
	movq	-96(%rbp), %rsi
	movq	-384(%rbp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	-352(%rbp), %rbx
	movq	-400(%rbp), %rdi
	movq	72(%rbx), %rsi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	24(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L2462
	call	_ZdlPv@PLT
.L2462:
	movq	-352(%rbp), %rax
	movq	(%rax), %rdi
	testq	%rdi, %rdi
	je	.L2463
	call	_ZdlPv@PLT
.L2463:
	movq	-352(%rbp), %rdi
	movq	%r15, %rbx
	call	_ZdlPv@PLT
	jmp	.L2464
	.cfi_endproc
.LFE8697:
	.section	.gcc_except_table
.LLSDAC8697:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8697-.LLSDACSBC8697
.LLSDACSBC8697:
	.uleb128 .LEHB239-.LCOLDB47
	.uleb128 .LEHE239-.LEHB239
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB240-.LCOLDB47
	.uleb128 .LEHE240-.LEHB240
	.uleb128 .L2535-.LCOLDB47
	.uleb128 0
	.uleb128 .LEHB241-.LCOLDB47
	.uleb128 .LEHE241-.LEHB241
	.uleb128 0
	.uleb128 0
.LLSDACSEC8697:
	.section	.text.unlikely
	.text
	.size	_Z7product19quantumSparseMatrixS_, .-_Z7product19quantumSparseMatrixS_
	.section	.text.unlikely
	.size	_Z7product19quantumSparseMatrixS_.cold, .-_Z7product19quantumSparseMatrixS_.cold
.LCOLDE47:
	.text
.LHOTE47:
	.section	.text.unlikely
.LCOLDB48:
	.text
.LHOTB48:
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
	je	.L2724
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2725
	movq	%r13, %rdi
.LEHB242:
	call	_Znwm@PLT
.LEHE242:
	movq	(%rbx), %rsi
	movq	%rax, %rcx
	movq	8(%rbx), %rax
	movq	%rax, %r14
	subq	%rsi, %r14
.L2635:
	movq	%rcx, %xmm0
	addq	%rcx, %r13
	punpcklqdq	%xmm0, %xmm0
	movq	%r13, 144(%rsp)
	movaps	%xmm0, 128(%rsp)
	cmpq	%rsi, %rax
	je	.L2637
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2637:
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
	je	.L2726
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2727
	movq	%r13, %rdi
.LEHB243:
	call	_Znwm@PLT
.LEHE243:
	movq	%rax, %rcx
	movq	32(%rbx), %rax
	movq	24(%rbx), %rsi
	movq	%rax, %r14
	subq	%rsi, %r14
.L2639:
	movq	%rcx, %xmm0
	addq	%rcx, %r13
	punpcklqdq	%xmm0, %xmm0
	movq	%r13, 168(%rsp)
	movups	%xmm0, 152(%rsp)
	cmpq	%rsi, %rax
	je	.L2641
	movq	%rcx, %rdi
	movq	%r14, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2641:
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
	je	.L2642
	leaq	184(%rsp), %r13
	leaq	16(%rsp), %rcx
	movq	%r13, %rdi
	movq	%r13, 16(%rsp)
.LEHB244:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE244:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2643:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2643
	movq	%rcx, 208(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2644:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2644
	movq	96(%rbx), %rdx
	movq	%rcx, 216(%rsp)
	movq	%rax, 200(%rsp)
	movq	%rdx, 224(%rsp)
.L2642:
	movq	8(%rbp), %rax
	movq	0(%rbp), %rsi
	pxor	%xmm0, %xmm0
	movq	$0, 32(%rsp)
	movaps	%xmm0, 16(%rsp)
	movq	%rax, %rbx
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L2728
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2729
	movq	%rbx, %rdi
.LEHB245:
	call	_Znwm@PLT
.LEHE245:
	movq	%rax, %rcx
	movq	8(%rbp), %rax
	movq	0(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2646:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 32(%rsp)
	movaps	%xmm0, 16(%rsp)
	cmpq	%rsi, %rax
	je	.L2652
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2652:
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
	je	.L2730
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L2731
	movq	%rbx, %rdi
.LEHB246:
	call	_Znwm@PLT
.LEHE246:
	movq	%rax, %rcx
	movq	32(%rbp), %rax
	movq	24(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2654:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 56(%rsp)
	movups	%xmm0, 40(%rsp)
	cmpq	%rsi, %rax
	je	.L2656
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2656:
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
	je	.L2657
	leaq	72(%rsp), %r13
	leaq	8(%rsp), %rcx
	movq	%r13, %rdi
	movq	%r13, 8(%rsp)
.LEHB247:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE7_M_copyINS9_11_Alloc_nodeEEEPSt13_Rb_tree_nodeIS3_EPKSD_PSt18_Rb_tree_node_baseRT_
.LEHE247:
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2658:
	movq	%rdx, %rcx
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2658
	movq	%rcx, 96(%rsp)
	movq	%rax, %rdx
	.p2align 4,,10
	.p2align 3
.L2659:
	movq	%rdx, %rcx
	movq	24(%rdx), %rdx
	testq	%rdx, %rdx
	jne	.L2659
	movq	96(%rbp), %rdx
	movq	%rcx, 104(%rsp)
	movq	%rax, 88(%rsp)
	movq	%rdx, 112(%rsp)
.L2657:
	leaq	128(%rsp), %rbp
	leaq	16(%rsp), %r13
	movq	%r12, %rdi
	movq	%rbp, %rdx
	movq	%r13, %rsi
.LEHB248:
	call	_Z7product19quantumSparseMatrixS_
.LEHE248:
	movq	88(%rsp), %rbx
	leaq	72(%rsp), %r13
	testq	%rbx, %rbx
	je	.L2669
.L2666:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2666
.L2669:
	movq	40(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2668
	call	_ZdlPv@PLT
.L2668:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2670
	call	_ZdlPv@PLT
.L2670:
	movq	200(%rsp), %rbx
	leaq	184(%rsp), %r13
	testq	%rbx, %rbx
	je	.L2674
.L2671:
	movq	24(%rbx), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2671
.L2674:
	movq	152(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2673
	call	_ZdlPv@PLT
.L2673:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2633
	call	_ZdlPv@PLT
.L2633:
	movq	232(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L2732
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
.L2724:
	.cfi_restore_state
	movq	%r13, %r14
	xorl	%ecx, %ecx
	jmp	.L2635
	.p2align 4,,10
	.p2align 3
.L2726:
	movq	%r13, %r14
	xorl	%ecx, %ecx
	jmp	.L2639
	.p2align 4,,10
	.p2align 3
.L2730:
	movq	%rbx, %r13
	xorl	%ecx, %ecx
	jmp	.L2654
	.p2align 4,,10
	.p2align 3
.L2728:
	movq	%rbx, %r13
	xorl	%ecx, %ecx
	jmp	.L2646
.L2732:
	call	__stack_chk_fail@PLT
.L2729:
.LEHB249:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE249:
.L2727:
.LEHB250:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE250:
.L2725:
.LEHB251:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE251:
.L2731:
.LEHB252:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE252:
.L2681:
	endbr64
	movq	%rax, %r12
	jmp	.L2661
.L2680:
	endbr64
	movq	%rax, %r12
	jmp	.L2663
.L2678:
	endbr64
	movq	%rax, %r12
	leaq	128(%rsp), %rbp
	jmp	.L2665
.L2682:
	endbr64
	movq	%rax, %rbp
	jmp	.L2649
.L2683:
	endbr64
	movq	%rax, %rbp
	jmp	.L2647
.L2679:
	endbr64
	movq	%rax, %r12
	jmp	.L2676
	.section	.gcc_except_table
.LLSDA8741:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8741-.LLSDACSB8741
.LLSDACSB8741:
	.uleb128 .LEHB242-.LFB8741
	.uleb128 .LEHE242-.LEHB242
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB243-.LFB8741
	.uleb128 .LEHE243-.LEHB243
	.uleb128 .L2682-.LFB8741
	.uleb128 0
	.uleb128 .LEHB244-.LFB8741
	.uleb128 .LEHE244-.LEHB244
	.uleb128 .L2683-.LFB8741
	.uleb128 0
	.uleb128 .LEHB245-.LFB8741
	.uleb128 .LEHE245-.LEHB245
	.uleb128 .L2678-.LFB8741
	.uleb128 0
	.uleb128 .LEHB246-.LFB8741
	.uleb128 .LEHE246-.LEHB246
	.uleb128 .L2680-.LFB8741
	.uleb128 0
	.uleb128 .LEHB247-.LFB8741
	.uleb128 .LEHE247-.LEHB247
	.uleb128 .L2681-.LFB8741
	.uleb128 0
	.uleb128 .LEHB248-.LFB8741
	.uleb128 .LEHE248-.LEHB248
	.uleb128 .L2679-.LFB8741
	.uleb128 0
	.uleb128 .LEHB249-.LFB8741
	.uleb128 .LEHE249-.LEHB249
	.uleb128 .L2678-.LFB8741
	.uleb128 0
	.uleb128 .LEHB250-.LFB8741
	.uleb128 .LEHE250-.LEHB250
	.uleb128 .L2682-.LFB8741
	.uleb128 0
	.uleb128 .LEHB251-.LFB8741
	.uleb128 .LEHE251-.LEHB251
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB252-.LFB8741
	.uleb128 .LEHE252-.LEHB252
	.uleb128 .L2680-.LFB8741
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
.L2661:
	.cfi_def_cfa_offset 288
	.cfi_offset 3, -48
	.cfi_offset 6, -40
	.cfi_offset 12, -32
	.cfi_offset 13, -24
	.cfi_offset 14, -16
	movq	40(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2663
	call	_ZdlPv@PLT
.L2663:
	movq	16(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2664
	call	_ZdlPv@PLT
.L2664:
	leaq	128(%rsp), %rbp
.L2665:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r12, %rdi
.LEHB253:
	call	_Unwind_Resume@PLT
.L2647:
	movq	152(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2649
	call	_ZdlPv@PLT
.L2649:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2650
	call	_ZdlPv@PLT
.L2650:
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE253:
.L2676:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L2665
	.cfi_endproc
.LFE8741:
	.section	.gcc_except_table
.LLSDAC8741:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8741-.LLSDACSBC8741
.LLSDACSBC8741:
	.uleb128 .LEHB253-.LCOLDB48
	.uleb128 .LEHE253-.LEHB253
	.uleb128 0
	.uleb128 0
.LLSDACSEC8741:
	.section	.text.unlikely
	.text
	.size	_ZmlRK19quantumSparseMatrixS1_, .-_ZmlRK19quantumSparseMatrixS1_
	.section	.text.unlikely
	.size	_ZmlRK19quantumSparseMatrixS1_.cold, .-_ZmlRK19quantumSparseMatrixS1_.cold
.LCOLDE48:
	.text
.LHOTE48:
	.section	.rodata.str1.8
	.align 8
.LC49:
	.string	"axes_1_product != axes_0_product i.e. "
	.section	.rodata.str1.1
.LC50:
	.string	" != "
	.section	.rodata.str1.8
	.align 8
.LC51:
	.string	"invalid axes, can't perform tensordot"
	.section	.text.unlikely
.LCOLDB52:
	.text
.LHOTB52:
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
	movq	%rax, 48(%rsp)
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
	movq	%rax, 40(%rsp)
.LEHB254:
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EEaSERKS9_
.LEHE254:
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
	leaq	24(%r12), %rbp
	movl	592(%rsp), %edx
	movl	%edx, 48(%r12)
	cmpq	%rax, %rsi
	je	.L2734
	movl	%edx, (%rsi)
	addq	$4, %rsi
	movq	%rsi, 8(%r12)
	cmpq	%rax, %rsi
	je	.L2736
.L3198:
	movl	592(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 8(%r12)
.L2737:
	movq	32(%r12), %rsi
	movq	40(%r12), %rax
	cmpq	%rax, %rsi
	je	.L2738
	movl	592(%rsp), %edx
	addq	$4, %rsi
	movl	%edx, -4(%rsi)
	movq	%rsi, 32(%r12)
	cmpq	%rax, %rsi
	je	.L2740
.L3197:
	movl	592(%rsp), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 32(%r12)
.L2741:
	movq	720(%rsp), %rbp
	movq	(%rsp), %r13
	testq	%rbp, %rbp
	je	.L2745
.L2742:
	movq	24(%rbp), %rsi
	movq	%r13, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbp, %rdi
	movq	16(%rbp), %rbp
	call	_ZdlPv@PLT
	testq	%rbp, %rbp
	jne	.L2742
.L2745:
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
	jne	.L2743
	jmp	.L2744
	.p2align 4,,10
	.p2align 3
.L3171:
	movl	(%rdx), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 104(%rsp)
.L2750:
	movq	24(%rdi), %rdx
	movq	32(%rdi), %rax
	addq	$1, %rbp
	subq	%rdx, %rax
	sarq	$2, %rax
	cmpq	%rbp, %rax
	jbe	.L2744
	movq	104(%rsp), %rsi
	movq	112(%rsp), %rax
.L2743:
	leaq	(%rdx,%rbp,4), %rdx
	cmpq	%rax, %rsi
	jne	.L3171
	movq	%r13, %rdi
.LEHB255:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%rsp), %rax
	movq	(%rax), %rdi
	jmp	.L2750
	.p2align 4,,10
	.p2align 3
.L2744:
	movq	24(%r14), %r9
	movq	32(%r14), %r8
	movl	$0, 704(%rsp)
	cmpq	%r9, %r8
	je	.L2751
	xorl	%ecx, %ecx
	leaq	64(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L2755:
	movq	(%rdi), %rsi
	movq	8(%rdi), %rdx
	subq	%rsi, %rdx
	sarq	$2, %rdx
	je	.L2752
	xorl	%eax, %eax
	jmp	.L2754
	.p2align 4,,10
	.p2align 3
.L3172:
	addq	$1, %rax
	cmpq	%rax, %rdx
	je	.L2752
.L2754:
	cmpl	%ecx, (%rsi,%rax,4)
	jne	.L3172
.L2753:
	movq	%r8, %rax
	addl	$1, %ecx
	subq	%r9, %rax
	movslq	%ecx, %rdx
	movl	%ecx, 704(%rsp)
	sarq	$2, %rax
	cmpq	%rax, %rdx
	jb	.L2755
.L2751:
	movq	24(%rbx), %r9
	movq	32(%rbx), %r8
	movl	$0, 704(%rsp)
	cmpq	%r9, %r8
	je	.L2756
	xorl	%ecx, %ecx
	leaq	96(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L2760:
	movq	24(%rdi), %rsi
	movq	32(%rdi), %rdx
	subq	%rsi, %rdx
	sarq	$2, %rdx
	je	.L2757
	xorl	%eax, %eax
	jmp	.L2759
	.p2align 4,,10
	.p2align 3
.L3173:
	addq	$1, %rax
	cmpq	%rdx, %rax
	je	.L2757
.L2759:
	cmpl	%ecx, (%rsi,%rax,4)
	jne	.L3173
.L2758:
	movq	%r8, %rax
	addl	$1, %ecx
	subq	%r9, %rax
	movslq	%ecx, %rdx
	movl	%ecx, 704(%rsp)
	sarq	$2, %rax
	cmpq	%rax, %rdx
	jb	.L2760
.L2756:
	movq	(%rdi), %rax
	movq	72(%rsp), %rsi
	xorl	%ebp, %ebp
	leaq	64(%rsp), %r13
	cmpq	%rax, 8(%rdi)
	jne	.L2761
	jmp	.L3169
	.p2align 4,,10
	.p2align 3
.L3175:
	movl	(%rdx), %eax
	addq	$4, %rsi
	movl	%eax, -4(%rsi)
	movq	%rsi, 72(%rsp)
.L2765:
	movq	(%rdi), %rax
	movq	8(%rdi), %rdx
	addq	$1, %rbp
	subq	%rax, %rdx
	movq	%rdx, %rcx
	sarq	$2, %rcx
	cmpq	%rbp, %rcx
	jbe	.L3174
.L2761:
	leaq	(%rax,%rbp,4), %rdx
	cmpq	%rsi, 80(%rsp)
	jne	.L3175
	movq	%r13, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%rsp), %rax
	movq	72(%rsp), %rsi
	movq	(%rax), %rdi
	jmp	.L2765
	.p2align 4,,10
	.p2align 3
.L2752:
	movq	72(%rsp), %rsi
	cmpq	80(%rsp), %rsi
	je	.L3176
	movl	%ecx, (%rsi)
	addq	$4, %rsi
	movl	704(%rsp), %ecx
	movq	%rsi, 72(%rsp)
	jmp	.L2753
	.p2align 4,,10
	.p2align 3
.L2757:
	movq	104(%rsp), %rsi
	cmpq	112(%rsp), %rsi
	je	.L3177
	movl	%ecx, (%rsi)
	addq	$4, %rsi
	movl	704(%rsp), %ecx
	movq	%rsi, 104(%rsp)
	jmp	.L2758
	.p2align 4,,10
	.p2align 3
.L3174:
	testq	%rcx, %rcx
	je	.L3169
	movq	24(%r14), %r8
	addq	%rax, %rdx
	movl	$1, %r13d
	.p2align 4,,10
	.p2align 3
.L2769:
	movslq	(%rax), %rcx
	addq	$4, %rax
	imull	(%r8,%rcx,4), %r13d
	cmpq	%rdx, %rax
	jne	.L2769
.L2762:
	movq	24(%rdi), %rax
	movq	32(%rdi), %rcx
	subq	%rax, %rcx
	movq	%rcx, %rdi
	shrq	$2, %rdi
	je	.L3178
	movq	24(%rbx), %rdi
	addq	%rax, %rcx
	movl	$1, %edx
	.p2align 4,,10
	.p2align 3
.L2770:
	movslq	(%rax), %r8
	addq	$4, %rax
	imull	(%rdi,%r8,4), %edx
	cmpq	%rcx, %rax
	jne	.L2770
	movl	%edx, 24(%rsp)
.L2768:
	movq	64(%rsp), %r8
	movq	%rsi, %rbp
	pxor	%xmm0, %xmm0
	movq	$0, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	subq	%r8, %rbp
	movq	%rbp, %rax
	sarq	$2, %rax
	je	.L3179
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L3180
	movq	%rbp, %rdi
	call	_Znwm@PLT
.LEHE255:
	movq	72(%rsp), %rsi
	movq	64(%rsp), %r8
	movq	%rax, %rcx
	movq	%rsi, %r15
	subq	%r8, %r15
.L2772:
	movq	%rcx, %xmm0
	addq	%rcx, %rbp
	punpcklqdq	%xmm0, %xmm0
	movq	%rbp, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	cmpq	%r8, %rsi
	je	.L2774
	movq	%rcx, %rdi
	movq	%r15, %rdx
	movq	%r8, %rsi
	call	memmove@PLT
	movq	%rax, %rcx
.L2774:
	addq	%r15, %rcx
	movq	(%rsp), %r15
	movq	%r14, %rsi
	movq	%rcx, 600(%rsp)
	movq	%r15, %rdi
.LEHB256:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE256:
	leaq	480(%rsp), %rax
	leaq	592(%rsp), %rcx
	movq	%r15, %rsi
	movq	%rcx, %rdx
	movq	%rax, %rdi
	movq	%rax, 32(%rsp)
	movq	%rcx, 16(%rsp)
.LEHB257:
	call	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE257:
	movdqa	480(%rsp), %xmm1
	movq	496(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 496(%rsp)
	movq	(%r14), %rdi
	movaps	%xmm0, 480(%rsp)
	movq	%rax, 16(%r14)
	movups	%xmm1, (%r14)
	testq	%rdi, %rdi
	je	.L2775
	call	_ZdlPv@PLT
.L2775:
	movq	520(%rsp), %rax
	movq	24(%r14), %rdi
	pxor	%xmm0, %xmm0
	movq	$0, 520(%rsp)
	movdqu	504(%rsp), %xmm2
	movups	%xmm0, 504(%rsp)
	movq	%rax, 40(%r14)
	movups	%xmm2, 24(%r14)
	testq	%rdi, %rdi
	je	.L2776
	call	_ZdlPv@PLT
.L2776:
	movl	528(%rsp), %eax
	movq	72(%r14), %r15
	leaq	56(%r14), %rbp
	movl	%eax, 48(%r14)
	testq	%r15, %r15
	je	.L2780
.L2777:
	movq	24(%r15), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r15, %rdi
	movq	16(%r15), %r15
	call	_ZdlPv@PLT
	testq	%r15, %r15
	jne	.L2777
.L2780:
	movq	552(%rsp), %rdx
	leaq	64(%r14), %rax
	movq	$0, 72(%r14)
	movq	%rax, 80(%r14)
	movq	%rax, 88(%r14)
	movq	$0, 96(%r14)
	testq	%rdx, %rdx
	je	.L2779
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
.L2779:
	movq	504(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2921
	call	_ZdlPv@PLT
.L2921:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2781
	call	_ZdlPv@PLT
.L2781:
	movq	776(%rsp), %r15
	leaq	760(%rsp), %rbp
	testq	%r15, %r15
	je	.L2785
.L2782:
	movq	24(%r15), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r15, %rdi
	movq	16(%r15), %r15
	call	_ZdlPv@PLT
	testq	%r15, %r15
	jne	.L2782
.L2785:
	movq	728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2784
	call	_ZdlPv@PLT
.L2784:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2786
	call	_ZdlPv@PLT
.L2786:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2787
	call	_ZdlPv@PLT
.L2787:
	movq	104(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	96(%rsp), %rsi
	movq	$0, 496(%rsp)
	movaps	%xmm0, 480(%rsp)
	movq	%rax, %rbp
	subq	%rsi, %rbp
	movq	%rbp, %rdx
	sarq	$2, %rdx
	je	.L3181
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L3182
	movq	%rbp, %rdi
.LEHB258:
	call	_Znwm@PLT
.LEHE258:
	movq	%rax, %rcx
	movq	104(%rsp), %rax
	movq	96(%rsp), %rsi
	movq	%rax, %r15
	subq	%rsi, %r15
.L2789:
	movq	%rcx, %xmm0
	addq	%rcx, %rbp
	punpcklqdq	%xmm0, %xmm0
	movq	%rbp, 496(%rsp)
	movaps	%xmm0, 480(%rsp)
	cmpq	%rsi, %rax
	je	.L2791
	movq	%rcx, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2791:
	addq	%r15, %rcx
	movq	(%rsp), %r15
	movq	%rbx, %rsi
	movq	%rcx, 488(%rsp)
	movq	%r15, %rdi
.LEHB259:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE259:
	movq	32(%rsp), %rdx
	movq	16(%rsp), %rdi
	movq	%r15, %rsi
.LEHB260:
	call	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE260:
	movdqa	592(%rsp), %xmm3
	movq	608(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 608(%rsp)
	movq	(%rbx), %rdi
	movaps	%xmm0, 592(%rsp)
	movq	%rax, 16(%rbx)
	movups	%xmm3, (%rbx)
	testq	%rdi, %rdi
	je	.L2792
	call	_ZdlPv@PLT
.L2792:
	movq	632(%rsp), %rax
	movq	24(%rbx), %rdi
	pxor	%xmm0, %xmm0
	movq	$0, 632(%rsp)
	movdqu	616(%rsp), %xmm4
	movups	%xmm0, 616(%rsp)
	movq	%rax, 40(%rbx)
	movups	%xmm4, 24(%rbx)
	testq	%rdi, %rdi
	je	.L2793
	call	_ZdlPv@PLT
.L2793:
	movl	640(%rsp), %eax
	movq	72(%rbx), %r15
	leaq	56(%rbx), %rbp
	movl	%eax, 48(%rbx)
	testq	%r15, %r15
	je	.L2797
.L2794:
	movq	24(%r15), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r15, %rdi
	movq	16(%r15), %r15
	call	_ZdlPv@PLT
	testq	%r15, %r15
	jne	.L2794
.L2797:
	movq	664(%rsp), %rdx
	leaq	64(%rbx), %rax
	movq	$0, 72(%rbx)
	movq	%rax, 80(%rbx)
	movq	%rax, 88(%rbx)
	movq	$0, 96(%rbx)
	testq	%rdx, %rdx
	je	.L2796
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
.L2796:
	movq	616(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2919
	call	_ZdlPv@PLT
.L2919:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2798
	call	_ZdlPv@PLT
.L2798:
	movq	776(%rsp), %r15
	leaq	760(%rsp), %rbp
	testq	%r15, %r15
	je	.L2802
.L2799:
	movq	24(%r15), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r15, %rdi
	movq	16(%r15), %r15
	call	_ZdlPv@PLT
	testq	%r15, %r15
	jne	.L2799
.L2802:
	movq	728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2801
	call	_ZdlPv@PLT
.L2801:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2803
	call	_ZdlPv@PLT
.L2803:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2804
	call	_ZdlPv@PLT
.L2804:
	movl	24(%rsp), %r15d
	cmpl	%r13d, %r15d
	je	.L2805
	movl	$38, %edx
	leaq	.LC49(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB261:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	%r15d, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$4, %edx
	leaq	.LC50(%rip), %rsi
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
	je	.L3183
	cmpb	$0, 56(%r13)
	je	.L2807
	movsbl	67(%r13), %esi
.L2808:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	jmp	.L3151
	.p2align 4,,10
	.p2align 3
.L2807:
	movq	%r13, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%r13), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rdx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rdx, %rax
	je	.L2808
	movq	%r13, %rdi
	call	*%rax
	movsbl	%al, %esi
	jmp	.L2808
.L3177:
	movq	(%rsp), %rdx
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%rsp), %rax
	movl	704(%rsp), %ecx
	movq	24(%rbx), %r9
	movq	32(%rbx), %r8
	movq	(%rax), %rdi
	jmp	.L2758
.L3176:
	movq	(%rsp), %rdx
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%rsp), %rax
	movl	704(%rsp), %ecx
	movq	24(%r14), %r9
	movq	32(%r14), %r8
	movq	(%rax), %rdi
	jmp	.L2753
.L2805:
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
.LEHE261:
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
.LEHB262:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE262:
	movq	136(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	128(%rsp), %rsi
	movq	$0, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	movq	%rax, %rbp
	subq	%rsi, %rbp
	movq	%rbp, %rdx
	sarq	$2, %rdx
	je	.L3184
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L3185
	movq	%rbp, %rdi
.LEHB263:
	call	_Znwm@PLT
.LEHE263:
	movq	%rax, %rcx
	movq	136(%rsp), %rax
	movq	128(%rsp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2810:
	movq	%rcx, %xmm0
	addq	%rcx, %rbp
	punpcklqdq	%xmm0, %xmm0
	movq	%rbp, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	cmpq	%rsi, %rax
	je	.L2812
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2812:
	movq	(%rsp), %r15
	addq	%r13, %rcx
	movq	%r14, %rsi
	movq	%rcx, 600(%rsp)
	movq	%r15, %rdi
.LEHB264:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE264:
	leaq	256(%rsp), %rax
	movq	16(%rsp), %rdx
	movq	%r15, %rsi
	movq	%rax, %rdi
	movq	%rax, 56(%rsp)
.LEHB265:
	call	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE265:
	movq	776(%rsp), %r13
	leaq	760(%rsp), %rbp
	testq	%r13, %r13
	je	.L2816
.L2813:
	movq	24(%r13), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r13, %rdi
	movq	16(%r13), %r13
	call	_ZdlPv@PLT
	testq	%r13, %r13
	jne	.L2813
.L2816:
	movq	728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2815
	call	_ZdlPv@PLT
.L2815:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2817
	call	_ZdlPv@PLT
.L2817:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2818
	call	_ZdlPv@PLT
.L2818:
	movq	168(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	160(%rsp), %rsi
	movq	$0, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	movq	%rax, %rbp
	subq	%rsi, %rbp
	movq	%rbp, %rdx
	sarq	$2, %rdx
	je	.L3186
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L3187
	movq	%rbp, %rdi
.LEHB266:
	call	_Znwm@PLT
.LEHE266:
	movq	%rax, %rcx
	movq	168(%rsp), %rax
	movq	160(%rsp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2820:
	movq	%rcx, %xmm0
	addq	%rcx, %rbp
	punpcklqdq	%xmm0, %xmm0
	movq	%rbp, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	cmpq	%rsi, %rax
	je	.L2822
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2822:
	movq	(%rsp), %rbp
	addq	%r13, %rcx
	movq	%rbx, %rsi
	movq	%rcx, 600(%rsp)
	movq	%rbp, %rdi
.LEHB267:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE267:
	leaq	368(%rsp), %r15
	movq	16(%rsp), %rdx
	movq	%rbp, %rsi
	movq	%r15, %rdi
.LEHB268:
	call	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE268:
	movq	776(%rsp), %r13
	leaq	760(%rsp), %rbp
	testq	%r13, %r13
	je	.L2826
.L2823:
	movq	24(%r13), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r13, %rdi
	movq	16(%r13), %r13
	call	_ZdlPv@PLT
	testq	%r13, %r13
	jne	.L2823
.L2826:
	movq	728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2825
	call	_ZdlPv@PLT
.L2825:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2827
	call	_ZdlPv@PLT
.L2827:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2828
	call	_ZdlPv@PLT
.L2828:
	movq	16(%rsp), %r13
	movq	%r15, %rsi
	movq	%r13, %rdi
.LEHB269:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE269:
	movq	32(%rsp), %rbp
	movq	56(%rsp), %rsi
	movq	%rbp, %rdi
.LEHB270:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE270:
	movq	(%rsp), %rdi
	movq	%r13, %rdx
	movq	%rbp, %rsi
.LEHB271:
	call	_Z7product19quantumSparseMatrixS_
.LEHE271:
	movq	720(%rsp), %rax
	movq	(%r12), %rdi
	pxor	%xmm0, %xmm0
	movq	$0, 720(%rsp)
	movdqa	704(%rsp), %xmm5
	movaps	%xmm0, 704(%rsp)
	movq	%rax, 16(%r12)
	movups	%xmm5, (%r12)
	testq	%rdi, %rdi
	je	.L2829
	call	_ZdlPv@PLT
.L2829:
	movdqu	728(%rsp), %xmm6
	movq	744(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 744(%rsp)
	movq	24(%r12), %rdi
	movups	%xmm0, 728(%rsp)
	movq	%rax, 40(%r12)
	movups	%xmm6, 24(%r12)
	testq	%rdi, %rdi
	je	.L2830
	call	_ZdlPv@PLT
.L2830:
	movl	752(%rsp), %eax
	movq	40(%rsp), %rdi
	movq	72(%r12), %rsi
	movl	%eax, 48(%r12)
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	48(%rsp), %rdi
	movq	776(%rsp), %rax
	movq	$0, 72(%r12)
	movq	$0, 96(%r12)
	movq	%rdi, 80(%r12)
	movq	%rdi, 88(%r12)
	testq	%rax, %rax
	je	.L2831
	movl	768(%rsp), %edx
	movq	%rax, 72(%r12)
	movl	%edx, 64(%r12)
	movq	784(%rsp), %rdx
	movq	%rdx, 80(%r12)
	movq	792(%rsp), %rdx
	movq	%rdx, 88(%r12)
	movq	%rdi, 8(%rax)
	movq	800(%rsp), %rax
	movq	%rax, 96(%r12)
.L2831:
	movq	728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2917
	call	_ZdlPv@PLT
.L2917:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2832
	call	_ZdlPv@PLT
.L2832:
	movq	552(%rsp), %r13
	leaq	536(%rsp), %rbp
	testq	%r13, %r13
	je	.L2836
.L2833:
	movq	24(%r13), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r13, %rdi
	movq	16(%r13), %r13
	call	_ZdlPv@PLT
	testq	%r13, %r13
	jne	.L2833
.L2836:
	movq	504(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2835
	call	_ZdlPv@PLT
.L2835:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2837
	call	_ZdlPv@PLT
.L2837:
	movq	664(%rsp), %r13
	leaq	648(%rsp), %rbp
	testq	%r13, %r13
	je	.L2841
.L2838:
	movq	24(%r13), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%r13, %rdi
	movq	16(%r13), %r13
	call	_ZdlPv@PLT
	testq	%r13, %r13
	jne	.L2838
.L2841:
	movq	616(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2840
	call	_ZdlPv@PLT
.L2840:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2842
	call	_ZdlPv@PLT
.L2842:
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
	je	.L3188
	movabsq	$2305843009213693951, %rdx
	cmpq	%rdx, %rax
	ja	.L3189
	movq	24(%rsp), %rdi
.LEHB272:
	call	_Znwm@PLT
.LEHE272:
	movq	32(%rbp), %rdx
	movq	%rax, %rcx
	movq	8(%rsp), %rax
	movq	24(%rbp), %rsi
	movq	%rdx, %r8
	movq	(%rax), %r13
	subq	%rsi, %r8
.L2844:
	movq	24(%rsp), %rax
	movq	%rcx, %xmm0
	punpcklqdq	%xmm0, %xmm0
	addq	%rcx, %rax
	movaps	%xmm0, 704(%rsp)
	movq	%rax, 720(%rsp)
	cmpq	%rsi, %rdx
	je	.L2846
	movq	%r8, %rdx
	movq	%rcx, %rdi
	movq	%r8, 8(%rsp)
	call	memmove@PLT
	movq	8(%rsp), %r8
	movq	%rax, %rcx
.L2846:
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
	je	.L3190
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L3191
	movq	%rbp, %rdi
.LEHB273:
	call	_Znwm@PLT
.LEHE273:
	movq	%rax, %rcx
	movq	8(%r13), %rax
	movq	0(%r13), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L2848:
	movq	%rcx, %xmm0
	addq	%rcx, %rbp
	punpcklqdq	%xmm0, %xmm0
	movq	%rbp, 608(%rsp)
	movaps	%xmm0, 592(%rsp)
	cmpq	%rsi, %rax
	je	.L2850
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2850:
	movq	32(%rbx), %rax
	movq	24(%rbx), %rsi
	addq	%r13, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 600(%rsp)
	movq	%rax, %rbp
	movaps	%xmm0, 480(%rsp)
	movq	$0, 496(%rsp)
	subq	%rsi, %rbp
	movq	%rbp, %rdx
	sarq	$2, %rdx
	je	.L3192
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L3193
	movq	%rbp, %rdi
.LEHB274:
	call	_Znwm@PLT
.LEHE274:
	movq	%rax, %rcx
	movq	32(%rbx), %rax
	movq	24(%rbx), %rsi
	movq	%rax, %rbx
	subq	%rsi, %rbx
.L2852:
	movq	%rcx, %xmm0
	addq	%rcx, %rbp
	punpcklqdq	%xmm0, %xmm0
	movq	%rbp, 496(%rsp)
	movaps	%xmm0, 480(%rsp)
	cmpq	%rsi, %rax
	je	.L2854
	movq	%rcx, %rdi
	movq	%rbx, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2854:
	movq	32(%r14), %rax
	movq	24(%r14), %rsi
	addq	%rbx, %rcx
	pxor	%xmm0, %xmm0
	movq	%rcx, 488(%rsp)
	movq	%rax, %rbx
	movaps	%xmm0, 192(%rsp)
	movq	$0, 208(%rsp)
	subq	%rsi, %rbx
	movq	%rbx, %rdx
	sarq	$2, %rdx
	je	.L3194
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L3195
	movq	%rbx, %rdi
.LEHB275:
	call	_Znwm@PLT
.LEHE275:
	movq	%rax, %rcx
	movq	32(%r14), %rax
	movq	24(%r14), %rsi
	movq	%rax, %rbp
	subq	%rsi, %rbp
.L2856:
	movq	%rcx, %xmm0
	addq	%rcx, %rbx
	punpcklqdq	%xmm0, %xmm0
	movq	%rbx, 208(%rsp)
	movaps	%xmm0, 192(%rsp)
	cmpq	%rsi, %rax
	je	.L2858
	movq	%rcx, %rdi
	movq	%rbp, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L2858:
	addq	%rbp, %rcx
	movq	(%rsp), %r8
	movq	32(%rsp), %rdx
	leaq	224(%rsp), %rdi
	movq	%rcx, 200(%rsp)
	movq	16(%rsp), %rcx
	leaq	192(%rsp), %rsi
.LEHB276:
	call	_Z14newTensorShapeSt6vectorIiSaIiEES1_S1_S1_
.LEHE276:
	movdqa	224(%rsp), %xmm7
	movq	240(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 240(%rsp)
	movq	24(%r12), %rdi
	movaps	%xmm0, 224(%rsp)
	movq	%rax, 40(%r12)
	movups	%xmm7, 24(%r12)
	testq	%rdi, %rdi
	je	.L2860
	call	_ZdlPv@PLT
	movq	224(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2860
	call	_ZdlPv@PLT
.L2860:
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2862
	call	_ZdlPv@PLT
.L2862:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2863
	call	_ZdlPv@PLT
.L2863:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2864
	call	_ZdlPv@PLT
.L2864:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2865
	call	_ZdlPv@PLT
.L2865:
	movq	%r12, %rdi
.LEHB277:
	call	_ZN19quantumSparseMatrix11pruneMatrixEv
.LEHE277:
	movq	440(%rsp), %rbx
	leaq	424(%rsp), %rbp
	testq	%rbx, %rbx
	je	.L2869
.L2866:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2866
.L2869:
	movq	392(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2868
	call	_ZdlPv@PLT
.L2868:
	movq	368(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2870
	call	_ZdlPv@PLT
.L2870:
	movq	328(%rsp), %rbx
	leaq	312(%rsp), %rbp
	testq	%rbx, %rbx
	je	.L2874
.L2871:
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	%rbx, %rdi
	movq	16(%rbx), %rbx
	call	_ZdlPv@PLT
	testq	%rbx, %rbx
	jne	.L2871
.L2874:
	movq	280(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2873
	call	_ZdlPv@PLT
.L2873:
	movq	256(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2875
	call	_ZdlPv@PLT
.L2875:
	movq	160(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2876
	call	_ZdlPv@PLT
.L2876:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2877
	call	_ZdlPv@PLT
.L2877:
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2878
	call	_ZdlPv@PLT
.L2878:
	movq	64(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2733
	call	_ZdlPv@PLT
.L2733:
	movq	824(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L3196
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
.L3179:
	.cfi_restore_state
	movq	%rbp, %r15
	xorl	%ecx, %ecx
	jmp	.L2772
.L3181:
	movq	%rbp, %r15
	xorl	%ecx, %ecx
	jmp	.L2789
.L2738:
	leaq	592(%rsp), %rdx
	movq	%rbp, %rdi
.LEHB278:
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	32(%r12), %rsi
	movq	40(%r12), %rax
	cmpq	%rax, %rsi
	jne	.L3197
.L2740:
	leaq	592(%rsp), %rdx
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	jmp	.L2741
.L2734:
	leaq	592(%rsp), %rdx
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
	movq	8(%r12), %rsi
	movq	16(%r12), %rax
	cmpq	%rax, %rsi
	jne	.L3198
.L2736:
	leaq	592(%rsp), %rdx
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEE17_M_realloc_insertIJRKiEEEvN9__gnu_cxx17__normal_iteratorIPiS1_EEDpOT_
.LEHE278:
	jmp	.L2737
.L3169:
	movl	$1, %r13d
	jmp	.L2762
.L3178:
	movl	$1, 24(%rsp)
	jmp	.L2768
.L3184:
	movq	%rbp, %r13
	xorl	%ecx, %ecx
	jmp	.L2810
.L3186:
	movq	%rbp, %r13
	xorl	%ecx, %ecx
	jmp	.L2820
.L3194:
	movq	%rbx, %rbp
	xorl	%ecx, %ecx
	jmp	.L2856
.L3192:
	movq	%rbp, %rbx
	xorl	%ecx, %ecx
	jmp	.L2852
.L3190:
	movq	%rbp, %r13
	xorl	%ecx, %ecx
	jmp	.L2848
.L3188:
	movq	24(%rsp), %r8
	movq	%rbp, %r13
	xorl	%ecx, %ecx
	jmp	.L2844
.L3189:
.LEHB279:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE279:
.L3180:
.LEHB280:
	call	_ZSt17__throw_bad_allocv@PLT
.L3183:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE280:
.L3185:
.LEHB281:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE281:
.L3196:
	call	__stack_chk_fail@PLT
.L3182:
.LEHB282:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE282:
.L3193:
.LEHB283:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE283:
.L3187:
.LEHB284:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE284:
.L3191:
.LEHB285:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE285:
.L3195:
.LEHB286:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE286:
.L2933:
	endbr64
	movq	%rax, %rbx
	jmp	.L2891
.L2940:
	endbr64
	movq	%rax, %rbx
	jmp	.L2897
.L2936:
	endbr64
	movq	%rax, %rbx
	jmp	.L2895
.L2941:
	endbr64
	movq	%rax, %rbx
	jmp	.L2896
.L2939:
	endbr64
	movq	%rax, %rbx
	jmp	.L2898
.L2942:
	endbr64
	movq	%rax, %rbx
	jmp	.L2905
.L2944:
	endbr64
	movq	%rax, %rbx
	jmp	.L2901
.L2937:
	endbr64
	movq	%rax, %rbx
	jmp	.L2893
.L2938:
	endbr64
	movq	%rax, %rbx
	jmp	.L2892
.L2932:
	endbr64
	movq	%rax, %rbx
	jmp	.L2908
.L2934:
	endbr64
	movq	%rax, %rbx
	jmp	.L2889
.L2935:
	endbr64
	movq	%rax, %rbx
	jmp	.L2888
.L2943:
	endbr64
	movq	%rax, %rbx
	jmp	.L2903
.L2945:
	endbr64
	movq	%rax, %rbx
	jmp	.L2899
.L2928:
	endbr64
	movq	%rax, %rbp
	jmp	.L2880
.L2930:
	endbr64
	movq	%rax, %rbp
	jmp	.L2884
.L2927:
	endbr64
	movq	%rax, %rbp
	jmp	.L2881
.L3149:
	endbr64
	jmp	.L3150
.L2929:
	endbr64
	movq	%rax, %rbp
	jmp	.L2885
.L2946:
	endbr64
	movq	%rax, %rbp
	jmp	.L2746
	.section	.gcc_except_table
.LLSDA8730:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8730-.LLSDACSB8730
.LLSDACSB8730:
	.uleb128 .LEHB254-.LFB8730
	.uleb128 .LEHE254-.LEHB254
	.uleb128 .L2946-.LFB8730
	.uleb128 0
	.uleb128 .LEHB255-.LFB8730
	.uleb128 .LEHE255-.LEHB255
	.uleb128 .L3149-.LFB8730
	.uleb128 0
	.uleb128 .LEHB256-.LFB8730
	.uleb128 .LEHE256-.LEHB256
	.uleb128 .L2927-.LFB8730
	.uleb128 0
	.uleb128 .LEHB257-.LFB8730
	.uleb128 .LEHE257-.LEHB257
	.uleb128 .L2928-.LFB8730
	.uleb128 0
	.uleb128 .LEHB258-.LFB8730
	.uleb128 .LEHE258-.LEHB258
	.uleb128 .L3149-.LFB8730
	.uleb128 0
	.uleb128 .LEHB259-.LFB8730
	.uleb128 .LEHE259-.LEHB259
	.uleb128 .L2929-.LFB8730
	.uleb128 0
	.uleb128 .LEHB260-.LFB8730
	.uleb128 .LEHE260-.LEHB260
	.uleb128 .L2930-.LFB8730
	.uleb128 0
	.uleb128 .LEHB261-.LFB8730
	.uleb128 .LEHE261-.LEHB261
	.uleb128 .L3149-.LFB8730
	.uleb128 0
	.uleb128 .LEHB262-.LFB8730
	.uleb128 .LEHE262-.LEHB262
	.uleb128 .L2932-.LFB8730
	.uleb128 0
	.uleb128 .LEHB263-.LFB8730
	.uleb128 .LEHE263-.LEHB263
	.uleb128 .L2933-.LFB8730
	.uleb128 0
	.uleb128 .LEHB264-.LFB8730
	.uleb128 .LEHE264-.LEHB264
	.uleb128 .L2934-.LFB8730
	.uleb128 0
	.uleb128 .LEHB265-.LFB8730
	.uleb128 .LEHE265-.LEHB265
	.uleb128 .L2935-.LFB8730
	.uleb128 0
	.uleb128 .LEHB266-.LFB8730
	.uleb128 .LEHE266-.LEHB266
	.uleb128 .L2936-.LFB8730
	.uleb128 0
	.uleb128 .LEHB267-.LFB8730
	.uleb128 .LEHE267-.LEHB267
	.uleb128 .L2937-.LFB8730
	.uleb128 0
	.uleb128 .LEHB268-.LFB8730
	.uleb128 .LEHE268-.LEHB268
	.uleb128 .L2938-.LFB8730
	.uleb128 0
	.uleb128 .LEHB269-.LFB8730
	.uleb128 .LEHE269-.LEHB269
	.uleb128 .L2939-.LFB8730
	.uleb128 0
	.uleb128 .LEHB270-.LFB8730
	.uleb128 .LEHE270-.LEHB270
	.uleb128 .L2940-.LFB8730
	.uleb128 0
	.uleb128 .LEHB271-.LFB8730
	.uleb128 .LEHE271-.LEHB271
	.uleb128 .L2941-.LFB8730
	.uleb128 0
	.uleb128 .LEHB272-.LFB8730
	.uleb128 .LEHE272-.LEHB272
	.uleb128 .L2939-.LFB8730
	.uleb128 0
	.uleb128 .LEHB273-.LFB8730
	.uleb128 .LEHE273-.LEHB273
	.uleb128 .L2942-.LFB8730
	.uleb128 0
	.uleb128 .LEHB274-.LFB8730
	.uleb128 .LEHE274-.LEHB274
	.uleb128 .L2943-.LFB8730
	.uleb128 0
	.uleb128 .LEHB275-.LFB8730
	.uleb128 .LEHE275-.LEHB275
	.uleb128 .L2944-.LFB8730
	.uleb128 0
	.uleb128 .LEHB276-.LFB8730
	.uleb128 .LEHE276-.LEHB276
	.uleb128 .L2945-.LFB8730
	.uleb128 0
	.uleb128 .LEHB277-.LFB8730
	.uleb128 .LEHE277-.LEHB277
	.uleb128 .L2939-.LFB8730
	.uleb128 0
	.uleb128 .LEHB278-.LFB8730
	.uleb128 .LEHE278-.LEHB278
	.uleb128 .L2946-.LFB8730
	.uleb128 0
	.uleb128 .LEHB279-.LFB8730
	.uleb128 .LEHE279-.LEHB279
	.uleb128 .L2939-.LFB8730
	.uleb128 0
	.uleb128 .LEHB280-.LFB8730
	.uleb128 .LEHE280-.LEHB280
	.uleb128 .L3149-.LFB8730
	.uleb128 0
	.uleb128 .LEHB281-.LFB8730
	.uleb128 .LEHE281-.LEHB281
	.uleb128 .L2933-.LFB8730
	.uleb128 0
	.uleb128 .LEHB282-.LFB8730
	.uleb128 .LEHE282-.LEHB282
	.uleb128 .L3149-.LFB8730
	.uleb128 0
	.uleb128 .LEHB283-.LFB8730
	.uleb128 .LEHE283-.LEHB283
	.uleb128 .L2943-.LFB8730
	.uleb128 0
	.uleb128 .LEHB284-.LFB8730
	.uleb128 .LEHE284-.LEHB284
	.uleb128 .L2936-.LFB8730
	.uleb128 0
	.uleb128 .LEHB285-.LFB8730
	.uleb128 .LEHE285-.LEHB285
	.uleb128 .L2942-.LFB8730
	.uleb128 0
	.uleb128 .LEHB286-.LFB8730
	.uleb128 .LEHE286-.LEHB286
	.uleb128 .L2944-.LFB8730
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
.L2896:
	.cfi_def_cfa_offset 896
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	32(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2897:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2898:
	movq	%r15, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2895:
	movq	56(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2891:
	movq	160(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2908
	call	_ZdlPv@PLT
.L2908:
	movq	128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2909
	call	_ZdlPv@PLT
.L2909:
	movq	%rbx, %rbp
.L2883:
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2910
	call	_ZdlPv@PLT
.L2910:
	movq	64(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2911
	call	_ZdlPv@PLT
.L2911:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
.LEHB287:
	call	_Unwind_Resume@PLT
.LEHE287:
.L2899:
	movq	192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2901
	call	_ZdlPv@PLT
.L2901:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2903
	call	_ZdlPv@PLT
.L2903:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2905
	call	_ZdlPv@PLT
.L2905:
	movq	704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2898
	call	_ZdlPv@PLT
	jmp	.L2898
.L2892:
	movq	(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2893:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2895
	call	_ZdlPv@PLT
	jmp	.L2895
.L3151:
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	leaq	.LC51(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
.LEHB288:
	call	_ZNSt16invalid_argumentC1EPKc@PLT
.LEHE288:
	movq	_ZNSt16invalid_argumentD1Ev@GOTPCREL(%rip), %rdx
	leaq	_ZTISt16invalid_argument(%rip), %rsi
	movq	%r13, %rdi
.LEHB289:
	call	__cxa_throw@PLT
.LEHE289:
.L2926:
	endbr64
.L3150:
	movq	%rax, %rbp
	jmp	.L2883
.L2931:
	endbr64
	movq	%r13, %rdi
	movq	%rax, %rbp
	call	__cxa_free_exception@PLT
	jmp	.L2883
.L2888:
	movq	(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2889:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2891
	call	_ZdlPv@PLT
	jmp	.L2891
.L2884:
	movq	(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2885:
	movq	480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L2883
.L3170:
	call	_ZdlPv@PLT
	jmp	.L2883
.L2880:
	movq	(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L2881:
	movq	592(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L3170
	jmp	.L2883
.L2746:
	movq	720(%rsp), %rsi
	movq	(%rsp), %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	40(%rsp), %rdi
	movq	72(%r12), %rsi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	24(%r12), %rdi
	testq	%rdi, %rdi
	je	.L2747
	call	_ZdlPv@PLT
.L2747:
	movq	(%r12), %rdi
	testq	%rdi, %rdi
	je	.L2748
	call	_ZdlPv@PLT
.L2748:
	movq	%rbp, %rdi
.LEHB290:
	call	_Unwind_Resume@PLT
.LEHE290:
	.cfi_endproc
.LFE8730:
	.section	.gcc_except_table
.LLSDAC8730:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8730-.LLSDACSBC8730
.LLSDACSBC8730:
	.uleb128 .LEHB287-.LCOLDB52
	.uleb128 .LEHE287-.LEHB287
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB288-.LCOLDB52
	.uleb128 .LEHE288-.LEHB288
	.uleb128 .L2931-.LCOLDB52
	.uleb128 0
	.uleb128 .LEHB289-.LCOLDB52
	.uleb128 .LEHE289-.LEHB289
	.uleb128 .L2926-.LCOLDB52
	.uleb128 0
	.uleb128 .LEHB290-.LCOLDB52
	.uleb128 .LEHE290-.LEHB290
	.uleb128 0
	.uleb128 0
.LLSDACSEC8730:
	.section	.text.unlikely
	.text
	.size	_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE, .-_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE
	.section	.text.unlikely
	.size	_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE.cold, .-_Z9tensordot19quantumSparseMatrixS_St6vectorIS0_IiSaIiEESaIS2_EE.cold
.LCOLDE52:
	.text
.LHOTE52:
	.section	.rodata.str1.1
.LC113:
	.string	"test case - "
.LC114:
	.string	" = "
.LC115:
	.string	"1"
.LC116:
	.string	" -- "
.LC117:
	.string	"2"
.LC118:
	.string	"3"
	.section	.rodata.str1.8
	.align 8
.LC119:
	.string	"getting element in diagonal idx = "
	.section	.rodata.str1.1
.LC120:
	.string	" position = "
.LC121:
	.string	"matrix position - "
.LC122:
	.string	"tensor position - "
	.section	.rodata.str1.8
	.align 8
.LC123:
	.string	"reading element from dense version: "
	.section	.rodata.str1.1
.LC124:
	.string	"4"
.LC125:
	.string	" --example1-- "
.LC126:
	.string	" --example2-- "
.LC128:
	.string	"5"
.LC129:
	.string	"30"
.LC130:
	.string	"stoi"
.LC131:
	.string	" ---- dense product ---- "
.LC132:
	.string	" ---- correct answer ---- "
.LC133:
	.string	" -- first -- "
.LC134:
	.string	" -- second -- "
.LC135:
	.string	" -- qp -- "
.LC136:
	.string	"test"
	.section	.text.unlikely
.LCOLDB137:
	.section	.text.startup,"ax",@progbits
.LHOTB137:
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
.LEHB291:
	call	_ZN11denseMatrixC1EiPf
.LEHE291:
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
.LEHB292:
	call	_ZN11denseMatrixC1EiPf
.LEHE292:
	leaq	1232(%rsp), %r14
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1248(%rsp)
	movq	%r14, %rdi
	movq	%r14, 592(%rsp)
	leaq	1200(%rsp), %r15
	movaps	%xmm0, 1232(%rsp)
.LEHB293:
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
.LEHE293:
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
.LEHB294:
	call	_ZN11denseMatrixC1EiPf
.LEHE294:
	leaq	1264(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1280(%rsp)
	movq	%rax, %rdi
	movq	%rax, 600(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1264(%rsp)
.LEHB295:
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
.LEHE295:
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
.LEHB296:
	call	_ZN11denseMatrixC1EiPf
.LEHE296:
	leaq	1296(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1312(%rsp)
	movq	%rax, %rdi
	movq	%rax, 616(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1296(%rsp)
.LEHB297:
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
.LEHE297:
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
.LEHB298:
	call	_ZN11denseMatrixC1EiPf
.LEHE298:
	leaq	1328(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1344(%rsp)
	movq	%rax, %rdi
	movq	%rax, 632(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1328(%rsp)
.LEHB299:
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
.LEHE299:
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
.LEHB300:
	call	_ZN11denseMatrixC1EiPf
.LEHE300:
	leaq	1360(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1376(%rsp)
	movq	%rax, %rdi
	movq	%rax, 640(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1360(%rsp)
.LEHB301:
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
.LEHE301:
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
.LEHB302:
	call	_ZN11denseMatrixC1EiPf
.LEHE302:
	leaq	1392(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1408(%rsp)
	movq	%rax, %rdi
	movq	%rax, 664(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1392(%rsp)
.LEHB303:
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
.LEHE303:
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
.LEHB304:
	call	_ZN11denseMatrixC1EiPf
.LEHE304:
	leaq	1424(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1440(%rsp)
	movq	%rax, %rdi
	movq	%rax, 672(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1424(%rsp)
.LEHB305:
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
.LEHE305:
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
.LEHB306:
	call	_ZN11denseMatrixC1EiPf
.LEHE306:
	leaq	1456(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1472(%rsp)
	movq	%rax, %rdi
	movq	%rax, 680(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1456(%rsp)
.LEHB307:
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
.LEHE307:
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
.LEHB308:
	call	_ZN11denseMatrixC1EiPf
.LEHE308:
	leaq	1488(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1504(%rsp)
	movq	%rax, %rdi
	movq	%rax, 704(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1488(%rsp)
.LEHB309:
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
.LEHE309:
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
.LEHB310:
	call	_ZN11denseMatrixC1EiPf
.LEHE310:
	leaq	1520(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1536(%rsp)
	movq	%rax, %rdi
	movq	%rax, 712(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1520(%rsp)
.LEHB311:
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
.LEHE311:
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
.LEHB312:
	call	_ZN11denseMatrixC1EiPf
.LEHE312:
	leaq	1552(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1568(%rsp)
	movq	%rax, %rdi
	movq	%rax, 736(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1552(%rsp)
.LEHB313:
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
.LEHE313:
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
.LEHB314:
	call	_ZN11denseMatrixC1EiPf
.LEHE314:
	leaq	1584(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1600(%rsp)
	movq	%rax, %rdi
	movq	%rax, 744(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1584(%rsp)
.LEHB315:
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
.LEHE315:
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
.LEHB316:
	call	_ZN11denseMatrixC1EiPf
.LEHE316:
	leaq	1616(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1632(%rsp)
	movq	%rax, %rdi
	movq	%rax, 752(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1616(%rsp)
.LEHB317:
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
.LEHE317:
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
.LEHB318:
	call	_ZN11denseMatrixC1EiPf
.LEHE318:
	leaq	1648(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1664(%rsp)
	movq	%rax, %rdi
	movq	%rax, 776(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1648(%rsp)
.LEHB319:
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
.LEHE319:
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
.LEHB320:
	call	_ZN11denseMatrixC1EiPf
.LEHE320:
	leaq	1680(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1696(%rsp)
	movq	%rax, %rdi
	movq	%rax, 784(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1680(%rsp)
.LEHB321:
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
.LEHE321:
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
.LEHB322:
	call	_ZN11denseMatrixC1EiPf
.LEHE322:
	leaq	1712(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1728(%rsp)
	movq	%rax, %rdi
	movq	%rax, 808(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1712(%rsp)
.LEHB323:
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
.LEHE323:
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
.LEHB324:
	call	_ZN11denseMatrixC1EiPf
.LEHE324:
	leaq	1744(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1760(%rsp)
	movq	%rax, %rdi
	movq	%rax, 816(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1744(%rsp)
.LEHB325:
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
.LEHE325:
	movaps	.LC83(%rip), %xmm4
	movaps	.LC84(%rip), %xmm3
	leaq	7136(%rsp), %r12
	pxor	%xmm0, %xmm0
	movaps	.LC85(%rip), %xmm2
	movaps	.LC86(%rip), %xmm1
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
.LEHB326:
	call	_ZN11denseMatrixC1EiPf
.LEHE326:
	leaq	1776(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1792(%rsp)
	movq	%rax, %rdi
	movq	%rax, 824(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1776(%rsp)
.LEHB327:
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
.LEHE327:
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
.LEHB328:
	call	_ZN11denseMatrixC1EiPf
.LEHE328:
	leaq	1808(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1824(%rsp)
	movq	%rax, %rdi
	movq	%rax, 848(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1808(%rsp)
.LEHB329:
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
.LEHE329:
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
.LEHB330:
	call	_ZN11denseMatrixC1EiPf
.LEHE330:
	leaq	1840(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1856(%rsp)
	movq	%rax, %rdi
	movq	%rax, 856(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1840(%rsp)
.LEHB331:
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
.LEHE331:
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
.LEHB332:
	call	_ZN11denseMatrixC1EiPf
.LEHE332:
	leaq	1872(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1888(%rsp)
	movq	%rax, %rdi
	movq	%rax, 880(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1872(%rsp)
.LEHB333:
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
.LEHE333:
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
.LEHB334:
	call	_ZN11denseMatrixC1EiPf
.LEHE334:
	leaq	1904(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1920(%rsp)
	movq	%rax, %rdi
	movq	%rax, 888(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1904(%rsp)
.LEHB335:
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
.LEHE335:
	movaps	.LC87(%rip), %xmm4
	movaps	.LC89(%rip), %xmm6
	leaq	7936(%rsp), %r12
	pxor	%xmm0, %xmm0
	movaps	.LC90(%rip), %xmm7
	movaps	.LC91(%rip), %xmm5
	movl	$8, %esi
	movq	%r12, %rdi
	movaps	%xmm4, 23776(%rsp)
	movaps	.LC88(%rip), %xmm4
	leaq	23776(%rsp), %rdx
	movaps	%xmm6, 23840(%rsp)
	movaps	.LC93(%rip), %xmm6
	movaps	%xmm4, 23824(%rsp)
	movaps	.LC92(%rip), %xmm4
	movaps	%xmm7, 23888(%rsp)
	movaps	.LC94(%rip), %xmm7
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
.LEHB336:
	call	_ZN11denseMatrixC1EiPf
.LEHE336:
	leaq	1936(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1952(%rsp)
	movq	%rax, %rdi
	movq	%rax, 896(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1936(%rsp)
.LEHB337:
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
.LEHE337:
	movaps	.LC87(%rip), %xmm5
	leaq	8096(%rsp), %r12
	movaps	.LC88(%rip), %xmm1
	pxor	%xmm0, %xmm0
	movaps	.LC89(%rip), %xmm2
	movaps	.LC90(%rip), %xmm3
	leaq	24288(%rsp), %rdx
	movl	$8, %esi
	movaps	.LC91(%rip), %xmm4
	movaps	.LC92(%rip), %xmm6
	movq	%r12, %rdi
	movaps	%xmm5, 24288(%rsp)
	movaps	.LC93(%rip), %xmm7
	movaps	.LC94(%rip), %xmm5
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
.LEHB338:
	call	_ZN11denseMatrixC1EiPf
.LEHE338:
	leaq	1968(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	movq	$0, 1984(%rsp)
	movq	%rax, %rdi
	movq	%rax, 928(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 1968(%rsp)
.LEHB339:
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
.LEHE339:
	movabsq	$4724276010211082240, %rax
	movaps	.LC95(%rip), %xmm1
	movaps	.LC96(%rip), %xmm2
	leaq	13056(%rsp), %rdx
	movq	%rax, 13120(%rsp)
	movaps	.LC97(%rip), %xmm3
	leaq	8176(%rsp), %rax
	movq	%r12, %rsi
	movaps	.LC98(%rip), %xmm0
	movq	%rax, %rdi
	movq	%rax, 48(%rsp)
	movaps	%xmm1, 13056(%rsp)
	movaps	%xmm2, 13072(%rsp)
	movaps	%xmm3, 13088(%rsp)
	movaps	%xmm0, 13104(%rsp)
.LEHB340:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE340:
	leaq	2032(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$8589934598, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB341:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE341:
	leaq	8256(%rsp), %r9
	movaps	.LC95(%rip), %xmm4
	movaps	.LC96(%rip), %xmm6
	leaq	12848(%rsp), %rdx
	movaps	.LC97(%rip), %xmm7
	movq	%r12, %rsi
	movq	%r9, %rdi
	movq	%r9, 280(%rsp)
	movaps	%xmm4, 12848(%rsp)
	movaps	%xmm6, 12864(%rsp)
	movaps	%xmm7, 12880(%rsp)
.LEHB342:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE342:
	leaq	2064(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	48(%rsp), %rsi
	movq	$0, 2080(%rsp)
	movq	%rax, %rdi
	movq	%rax, 952(%rsp)
	movq	%rax, %r12
	movaps	%xmm0, 2064(%rsp)
.LEHB343:
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
.LEHE343:
	movaps	.LC99(%rip), %xmm0
	leaq	8336(%rsp), %rsi
	movabsq	$4726527810025291776, %rdx
	movaps	.LC95(%rip), %xmm5
	movq	%rsi, %rdi
	movq	%rdx, 13200(%rsp)
	movq	%r12, %rsi
	leaq	13136(%rsp), %rdx
	movaps	%xmm0, 13152(%rsp)
	movaps	.LC100(%rip), %xmm0
	movq	%rdi, 296(%rsp)
	movaps	%xmm0, 13168(%rsp)
	movaps	.LC101(%rip), %xmm0
	movaps	%xmm5, 13136(%rsp)
	movaps	%xmm0, 13184(%rsp)
.LEHB344:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE344:
	leaq	2128(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB345:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE345:
	movaps	.LC102(%rip), %xmm0
	leaq	8416(%rsp), %r10
	leaq	14176(%rsp), %rdx
	movq	%r12, %rsi
	movq	%r10, %rdi
	movq	%r10, 312(%rsp)
	movaps	%xmm0, 14176(%rsp)
	movaps	.LC103(%rip), %xmm0
	movaps	%xmm0, 14192(%rsp)
	movaps	.LC104(%rip), %xmm0
	movaps	%xmm0, 14208(%rsp)
	movaps	.LC105(%rip), %xmm0
	movaps	%xmm0, 14224(%rsp)
	movaps	.LC106(%rip), %xmm0
	movaps	%xmm0, 14240(%rsp)
	movaps	.LC107(%rip), %xmm0
	movaps	%xmm0, 14256(%rsp)
.LEHB346:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE346:
	leaq	2160(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	296(%rsp), %rsi
	movq	$0, 2176(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 976(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2160(%rsp)
.LEHB347:
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
.LEHE347:
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
.LEHB348:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE348:
	leaq	2224(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB349:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE349:
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
.LEHB350:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE350:
	leaq	2256(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	328(%rsp), %rsi
	movq	$0, 2272(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1000(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2256(%rsp)
.LEHB351:
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
.LEHE351:
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
.LEHB352:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE352:
	leaq	2320(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB353:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE353:
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
.LEHB354:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE354:
	leaq	2352(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	360(%rsp), %rsi
	movq	$0, 2368(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1040(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2352(%rsp)
.LEHB355:
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
.LEHE355:
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
.LEHB356:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE356:
	leaq	2416(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB357:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE357:
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
.LEHB358:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE358:
	leaq	2448(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	56(%rsp), %rsi
	movq	$0, 2464(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1064(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2448(%rsp)
.LEHB359:
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
.LEHE359:
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
.LEHB360:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE360:
	leaq	2512(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB361:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE361:
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
.LEHB362:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE362:
	leaq	2544(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	80(%rsp), %rsi
	movq	$0, 2560(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1088(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2544(%rsp)
.LEHB363:
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
.LEHE363:
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
.LEHB364:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE364:
	leaq	2608(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB365:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE365:
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
.LEHB366:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE366:
	leaq	2640(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	96(%rsp), %rsi
	movq	$0, 2656(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1104(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2640(%rsp)
.LEHB367:
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
.LEHE367:
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
.LEHB368:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE368:
	leaq	2704(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB369:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE369:
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
.LEHB370:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE370:
	leaq	2736(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	112(%rsp), %rsi
	movq	$0, 2752(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1120(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2736(%rsp)
.LEHB371:
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
.LEHE371:
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
.LEHB372:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE372:
	leaq	2800(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB373:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE373:
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
.LEHB374:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE374:
	leaq	2832(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	128(%rsp), %rsi
	movq	$0, 2848(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1144(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2832(%rsp)
.LEHB375:
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
.LEHE375:
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
.LEHB376:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE376:
	leaq	2896(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB377:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE377:
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
.LEHB378:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE378:
	leaq	2928(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	144(%rsp), %rsi
	movq	$0, 2944(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1152(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 2928(%rsp)
.LEHB379:
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
.LEHE379:
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
.LEHB380:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE380:
	leaq	2992(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB381:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE381:
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
.LEHB382:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE382:
	leaq	3024(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	160(%rsp), %rsi
	movq	$0, 3040(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1168(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3024(%rsp)
.LEHB383:
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
.LEHE383:
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
.LEHB384:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE384:
	leaq	3088(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$8589934598, %rcx
	movq	%r12, %rdi
	movq	%rcx, 28896(%rsp)
.LEHB385:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE385:
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
.LEHB386:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE386:
	leaq	3120(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	176(%rsp), %rsi
	movq	$0, 3136(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 1184(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3120(%rsp)
.LEHB387:
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
.LEHE387:
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
.LEHB388:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE388:
	leaq	3184(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$17179869190, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB389:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE389:
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
.LEHB390:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE390:
	leaq	3216(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	192(%rsp), %rsi
	movq	$0, 3232(%rsp)
	movq	%rax, %rdi
	movq	%rax, 408(%rsp)
	movq	%rax, %r12
	movaps	%xmm0, 3216(%rsp)
.LEHB391:
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
.LEHE391:
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
.LEHB392:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE392:
	leaq	3280(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$8589934598, %rcx
	movq	%r12, %rdi
	movq	%rcx, 28896(%rsp)
.LEHB393:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE393:
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
.LEHB394:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE394:
	leaq	3312(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	208(%rsp), %rsi
	movq	$0, 3328(%rsp)
	movq	%rax, %rdi
	movq	%rax, 440(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 3312(%rsp)
.LEHB395:
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
.LEHE395:
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
.LEHB396:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE396:
	leaq	3376(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB397:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE397:
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
.LEHB398:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE398:
	leaq	3408(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	216(%rsp), %rsi
	movq	$0, 3424(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 464(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3408(%rsp)
.LEHB399:
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
.LEHE399:
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
.LEHB400:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE400:
	leaq	3472(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB401:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE401:
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
.LEHB402:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE402:
	leaq	3504(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	232(%rsp), %rsi
	movq	$0, 3520(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 480(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3504(%rsp)
.LEHB403:
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
.LEHE403:
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
.LEHB404:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE404:
	leaq	3568(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB405:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE405:
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
.LEHB406:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE406:
	leaq	3600(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	248(%rsp), %rsi
	movq	$0, 3616(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 504(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3600(%rsp)
.LEHB407:
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
.LEHE407:
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
.LEHB408:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE408:
	leaq	3664(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB409:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE409:
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
.LEHB410:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE410:
	leaq	3696(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	264(%rsp), %rsi
	movq	$0, 3712(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 520(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3696(%rsp)
.LEHB411:
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
.LEHE411:
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
.LEHB412:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE412:
	leaq	3760(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB413:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE413:
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
.LEHB414:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE414:
	leaq	3792(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	288(%rsp), %rsi
	movq	$0, 3808(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 544(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3792(%rsp)
.LEHB415:
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
.LEHE415:
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
.LEHB416:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE416:
	leaq	3856(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB417:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE417:
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
.LEHB418:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE418:
	leaq	3888(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	320(%rsp), %rsi
	movq	$0, 3904(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 560(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3888(%rsp)
.LEHB419:
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
.LEHE419:
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
.LEHB420:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE420:
	leaq	3952(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB421:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE421:
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
.LEHB422:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE422:
	leaq	3984(%rsp), %rcx
	pxor	%xmm0, %xmm0
	movq	352(%rsp), %rsi
	movq	$0, 4000(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 576(%rsp)
	movq	%rcx, %r12
	movaps	%xmm0, 3984(%rsp)
.LEHB423:
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
.LEHE423:
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
.LEHB424:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE424:
	leaq	4048(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$68719476740, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB425:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE425:
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
.LEHB426:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE426:
	leaq	4080(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	384(%rsp), %rsi
	movq	$0, 4096(%rsp)
	movq	%rax, %rdi
	movq	%rax, 608(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 4080(%rsp)
.LEHB427:
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
.LEHE427:
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
.LEHB428:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE428:
	leaq	4144(%rsp), %r12
	movq	%rbp, %rsi
	movl	$2, %edx
	movabsq	$34359738370, %rax
	movq	%r12, %rdi
	movq	%rax, 28896(%rsp)
.LEHB429:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE429:
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
.LEHB430:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE430:
	leaq	4176(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	72(%rsp), %rsi
	movq	$0, 4192(%rsp)
	movq	%rax, %rdi
	movq	%rax, 648(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 4176(%rsp)
.LEHB431:
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
.LEHE431:
	movss	.LC108(%rip), %xmm0
	leaq	11856(%rsp), %rax
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movaps	%xmm0, 12992(%rsp)
	movaps	.LC109(%rip), %xmm0
	movq	%rax, %rdi
	movq	%rax, %r12
	movq	%rax, 400(%rsp)
	movaps	%xmm0, 13008(%rsp)
	movaps	.LC110(%rip), %xmm0
	movaps	%xmm0, 13024(%rsp)
	movaps	.LC111(%rip), %xmm0
	movaps	%xmm0, 13040(%rsp)
.LEHB432:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE432:
	movabsq	$8589934594, %rax
	leaq	4240(%rsp), %rbp
	movl	$2, %edx
	movq	%rax, 12816(%rsp)
	leaq	12816(%rsp), %rax
	movq	%rbp, %rdi
	movq	%rax, %rsi
	movq	%rax, 40(%rsp)
.LEHB433:
	call	_ZNSt6vectorIiSaIiEEC2ESt16initializer_listIiERKS0_.constprop.0
.LEHE433:
	leaq	11936(%rsp), %rax
	movaps	.LC112(%rip), %xmm0
	movq	%rbp, %rsi
	leaq	12768(%rsp), %rdx
	movq	%rax, %rdi
	movq	%rax, 496(%rsp)
	movq	%rax, %rbp
	movaps	%xmm0, 12768(%rsp)
.LEHB434:
	call	_ZN11denseMatrixC1EPSt6vectorIiSaIiEEPf
.LEHE434:
	leaq	4272(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	%r12, %rsi
	movq	$0, 4288(%rsp)
	movq	%rax, %rdi
	movq	%rax, 696(%rsp)
	movq	%rax, %r14
	movaps	%xmm0, 4272(%rsp)
.LEHB435:
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%rbp, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EE9push_backERKS0_
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EE9push_backERKS2_
	cmpl	$1, %ebx
	je	.L4409
	movq	8(%r13), %rbp
	leaq	.LC115(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L4410
	leaq	.LC117(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L4411
	leaq	.LC118(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L4412
	leaq	.LC124(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L4413
	leaq	.LC128(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L4414
	leaq	.LC136(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L3202
	movq	16(%r13), %rsi
	leaq	12784(%rsp), %rdi
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.isra.0
.LEHE435:
	movq	12784(%rsp), %rdx
	movq	strtol@GOTPCREL(%rip), %rdi
	movl	$10, %r8d
	xorl	%ecx, %ecx
	leaq	.LC130(%rip), %rsi
.LEHB436:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	movl	$12, %edx
	leaq	.LC113(%rip), %rsi
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
.LEHE436:
	movq	1200(%rsp), %rax
	leaq	12544(%rsp), %r12
	movq	%r12, %rdi
	movq	(%rax,%rbx), %rsi
.LEHB437:
	call	_ZN11denseMatrixC1ERKS_
.LEHE437:
	leaq	12016(%rsp), %r14
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%r14, %rdi
	movq	%r14, 32(%rsp)
.LEHB438:
	call	_Z12denseProduct11denseMatrixS_
.LEHE438:
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	leaq	_ZSt4cout(%rip), %rdi
.LEHB439:
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movl	$25, %edx
	leaq	.LC131(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	%r13, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN11denseMatrix5printEv
	movl	$25, %edx
	leaq	.LC131(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE439:
	leaq	12096(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movq	%rax, %rdi
	movq	%rax, 24(%rsp)
.LEHB440:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE440:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3289
	call	_ZdlPv@PLT
.L3289:
	movl	$26, %edx
	leaq	.LC132(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB441:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$26, %edx
	leaq	.LC132(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	1200(%rsp), %rax
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %r13
	movq	%r13, %rsi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE441:
	leaq	12208(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%rax, %rdi
	movq	%rax, 16(%rsp)
.LEHB442:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE442:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3290
	call	_ZdlPv@PLT
.L3290:
	movl	$13, %edx
	leaq	.LC133(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB443:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$13, %edx
	leaq	.LC133(%rip), %rsi
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
.LEHE443:
	leaq	12320(%rsp), %r14
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%r14, %rdi
.LEHB444:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE444:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3291
	call	_ZdlPv@PLT
.L3291:
	movl	$14, %edx
	leaq	.LC134(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB445:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$14, %edx
	leaq	.LC134(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE445:
	movq	16(%rsp), %rsi
	movq	%r12, %rdi
.LEHB446:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE446:
	leaq	12432(%rsp), %r13
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%r13, %rdi
.LEHB447:
	call	_Z7product19quantumSparseMatrixS_
.LEHE447:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movl	$10, %edx
	leaq	.LC135(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB448:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$10, %edx
	leaq	.LC135(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE448:
	movq	24(%rsp), %rsi
	movq	%r12, %rdi
.LEHB449:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE449:
	movq	40(%rsp), %rdi
	movq	%rbp, %rdx
	movq	%r12, %rsi
.LEHB450:
	call	_Z11checkResultB5cxx1119quantumSparseMatrixS_
.LEHE450:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movl	$3, %edx
	leaq	.LC114(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB451:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	12824(%rsp), %rdx
	movq	12816(%rsp), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	%rax, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE451:
.L4408:
	movq	12816(%rsp), %rdi
	leaq	12832(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3292
	call	_ZdlPv@PLT
.L3292:
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
	je	.L3202
.L4400:
	call	_ZdlPv@PLT
.L3202:
	movq	696(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	496(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4240(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3294
	call	_ZdlPv@PLT
.L3294:
	movq	400(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4208(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3295
	call	_ZdlPv@PLT
.L3295:
	movq	648(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	456(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4144(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3296
	call	_ZdlPv@PLT
.L3296:
	movq	72(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4112(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3297
	call	_ZdlPv@PLT
.L3297:
	movq	608(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	424(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4048(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3298
	call	_ZdlPv@PLT
.L3298:
	movq	384(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	4016(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3299
	call	_ZdlPv@PLT
.L3299:
	movq	576(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	368(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3952(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3300
	call	_ZdlPv@PLT
.L3300:
	movq	352(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3920(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3301
	call	_ZdlPv@PLT
.L3301:
	movq	560(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	336(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3856(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3302
	call	_ZdlPv@PLT
.L3302:
	movq	320(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3824(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3303
	call	_ZdlPv@PLT
.L3303:
	movq	544(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	304(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3760(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3304
	call	_ZdlPv@PLT
.L3304:
	movq	288(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3728(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3305
	call	_ZdlPv@PLT
.L3305:
	movq	520(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	272(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3664(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3306
	call	_ZdlPv@PLT
.L3306:
	movq	264(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3632(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3307
	call	_ZdlPv@PLT
.L3307:
	movq	504(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	256(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3568(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3308
	call	_ZdlPv@PLT
.L3308:
	movq	248(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3536(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3309
	call	_ZdlPv@PLT
.L3309:
	movq	480(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	240(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3472(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3310
	call	_ZdlPv@PLT
.L3310:
	movq	232(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3440(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3311
	call	_ZdlPv@PLT
.L3311:
	movq	464(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	224(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3376(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3312
	call	_ZdlPv@PLT
.L3312:
	movq	216(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3344(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3313
	call	_ZdlPv@PLT
.L3313:
	movq	440(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	920(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3280(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3314
	call	_ZdlPv@PLT
.L3314:
	movq	208(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3248(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3315
	call	_ZdlPv@PLT
.L3315:
	movq	408(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	200(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3184(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3316
	call	_ZdlPv@PLT
.L3316:
	movq	192(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3152(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3317
	call	_ZdlPv@PLT
.L3317:
	movq	1184(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	184(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3088(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3318
	call	_ZdlPv@PLT
.L3318:
	movq	176(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	3056(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3319
	call	_ZdlPv@PLT
.L3319:
	movq	1168(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	168(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2992(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3320
	call	_ZdlPv@PLT
.L3320:
	movq	160(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2960(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3321
	call	_ZdlPv@PLT
.L3321:
	movq	1152(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	152(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2896(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3322
	call	_ZdlPv@PLT
.L3322:
	movq	144(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2864(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3323
	call	_ZdlPv@PLT
.L3323:
	movq	1144(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	136(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2800(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3324
	call	_ZdlPv@PLT
.L3324:
	movq	128(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2768(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3325
	call	_ZdlPv@PLT
.L3325:
	movq	1120(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	120(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2704(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3326
	call	_ZdlPv@PLT
.L3326:
	movq	112(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2672(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3327
	call	_ZdlPv@PLT
.L3327:
	movq	1104(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	104(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2608(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3328
	call	_ZdlPv@PLT
.L3328:
	movq	96(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2576(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3329
	call	_ZdlPv@PLT
.L3329:
	movq	1088(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	88(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2512(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3330
	call	_ZdlPv@PLT
.L3330:
	movq	80(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2480(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3331
	call	_ZdlPv@PLT
.L3331:
	movq	1064(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	64(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2416(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3332
	call	_ZdlPv@PLT
.L3332:
	movq	56(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2384(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3333
	call	_ZdlPv@PLT
.L3333:
	movq	1040(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	376(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3334
	call	_ZdlPv@PLT
.L3334:
	movq	360(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2288(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3335
	call	_ZdlPv@PLT
.L3335:
	movq	1000(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	344(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2224(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3336
	call	_ZdlPv@PLT
.L3336:
	movq	328(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2192(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3337
	call	_ZdlPv@PLT
.L3337:
	movq	976(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	312(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2128(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3338
	call	_ZdlPv@PLT
.L3338:
	movq	296(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3339
	call	_ZdlPv@PLT
.L3339:
	movq	952(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	280(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2032(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3340
	call	_ZdlPv@PLT
.L3340:
	movq	48(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	movq	2000(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3341
	call	_ZdlPv@PLT
.L3341:
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
	jne	.L4415
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
.L4410:
	.cfi_restore_state
	movq	392(%rsp), %r14
	movq	%r14, %rdi
.LEHB452:
	call	_ZN11denseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
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
.LEHE452:
	leaq	12656(%rsp), %rbp
	movq	%rbx, %rsi
	movq	%rbp, %rdi
.LEHB453:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE453:
	leaq	12432(%rsp), %r13
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movq	%r13, %rdi
.LEHB454:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE454:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3244
	call	_ZdlPv@PLT
.L3244:
	movq	%r13, %rdi
.LEHB455:
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
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
.LEHE455:
	leaq	12320(%rsp), %r14
	movq	%rbx, %rsi
	movq	%r14, %rdi
.LEHB456:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE456:
	movq	%r13, %rsi
	movq	%rbp, %rdi
.LEHB457:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE457:
	leaq	12544(%rsp), %r12
	movq	%r14, %rdx
	movq	%rbp, %rsi
	movq	%r12, %rdi
.LEHB458:
	call	_Z7reshape19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE458:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3245
	call	_ZdlPv@PLT
.L3245:
	movq	%r12, %rdi
.LEHB459:
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE459:
.L4406:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12208(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3252
	call	_ZdlPv@PLT
.L3252:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4400
	jmp	.L3202
.L4409:
	movq	$0, 8(%rsp)
	movq	1200(%rsp), %rax
	xorl	%ebx, %ebx
	cmpq	%rax, 1208(%rsp)
	je	.L3202
	.p2align 4,,10
	.p2align 3
.L3201:
	movl	$12, %edx
	leaq	.LC113(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB460:
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
	je	.L4416
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L4417
	movq	%r12, %rdi
	call	_Znwm@PLT
.LEHE460:
	movq	%rax, %rcx
	movq	80(%rbp), %rax
	movq	72(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L3204:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 12672(%rsp)
	movaps	%xmm0, 12656(%rsp)
	cmpq	%rsi, %rax
	je	.L3206
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L3206:
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
	je	.L4418
	movabsq	$2305843009213693951, %rax
	cmpq	%rax, %rdx
	ja	.L4419
	movq	%r12, %rdi
.LEHB461:
	call	_Znwm@PLT
.LEHE461:
	movq	%rax, %rcx
	movq	104(%rbp), %rax
	movq	96(%rbp), %rsi
	movq	%rax, %r13
	subq	%rsi, %r13
.L3208:
	movq	%rcx, %xmm0
	addq	%rcx, %r12
	punpcklqdq	%xmm0, %xmm0
	movq	%r12, 12696(%rsp)
	movups	%xmm0, 12680(%rsp)
	cmpq	%rsi, %rax
	je	.L3210
	movq	%rcx, %rdi
	movq	%r13, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L3210:
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
	je	.L4420
	movabsq	$2305843009213693951, %rcx
	cmpq	%rcx, %rax
	ja	.L4421
	movq	%r12, %rdi
.LEHB462:
	call	_Znwm@PLT
.LEHE462:
	movq	%rax, %rcx
.L3212:
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
	je	.L3218
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L3218:
	addq	%r12, %rcx
	pxor	%xmm2, %xmm2
	movq	%rcx, 12552(%rsp)
	movq	32(%rbp), %r12
	subq	24(%rbp), %r12
	movups	%xmm2, 12568(%rsp)
	movq	$0, 12584(%rsp)
	movq	%r12, %rax
	sarq	$2, %rax
	je	.L4422
	movabsq	$2305843009213693951, %rcx
	cmpq	%rcx, %rax
	ja	.L4423
	movq	%r12, %rdi
.LEHB463:
	call	_Znwm@PLT
.LEHE463:
	movq	%rax, %rcx
.L3220:
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
	je	.L3223
	movq	%rcx, %rdi
	movq	%r12, %rdx
	call	memmove@PLT
	movq	%rax, %rcx
.L3223:
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
.LEHB464:
	call	_Z12denseProduct11denseMatrixS_
.LEHE464:
	movq	12568(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3228
	call	_ZdlPv@PLT
.L3228:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3229
	call	_ZdlPv@PLT
.L3229:
	movq	12680(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3230
	call	_ZdlPv@PLT
.L3230:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3231
	call	_ZdlPv@PLT
.L3231:
	movq	32(%rsp), %r14
	movq	%rbp, %rdi
	movq	%r14, %rsi
.LEHB465:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE465:
	leaq	12096(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movq	%rax, %rdi
	movq	%rax, 24(%rsp)
.LEHB466:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE466:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3232
	call	_ZdlPv@PLT
.L3232:
	movq	1200(%rsp), %rax
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %r13
	movq	%r13, %rsi
.LEHB467:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE467:
	leaq	12208(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%rax, %rdi
	movq	%rax, 16(%rsp)
.LEHB468:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE468:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3233
	call	_ZdlPv@PLT
.L3233:
	movq	1200(%rsp), %rax
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %r13
	addq	$72, %r13
	movq	%r13, %rsi
.LEHB469:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE469:
	leaq	12320(%rsp), %r14
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%r14, %rdi
.LEHB470:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE470:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3234
	call	_ZdlPv@PLT
.L3234:
	movq	%r14, %rsi
	movq	%rbp, %rdi
.LEHB471:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE471:
	movq	16(%rsp), %rsi
	movq	%r12, %rdi
.LEHB472:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE472:
	leaq	12432(%rsp), %r13
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%r13, %rdi
.LEHB473:
	call	_Z7product19quantumSparseMatrixS_
.LEHE473:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r13, %rsi
	movq	%rbp, %rdi
.LEHB474:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE474:
	movq	24(%rsp), %rsi
	movq	%r12, %rdi
.LEHB475:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE475:
	movq	40(%rsp), %rdi
	movq	%rbp, %rdx
	movq	%r12, %rsi
.LEHB476:
	call	_Z11checkResultB5cxx1119quantumSparseMatrixS_
.LEHE476:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movl	$3, %edx
	leaq	.LC114(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB477:
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
	je	.L4424
	cmpb	$0, 56(%r12)
	je	.L3236
	movsbl	67(%r12), %esi
.L3237:
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	movq	12816(%rsp), %rdi
	leaq	12832(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3238
	call	_ZdlPv@PLT
.L3238:
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
	je	.L3239
	call	_ZdlPv@PLT
.L3239:
	movq	12016(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3240
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
	jb	.L3201
	jmp	.L3202
	.p2align 4,,10
	.p2align 3
.L3236:
	movq	%r12, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%r12), %rax
	leaq	_ZNKSt5ctypeIcE8do_widenEc(%rip), %rcx
	movl	$10, %esi
	movq	48(%rax), %rax
	cmpq	%rcx, %rax
	je	.L3237
	movq	%r12, %rdi
	call	*%rax
.LEHE477:
	movsbl	%al, %esi
	jmp	.L3237
	.p2align 4,,10
	.p2align 3
.L3240:
	movq	1208(%rsp), %rax
	subq	1200(%rsp), %rax
	addq	$24, %rbx
	movabsq	$-6148914691236517205, %rdx
	sarq	$3, %rax
	addq	$1, 8(%rsp)
	movq	8(%rsp), %rcx
	imulq	%rdx, %rax
	cmpq	%rcx, %rax
	ja	.L3201
	jmp	.L3202
	.p2align 4,,10
	.p2align 3
.L4418:
	movq	%r12, %r13
	xorl	%ecx, %ecx
	jmp	.L3208
	.p2align 4,,10
	.p2align 3
.L4416:
	movq	%r12, %r13
	xorl	%ecx, %ecx
	jmp	.L3204
	.p2align 4,,10
	.p2align 3
.L4420:
	xorl	%ecx, %ecx
	jmp	.L3212
	.p2align 4,,10
	.p2align 3
.L4422:
	xorl	%ecx, %ecx
	jmp	.L3220
.L4412:
	leaq	12432(%rsp), %r13
	movq	40(%rsp), %rsi
	movl	$3, %edx
	movabsq	$12884901891, %rax
	movq	%r13, %rdi
	movq	%rax, 12816(%rsp)
	movl	$2, 12824(%rsp)
.LEHB478:
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
	je	.L3256
	call	_ZdlPv@PLT
	movq	12432(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3256
	call	_ZdlPv@PLT
.L3256:
	movq	48(%rsp), %r14
	movq	%r14, %rdi
	call	_ZN11denseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
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
.LEHE478:
	leaq	12544(%rsp), %r12
	movq	%rbx, %rsi
	movq	%r12, %rdi
.LEHB479:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE479:
	leaq	12656(%rsp), %rbp
	movq	%r12, %rdx
	movq	%r14, %rsi
	movq	%rbp, %rdi
.LEHB480:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE480:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3258
	call	_ZdlPv@PLT
.L3258:
	movq	%rbp, %rdi
.LEHB481:
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movl	$34, %edx
	leaq	.LC119(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movl	$2, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSolsEi@PLT
	movl	$12, %edx
	leaq	.LC120(%rip), %rsi
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
.LEHE481:
	movl	$18, %edx
	leaq	.LC121(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB482:
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
.LEHE482:
	movl	$18, %edx
	leaq	.LC122(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB483:
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
	leaq	.LC123(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE483:
	movq	48(%rsp), %rdi
	movq	%r12, %rsi
.LEHB484:
	call	_ZN11denseMatrix7getItemESt6vectorIiSaIiEE
	leaq	12096(%rsp), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	movq	%xmm0, 12096(%rsp)
	call	_ZStlsIfcSt11char_traitsIcEERSt13basic_ostreamIT0_T1_ES6_RKSt7complexIT_E@PLT
	movq	%rax, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE484:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3259
	call	_ZdlPv@PLT
.L3259:
	movq	12432(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3260
	call	_ZdlPv@PLT
.L3260:
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3261
	call	_ZdlPv@PLT
.L3261:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12208(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4400
	jmp	.L3202
.L4411:
	movq	48(%rsp), %r14
	movq	%r14, %rdi
.LEHB485:
	call	_ZN11denseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
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
.LEHE485:
	leaq	12656(%rsp), %rbp
	movq	%rbx, %rsi
	movq	%rbp, %rdi
.LEHB486:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE486:
	leaq	12432(%rsp), %r13
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movq	%r13, %rdi
.LEHB487:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE487:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3249
	call	_ZdlPv@PLT
.L3249:
	movq	%r13, %rdi
.LEHB488:
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE488:
	leaq	12320(%rsp), %r14
	pxor	%xmm0, %xmm0
	leaq	12208(%rsp), %rsi
	movq	$0, 12224(%rsp)
	movq	%r14, %rdi
	movaps	%xmm0, 12208(%rsp)
.LEHB489:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE489:
	movq	%r13, %rsi
	movq	%rbp, %rdi
.LEHB490:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE490:
	leaq	12544(%rsp), %r12
	movq	%r14, %rdx
	movq	%rbp, %rsi
	movq	%r12, %rdi
.LEHB491:
	call	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE491:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3250
	call	_ZdlPv@PLT
.L3250:
	movq	%r12, %rdi
.LEHB492:
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE492:
	movq	%r14, %rdx
	movq	%r12, %rsi
	movq	%rbp, %rdi
.LEHB493:
	call	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE
.LEHE493:
	movq	%rbp, %rdi
.LEHB494:
	call	_ZN11denseMatrix5printEv
.LEHE494:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3251
	call	_ZdlPv@PLT
.L3251:
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB495:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE495:
	jmp	.L4406
.L4413:
	movl	$14, %edx
	leaq	.LC125(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB496:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	48(%rsp), %rbx
	movq	%rbx, %rdi
	call	_ZN11denseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
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
.LEHE496:
	leaq	12656(%rsp), %rbp
	movq	%r12, %rsi
	movq	%rbp, %rdi
.LEHB497:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE497:
	leaq	12208(%rsp), %rax
	movq	%rbp, %rdx
	movq	%rbx, %rsi
	movq	%rax, %rdi
	movq	%rax, 16(%rsp)
.LEHB498:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE498:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3264
	call	_ZdlPv@PLT
.L3264:
	movabsq	$12884901891, %rax
	movq	40(%rsp), %rsi
	movl	$3, %edx
	movl	$2, 12824(%rsp)
	movq	%rax, 12816(%rsp)
	leaq	12096(%rsp), %rax
	movq	%rax, %rdi
	movq	%rax, 24(%rsp)
.LEHB499:
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
	je	.L3266
	call	_ZdlPv@PLT
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3266
	call	_ZdlPv@PLT
.L3266:
	movq	16(%rsp), %rbx
	movq	%rbx, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE499:
	leaq	12016(%rsp), %rax
	pxor	%xmm0, %xmm0
	leaq	12544(%rsp), %r12
	movq	$0, 12032(%rsp)
	movq	%rax, %rsi
	movq	%r12, %rdi
	movq	%rax, 32(%rsp)
	movaps	%xmm0, 12016(%rsp)
.LEHB500:
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE500:
	movq	%rbx, %rsi
	movq	%rbp, %rdi
.LEHB501:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE501:
	leaq	12320(%rsp), %r14
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movq	%r14, %rdi
.LEHB502:
	call	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE502:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3268
	call	_ZdlPv@PLT
.L3268:
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB503:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE503:
	movq	%r12, %rdx
	movq	%r14, %rsi
	movq	%rbp, %rdi
.LEHB504:
	call	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE
.LEHE504:
	movq	%rbp, %rdi
.LEHB505:
	call	_ZN11denseMatrix5printEv
.LEHE505:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3269
	call	_ZdlPv@PLT
.L3269:
	movl	$14, %edx
	leaq	.LC126(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB506:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	400(%rsp), %rbx
	movq	%rbx, %rdi
	call	_ZN11denseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE506:
	leaq	12432(%rsp), %r13
	movq	%rbp, %rdx
	movq	%rbx, %rsi
	movq	%r13, %rdi
.LEHB507:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE507:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3270
	call	_ZdlPv@PLT
.L3270:
	movdqa	.LC127(%rip), %xmm0
	movq	40(%rsp), %rsi
	movl	$4, %edx
	movq	%r12, %rdi
	movaps	%xmm0, 12816(%rsp)
.LEHB508:
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
	je	.L3272
	call	_ZdlPv@PLT
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3272
	call	_ZdlPv@PLT
.L3272:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	24(%rsp), %rbx
	movq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE508:
	movq	%r13, %rsi
	movq	%r12, %rdi
.LEHB509:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE509:
	movq	%rbx, %rdx
	movq	%r12, %rsi
	movq	%rbp, %rdi
.LEHB510:
	call	_Z9transpose19quantumSparseMatrixSt6vectorIiSaIiEE
.LEHE510:
	movdqa	12656(%rsp), %xmm2
	movq	12672(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 12672(%rsp)
	movq	12320(%rsp), %rdi
	movaps	%xmm0, 12656(%rsp)
	movq	%rax, 12336(%rsp)
	movaps	%xmm2, 12320(%rsp)
	testq	%rdi, %rdi
	je	.L3274
	call	_ZdlPv@PLT
.L3274:
	movdqu	12680(%rsp), %xmm3
	movq	12696(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 12696(%rsp)
	movq	12344(%rsp), %rdi
	movups	%xmm0, 12680(%rsp)
	movq	%rax, 12360(%rsp)
	movups	%xmm3, 12344(%rsp)
	testq	%rdi, %rdi
	je	.L3275
	call	_ZdlPv@PLT
.L3275:
	movl	12704(%rsp), %eax
	movq	12392(%rsp), %r8
	movq	%r14, 8(%rsp)
	leaq	12376(%rsp), %rbx
	movq	%rbp, 24(%rsp)
	movl	%eax, 12368(%rsp)
	movq	%r8, %rbp
.L3277:
	testq	%rbp, %rbp
	je	.L3276
	movq	24(%rbp), %rsi
	movq	%rbx, %rdi
	call	_ZNSt8_Rb_treeIiSt4pairIKi8diagonalESt10_Select1stIS3_ESt4lessIiESaIS3_EE8_M_eraseEPSt13_Rb_tree_nodeIS3_E
	movq	16(%rbp), %r14
	movq	%rbp, %rdi
	call	_ZdlPv@PLT
	movq	%r14, %rbp
	jmp	.L3277
.L3276:
	movq	12728(%rsp), %rdx
	leaq	12384(%rsp), %rax
	movq	$0, 12392(%rsp)
	movq	%rax, 12400(%rsp)
	movq	8(%rsp), %r14
	movq	%rax, 12408(%rsp)
	movq	24(%rsp), %rbp
	movq	$0, 12416(%rsp)
	testq	%rdx, %rdx
	je	.L3278
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
.L3278:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3279
	call	_ZdlPv@PLT
.L3279:
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB511:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$4, %edx
	leaq	.LC116(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE511:
	movq	%r12, %rdx
	movq	%r14, %rsi
	movq	%rbp, %rdi
.LEHB512:
	call	_ZN19quantumSparseMatrix20convertToDenseMatrixESt6vectorIiSaIiEE
.LEHE512:
	movq	%rbp, %rdi
.LEHB513:
	call	_ZN11denseMatrix5printEv
.LEHE513:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3280
	call	_ZdlPv@PLT
.L3280:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	12016(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3281
	call	_ZdlPv@PLT
.L3281:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	4304(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4400
	jmp	.L3202
.L4414:
	leaq	12784(%rsp), %rdi
	leaq	.LC129(%rip), %rsi
.LEHB514:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.isra.0
.LEHE514:
	movq	12784(%rsp), %rdx
	movq	strtol@GOTPCREL(%rip), %rdi
	movl	$10, %r8d
	xorl	%ecx, %ecx
	leaq	.LC130(%rip), %rsi
.LEHB515:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	movl	$12, %edx
	leaq	.LC113(%rip), %rsi
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
.LEHE515:
	movq	1200(%rsp), %rax
	leaq	12544(%rsp), %r12
	movq	%r12, %rdi
	movq	(%rax,%rbx), %rsi
.LEHB516:
	call	_ZN11denseMatrixC1ERKS_
.LEHE516:
	leaq	12016(%rsp), %r14
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%r14, %rdi
	movq	%r14, 32(%rsp)
.LEHB517:
	call	_Z12denseProduct11denseMatrixS_
.LEHE517:
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	leaq	_ZSt4cout(%rip), %rdi
.LEHB518:
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movl	$25, %edx
	leaq	.LC131(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %r13
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	%r13, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN11denseMatrix5printEv
	movl	$25, %edx
	leaq	.LC131(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE518:
	leaq	12096(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movq	%rax, %rdi
	movq	%rax, 24(%rsp)
.LEHB519:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE519:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3284
	call	_ZdlPv@PLT
.L3284:
	movl	$26, %edx
	leaq	.LC132(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB520:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$26, %edx
	leaq	.LC132(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	1200(%rsp), %rax
	movq	%rbp, %rdi
	movq	(%rax,%rbx), %r13
	movq	%r13, %rsi
	call	_ZNSt6vectorIiSaIiEEC1ERKS1_
.LEHE520:
	leaq	12208(%rsp), %rax
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%rax, %rdi
	movq	%rax, 16(%rsp)
.LEHB521:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE521:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3285
	call	_ZdlPv@PLT
.L3285:
	movl	$13, %edx
	leaq	.LC133(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB522:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$13, %edx
	leaq	.LC133(%rip), %rsi
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
.LEHE522:
	leaq	12320(%rsp), %r14
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%r14, %rdi
.LEHB523:
	call	_ZN11denseMatrix22convertToQuantumSparseESt6vectorIiSaIiEE
.LEHE523:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3286
	call	_ZdlPv@PLT
.L3286:
	movl	$14, %edx
	leaq	.LC134(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB524:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$14, %edx
	leaq	.LC134(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	leaq	12432(%rsp), %r13
	movq	16(%rsp), %rsi
	movq	%r14, %rdx
	movq	%r13, %rdi
	call	_ZmlRK19quantumSparseMatrixS1_
.LEHE524:
	movl	$10, %edx
	leaq	.LC135(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB525:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrix5printEv
	movl	$10, %edx
	leaq	.LC135(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE525:
	movq	24(%rsp), %rsi
	movq	%r12, %rdi
.LEHB526:
	call	_ZN19quantumSparseMatrixC1ERKS_
.LEHE526:
	movq	40(%rsp), %rdi
	movq	%rbp, %rdx
	movq	%r12, %rsi
.LEHB527:
	call	_Z11checkResultB5cxx1119quantumSparseMatrixS_
.LEHE527:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	movl	$3, %edx
	leaq	.LC114(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB528:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	12824(%rsp), %rdx
	movq	12816(%rsp), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	%rax, %rdi
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@PLT
.LEHE528:
	jmp	.L4408
.L4424:
.LEHB529:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE529:
.L4421:
.LEHB530:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE530:
.L4417:
.LEHB531:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE531:
.L4423:
.LEHB532:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE532:
.L4419:
.LEHB533:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE533:
.L4415:
	call	__stack_chk_fail@PLT
.L3799:
	endbr64
	movq	%rax, %rbx
	leaq	12656(%rsp), %rbp
	jmp	.L3227
.L3655:
	endbr64
	movq	%rax, %rbp
	leaq	1200(%rsp), %r15
	jmp	.L3649
.L3817:
	endbr64
	movq	%rax, %rbx
	jmp	.L3366
.L3654:
	endbr64
	movq	%rax, %rbp
	leaq	1200(%rsp), %r15
	jmp	.L3650
.L3818:
	endbr64
	movq	%rax, %rbx
	jmp	.L3364
.L3859:
	endbr64
	movq	%rax, %rbx
	jmp	.L3428
.L3858:
	endbr64
	movq	%rax, %rbx
	jmp	.L3430
.L3840:
	endbr64
	movq	%rax, %rbx
	jmp	.L3400
.L3839:
	endbr64
	movq	%rax, %rbx
	jmp	.L3402
.L3857:
	endbr64
	movq	%rax, %rbx
	jmp	.L3425
.L3856:
	endbr64
	movq	%rax, %rbx
	jmp	.L3427
.L3855:
	endbr64
	movq	%rax, %rbx
	jmp	.L3422
.L3854:
	endbr64
	movq	%rax, %rbx
	jmp	.L3424
.L3866:
	endbr64
	movq	%rax, %rbx
	jmp	.L3439
.L3863:
	endbr64
	movq	%rax, %rbx
	jmp	.L3431
.L3850:
	endbr64
	movq	%rax, %rbx
	jmp	.L3413
.L3861:
	endbr64
	movq	%rax, %rbx
	jmp	.L3433
.L3865:
	endbr64
	movq	%rax, %rbx
	jmp	.L3440
.L3862:
	endbr64
	movq	%rax, %rbx
	jmp	.L3432
.L3864:
	endbr64
	movq	%rax, %rbx
	jmp	.L3434
.L3860:
	endbr64
	movq	%rax, %rbx
	jmp	.L3436
.L3853:
	endbr64
	movq	%rax, %rbx
	jmp	.L3419
.L3852:
	endbr64
	movq	%rax, %rbx
	jmp	.L3420
.L3851:
	endbr64
	movq	%rax, %rbx
	jmp	.L3421
.L3849:
	endbr64
	movq	%rax, %rbx
	jmp	.L3414
.L3878:
	endbr64
	movq	%rax, %rbx
	jmp	.L3454
.L3877:
	endbr64
	movq	%rax, %rbx
	jmp	.L3455
.L3876:
	endbr64
	movq	%rax, %rbx
	jmp	.L3450
.L3875:
	endbr64
	movq	%rax, %rbx
	jmp	.L3451
.L3874:
	endbr64
	movq	%rax, %rbx
	jmp	.L3452
.L3873:
	endbr64
	movq	%rax, %rbx
	jmp	.L3447
.L3872:
	endbr64
	movq	%rax, %rbx
	jmp	.L3449
.L3871:
	endbr64
	movq	%rax, %rbx
	jmp	.L3444
.L3870:
	endbr64
	movq	%rax, %rbx
	jmp	.L3446
.L3869:
	endbr64
	movq	%rax, %rbx
	jmp	.L3441
.L3868:
	endbr64
	movq	%rax, %rbx
	jmp	.L3443
.L3867:
	endbr64
	movq	%rax, %rbx
	jmp	.L3438
.L3880:
	endbr64
	movq	%rax, %rbx
	jmp	.L3456
.L3879:
	endbr64
	movq	%rax, %rbx
	jmp	.L3453
.L3831:
	endbr64
	movq	%rax, %rbx
	jmp	.L3385
.L3830:
	endbr64
	movq	%rax, %rbx
	jmp	.L3387
.L3767:
	endbr64
	movq	%rax, %rbx
	jmp	.L3504
.L3766:
	endbr64
	movq	%rax, %rbx
	jmp	.L3506
.L3765:
	endbr64
	movq	%rax, %rbx
	jmp	.L3507
.L3764:
	endbr64
	movq	%rax, %rbx
	jmp	.L3509
.L3824:
	endbr64
	movq	%rax, %rbx
	jmp	.L3377
.L3823:
	endbr64
	movq	%rax, %rbx
	jmp	.L3383
.L3822:
	endbr64
	movq	%rax, %rbx
	jmp	.L3371
.L3821:
	endbr64
	movq	%rax, %rbx
	jmp	.L3373
.L3835:
	endbr64
	movq	%rax, %rbx
	jmp	.L3388
.L3833:
	endbr64
	movq	%rax, %rbx
	jmp	.L3392
.L3834:
	endbr64
	movq	%rax, %rbx
	jmp	.L3390
.L3832:
	endbr64
	movq	%rax, %rbx
	jmp	.L3394
.L3763:
	endbr64
	movq	%rax, %rbx
	jmp	.L3510
.L3762:
	endbr64
	movq	%rax, %rbx
	jmp	.L3512
.L3761:
	endbr64
	movq	%rax, %rbx
	jmp	.L3513
.L3760:
	endbr64
	movq	%rax, %rbx
	jmp	.L3515
.L3759:
	endbr64
	movq	%rax, %rbx
	jmp	.L3516
.L3758:
	endbr64
	movq	%rax, %rbx
	jmp	.L3518
.L3757:
	endbr64
	movq	%rax, %rbx
	jmp	.L3519
.L3756:
	endbr64
	movq	%rax, %rbx
	jmp	.L3521
.L3755:
	endbr64
	movq	%rax, %rbx
	jmp	.L3522
.L3754:
	endbr64
	movq	%rax, %rbx
	jmp	.L3524
.L3753:
	endbr64
	movq	%rax, %rbx
	jmp	.L3525
.L3752:
	endbr64
	movq	%rax, %rbx
	jmp	.L3527
.L3751:
	endbr64
	movq	%rax, %rbx
	jmp	.L3528
.L3750:
	endbr64
	movq	%rax, %rbx
	jmp	.L3530
.L3749:
	endbr64
	movq	%rax, %rbx
	jmp	.L3531
.L3748:
	endbr64
	movq	%rax, %rbx
	jmp	.L3533
.L3747:
	endbr64
	movq	%rax, %rbx
	jmp	.L3534
.L3746:
	endbr64
	movq	%rax, %rbx
	jmp	.L3536
.L3745:
	endbr64
	movq	%rax, %rbx
	jmp	.L3537
.L3744:
	endbr64
	movq	%rax, %rbx
	jmp	.L3539
.L3743:
	endbr64
	movq	%rax, %rbx
	jmp	.L3540
.L3742:
	endbr64
	movq	%rax, %rbx
	jmp	.L3542
.L3741:
	endbr64
	movq	%rax, %rbx
	jmp	.L3543
.L3740:
	endbr64
	movq	%rax, %rbx
	jmp	.L3545
.L3739:
	endbr64
	movq	%rax, %rbx
	jmp	.L3546
.L3738:
	endbr64
	movq	%rax, %rbx
	jmp	.L3548
.L3737:
	endbr64
	movq	%rax, %rbx
	jmp	.L3549
.L3736:
	endbr64
	movq	%rax, %rbx
	jmp	.L3551
.L3735:
	endbr64
	movq	%rax, %rbx
	jmp	.L3552
.L3734:
	endbr64
	movq	%rax, %rbx
	jmp	.L3554
.L3733:
	endbr64
	movq	%rax, %rbx
	jmp	.L3555
.L3732:
	endbr64
	movq	%rax, %rbx
	jmp	.L3557
.L3731:
	endbr64
	movq	%rax, %rbx
	jmp	.L3558
.L3730:
	endbr64
	movq	%rax, %rbx
	jmp	.L3560
.L3729:
	endbr64
	movq	%rax, %rbx
	jmp	.L3561
.L3728:
	endbr64
	movq	%rax, %rbx
	jmp	.L3563
.L3727:
	endbr64
	movq	%rax, %rbx
	jmp	.L3564
.L3726:
	endbr64
	movq	%rax, %rbx
	jmp	.L3566
.L3725:
	endbr64
	movq	%rax, %rbx
	jmp	.L3567
.L3724:
	endbr64
	movq	%rax, %rbx
	jmp	.L3569
.L3723:
	endbr64
	movq	%rax, %rbx
	jmp	.L3570
.L3722:
	endbr64
	movq	%rax, %rbx
	jmp	.L3572
.L3721:
	endbr64
	movq	%rax, %rbx
	jmp	.L3573
.L3720:
	endbr64
	movq	%rax, %rbx
	jmp	.L3575
.L3719:
	endbr64
	movq	%rax, %rbx
	jmp	.L3576
.L3718:
	endbr64
	movq	%rax, %rbx
	jmp	.L3578
.L3717:
	endbr64
	movq	%rax, %rbx
	jmp	.L3579
.L3716:
	endbr64
	movq	%rax, %rbx
	jmp	.L3581
.L3838:
	endbr64
	movq	%rax, %rbx
	jmp	.L3417
.L3837:
	endbr64
	movq	%rax, %rbx
	jmp	.L3396
.L3836:
	endbr64
	movq	%rax, %rbx
	jmp	.L3398
.L3829:
	endbr64
	movq	%rax, %rbx
	jmp	.L3378
.L3828:
	endbr64
	movq	%rax, %rbx
	jmp	.L3379
.L3827:
	endbr64
	movq	%rax, %rbx
	jmp	.L3381
.L3826:
	endbr64
	movq	%rax, %rbx
	jmp	.L3374
.L3825:
	endbr64
	movq	%rax, %rbx
	jmp	.L3375
.L3848:
	endbr64
	movq	%rax, %rbx
	jmp	.L3409
.L3844:
	endbr64
	movq	%rax, %rbx
	jmp	.L3403
.L3846:
	endbr64
	movq	%rax, %rbx
	jmp	.L3412
.L3843:
	endbr64
	movq	%rax, %rbx
	jmp	.L3404
.L3842:
	endbr64
	movq	%rax, %rbx
	jmp	.L3406
.L3841:
	endbr64
	movq	%rax, %rbx
	jmp	.L3399
.L3847:
	endbr64
	movq	%rax, %rbx
	jmp	.L3410
.L3845:
	endbr64
	movq	%rax, %rbx
	jmp	.L3407
.L3683:
	endbr64
	movq	%rax, %rbp
	jmp	.L3621
.L3675:
	endbr64
	movq	%rax, %rbp
	jmp	.L3629
.L3674:
	endbr64
	movq	%rax, %rbp
	jmp	.L3630
.L3673:
	endbr64
	movq	%rax, %rbp
	jmp	.L3631
.L3672:
	endbr64
	movq	%rax, %rbp
	jmp	.L3632
.L3814:
	endbr64
	movq	%rax, %rbx
	jmp	.L3362
.L3815:
	endbr64
	movq	%rax, %rbx
	jmp	.L3360
.L3816:
	endbr64
	movq	%rax, %rbx
	jmp	.L3369
.L3819:
	endbr64
	movq	%rax, %rbx
	jmp	.L3363
.L3679:
	endbr64
	movq	%rax, %rbp
	jmp	.L3625
.L3678:
	endbr64
	movq	%rax, %rbp
	jmp	.L3626
.L3677:
	endbr64
	movq	%rax, %rbp
	jmp	.L3627
.L3676:
	endbr64
	movq	%rax, %rbp
	jmp	.L3628
.L3681:
	endbr64
	movq	%rax, %rbp
	jmp	.L3623
.L3680:
	endbr64
	movq	%rax, %rbp
	jmp	.L3624
.L3682:
	endbr64
	movq	%rax, %rbp
	jmp	.L3622
.L3810:
	endbr64
	movq	%rax, %rbx
	jmp	.L3357
.L3811:
	endbr64
	movq	%rax, %rbx
	jmp	.L3356
.L3812:
	endbr64
	movq	%rax, %rbx
	jmp	.L3355
.L3813:
	endbr64
	movq	%rax, %rbx
	jmp	.L3358
.L3802:
	endbr64
	movq	%rax, %rbx
	jmp	.L3343
.L3804:
	endbr64
	movq	%rax, %rbx
	jmp	.L3346
.L3803:
	endbr64
	movq	%rax, %rbx
	jmp	.L3348
.L3805:
	endbr64
	movq	%rax, %rbx
	jmp	.L3351
.L3800:
	endbr64
	movq	%rax, %rbx
	jmp	.L3342
.L3801:
	endbr64
	movq	%rax, %rbx
	jmp	.L3345
.L3882:
	endbr64
	movq	%rax, %rbx
	jmp	.L3225
.L3881:
	endbr64
	movq	%rax, %rbx
	jmp	.L3213
.L3703:
	endbr64
	movq	%rax, %rbx
	jmp	.L3600
.L3702:
	endbr64
	movq	%rax, %rbp
	jmp	.L3602
.L3701:
	endbr64
	movq	%rax, %rbp
	jmp	.L3603
.L3700:
	endbr64
	movq	%rax, %rbp
	jmp	.L3604
.L3699:
	endbr64
	movq	%rax, %rbp
	jmp	.L3605
.L3698:
	endbr64
	movq	%rax, %rbp
	jmp	.L3606
.L3697:
	endbr64
	movq	%rax, %rbp
	jmp	.L3607
.L3696:
	endbr64
	movq	%rax, %rbp
	jmp	.L3608
.L3695:
	endbr64
	movq	%rax, %rbp
	jmp	.L3609
.L3694:
	endbr64
	movq	%rax, %rbp
	jmp	.L3610
.L3693:
	endbr64
	movq	%rax, %rbp
	jmp	.L3611
.L3692:
	endbr64
	movq	%rax, %rbp
	jmp	.L3612
.L3691:
	endbr64
	movq	%rax, %rbp
	jmp	.L3613
.L3690:
	endbr64
	movq	%rax, %rbp
	jmp	.L3614
.L3689:
	endbr64
	movq	%rax, %rbp
	jmp	.L3615
.L3688:
	endbr64
	movq	%rax, %rbp
	jmp	.L3616
.L3687:
	endbr64
	movq	%rax, %rbp
	jmp	.L3617
.L3686:
	endbr64
	movq	%rax, %rbp
	jmp	.L3618
.L3685:
	endbr64
	movq	%rax, %rbp
	jmp	.L3619
.L3684:
	endbr64
	movq	%rax, %rbp
	jmp	.L3620
.L3715:
	endbr64
	movq	%rax, %rbx
	jmp	.L3582
.L3714:
	endbr64
	movq	%rax, %rbx
	jmp	.L3584
.L3713:
	endbr64
	movq	%rax, %rbx
	jmp	.L3585
.L3712:
	endbr64
	movq	%rax, %rbx
	jmp	.L3587
.L3711:
	endbr64
	movq	%rax, %rbx
	jmp	.L3588
.L3710:
	endbr64
	movq	%rax, %rbx
	jmp	.L3590
.L3709:
	endbr64
	movq	%rax, %rbx
	jmp	.L3591
.L3708:
	endbr64
	movq	%rax, %rbx
	jmp	.L3593
.L3707:
	endbr64
	movq	%rax, %rbx
	jmp	.L3594
.L3706:
	endbr64
	movq	%rax, %rbx
	jmp	.L3596
.L3705:
	endbr64
	movq	%rax, %rbx
	jmp	.L3597
.L3704:
	endbr64
	movq	%rax, %rbx
	jmp	.L3599
.L3783:
	endbr64
	movq	%rax, %rbx
	jmp	.L3480
.L3782:
	endbr64
	movq	%rax, %rbx
	jmp	.L3482
.L3781:
	endbr64
	movq	%rax, %rbx
	jmp	.L3483
.L3780:
	endbr64
	movq	%rax, %rbx
	jmp	.L3485
.L3779:
	endbr64
	movq	%rax, %rbx
	jmp	.L3486
.L3778:
	endbr64
	movq	%rax, %rbx
	jmp	.L3488
.L3777:
	endbr64
	movq	%rax, %rbx
	jmp	.L3489
.L3776:
	endbr64
	movq	%rax, %rbx
	jmp	.L3491
.L3775:
	endbr64
	movq	%rax, %rbx
	jmp	.L3492
.L3774:
	endbr64
	movq	%rax, %rbx
	jmp	.L3494
.L3773:
	endbr64
	movq	%rax, %rbx
	jmp	.L3495
.L3772:
	endbr64
	movq	%rax, %rbx
	jmp	.L3497
.L3771:
	endbr64
	movq	%rax, %rbx
	jmp	.L3498
.L3770:
	endbr64
	movq	%rax, %rbx
	jmp	.L3500
.L3769:
	endbr64
	movq	%rax, %rbx
	jmp	.L3501
.L3768:
	endbr64
	movq	%rax, %rbx
	jmp	.L3503
.L3791:
	endbr64
	movq	%rax, %rbx
	jmp	.L3468
.L3790:
	endbr64
	movq	%rax, %rbx
	jmp	.L3470
.L3789:
	endbr64
	movq	%rax, %rbx
	jmp	.L3471
.L3788:
	endbr64
	movq	%rax, %rbx
	jmp	.L3473
.L3787:
	endbr64
	movq	%rax, %rbx
	jmp	.L3474
.L3786:
	endbr64
	movq	%rax, %rbx
	jmp	.L3476
.L3785:
	endbr64
	movq	%rax, %rbx
	jmp	.L3477
.L3784:
	endbr64
	movq	%rax, %rbx
	jmp	.L3479
.L3795:
	endbr64
	movq	%rax, %rbx
	jmp	.L3462
.L3794:
	endbr64
	movq	%rax, %rbx
	jmp	.L3464
.L3793:
	endbr64
	movq	%rax, %rbx
	jmp	.L3465
.L3792:
	endbr64
	movq	%rax, %rbx
	jmp	.L3467
.L3797:
	endbr64
	movq	%rax, %rbx
	jmp	.L3459
.L3796:
	endbr64
	movq	%rax, %rbx
	jmp	.L3461
.L3798:
	endbr64
	movq	%rax, %rbx
	jmp	.L3215
.L3820:
	endbr64
	movq	%rax, %rbx
	jmp	.L3367
.L3671:
	endbr64
	movq	%rax, %rbp
	jmp	.L3633
.L3669:
	endbr64
	movq	%rax, %rbp
	jmp	.L3635
.L3668:
	endbr64
	movq	%rax, %rbp
	jmp	.L3636
.L3670:
	endbr64
	movq	%rax, %rbp
	jmp	.L3634
.L3667:
	endbr64
	movq	%rax, %rbp
	jmp	.L3637
.L3666:
	endbr64
	movq	%rax, %rbp
	jmp	.L3638
.L3665:
	endbr64
	movq	%rax, %rbp
	jmp	.L3639
.L3664:
	endbr64
	movq	%rax, %rbp
	jmp	.L3640
.L3663:
	endbr64
	movq	%rax, %rbp
	jmp	.L3641
.L3662:
	endbr64
	movq	%rax, %rbp
	jmp	.L3642
.L3661:
	endbr64
	movq	%rax, %rbp
	jmp	.L3643
.L3660:
	endbr64
	movq	%rax, %rbp
	jmp	.L3644
.L3659:
	endbr64
	movq	%rax, %rbp
	jmp	.L3645
.L3658:
	endbr64
	movq	%rax, %rbp
	jmp	.L3646
.L3657:
	endbr64
	movq	%rax, %rbp
	jmp	.L3647
.L3656:
	endbr64
	movq	%rax, %rbp
	jmp	.L3648
.L3806:
	endbr64
	movq	%rax, %rbx
	jmp	.L3349
.L3807:
	endbr64
	movq	%rax, %rbx
	jmp	.L3354
.L3808:
	endbr64
	movq	%rax, %rbx
	jmp	.L3353
.L3809:
	endbr64
	movq	%rax, %rbx
	jmp	.L3352
	.section	.gcc_except_table
.LLSDA8759:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8759-.LLSDACSB8759
.LLSDACSB8759:
	.uleb128 .LEHB291-.LFB8759
	.uleb128 .LEHE291-.LEHB291
	.uleb128 .L3654-.LFB8759
	.uleb128 0
	.uleb128 .LEHB292-.LFB8759
	.uleb128 .LEHE292-.LEHB292
	.uleb128 .L3655-.LFB8759
	.uleb128 0
	.uleb128 .LEHB293-.LFB8759
	.uleb128 .LEHE293-.LEHB293
	.uleb128 .L3656-.LFB8759
	.uleb128 0
	.uleb128 .LEHB294-.LFB8759
	.uleb128 .LEHE294-.LEHB294
	.uleb128 .L3657-.LFB8759
	.uleb128 0
	.uleb128 .LEHB295-.LFB8759
	.uleb128 .LEHE295-.LEHB295
	.uleb128 .L3658-.LFB8759
	.uleb128 0
	.uleb128 .LEHB296-.LFB8759
	.uleb128 .LEHE296-.LEHB296
	.uleb128 .L3659-.LFB8759
	.uleb128 0
	.uleb128 .LEHB297-.LFB8759
	.uleb128 .LEHE297-.LEHB297
	.uleb128 .L3660-.LFB8759
	.uleb128 0
	.uleb128 .LEHB298-.LFB8759
	.uleb128 .LEHE298-.LEHB298
	.uleb128 .L3661-.LFB8759
	.uleb128 0
	.uleb128 .LEHB299-.LFB8759
	.uleb128 .LEHE299-.LEHB299
	.uleb128 .L3662-.LFB8759
	.uleb128 0
	.uleb128 .LEHB300-.LFB8759
	.uleb128 .LEHE300-.LEHB300
	.uleb128 .L3663-.LFB8759
	.uleb128 0
	.uleb128 .LEHB301-.LFB8759
	.uleb128 .LEHE301-.LEHB301
	.uleb128 .L3664-.LFB8759
	.uleb128 0
	.uleb128 .LEHB302-.LFB8759
	.uleb128 .LEHE302-.LEHB302
	.uleb128 .L3665-.LFB8759
	.uleb128 0
	.uleb128 .LEHB303-.LFB8759
	.uleb128 .LEHE303-.LEHB303
	.uleb128 .L3666-.LFB8759
	.uleb128 0
	.uleb128 .LEHB304-.LFB8759
	.uleb128 .LEHE304-.LEHB304
	.uleb128 .L3667-.LFB8759
	.uleb128 0
	.uleb128 .LEHB305-.LFB8759
	.uleb128 .LEHE305-.LEHB305
	.uleb128 .L3668-.LFB8759
	.uleb128 0
	.uleb128 .LEHB306-.LFB8759
	.uleb128 .LEHE306-.LEHB306
	.uleb128 .L3669-.LFB8759
	.uleb128 0
	.uleb128 .LEHB307-.LFB8759
	.uleb128 .LEHE307-.LEHB307
	.uleb128 .L3670-.LFB8759
	.uleb128 0
	.uleb128 .LEHB308-.LFB8759
	.uleb128 .LEHE308-.LEHB308
	.uleb128 .L3671-.LFB8759
	.uleb128 0
	.uleb128 .LEHB309-.LFB8759
	.uleb128 .LEHE309-.LEHB309
	.uleb128 .L3672-.LFB8759
	.uleb128 0
	.uleb128 .LEHB310-.LFB8759
	.uleb128 .LEHE310-.LEHB310
	.uleb128 .L3673-.LFB8759
	.uleb128 0
	.uleb128 .LEHB311-.LFB8759
	.uleb128 .LEHE311-.LEHB311
	.uleb128 .L3674-.LFB8759
	.uleb128 0
	.uleb128 .LEHB312-.LFB8759
	.uleb128 .LEHE312-.LEHB312
	.uleb128 .L3675-.LFB8759
	.uleb128 0
	.uleb128 .LEHB313-.LFB8759
	.uleb128 .LEHE313-.LEHB313
	.uleb128 .L3676-.LFB8759
	.uleb128 0
	.uleb128 .LEHB314-.LFB8759
	.uleb128 .LEHE314-.LEHB314
	.uleb128 .L3677-.LFB8759
	.uleb128 0
	.uleb128 .LEHB315-.LFB8759
	.uleb128 .LEHE315-.LEHB315
	.uleb128 .L3678-.LFB8759
	.uleb128 0
	.uleb128 .LEHB316-.LFB8759
	.uleb128 .LEHE316-.LEHB316
	.uleb128 .L3679-.LFB8759
	.uleb128 0
	.uleb128 .LEHB317-.LFB8759
	.uleb128 .LEHE317-.LEHB317
	.uleb128 .L3680-.LFB8759
	.uleb128 0
	.uleb128 .LEHB318-.LFB8759
	.uleb128 .LEHE318-.LEHB318
	.uleb128 .L3681-.LFB8759
	.uleb128 0
	.uleb128 .LEHB319-.LFB8759
	.uleb128 .LEHE319-.LEHB319
	.uleb128 .L3682-.LFB8759
	.uleb128 0
	.uleb128 .LEHB320-.LFB8759
	.uleb128 .LEHE320-.LEHB320
	.uleb128 .L3683-.LFB8759
	.uleb128 0
	.uleb128 .LEHB321-.LFB8759
	.uleb128 .LEHE321-.LEHB321
	.uleb128 .L3684-.LFB8759
	.uleb128 0
	.uleb128 .LEHB322-.LFB8759
	.uleb128 .LEHE322-.LEHB322
	.uleb128 .L3685-.LFB8759
	.uleb128 0
	.uleb128 .LEHB323-.LFB8759
	.uleb128 .LEHE323-.LEHB323
	.uleb128 .L3686-.LFB8759
	.uleb128 0
	.uleb128 .LEHB324-.LFB8759
	.uleb128 .LEHE324-.LEHB324
	.uleb128 .L3687-.LFB8759
	.uleb128 0
	.uleb128 .LEHB325-.LFB8759
	.uleb128 .LEHE325-.LEHB325
	.uleb128 .L3688-.LFB8759
	.uleb128 0
	.uleb128 .LEHB326-.LFB8759
	.uleb128 .LEHE326-.LEHB326
	.uleb128 .L3689-.LFB8759
	.uleb128 0
	.uleb128 .LEHB327-.LFB8759
	.uleb128 .LEHE327-.LEHB327
	.uleb128 .L3690-.LFB8759
	.uleb128 0
	.uleb128 .LEHB328-.LFB8759
	.uleb128 .LEHE328-.LEHB328
	.uleb128 .L3691-.LFB8759
	.uleb128 0
	.uleb128 .LEHB329-.LFB8759
	.uleb128 .LEHE329-.LEHB329
	.uleb128 .L3692-.LFB8759
	.uleb128 0
	.uleb128 .LEHB330-.LFB8759
	.uleb128 .LEHE330-.LEHB330
	.uleb128 .L3693-.LFB8759
	.uleb128 0
	.uleb128 .LEHB331-.LFB8759
	.uleb128 .LEHE331-.LEHB331
	.uleb128 .L3694-.LFB8759
	.uleb128 0
	.uleb128 .LEHB332-.LFB8759
	.uleb128 .LEHE332-.LEHB332
	.uleb128 .L3695-.LFB8759
	.uleb128 0
	.uleb128 .LEHB333-.LFB8759
	.uleb128 .LEHE333-.LEHB333
	.uleb128 .L3696-.LFB8759
	.uleb128 0
	.uleb128 .LEHB334-.LFB8759
	.uleb128 .LEHE334-.LEHB334
	.uleb128 .L3697-.LFB8759
	.uleb128 0
	.uleb128 .LEHB335-.LFB8759
	.uleb128 .LEHE335-.LEHB335
	.uleb128 .L3698-.LFB8759
	.uleb128 0
	.uleb128 .LEHB336-.LFB8759
	.uleb128 .LEHE336-.LEHB336
	.uleb128 .L3699-.LFB8759
	.uleb128 0
	.uleb128 .LEHB337-.LFB8759
	.uleb128 .LEHE337-.LEHB337
	.uleb128 .L3700-.LFB8759
	.uleb128 0
	.uleb128 .LEHB338-.LFB8759
	.uleb128 .LEHE338-.LEHB338
	.uleb128 .L3701-.LFB8759
	.uleb128 0
	.uleb128 .LEHB339-.LFB8759
	.uleb128 .LEHE339-.LEHB339
	.uleb128 .L3702-.LFB8759
	.uleb128 0
	.uleb128 .LEHB340-.LFB8759
	.uleb128 .LEHE340-.LEHB340
	.uleb128 .L3703-.LFB8759
	.uleb128 0
	.uleb128 .LEHB341-.LFB8759
	.uleb128 .LEHE341-.LEHB341
	.uleb128 .L3704-.LFB8759
	.uleb128 0
	.uleb128 .LEHB342-.LFB8759
	.uleb128 .LEHE342-.LEHB342
	.uleb128 .L3705-.LFB8759
	.uleb128 0
	.uleb128 .LEHB343-.LFB8759
	.uleb128 .LEHE343-.LEHB343
	.uleb128 .L3706-.LFB8759
	.uleb128 0
	.uleb128 .LEHB344-.LFB8759
	.uleb128 .LEHE344-.LEHB344
	.uleb128 .L3707-.LFB8759
	.uleb128 0
	.uleb128 .LEHB345-.LFB8759
	.uleb128 .LEHE345-.LEHB345
	.uleb128 .L3708-.LFB8759
	.uleb128 0
	.uleb128 .LEHB346-.LFB8759
	.uleb128 .LEHE346-.LEHB346
	.uleb128 .L3709-.LFB8759
	.uleb128 0
	.uleb128 .LEHB347-.LFB8759
	.uleb128 .LEHE347-.LEHB347
	.uleb128 .L3710-.LFB8759
	.uleb128 0
	.uleb128 .LEHB348-.LFB8759
	.uleb128 .LEHE348-.LEHB348
	.uleb128 .L3711-.LFB8759
	.uleb128 0
	.uleb128 .LEHB349-.LFB8759
	.uleb128 .LEHE349-.LEHB349
	.uleb128 .L3712-.LFB8759
	.uleb128 0
	.uleb128 .LEHB350-.LFB8759
	.uleb128 .LEHE350-.LEHB350
	.uleb128 .L3713-.LFB8759
	.uleb128 0
	.uleb128 .LEHB351-.LFB8759
	.uleb128 .LEHE351-.LEHB351
	.uleb128 .L3714-.LFB8759
	.uleb128 0
	.uleb128 .LEHB352-.LFB8759
	.uleb128 .LEHE352-.LEHB352
	.uleb128 .L3715-.LFB8759
	.uleb128 0
	.uleb128 .LEHB353-.LFB8759
	.uleb128 .LEHE353-.LEHB353
	.uleb128 .L3716-.LFB8759
	.uleb128 0
	.uleb128 .LEHB354-.LFB8759
	.uleb128 .LEHE354-.LEHB354
	.uleb128 .L3717-.LFB8759
	.uleb128 0
	.uleb128 .LEHB355-.LFB8759
	.uleb128 .LEHE355-.LEHB355
	.uleb128 .L3718-.LFB8759
	.uleb128 0
	.uleb128 .LEHB356-.LFB8759
	.uleb128 .LEHE356-.LEHB356
	.uleb128 .L3719-.LFB8759
	.uleb128 0
	.uleb128 .LEHB357-.LFB8759
	.uleb128 .LEHE357-.LEHB357
	.uleb128 .L3720-.LFB8759
	.uleb128 0
	.uleb128 .LEHB358-.LFB8759
	.uleb128 .LEHE358-.LEHB358
	.uleb128 .L3721-.LFB8759
	.uleb128 0
	.uleb128 .LEHB359-.LFB8759
	.uleb128 .LEHE359-.LEHB359
	.uleb128 .L3722-.LFB8759
	.uleb128 0
	.uleb128 .LEHB360-.LFB8759
	.uleb128 .LEHE360-.LEHB360
	.uleb128 .L3723-.LFB8759
	.uleb128 0
	.uleb128 .LEHB361-.LFB8759
	.uleb128 .LEHE361-.LEHB361
	.uleb128 .L3724-.LFB8759
	.uleb128 0
	.uleb128 .LEHB362-.LFB8759
	.uleb128 .LEHE362-.LEHB362
	.uleb128 .L3725-.LFB8759
	.uleb128 0
	.uleb128 .LEHB363-.LFB8759
	.uleb128 .LEHE363-.LEHB363
	.uleb128 .L3726-.LFB8759
	.uleb128 0
	.uleb128 .LEHB364-.LFB8759
	.uleb128 .LEHE364-.LEHB364
	.uleb128 .L3727-.LFB8759
	.uleb128 0
	.uleb128 .LEHB365-.LFB8759
	.uleb128 .LEHE365-.LEHB365
	.uleb128 .L3728-.LFB8759
	.uleb128 0
	.uleb128 .LEHB366-.LFB8759
	.uleb128 .LEHE366-.LEHB366
	.uleb128 .L3729-.LFB8759
	.uleb128 0
	.uleb128 .LEHB367-.LFB8759
	.uleb128 .LEHE367-.LEHB367
	.uleb128 .L3730-.LFB8759
	.uleb128 0
	.uleb128 .LEHB368-.LFB8759
	.uleb128 .LEHE368-.LEHB368
	.uleb128 .L3731-.LFB8759
	.uleb128 0
	.uleb128 .LEHB369-.LFB8759
	.uleb128 .LEHE369-.LEHB369
	.uleb128 .L3732-.LFB8759
	.uleb128 0
	.uleb128 .LEHB370-.LFB8759
	.uleb128 .LEHE370-.LEHB370
	.uleb128 .L3733-.LFB8759
	.uleb128 0
	.uleb128 .LEHB371-.LFB8759
	.uleb128 .LEHE371-.LEHB371
	.uleb128 .L3734-.LFB8759
	.uleb128 0
	.uleb128 .LEHB372-.LFB8759
	.uleb128 .LEHE372-.LEHB372
	.uleb128 .L3735-.LFB8759
	.uleb128 0
	.uleb128 .LEHB373-.LFB8759
	.uleb128 .LEHE373-.LEHB373
	.uleb128 .L3736-.LFB8759
	.uleb128 0
	.uleb128 .LEHB374-.LFB8759
	.uleb128 .LEHE374-.LEHB374
	.uleb128 .L3737-.LFB8759
	.uleb128 0
	.uleb128 .LEHB375-.LFB8759
	.uleb128 .LEHE375-.LEHB375
	.uleb128 .L3738-.LFB8759
	.uleb128 0
	.uleb128 .LEHB376-.LFB8759
	.uleb128 .LEHE376-.LEHB376
	.uleb128 .L3739-.LFB8759
	.uleb128 0
	.uleb128 .LEHB377-.LFB8759
	.uleb128 .LEHE377-.LEHB377
	.uleb128 .L3740-.LFB8759
	.uleb128 0
	.uleb128 .LEHB378-.LFB8759
	.uleb128 .LEHE378-.LEHB378
	.uleb128 .L3741-.LFB8759
	.uleb128 0
	.uleb128 .LEHB379-.LFB8759
	.uleb128 .LEHE379-.LEHB379
	.uleb128 .L3742-.LFB8759
	.uleb128 0
	.uleb128 .LEHB380-.LFB8759
	.uleb128 .LEHE380-.LEHB380
	.uleb128 .L3743-.LFB8759
	.uleb128 0
	.uleb128 .LEHB381-.LFB8759
	.uleb128 .LEHE381-.LEHB381
	.uleb128 .L3744-.LFB8759
	.uleb128 0
	.uleb128 .LEHB382-.LFB8759
	.uleb128 .LEHE382-.LEHB382
	.uleb128 .L3745-.LFB8759
	.uleb128 0
	.uleb128 .LEHB383-.LFB8759
	.uleb128 .LEHE383-.LEHB383
	.uleb128 .L3746-.LFB8759
	.uleb128 0
	.uleb128 .LEHB384-.LFB8759
	.uleb128 .LEHE384-.LEHB384
	.uleb128 .L3747-.LFB8759
	.uleb128 0
	.uleb128 .LEHB385-.LFB8759
	.uleb128 .LEHE385-.LEHB385
	.uleb128 .L3748-.LFB8759
	.uleb128 0
	.uleb128 .LEHB386-.LFB8759
	.uleb128 .LEHE386-.LEHB386
	.uleb128 .L3749-.LFB8759
	.uleb128 0
	.uleb128 .LEHB387-.LFB8759
	.uleb128 .LEHE387-.LEHB387
	.uleb128 .L3750-.LFB8759
	.uleb128 0
	.uleb128 .LEHB388-.LFB8759
	.uleb128 .LEHE388-.LEHB388
	.uleb128 .L3751-.LFB8759
	.uleb128 0
	.uleb128 .LEHB389-.LFB8759
	.uleb128 .LEHE389-.LEHB389
	.uleb128 .L3752-.LFB8759
	.uleb128 0
	.uleb128 .LEHB390-.LFB8759
	.uleb128 .LEHE390-.LEHB390
	.uleb128 .L3753-.LFB8759
	.uleb128 0
	.uleb128 .LEHB391-.LFB8759
	.uleb128 .LEHE391-.LEHB391
	.uleb128 .L3754-.LFB8759
	.uleb128 0
	.uleb128 .LEHB392-.LFB8759
	.uleb128 .LEHE392-.LEHB392
	.uleb128 .L3755-.LFB8759
	.uleb128 0
	.uleb128 .LEHB393-.LFB8759
	.uleb128 .LEHE393-.LEHB393
	.uleb128 .L3756-.LFB8759
	.uleb128 0
	.uleb128 .LEHB394-.LFB8759
	.uleb128 .LEHE394-.LEHB394
	.uleb128 .L3757-.LFB8759
	.uleb128 0
	.uleb128 .LEHB395-.LFB8759
	.uleb128 .LEHE395-.LEHB395
	.uleb128 .L3758-.LFB8759
	.uleb128 0
	.uleb128 .LEHB396-.LFB8759
	.uleb128 .LEHE396-.LEHB396
	.uleb128 .L3759-.LFB8759
	.uleb128 0
	.uleb128 .LEHB397-.LFB8759
	.uleb128 .LEHE397-.LEHB397
	.uleb128 .L3760-.LFB8759
	.uleb128 0
	.uleb128 .LEHB398-.LFB8759
	.uleb128 .LEHE398-.LEHB398
	.uleb128 .L3761-.LFB8759
	.uleb128 0
	.uleb128 .LEHB399-.LFB8759
	.uleb128 .LEHE399-.LEHB399
	.uleb128 .L3762-.LFB8759
	.uleb128 0
	.uleb128 .LEHB400-.LFB8759
	.uleb128 .LEHE400-.LEHB400
	.uleb128 .L3763-.LFB8759
	.uleb128 0
	.uleb128 .LEHB401-.LFB8759
	.uleb128 .LEHE401-.LEHB401
	.uleb128 .L3764-.LFB8759
	.uleb128 0
	.uleb128 .LEHB402-.LFB8759
	.uleb128 .LEHE402-.LEHB402
	.uleb128 .L3765-.LFB8759
	.uleb128 0
	.uleb128 .LEHB403-.LFB8759
	.uleb128 .LEHE403-.LEHB403
	.uleb128 .L3766-.LFB8759
	.uleb128 0
	.uleb128 .LEHB404-.LFB8759
	.uleb128 .LEHE404-.LEHB404
	.uleb128 .L3767-.LFB8759
	.uleb128 0
	.uleb128 .LEHB405-.LFB8759
	.uleb128 .LEHE405-.LEHB405
	.uleb128 .L3768-.LFB8759
	.uleb128 0
	.uleb128 .LEHB406-.LFB8759
	.uleb128 .LEHE406-.LEHB406
	.uleb128 .L3769-.LFB8759
	.uleb128 0
	.uleb128 .LEHB407-.LFB8759
	.uleb128 .LEHE407-.LEHB407
	.uleb128 .L3770-.LFB8759
	.uleb128 0
	.uleb128 .LEHB408-.LFB8759
	.uleb128 .LEHE408-.LEHB408
	.uleb128 .L3771-.LFB8759
	.uleb128 0
	.uleb128 .LEHB409-.LFB8759
	.uleb128 .LEHE409-.LEHB409
	.uleb128 .L3772-.LFB8759
	.uleb128 0
	.uleb128 .LEHB410-.LFB8759
	.uleb128 .LEHE410-.LEHB410
	.uleb128 .L3773-.LFB8759
	.uleb128 0
	.uleb128 .LEHB411-.LFB8759
	.uleb128 .LEHE411-.LEHB411
	.uleb128 .L3774-.LFB8759
	.uleb128 0
	.uleb128 .LEHB412-.LFB8759
	.uleb128 .LEHE412-.LEHB412
	.uleb128 .L3775-.LFB8759
	.uleb128 0
	.uleb128 .LEHB413-.LFB8759
	.uleb128 .LEHE413-.LEHB413
	.uleb128 .L3776-.LFB8759
	.uleb128 0
	.uleb128 .LEHB414-.LFB8759
	.uleb128 .LEHE414-.LEHB414
	.uleb128 .L3777-.LFB8759
	.uleb128 0
	.uleb128 .LEHB415-.LFB8759
	.uleb128 .LEHE415-.LEHB415
	.uleb128 .L3778-.LFB8759
	.uleb128 0
	.uleb128 .LEHB416-.LFB8759
	.uleb128 .LEHE416-.LEHB416
	.uleb128 .L3779-.LFB8759
	.uleb128 0
	.uleb128 .LEHB417-.LFB8759
	.uleb128 .LEHE417-.LEHB417
	.uleb128 .L3780-.LFB8759
	.uleb128 0
	.uleb128 .LEHB418-.LFB8759
	.uleb128 .LEHE418-.LEHB418
	.uleb128 .L3781-.LFB8759
	.uleb128 0
	.uleb128 .LEHB419-.LFB8759
	.uleb128 .LEHE419-.LEHB419
	.uleb128 .L3782-.LFB8759
	.uleb128 0
	.uleb128 .LEHB420-.LFB8759
	.uleb128 .LEHE420-.LEHB420
	.uleb128 .L3783-.LFB8759
	.uleb128 0
	.uleb128 .LEHB421-.LFB8759
	.uleb128 .LEHE421-.LEHB421
	.uleb128 .L3784-.LFB8759
	.uleb128 0
	.uleb128 .LEHB422-.LFB8759
	.uleb128 .LEHE422-.LEHB422
	.uleb128 .L3785-.LFB8759
	.uleb128 0
	.uleb128 .LEHB423-.LFB8759
	.uleb128 .LEHE423-.LEHB423
	.uleb128 .L3786-.LFB8759
	.uleb128 0
	.uleb128 .LEHB424-.LFB8759
	.uleb128 .LEHE424-.LEHB424
	.uleb128 .L3787-.LFB8759
	.uleb128 0
	.uleb128 .LEHB425-.LFB8759
	.uleb128 .LEHE425-.LEHB425
	.uleb128 .L3788-.LFB8759
	.uleb128 0
	.uleb128 .LEHB426-.LFB8759
	.uleb128 .LEHE426-.LEHB426
	.uleb128 .L3789-.LFB8759
	.uleb128 0
	.uleb128 .LEHB427-.LFB8759
	.uleb128 .LEHE427-.LEHB427
	.uleb128 .L3790-.LFB8759
	.uleb128 0
	.uleb128 .LEHB428-.LFB8759
	.uleb128 .LEHE428-.LEHB428
	.uleb128 .L3791-.LFB8759
	.uleb128 0
	.uleb128 .LEHB429-.LFB8759
	.uleb128 .LEHE429-.LEHB429
	.uleb128 .L3792-.LFB8759
	.uleb128 0
	.uleb128 .LEHB430-.LFB8759
	.uleb128 .LEHE430-.LEHB430
	.uleb128 .L3793-.LFB8759
	.uleb128 0
	.uleb128 .LEHB431-.LFB8759
	.uleb128 .LEHE431-.LEHB431
	.uleb128 .L3794-.LFB8759
	.uleb128 0
	.uleb128 .LEHB432-.LFB8759
	.uleb128 .LEHE432-.LEHB432
	.uleb128 .L3795-.LFB8759
	.uleb128 0
	.uleb128 .LEHB433-.LFB8759
	.uleb128 .LEHE433-.LEHB433
	.uleb128 .L3796-.LFB8759
	.uleb128 0
	.uleb128 .LEHB434-.LFB8759
	.uleb128 .LEHE434-.LEHB434
	.uleb128 .L3797-.LFB8759
	.uleb128 0
	.uleb128 .LEHB435-.LFB8759
	.uleb128 .LEHE435-.LEHB435
	.uleb128 .L3798-.LFB8759
	.uleb128 0
	.uleb128 .LEHB436-.LFB8759
	.uleb128 .LEHE436-.LEHB436
	.uleb128 .L3865-.LFB8759
	.uleb128 0
	.uleb128 .LEHB437-.LFB8759
	.uleb128 .LEHE437-.LEHB437
	.uleb128 .L3866-.LFB8759
	.uleb128 0
	.uleb128 .LEHB438-.LFB8759
	.uleb128 .LEHE438-.LEHB438
	.uleb128 .L3867-.LFB8759
	.uleb128 0
	.uleb128 .LEHB439-.LFB8759
	.uleb128 .LEHE439-.LEHB439
	.uleb128 .L3868-.LFB8759
	.uleb128 0
	.uleb128 .LEHB440-.LFB8759
	.uleb128 .LEHE440-.LEHB440
	.uleb128 .L3869-.LFB8759
	.uleb128 0
	.uleb128 .LEHB441-.LFB8759
	.uleb128 .LEHE441-.LEHB441
	.uleb128 .L3870-.LFB8759
	.uleb128 0
	.uleb128 .LEHB442-.LFB8759
	.uleb128 .LEHE442-.LEHB442
	.uleb128 .L3871-.LFB8759
	.uleb128 0
	.uleb128 .LEHB443-.LFB8759
	.uleb128 .LEHE443-.LEHB443
	.uleb128 .L3872-.LFB8759
	.uleb128 0
	.uleb128 .LEHB444-.LFB8759
	.uleb128 .LEHE444-.LEHB444
	.uleb128 .L3873-.LFB8759
	.uleb128 0
	.uleb128 .LEHB445-.LFB8759
	.uleb128 .LEHE445-.LEHB445
	.uleb128 .L3874-.LFB8759
	.uleb128 0
	.uleb128 .LEHB446-.LFB8759
	.uleb128 .LEHE446-.LEHB446
	.uleb128 .L3875-.LFB8759
	.uleb128 0
	.uleb128 .LEHB447-.LFB8759
	.uleb128 .LEHE447-.LEHB447
	.uleb128 .L3876-.LFB8759
	.uleb128 0
	.uleb128 .LEHB448-.LFB8759
	.uleb128 .LEHE448-.LEHB448
	.uleb128 .L3877-.LFB8759
	.uleb128 0
	.uleb128 .LEHB449-.LFB8759
	.uleb128 .LEHE449-.LEHB449
	.uleb128 .L3878-.LFB8759
	.uleb128 0
	.uleb128 .LEHB450-.LFB8759
	.uleb128 .LEHE450-.LEHB450
	.uleb128 .L3879-.LFB8759
	.uleb128 0
	.uleb128 .LEHB451-.LFB8759
	.uleb128 .LEHE451-.LEHB451
	.uleb128 .L3880-.LFB8759
	.uleb128 0
	.uleb128 .LEHB452-.LFB8759
	.uleb128 .LEHE452-.LEHB452
	.uleb128 .L3798-.LFB8759
	.uleb128 0
	.uleb128 .LEHB453-.LFB8759
	.uleb128 .LEHE453-.LEHB453
	.uleb128 .L3814-.LFB8759
	.uleb128 0
	.uleb128 .LEHB454-.LFB8759
	.uleb128 .LEHE454-.LEHB454
	.uleb128 .L3815-.LFB8759
	.uleb128 0
	.uleb128 .LEHB455-.LFB8759
	.uleb128 .LEHE455-.LEHB455
	.uleb128 .L3816-.LFB8759
	.uleb128 0
	.uleb128 .LEHB456-.LFB8759
	.uleb128 .LEHE456-.LEHB456
	.uleb128 .L3817-.LFB8759
	.uleb128 0
	.uleb128 .LEHB457-.LFB8759
	.uleb128 .LEHE457-.LEHB457
	.uleb128 .L3818-.LFB8759
	.uleb128 0
	.uleb128 .LEHB458-.LFB8759
	.uleb128 .LEHE458-.LEHB458
	.uleb128 .L3819-.LFB8759
	.uleb128 0
	.uleb128 .LEHB459-.LFB8759
	.uleb128 .LEHE459-.LEHB459
	.uleb128 .L3820-.LFB8759
	.uleb128 0
	.uleb128 .LEHB460-.LFB8759
	.uleb128 .LEHE460-.LEHB460
	.uleb128 .L3798-.LFB8759
	.uleb128 0
	.uleb128 .LEHB461-.LFB8759
	.uleb128 .LEHE461-.LEHB461
	.uleb128 .L3881-.LFB8759
	.uleb128 0
	.uleb128 .LEHB462-.LFB8759
	.uleb128 .LEHE462-.LEHB462
	.uleb128 .L3799-.LFB8759
	.uleb128 0
	.uleb128 .LEHB463-.LFB8759
	.uleb128 .LEHE463-.LEHB463
	.uleb128 .L3882-.LFB8759
	.uleb128 0
	.uleb128 .LEHB464-.LFB8759
	.uleb128 .LEHE464-.LEHB464
	.uleb128 .L3800-.LFB8759
	.uleb128 0
	.uleb128 .LEHB465-.LFB8759
	.uleb128 .LEHE465-.LEHB465
	.uleb128 .L3801-.LFB8759
	.uleb128 0
	.uleb128 .LEHB466-.LFB8759
	.uleb128 .LEHE466-.LEHB466
	.uleb128 .L3802-.LFB8759
	.uleb128 0
	.uleb128 .LEHB467-.LFB8759
	.uleb128 .LEHE467-.LEHB467
	.uleb128 .L3803-.LFB8759
	.uleb128 0
	.uleb128 .LEHB468-.LFB8759
	.uleb128 .LEHE468-.LEHB468
	.uleb128 .L3804-.LFB8759
	.uleb128 0
	.uleb128 .LEHB469-.LFB8759
	.uleb128 .LEHE469-.LEHB469
	.uleb128 .L3805-.LFB8759
	.uleb128 0
	.uleb128 .LEHB470-.LFB8759
	.uleb128 .LEHE470-.LEHB470
	.uleb128 .L3806-.LFB8759
	.uleb128 0
	.uleb128 .LEHB471-.LFB8759
	.uleb128 .LEHE471-.LEHB471
	.uleb128 .L3807-.LFB8759
	.uleb128 0
	.uleb128 .LEHB472-.LFB8759
	.uleb128 .LEHE472-.LEHB472
	.uleb128 .L3808-.LFB8759
	.uleb128 0
	.uleb128 .LEHB473-.LFB8759
	.uleb128 .LEHE473-.LEHB473
	.uleb128 .L3809-.LFB8759
	.uleb128 0
	.uleb128 .LEHB474-.LFB8759
	.uleb128 .LEHE474-.LEHB474
	.uleb128 .L3810-.LFB8759
	.uleb128 0
	.uleb128 .LEHB475-.LFB8759
	.uleb128 .LEHE475-.LEHB475
	.uleb128 .L3811-.LFB8759
	.uleb128 0
	.uleb128 .LEHB476-.LFB8759
	.uleb128 .LEHE476-.LEHB476
	.uleb128 .L3812-.LFB8759
	.uleb128 0
	.uleb128 .LEHB477-.LFB8759
	.uleb128 .LEHE477-.LEHB477
	.uleb128 .L3813-.LFB8759
	.uleb128 0
	.uleb128 .LEHB478-.LFB8759
	.uleb128 .LEHE478-.LEHB478
	.uleb128 .L3798-.LFB8759
	.uleb128 0
	.uleb128 .LEHB479-.LFB8759
	.uleb128 .LEHE479-.LEHB479
	.uleb128 .L3830-.LFB8759
	.uleb128 0
	.uleb128 .LEHB480-.LFB8759
	.uleb128 .LEHE480-.LEHB480
	.uleb128 .L3831-.LFB8759
	.uleb128 0
	.uleb128 .LEHB481-.LFB8759
	.uleb128 .LEHE481-.LEHB481
	.uleb128 .L3832-.LFB8759
	.uleb128 0
	.uleb128 .LEHB482-.LFB8759
	.uleb128 .LEHE482-.LEHB482
	.uleb128 .L3833-.LFB8759
	.uleb128 0
	.uleb128 .LEHB483-.LFB8759
	.uleb128 .LEHE483-.LEHB483
	.uleb128 .L3834-.LFB8759
	.uleb128 0
	.uleb128 .LEHB484-.LFB8759
	.uleb128 .LEHE484-.LEHB484
	.uleb128 .L3835-.LFB8759
	.uleb128 0
	.uleb128 .LEHB485-.LFB8759
	.uleb128 .LEHE485-.LEHB485
	.uleb128 .L3798-.LFB8759
	.uleb128 0
	.uleb128 .LEHB486-.LFB8759
	.uleb128 .LEHE486-.LEHB486
	.uleb128 .L3821-.LFB8759
	.uleb128 0
	.uleb128 .LEHB487-.LFB8759
	.uleb128 .LEHE487-.LEHB487
	.uleb128 .L3822-.LFB8759
	.uleb128 0
	.uleb128 .LEHB488-.LFB8759
	.uleb128 .LEHE488-.LEHB488
	.uleb128 .L3823-.LFB8759
	.uleb128 0
	.uleb128 .LEHB489-.LFB8759
	.uleb128 .LEHE489-.LEHB489
	.uleb128 .L3824-.LFB8759
	.uleb128 0
	.uleb128 .LEHB490-.LFB8759
	.uleb128 .LEHE490-.LEHB490
	.uleb128 .L3825-.LFB8759
	.uleb128 0
	.uleb128 .LEHB491-.LFB8759
	.uleb128 .LEHE491-.LEHB491
	.uleb128 .L3826-.LFB8759
	.uleb128 0
	.uleb128 .LEHB492-.LFB8759
	.uleb128 .LEHE492-.LEHB492
	.uleb128 .L3827-.LFB8759
	.uleb128 0
	.uleb128 .LEHB493-.LFB8759
	.uleb128 .LEHE493-.LEHB493
	.uleb128 .L3828-.LFB8759
	.uleb128 0
	.uleb128 .LEHB494-.LFB8759
	.uleb128 .LEHE494-.LEHB494
	.uleb128 .L3829-.LFB8759
	.uleb128 0
	.uleb128 .LEHB495-.LFB8759
	.uleb128 .LEHE495-.LEHB495
	.uleb128 .L3827-.LFB8759
	.uleb128 0
	.uleb128 .LEHB496-.LFB8759
	.uleb128 .LEHE496-.LEHB496
	.uleb128 .L3798-.LFB8759
	.uleb128 0
	.uleb128 .LEHB497-.LFB8759
	.uleb128 .LEHE497-.LEHB497
	.uleb128 .L3836-.LFB8759
	.uleb128 0
	.uleb128 .LEHB498-.LFB8759
	.uleb128 .LEHE498-.LEHB498
	.uleb128 .L3837-.LFB8759
	.uleb128 0
	.uleb128 .LEHB499-.LFB8759
	.uleb128 .LEHE499-.LEHB499
	.uleb128 .L3838-.LFB8759
	.uleb128 0
	.uleb128 .LEHB500-.LFB8759
	.uleb128 .LEHE500-.LEHB500
	.uleb128 .L3839-.LFB8759
	.uleb128 0
	.uleb128 .LEHB501-.LFB8759
	.uleb128 .LEHE501-.LEHB501
	.uleb128 .L3840-.LFB8759
	.uleb128 0
	.uleb128 .LEHB502-.LFB8759
	.uleb128 .LEHE502-.LEHB502
	.uleb128 .L3841-.LFB8759
	.uleb128 0
	.uleb128 .LEHB503-.LFB8759
	.uleb128 .LEHE503-.LEHB503
	.uleb128 .L3842-.LFB8759
	.uleb128 0
	.uleb128 .LEHB504-.LFB8759
	.uleb128 .LEHE504-.LEHB504
	.uleb128 .L3843-.LFB8759
	.uleb128 0
	.uleb128 .LEHB505-.LFB8759
	.uleb128 .LEHE505-.LEHB505
	.uleb128 .L3844-.LFB8759
	.uleb128 0
	.uleb128 .LEHB506-.LFB8759
	.uleb128 .LEHE506-.LEHB506
	.uleb128 .L3842-.LFB8759
	.uleb128 0
	.uleb128 .LEHB507-.LFB8759
	.uleb128 .LEHE507-.LEHB507
	.uleb128 .L3845-.LFB8759
	.uleb128 0
	.uleb128 .LEHB508-.LFB8759
	.uleb128 .LEHE508-.LEHB508
	.uleb128 .L3846-.LFB8759
	.uleb128 0
	.uleb128 .LEHB509-.LFB8759
	.uleb128 .LEHE509-.LEHB509
	.uleb128 .L3847-.LFB8759
	.uleb128 0
	.uleb128 .LEHB510-.LFB8759
	.uleb128 .LEHE510-.LEHB510
	.uleb128 .L3848-.LFB8759
	.uleb128 0
	.uleb128 .LEHB511-.LFB8759
	.uleb128 .LEHE511-.LEHB511
	.uleb128 .L3846-.LFB8759
	.uleb128 0
	.uleb128 .LEHB512-.LFB8759
	.uleb128 .LEHE512-.LEHB512
	.uleb128 .L3849-.LFB8759
	.uleb128 0
	.uleb128 .LEHB513-.LFB8759
	.uleb128 .LEHE513-.LEHB513
	.uleb128 .L3850-.LFB8759
	.uleb128 0
	.uleb128 .LEHB514-.LFB8759
	.uleb128 .LEHE514-.LEHB514
	.uleb128 .L3798-.LFB8759
	.uleb128 0
	.uleb128 .LEHB515-.LFB8759
	.uleb128 .LEHE515-.LEHB515
	.uleb128 .L3851-.LFB8759
	.uleb128 0
	.uleb128 .LEHB516-.LFB8759
	.uleb128 .LEHE516-.LEHB516
	.uleb128 .L3852-.LFB8759
	.uleb128 0
	.uleb128 .LEHB517-.LFB8759
	.uleb128 .LEHE517-.LEHB517
	.uleb128 .L3853-.LFB8759
	.uleb128 0
	.uleb128 .LEHB518-.LFB8759
	.uleb128 .LEHE518-.LEHB518
	.uleb128 .L3854-.LFB8759
	.uleb128 0
	.uleb128 .LEHB519-.LFB8759
	.uleb128 .LEHE519-.LEHB519
	.uleb128 .L3855-.LFB8759
	.uleb128 0
	.uleb128 .LEHB520-.LFB8759
	.uleb128 .LEHE520-.LEHB520
	.uleb128 .L3856-.LFB8759
	.uleb128 0
	.uleb128 .LEHB521-.LFB8759
	.uleb128 .LEHE521-.LEHB521
	.uleb128 .L3857-.LFB8759
	.uleb128 0
	.uleb128 .LEHB522-.LFB8759
	.uleb128 .LEHE522-.LEHB522
	.uleb128 .L3858-.LFB8759
	.uleb128 0
	.uleb128 .LEHB523-.LFB8759
	.uleb128 .LEHE523-.LEHB523
	.uleb128 .L3859-.LFB8759
	.uleb128 0
	.uleb128 .LEHB524-.LFB8759
	.uleb128 .LEHE524-.LEHB524
	.uleb128 .L3860-.LFB8759
	.uleb128 0
	.uleb128 .LEHB525-.LFB8759
	.uleb128 .LEHE525-.LEHB525
	.uleb128 .L3861-.LFB8759
	.uleb128 0
	.uleb128 .LEHB526-.LFB8759
	.uleb128 .LEHE526-.LEHB526
	.uleb128 .L3862-.LFB8759
	.uleb128 0
	.uleb128 .LEHB527-.LFB8759
	.uleb128 .LEHE527-.LEHB527
	.uleb128 .L3863-.LFB8759
	.uleb128 0
	.uleb128 .LEHB528-.LFB8759
	.uleb128 .LEHE528-.LEHB528
	.uleb128 .L3864-.LFB8759
	.uleb128 0
	.uleb128 .LEHB529-.LFB8759
	.uleb128 .LEHE529-.LEHB529
	.uleb128 .L3813-.LFB8759
	.uleb128 0
	.uleb128 .LEHB530-.LFB8759
	.uleb128 .LEHE530-.LEHB530
	.uleb128 .L3799-.LFB8759
	.uleb128 0
	.uleb128 .LEHB531-.LFB8759
	.uleb128 .LEHE531-.LEHB531
	.uleb128 .L3798-.LFB8759
	.uleb128 0
	.uleb128 .LEHB532-.LFB8759
	.uleb128 .LEHE532-.LEHB532
	.uleb128 .L3882-.LFB8759
	.uleb128 0
	.uleb128 .LEHB533-.LFB8759
	.uleb128 .LEHE533-.LEHB533
	.uleb128 .L3881-.LFB8759
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
.L3225:
	.cfi_def_cfa_offset 35376
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3226
	call	_ZdlPv@PLT
.L3226:
	leaq	12656(%rsp), %rbp
.L3227:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
.L3215:
	movq	696(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	496(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3459:
	movq	4240(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4425
.L3461:
	movq	400(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3462:
	movq	4208(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4426
.L3464:
	movq	648(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	456(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3465:
	movq	4144(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4427
.L3467:
	movq	72(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3468:
	movq	4112(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4428
.L3470:
	movq	608(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	424(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3471:
	movq	4048(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4429
.L3473:
	movq	384(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3474:
	movq	4016(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4430
.L3476:
	movq	576(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	368(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3477:
	movq	3952(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4431
.L3479:
	movq	352(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3480:
	movq	3920(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4432
.L3482:
	movq	560(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	336(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3483:
	movq	3856(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4433
.L3485:
	movq	320(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3486:
	movq	3824(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4434
.L3488:
	movq	544(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	304(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3489:
	movq	3760(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4435
.L3491:
	movq	288(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3492:
	movq	3728(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4436
.L3494:
	movq	520(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	272(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3495:
	movq	3664(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4437
.L3497:
	movq	264(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3498:
	movq	3632(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4438
.L3500:
	movq	504(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	256(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3501:
	movq	3568(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4439
.L3503:
	movq	248(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3504:
	movq	3536(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4440
.L3506:
	movq	480(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	240(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3507:
	movq	3472(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4441
.L3509:
	movq	232(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3510:
	movq	3440(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4442
.L3512:
	movq	464(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	224(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3513:
	movq	3376(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4443
.L3515:
	movq	216(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3516:
	movq	3344(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4444
.L3518:
	movq	440(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	920(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3519:
	movq	3280(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4445
.L3521:
	movq	208(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3522:
	movq	3248(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4446
.L3524:
	movq	408(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	200(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3525:
	movq	3184(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4447
.L3527:
	movq	192(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3528:
	movq	3152(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4448
.L3530:
	movq	1184(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	184(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3531:
	movq	3088(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4449
.L3533:
	movq	176(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3534:
	movq	3056(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4450
.L3536:
	movq	1168(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	168(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3537:
	movq	2992(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4451
.L3539:
	movq	160(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3540:
	movq	2960(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4452
.L3542:
	movq	1152(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	152(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3543:
	movq	2896(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4453
.L3545:
	movq	144(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3546:
	movq	2864(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4454
.L3548:
	movq	1144(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	136(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3549:
	movq	2800(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4455
.L3551:
	movq	128(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3552:
	movq	2768(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4456
.L3554:
	movq	1120(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	120(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3555:
	movq	2704(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4457
.L3557:
	movq	112(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3558:
	movq	2672(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4458
.L3560:
	movq	1104(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	104(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3561:
	movq	2608(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4459
.L3563:
	movq	96(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3564:
	movq	2576(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4460
.L3566:
	movq	1088(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	88(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3567:
	movq	2512(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4461
.L3569:
	movq	80(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3570:
	movq	2480(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4462
.L3572:
	movq	1064(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	64(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3573:
	movq	2416(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4463
.L3575:
	movq	56(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3576:
	movq	2384(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4464
.L3578:
	movq	1040(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	376(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3579:
	movq	2320(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4465
.L3581:
	movq	360(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3582:
	movq	2288(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4466
.L3584:
	movq	1000(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	344(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3585:
	movq	2224(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4467
.L3587:
	movq	328(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3588:
	movq	2192(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4468
.L3590:
	movq	976(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	312(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3591:
	movq	2128(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4469
.L3593:
	movq	296(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3594:
	movq	2096(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4470
.L3596:
	movq	952(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	280(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3597:
	movq	2032(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4471
.L3599:
	movq	48(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3600:
	movq	2000(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3601
	call	_ZdlPv@PLT
.L3601:
	movq	%rbx, %rbp
.L3602:
	movq	928(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1080(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3603:
	movq	1056(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3604:
	movq	896(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1032(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3605:
	movq	1016(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3606:
	movq	888(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	992(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3607:
	movq	968(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3608:
	movq	880(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	944(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3609:
	movq	912(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3610:
	movq	856(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	872(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3611:
	movq	840(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3612:
	movq	848(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	800(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3613:
	movq	768(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3614:
	movq	824(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	728(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3615:
	movq	688(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3616:
	movq	816(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	656(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3617:
	movq	624(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3618:
	movq	808(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	584(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3619:
	movq	568(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3620:
	movq	784(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	552(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3621:
	movq	536(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3622:
	movq	776(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	528(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3623:
	movq	512(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3624:
	movq	752(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	488(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3625:
	movq	472(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3626:
	movq	744(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	448(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3627:
	movq	432(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3628:
	movq	736(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	416(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3629:
	movq	1192(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3630:
	movq	712(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1176(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3631:
	movq	1160(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3632:
	movq	704(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	392(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3633:
	movq	1136(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3634:
	movq	680(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1128(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3635:
	movq	1112(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3636:
	movq	672(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1096(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3637:
	movq	1072(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3638:
	movq	664(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1048(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3639:
	movq	1024(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3640:
	movq	640(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	1008(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3641:
	movq	984(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3642:
	movq	632(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	960(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3643:
	movq	936(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3644:
	movq	616(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	904(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3645:
	movq	864(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3646:
	movq	600(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	832(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3647:
	movq	792(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3648:
	movq	592(%rsp), %rdi
	call	_ZNSt6vectorI11denseMatrixSaIS0_EED1Ev
	movq	760(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3649:
	movq	720(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3650:
	movq	%r15, %rdi
	call	_ZNSt6vectorIS_I11denseMatrixSaIS0_EESaIS2_EED1Ev
	movq	%rbp, %rdi
.LEHB534:
	call	_Unwind_Resume@PLT
.LEHE534:
.L3363:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3364:
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3366
	call	_ZdlPv@PLT
.L3366:
	movq	12208(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4472
.L3369:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3362:
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3215
	call	_ZdlPv@PLT
	jmp	.L3215
.L4472:
	call	_ZdlPv@PLT
	jmp	.L3369
.L4425:
	call	_ZdlPv@PLT
	jmp	.L3461
.L4426:
	call	_ZdlPv@PLT
	jmp	.L3464
.L4427:
	call	_ZdlPv@PLT
	jmp	.L3467
.L4428:
	call	_ZdlPv@PLT
	jmp	.L3470
.L4429:
	call	_ZdlPv@PLT
	jmp	.L3473
.L4430:
	call	_ZdlPv@PLT
	jmp	.L3476
.L4431:
	call	_ZdlPv@PLT
	jmp	.L3479
.L4432:
	call	_ZdlPv@PLT
	jmp	.L3482
.L4433:
	call	_ZdlPv@PLT
	jmp	.L3485
.L4434:
	call	_ZdlPv@PLT
	jmp	.L3488
.L4435:
	call	_ZdlPv@PLT
	jmp	.L3491
.L4436:
	call	_ZdlPv@PLT
	jmp	.L3494
.L4437:
	call	_ZdlPv@PLT
	jmp	.L3497
.L4438:
	call	_ZdlPv@PLT
	jmp	.L3500
.L4439:
	call	_ZdlPv@PLT
	jmp	.L3503
.L4440:
	call	_ZdlPv@PLT
	jmp	.L3506
.L4441:
	call	_ZdlPv@PLT
	jmp	.L3509
.L4442:
	call	_ZdlPv@PLT
	jmp	.L3512
.L4443:
	call	_ZdlPv@PLT
	jmp	.L3515
.L4444:
	call	_ZdlPv@PLT
	jmp	.L3518
.L4445:
	call	_ZdlPv@PLT
	jmp	.L3521
.L4446:
	call	_ZdlPv@PLT
	jmp	.L3524
.L4447:
	call	_ZdlPv@PLT
	jmp	.L3527
.L4448:
	call	_ZdlPv@PLT
	jmp	.L3530
.L4449:
	call	_ZdlPv@PLT
	jmp	.L3533
.L4450:
	call	_ZdlPv@PLT
	jmp	.L3536
.L4451:
	call	_ZdlPv@PLT
	jmp	.L3539
.L4452:
	call	_ZdlPv@PLT
	jmp	.L3542
.L4453:
	call	_ZdlPv@PLT
	jmp	.L3545
.L4454:
	call	_ZdlPv@PLT
	jmp	.L3548
.L4455:
	call	_ZdlPv@PLT
	jmp	.L3551
.L4456:
	call	_ZdlPv@PLT
	jmp	.L3554
.L4457:
	call	_ZdlPv@PLT
	jmp	.L3557
.L4458:
	call	_ZdlPv@PLT
	jmp	.L3560
.L4459:
	call	_ZdlPv@PLT
	jmp	.L3563
.L4460:
	call	_ZdlPv@PLT
	jmp	.L3566
.L4461:
	call	_ZdlPv@PLT
	jmp	.L3569
.L4462:
	call	_ZdlPv@PLT
	jmp	.L3572
.L4463:
	call	_ZdlPv@PLT
	jmp	.L3575
.L4464:
	call	_ZdlPv@PLT
	jmp	.L3578
.L4465:
	call	_ZdlPv@PLT
	jmp	.L3581
.L4466:
	call	_ZdlPv@PLT
	jmp	.L3584
.L4467:
	call	_ZdlPv@PLT
	jmp	.L3587
.L4468:
	call	_ZdlPv@PLT
	jmp	.L3590
.L4469:
	call	_ZdlPv@PLT
	jmp	.L3593
.L4470:
	call	_ZdlPv@PLT
	jmp	.L3596
.L4471:
	call	_ZdlPv@PLT
	jmp	.L3599
.L3428:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4473
.L3430:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3427:
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3424:
	movq	32(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
.L3421:
	movq	12784(%rsp), %rdi
	leaq	12800(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3215
	call	_ZdlPv@PLT
	jmp	.L3215
.L4473:
	call	_ZdlPv@PLT
	jmp	.L3430
.L3399:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3400:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3402
	call	_ZdlPv@PLT
.L3402:
	movq	12016(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4474
.L3417:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3398:
	movq	4304(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3215
	call	_ZdlPv@PLT
	jmp	.L3215
.L4474:
	call	_ZdlPv@PLT
	jmp	.L3417
.L3425:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3427
	call	_ZdlPv@PLT
	jmp	.L3427
.L3422:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3424
	call	_ZdlPv@PLT
	jmp	.L3424
.L3438:
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
.L3439:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
.L3440:
	movq	12784(%rsp), %rdi
	leaq	12800(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3215
	call	_ZdlPv@PLT
	jmp	.L3215
.L3413:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
.L3414:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4475
.L3412:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3406:
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3402
.L3434:
	movq	12816(%rsp), %rdi
	leaq	12832(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3433
	call	_ZdlPv@PLT
.L3433:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3436:
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3430
.L3431:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3432:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3433
.L4475:
	call	_ZdlPv@PLT
	jmp	.L3412
.L3419:
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
.L3420:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
	jmp	.L3421
.L3453:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3454:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3455:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3452:
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3449:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3446:
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3443:
	movq	32(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	jmp	.L3440
.L3450:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3451:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3452
.L3447:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3449
	call	_ZdlPv@PLT
	jmp	.L3449
.L3444:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3446
	call	_ZdlPv@PLT
	jmp	.L3446
.L3441:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3443
	call	_ZdlPv@PLT
	jmp	.L3443
.L3456:
	movq	12816(%rsp), %rdi
	leaq	12832(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3455
	call	_ZdlPv@PLT
	jmp	.L3455
.L3385:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3387
	call	_ZdlPv@PLT
.L3387:
	movq	12208(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3215
	call	_ZdlPv@PLT
	jmp	.L3215
.L3374:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3375:
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3377
	call	_ZdlPv@PLT
.L3377:
	movq	12208(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L4476
.L3383:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3373:
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3215
	call	_ZdlPv@PLT
	jmp	.L3215
.L4476:
	call	_ZdlPv@PLT
	jmp	.L3383
.L3371:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3373
	call	_ZdlPv@PLT
	jmp	.L3373
.L3388:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3390
	call	_ZdlPv@PLT
.L3390:
	movq	12432(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3392
	call	_ZdlPv@PLT
.L3392:
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3394
	call	_ZdlPv@PLT
.L3394:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3387
.L3396:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3398
	call	_ZdlPv@PLT
	jmp	.L3398
.L3378:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
.L3379:
	movq	12320(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3381
	call	_ZdlPv@PLT
.L3381:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3377
.L3403:
	movq	%rbp, %rdi
	call	_ZN11denseMatrixD1Ev
.L3404:
	movq	12544(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3406
	call	_ZdlPv@PLT
	jmp	.L3406
.L3409:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3410:
	movq	12096(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3412
	call	_ZdlPv@PLT
	jmp	.L3412
.L3407:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3406
	call	_ZdlPv@PLT
	jmp	.L3406
.L3360:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3362
	call	_ZdlPv@PLT
	jmp	.L3362
.L3355:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3356:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3357:
	movq	%r13, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3354:
	movq	%r14, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3351:
	movq	16(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3348:
	movq	24(%rsp), %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3345:
	movq	32(%rsp), %rdi
	call	_ZN11denseMatrixD1Ev
	jmp	.L3215
.L3358:
	movq	12816(%rsp), %rdi
	leaq	12832(%rsp), %rax
	cmpq	%rax, %rdi
	je	.L3357
	call	_ZdlPv@PLT
	jmp	.L3357
.L3343:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3345
	call	_ZdlPv@PLT
	jmp	.L3345
.L3346:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3348
	call	_ZdlPv@PLT
	jmp	.L3348
.L3342:
	movq	%r12, %rdi
	call	_ZN11denseMatrixD1Ev
	jmp	.L3227
.L3213:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3215
	call	_ZdlPv@PLT
	jmp	.L3215
.L3367:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3366
.L3349:
	movq	12656(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L3351
	call	_ZdlPv@PLT
	jmp	.L3351
.L3352:
	movq	%r12, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
.L3353:
	movq	%rbp, %rdi
	call	_ZN19quantumSparseMatrixD1Ev
	jmp	.L3354
	.cfi_endproc
.LFE8759:
	.section	.gcc_except_table
.LLSDAC8759:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8759-.LLSDACSBC8759
.LLSDACSBC8759:
	.uleb128 .LEHB534-.LCOLDB137
	.uleb128 .LEHE534-.LEHB534
	.uleb128 0
	.uleb128 0
.LLSDACSEC8759:
	.section	.text.unlikely
	.section	.text.startup
	.size	main, .-main
	.section	.text.unlikely
	.size	main.cold, .-main.cold
.LCOLDE137:
	.section	.text.startup
.LHOTE137:
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
.LC35:
	.long	1
	.long	1
	.long	1
	.long	1
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC41:
	.long	2296604913
	.long	1056241845
	.section	.rodata.cst16
	.align 16
.LC83:
	.long	1073741824
	.long	1077936128
	.long	0
	.long	0
	.align 16
.LC84:
	.long	0
	.long	0
	.long	1077936128
	.long	1073741824
	.align 16
.LC85:
	.long	0
	.long	0
	.long	1073741824
	.long	1077936128
	.align 16
.LC86:
	.long	1077936128
	.long	1073741824
	.long	0
	.long	0
	.align 16
.LC87:
	.long	1091567616
	.long	1092616192
	.long	0
	.long	0
	.align 16
.LC88:
	.long	0
	.long	0
	.long	1093664768
	.long	1094713344
	.align 16
.LC89:
	.long	0
	.long	0
	.long	1095761920
	.long	1096810496
	.align 16
.LC90:
	.long	1097859072
	.long	1098907648
	.long	0
	.long	0
	.align 16
.LC91:
	.long	1099431936
	.long	1099956224
	.long	0
	.long	0
	.align 16
.LC92:
	.long	0
	.long	0
	.long	1100480512
	.long	1101004800
	.align 16
.LC93:
	.long	0
	.long	0
	.long	1101529088
	.long	1102053376
	.align 16
.LC94:
	.long	1102577664
	.long	1103101952
	.long	0
	.long	0
	.align 16
.LC95:
	.long	1065353216
	.long	1073741824
	.long	1077936128
	.long	1082130432
	.align 16
.LC96:
	.long	1084227584
	.long	1086324736
	.long	1088421888
	.long	1090519040
	.align 16
.LC97:
	.long	1091567616
	.long	1092616192
	.long	1093664768
	.long	1094713344
	.align 16
.LC98:
	.long	1095761920
	.long	1096810496
	.long	1097859072
	.long	1098907648
	.align 16
.LC99:
	.long	1086324736
	.long	1088421888
	.long	1090519040
	.long	1091567616
	.align 16
.LC100:
	.long	1092616192
	.long	1093664768
	.long	1094713344
	.long	1095761920
	.align 16
.LC101:
	.long	1096810496
	.long	1097859072
	.long	1098907648
	.long	1099431936
	.align 16
.LC102:
	.long	1101004800
	.long	1101529088
	.long	1102053376
	.long	1102577664
	.align 16
.LC103:
	.long	1103101952
	.long	1103626240
	.long	1104150528
	.long	1104674816
	.align 16
.LC104:
	.long	1105199104
	.long	1105723392
	.long	1106247680
	.long	1106771968
	.align 16
.LC105:
	.long	1107296256
	.long	1107558400
	.long	1107820544
	.long	1108082688
	.align 16
.LC106:
	.long	1108344832
	.long	1108606976
	.long	1108869120
	.long	1109131264
	.align 16
.LC107:
	.long	1109393408
	.long	1109655552
	.long	1109917696
	.long	1110179840
	.align 16
.LC108:
	.long	1060439287
	.long	0
	.long	0
	.long	0
	.align 16
.LC109:
	.long	0
	.long	1060439287
	.long	0
	.long	0
	.align 16
.LC110:
	.long	0
	.long	0
	.long	0
	.long	1060439287
	.align 16
.LC111:
	.long	0
	.long	0
	.long	1060439287
	.long	0
	.align 16
.LC112:
	.long	1060439287
	.long	0
	.long	0
	.long	3207922935
	.align 16
.LC127:
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
