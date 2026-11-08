<!-- Copy of the ShmMem wiki, https://github.com/justlostintime/ShmMem/wiki -->

# Home

Welcome to the ShmMem wiki!

ShmMem is a shared memory library allowing the user to utilize Linux's Shared memory feature.

An installable version may be found at justlostintime/ppa repository.

# Introduction

# ShmMem project
ShmMem is a shared memory library allowing the user to utilize Linux's Shared memory feature. 

Implemented in this library is the useful constructs of Arrays, Lists, Fifo/Filo, Queues, prioritized queue's.
The framework for the creation of custom Shared data types are also provided by this library.

Hopefully the user will find this Gambas3 library useful and the interface intuitive and simple to implement within projects.

This library is tested with with Gambas3 3.18 thru the current release.

# Implementation
The Shared memory library is implemented as a number of independent classes which may be used for many different purposes. Each class provides independent interfaces to manage blocks of memory at various levels. In some applications it may be faster to reference values at a lower level than provided by the high level user interface. 

## ShmMem class
This is the highest level user interface class. This instantiates each of the other classes and provided a unified user interface to the functionality.

## ShmMemBlock Class
This class actually creates the named  or unnamed memory segments. It implements the lowest level interface to the physical memory segments created. It implements the lock used to access the memory.

## ShmLock module
The robust, process shared, recursive mutexes used by the memory block, lists, queues and arrays. A lock held by a
process that dies is taken over by the next one, instead of waiting for ever.

## ShmManage class
This class implements the virtual memory address scheme and manages the allocations at the lowest level, Servicing the higher levels calls to allocated and freed memory blocks. It manages the free list and the allocated list. Responsible to maintain as much as possible unfragmented memory blocks.

## ShmVarStorage class
This implements the concept of variable values. It manages the storage and retrieval of values_types from the Managed memory. It manages and knows about the way different types of values are stored and retrieved. I manages the Custom Data Types used by the Shared memory environment.

## ShmSymbolTable Class
This Allows the user to manage variable values through a shared symbol table. It uses the Var Storage interface to store and retrieve value associated with Symbol names. This is implemented as a hash table with buckets.

# Installation

This library is available for installation from the project source in this repository or in binary form at [JustLostInTime/PPA](https://github.com/justlostintime/ppa)

This project can also be downloaded from the Gambas Farm server :  ShmMem project

This library Also requires the gb.eval component, used for accessing gambas classes and evaluating import and export expresions covered later in this document.

The current version is 2.1 

# Interface

# Description
   The class object is created by the following calls. The Shared memory segments will be deleted after the last App/task accessing it closes. The Segments are closed by the individual app/task when the last object reference is deleted. Within the shared segment memory is accessed and read through a virtual address space. This allows the relocation of the segment during program execution. An Application can create an number of Shared memory segments, each having it's own Symbols and storage memory.

# Interface
## Creating a new Shared memory segment
A memory segment may be created in a number of ways, By name or Just local to The app and its tasks.

## Named Memory
Shared named memory segments may be created and accessed by using the Assigned name by all application having the correct permissions. The named segments are created at the time of instantiation of the ShmMem class. Two Actual named segments are created the symbol table and the variable memory storage area.

### Definition Long
MyMemory = ShmMem(Memory_Length, Segment_name, Number_Of_Symbols,Locking_timeout, isExecutable , setPermissions )
* Memory Length     - Defaults to 20000000 bytes (20 MB). This is the length of the variable memory made available to users program
* Segment Name      - This is a string used to name the segment. Two actual segments will be created SegName_Data, SegName_Symbols
* Number of Symbols - Defaults to 8000. This is the maximum number of symbols supported by the allocated memory segment.
* Locking timeout   - Defaults to 0.1. Kept in the memory block (LockTimeout) and used by ExclusiveTimeout. The normal memory lock waits up to 30 seconds for a live holder, see [Locks](#locks-processes-and-errors).
* isExecutable      - Defaults to false. This will allow the loading of binary blobs, and execution of those blobs. Intended for JIT. See [Executable Blocks](https://github.com/justlostintime/ShmMem/wiki/Executable-Blocks)
* setPermissions    - Integer value used to set the permissions for the created segment. Defaults to &O660.or &0770 if executable

The number of symbols and locking timeout are optional for the call to create the class.

### Definition Short
MyMemory = ShmMem("Segment_name")
* Segment Name      - This is a string used to name the segment. Two actual segments will be created SegName_Data, SegName_Symbols
The segments created will assume the defaults listed above. In most cases this will be more than needed by most uses.

## Unnamed Memory
Unnamed memory segments may be shared by all tasks and the app creating it.

### Definition Long
MyMemory = new ShmMem(Memory Length, "", Max Number of symbols, LockTimeOut, isExecutable , setPermissions )
* Memory Length     - Defaults to 20000000 bytes (20 MB). This is the length of the variable memory made available to users program
* Segment Name ""   - Left Blank indicates unnamed segments
* Number of Symbols - Defaults to 8000. This is the maximum number of symbols supported by the allocated memory segment.
* Locking timeout   - Defaults to 0.1. Kept in the memory block (LockTimeout) and used by ExclusiveTimeout. The normal memory lock waits up to 30 seconds for a live holder, see [Locks](#locks-processes-and-errors).
* isExecutable      - Defaults to false. This will allow the loading of binary blobs, and execution of those blobs. Intended for JIT. See [Executable Blocks](https://github.com/justlostintime/ShmMem/wiki/Executable-Blocks)
* setPermissions    - Integer value used to set the permissions for the created segment. Defaults to &O660.or &0770 if executable.

Everything is optional  number of symbols and locking timeout are optional for the call to create the class.

### Definition Short
MyMemory = new ShmMem
The segments created will assume the defaults listed above. In most cases this will be more than needed by most users.

## Interface Calls
### Alloc
* Alloc(Size_needed) as Pointer
* Allocates a memory segment returning the virtual memory address to be used for the memory access.

### Close - Close and release shared memory resources
* Close()
* Close the shared memory segment when the application is exiting. This is required to prevent circular and unreleased memory blocks.

### Exist
* Exist("Symbol_Name") as boolean
* Tests for the existence of the symbol name requested returning true of false as appropriate.

### ForceDelete - Static 
* ForceDelete()
* This interface will force the deletion of old shared memory segments. Be careful as it will leave other tasks in a bad state.
* This is a class static function and does not require that an instance be created.

### Free Symbol/Virtual Memory
*  Free("Symbol_Name)
> *  Free the symbol name, from the Symbol table and release all allocated memory used by the symbols value.
*  Free(Virtual Address)
> * Free the virtual memory value, or allocated memory

### Get List Type - Static
* GetListType(VariableMemory, DataType) as Variant[]
* Returns a list of all allocated memory blocks of the provided memory type.
* This is a class static function and does not require that an instance be created.

### Get Memory Segment - static
GetMemorySegment(Signature) as shmmem
*  Look for the correct signature and return the appropriate shmmem object
*  if not found then return the default shmmem memory object which is the first one defined.
*  if no default set then return null if not found
*  Locate a shared memory block by signature as an object
*  This will be used by the _read functions in the Shm Classes to locate the correct memory block in which to instantiate the shmclass

### GetObjectClass - Static
* GetObjectClass(object) as class
* Returns an instance of the class of the object.
* This is a class static function and does not require that an instance be created.
* This is needed because modules return a class of class and require processing to get the actual class for the module.

### Load Mem Image
* LoadImage(optional "File_Name")
* Reads and loads/merges the image into shared memory.
* Error are reported during the load
* The image must have been saved by the SaveImage call
* If the file name is not provided then ApplicationName.image is used.

### Load Variable
* LoadVar("Symbol File path/Name", optional "Symbol Rename")
* "Symbol File path/Name" - Opens the the file and creates the updated/new symbol entry and value.
* Defaults to an name.extension of Name.var. by default used the base name of the file as the symbol name.
* optional "Symbol Rename" - The symbol will be created with this name not the base name of the file.

### Notify on Change of specific variable
* Notify("Symbol Name",ObjectToCall, Optional "Method to to call", Timeout As Float, "64 char tag name")
* "Symbol Name"       - The name of the symbol to be watched.
* Object to be called - The method default method is "SymbolName_notify"
* Optional Method To Call - this over rides the default Method name.
* Timeout - The time to wait for a variable change. Defaults to 0 = wait forever
* An application or task may request more than one notification for the same Symbol.
* event calls have the format myvar_notify(SymbolName, NewValue, IfTimedOut)
>> SymbolName - the name of the symbol which changed<br>
>> NewValue   - The new value of variable<br>
>> IfTimedOut - A true or false value<br>

### Notify Stop
* NotifyStop("Symbol Name",ObjectToCall, Optional "Method to to call", Optional "64 char tag name")
* This must be called with the same symbol, object, method and tag used in the notify call. This is because it is possible for an application to request notification more than once.
* Raises an error when there is no matching notify request for the symbol.
* See notify for details

### Notify on Change of any variable
* Notify([true|false],ObjectToCall, Optional "Method to to call")
* True - turn on notifications of any change, False - turn Notification off.
* Object to be called - The method default method is "SymbolName_notify"
* Optional Method To Call - this over rides the default Method name of OnAny_change.
* event calls have the format myvar_notify(SymbolName, NewValue, IfTimedOut)
>> SymbolName - the name of the symbol which changed<br>
>> NewValue   - The new value of variable<br>
>> IfTimedOut - A true or false value - not actually used here, but for constancy<br>

### Notify Get Queue
* NotifyQ("Symbol name") as shmList
* Returns a list of all tasks apps waiting for a symbol to change

### Notify On New Symbol
* NotifyOnNew(EnableDisable, ObjectToCall, Optional "Method to to call")
* Creates a notification when ever a new symbol is created.
* Enable/Disable - Enable = true, disable = false
* The default method is OnNew_Created(SymName, Value, TimedOut)


### Notify On Remove Symbol
* NotifyOnRemove(EnableDisable, ObjectToCall, Optional "Method to to call")
* Creates a notification when ever a symbol is Removed/Deleted.
* Enable/Disable - Enable = true, disable = false
* The default method is OnRemove_Created(SymName, Value, TimedOut)

### Print
* Print()
* list the Symbols in the symbol table
```
Symbol Table Listing
MaxLength = 3, Available Slots = 7990, Occupied Slots = 3,
Collisions = 0, Search Retry count = 0
Last Updated 0.002051937000942, Phy Address 7322AC23F000
   97:a                         : @00000005A6, Len       32, *Integer       , Value = 1
   98:b                         : @00000005C6, Len       32, *String        @00000005E6, Blk   1036, Len     12, Value=hello worl
 7706:#onnew                    : @0000000030, Len       32, *String        @0000000050, Blk   1062, Len     38, Value=Holding Qu
```

### Print All Info
* PrintAllInfo()
* Print Symbol info and Raw Storage memory
```
***************************************** Full Memory Info ***************************************************
Default Memory Size 20MB, Max Symbol Table entries 8000, Default Timeout 0.1


Symbol Table Listing
MaxLength = 3, Available Slots = 7990, Occupied Slots = 3,
Collisions = 0, Search Retry count = 0
Last Updated 0.003240845006076, Phy Address 7F0D746A3000
   97:a                         : @00000005A6, Len       32, *Integer       , Value = 1
   98:b                         : @00000005C6, Len       32, *String        @00000005E6, Blk   1036, Len     12, Value=hello worl
 7706:#onnew                    : @0000000030, Len       32, *String        @0000000050, Blk   1062, Len     38, Value=Holding Qu


Memory Address : 7F0D7481B000
Memory Length  : 2000112 2000112
Data Address   : 7F0D7481B070 As Offset from Start Of Shared Memory Segment  000000070
Data Length    : 2000000 2000000
Header Length  : 112
Sem Lock Addr  : 7F0D7481B000
Lock TimeOut   : 0.1 0.1
New Mem Block  : True
Memory Handle  : No Handle, Not Using Named Shared Memory

Start of mem        48, End of mem   1999999, Length 2000000
FreeList Head 2586
**** Mem Block List
@0000000030, Len       32, *String        @0000000050, Blk   1062, Len     38, Value=Holding Qu
@0000000050, Len     1102, StringData     Holding Qu
@000000049E, Len      168, ShmList        , Value = 1182, Ref
```
### Real Address from Virtual Address
* ReadAddress(VirtualAddress) as pointer
* Takes the virtual address within the shared segment and returns the real address
* This class uses virtual addresses to access shared memory

### Remove Symbol from symbol table
* Remove the symbol from the symbol table
* Notify any app/task waiting for removal of symbols

### Save Image
* SaveImage(Optional FileName As String = Application.name & ".image")
* Saves a re-creatable copy of the Shared memory and symbol table to a file.

### Save Symbol
* SaveVar(VarName As String, Optional filename As String = "")
* VarName - the name of the symbol to save
* The default file name is the file base name with the .var extension Name.var
* Filename - overrides the default file name used.  which is the VarName.var

### Save Gambas Native Value as ShmMem Variable
* SaveNativeVar(Assigned_ShmMem_Name as string, Value as variant, FileName as string)
* Assigned_ShmMem_Name - the name of the ShmMem Symbol to associate with the value when loaded
* Value - the gambas native value to be saved as ShmMem formatted Value
* FileName = Overrides the default file name used - which is the Assigned_ShmMem_Name.var

### Set full Paths
* SetPath(filePath As String, Optional defaultBaseName As String = "", defaultExtension As String = "") As String
* Returns the full path to a Variable or image file
* Applies defaults to the filename path and extensions
* The Default Path is set by the property DefaultDirectory

### Size of Value
* SizeOf(Value As Variant) As Long
* Returns the size of a Values storage
* Works with special Shared memory classes

### VarPtr
* {VarPtr}(SymName As String) As Variant
* Returns the virtual address of the symbols value
## Deprecated Functions
The functions below check the value in a loop. You should now use the NotifyOnNew, NotifyOnRemove and Notify calls instead.
Those are asynchronous: the program keeps running and receives an event.

The loop is not a busy wait: the pause between checks starts at 1 ms and doubles up to 50 ms, so a quick change is
seen at once and a long wait costs about 20 checks a second. A Timeout of 0 waits for ever.

### Waitfor
* WaitFor(SymName As String, Optional Timeout As Float = 0) As Boolean
* Wait for a symbol to be created, with a timeout. Returns True when it exists
* Old interface should use notifyOnNew instead

### Wait Specific Value
* WaitForValue(SymName As String, Value As Variant, Optional Timeout As Float = 0) As Boolean
* Wait for a symbol to have a specific value
* Old interface should use Notify instead

### Wait Value Change
* WaitValueChange(SymName As String, Value As Variant, Optional Timeout As Float = 0) As Boolean
* Wait for a value to change
* Old interface should use notify instead

## Locks, Processes and Errors
### Locks
* The memory block, every list/queue and every array have their own lock: a process shared, robust, recursive pthread mutex, made in the shared memory itself.
* A lock held by a process that ends or is killed is taken over by the next process that locks it, with a message on stderr: "a process ended while it held the lock of ..., recovered". What the dead process was changing may be half done.
* A process waits up to 30 seconds for a lock held by a live process (lists and arrays: the Wait_Time of Lock), then an error is raised: "Mutex race condition !!! : ..., another process held the lock for 30 s".
* Waiting does not use the processor: the waiters sleep in the kernel and are woken when the lock is released.
* A process may take the same lock more than once, each Lock needs its Unlock. A release of a lock that is not held is ignored.
* Segments made by a version before 2.3 use semaphores and can not be used: remove them with ForceDelete, or delete the segment files in /dev/shm, before starting.

### Tasks and fork
* A forked Task inherits the ShmMem objects of its parent. Objects remember the process that made them: when a Task ends, it does not change the use counts of the parent's segment, lists and values, and does not take over the parent's notify queue.
* Lock counts are kept per process, a Task starts with no lock held.

### Errors
* Errors are raised to the caller, the library does not stop or print and continue. Errors inside the library say "internal error" and where.
* Examples: a list Remove... of a value that is not there raises "Empty List - ...", an index past the end raises "Out Of Bounds", a full memory raises "Out Of Variable Memory".

# ShmMem Interface - Properties

# Count
* Returns the number of symbols

# Debug
* Turns on or off debug messages

# DefaultDirectory
* The default directory used to load and save images or variables

# Length
* Returns the number of symbols

# Key 
* Returns the name of the current symbol during iteration

# Max
* Returns the max entry during iteration

# Objects - Static
* A table of active shmmem blocks for this PID

# PID - Static
* Returns the PID of the current App/task used to identify when a new task attempts to connect to the shared memory and Symbols are being restored.

# ShmObject
* Returns a list of shmmem objects

# Signature
* Each Shmmem object and all decedents have a unique Signature. This is used internally to correctly associate control objects and values.

# Shared Memory Symbols

# Defining a Shared Symbol
Symbols are created dynamically as they are referenced and the value type is defined by the type of data being referenced by them.
The symbols are referenced/created using the class variable access method.<br>
If a variable does not exist during a value assignment it is created and the value is saved.<br>
If referenced to retrieve a value an error will be created if it is not found.<br>

Symbols are basically a property of the shared memory object.

## Example ways to define
```
public mymem = new ShmMem  ' Creates an un-named memory segment
with mymem
   !a = "this message"     ' the ! is a way that gambas uses to access a property of the object
   .a = 1                  ' the . is synonymous with the !
   mymem["a"] = 200.0      ' As an element of the shared memory object.
end with
```
All of the above methods are exactly equivalent.

# Iteration

# Iteration implementation
It is possible to iterate through the shared memory. Iteration progresses through a sorted list of Symbol names. Each iterations returns the variant value of the symbol and the key property is set to the name of the symbol.
## Example:
```
dim mymem as new shmmem  ' use the defaults for unnamed memory
with mymem
   !a = 100
   !b = "this"
   for each v as variant in mymem
     print mymem.key;"=";v
   next
end with
```
## Outputs:
```
#onnew=Holding Queue for new symbol creation
a=100
b=this
```

# Notifications

# Introduction
These functions only work with values that are assigned to a symbol table entry.

ShmMem has four types of notifications available to users.
1. Notify when a Symbol is created
1. Notify when a symbol is removed/deleted
1. Notify when a Specific symbol changes value
1. Notify when any symbol changes value

Each notification does as the names suggest. The App/Task receives an event with the following parameters
1. The name of the variable
1. The value of the variable - new and changed only
1. Indication if the request timed out, this was an option when asking for changes.

# How the notifications are delivered
* Each process that asks for notifications has its own queue in the shared memory and a notify pipe, /dev/shm/shmmem-notify-&lt;pid&gt;.
* A change is put on the queue of every process waiting for it, then a byte is written to that process's pipe.
* The pipe is watched by the Gambas event loop: the event is raised as soon as the program returns to the event loop (for example in a Wait).
* A program that is busy and does not return to the event loop gets its waiting events when it next creates, writes or removes a variable.
* No signals are used.
* A pipe left by a process that ended without closing it is removed by the next process that opens its pipe.

# Using the notifications

## On creation of a Symbol
Have a look at the [Shmmem - NotifyOnNew](https://github.com/justlostintime/ShmMem/wiki/Interface#notify-on-new-symbol) for details
```
Public sub main()
   Dim myshm as new shmMem
   myshm.NotifyOnNew(true, me, "WhenChanged")
   myshm!newvar=100
   wait 3               ' let it print
   quit 0
end
Public sub WhenChanged(Varname as string, Value as variant, timed_out as boolean)
' do something , the value is set to the first value, the timed out is always false
end
```
## On Removal/Deletion of a Symbol
Have a look at the [Shmmem - NotifyOnRemove](https://github.com/justlostintime/ShmMem/wiki/Interface#notify-on-remove-symbol) for details
```
Public sub main()
   Dim myshm as new shmMem
   myshm.NotifyOnRemove(true, me, "WhenRemoved")
   myshm!newvar=100
   MyShm.remove("newvar")
   wait 3               ' let it print
   quit 0
end

Public sub WhenRemoved(Varname as string, Value as variant, timed_out as boolean)
' do something, The value and timed out are set to false, false always
end
```

## On Specific Symbol Value changed
Have a look at the [Shmmem - Notify](https://github.com/justlostintime/ShmMem/wiki/Interface#notify-on-change) for details
```
Public sub main()
   Dim myshm as new shmMem
   myshm!newvar=100
   myshm.Notify("newvar", me, "WhenChanged",20,"This tag")
   myshm!newvar=200
   MyShm.NotifyStop("newvar", me, "WhenChanged","This tag")   'symbol, object, method and tag must match the notify request
   wait 3               ' let it print
   quit 0
end

Public sub WhenChanged(Varname as string, Value as variant, timed_out as boolean)
' do something
end
```
## On Any Symbol Value changed
Have a look at the [Shmmem - Notify](https://github.com/justlostintime/ShmMem/wiki/Interface#notify-on-change) for details
```
Public sub main()
   Dim myshm as new shmMem
   myshm!newvar=100
   myshm.NotifyOnAny(true, me, "WhenChanged")
   myshm!newvar=200
   MyShm.NotifyOnAny(false, me, "WhenChanged")   'this must match exactly the notify request
   wait 3               ' let it print
   quit 0
end

Public sub WhenChanged(Varname as string, Value as variant, timed_out as boolean)
' do something
end
```

# ShmMem DataTypes - Overview

ShmMem data types are implemented as pointers to data structures contained in the shared memory area. Instantiation is done as a pointer internally used by the gambas class interface to the datatype.<br> 
Internally each type implements a number of specific methods which allows the object to be handled in a similar way to Gambas's built in data types
Each Data Type is assigned an integer type value. These type values are used in the same way as gambas' datatype but are assigned values higher than those used by gambas. Shm datatypes may be assigned to a symbol or not. Individual tasks and apps may access these type through the symbol table when assigned or by the Tag associated with the object when it was created. When creating these datatype you must specify which shared block to associate the object to.

For example the following list is used by the included datatypes:
* ShmList       = 20
* ShmListEntry  = 21
* ShmFiFo       = 22
* ShmFifoEntry  = 23
* ShmFiLo       = 24
* ShmFiloEntry  = 25
* ShmQueue      = 26
* ShmQueueEntry = 27
* ShmArray      = 28
* ShmValue      = 29
* Native object = 128 (ShmClass, a prototype)

Each Shm dataype must implement an _init() to register the class as an internal shm class.<br>
For example:
```
Static Public Sub _init()
    ShmVarStorage.DefineClass("ShmList", cShmlist)
    ShmVarStorage.DefineClass("ShmListEntry", cShmlistEntry)
End
```
### Example: Using shm types
```
' Task 1
dim mymem as new shmmem("MyMemBlock")
with mymem
   dim mylist as new ShmList(mymem,0,true,"this list") ' use mymem, 0= create new dpointer, global value, tag
   mylist.add("this message",5677,"entry tag")         ' add an entry with extended id, and tag
   !a = mylist                                         ' add a symbol table entry for this list
   dim sameList as new ShmList(mymem,"this list")      ' Points to the same list in shared mem
   print Samelist.first                                ' outputs "this message"
   dim againList as new ShmList(mymem,myList.address)  ' again the same list. This interface is used mostly internally
   print againList.first                               ' outputs "this message"
   print !a.first                                      ' outputs "this message"
end with 
```
In Another running task/app:
```
'Task 2
dim mymem as new shmmem("MyMemBlock")
with mymem
   dim sameList as new ShmList(mymem,"this list")      ' Points to the same list in shared mem
   print Samelist.first;;SameList.tag                  ' outputs "this message this list"
   print !a.first;;!a.tag                              ' outputs "this message this list"
end with
```
### Example: Defining Types
Many more examples can be found in the ShmMem Project files

```
' Gambas class file

Export

''' Implements a first in first out Queue in shared memory

Inherits ShmList

Static Public cShmFiFo As Integer = 22            ''  Static type value Assigned to this Shm class - 22
Static Public cShmFiFoEntry As Integer = 23       ''  The entry in a ShmList object type - 23

Static Public Sub _init()

    ShmVarStorage.DefineClass("ShmFiFo", cShmFiFo)
    ShmVarStorage.DefineClass("ShmFiFoEntry", cShmFiFoEntry)

End

'' Convert the Virtual address to an actual list object
Static Public Sub AsObject(vvarmem As ShmVarStorage, VirtAddr As Pointer) As ShmList

    Return Object.New(vVarMem.GetTextType(cShmFiFo), [vvarmem, VirtAddr])

End

Public Sub Pop() As Variant

    Return Me.remove(0)

End
```
### Storing your own objects
Objects of your own Gambas classes can be stored too: inherit [ShmStorableClass](https://github.com/justlostintime/ShmMem/wiki/ShmStorableClass), or define _read and _write in the class.

### Notes on using Tags
While it is possible to add a TAG to many of the data types used by shared memory, referencing these TAGS can be very slow
when there is a large number of tagged memory segments. The program does a sequential search through the allocated memory blocks looking for the requested TAG.

# ShmMem DataTypes - Defining

Shared memory datatypes are essentially interfaces to structures stored in the allocated memory block.
ShmMem datatypes must have the following methods and properties.

## Initialization
_init is required to register the class as a datatype. Each assigned value must be unique.
```
Static Public cShmList As Integer = 20             '' The Constant identifying this class 
                                                   ''   name must not be a valid gb datatype integer
Static Public cShmListEntry As Integer = 21        '' The entry in a ShmList object type

Static Public Sub _init()
    ShmVarStorage.DefineClass("ShmList", cShmlist)
    ShmVarStorage.DefineClass("ShmListEntry", cShmlistEntry)
End
```
## Assignment
_Assign is required in order to allow the data structures to be assigned to the object. A Dpointer is passed to the object with the virtual address
of the data structure associated with this datatype. This example is from the ShmList data type.
```
Public Sub _Assign(VEntry As DPointer)
    If listhead = Null Then
        vEntry.value = Null                     ' if the listhead is valid then continue
    Else
        Inc ListHead.RefCount                   '  represents the number of references to this entry
        vEntry.Value = ListHead.Address         '  Assign this to the variable
    Endif
End
```
## Creation/Reference
_new is required to create a new structure or to instantiate the object from the virtual address of an existing dpointer. This example is from the ShmList datatype. In this example it is also possible to reference an existing dpointer by the tag assigned to it.
```
Public Sub _new(VarStorage As Variant, 
                Optional VirtAddressOrTag As Variant = CPointer(0), 
                GlobalValue As Boolean = False, Tag As String = "")

    Dim Result As Integer = 0
    Dim VirtAddress As Pointer = 0

    If Object.Class(VarStorage).name == "ShmMem" Then
        VarMem = VarStorage.MyVarMem
    Else
        VarMem = VarStorage
    Endif

    Dim RealPtr As Pointer
    If TypeOf(VirtAddressOrTag) = gb.string Then
        VirtAddress = LocateByTag(VirtAddressOrTag)
        If VirtAddress = Null Then
            Error.Raise("List / Queue : locate by tag " & Quote(VirtAddressOrTag))
        Endif
    Else
        VirtAddress = VirtAddressOrTag
    Endif

    If VirtAddress = 0 Then
        ListHead = NewEntry()
        VirtualAddress = ListHead.Address
        ListHead.type = SetHeadType
        ListHead.Global = GlobalValue
        ListHead.sema = VarMem.Alloc(64)                        ' 64 bytes: ShmLock aligns the 40 byte mutex inside them
        ListHead.UsePriority = False
        ListHead.Value = 0
        ListHead.tag = Byte[].FromString(tag)
        SemAddress = varmem.RealDataAddress(ListHead.sema)
        If Not ShmLock.Init(SemAddress) Then Error.Raise("ShmList: " & ShmLock.LastError)   ' the robust mutex, see ShmLock
    Else
        VirtualAddress = VirtAddress
        RealPtr = VarMem.RealAddress(VirtAddress)
        ListHead = RealPtr
        SemAddress = varmem.RealDataAddress(ListHead.sema)
        Me.lock()
        Inc ListHead.RefCount
    Endif
    Me.unlock()

End
```
## Locking and Tasks
A datatype that has its own lock reserves 64 bytes in the shared memory and uses the ShmLock module:
* ShmLock.Init(Address) As Boolean - makes the mutex, False when it fails, ShmLock.LastError says why.
* ShmLock.Take(Address, Seconds, "what") As Integer - 0 locked, 1 locked after the holder died, -1 not locked (raise ShmLock.LastError).
* ShmLock.Give(Address) - release.

Keep a lock depth with the pid that owns it, so a forked Task starts without the lock. Remember the pid that made the
object in _new, and do nothing in _free when it differs: a Task ending must not change counts in the shared memory
that belong to its parent.

## Addressing
UserPtr is required by each datatype to return a data structure pointer to the real memory address of the corresponding data structure at the specified virtual address.
this example is from the ShmList datatype.
```
Static Public Sub UserPtr(vvarmem As ShmVarStorage, VirtAddr As Pointer) As Dlist
    If VirtAddr <= 0 Then Return Null
    Dim RealPtr As Pointer = vVarMem.RealAddress(VirtAddr)
    Return RealPtr
End
```
## Convert Virtual Address to Object
asObject Each class must be able to provide an interface which can convert a virtual address into an instantiated Object of its own class. This example is from the ShmList data type.
```
Static Public Sub AsObject(vvarmem As ShmVarStorage, VirtAddr As Pointer) As ShmList
    Return Object.New(vVarMem.GetTextType(cShmList), [vvarmem, VirtAddr])
End
```

# ShmMem DataTypes - ShmValue

Stores a single value onto the heap, without a Symbol table reference. Is managed by the user. A tag may be added and it is possible to reference the value by the tag name. This is the fastest access time when using the value, no checks no locks.

## Interface on create
'' Value may be accessed or created, VirtAddressOrTag = 0 then create new Value
'' VirtAddressOrTag = "tagname" then look for and return variable with this tag
'' VirtAddressOrTag > 0 then return Value at this virtual address
'' VarStorage = type of stream  initialize from a file
Public Sub _new(Optional VarStorage As Variant = Null, VirtAddressOrTag As Variant = 0, Tag As String = "", vValue As Variant = Null)

## Creating the value
in process 1
```
dim mymem as new shmmem(100000,"MyShared")  ' create the shared heap space
dim a as new shmValue(MyMem,0,"userValueTag")
a.value="this string or something"

```
In process 2 to access the value
```
dim mymem as new shmmem(100000,"MyShared") ' get access to the named heap space
dim a as new ShmValue(MyMem,"userValueTag")  ' get a reference to the other tasks value
a.value=100
```

## Constructor parameters
* VarStorage        - the ShmMem (or its memory pool) to create the value in, or a stream to read the value from.
* VirtAddressOrTag  - 0 creates a new value, a tag finds the value created with that tag, a virtual address refers to the value there.
* Tag               - the tag of a new value.
* vValue            - the first value of a new value.

## Properties
### MemoryPool
Returns the ShmVarStorage memory pool the value belongs to.
### RealAddress
Returns the real address of the value header.
### RealDataAddress
Returns the real address of the data header.
### Tag
Read or write the tag of the value.
### Type
Returns the datatype ShmValue (29), not the type of the value stored.
### Value
Read or write the value.
### VirtAddress
Returns the virtual address of the value header.

## Methods
### Free
* Free()
Frees the value and its storage.
### List - Static
* ShmValue.List(VarStorage As Variant) As ShmValue[]
Returns all the values in the memory block.
### LocateByAddress
* locateByAddress(Virt As Pointer) As Pointer
Checks that Virt is the virtual address of a value in the shared memory: returns it when it is, Null when not.

# ShmMem DataTypes - ShmList

# ShmList
This implements lists that may be shared between tasks and applications. This class is inherited by all other list/queue classes. Lists are doubly linked. Supports next and previous searches. Each entry may also be assigned an extended integer id and a Tag string. The entries are class ShmListEntry and all other list/Queue entries inherit this class. It is possible to search a list using the ExtendedID or the Tag for a specific entry.Lists are re-entrant, protected by a semaphore.

# Interface
## Creating a new list
```
_new(VarStorage As Variant, Optional VirtAddressOrTag As Variant = CPointer(0),
     GlobalValue As Boolean = False, Tag As String = "", UsePriority As Boolean = True)
```
* VarStorage        - the memory block you wish to create the array in.
* Virtual Address | Tag
* * Virtual address  - if = 0 then a new list is created, else an new reference instance of the list at virtual address is created.
* * Tag              - if found creates a new reference instance.
* UsePriority       - Defaults to True. Kept with the list, see the UsePriority property.

Lists may be referenced or created in one of three ways
* Creating a new list
```
 dim myMem as new ShmMem("mymem")
    with mymem
       Dim MyList as new ShmList(mymem,0,true,"this list") ' use mymem for storage, virt address = 0 new list, global yes, tag
       !a = new ShmList(mymem,0,true,"this list")          ' use mymem for storage, virt address = 0 new list, global yes, tag
    end with
```
* Create a new reference to a list
```
 dim myMem as new ShmMem("mymem")
    with mymem
       Dim MyList as new ShmList(mymem,"this list") ' use mymem for storage, find this tag
       !a = new ShmList(mymem,"this list")          ' use mymem for storage, find this tag
       Dim ByList as new ShmList(MyMem,virtAddress) ' Use mymem for storage, Reference address = virtual address
    end with
```
The form using the virtual address is mostly used internally
## Iteration through the list
for next and for each  are supported for lists. Iteration occurs from the top of the list to the bottom. The value of the entry is returned for each iteration, and the key is set to the entry index value. Key_ExtendedID is set to the extended id value. Key_Tag is set to the entry tag value.
Key_Dlist contains a pointer to the current entry data structure.
```
    for each v as variant in mylist
       print v,key,key_ExtendedID,Key_Dlist,Key_Tag
    next
    for i as integer = 0 to myList.max
       print v,key,key_ExtendedID,Key_Dlist,Key_Tag
    next
```
## Properties
### Address
Returns the virtual address of the list head
### AllEntries
Returns an array with all the entries of the list, as ShmListEntry objects (Priority, Tag, Value).
### AllLists
Returns an array of every list in the shared memory as an array of ShmList[]
### ClassEntry
Returns the text name of the entry class for this list.Note when inherited returns text name of inheriting class.
### ClassList
Returns the text name of the class of this list type. Note when inherited returns text name of inheriting class.
### Count
Returns the number of entries in the list
### Debug
Turns on or off debug messages true or false
### First
Return the value of the first entry in the list
### Last
Returns the value of the last entry on the list
### MemoryPool
Returns the ShmVarStorage memory pool the list belongs to.
### Max
Returns the highest valid index
### Next
Returns the next element in the list
### Prev
Returns the previous entry on the list
### RefCount
Returns the number of refrences to this list
### Tag 
Read or set the value of this lists Tag
### UsePriority
Returns True when the list/queue uses the priority (ExtendedId) of its entries. Set when the list is created.
### Type
Returns the type value of the list
### Value
Returns the virtual address of the list

## Methods
### Add
* add(Value As Variant, Optional ExtendedId As Long = 0, TagInfo As String = "")
Adds a new entry onto the end of the list.
ExtendedID provided a fast way of searching for a specific element when used
Taginfo is a text tag that can also be used to search for a specific entry

### AsDlistList
* AsDlistList() As DList[]
Returns a list of Dlist entrys, these are really pointers to the actual entry structure in shared memory

### Clear
* Clear()
Empty the list free all entries and values

### Copy
* Copy()
Returns a deep copy of the list

### Find
*  Find(value As Variant, Optional ReturnElement As Boolean = False) As Variant
Find a value in the list and return either the index of the value or the actual ListElement object.

### Find Extended Id
* FindExtId(Value As Long, Optional ReturnElement As Boolean = False) As Long
Find an Extend Iid  in the list and return either the index of the ID or the actual ListElement object.

### Find Tag
*  FindTag(Value As String, Optional ReturnElement As Boolean = False) As Variant
Locate the entry by the tag assigned to it. Returns the index or the element in the list.

### Find Virtual Address
* FindVirtAddress(VirtAddress As Pointer, Optional ReturnElement As Boolean = False) As Variant
Locate the list entry by its virtual address and return the index or the element in the list.

### Free
* Free(Optional OverRideGlobal As Boolean = False)
Delete the entire list, free values, entries and its lock. Override if the list is created as a global list that may not be deleted.

### Insert
* insert(Index As Long, value As Variant, Optional ExtendedId As Integer = 0, TagInfo As String = "")
Insert a value into the list at index, add the extendd ID and TagInfo if present

### Lock
* Lock(Optional Wait_Time As Float = 30.0, Auto_Recovery As Boolean = False) As Boolean
Lock the list. This is done automatically whenever the list constructs are accessed, the values are always locked when set or read.
Not required by the user in most cases.
* Wait_Time - how long to wait for a live process holding the lock, then an error is raised. A lock held by a process that ended is taken over.
* Auto_Recovery - ignored, kept for compatibility. It forced the lock open, even under a live holder.
* The same process may lock more than once, each Lock needs an Unlock.

### LocateByAddress
* locateByAddress(Virt As Pointer) As Pointer
Checks that Virt is the virtual address of a list in the shared memory: returns it when it is, Null when not.

### NewEntry
*  NewEntry(Optional Value As Variant = Null) As DList
Creates a new dlistentry in the shared memory and returns the class object wrapper. Does not add the entry to the list.
Used internally.

### Pop
* pop()
Removes and returns the last item on the list

### popInfo
* popInfo
Removes and returns the last entry from the list. Returns an entryInfo Object the format is 
```
Property Read Tag As String Use $Tag
Property Read ExtendedId As Variant Use $ExtendedID                           ' also referred to as priority
Property Read Value As Variant Use $Value

Public Sub _new(vValue As Variant, vExtendedID As Variant, sTag As String)

    $Tag = sTag
    $value = vValue
    $ExtendedId = vExtendedId

End
```
### Push
*  Push(value As Variant, Optional ExtendedID As Long = 0, TagInfo As String = "Push")
Pushes the value onto the end of the list.

### Remove
*  remove(Optional Index As Long = -1, WithReturn As Boolean = True) As Variant
Removes the index item from the list and optionally returns the value

### Remove By Value
*  RemoveByValue(vValue As Variant) As Variant
Removes the entry by Value; returns the value

###  Remove By Virtual address
*  RemoveByVirt(VirtAddress As Pointer) As Variant
Removes the element by virtual address; returns the value

###  Remove by extended Id
*  RemoveExtId(ExtendedId As Long) As Variant
Removes the element by its extended Id; returns the value

### Remove by tag 
* RemoveTag(sTag As String) As Variant
Removes the element with the matching tag; returns the value

### TextTree
* TextTree() as string
Returns a printable representation of the list tree.

### unlock
* Unlock() As Boolean
Unlocks the list structures. Returns False when this process did not hold the lock, the call is then ignored.

# ShmMem DataTypes - ShmQueue

# ShmQueue
This implements Queues and Prioritized Queues that may be shared between tasks and applications.
# Interface
## Creating a new Queue
```
_new(VarStorage As Variant, Optional VirtAddressOrTag As Variant = CPointer(0),
       GlobalValue As Boolean = False, Tag As String = "",UsePriority as boolean = true)
```
* VarStorage        - the memory block you wish to create the array in.
* Virtual Address | Tag
* * Virtual address  - if = 0 then a new list is created, else an new reference instance of the list at virtual address is created.
* * Tag              - if found creates a new reference instance.
* UsePriority       - The queue will use a priority when adding or removing elements to the queue
* * When specifies then the priority must be specified when the element is added to the queue

Queues may be referenced or created in one of three ways
* Creating a new Queue
```
 dim myMem as new ShmMem("mymem")
    with mymem
       ' use mymem for storage, virt address = 0 new list, global yes, tag, And priority
       Dim MyQueue as new ShmQueue(mymem,0,true,"this list",true) 

       ' use mymem for storage, virt address = 0 new list, global yes, tag, priority sorting
       !a = new ShmQueue(mymem,0,true,"this list",true)          
    end with
```
* Create a new reference to a Queue
```
 dim myMem as new ShmMem("mymem")
    with mymem
       Dim MyQueue as new ShmQueue(mymem,"this list") ' use mymem for storage, find this tag
       !a = new ShmQueue(mymem,"this list")           ' use mymem for storage, find this tag
       Dim ByAddr as new ShmQueue(MyMem,virtAddress)  ' Use mymem for storage, Reference address = virtual address
    end with
```
The form using the virtual address is mostly used internally.

## Iteration through the list
for next and for each  are supported for lists. Iteration occurs from the top of the Queue to the bottom. When priority is used then the top is the lowest priority number and bottom is the highest priority number. The value of the entry is returned for each iteration, and the key is set to the entry index value. Key_ExtendedID is set to the extended id value. Key_Tag is set to the entry tag value. The key_ExtendedID is the value of the priority assigned to the queue element.

Key_Dlist contains a pointer to the current entry data structure.
```
    for each v as variant in mylist
       print v,mylist.key,mylist.key_ExtendedID,mylist.Key_Dlist,mylist.Key_Tag
    next
    for i as integer = 0 to myList.max
       print v,mylist.key,mylist.key_ExtendedID,mylist.Key_Dlist,mylist.Key_Tag
    next
```
## Properties 
### See List data type for Common properties. There are no special properties for queues.
### Extended ID is used in queues to set the priority

## Methods
## See List type for common methods
### DeQueue(Optional priority as integer)
* priority - when specified seek the requested entry with given priority
Returns the next appropriate value from the queue, based upon priority or position as defined when the queue is created. If a priority is specified then fail if not found.

### EnQueue((Value As Variant, Optional Priority As Integer = 0, TagValue As String = "")
* Value       - item to be stored into the queue.
* Priority    - Add this priority to the queue, if not specified then default to 0
* Tag         - text tag for this element
Adds the value to the queue as specified by the Priority.

### Exist(Priority As Integer)
* Priority - the priority to search the queue for
Check if a specific priority item exists on the queue, returns true of false

### SeekPriority(Priority As Integer, Optional bMatch As Boolean = False)
* Priority - the next element with this priority
* bMatch   - Return exact match or next higher match
* * true   - return when an exact match is found
* * false  - returns the exact or next higher match
Search for and return the entry from the queue matching the requested priority. The element is not removed from the queue.

## Re-implemented methods
### POP()
Returns same as Dequeue

### PUSH(Value As Variant, Optional Priority As Long = 0, TagInfo As String = "QPush")
Adds the same as enqueue, defaults the tag to "QPush"

# ShmMem DataTypes - ShmFiFo

# ShmFiFO
This implements a First in First out Queue that may be shared between tasks and applications. This inherits the List data type and re-implements POP interface to always returns the oldest(first added) element on a list.

# Interface
## Creating a new FiFo
```
_new(VarStorage As Variant, Optional VirtAddressOrTag As Variant = CPointer(0),
     GlobalValue As Boolean = False, Tag As String = "", UsePriority As Boolean = True)
```
* VarStorage        - the memory block you wish to create the array in.
* Virtual Address | Tag
* * Virtual address  - if = 0 then a new list is created, else an new reference instance of the list at virtual address is created.
* * Tag              - if found creates a new reference instance.
* UsePriority       - Defaults to True. Kept with the list, see the UsePriority property.

Lists may be referenced or created in one of three ways
* Creating a new FiFo
```
 dim myMem as new ShmMem("mymem")
    with mymem
       Dim MyFiFo as new ShmFiFo(mymem,0,true,"this list") ' use mymem for storage, virt address = 0 new list, global yes, tag
       !a = new ShmFiFo(mymem,0,true,"this list")          ' use mymem for storage, virt address = 0 new list, global yes, tag
    end with
```
* Create a new reference to a FiFo
```
 dim myMem as new ShmMem("mymem")
    with mymem
       Dim MyFiFo as new ShmFiFo(mymem,"this list") ' use mymem for storage, find this tag
       !a = new ShmFifo(mymem,"this list")          ' use mymem for storage, find this tag
       Dim ByFiFo as new ShmFiFo(MyMem,virtAddress) ' Use mymem for storage, Reference address = virtual address
    end with
```
The form using the virtual address is mostly used internally
## Iteration through the FiFo
for next and for each  are supported for lists. Iteration occurs from the top of the list to the bottom. The value of the entry is returned for each iteration, and the key is set to the entry index value. Key_ExtendedID is set to the extended id value. Key_Tag is set to the entry tag value.
Key_Dlist contains a pointer to the current entry data structure.
```
    for each v as variant in myFiFo
       print v,key,key_ExtendedID,Key_Dlist,Key_Tag
    next
    for i as integer = 0 to myFiFo.max
       print v,key,key_ExtendedID,Key_Dlist,Key_Tag
    next
```

## Properties 
### see List data type for Common properties

## Methods
## See List type for common methods

## Re-implemented methods
### POP()
Returns the oldest element on the list/queue

# ShmMem DataTypes - ShmFiLo

# ShmFiLo
This implements First in Last Out queues that may be shared between tasks and applications.This inherits the List data type and re-implements POP interface to always returns the newest(most recently added) element on a list.
# Interface
## Creating a new  FiLo
```
_new(VarStorage As Variant, Optional VirtAddressOrTag As Variant = CPointer(0),
     GlobalValue As Boolean = False, Tag As String = "", UsePriority As Boolean = True)
```
* VarStorage        - the memory block you wish to create the array in.
* Virtual Address | Tag
* * Virtual address  - if = 0 then a new list is created, else an new reference instance of the list at virtual address is created.
* * Tag              - if found creates a new reference instance.
* UsePriority       - Defaults to True. Kept with the list, see the UsePriority property.

Lists may be referenced or created in one of three ways
* Creating a new FiLo
```
 dim myMem as new ShmMem("mymem")
    with mymem
       Dim MyFiLo as new ShmFiLo(mymem,0,true,"this list") ' use mymem for storage, virt address = 0 new list, global yes, tag
       !a = new ShmFiLo(mymem,0,true,"this list")          ' use mymem for storage, virt address = 0 new list, global yes, tag
    end with
```
* Create a new reference to a FiLo
```
 dim myMem as new ShmMem("mymem")
    with mymem
       Dim MyFiLo as new ShmFiLo(mymem,"this list") ' use mymem for storage, find this tag
       !a = new ShmFiLo(mymem,"this list")          ' use mymem for storage, find this tag
       Dim ByFiLo as new ShmFiLo(MyMem,virtAddress) ' Use mymem for storage, Reference address = virtual address
    end with
```
The form using the virtual address is mostly used internally
## Iteration through the FiLo
for next and for each  are supported for lists. Iteration occurs from the top of the list to the bottom. The value of the entry is returned for each iteration, and the key is set to the entry index value. Key_ExtendedID is set to the extended id value. Key_Tag is set to the entry tag value.
Key_Dlist contains a pointer to the current entry data structure.

```
    for each v as variant in myFiLo
       print v,key,key_ExtendedID,Key_Dlist,Key_Tag
    next
    for i as integer = 0 to myFiLo.max
       print v,key,key_ExtendedID,Key_Dlist,Key_Tag
    next
```

## Properties 
### see List data type for Common properties

## Methods
## See List type for common methods

## Re-implemented methods
### POP()
Returns the most recently added element on the list/queue

# ShmMem DataTypes - ShmArray

# ShmArray
This implements Static Arrays that may be shared between tasks and applications. Arrays may have up to 10 dimensions.
The size of an array is limited by the amount of memory created when the shared memory block is created. These are not Gambas arrays, When a gambas array is assigned to a shmmem variable it is converted to ShmMem array type. Be warned.

# Interface
## Creating a new Array
```
Public Sub _new(VarStorage As Variant, Optional SubscriptsOrVirtAddressOrTag As Variant,
                Tag As String = "")
```
* VarStorage        - the memory block you wish to create the array in.
* Subscript | Tag | Virtual address
* * Subscript       - an array of dimensions each being a long value **[10,10,10]** up to 10 dimensions.
* * Tag             - the tag assigned when the array was originally created. Returns a reference 
                    - object to that array.
* * Virtual Address - The virtual address of the array in memory. Returns a reference object to the array.
* Tag               - A tag added to the array when originally created.

Arrays may be created or referenced in three ways:
* Creating a new array
```
    dim myMem as new ShmMem("mymem")
    with mymem
       dim myarray as new ShmArray(myMem,[10,10,10],"This Array Tag")
       myarray[0,0,0] = "this message"
    ' or
       !a = new ShmArray(myMem,[10,10,10],"This Array Tag")
       !a[0,0,0] = "that message"
    end with
```
* Accessing an array in memory
```
    dim myMem as new ShmMem("mymem")
    with mymem
       dim myarray as new ShmArray(myMem,"This Array Tag")
       print MyArray[0,0,0]                ' outputs "this message"
    ' or
       print !a[0,0,0]                     ' outputs "that message"
    end with
```
If you know the virtual address of the array you can access it using that address. This is mostly used internally.
```
    dim myMem as new ShmMem("mymem")
    with mymem
       dim myarray as new ShmArray(mymem,virtaddress)
       print MyArray[0,0,0]                               ' outputs "this message"
    end with
```
## Iteration through an array
For - next is supported for array data types. The array is iterated through in a linear fashion.The value is returned and the key is set to the subscript array reference in multi dimensional arrays. The key is an array of long values as subscripts to the returned value. The values are returned column by column . eg array def [3,3,3] then order is  [0,0,0], [1,0,0], [2,0,0], [0,1,0], [1,1,0], [2,1,0] .....[2,2,0],[2,2,1] [2,2,2]

```
        for each v as variant in MyArray
            print v,myarray.key
        next
```
Of course there is always the old iteration through each subscript manually.
```
        With MyMem
          Dim cc As Shmarray = !a.Copy("A good Copy")
          For ia = 0 To !a.submax[0]
              For ib = 0 To !a.submax[1]
                  For ic = 0 To !a.submax[2]
                      Print "By Element address["; ia;; ib;; ic; "]";; !a[ia, ib, ic];; cc[ia, ib, ic]
                  Next
              Next
          Next
        end with
```
## Properties
### Address
Returns the virtual address of the Data Portion of the array
### Bounds
Returns the dimensions of the array, the same as Dimensions.
### Count
Returns the total number of elements in the array
### Default
Returns or sets the default value for entries not yet set to a value.
The array will not use memory to store the default value, it will be returned when ever an empty array element is refrenced.
### Dimensions
Returns a long array of values, each representing a subscript length within the array.
### First
Returns the first element of the array.
### IterateAll
Set if the iteration over an array only returns values that have been set(false) or if every element is returned(true) if set then the default value will be returned for each empty element.
### Max
The highest element addressable in a for i = 0 to n loop.
### MemoryPool
Returns the ShmVarStorage memory pool the array belongs to.
### SubMax
Returns an array of longs representing the max addressable element for each subscript in the array.
### Tag
Returns or sets the arrays Tag string up to 64 utf8 characters.
### Type
Returns the internal shmmem datatype cShmArray
### UseLock
Sets or clears the use of array locking for each access to an element. The values are always locked when being set or read. This locking refers to array functions/methods/properties.
### Value
Returns the same as count, the number of elements in the array.
### VirtAddress
Returns the virtual address of the array.

## Methods
### Clear
* clear()
Clears/frees the elements/values of an array
### Copy
* Copy(Optional tag As String = "") As ShmArray
Creates a deep copy of the array, the optional tag will set the tag for this array
tags are not copied by default.
### Export
*  Export() As String
Transforms the array into a text format that can be saved and loaded later
### Free
*  Free()
Frees the Array shared memory, releases all values and its lock
### FormatDim
* FormatDim(dims As Long[]) As String
Returns the dimensions as text, each padded to six digits, for example [000010,000020].
### FromCvs
*  fromCvs(value As String)
Reads the \n separated string blob, and loads the data into an exsisting single or 2d array
### FromImport - Static
* ShmArray.FromImport(TheMem As ShmMem, sourceFile As String) As ShmArray
Creates a new array in TheMem from a file made with Export, and returns it.
### GetCol
*  GetCol(SubscriptWanted As Integer, ...) As Variant[]
Returns the request column SubScript identifies the subscript index, it is followed by a subscript mask. the column indicated is returned using the mask as the location of the requested column.
```
   Dim mem As New Shmmem("myseg")                     ' using named memory, other apps can access Space
   With mem
     !a = New Shmarray(mem, [3, 3, 3], "This Array 1")
     !b = !a.GetCol(1,2,0,1) ' get col index 1, mask 2,0,1, the subscript 1 will iterate through [2,0,1],[2,1,1],[2,2,1]
   end with
```
### GetOffset
* GetOffset(Dims As Variant[], Optional SingleIndex As Long) As Pointer
Returns the real pointer to the memory location containing a virtual pointer to the actual value of an array element.
### GetRow
* GetRow(...) As Variant[]
Returns the row at the specified position. This always iterates through the last subscript in the array definition. The user passed the n-1 subscript identifying the row to be returned.
```
 Dim mem As New Shmmem("myseg")                     ' using named memory, other apps can access Space
   With mem
     !a = New Shmarray(mem, [3, 3, 3], "This Array 1")
     !b = !a.GetRow(2,0) ' will iterate through [2,0,0],[2,0,1],[2,0,2]
   end with
```
### Import
*  Import(data As String)
Reads the data that was created from a previous export and re creates the array from this information. Old data is deleted the array may be resized to fit the new data.
### LinearToSubScript
* LinearToSubScript(Position As Long) As Long[]
Converts the position of an element in the linear storage into its subscripts.
### List - Static
* ShmArray.List(VarStorage As Variant) As ShmArray[]
Returns all the arrays in the memory block.
### LocateByAddress
* locateByAddress(Virt As Pointer) As Pointer
Checks that Virt is the virtual address of an array in the shared memory: returns it when it is, Null when not.
### lock
* lock(Optional Wait_Time As Float = 30.0, Auto_Recovery As Boolean = False) As Boolean
Manually locks the array, when UseLock is set (without UseLock it returns True and does nothing). Returns True when it was locked.
* Wait_Time - how long to wait for a live process holding the lock, then an error is raised (it used to return False). A lock held by a process that ended is taken over.
* Auto_Recovery - ignored, kept for compatibility.
* The same process may lock more than once, each lock needs an unlock.
### ReDim
* ReDim(dims As Long[])
Redimensions the array, all data will be lost
### ToCvs
* ToCvs() As String[]
Returns comma separated text array, for 1d and 2d arrays.
### unlock
* unlock() As Boolean
Unlocks the array. Returns False when this process did not hold the lock, the call is then ignored

# ShmMem Datatypes - ShmThread

# ShmThread
This Data type allows the creation and execution of linux threats from binary blobs stored in an executable shared memory segment.
Straight forward interface which allows creation and execution of threads withing the gambas executable. This is meant for creating in memory JIT'S or very fast synchronous or asynchronous functions that operate on gambas variables. Implemented in assembly or C languages. C being the most portable from arm to x86-64.
The binaries that are executed must be linked as Position independent executables. The templates included Build scripts included in this project help to achieve this goal.

See [Executable Blocks](https://github.com/justlostintime/ShmMem/wiki/Executable-Blocks) for making an executable segment, the rules a blob must follow, passing data, and the assembler and C templates with their build scripts.

# Interface
## Creating New Thread
```
Public Sub _new(SysMem As ShmMem, Ident As Variant, Optional ProgramLength As Integer = 0)
```
* SysMem      - the shared memory block to use for this thread
* Ident       - There are 2 types of idents that can be provided Virtual Pointer or Shared Mem Symbol name
* * Virtual Pointer        - this is the offset from the start of the shared memory segment to begin execution
* * Shared Mem symbol name - this is a string containing the name of a symbol in the shared memory segment
* * * This is the most commonly used interface
* ProgramLength - with Ident = "", allocates ProgramLength bytes in SysMem for the program (the Auto property is then True)

Threads may be created and referenced in two ways:
* Creating a new thread
```
  dim smem as ShmMem
  smem = New ShmMem(1280000, "test", 3000, 2.1, True)
  with smem
     !a = File.Load("templates/pthreadPassString.bin")
     dim aThread as new shmThread(smem,"a")            ' pass the shared mem and the 
                                                       '   name of the symbol storing the blob
     aThread.execute("This Message")                   ' start the background thread and wait 
                                                       '   for it to complete
     ' or start the thread and don't wait for completion
     aThread.execute("That message",false)
     ' do something else
     aThread.WaitComplete()
  end with 
```
* Threads can also be created from any memory allocated from the executable memory segment.
```
  dim smem as ShmMem
  smem = New ShmMem(1280000, "test", 3000, 2.1, True)
  with smem
     dim sBlob as string = File.Load("templates/pthreadPassString.bin")
     !a = sBlob                                        ' Copy the content of the sBlob into shared mem segment
     ' or 
     !a = .alloc(1000)
     ' write some byte to the memory and then .... byte@(!a+1) = 0x60 
     dim aThread as new shmThread(smem,"a")            ' pass the shared mem and the name of the symbol storing the blob
     'Alternately dim aThread as new shmThread(smem,!a)' Pass the virtual address of the memory to call
     aThread.execute("This Message")                   ' start the background thread and wait for it to complete
     ' or start the thread and don't wait for completion
     aThread.execute("That message",false)
     ' do something else
     aThread.WaitComplete()
  end with 
```
* Or You may allocate a byte array and use it later for JIT creation and execution
```
  dim smem as ShmMem
  smem = New ShmMem(1280000, "test", 3000, 2.1, True)
  with smem
     !a = .alloc(1000)
     dim aThread as new shmThread(smem,"a")            ' pass the shared mem and the name of the symbol storing the blob
     sThread[0] = &H22                                 ' write bytes directly to the memory for jit usage 
     aThread.execute("This Message")                   ' start the background thread and wait for it to complete
     ' or start the thread and don't wait for completion
     aThread.execute("That message",false)
     ' do something else
     aThread.WaitComplete()
  end with 
```
 

## Properties
All are read only.
### Auto
True when the program memory was allocated by the constructor (Ident = "" and a ProgramLength).
### Attribute
The pthread attributes of the thread.
### Call_Args
The argument pointer passed to the thread.
### Call_Memory
The ShmMem the thread runs in.
### Function_Address
The real address of the function the thread runs.
### Function_VirtAddr
The virtual address of the function in the shared memory.
### Result
The value returned by the thread.
### Thread
The pthread handle of the thread.

## Methods
### Cancel
* Cancel() As Integer
Asks the thread to stop (pthread_cancel). Returns 0 when the request was sent.
### Execute
* Execute(Optional arg As Pointer = Null, WaitToComplete As Boolean = True) As Variant
Starts the thread with arg, and waits for it to complete unless WaitToComplete is False.
### Kill
* Kill(Optional signumber As Integer = Signal.SIGKILL) As Integer
Sends a signal to the running thread, SIGKILL by default.
### WaitComplete
* WaitComplete() As Variant
Waits for the running thread to complete and returns its result (the pthread_join error code if the join fails). This should be used most of the time, a thread left running in the background can be dangerous.

# Executable Blocks
A ShmMem segment can be made executable. Binary code, a "blob" written in assembler or C, is then stored in it like any other value, and run as a native thread inside the Gambas program with [ShmThread](https://github.com/justlostintime/ShmMem/wiki/ShmMem-Datatypes-%E2%80%90-ShmThread). This is meant for in memory JIT code and for very fast functions working on shared data.

**Be careful:** the code runs inside your program, with no checks. A bad blob crashes the whole program, and it can overwrite any memory of the process.

The project provides templates for blobs in assembler and C, with the scripts that build them, in the `templates` directory. The example `Examples/vTestApps/Executable_Shared_Segments/TestExecutableBlocks.module` loads and runs all of them.

# Making an executable segment
Pass True as the isExecutable parameter (the fifth) when the segment is created:
```
Dim smem As New ShmMem(1280000, "test", 3000, 2.2, True)   ' length, name, symbols, lock timeout, executable
```
The segment is mapped with execute permission, and gets the permissions &O770 instead of &O660.

# Loading and running a blob
Store the binary in a variable and create a ShmThread on it:
```
With smem
    !a = File.Load("templates/pthreadPassString.bin")      ' the binary is stored in the segment
    Dim a As New ShmThread(smem, "a")                       ' a thread running the code of variable a
    a.Execute("Hello from Gambas\n")                        ' run it, wait for it to finish
End With
```
A ShmThread can also be created:
* on a virtual address in the segment: `New ShmThread(smem, VirtualAddress)`
* on new memory: `New ShmThread(smem, "", 4000)` allocates 4000 bytes for the program, then copy the code into it with `e[0] = File.Load("templates/pthreadPassStruct.bin")`.

## Execute
* Execute(Optional arg As Pointer = Null, WaitToComplete As Boolean = True) As Variant
* Starts the code as a new pthread. The code starts at the first byte of the blob, with arg as its only argument, in register rdi (the x86-64 C calling convention).
* WaitToComplete = True waits for the thread and returns its result. With False it returns at once: call WaitComplete() before reading anything the thread writes.
* WaitComplete(), Cancel() and Kill() are described on the [ShmThread](https://github.com/justlostintime/ShmMem/wiki/ShmMem-Datatypes-%E2%80%90-ShmThread) page.

## Passing data
The templates show three ways to pass data:
* **A string:** `a.Execute("message")` passes the address of the string's characters. End it with "\0" if the code looks for the end of the string.
* **A value:** `b.Execute(2)` passes the number itself, in rdi.
* **A structure:** `c.Execute(Object.Data(MyStruct))` passes the address of a Gambas structure. The code reads and writes its fields at their offsets, and by convention the first field is the result:
```
Public Struct messitup
    result As Long          ' offset 0, set by the thread
    value As Long           ' offset 8
    message As String       ' offset 16, a pointer to the characters
    writeLen As Long        ' offset 24
End Struct
```
Read the fields the thread writes only after it has finished.

# Rules for a blob
* x86-64 Linux code, position independent: the blob is loaded at any address.
* The entry point is the first byte of the blob.
* No libraries: the blob is not linked to libc or anything else, so it can not call printf, malloc or pthread functions. Use Linux system calls (the templates use write, open, close and exit).
* Everything the code needs, its data included, must be inside the blob, reached relative to the instruction pointer.
* End the thread with the exit system call (SYS_exit, 60), as the templates do. Never use exit_group (231): it ends the whole program.

# The templates
In the `templates` directory of the project:

| File | What it is |
|------|------------|
| pthreadPassString.asm | Assembler: receives a string, writes it and a log entry |
| pthreadPassValue.asm | Assembler: receives a value, writes a message that many times |
| pthreadPassStruct.asm | Assembler: receives a structure, uses its fields and sets its result |
| pthreadStruct.c | C: receives the same structure, writes the message value times and sets result and writeLen |
| buildAsm | Builds the three assembler templates |
| buildC | Builds the C template |
| linkinfo | Linker script used by buildC: puts the code at address 0 |
| thread_example.c, thread_example.s | Not a blob: a stand-alone C program using pthreads, and its assembler output, kept for reference |

The assembler templates append a line to /tmp/shm_exec.log each time they run.

## Building the assembler blobs
The assembler templates need the flat assembler, fasm (`sudo apt install fasm`). Run in the templates directory:
```
./buildAsm
```
It runs `fasm name.asm name.bin` for each template. fasm writes a flat binary directly: no linking is needed.

## Building the C blob
The C template needs gcc and binutils (ld, objcopy, objdump). Run in the templates directory:
```
./buildC
```
It does:
1. `gcc -g -fPIE -finline-functions -fno-stack-protector -c pthreadStruct.c`: position independent code, without the stack protector, which needs libc.
2. `ld -T linkinfo -o pthreadStruct.elf pthreadStruct.o --entry threadEntry -z noexecstack`: links at address 0.
3. `objcopy -O binary -j .text pthreadStruct.elf pthreadStruct.bin`: keeps only the code.
4. `objdump -d -M intel -S pthreadStruct.elf > C_dump.txt`: a disassembly, to check the result.

Rules for the C code, followed by pthreadStruct.c:
* The entry function (threadEntry) must be the first function in the file.
* Only the .text section is kept: no global or static variables, and no string constants.
* System calls are made with inline assembler, see showMsg and ThreadExit in the template.

## Running the example
The example loads the blobs from `templates/`, so run it from the project directory, after building them:
```
cd templates && ./buildAsm && ./buildC && cd ..
```
Then run TestExecutableBlocks from the IDE, or `gbx3 -s TestExecutableBlocks .` in the project directory. It runs each blob 1001 times (RepeatLoop), without waiting for the threads (WaitComplete = False), so the results it prints while the threads are still running can be 0.

# ShmStorableClass
A base class for your own Gambas classes whose objects are stored in shared memory, saved in images and shared between tasks and applications.

Inherit it and the object is written and read for you: every public variable and property of your class is stored. Without it a class must define its own `_read` and `_write` methods (see Writing your own _read and _write below).

```
' Gambas class file: Person.class
Inherits ShmStorableClass

Public Name As String
Public Age As Integer
Public Phones As String[]
```
```
Dim mymem As New ShmMem("mymem")
Dim p As New Person

p.Name = "jane"
p.Age = 40
mymem!person = p                    ' a copy of the object is stored in shared memory

' in another task or application using "mymem"
Dim q As Person = mymem!person      ' a new Person object with the stored values
Print q.Name, q.Age
```
The value read back is a new object, a copy: changing it does not change the stored value. Assign it again to store the change.

# What is stored
* The class version (an Integer), then the value of each public variable and property of the object, in the order Gambas lists the class symbols.
* Values are written with `Write As Variant`, so any type that can be written that way can be stored: native values, arrays, collections and other storable objects.
* Methods, constants and static variables are not stored.
* The Tag property is stored too.

# Rules for your class
* Every public property must be writable: reading the object sets each property again. A read only property makes the read fail with "'Class.Property' is read only".
* The class must be available, with the same name, in every program that reads the object.
* Adding, removing or reordering public variables changes the stored layout: objects saved before the change can not be read correctly after it.

# Interface
## Creating
* New YourClass(Optional LoadFrom As Variant = Null)
* LoadFrom - Null creates a normal new object.
* * a Pointer - reads the object from the memory at that address.
* * a File - reads the object from the file.
* Any other value raises "Invalid object type specified for loading/copy". See Limitations.

## Properties
### Tag
* Tag As String
* Read or write. Defaults to the name of the class.

## Methods
### CheckVersion
* CheckVersion(VersionNumber As String) As Integer
* Returns the version of the object minus VersionNumber: 0 when they are the same.
### GetObjectVersion
* GetObjectVersion() As Integer
* Returns the version of the object.
### ToString
* ToString() As String
* Returns a printable list of the stored values: name, Gambas type and value. Objects are shown as their address.

## Special methods
These are called by Gambas and the library. Override them in your class only to change how the object is stored.
* _write(mFile As File) - writes the version and the values.
* _read(mFile As File) - reads the version and the values.
* _serialize() As Integer - the number of bytes _write writes.
* _compare(OtherObject) As Integer - compares the values one by one: 0 when equal, 1 or -1 at the first difference. Raises "Object versions not equal or not found" when the versions differ.

# Writing your own _read and _write
A class that does not inherit ShmStorableClass can be stored when it defines both methods. Read the values in the order they were written.
```
' Gambas class file
Public Name As String
Public Count As Integer

Public Sub _write(hFile As Stream)
    Write #hFile, Name As String
    Write #hFile, Count As Integer
End

Public Sub _read(hFile As Stream)
    Name = Read #hFile As String
    Count = Read #hFile As Integer
End
```
See SharedObjectExample.class in the library source for a longer example.

# Limitations
These are how the class behaves now:
* The version is always 1 (ShmStorableClass.classversion). A `classversion` constant declared in your class is not used, so the version can not be used to tell apart the layouts of your class.
* There is no way to convert objects stored with an older layout: the conversion hook (_convertStream) is private and does nothing.
* Creating an object from another object, New YourClass(OtherObject), always raises "Invalid object type specified for loading/copy".
