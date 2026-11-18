format ELF64
public _start

msg db 'Result = '
len = $ - msg
usage db 'Usage: ./calc a b c', 10
usage_len = $ - usage
minus db '-'
buf rb 32
newline db 10

_start:
    cmp qword [rsp], 4
    jne error

    mov rsi, [rsp+16]
    call atoi
    mov r12d, eax

    mov rsi, [rsp+24]
    call atoi
    mov r13d, eax

    mov rsi, [rsp+32]
    call atoi
    mov r14d, eax

    ; (((a+c)-b)*c*c)-c
    mov eax, r12d
    add eax, r14d
    sub eax, r13d
    imul eax, r14d
    imul eax, r14d
    sub eax, r14d

    mov r15d, eax

    mov rsi, msg
    mov edx, len
    call print

    mov eax, r15d
    call print_num

    mov rsi, newline
    mov edx, 1
    call print

    jmp exit

error:
    mov rsi, usage
    mov edx, usage_len
    call print

exit:
    mov eax, 60
    xor edi, edi
    syscall

; string to number
atoi:
    xor eax, eax
    xor ecx, ecx

    cmp byte [rsi], '-'
    jne .loop
    mov ecx, 1
    inc rsi

.loop:
    movzx edx, byte [rsi]
    cmp dl, '0'
    jb .end
    cmp dl, '9'
    ja .end

    imul eax, 10
    sub dl, '0'
    add eax, edx
    inc rsi
    jmp .loop

.end:
    test ecx, ecx
    jz .ret
    neg eax
.ret:
    ret

; print string
print:
    mov eax, 1
    mov edi, 1
    syscall
    ret

; print number
print_num:
    test eax, eax
    jns .positive

    push rax
    mov rsi, minus
    mov edx, 1
    call print
    pop rax
    neg eax

.positive:
    mov r8, buf
    add r8, 31
    mov ecx, 10
    xor ebx, ebx

    test eax, eax
    jnz .convert

    dec r8
    mov byte [r8], '0'
    inc ebx
    jmp .show

.convert:
    xor edx, edx
    div ecx
    add dl, '0'
    dec r8
    mov [r8], dl
    inc ebx
    test eax, eax
    jnz .convert

.show:
    mov rsi, r8
    mov edx, ebx
    call print
    ret
