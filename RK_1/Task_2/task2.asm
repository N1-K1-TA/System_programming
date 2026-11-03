format ELF64 executable

segment readable executable

entry _start

_start:
    pop     rsi
    cmp     rsi, 2
    jl      .exit_error
    pop     rsi
    pop     rsi

    ; Парсим строку в число (в rax)
    xor     rax, rax
    mov     rcx, 10
.parse_loop:
    movzx   rdx, byte [rsi]
    cmp     dl, '0'
    jl      .parse_done
    cmp     dl, '9'
    jg      .parse_done
    sub     dl, '0'
    imul    rax, rcx
    add     rax, rdx
    inc     rsi
    jmp     .parse_loop
.parse_done:

    test    rax, rax
    jle     .exit_error

    mov     r8, rax

    xor     rbx, rbx
    xor     rdx, rdx
    mov     r9, 10

.calc_loop:
    ; текущий элемент = текущий элемент * 10 + 1
    imul    rdx, r9
    add     rdx, 1

    ; добавляем к общей сумме
    add     rbx, rdx

    dec     r8
    jnz     .calc_loop

    ; Преобразуем число из rbx в строку и выводим
    mov     rax, rbx
    mov     rdi, out_buf + 31
    mov     byte [rdi], 10
    dec     rdi
    mov     rcx, 10

.convert_loop:
    xor     rdx, rdx
    div     rcx
    add     dl, '0'
    mov     [rdi], dl
    dec     rdi
    test    rax, rax
    jnz     .convert_loop

    inc     rdi
    mov     rsi, rdi
    mov     rdx, out_buf + 32
    sub     rdx, rsi

    ; Системный вызов write (stdout)
    mov     rax, 1
    mov     rdi, 1
    syscall

    ; Выход (sys_exit)
    mov     rax, 60
    xor     rdi, rdi
    syscall

.exit_error:
    mov     rax, 60
    mov     rdi, 1
    syscall

segment readable writable

    out_buf rb 32
