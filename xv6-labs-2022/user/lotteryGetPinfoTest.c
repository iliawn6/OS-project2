#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"




int

main(int argc, char *argv[])

{
    printf("hello");
/*
    int pid_par = getpid();
    settickets(21);

    if(fork == 0){

        int pid_chd = getpid();
        struct pstat st;
        getpinfo(&st);

        int tickets_par = -1,tickets_chd = -1;
        int i;

        for(i = 0; i < NPROC; i++){

            if (st.pid[i] == pid_par){
                tickets_par = st.tickets[i];
                printf("parent process %d tickets: %d\n", i , st.tickets[i])
                printf("parent process %d ticks: %d\n",i,st.ticks[i]);
            }

            else if (st.pid[i] == pid_chd){
                tickets_chd = st->tickets[i];
                printf("parent process %d tickets: %d\n", i , st.tickets[i])
                printf("parent process %d ticks: %d\n",i,st.ticks[i]);
            }
        }

        exit();

    }

    while (wait() > 0);
    exit();
    */


}