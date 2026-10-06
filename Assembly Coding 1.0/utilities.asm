option casemap:none

extern GetStdHandle:proc
extern WriteFile:proc
extern ExitProcess:proc

STD_OUTPUT_HANDLE equ -11

.code

; console_print - print a string of known length to the console
; inputs:
;  rcx - pointer to the string
;  rdx - length of the string

console_print PROC

	; prologue - set up frame pointer, save registers and reserve shadow space
	push rbp
	mov rbp, rsp
	push rcx
	push rdx
	sub rsp, 8 ; keep stack aligned

	; call to GetStdHandle
	mov rcx, STD_OUTPUT_HANDLE
	call GetStdHandle ; stdout handle is now in rax

	; call to WriteFile
	mov rcx, rax       ; arg1: stdout handle
	mov rdx, [rbp-8]  ; arg2: pointer to message
	mov r8, [rbp-16]  ; arg3: length of message
	sub rsp, 10h
	lea r9, [rsp]  ; arg4: pointer to written buffer
	mov qword ptr [r9],0
	sub rsp, 20h   ; shadow store
	call WriteFile
	add rsp, 30h

	; epilogue - unwind the prolog steps
	add rsp, 8
	pop rdx
	pop rcx
	pop rbp

	ret
console_print ENDP

END
