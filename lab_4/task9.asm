
format ELF executable 3
entry start

segment readable executable

start:
    call read_int

    mov ebp, eax
    mov esi, 1
    mov edi, 0

cycle:
    cmp esi, ebp
    jg finish

    mov eax, esi
    dec eax
    shr eax, 1
    and eax, 1

    cmp eax, 0
    jne minus

    add edi, esi
    jmp next

minus:
    sub edi, esi

next:
    inc esi
    jmp cycle

finish:
    mov eax, edi
    call print_int
    jmp exit_program

include 'common.inc'

segment readable writeable

char_buf rb 1
out_buf rb 32
