format ELF64 executable 3
entry start

segment readable executable

start:
    mov rax, [rsp]
    cmp rax, 2
    jl .exit

    mov rsi, [rsp + 16]
    movzx eax, byte [rsi]

    push rax
    mov rsi, msg
    mov edx, msg_len
    call print_string
    pop rax

    call print_uint

    mov rsi, newline
    mov edx, 1
    call print_string

.exit:
    mov eax, 60
    xor edi, edi
    syscall

print_string:
    mov eax, 1
    mov edi, 1
    syscall
    ret

print_uint:
    mov r8, num_buffer
    add r8, 31

    xor ecx, ecx
    mov ebx, 10

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec r8
    mov [r8], dl
    inc ecx
    test eax, eax
    jnz .convert

    mov rsi, r8
    mov edx, ecx
    call print_string
    ret

segment readable writeable

msg db 'ASCII-code: '
msg_len = $ - msg
newline db 10
num_buffer rb 32
