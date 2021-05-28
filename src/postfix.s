.section .data
  ebp: .long 0

  invalid: .ascii "Invalid"
  invalid_len: .long . - invalid

  number: .long 0
  negative: .short 0
  before: .short -48

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
  subb $'0', %al  # sottrai 48

  # Code
  cmp $'+'-48, %al
  je if_plus
  cmp $'-'-48, %al
  je if_dash
  cmp $'*'-48, %al
  je if_mul
  cmp $'/'-48, %al
  je if_div

  cmp $' '-48, %al
  je if_space
  cmp $-48, %al
  je if_space

  cmp $'0'-48, %al
  jl if_invalid
  cmp $'9'-48, %al
  jg if_invalid
  jmp if_number

  # jmp invalid  # Invalid

  if_plus:
    # code
    jmp while

  if_dash:
    movl $1, negative
    jmp while

  if_minum:
    # code
    jmp while

  if_mul:
    # code
    jmp while

  if_div:
    # code
    jmp while

  if_space:
    mov before, %dl

    cmp $'-'-48, %dl
    je if_minum

    cmp $'0'-48, %dl
    jl while
    cmp $'9'-48, %dl
    jg while

    create_number:
      # code (se numero negativo: * -1)
      # pushl number  # eliminare da stack al termine del programma
      movl $0, number

    jmp while

  if_number:
    mov %al, %cl  # salvo %ax

    mov $10, %dx
    movl number, %eax
    mul %edx

    add %ecx, %eax
    mov %eax, number

    mov %cl, %al  # ripristino %ax

    jmp while

  if_invalid:
    jmp return


while:
  movb %al, before  # salva carattere precedente

  cmp $-48, %al  # compare con -48 (\0 - 48)
  je return

  incl %ebx  # incrementa ebx
  jmp do


return:

  # popl %eax


fine:

  popl %edx              # ripristino i registri general purpose
	popl %ecx
	popl %ebx

  movl ebp, %ebp         # ripristino %ebp

ret
