
read_int:
    push edi
    push esi

    mov edi, 0
    mov esi, 1

read_loop:
    mov eax, 3
    mov ebx, 0
    mov ecx, char_buf
    mov edx, 1
    int 80h

    cmp eax, 1
    jne read_end

    mov al, [char_buf]

    cmp al, 10
    je read_end

    cmp al, '-'
    jne check_digit

    mov esi, -1
    jmp read_loop

check_digit:
    cmp al, '0'
    jb read_loop

    cmp al, '9'
    ja read_loop

    movzx eax, al
    sub eax, '0'

    imul edi, 10
    add edi, eax

    jmp read_loop

read_end:
    mov eax, edi
    imul eax, esi

    pop esi
    pop edi
    ret


print_int:
    mov esi, out_buf
    add esi, 31

    mov byte [esi], 10
    dec esi

    mov ebx, 10
    mov ebp, 0

    cmp eax, 0
    jge print_loop

    neg eax
    mov ebp, 1

print_loop:
    xor edx, edx
    div ebx

    add dl, '0'
    mov [esi], dl
    dec esi

    test eax, eax
    jnz print_loop

    cmp ebp, 1
    jne print_end

    mov byte [esi], '-'
    dec esi

print_end:
    inc esi

    mov edx, out_buf
    add edx, 31
    sub edx, esi
    inc edx

    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 80h
    ret


exit_program:
    mov eax, 1
    mov ebx, 0
    int 80h
