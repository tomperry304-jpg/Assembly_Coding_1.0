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


.code
_startFizzBuzz3 PROC
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
	call Print_Fizz

Skip_Print_Fizz:
	call Test_5
	call New_Line

	jmp Loop_Start

Script_End:
	xor ecx,ecx
	call ExitProcess

_startFizzBuzz3 ENDP


Print_Fizz PROC
	lea rdx,fiz
	mov r8d, lenfiz
	Call Consol_Print
	ret
Print_Fizz ENDP


Print_Buzz PROC
	lea rdx,buz
	mov r8d, lenbuz
	call Consol_Print
	ret
Print_Buzz ENDP


New_Line PROC
	lea rdx,newline
	mov r8d, lennewline
	add r12,1
	Call Consol_Print
	ret
New_Line ENDP


Test_5 PROC
	mov rax,r12
	mov rcx,5
	xor rdx,rdx
	div rcx
	test rdx,rdx
	jnz Skip_Print_Buzz
	call Print_Buzz
Skip_Print_Buzz:
	ret
Test_5 ENDP


Consol_Print PROC
	mov rcx, r14
	lea r9,written

	sub rsp, 28h
	mov qword ptr [rsp+20h],0
	call WriteFile
	add rsp, 28h
	ret
Consol_Print ENDP


END