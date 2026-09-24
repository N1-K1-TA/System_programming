; Лабораторная работа №2, вариант 19
; ФИО: Сорокин Никита Васильевич
; Задание 1. Вывод строки S в обратном порядке.

format ELF64

public _start

section '.data' writeable
s db 'NIiUjmvIsSpDdudQxauBx'
s_len = $-s

section '.bss' writeable
buf rb s_len

section '.text' executable
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
