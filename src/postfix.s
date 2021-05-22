.section .data
  ebp: .long 0
  char_end: .short 0
  ; char: .ascii "0\n"
  ; char_len: .long . - char

  number: .long 0
  negative: .short 0
  before: .long -48

.section .text
  .global postfix

postfix:
  movl %ebp, ebp         # salvo ebp
  movl %esp, %ebp        # ebp come registro per recuperare i parametri

	pushl %ebx             # salvo i registri general purpose
	pushl %ecx
	pushl %edx

  # Start code
  movl 4(%ebp), %ebx                 # leggo puntatore a input string

do:
  movb (%ebx), %al

  # subb $48, %al
  subb $'0', %al # sottrai 48

  # code

  cmp $'+', %al
  je if_plus
  cmp $'-', %al
  je if_dash

if_plus:
  # code
  jmp while

if_dash:
  # code
  movl $1, negative
  jmp while

while:
  cmp $-48, %al # compare con -48 (\0 - 48)
  je fine

  incl %ebx # incrementa ebx
  jmp do

  # End code
fine:
  popl %edx              # ripristino i registri general purpose
	popl %ecx
	popl %ebx

  movl ebp, %ebp         # ripristino %ebp

ret
