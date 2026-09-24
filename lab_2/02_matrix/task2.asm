; Лабораторная работа №2, вариант 19
; ФИО: Сорокин Никита Васильевич
; Задание 2. Матрица M x K из N символов.

format ELF64

public _start

M = 2
K = 3
N = 6

section '.bss' writeable
matrix rb N
output rb (M+1)*K

section '.text' executable
_start:
    lea rdi,[matrix]
    mov rcx,N
    mov al,'$'
.fill:
    mov [rdi],al
    inc rdi
    loop .fill

    lea rsi,[matrix]
    lea rdi,[output]
    mov r8d,K

.row:
    mov r9d,M
.col:
    mov al,[rsi]
    mov [rdi],al
    inc rsi
    inc rdi
    dec r9d
    jnz .col

    mov byte [rdi],10
    inc rdi
    dec r8d
    jnz .row

    mov eax,1
    mov edi,1
    lea rsi,[output]
    mov edx,(M+1)*K
    syscall

    mov eax,60
    xor edi,edi
    syscall
