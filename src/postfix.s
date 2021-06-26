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
  movl %ebp, ebp  # salva ebp
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
  movb (%esi), %al  # carattere da esaminare

  subb $'0', %al  # sottrai 48

  cmp $'+'-48, %al  # se '+' -> salta a if_plus
  je if_plus
  cmp $'-'-48, %al  # se '-' -> salta a if_dash
  je if_dash
  cmp $'*'-48, %al  # se '*' -> salta a if_mul
  je if_mul
  cmp $'/'-48, %al  # se '/' -> salta a if_div
  je if_div

  cmp $' '-48, %al  # se ' ' o '\0' -> salta a if_space
  je if_space
  cmp $-48, %al
  je if_space

  cmp $'0'-48, %al  # se NON è un numero -> salta a return_invalid
  jl return_invalid
  cmp $'9'-48, %al
  jg return_invalid
  jmp if_number

  jmp return_invalid  # Invalid

  if_plus:
    popl %edx  # numero 2
    popl %ecx  # numero 1

    addl %edx, %ecx  # numero 2 + numero 1

    pushl %ecx  # risultato nello stack
    jmp while

  if_dash:
    movb $1, negative  # alza a 1 negative
    jmp while

  if_minum:
    popl %edx  # numero 2
    popl %ecx  # numero 1

    subl %edx, %ecx  # numero 2 - numero 1

    pushl %ecx  # risultato nello stack
    movb $0, negative  # reset 'negative'
    jmp while

  if_mul:
    mov %al, %cl  # salva %al
    
    popl %edx  # numero 2
    popl %eax  # numero 1

    mul %edx  # numero 1 * numero 2
    pushl %eax # risultato nello stack

    mov %cl, %al  # ripristino %al
    jmp while

  if_div:
    xorl %edx, %edx  # reset %edx
    mov %al, %bl  # salva %al

    popl %ecx  # numero 2
    popl %eax  # numero 1

    idiv %ecx  # numero 2 / numero 1
    pushl %eax  # risultato nello stack

    mov %bl, %al  # ripristina %al
    jmp while

  if_space:
    mov before, %dl  # carattere precedente in %dl

    cmp $'-'-48, %dl  # se '-' -> salta a if_minum
    je if_minum  

    cmp $'0'-48, %dl  # se NON é un numero -> salta a while
    jl while
    cmp $'9'-48, %dl
    jg while

    create_number:
      movb negative, %dl  # carica negative

      cmp $1, %dl  # se numero positivo -> salta a save_number
      jne save_number

      negl number  # se numero negativo -> cambia segno
      movb $0, negative

      save_number:  # numero nello stack e reset di number
        pushl number
        movl $0, number

    jmp while

  if_number:
    xorl %ecx, %ecx  # reset %ecx  
    mov %al, %cl  # salva %ax

    movl $10, %edx  # prepara i registri per la moltiplicazione
    movl number, %eax  
    mul %edx  # moltiplico number *10

    addl %ecx, %eax  # aggiunge %ecx a number
    movl %eax, number

    mov %cl, %al  # ripristino %ax
    jmp while


while:
  movb %al, before  # salva carattere precedente

  cmp $-48, %al  # compare con -48 (\0 - 48)
  je return

  incl %esi  # incrementa %esi
  jmp do


return:
  popl %eax  # scarica risultato da stack
  call itoa  # converto il numero in stringa

  write_string:  # copia stringa risultante da itoa in output
    movb (%eax), %bl 
    movb %bl, (%edi)
    incl %eax
    incl %edi

    cmp $0, %bl
    jne write_string

  jmp fine

return_invalid:
  movl invalid_len, %ecx
  leal invalid, %esi  # puntatore di invalid in %esi

  write_string_invalid: # copia string "Invalid" in output
    movb (%esi), %al
    movb %al, (%edi)
    incl %esi
    incl %edi

    loop write_string_invalid  # decrementa %ecx e salta
  movb $0, (%edi)  # inserisce il carattere di terminazione


fine:
  movl esp, %esp  # ripristino esp

  popl %edi  # ripristino i registri
  popl %esi
  popl %edx
  popl %ecx
  popl %ebx

  movl ebp, %ebp  # ripristino %ebp

ret
