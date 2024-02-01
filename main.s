.extern printf
.extern scanf
.extern rand
.extern srand
.section .data
user_number:
    .zero 4
user_seed:
    .zero 4
game_number:
    .zero 4

.section .rodata
user_greet_fmt:
    .string "Enter configuration seed: "
user_guess_fmt:
    .string "What is your guess? "
user_gameover_fmt:
    .string "Game over, you lost :(. The correct answer was "
user_correct_fmt:
    .string "Congratz! You won!"
number_fmt:
    .string "%u"

incorrect_result_fmt:
    .string "Incorrect!\n"

.section .text
.globl main
.type	main, @function 
main:
      # Enter
    pushq %rbp
    movq %rsp, %rbp 
    # print seed promt
    movq $user_greet_fmt, %rdi
    xor %rax , %rax
    call printf
    # scan seed
    movq $number_fmt, %rdi
    movl $user_seed , %esi
    xor %rax, %rax
    call scanf
    # print seed
    movq $number_fmt, %rdi
    movl user_seed , %esi
    xor %rax , %rax
    call printf
    # set srand
    movq user_seed , %rdi
    xor %rax, %rax
    call srand
    # get random number , need modulu 10
    xor %rax, %rax 
    call rand 
    # set modulu
    xor %edx, %edx
    movl $10 , % ebx # set divider
    div %ebx # modulu 10 in eax
    movl %edx, game_number 
   
    # set loop for 5 times
    xorq %rbx, %rbx
    movb $0x05, %bl    
    
.loop:
    # zero rdi
    xor %rdi, %rdi
    # promt guess
    movq $user_guess_fmt , %rdi
    xor %rax, %rax
    call printf
    # scan answer
    movq $number_fmt, %rdi
    movq $user_number, %rsi
    xor %rax, %rax
    call scanf
    # compare user_number with game_number
    movl user_number, %edi
    movl game_number, %esi
    cmpl %edi,%esi
    je .correct
    jne .incorrect
    
    
.incorrect:
    # print incorrect
    movq $incorrect_result_fmt, %rdi
    xor %rax, %rax
    call printf
    decb %bl
    cmpb $0x0 , %bl
    jne .loop
    je .gameover
.correct:
    # print correct
    movq $user_correct_fmt, %rdi
    xor %rax, %rax
    call printf
    jmp .done
.gameover:
    # print gameover
    movq $user_gameover_fmt, %rdi
    xor %rax, %rax
    call printf
    jmp .done
.done:
      # Exit
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret
