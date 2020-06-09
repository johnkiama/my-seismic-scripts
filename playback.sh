#!/bin/bash

echo "$(tput setaf 4)YOU ARE RUNNING GDC SEISMIC DATA SCART SCRIPT$(tput sgr 0)"
echo ""

_scriptConfigs=$(readlink -f configSettings.ini) 

source <(grep = <(grep -A3 '\[section-playback\]' $_scriptConfigs | sed 's/ *= */=/g'))

reg='^[0-9]{3}$'
          
echo "$(tput setaf 1)PROCESSING: $(tput sgr 0)"$@
echo ""


function validate(){

if [[ ! ($startjulianday =~ $reg && $endjulianday =~ $reg) ]]
  then
    zenity   --info  --title  "Info dialog"  --text "Incomplete digits for start or end julian day"
  exit 0
fi
}
#validate

function zenityParser(){
  zenity   --question  --title  "Processing dialog"  --text "$message" \
           --ok-label=Run \
           --cancel-label=Cancel \
           --timeout=10
  case $? in
    1) exit ;;
  esac
}

if [ "$startjulianday" == "$endjulianday" ]
  then
    message="Processing $startjulianday!\nWould you like to continue?-- or WAIT 10 sec to automatically continue"
    zenityParser
else
    message="Processing $startjulianday to $endjulianday!\nWould you like to continue?--WAIT 10 sec to automatically"
    zenityParser
fi

source <(grep = <(grep -A3 '\[files-playback\]' $_scriptConfigs | sed 's/ *= */=/g'))

rawdir="$playback_in_dir/"PS_SCART_$year
rawdir1="$playback_out_dir/"PS_PLAYBACK_$year

if [ ! -d $rawdir1 ]
then
  mkdir -p $rawdir1
fi

for ((y=$startjulianday; y<=$endjulianday; y++))
  do
    OUTPUT="$rawdir1/"ps.$year.$y.xml
    DBFLAG="-d $picks_storage"
    STORAGE=$DBFLAG
    CONFIGFLAGS="-H localhost:4803 --verbosity=4"
    FLAGS="$CONFIGFLAGS $STORAGE"
    sleep 2

    # Start EventParameters logging
    echo "...........Processing Day $y..........."
    echo "Starting autoloc..."
    scautoloc $FLAGS --playback --start-stop-msg=1 --auto-shutdown=1 --shutdown-master-module=scautopick --xxl-enable=1 &
    echo "Starting magtool..."
    scmag $FLAGS --start-stop-msg=1 --auto-shutdown=1 --shutdown-master-module=scautoloc &
    echo "Starting eventtool..."
    scevent $FLAGS --start-stop-msg=1 --auto-shutdown=1 --shutdown-master-module=scmag --db-disable &
    echo "Starting sceplog..."
    sceplog $CONFIGFLAGS --auto-shutdown=1 --shutdown-master-module=scevent > $OUTPUT &
    pid=$!
    echo "Starting autopick..."
    #seiscomp exec scart -ds -n "$1" -t "$2~$3" /home/sysop/seiscomp3/var/lib/archive/ | scautopick -I - $FLAGS --start-stop-msg=1
    scautopick --playback -I file://$rawdir/mseed.sorted.$year.$y $FLAGS --start-stop-msg=1
    echo "Finished waveform processing"
    wait $pid
    echo "Finished event processing"
done
