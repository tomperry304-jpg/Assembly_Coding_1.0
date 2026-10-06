;data section
option casemap:none

extern CreateFileA:proc
extern ReadFile:proc
extern CloseHandle:proc
extern ExitProcess:proc
extern console_print: proc

GENERIC_READ            equ 80000000h
OPEN_EXISTING           equ 3
FILE_ATTRIBUTE_NORMAL   equ 80h
INVALID_HANDLE_VALUE    equ -1

.data
filename db "2022_day3_input.txt", 0
err_msg db "error opening file"
err_len equ $ - err_msg

buffer db 65536 dup(0)
instructionblock db 128 dup(0)
bytesRead dq 0
fileHandle dq 0

.code
Day3_Code_2022 PROC
;open the file (calling Creatfile)
sub rsp, 38h
lea rcx, filename ;1st arg
mov edx, GENERIC_READ ;2nd arg
xor r8d, r8d ;3rd arg
xor r9d, r9d ;4th arg
mov qword ptr [rsp+20h], OPEN_EXISTING ;5th arg
mov qword ptr [rsp+28h], FILE_ATTRIBUTE_NORMAL ;6th arg
mov qword ptr [rsp+30h], 0 ;7th arg (null)

call CreateFileA ; call function (filehandle in rax)
add rsp, 38h ;clear stack


mov fileHandle, rax ;save filhandle

;check if opening file failed
cmp rax, INVALID_HANDLE_VALUE
jne file_ok

lea rcx, [err_msg]
mov rdx, err_len
call console_print 
; write error message
jmp Script_End

file_ok:

;readfile (calling readfile)
sub rsp, 28h

mov rcx, fileHandle ;1st arg
lea rdx, buffer ;2nd arg
mov r8d, 65535 ;3rd arg
lea r9, bytesRead ;4th arg
mov qword ptr [rsp+20h], 0 ;5th arg

call ReadFile
add rsp, 28h
;input data inside buffer
;file size inside bytsRead

;closing the file (call CloseHandle)
sub rsp, 28h
mov rcx, fileHandle ;1st arg
call CloseHandle
add rsp, 28h


xor r12,r12 ;r12 is the priority sum (final output)
xor r14,r14 ;zero counter for code
xor rbx,rbx ;length of instruction block


mov r13,bytesRead
lea rsi,buffer
lea r15,instructionblock
Read_Characters:
	cmp r13,0
	jz Script_End
	
	mov al,[rsi] ;al = the charater we want to read
	;prossec al hear
	cmp al,10
	jnz Skip_Execution_call
	;mov BYTE PTR [r15],0

	sub rsp, 28h
	lea rcx,instructionblock
	mov rdx,rbx
	Call Instruction_Execute
	add rsp, 28h
	lea r15,instructionblock ;recets instruction pointer

	
	inc rsi
	dec r13
	
	xor rbx,rbx
	jmp Read_Characters

	Skip_Execution_call: ;write the next character into instruction block
	mov BYTE PTR [r15], al
	inc r15
	inc rsi
	dec r13
	inc rbx
	jmp Read_Characters

Script_End:
xor ecx,ecx
sub rsp,28h
call ExitProcess

Day3_Code_2022 ENDP



Instruction_Execute Proc
; rcx - pointer to instruciton block
; rdx - length of instruction block
mov r8,2
mov rax,rdx
xor rdx,rdx
div r8 ;rax = hlaf length of instruciton block = rucsack sec 1
mov r10,rax


;65 to 90 for uppercase letters and 97 to 122 for lowercase letters

lea rcx,instructionblock
mov rdx,r10 ;read length
call Letters_Log
mov r11,rax

;update pointers to second half
lea rcx,instructionblock
mov rdx,r10 ;read length
add rcx,r10 ;shift to second half of instruction block
call Letters_Log




;add both letter log blocks
and r11,rax
mov rcx,r11
call Bitwise_summation
add r12,rax
ret
Instruction_Execute ENDP


Letters_Log PROC
;rcx = pointer to instruction start
;rdx = instruction read length

;rax = the register with bit log in
xor r8,r8 ;clear r8,r9


Loop_Start:
cmp rdx,0
jz End_of_loop
mov al,[rcx]	; move 1 byte into RAX register corrispondig to lower or upercase letter
inc rcx
dec rdx

;65 to 90 for uppercase letters and 97 to 122 for lowercase letters
cmp al,91
jl Uppercase
sub al,97
jmp Memory_Update

Uppercase:
sub al,39

Memory_Update:
push rcx

mov r9,1
mov cl,al
shl r9,cl
or r8,r9

pop rcx

jmp Loop_Start

End_of_loop:
mov rax,r8
ret
Letters_Log ENDP


Bitwise_summation PROC
;rcx binary register to be sumed (in)
;summed bitwise position of all 1ns (+1) since zero start
mov rdx,64
mov r8,8000000000000000h
xor rax,rax
Loop_Start:
	cmp rdx,0
	jz Loop_end
	test rcx,r8
	jz Skip_Bit
	add rax,rdx


	Skip_Bit:
	dec rdx
	shr r8,1
	jmp Loop_Start

Loop_end:
ret
Bitwise_summation ENDP


END