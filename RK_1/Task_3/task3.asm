format ELF64 executable
entry start

sys_read     = 0
sys_open     = 2
sys_close    = 3
sys_getdents = 78
sys_chdir    = 80
sys_chmod    = 90
sys_exit     = 60
sys_getrandom= 318

O_RDONLY     = 0
DT_REG       = 8

section '.bss' readable writeable
    dir_buf     rb 4096
    rnd_buf     rb 8
    file_list   rq 256
    file_count  rq 1

section '.text' executable

start:
    pop     rcx
    cmp     rcx, 2
    jl      exit_error

    pop     rax
    pop     rdi

    mov     rax, sys_chdir
    syscall
    test    rax, rax
    js      exit_error

    mov     rax, sys_open
    mov     rdi, current_dir
    mov     rsi, O_RDONLY
    xor     rdx, rdx
    syscall
    test    rax, rax
    js      exit_error
    mov     rbx, rax
    mov     rax, sys_getdents
    mov     rdi, rbx
    mov     rsi, dir_buf
    mov     rdx, 4096
    syscall
    test    rax, rax
    jle     close_and_exit

    mov     r8, rax
    xor     r9, r9
    mov     qword [file_count], 0

parse_loop:
    cmp     r9, r8
    jge     select_files

    lea     r10, [dir_buf + r9]
    movzx   rax, word [r10 + 16]
    mov     r11b, byte [r10 + 18]

    cmp     r11b, DT_REG
    jne     next_entry

    lea     rax, [r10 + 19]
    mov     rcx, [file_count]
    mov     [file_list + rcx * 8], rax
    inc     qword [file_count]

    cmp     qword [file_count], 256
    je      select_files

next_entry:
    movzx   rax, word [r10 + 16]
    add     r9, rax
    jmp     parse_loop

select_files:
    mov     rax, [file_count]
    test    rax, rax
    jz      close_and_exit

    call    get_random_uint64
    xor     rdx, rdx
    div     qword [file_count]
    inc     rdx
    mov     r12, rdx

change_loop:
    test    r12, r12
    jz      close_and_exit

    call    get_random_uint64
    xor     rdx, rdx
    div     qword [file_count]

    mov     rdi, [file_list + rdx * 8] ; rdi = имя файла

    call    get_random_uint64
    and     rax, 0777o
    mov     rsi, rax

    mov     rax, sys_chmod
    syscall

    dec     r12
    jmp     change_loop

close_and_exit:
    mov     rax, sys_close
    mov     rdi, rbx
    syscall

    mov     rax, sys_exit
    xor     rdi, rdi
    syscall

exit_error:
    mov     rax, sys_exit
    mov     rdi, 1
    syscall

get_random_uint64:
    mov     rax, sys_getrandom
    mov     rdi, rnd_buf
    mov     rsi, 8
    xor     rdx, rdx
    syscall
    mov     rax, [rnd_buf]
    ret

section '.data' readable
    current_dir db '.', 0
