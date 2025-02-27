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

RepeatCount = 8
StringPtr = 16
resultValue = 0

main:

  push rdi     ; save the first parameter passed

;*******************************************************************
; write the startup message
;*******************************************************************
  lea rsi,[msg_start]
  mov rdx,msg_start_len
  call writeMsg

;*******************************************************************
; Look at the structure passed and read the time to display
; and get the message to display and calc length
;*******************************************************************

  mov rsi,[rdi+StringPtr]      ; point to the message
  call strlen                  ; calculate the length and return inrax
  mov rdx,rax                  ; get the length of the string
  mov rax,[rdi+RepeatCount]    ; Get the number of times to print a message

;*******************************************************************
; print the message the number of time presented
;*******************************************************************
doloop:
  cmp rax,0x0
  je  cont1
  call writeMsg
  dec rax
  jmp doloop

;*******************************************************************
; Write a log entry for this jit blob
;*******************************************************************
cont1:
  mov rax, SYS_open
  lea rdi, [log]
  mov rsi, WRONLY or CREAT or APPEND
  mov rdx, 0660o
  syscall

  test rax,rax
  jnl  continueWrite

;*******************************************************************
; if the open failed then print an error message
;*******************************************************************
  push rax                              ; save the returned error code
  lea rsi,[err_open_failed]             ; write the error message
  mov rdx, err_open_failed_len
  call writeMsg

  pop  rdi                               ; pop rax return code to rdi
  jmp  quickExit

;*******************************************************************
; if no error then continue
;*******************************************************************
continueWrite:

  mov rdi,rax                ; mov the file descriptor to rdi for call
  push rdi                   ; rdi contains the file descriptor

  mov rax, SYS_write
  lea rsi, [data_msg]
  mov rdx, data_msg_len
  syscall

  pop rdi                   ; Get the saved fd from stack
  push rdi                  ; save it for next call
  mov rax, SYS_fsync        ; force flush of buffer
  syscall

  pop rdi                   ; get the fd for file close call
  mov rax, SYS_close        ; close the file
  syscall

  mov rdi, 0         ; no error

quickExit:
  push rdi              ; save the result from the last call

  lea rsi,[msg]
  mov rdx,msg_len
  call writeMsg

  pop rax               ; rdi is the value returned on exit in rax

;*******************************************************************
; exit the thread using sys exit call
; since we are using sys exit pthread does not return anything
; as we do not call pthread_exit
; So the passed structure has a result field in this example a long value
;*******************************************************************

  cmp rax, 0                     ; if it is zero then everything worked
  jne setresult                  ; if not then return error code
  mov rax, 89                    ; our special code to know we set return value

setresult:
  pop rsi                        ; get the address of the structure originally saved
  mov [rsi+resultValue], rax     ; save the value to the structure
  xor  rdi,rdi                   ; set exit return code to zero
  mov rax, SYS_exit
  syscall

;*******************************************************************
; Write message
;*******************************************************************
writeMsg:
  push rax
  push rdi

  mov rax,SYS_write
  mov rdi,1
  syscall

  pop rdi
  pop rax

  ret

;*******************************************************************
; String Length
; Input is pointer in rsi, out put is length in rax
;*******************************************************************
strlen:
    xor rax, rax        ; loop counter

startLoop:
    xor dx, dx
    mov dl, byte [rsi+rax]
    inc rax

    cmp dl, 0x0    ; null byte
    jne startLoop
    dec rax
    ret

;*******************************************************************
; Data section
;*******************************************************************
msg_start db 10,"Begin the thread for structure",10
msg_start_len =  $-msg_start

msg db "It worked",10
msg_len = $ - msg

log db "/home/brian/Desktop/bin_log.log",0
log_len = $-log

data_msg db "this is data for a structure",10
data_msg_len = $-data_msg

err_open_failed db "Open of log failed",10
err_open_failed_len = $ - err_open_failed
