format ELF64

public _start

s db 0xA, 'NIiUjmvIsSpDdudQxauBx'
s_len = $-s

buf rb 1

_start:
    lea rsi, [s]
    lea rdi, [s + s_len - 1]

    mov rcx, s_len / 2
.reverse:
    mov al, [rsi]
    mov [buf], al
    mov al, [rdi]
    mov [rsi], al
    mov al, [buf]
    mov [rdi], al

    inc rsi
    dec rdi
    loop .reverse

    mov eax, 1
    mov edi, 1
    lea rsi, [s]
    mov edx, s_len
    syscall

    mov eax, 60
    xor edi, edi
    syscall
