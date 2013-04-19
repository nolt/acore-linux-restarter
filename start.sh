#! /bin/bash
cd /YOUR/TRINITYCORE/PATH
screen -AmdS authserver ./rauthserver.sh
screen -AmdS worldserver ./rworldserver.sh
echo Started!
