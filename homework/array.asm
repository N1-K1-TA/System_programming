format ELF64

section '.text' executable

public create_array
public free_array
public fill_random
public get_odd_numbers
public count_primes
public reverse_array

SYS_MMAP      equ 9
SYS_MUNMAP    equ 11
SYS_GETRANDOM equ 318

PROT_READ     equ 1
PROT_WRITE    equ 2
MAP_PRIVATE   equ 0x02
MAP_ANONYMOUS equ 0x20

; int* create_array(size_t size)
create_array:
    push rbp
    mov rbp, rsp
    shl rdi, 2               ; size * sizeof(int)
    jz .err

    mov rsi, rdi             ; length
    xor rdi, rdi             ; addr = NULL
    mov rdx, PROT_READ or PROT_WRITE
    mov r10, MAP_PRIVATE or MAP_ANONYMOUS
    mov r8, -1               ; fd = -1
    xor r9, r9               ; offset = 0
    mov rax, SYS_MMAP
    syscall

    cmp rax, -4095
    jae .err
    leave
    ret
.err:
    xor rax, rax
    leave
    ret

; void free_array(int* ptr, size_t size)
free_array:
    push rbp
    mov rbp, rsp
    test rdi, rdi
    jz .done
    test rsi, rsi
    jz .done
    shl rsi, 2               ; length = size * 4
    mov rax, SYS_MUNMAP
    syscall
.done:
    leave
    ret

; void fill_random(int* ptr, size_t size, int min_val, int max_val)
fill_random:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    push rbx

    test rdi, rdi
    jz .fill_done
    test rsi, rsi
    jz .fill_done

    mov r12, rdi             ; ptr
    mov r13, rsi             ; size
    mov r14d, edx            ; min_val
    mov r15d, ecx            ; max_val
    sub r15d, r14d           ; range = max - min + 1
    inc r15d
    cmp r15d, 0
    jle .fill_done

    xor rbx, rbx             ; i = 0
.loop_fill:
    cmp rbx, r13
    jge .fill_done

    sub rsp, 16
    mov rdi, rsp
    mov rsi, 4
    xor rdx, rdx
    mov rax, SYS_GETRANDOM
    syscall
    mov eax, dword [rsp]
    add rsp, 16

    ; eax = abs(eax)
    mov edx, eax
    sar edx, 31
    xor eax, edx
    sub eax, edx

    xor rdx, rdx
    div r15d                 ; edx = eax % range
    add edx, r14d            ; val = min_val + edx

    mov dword [r12 + rbx*4], edx
    inc rbx
    jmp .loop_fill

.fill_done:
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    leave
    ret

; size_t get_odd_numbers(const int* src, size_t src_size, int* dst)
get_odd_numbers:
    push rbp
    mov rbp, rsp
    xor rax, rax             ; count = 0
    test rdi, rdi
    jz .odd_done
    test rdx, rdx
    jz .odd_done
    test rsi, rsi
    jz .odd_done

    xor rcx, rcx             ; i = 0
.loop_odd:
    cmp rcx, rsi
    jge .odd_done

    mov r8d, dword [rdi + rcx*4]
    test r8d, 1
    jz .skip_odd

    mov dword [rdx + rax*4], r8d
    inc rax

.skip_odd:
    inc rcx
    jmp .loop_odd

.odd_done:
    leave
    ret

; size_t count_primes(const int* ptr, size_t size)
count_primes:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    xor rbx, rbx             ; prime_count = 0
    test rdi, rdi
    jz .prime_done
    test rsi, rsi
    jz .prime_done

    xor r12, r12             ; i = 0
.loop_prime:
    cmp r12, rsi
    jge .prime_done

    mov edx, dword [rdi + r12*4]
    cmp edx, 2
    jl .next_elem

    mov ecx, 2
.check_div:
    mov eax, ecx
    imul eax, ecx
    cmp eax, edx
    jg .is_prime_val

    mov eax, edx
    push rdx
    xor rdx, rdx
    div ecx
    pop r8
    test rdx, rdx
    jz .next_elem

    inc ecx
    jmp .check_div

.is_prime_val:
    inc rbx

.next_elem:
    inc r12
    jmp .loop_prime

.prime_done:
    mov rax, rbx
    pop r12
    pop rbx
    leave
    ret

; void reverse_array(int* ptr, size_t size)
reverse_array:
    push rbp
    mov rbp, rsp
    test rdi, rdi
    jz .rev_done
    cmp rsi, 1
    jle .rev_done

    xor rax, rax             ; left = 0
    mov r8, rsi
    dec r8                   ; right = size - 1

.loop_rev:
    cmp rax, r8
    jge .rev_done

    mov ecx, dword [rdi + rax*4]
    mov edx, dword [rdi + r8*4]

    mov dword [rdi + rax*4], edx
    mov dword [rdi + r8*4], ecx

    inc rax
    dec r8
    jmp .loop_rev

.rev_done:
    leave
    ret
