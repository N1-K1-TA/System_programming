format ELF64
public _start
include 'func.asm'


char_buf db 0, 0

_start:
    pop rcx
    cmp rcx, 2

    pop rsi
    pop rsi

    mov al, [rsi]
    mov rcx, 10
.loop1:
    mov [char_buf], al
    mov rsi, char_buf
    call print_str
    call new_line
    inc al
    loop .loop1

    call exit
