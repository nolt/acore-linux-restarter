# Linux restarter for ACore/MaNGOS/CMangos/TrinityCore.

Support : [AzerothCore](http://azerothcore.org)

## Requirements:
- screen
- gdb

## Installation
- sudo apt install -y screen gdb
- clone or download acoreadmin.sh
- chmod +x acoreadmin.sh

## Commands
- start - starts auth and world
- stop - stops auth and world
- restart - both
- wstart - starts world
- wdstart - starts world with debug mode
- wrestart - restart world
- wstop - stop world
- wmonitor - world monitor
- astart - auth start
- arestart - auth restart
- astop - auth stop
- amonitor - auth monitor

To leave wmonitor or amonitor (screen exit) please type Ctrl+A+D to exit screen without killing running process.
If you want to run multi realm server, just copy acoreadmin.sh and change WPATH variable.

Thanks to:
[Lillecarl](https://gist.github.com/Lillecarl) for initial code.
[Elmsroth](https://www.getmangos.eu/profile/16315-elmsroth/) for digging gist.
