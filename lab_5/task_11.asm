format ELF executable 3
entry start

segment readable executable

start:
    pop eax
    cmp eax, 3
    jl exit_err

    pop eax
    pop ebx
    pop ecx

    mov [file_out], ebx

    mov esi, ecx
    xor eax, eax
conv_loop:
    movzx edx, byte [esi]
    cmp edx, 0
    je conv_done
    sub edx, '0'
    imul eax, eax, 10
    add eax, edx
    inc esi
    jmp conv_loop
conv_done:
    mov [n_val], eax

    mov eax, 8
    mov ebx, [file_out]
    mov ecx, 438
    int 0x80
    cmp eax, 0
    jl exit_err
    mov [fd_out], eax

    mov ecx, 2
check_prime_loop:
    cmp ecx, [n_val]
    jg finish_gen

    mov edi, 2
prime_subloop:
    cmp edi, ecx
    jge is_prime
    mov eax, ecx
    xor edx, edx
    mov ebx, edi
    div ebx
    cmp edx, 0
    je not_prime
    inc edi
    jmp prime_subloop

is_prime:
    mov eax, ecx
    xor edx, edx
    mov ebx, 10
    div ebx
    cmp edx, 1
    jne not_prime

    call int_to_str

    push ecx
    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, num_str
    mov edx, [str_len]
    int 0x80

    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, newline
    mov edx, 1
    int 0x80
    pop ecx

not_prime:
    inc ecx
    jmp check_prime_loop

finish_gen:
    mov eax, 6
    mov ebx, [fd_out]
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80

exit_err:
    mov eax, 1
    mov ebx, 1
    int 0x80

int_to_str:
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov eax, ecx
    mov edi, num_str + 10
    mov byte [edi], 0
    mov ecx, 10
    mov [str_len], 0

itoa_loop:
    xor edx, edx
    div ecx
    add dl, '0'
    dec edi
    mov byte [edi], dl
    inc dword [str_len]
    cmp eax, 0
    jne itoa_loop

    mov esi, edi
    mov edi, num_str
    mov ecx, [str_len]
    cld
    rep movsb

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

segment readable writeable
    file_out   dd 0
    fd_out     dd 0
    n_val      dd 0
    str_len    dd 0
    newline    db 0x0A
    num_str    rb 20
