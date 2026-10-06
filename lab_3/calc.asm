format ELF64 executable 3
entry start

segment readable executable

start:
    mov rax, [rsp]
    cmp rax, 4
    jne .input_error

    mov rsi, [rsp + 16]
    call parse_int
    mov r12d, eax

    mov rsi, [rsp + 24]
    call parse_int
    mov r13d, eax

    mov rsi, [rsp + 32]
    call parse_int
    mov r14d, eax

    ; Вариант 19:
    ; (((((a+c)-b)*c)*c)-c)
    mov eax, r12d
    add eax, r14d
    sub eax, r13d
    imul eax, r14d
    imul eax, r14d
    sub eax, r14d
    mov r15d, eax

    mov rsi, expression_msg
    mov edx, expression_msg_len
    call print_string

    mov eax, r12d
    call print_int

    mov rsi, b_msg
    mov edx, b_msg_len
    call print_string

    mov eax, r13d
    call print_int

    mov rsi, c_msg
    mov edx, c_msg_len
    call print_string

    mov eax, r14d
    call print_int

    mov rsi, result_label
    mov edx, result_label_len
    call print_string

    mov eax, r15d
    call print_int

    mov rsi, newline
    mov edx, 1
    call print_string

    jmp .exit

.input_error:
    mov rsi, usage_msg
    mov edx, usage_msg_len
    call print_string

.exit:
    mov eax, 60
    xor edi, edi
    syscall

parse_int:
    xor eax, eax
    xor ecx, ecx

    cmp byte [rsi], '-'
    jne .digits

    mov ecx, 1
    inc rsi

.digits:
    movzx edx, byte [rsi]
    test dl, dl
    jz .done

    cmp dl, '0'
    jb .done
    cmp dl, '9'
    ja .done

    imul eax, eax, 10
    sub edx, '0'
    add eax, edx

    inc rsi
    jmp .digits

.done:
    test ecx, ecx
    jz .return

    neg eax

.return:
    ret

print_string:
    mov eax, 1
    mov edi, 1
    syscall
    ret

print_int:
    test eax, eax
    jns .positive

    push rax
    mov rsi, minus
    mov edx, 1
    call print_string
    pop rax
    neg eax

.positive:
    mov r8, num_buffer
    add r8, 31

    xor ecx, ecx
    mov ebx, 10

    test eax, eax
    jnz .convert

    dec r8
    mov byte [r8], '0'
    mov ecx, 1
    jmp .write

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec r8
    mov [r8], dl
    inc ecx
    test eax, eax
    jnz .convert

.write:
    mov rsi, r8
    mov edx, ecx
    call print_string
    ret

segment readable writeable

expression_msg db 'Expression: (((((a+c)-b)*c)*c)-c)', 10
expression_msg_len = $ - expression_msg

b_msg db ', b = '
b_msg_len = $ - b_msg

c_msg db ', c = '
c_msg_len = $ - c_msg

result_label db ', result = '
result_label_len = $ - result_label

usage_msg db 'Usage: ./calc a b c', 10
usage_msg_len = $ - usage_msg

minus db '-'
newline db 10

num_buffer rb 32
