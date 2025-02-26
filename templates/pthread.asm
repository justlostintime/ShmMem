USE64

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
  push rdx
  push rsi

  lea rsi,[msg_start]
  mov rdx,msg_start_len
  call writeMsg

  mov rax, SYS_open
  lea rdi, [log]
  mov rsi, WRONLY or CREAT or APPEND
  mov rdx, 0660o
  syscall

  test rax,rax
  jnl  continueWrite
  push rax

  lea rsi,[err_open_failed]
  mov rdx, err_open_failed_len
  call writeMsg

  pop  rdi
  jmp  quickExit

continueWrite:

  mov rdi,rax
  push rdi                ; rdi contains the file descriptor

  mov rax, SYS_write
  lea rsi, [data_msg]
  mov rdx, data_msg_len
  syscall

  pop rdi
  push rdi
  mov rax, SYS_fsync
  syscall

  pop rdi
  mov rax, SYS_close
  syscall

  pop rsi
  pop rdx

  mov rdi, 0         ; no error

quickExit:
  push rdi

  lea rsi,[msg]
  mov rdx,msg_len
  call writeMsg

  pop rdi
  mov rax, SYS_exit
  syscall

writeMsg:
  mov rax,SYS_write
  mov rdi,1
  syscall
  ret

msg_start db 10,"Begin the thread!",10
msg_start_len =  $-msg_start

msg db "It worked",10
msg_len = $ - msg

log db "/home/brian/Desktop/bin_log.log",0
log_len = $-log

data_msg db "this is a data message",10
data_msg_len = $-data_msg

err_open_failed db "Open of log failed",10
err_open_failed_len = $ - err_open_failed
