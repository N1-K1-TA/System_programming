; Лабораторная работа №2, вариант 19
; ФИО: Сорокин Никита Васильевич
; Задание 3. Треугольник из N=6 символов '$'.

format ELF64

public _start

section '.bss' writeable
output rb 16

section '.text' executable
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
    mov edx,9
    syscall

    mov eax,60
    xor edi,edi
    syscall
