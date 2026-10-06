option casemap:none

extern GetStdHandle:proc
extern WriteFile:proc
extern ExitProcess:proc

STD_OUTPUT_HANDLE equ -11

.data
msg db "Hello, stdout!",13,10
len equ $ - msg
written dq 0

.code
_start PROC

	mov rcx, STD_OUTPUT_HANDLE
	call GetStdHandle

	mov rcx,rax
	lea rdx,msg
	mov r8d, len
	lea r9, written

	sub rsp, 28h
	mov qword ptr [rsp+20h],0
	call WriteFile
	add rsp, 28h

	xor ecx,ecx
	call ExitProcess
	ret
_start ENDP

END
