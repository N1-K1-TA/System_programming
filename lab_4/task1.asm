
format ELF executable 3
entry start

segment readable executable

start:
    call read_int

    mov ebx, 481
    xor edx, edx
    div ebx

    call print_int
    jmp exit_program

include 'common.inc'

segment readable writeable

char_buf rb 1
out_buf rb 32
