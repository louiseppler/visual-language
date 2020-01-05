SECTION .data
msgd        db      '##'


SECTION .bss
sinput:     resb    255                                 ; reserve a 255 byte space in memory for the users input string


SECTION .text
global  start

start:
   ;read
   push rax
   call getinput
   mov  r8, rax
   pop  rax

   ;define number
   mov  r9, 20

   ;divide
   push rsi
   push rax

   push r9
   push r8
   pop rax
   pop rsi
   call divide
   push rax
   pop r8

   pop  rax
   pop  rsi


   ;print
   push rax
   mov  rax, r8
   call iprintLF
   pop  rax

   call exit

;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

getinput:
  push rdx
  push rdi
  push rsi

  mov     rdx, 255        ; number of bytes to read
  mov     rsi, sinput     ; reserved space to store our input (known as a buffer)
  mov     rdi, 0          ; write to the STDIN file
  mov     rax, 0x2000003  ; invoke SYS_READ (kernel opcode 3)
  syscall



atoi:
    mov     rsi, 0
    push    r8
    push    r10
    mov     rax, 0
    mov r8, sinput

.multiplyLoop:
    mov     rdi, 0
    mov     dil, [r8+rsi]   ; move a single byte into ebx register's lower half

    cmp     dil, 48          ; compare ebx register's lower half value against ascii value 48 (char value 0)
    jl      .finished
    cmp     dil, 57          ; compare ebx register's lower half value against ascii value 57 (char value 9)
    jg      .finished
    cmp     dil, 10          ; compare ebx register's lower half value against ascii value 10 (linefeed character)
    je      .finished
    cmp     dil, 0           ; compare ebx register's lower half value against decimal value 0 (end of string)
    jz      .finished

    sub     dil, 48          ; convert ebx register's lower half to decimal representation of ascii value
    add     rax, rdi
    mov     rdi, 10
    mul     rdi
    inc     rsi
    jmp     .multiplyLoop


.finished:
    push    rsi
    mov     rsi, 10
    div     rsi             ; divide eax by value in ebx (in this case 10)

    pop     rsi
    pop     r10
    pop     r8

    pop rsi
    pop rdi
    pop rdx

    ret
;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

; void iprint(Integer number)
; Integer printing function (itoa)
iprint:
    push    rax
    push    rsi
    push    rdx
    push    rdi
    push    r8
    mov     rsi, 0

divideLoop:
    inc     rsi             ; count each byte to print - number of characters
    mov     rdx, 0          ; empty edx
    mov     r8, 10         ; mov 10 into esi
    idiv    r8             ; divide eax by esi
    add     rdx, 48         ; convert edx to it's ascii representation - edx holds the remainder after a divide instruction
    push    rdx             ; push edx (string representation of an intger) onto the stack
    cmp     rax, 0          ; can the integer be divided anymore?
    jnz     divideLoop

printLoop:
    dec     rsi             ; count down each byte that we put on the stack
    mov     rax, rsp        ; mov the stack pointer into eax for printing
    call    sprint
    pop     rax
    cmp     rsi, 0          ; have we printed all bytes we pushed onto the stack?
    jnz     printLoop

    pop     r8
    pop     rdi
    pop     rdx
    pop     rsi
    pop     rax
    ret

    ;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  ; void iprintLF(Integer number)
  ; Integer printing function with linefeed (itoa)
  iprintLF:
    call    iprint

    push    rax
    mov     rax, 0Ah        ; move 0Ah into eax - 0Ah is the ascii character for a linefeed
    push    rax             ; push the linefeed onto the stack so we can get the address
    mov     rax, rsp        ; move the address of the current stack pointer into eax for sprint
    call    sprint          ; call our sprint function
    pop     rax             ; remove our linefeed character from the stack
    pop     rax             ; restore the original value of eax before our function was called
    ret


;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  slen: ;msg location at rax -> places leng at rdx
    push rdi
    mov rdi, rax

  nextchar:
    cmp byte [rax], 0
    jz finished
    inc rax
    jmp nextchar

  finished:
    sub rax, rdi ;subtrace two addresses -> bytes inbetween
    ;;mov rdx, rax ; length of msg
    pop rdi
    ret

;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  exit:
     ; Exit code
     mov rax, 0x2000001 ; exit
     mov rdi, 0
     syscall

;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  sprint: ;prints
  ;;  mov rax, msg ;orinial point of msg
    push rdx
    push rdi
    push rsi
    push rax
    call slen

    ;mov rdx, rax
    mov rdx, rax
    pop rax

    mov rsi, rax
    mov rax, 0x2000004 ; write
    mov rdi, 1 ; stdout
    ;mov rsi, msg
    syscall

    pop rsi
    pop rdi
    pop rdx
    ret
;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  sprintLF:
    call    sprint
    push    rax
    mov     rax, 0Ah    ; move 0Ah into eax - 0Ah is the ascii character for a linefeed
    push    rax
    mov     rax, rsp    ; move the address of the current stack pointer into eax for sprint
    call    sprint      ; call our sprint function
    pop     rax
    pop     rax
    ret
;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  ;divide
  divide:
    push rdx
    xor  rdx, rdx
    div  rsi
    mov  rsi, rdx
    pop rdx
    ret
;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    debugg:
    push rdx
    push rdi
    push rsi
    push rax

    mov rax, 0x2000004 ; write
    mov rdi, 1 ; stdout
    mov rsi, msgd
    mov rdx, 3
    syscall

    pop rax
    pop rsi
    pop rdi
    pop rdx
    ret
