// build this example using the included
// bash script buildCExample

#include <unistd.h>
#include <sys/syscall.h>

typedef struct {
  long result;
  long count;
  char *msg;
} mys;

void threadEntry(mys *data) {
  data->result = 89;
 /*
  __asm__("pop %rbp\n\t"
          "mov %rdi,0x0\n\t"
          "mov %rax,60\n\t"
          "syscall\n\t");
*/
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
