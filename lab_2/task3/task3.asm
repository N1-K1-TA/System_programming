format ELF64

public _start

M = 3
K = 3
N = M*(M+1)/2

output rb N+K

_start:
    lea rdi,[output]

    mov r8d,1
.row:
    mov r9d,r8d
.col:
    mov byte [rdi],'$'
    inc rdi
    dec r9d
    jnz .col
    mov byte [rdi],10
    inc rdi
    inc r8d
    cmp r8d,4
    jb .row

    mov eax,1
    mov edi,1
    lea rsi,[output]
    mov edx,N+K
    syscall

    mov eax,60
    xor edi,edi
    syscall
