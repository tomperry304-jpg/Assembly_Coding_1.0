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
filename db "2025_day1_input.txt", 0
err_msg db "error opening file"
err_len equ $ - err_msg

buffer db 65536 dup(0)
instruction db 16 dup(0)
bytesRead dq 0
fileHandle dq 0

.code
Day1_Code_2025 PROC
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


mov r12,50 ;r12 is the register that indicats current dial value (starting at 50)
xor r14,r14 ;zero counter for code
xor rbx,rbx ;length of instruction block


mov r13,bytesRead
lea rsi,buffer
lea r15,instruction
Read_Characters:
	cmp r13,0
	jz Script_End
	
	mov al,[rsi] ;al = the charater we want to read
	;prossec al hear
	cmp al,10
	jnz Skip_Execution_call
	;mov BYTE PTR [r15],0

	sub rsp, 28h
	lea rcx,instruction
	mov rdx,rbx
	Call Instruction_Execute
	add rsp, 28h
	lea r15,instruction ;recets instruction pointer

	
	inc rsi ;skiping the 10 of "13","10"
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

Day1_Code_2025 ENDP



Instruction_Execute Proc
; r12 is input and output, represents the dial position
  
xor r8,r8 ;current count
mov r9,1 ;current multiplyer
mov r10,10
mov r11,100

add rcx,rdx ;move stack pointer to the end of the instruction (we will be reading it backwards)
dec rcx
Loop_Start:
xor rax, rax    ; rax is used to read the character
mov al,[rcx]	; move 1 byte into RAX register
dec rcx

cmp al, 'R'
jz Summing

cmp al, 'L'
jz Subtracting

sub al, '0' ; convert character digit to number
imul rax,r9 ; scale number by current multiplier
add r8,rax 
imul r9,r10 ; multiplier times by 10

jmp Loop_Start

Summing:
add r12,r8
mov rax,r12
xor rdx,rdx
div r11
mov r12,rdx
jmp Execute_End

Subtracting:
sub r12,r8

mov rax,r12
cqo
idiv r11
cmp rdx,0
jl Overflow
mov r12,rdx
jmp Execute_End

Overflow:
add rdx,100
mov r12,rdx

Execute_End:
cmp r12,0
jnz Return
inc r14

Return:
	ret
Instruction_Execute ENDP

END