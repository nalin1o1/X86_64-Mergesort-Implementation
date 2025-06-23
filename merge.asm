section .data

array dq 3,1,2,4,5
array_len dq $ - array
n1 dq 0
n2 dq 0
array_middle dq 0
base_pointer dq 0

section .text
global _start

_start:

jmp main

merge:

push rbp 
mov rbp,rsp


mov rax,rsi
mov rbx,rdx
mov rcx,r10 ;l,m,r

shl rbx,3
lea rcx,[array + rdx*8]
mov [array_middle],rcx


mov rcx,r10
mov rbx,rdx
; calculating the size of the array required

sub rbx,rax
add rbx,1
mov [n1],rbx	;storing n1 inside var1

sub rcx,rdx
mov [n2],rcx	;storing n2 sinde var2

add rcx,[n1]
shl rcx,3
sub rsp,rcx 	; allocating the space requried

lea rcx,[rsp]
shl rcx,4
cmp rsp,rcx

mov rax,0


loop1:
cmp [n1],rax	;filling the L array	starts filling from the bottom of the rsp pointer
je next
lea rbx,[array + rsi*8]
mov rbx, [rbx + rax*8]
mov [rsp + rax*8],rbx
lea rcx,[rsp + rax*8]
add rax,1
jmp loop1


next:
;rcx holds the current rsp stack pointer
add rcx,8
xor rax,rax

loop2:	;load the R array
cmp [n2],rax
je next2
mov rbx,[array_middle]
lea rbx, [rbx + 8]
mov rbx,[rbx + rax*8]

lea rcx,[rcx + rax*8]
mov [rcx],rbx
add rax,1
jmp loop2


next2:

mov rax,0
mov rbx,0
mov rcx,[n1]
shl rcx,3
lea rcx, [rsp + rcx]	;storing the middle of the stack inside rcx
mov r9,0	; L counter
mov r8,0	; R counter
lea r11,[array + rsi*8]	;r11 stores the address of l index of array

loop3:
; r8 and r9 are registers for counter r9 for L and r8 for R
cmp r9,[n1]
je next3
cmp r8,[n2]
je next3


mov rax,[rsp + r9*8]
mov rbx,[rcx + r8*8]
cmp rax,rbx
jg if1	; Li > Rj
jl if2	; Li < Ri

if1:	; Li > Ri
mov [r11],rax
add r9,1
add r11,8
jmp loop3

if2:
mov [r11],rbx
add r8,1
add r11,8
jmp loop3

next3:

loop4:
cmp r9,[n1]
je loop5
mov rax,[rsp + r9*8]
mov [r11],rax
add r9,1
add r11,8
jmp loop4

loop5:
cmp r8,[n2]
je final
mov rbx,[rcx + r8*8]
mov [r11],rbx
add r8,1
add r11,8
jmp loop5

final:
leave 
ret


mergesort:


; computing the value of the middle element


mov rax,rsi
mov rbx,rdx

cmp rax,rbx
je final1

;alignment

push rbp
mov rbp,rsp
sub rsp,24
add rsp,15
and rsp,-16	;allocating 24 bytes of space 
mov [base_pointer],rbp

mov [rbp-8],rax
mov [rbp-16],rbx

;m = l + (r-l)/2
sub rbx,rax
shr rbx,1
add rbx,rax
mov rcx,rbx	;m
mov rbx,rdx	;r

mov [rbp-24],rcx	

mov rsi,[rbp-8]		
mov rdx,[rbp-24]	;storing m as r

call mergesort

mov rsi,[rbp-24]
add rsi,1
mov rdx,[rbp-16]

call mergesort

mov rsi,[rbp-8]
mov rdx,[rbp-24]
mov r10,[rbp-16]

call merge
final1:
mov rbp,[base_pointer]
ret

main:

mov rsi,0		;passing indices here and not pointers remember
mov rbx,[array_len]
shr rbx,3
sub rbx,1
mov rdx,rbx
call mergesort

lea rax,[array]
call merge

mov rax,60
mov rdi,0
syscall
