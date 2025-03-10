USE64
; requires fasm fast assembler to assemble this file correctly

SYS_exit  equ 60
SYS_close equ 3
SYS_open  equ 2
SYS_write equ 1
SYS_fsync equ 0x76

STDIN  = 0
STDOUT = 1
STDERR = 2

ACCMODE = 0x03
RDONLY  = 0x00
WRONLY  = 0x01
RDWR    = 0x02
CREAT   = 0x40
APPEND  = 0x400
EXCL    = 0x80

main:
  push rbx
  
  mov  r12,rdi            ; save the string address
  
  cmp rdi,0               ; if it is a null message then dont write anything
  je  NullMessage
  
  mov rsi,rdi
  call strlen
  mov  r15,rax
  mov rdx,rax
  call writeMsg

  mov rax, SYS_open
  lea rdi, [log]
  mov rsi, WRONLY or CREAT or APPEND
  mov rdx, 0660o
  syscall

  test rax,rax
  jnl  continueWrite
  mov r13, rax                    ; get the error number

  lea rsi,[err_open_failed]
  mov rdx, err_open_failed_len
  call writeMsg
  jmp  quickExit

continueWrite:

  mov r14,rax                     ; preserve the file descriptor

  mov rax, SYS_write
  lea rsi, [data_msg]
  mov rdx, data_msg_len
  syscall
  
  mov rdi,r14
  mov rax, SYS_fsync
  syscall

  mov rdi,r14
  mov rax, SYS_close
  syscall

NullMessage:

  mov r13, 0              ; no error

quickExit:

  cmp r15,0               ; check if it is a null message
  je  NoExitMsg
  
  lea rsi,[msg]
  mov rdx,msg_len
  call writeMsg
  
NoExitMsg:

  pop rbx
  
  mov rdi,r13
  mov rax, SYS_exit
  syscall

writeMsg:
  cmp rsi,0             ; check for null pointer
  je NoMessage          ; skip write if it is
  mov rax,SYS_write
  mov rdi,1
  syscall
NoMessage:
  ret

strlen:
    xor rax, rax        ; loop counter
    cmp rsi, 0          ; check if null pointer passed
    je  strlencomplete  ; return 0 length if no message found
    
startLoop:
    xor dx, dx
    mov dl, byte [rsi+rax]
    cmp dl, 0x0    ; null byte
    je  strlencomplete
    inc rax
    jmp startLoop

strlencomplete:
    ret

msg_start db 10,"Begin the thread!",10
msg_start_len =  $-msg_start

msg db "It worked For ASM String",10
msg_len = $ - msg

log db "/tmp/shm_exec.log",0
log_len = $-log

data_msg db "this is a data Pass String",10
data_msg_len = $-data_msg

err_open_failed db "Open of log failed",10
err_open_failed_len = $ - err_open_failed
