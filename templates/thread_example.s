	.file	"thread_example.c"
# GNU C17 (Ubuntu 12.3.0-1ubuntu1~22.04) version 12.3.0 (x86_64-linux-gnu)
#	compiled by GNU C version 12.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O2 -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"Thread %d: Hello from thread!\n"
	.text
	.p2align 4
	.globl	thread_function
	.type	thread_function, @function
thread_function:
.LFB40:
	.cfi_startproc
	endbr64	
	pushq	%rax	#
	.cfi_def_cfa_offset 16
	popq	%rax	#
	.cfi_def_cfa_offset 8
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC0(%rip), %rsi	#, tmp86
	xorl	%eax, %eax	#
# thread_example.c:6: void *thread_function(void *arg) {
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 16
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	(%rdi), %edx	# MEM[(int *)arg_2(D)], MEM[(int *)arg_2(D)]
	movl	$1, %edi	#,
	call	__printf_chk@PLT	#
# thread_example.c:9:     pthread_exit(NULL);
	xorl	%edi, %edi	#
	call	pthread_exit@PLT	#
	.cfi_endproc
.LFE40:
	.size	thread_function, .-thread_function
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"Failed to create thread"
	.section	.rodata.str1.8
	.align 8
.LC2:
	.string	"Main thread: All threads completed."
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB41:
	.cfi_startproc
	endbr64	
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	leaq	thread_function(%rip), %r14	#, tmp104
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	xorl	%ebx, %ebx	# ivtmp.19
	subq	$88, %rsp	#,
	.cfi_def_cfa_offset 144
# thread_example.c:12: int main() {
	movq	%fs:40, %rax	# MEM[(<address-space-1> long unsigned int *)40B], tmp106
	movq	%rax, 72(%rsp)	# tmp106, D.3788
	xorl	%eax, %eax	# tmp106
	movq	%rsp, %r13	#, ivtmp.24
	leaq	32(%rsp), %r15	#, ivtmp.16
.L7:
# thread_example.c:18:         thread_ids[i] = i;
	movl	%ebx, 0(%r13)	# ivtmp.19, MEM[(int *)_40]
# thread_example.c:19:         int result = pthread_create(&threads[i], NULL, thread_function, &thread_ids[i]);
	leaq	(%r15,%rbx,8), %rdi	#, tmp96
	movq	%r13, %rcx	# ivtmp.24,
	movq	%r14, %rdx	# tmp104,
	xorl	%esi, %esi	#
	movq	%r15, %rbp	# ivtmp.16, ivtmp.16
	call	pthread_create@PLT	#
	movl	%eax, %r12d	# tmp105, <retval>
# thread_example.c:20:         if (result != 0) {
	testl	%eax, %eax	# <retval>
	jne	.L13	#,
# thread_example.c:17:     for (int i = 0; i < 5; i++) {
	addq	$1, %rbx	#, ivtmp.19
	addq	$4, %r13	#, ivtmp.24
	cmpq	$5, %rbx	#, ivtmp.19
	jne	.L7	#,
	leaq	72(%rsp), %rbx	#, _33
	.p2align 4,,10
	.p2align 3
.L8:
# thread_example.c:28:         pthread_join(threads[i], NULL);
	movq	0(%rbp), %rdi	# MEM[(long unsigned int *)_31], MEM[(long unsigned int *)_31]
	xorl	%esi, %esi	#
# thread_example.c:27:     for (int i = 0; i < 5; i++) {
	addq	$8, %rbp	#, ivtmp.16
# thread_example.c:28:         pthread_join(threads[i], NULL);
	call	pthread_join@PLT	#
# thread_example.c:27:     for (int i = 0; i < 5; i++) {
	cmpq	%rbx, %rbp	# _33, ivtmp.16
	jne	.L8	#,
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC2(%rip), %rdi	#, tmp100
	call	puts@PLT	#
.L4:
# thread_example.c:33: }
	movq	72(%rsp), %rax	# D.3788, tmp107
	subq	%fs:40, %rax	# MEM[(<address-space-1> long unsigned int *)40B], tmp107
	jne	.L14	#,
	addq	$88, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movl	%r12d, %eax	# <retval>,
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
.L13:
	.cfi_restore_state
# thread_example.c:21:             perror("Failed to create thread");
	leaq	.LC1(%rip), %rdi	#, tmp98
# thread_example.c:22:             return 1;
	movl	$1, %r12d	#, <retval>
# thread_example.c:21:             perror("Failed to create thread");
	call	perror@PLT	#
# thread_example.c:22:             return 1;
	jmp	.L4	#
.L14:
# thread_example.c:33: }
	call	__stack_chk_fail@PLT	#
	.cfi_endproc
.LFE41:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 12.3.0-1ubuntu1~22.04) 12.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
