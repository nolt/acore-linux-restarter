#! /bin/bash
while x=1;
do
    gdb worldserver --batch -x gdbcommands | tee current
    NOW=$(date +"%d-%m-%Y")
    mkdir -p crashes
    mv current crashes/$NOW.log
    killall -9 worldserver
    echo Server shut down!
    sleep 1
done
