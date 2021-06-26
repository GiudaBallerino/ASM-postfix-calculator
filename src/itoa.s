# Function: itoa.s
# Converts an integer into a string

.section .data
	string: .ascii "0000000000000"
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

	leal string, %esi  # puntatore di string in %esi

	cmp $0, %eax  # se >=0 -> salta a divide
	jge divide

negative:
	movb $1, sign  # salva segno negativo
	negl %eax  # cambia segno

divide:
	movl $0, %edx  # azzera %edx
	div %ebx  # dividi %eax per 10

	addb $48, %dl  # ottiene carattere

	movb %dl, (%ecx,%esi,1)  # sposta %dl in string
	inc %ecx

	cmp $0, %eax # se diverso 0 -> salta a divide
	jne divide


cmp $0, sign  # se numero positivo -> salta a reverse
je reverse

movb $'-', (%ecx,%esi,1)  # aggiunge '-' al termina di string
inc %ecx

reverse:
	movb $0, (%ecx,%esi,1)  # aggiungi carattere di terminazione
	# inc %ecx  # NON incremento -> length-1

	movl $0, %ebx  # azzera %ebx
	# %ecx = length di string

	_loop:
		# %ebx = i
		# %ecx = j = length-1

		movb (%ebx,%esi,1), %al  # salva carattere (0 + %ebx)
		movb -1(%ecx,%esi,1), %ah  # salva carattere (length-1 - %ecx)

		movb %ah, (%ebx,%esi,1)  # scambia caratteri
		movb %al, -1(%ecx,%esi,1)

		inc %ebx
		dec %ecx

		cmp %ecx, %ebx  # se %ecx >= %ebx -> salta a _loop
		jl _loop

_return:
	leal string, %eax  # puntatore di string in %eax

	popl %edi  # ripristino i registri
	popl %esi
	popl %edx
	popl %ecx
	popl %ebx

ret
