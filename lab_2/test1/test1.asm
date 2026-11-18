
format ELF64

public _start

M = 21
K = 6
N = M

s db 'NIiUjmvIsSpDdudQxauBx'
output rb N+K

_start:
    lea rsi,[s]
    lea rdi,[output]
    mov r8d,1

.row:
    mov r9d,r8d

.col:
    mov al,[rsi]
    mov [rdi],al
    inc rsi
    inc rdi
    dec r9d
    jnz .col

    mov byte [rdi],10
    inc rdi

    inc r8d
    cmp r8d,K+1
    jb .row

    mov eax,1
    mov edi,1
    lea rsi,[output]
    mov edx,N+K
    syscall

    mov eax,60
    xor edi,edi
    syscall
