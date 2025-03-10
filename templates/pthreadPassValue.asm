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

  mov r15,rdi
  mov rax,rdi
  lea rsi,[msg_start]
  mov rdx, msg_start_len

msgloop:
  cmp rax , 0x0
  je  msgLoopDone
  call writeMsg
  dec rax
  jmp msgloop

msgLoopDone:
  cmp r15,0x0
  je  NoMessages
  
  mov rax, SYS_open
  lea rdi, [log]
  mov rsi, WRONLY or CREAT or APPEND
  mov rdx, 0660o
  syscall

  mov  r13,rax              ; get result
  test rax,rax
  jnl  continueWrite
  
  lea rsi,[err_open_failed]
  mov rdx, err_open_failed_len
  call writeMsg
  jmp  quickExit

continueWrite:

  mov rdi, r13
  mov rax, SYS_write
  lea rsi, [data_msg]
  mov rdx, data_msg_len
  syscall

  mov rdi,r13
  mov rax, SYS_fsync
  syscall

  mov rdi,r13
  mov rax, SYS_close
  syscall
  
NoMessages:
  mov r13, 0         ; no error

quickExit:
  cmp r15,0x0        ; if we write it 0 times then skip end msg
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
  cmp  rsi,0x0
  je   NoWrite
  cmp  rdx,0x0
  je   NoWrite
  push rax
  push rdi
  push rdx

  mov rax,SYS_write
  mov rdi,1
  syscall

  pop rdx
  pop rdi
  pop rax
  
NoWrite:
  ret

strlen:
    push rdx
    xor rax, rax        ; loop counter
    cmp rsi,0x0         ; null pointer then return 0 length
    je  NoLength
startLoop:
    xor dx, dx
    mov dl, byte [rsi+rax]
    inc rax
    cmp dl, 0x0    ; null byte
    jne startLoop
    dec rax
NoLength:
    pop rdx
    ret

msg_start db 10,"Begin the thread ?: Passing by value",10," so loop provided times",10
msg_start_len =  $-msg_start

msg db "It worked for ASM Value ",10
msg_len = $ - msg

log db "/tmp/shm_exec.log",0
log_len = $-log

data_msg db "this is a data message Pass by value",10
data_msg_len = $-data_msg

err_open_failed db "Open of log failed",10
err_open_failed_len = $ - err_open_failed
