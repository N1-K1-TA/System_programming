public exit
exit:
mov rax, 60
xor rdi, rdi
syscall
ret

public print_str
;input rsi - place of memory of begin string
print_str:
push rax
push rdi
push rdx
push rcx
mov rax, rsi
call len_str
mov rdx, rax
mov rax, 1
mov rdi, 1
syscall
pop rcx
pop rdx
pop rdi
pop rax
ret

public new_line
new_line:
push rax
push rdi
push rsi
push rdx
push rcx
mov rax, 0xA
push rax
mov rdi, 1
mov rsi, rsp
mov rdx, 1
mov rax, 1
syscall
pop rax
pop rcx
pop rdx
pop rsi
pop rdi
pop rax
ret

public len_str
;input rax - place of memory of begin string
;output rax - length of the string
len_str:
push rdx
mov rdx, rax
.iter:
cmp byte [rax], 0
je .next
inc rax
jmp .iter
.next:
sub rax, rdx
pop rdx
ret

public str_number
;input rsi - place of memory of begin string
;output rax - the number from the string (supports leading '-')
str_number:
push rcx
push rbx
push r8

xor rax, rax
xor rcx, rcx
mov r8, 1
cmp byte [rsi], '-'
jne .loop
mov r8, -1
inc rsi
.loop:
xor rbx, rbx
mov bl, byte [rsi+rcx]
cmp bl, '0'
jl .finished
cmp bl, '9'
jg .finished
sub bl, '0'
imul rax, 10
add rax, rbx
inc rcx
jmp .loop
.finished:
test rcx, rcx
jz .restore
imul rax, r8
.restore:
pop r8
pop rbx
pop rcx
ret

public number_str
;input rax - number, rsi - address of begin of string
;output: null-terminated decimal string at rsi (supports negative)
number_str:
push rbx
push rcx
push rdx
push r8

xor rcx, rcx
mov r8, 0
test rax, rax
jns .pos
neg rax
mov byte [rsi], '-'
mov r8, 1
.pos:
mov rbx, 10
.loop1:
xor rdx, rdx
div rbx
add rdx, '0'
push rdx
inc rcx
test rax, rax
jnz .loop1
mov rdx, r8
.loop2:
pop rax
mov byte [rsi+rdx], al
inc rdx
dec rcx
jnz .loop2
mov byte [rsi+rdx], 0

pop r8
pop rdx
pop rcx
pop rbx
ret
