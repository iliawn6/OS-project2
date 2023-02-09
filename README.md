# XV6 Lottery Scheduler

We added a lottery ticket scheduler,
 in addition to the default scheduler found on xv6.
 In this scheduling, every process have some tickets and scheduler picks a random ticket and process having that ticket is the winner and
 it is executed for a time slice and then another ticket is picked by the scheduler. These tickets represent the share of processes.
 A process having a higher number of tickets give it more chance to get chosen for execution.

[Lottery Scheduling](https://www.geeksforgeeks.org/lottery-process-scheduling-in-operating-system/)

## Essential System Calls

### settickets system call:

settickets system call sets the number of tickets for the current process with the following prototype: 
```c
int settickets(int number)
```

### getprocessinfo system call:

getprocessesinfo is a system call with the following prototype

```c
int getprocessesinfo(struct processes_info *p);
```
where struct processses_info is defined in a new header file processesinfo.h as:
```c
struct processes_info {
    int num_processes;
    int pids[NPROC];       
    int times_scheduled[NPROC];
    int tickets[NPROC];               
};
```

The system call should fill in the struct pointed to by its arguments by:

* setting num_processes to the total number of non-UNUSED processes in the process table

* for each i from 0 to num_processes, setting:
pids[i] to the pid of ith non-UNUSED process in the process table;

* times_scheduled[i] to the number of times this process has been scheduled since it was created.

* tickets[i] to the number of tickets assigned to each process.




## Building and Running XV6

    $ make qemu 

Testing the system call with our user program:
    
    $ testtickets

Testing the lottery scheduler with our user program:
    
    $ lotterytest
