.extern printf
.extern scanf

.section .rodata
invalid_fmt:
    .string "invalid input!\n"



.section .text
.globl pstrlen
.type	pstrlen, @function 
pstrlen:  ## getting a string returns the lengths - by length in struct.
    # Enter
    pushq %rbp
    movq %rsp, %rbp    
    # rdi is adress of pstring
    xorq %rax, %rax
    movb (%rdi) , %al

    # Exit
    
    movq %rbp, %rsp
    popq %rbp
    ret

.globl pstrijcpy
.type	pstrijcpy, @function 
pstrijcpy: ## Given pointers to two Pstrings, and two indices, the function copies src[i:j]
            ## into dst[i:j] and returns the pointer to dst. If either i or j are invalid given src and
            ## dst sizes, no changes should be made to dst, and the following message message
            ## should be printed: "invalid input!\n"
     # Enter
    pushq %rbp
    movq %rsp, %rbp    
    # rsi - dst, rdi - src, rdx - i , rcx - j
    # check i,j in dst,src length 

    # check i less then j
    cmpb %dl, %cl # j - i 
    jle .invalid # i > j
    
    # check j less then dst then src
    xorq %rax, %rax
    movb (%rdi), %al
    cmpb %cl , %al # src length - j must be > 0
    jle .invalid

    xorq %rax, %rax
    movb (%rsi), %al
    cmpb %cl , %al # dst kength - j must be > 0
    jle .invalid 

    # i < length because i < j at this point
    jmp .switch

.invalid:
    xorq %rax, %rax
    movq $invalid_fmt, %rdi
    call printf
    jmp .done

.switch:
    xorq %rax, %rax
    #increment both regs to start from 0 bit and not length char
    incq %rdi
    incq %rsi
    jmp .loop_cpy
.loop_cpy:
    # i in rdx
    movb (%rsi,%rdx) ,%al # src + i into al
    movb %al, (%rdi,%rdx) # al into dst + i
    incq %rdx
    cmpb %dl,%cl
    jge .loop_cpy # until i > j
    
    jmp .done



.globl swapCase
.type	swapCase, @function
swapCase: ## Given a pointer to a Pstring, the function turns every capital letter to a little
            ## one and vice versa.

    # Enter
    pushq %rbp
    movq %rsp, %rbp   
    pushq %rdi # store rdi in stack
     
    # A-Z 65-90, a-z 97-122
.loop:
    incq %rdi # increment to first bit
    # Read byte from string
    movb (%rdi), %al

    # If we're at the end of the string, exit
    cmpb $0x0, %al
    je .done

    # If byte is < 65 or > 122 its not a letter
    cmpb $65, %al
    jl .loop
    cmpb $122, %al
    jg .loop
    # byte is between 65 <= byte <= 122
    ## if <= 90 its a Big letter, big to small
    cmpb $90, %al
    jle .convert_bg_sm
    ## else > 90 , check if >= 97 small to big
    cmpb $97, %al
    jge .convert_sm_bg
    ## if not jumped by now then 90 < byte < 97 not a letter
    jmp .loop

.convert_sm_bg:
    ## sub 32 from value
    sub $32, (%rdi)
    jmp .loop
.convert_bg_sm:
    ## add 32 to value
    add $32, (%rdi)
    jmp .loop
.done:

    # Exit
    xorq %rax, %rax
    popq %rax # get original addres from stack and return it
    movq %rbp, %rsp
    popq %rbp
    
    ret
