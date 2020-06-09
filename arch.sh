#!/bin/bash 

#Script to rearrange reftek data
#Script by John Kiama
########################################################################################
#Set your variables
########################################################################################

echo "$(tput setaf 4)YOU ARE RUNNING GDC SEISMIC DATA PROCESSING SCRIPT$(tput sgr 0)"
echo ""

sleep 1

_scriptConfigs=$(readlink -f configSettings.ini)

source <(grep = <(grep -A4 '\[section-archive\]' $_scriptConfigs | sed 's/ *= */=/g'))

sleep 1
reg='^[0-9]{7}$'

      
echo "$(tput setaf 1)PROCESSING: $(tput sgr 0)"$@
echo ""


function validate(){

if [[ ! ($startjulianday =~ $reg &&  $endjulianday =~ $reg) ]]
  then
    zenity   --info  --title  "Info dialog"  --text "Incomplete digits for start or end julian day"
  exit 0
fi
}
validate

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

for ((k=$startjulianday; k<=$endjulianday; k++))
  do
    numberOfStations=0
    while [ $numberOfStations -lt ${#arr_station[@]} ]
      do
        station=${arr_station[numberOfStations]}
        numberOfStations=`expr $numberOfStations + 1`
        
        source <(grep = <(grep -A3 '\[files-archive\]' $_scriptConfigs | sed 's/ *= */=/g'))
        
        msd_dir="$inp_dir/"$k/$station
    
        #echo $k $station

      if [ -d $msd_dir ]; then
        cd $msd_dir
        echo `pwd`
        cat `ls *.msd` | scmssort -E > $k"."$station"."mseed
        scart -v -I $k"."$station"."mseed $out_dir
      fi
    done
done
