#! /bin/bash

THIS_FULLPATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd -P)/`basename "${BASH_SOURCE[0]}"`
THIS_FOLDERPATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd -P)

APATH=/home/mangos/mangos-server/bin
WPATH=/home/mangos/mangos-server/bin
ASRV_BIN=realmd         #This usually doesnt change. TrinityCore: authserver  MaNGOS: realmd  ArcEmu: whocares?
WSRV_BIN_ORG=mangosd    #This usually doesnt change. TrinityCore: worldserver MaNGOS: mangosd ArcEmu: whocares?
WSRV_BIN=mangosd
WSRV_SCR=mangosd

echo "run" > gdbcommands
echo "shell echo -e \"\nCRASHLOG BEGIN\n\"" >> gdbcommands
echo "info program" >> gdbcommands
echo "shell echo -e \"\nBACKTRACE\n\"" >> gdbcommands
echo "bt" >> gdbcommands
echo "shell echo -e \"\nBACKTRACE FULL\n\"" >> gdbcommands
echo "bt full" >> gdbcommands
echo "shell echo -e \"\nTHREADS\n\"" >> gdbcommands
echo "info threads" >> gdbcommands
echo "shell echo -e \"\nTHREADS BACKTRACE\n\"" >> gdbcommands
echo "thread apply all bt full" >> gdbcommands

DEBUG=false

#WORLD FUNCTIONS
startWorld()
{
    if [ "$(screen -ls | grep $WSRV_SCR)" ]
    then
        echo $WSRV_BIN is already running
    else
        cd $WPATH
        screen -AmdS $WSRV_SCR $THIS_FULLPATH $WSRV_BIN $DEBUG
        echo $WSRV_BIN is alive
    fi
}

restartWorld()
{
    screen -S $WSRV_SCR -X stuff "saveall$(printf \\r)"
    echo saved all characters, and server restart initialized
    screen -S $WSRV_SCR -X stuff "server restart 5$(printf \\r)"
}

stopWorld()
{
    screen -S $WSRV_SCR -X stuff "saveall
    "
    echo saveall sent, waiting 5 seconds to kill $WSRV_BIN
    sleep 5
    screen -S $WSRV_SCR -X kill &>/dev/null
    echo $WSRV_BIN is dead
}

monitorWorld()
{
    echo press ctrl+a+d to detach from the server without shutting it down
    sleep 5
    screen -r $WSRV_SCR
}
#AUTH FUNCTIONS
startAuth()
{
    if [ "$(screen -ls | grep $ASRV_BIN)" ]
    then
        echo $ASRV_BIN is already running
    else
        cd $APATH
        screen -AmdS $ASRV_BIN $THIS_FULLPATH $ASRV_BIN
        echo $ASRV_BIN is alive
    fi
}

stopAuth()
{
    screen -S $ASRV_BIN -X kill &>/dev/null
    echo $ASRV_BIN is dead
}

restartAuth()
{
    stopAuth
    startAuth
    echo $ASRV_BIN restarted
}

monitorAuth()
{
    echo press ctrl+a+d to detach from the server without shutting it down
    sleep 5
    screen -r $ASRV_BIN
}

#FUNCTION SELECTION
case "$1" in
    $WSRV_BIN )
    if [ "$2" == "true" ]
    then
        while x=1;
        do
            gdb $WPATH/$WSRV_BIN --batch -x gdbcommands | tee current
            NOW=$(date +"%s-%d-%m-%Y")
            mkdir -p $THIS_FOLDERPATH/crashes
            mv current $THIS_FOLDERPATH/crashes/$NOW.log &>/dev/null
            killall -9 $WSRV_BIN
            echo $NOW $WSRV_BIN stopped, restarting! | tee -a $THIS_FULLPATH.log
            echo crashlog available at: $THIS_FOLDERPATH/crashes/$NOW.log
            sleep 1
        done
    else
        while x=1;
        do
            ./$WSRV_BIN
            NOW=$(date +"%s-%d-%m-%Y")
            echo $NOW $WSRV_BIN stopped, restarting! | tee -a $THIS_FULLPATH.log
            sleep 1
        done
    fi
    ;;
    $ASRV_BIN )
        while x=1;
        do
            ./$ASRV_BIN
            NOW=$(date +"%s-%d-%m-%Y")
            echo $NOW $ASRV_BIN stopped, restarting! | tee -a $THIS_FULLPATH.log
            sleep 1
        done
    ;;
    "wstart" )
    startWorld
    ;;
    "wdstart" )
    DEBUG=true
    startWorld
    ;;
    "wrestart" )
    restartWorld
    ;;
    "wstop" )
    stopWorld
    ;;
    "wmonitor" )
    monitorWorld
    ;;

    "astart" )
    startAuth
    ;;
    "arestart" )
    restartAuth
    ;;
    "astop" )
    stopAuth
    ;;
    "amonitor" )
    monitorAuth
    ;;
    
    "start" )
    startWorld
    startAuth
    ;;
    "stop" )
    stopWorld
    stopAuth
    ;;
    "restart" )
    restartWorld
    restartAuth
    ;;
    * )
    echo Your argument is invalid
    echo "usage: start | stop | restart | wstart | wdstart | wrestart | wstop | wmonitor | astart | arestart | astop | amonitor"
    exit 1
    ;;
esac