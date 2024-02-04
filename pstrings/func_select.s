.extern printf
.extern scanf

.section .rodata
invalid_fmt:
    .string "invalid option!\n"
answer_31_fmt:
    .string "first pstring length: %d, second pstring length: %d\n"
answer_33_34_fmt:
    .string "length: %d, string: %s\n"
scan_fmt:
    .string "%hhu %hhu"

.section .text
.globl run_func
.type	run_func, @function 
## int choice, Pstring *pstr1, Pstring *pstr2
run_func: 
    # Enter
    pushq %rbp
    movq %rsp, %rbp 
    
    # %rdi - int choice
    # %rsi - *pstring - 8 bytes
    # %rdx - *pstring2 - 8 bytes
    # save arguments to caller registers - 
    movl %edi , %r12d # save int in r10 fill 32 bits with zeros
    movq %rsi, %r13 #1pstring* - r11
    movq %rdx, %r14 #2pstring* - r12
     
    # compare rdi with 31,33/34 because int so cmpl
    xorq %rsi, %rsi
    xorq %rdi, %rdi
    cmpl $31, %r12d
    je .31

    cmpl $33, %r12d
    je .33

    cmpl $34, %r12d
    je .34
    jne .invalid  # if by now no equalty then error
    
.31: # call pstrlen for each string
    xorq %rax, %rax
    movq %r13, %rdi # pstr 1
    call pstrlen
    movzb %al , %r8 # length 1
    xorq %rax, %rax
    movq %r14, %rdi # pstr2
    call pstrlen
    movzb %al, %r9 # length 2
    movq $answer_31_fmt, %rdi
    movzbq %r8b, %rsi
    movzbq %r9b, %rdx
    call printf
    jmp .done
.33:
    xorq %rax, %rax
    movq %r13, %rdi # pstr 1
    call swapCase
    movq $answer_33_34_fmt, %rdi
    xorq %rsi,%rsi
    movzbq (%rax), %rsi
    leaq 1(%rax), %rdx
    call printf
    xorq %rax, %rax
    movq %r14, %rdi # pstr 2
    call swapCase
    movq $answer_33_34_fmt, %rdi
    xorq %rsi,%rsi
    movzbq (%rax), %rsi
    leaq 1(%rax), %rdx
    call printf
    jmp .done
.34:    ##Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)
      
    sub $16, %rsp # allocate 16 byets for 2 char - i,j
    # clear adresses and regs
    movq $0x0,-8(%rbp)
    movq $0x0,-16(%rbp)
    xorq %rsi,%rsi 
    xorq %rdx, %rdx
    # scan chars
    movq $scan_fmt, %rdi # set %d %d in scanf
    leaq -8(%rbp), %rsi # load addres for first int
    leaq -16(%rbp), %rdx # load addres for 2 int
    call scanf

    xor %rax, %rax
    movq %r13, %rdi # load pstr1 dst to rdi
    movq %r14, %rsi # load pastr2 src to rsi
    movq -8(%rbp), %rdx # copy value in addres (int 1)
    movq -16(%rbp), %rcx # capy value in addres (int2) 
    call pstrijcpy
    add $16, %rsp
    
    # print pstr1
    movq $answer_33_34_fmt, %rdi
    xorq %rsi,%rsi 
    xorq %rdx, %rdx
    movzbq (%r13), %rsi
    leaq 1(%r13), %rdx
    call printf

    #print pstr2
    movq $answer_33_34_fmt, %rdi
    xorq %rsi,%rsi 
    xorq %rdx, %rdx
    movzbq (%r14), %rsi
    leaq 1(%r14), %rdx
    call printf

    jmp .done
.invalid:   
    xor %rax, %rax
    movq $invalid_fmt , %rdi
    call printf
    jmp .done
.done:

    # rdx - pstr2

    # Exit
   
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret
