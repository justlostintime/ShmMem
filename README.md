# ShmMem

Gambas3 Component to Use Linux Shared Memory Functions

This can be used to store any valid gambas object or variable type.
This allows the use of bothd named and un-named shared 
memory segments, and can be used to communicate between local tasks or applications in a machine.

This is the next iteration of the Gambas 3 sharedmem component. It is targeted at the 
gambas 3.18 and forward. If you need Shared memory for earlier versions please see the 
SharedMemory component containded in this repository.

This version moves to create a symbol table using local hash functions
