option casemap:none

extern GetStdHandle:proc
extern WriteFile:proc
extern ExitProcess:proc
extern console_print: proc

STD_OUTPUT_HANDLE equ -11

.data
fiz db "Fizz"
lenfiz equ $ - fiz

buz db "Buzz"
lenbuz equ $ - buz

newline db 13,10
lennewline equ $ - newline
written dq 0



;rcx = stdout handle
;rdx = address of text
;r8d = length of text
;r9 = address of written

;rcx = 1st
;rdx = 2nd
;r8 = 3rd
;r9 = 4th

;rax = return

.code
_startFizzBuzz5 PROC
    and rsp, -16  ; Clears the lowest 4 bits of RSP


	

	
	mov rcx, STD_OUTPUT_HANDLE
	sub rsp, 28h
	call GetStdHandle
	add rsp, 28h
	
	mov r14,rax

	sub rsp, 10h

	mov rcx,1234
	mov rdx,rsp
	mov r8,10h
	
	call I_to_a
	mov rcx,rax
	mov rdx,rax
	call String_Length
	mov r8d,eax
	call console_print
	add rsp,10h
; r12 is the loop index
mov r12,1


Loop_Start:
	cmp r12,100
	jg Script_End ;if greater then jump to end

	mov rax,r12
	mov rcx,3
	xor rdx,rdx
	div rcx
	test rdx,rdx
	jnz Skip_Print_Fizz
	lea rdx,fiz
	mov r8d,lenfiz

	sub rsp, 28h
	call console_print
	add rsp, 28h


Skip_Print_Fizz:
	mov rcx,r12

	sub rsp, 28h
	call Test_52
	add rsp, 28h

;printing numbers 


;I to a fucntion for storing sting converted dicimals


Print_Digits:




Skip_Print_Number:
	lea rdx,newline
	mov r8d,lennewline

	sub rsp, 28h
	call console_print
	add rsp, 28h

	add r12,1
	jmp Loop_Start


Script_End:
	xor ecx,ecx
	call ExitProcess

_startFizzBuzz5 ENDP


Test_52 PROC
	mov rax,rcx
	mov r10,5
	xor rdx,rdx
	div r10
	test rdx,rdx
	jnz Skip_Print_Buzz
	lea rdx,buz
	mov r8d,lenbuz

	sub rsp, 28h
	call console_print
	add rsp, 28h

Skip_Print_Buzz:
	ret

Test_52 ENDP



I_to_a PROC
; rcx = in number to be converted
; rdx = (in) pointer to the buffer
; r8 = (in) length of buffer

;r11 = number of digites
;rax = is the where the number is moved to

mov rax,rcx
add r8,rdx ;r8 is now the pointing to the end of the buffer
xor r11,r11
mov r12,10
mov BYTE PTR [r8],0


Decimal_Loop:
dec r8
xor rdx,rdx
div r12
add rdx,48
mov BYTE PTR [r8],dl
inc r11
test rax,rax
jnz Decimal_Loop

mov rax,r8
ret

I_to_a ENDP

String_Length PROC
;rcx = pointer
xor rax,rax
count_start:
	cmp BYTE PTR [rcx],0
	jz count_end
	inc rcx
	inc rax
	jmp count_start
count_end:
	ret

String_Length ENDP

END