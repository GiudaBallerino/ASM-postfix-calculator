# Function: itoa.s
# Converts an integer into a string

.section .data
	string: .ascii "00000000000"
	sign: .short 0

.section .text
	.global itoa

.type itoa, @function

itoa:
	# numero da convertire in %eax

	pushl %ebx  # salvo i registri
	pushl %ecx
	pushl %edx
	pushl %esi
	pushl %edi

	movl $0, %ebx  # azzera %ebx
	movl $0, %ecx  # azzera %ecx
	movl $0, %edx  # azzera %edx

	movl $10, %ebx  # 10 in %ebx per divisione

	leal string, %esi

	cmp $0, %eax
	jge divide

negative:
	movb $1, sign  # salvo segno negativo
	negl %eax

divide:
	movl $0, %edx  # azzera %edx
	div %ebx  # dividi %eax per 10

	addb $48, %dl  # ottieni carattere

	movb %dl, (%ecx,%esi,1)  # sposta DL in string
	inc %ecx

	cmp $0, %eax
	jne divide  # mentre diverso da 0

cmp $0, sign
je reverse

movb $'-', (%ecx,%esi,1)  # aggiungi '-'
inc %ecx

reverse:
	movb $0, (%ecx,%esi,1)  # aggiungi carattere di terminazione
	# inc %ecx  # non incremento -> length-1

	movl $0, %ebx  # azzera %ebx

	_loop:
		# %ebx = i
		# %ecx = j = length-1

		movb (%ebx,%esi,1), %al  # salva carattere (0 + %ebx)
		movb -1(%ecx,%esi,1), %ah  # salva carattere (length-1 - %ecx)

		movb %ah, (%ebx,%esi,1)  # scambia caratteri
		movb %al, -1(%ecx,%esi,1)

		inc %ebx
		dec %ecx

		cmp %ecx, %ebx
		jl _loop

_return:
	leal string, %eax  # return in %eax

	popl %edi  # ripristino i registri
	popl %esi
	popl %edx
	popl %ecx
	popl %ebx

ret
