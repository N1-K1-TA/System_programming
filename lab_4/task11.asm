
format ELF executable 3
entry start

segment readable executable

start:
    call read_int

    mov ebp, eax
    mov esi, 0
    mov edi, 0

vote_loop:
    cmp edi, ebp
    jge result

    call read_int

    cmp eax, 1
    jne next_vote

    inc esi

next_vote:
    inc edi
    jmp vote_loop

result:
    mov eax, ebp
    shr eax, 1

    cmp esi, eax
    jle no

yes:
    mov eax, 4
    mov ebx, 1
    mov ecx, yes_msg
    mov edx, yes_len
    int 80h

    jmp exit_program

no:
    mov eax, 4
    mov ebx, 1
    mov ecx, no_msg
    mov edx, no_len
    int 80h

    jmp exit_program

include 'common.inc'

segment readable writeable

char_buf rb 1
out_buf rb 32

yes_msg db 'Да', 10
yes_len = $ - yes_msg

no_msg db 'Нет', 10
no_len = $ - no_msg
