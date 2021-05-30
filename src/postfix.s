.section .data
  ebp: .long 0
  al: .long 0

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

  xorl %ebx, %ebx
  xorl %ecx, %ecx
  xorl %edx, %edx

  # Start code
  movl 4(%ebp), %ebx                 # leggo puntatore a input string

do:
  movb (%ebx), %al

  # subb $48, %al
  subb $'0', %al  # sottrai 48

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

  jmp invalid  # Invalid

  if_plus:
    popl %edx
    popl %ecx

    addl %edx, %ecx

    pushl %ecx
    jmp while

  if_dash:
    movb $1, negative
    jmp while

  if_minum:
    # xorl %edx, %edx
    popl %edx
    popl %ecx

    subl %edx, %ecx

    pushl %ecx
    movb $0, negative
    jmp while

  if_mul:
    mov %al, %cl  # salvo %al
    
    popl %edx
    popl %eax

    mul %edx
    pushl %eax

    # movl $0, %eax
    mov %cl, %al  # ripristino %al
    jmp while

  if_div:
    mov %al, al  # salvo %al

    xorl %edx, %edx

    popl %ecx
    popl %eax

    idiv %ecx
    pushl %eax

    # movl $0, %eax
    mov al, %al  # ripristino %al
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
      movb negative, %dl
      cmp $1, %dl
      jne save_number

      negl number  # numero negativo
      movb $0, negative

      save_number:
        pushl number
        # movl number, %edx
        movl $0, number

    jmp while

  if_number:
    mov %al, %cl  # salvo %ax

    movl $10, %edx
    movl number, %eax
    mul %edx

    addl %ecx, %eax
    movl %eax, number

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

  popl %eax


fine:

  popl %edx              # ripristino i registri general purpose
  popl %ecx
  popl %ebx

  movl ebp, %ebp         # ripristino %ebp

ret
