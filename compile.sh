
ard="/dev/ttyACM0"
sScriptFile="output.ino";
sOutputFolder="/tmp/output/";
sLock="lock.txt"

cd "$sOutputFolder"
while [ 0  -lt 1 ]; do
    if [ ! -e "$sLock" ]
    then
	if [ -e "$ard" ]
	then
	  if [ -e "$sScriptFile" ]
	  then
	    touch "$sLock"
	    scons upload ARDUINO_BOARD=uno  ARDUINO_PORT=/dev/ttyACM0
	    mv "$sScriptFile" "../old-$sScriptFile"
	    rm "$sLock"
	  fi
	fi
    fi
sleep 5s
echo "."
done
