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
_startFizzBuzz PROC
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
	jz Print_Fizz

Test_5:
	mov rax,r12
	mov rcx,5
	xor rdx,rdx
	div rcx
	test rdx,rdx
	jz Print_Buzz

New_Line:
	lea r13, Loop_Start
	lea rdx,newline
	mov r8d, lennewline
	add r12,1
	jmp Consol_Print

Print_Fizz:
	lea r13, Test_5
	lea rdx,fiz
	mov r8d, lenfiz
	jmp Consol_Print

Print_Buzz:
	lea r13, New_Line
	lea rdx,buz
	mov r8d, lenbuz
	jmp Consol_Print



Consol_Print:
	mov rcx, r14
	lea r9,written

	sub rsp, 28h
	mov qword ptr [rsp+20h],0
	call WriteFile
	add rsp, 28h

	jmp r13

Script_End:
	xor ecx,ecx
	call ExitProcess

_startFizzBuzz ENDP
END