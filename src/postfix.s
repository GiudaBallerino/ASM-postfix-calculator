.section .data
  ebp: .long 0
  esp: .long 0

  invalid: .ascii "Invalid"
  invalid_len: .long . - invalid

  number: .long 0
  negative: .short 0
  before: .short -48

.section .text
  .global postfix

postfix:
  movl %ebp, ebp  # salvo ebp
  movl %esp, %ebp  # ebp come registro per recuperare i parametri

  pushl %ebx  # salvo i registri
  pushl %ecx
  pushl %edx
  pushl %esi
  pushl %edi

  movl %esp, esp  # salvo esp

  # Start code
  movl 4(%ebp), %esi  # input string
  movl 8(%ebp), %edi  # output string

do:
  movb (%esi), %al

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
  jl return_invalid
  cmp $'9'-48, %al
  jg return_invalid
  jmp if_number

  jmp return_invalid  # Invalid

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
    popl %edx
    popl %ecx

    subl %edx, %ecx

    pushl %ecx
    movb $0, negative  # reset 'negative'
    jmp while

  if_mul:
    mov %al, %cl  # salvo %al
    
    popl %edx
    popl %eax

    mul %edx
    pushl %eax

    mov %cl, %al  # ripristino %al
    jmp while

  if_div:
    xorl %edx, %edx  # reset %edx
    mov %al, %bl  # salvo %al

    popl %ecx
    popl %eax

    idiv %ecx
    pushl %eax

    mov %bl, %al  # ripristino %al
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
        movl $0, number

    jmp while

  if_number:
    xorl %ecx, %ecx  # reset %ecx
    mov %al, %cl  # salvo %ax

    movl $10, %edx
    movl number, %eax
    mul %edx

    addl %ecx, %eax
    movl %eax, number

    mov %cl, %al  # ripristino %ax
    jmp while


while:
  movb %al, before  # salva carattere precedente

  cmp $-48, %al  # compare con -48 (\0 - 48)
  je return

  incl %esi  # incrementa ebx
  jmp do


return:
  popl %eax
  call itoa

  write_string:
    movb (%eax), %bl
    movb %bl, (%edi)
    incl %eax
    incl %edi

    cmp $0, %bl
    jne write_string

  jmp fine

return_invalid:
  movl invalid_len, %ecx
  leal invalid, %esi

  write_string_invalid:
    movb (%esi), %al
    movb %al, (%edi)
    incl %esi
    incl %edi

    loop write_string_invalid  # decrementa %ecx e salta
  movb $0, (%edi)


fine:
  movl esp, %esp  # ripristino esp

  popl %edi  # ripristino i registri
  popl %esi
  popl %edx
  popl %ecx
  popl %ebx

  movl ebp, %ebp  # ripristino %ebp

ret
