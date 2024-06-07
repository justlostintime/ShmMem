# ShmMem

Gambas3 Component to Use Linux Shared Memory Functions

This can be used to store any valid gambas object or variable type.
Allows the use of both named and un-named shared 
memory segments. This allows fast communicate between local tasks or applications
on a machine. Changes in variables can be used to trigger notifications to
apps/task having registerd for those notifications.

This is the next iteration of the Gambas 3 shared memory component. It is targeted at the 
gambas 3.19 and forward. If you need Shared memory for earlier versions please see the 
SharedMemory component containded in this repository.

This version moves to create a symbol table using local hash functions

Run the demo by
1) Project->make executable
2) right click on Data->Demo directory
3) Select -> open in file manager
4) In your file manger open a terminal for each demo user
5) run ./demo_user1, 2 and 3
6) enter variable change to user1 screen, see all terminals change
