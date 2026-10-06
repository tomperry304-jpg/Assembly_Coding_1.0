option casemap:none

extern GetStdHandle:proc
extern WriteFile:proc
extern ExitProcess:proc

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
_startFizzBuzz4 PROC
    and rsp, -16  ; Clears the lowest 4 bits of RSP
	mov rcx, STD_OUTPUT_HANDLE
	sub rsp, 28h
	call GetStdHandle
	add rsp, 28h
	
	mov r14,rax

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
	lea rcx,fiz
	mov edx,lenfiz

	sub rsp, 28h
	call Print_Fizz1
	add rsp, 28h


Skip_Print_Fizz:
	mov rcx,r12

	sub rsp, 28h
	call Test_51
	add rsp, 28h

	lea rcx,newline
	mov edx,lennewline

	sub rsp, 28h
	call New_Line1
	add rsp, 28h

	add r12,1
	jmp Loop_Start


Script_End:
	xor ecx,ecx
	call ExitProcess

_startFizzBuzz4 ENDP


Print_Fizz1 PROC
	mov r9d,edx
	mov rdx,rcx
	mov r8d,r9d

	sub rsp, 28h
	Call Consol_Print1
	add rsp, 28h

	ret
Print_Fizz1 ENDP


Print_Buzz1 PROC
	mov r9d,edx
	mov rdx,rcx
	mov r8d,r9d

	sub rsp, 28h
	call Consol_Print1
	add rsp, 28h

	ret
Print_Buzz1 ENDP


New_Line1 PROC
	mov r9d,edx
	mov rdx,rcx
	mov r8d,r9d

	sub rsp, 28h
	Call Consol_Print1
	add rsp, 28h

	ret
New_Line1 ENDP


Test_51 PROC
	mov rax,rcx
	mov r10,5
	xor rdx,rdx
	div r10
	test rdx,rdx
	jnz Skip_Print_Buzz
	lea rcx,buz
	mov edx,lenbuz

	sub rsp, 28h
	call Print_Buzz1
	add rsp, 28h

Skip_Print_Buzz:
	ret

Test_51 ENDP


Consol_Print1 PROC
	mov rcx, r14
	lea r9,written

	sub rsp, 28h
	mov qword ptr [rsp+20h],0
	call WriteFile
	add rsp, 28h
	ret
Consol_Print1 ENDP


END