option casemap:none

extern GetStdHandle:proc
extern WriteFile:proc
extern ExitProcess:proc

STD_OUTPUT_HANDLE equ -11

.data
fiz db "Fizz",13,10
lenfiz equ $ - fiz

buz db "Buzz",13,10
lenbuz equ $ - buz

fizbuz db "FizzBuzz",13,10
lenfizbuz equ $ - fizbuz
written dq 0


.code
_startFizzBang PROC
	mov rcx, STD_OUTPUT_HANDLE
	sub rsp, 28h
	call GetStdHandle
	add rsp, 28h

	mov r13, rax        ; save stdout handle

; r12 is the loop index
mov r12,1
Loop_Start:
	cmp r12,100
	jg Script_End ;if greater then jump to end

	mov rax,r12
	mov rcx,5
	xor rdx,rdx
	div rcx
	mov r9, rdx ;remainder of r12/5 in r9

	mov rax,r12
	mov rcx,3
	xor rdx,rdx
	div rcx
	mov r10, rdx ; remainder of r12/3 in r10

	mov r11,r9
	add r11,r10 
	jz Print_Fizzbuz


	test r9,r9
	jz Print_Buzz


	test r10,r10
	jz Print_Fizz


	;lea rdx,r12
	add r12,1
	jmp Loop_Start

Print_Fizzbuz:
	lea rdx,fizbuz
	mov r8d, lenfizbuz
	jmp Consol_Print

Print_Fizz:
	lea rdx,fiz
	mov r8d, lenfiz
	jmp Consol_Print

Print_Buzz:
	lea rdx,buz
	mov r8d, lenbuz
	jmp Consol_Print

Consol_Print:
	mov rcx, r13

	;lea rdx,msg

	;mov r8d, len
	lea r9, written

	sub rsp, 28h
	mov qword ptr [rsp+20h],0
	call WriteFile
	add rsp, 28h

	
	add r12,1
	jmp Loop_Start

Script_End:
	xor ecx,ecx
	call ExitProcess

_startFizzBang ENDP
END





