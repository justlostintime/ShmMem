// build this example using the included
// bash script buildCExample

#include <unistd.h>
#include <sys/syscall.h>

typedef struct {
  long result;               // since we use syscall to stop thread then input structur's first field will be result
  long count;                // number of times to loop
  char *msg;                 // message to be displayed
  long writeLen;             // The returned number of characters to write
} mys;

// void showMsg(char *msg, int length);
// int stringlength(char *msg);

void threadEntry(mys *data) {
  int y;
  //  void * wrtit = &showMsg;
  //  void * slen  = &stringlength;

  //  int strit = stringlength(data->msg);
  stringlength:
  int strit = 0;
  char *ptr = data->msg;
  while(strit < 256) {
    if(*ptr == 0) break;
    strit++;
    ptr++;
  }

  data->writeLen = strit;

  for(y=1; y <= data->count; y++) {
    data->result=y;

    //    showMsg(data->msg, strit); Write the message out using the system call
    showMsg:
    unsigned long syscall_nr = 1;  SYS_write;
    unsigned long  stdout_nr = 1;
    unsigned long len_parm = strit;

    asm ("movq %0, %%rax\n"
      "movq %1, %%rsi\n"
      "movq %2, %%rdx\n"
      "movq %3, %%rdi\n"
      "syscall"
      : /* output parameters, we aren't outputting anything, no none */
      /* (none) */
      : /* input parameters mapped to %0 and %1, repsectively */
      "m" (syscall_nr), "m" (data->msg), "m" (len_parm), "m" (stdout_nr)
      : /* registers that we are "clobbering", unneeded since we are calling exit */
    "rax", "rdi", "rsi", "rdx");
  }

// Exit the program using a system call
  unsigned long syscall_nr = 60;
  long exit_status = 42;

  asm ("movq %0, %%rax\n"
    "movq %1, %%rdi\n"
    "syscall"
    : /* output parameters, we aren't outputting anything, no none */
    /* (none) */
    : /* input parameters mapped to %0 and %1, repsectively */
    "m" (syscall_nr), "m" (exit_status)
    : /* registers that we are "clobbering", unneeded since we are calling exit */
  "rax", "rdi");
}

/* these must be inline to create a relocatable static binary
inline void showMsg(char *msg, int length){
  unsigned long syscall_nr = 1;  SYS_write;
  unsigned long  stdout_nr = 1;
  unsigned long len_parm = length;

  asm ("movq %0, %%rax\n"
    "movq %1, %%rsi\n"
    "movq %2, %%rdx\n"
    "movq %3, %%rdi\n"
    "syscall"
    : // output parameters, we aren't outputting anything, no none
    // (none)
    : // input parameters mapped to %0 and %1, repsectively
    "m" (syscall_nr), "m" (msg), "m" (len_parm), "m" (stdout_nr)
    : // registers that we are "clobbering", unneeded since we are calling exit
  "rax", "rdi", "rsi", "rdx");

  return;
}

inline int stringlength(char *msg) {
  int count = 0;
  char *ptr = msg;
  while(count < 256) {
    if(*ptr == 0) break;
    count++;
    ptr++;
  }
  return 8;
}
*/