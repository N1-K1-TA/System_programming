format ELF64

public _start

s db 0xA, 'NIiUjmvIsSpDdudQxauBx'
s_len = $-s

buf rb s_len

_start:
    lea rsi,[s]
    lea rdi,[buf+s_len-1]
    mov rcx,s_len

.reverse:
    mov al,[rsi]
    mov [rdi],al
    inc rsi
    dec rdi
    loop .reverse

    mov eax,1
    mov edi,1
    lea rsi,[buf]
    mov edx,s_len
    syscall

    mov eax,60
    xor edi,edi
    syscall
