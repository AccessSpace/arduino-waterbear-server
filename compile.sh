sDefaultPort="/dev/ttyACM0"
sDefaultBoard="uno"


sPort=${1:-$sDefaultPort}
sBoard=${2:-$sDefaultBoard}


sServerDir="$( cd "$( dirname "$0" )" && pwd )" 
sScriptFile="output.ino";
sOutputFolder="/tmp/output/";
sLock="lock.txt"

cd "$sOutputFolder"
rm "$sLock"

while [ 0  -lt 1 ]; do
    if [ ! -e "$sLock" ]
    then
	if [ -e "$sPort" ]
	then
	  if [ -e "$sScriptFile" ]
	  then
	    touch "$sLock"
	    scons upload ARDUINO_BOARD=$sBoard  ARDUINO_PORT=$sPort EXTRA_LIB="$sServerDir/external/ebl-arduino"
	    mv "$sScriptFile" "../old-$sScriptFile"
	    rm "$sLock"
	  fi
	fi
    fi
sleep 5s
echo "."
done
