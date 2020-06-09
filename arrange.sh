#!/bin/bash

#Script to rearrange reftek data
#Script by John Kiama
########################################################################################
#Set your variables
########################################################################################

echo "$(tput setaf 4)YOU ARE RUNNING GDC SEISMIC DATA ARRANGEMENT SCRIPT$(tput sgr 0)"
echo ""

#x=$(readlink -f configSettings.ini)
# echo $(dirname $x)
#cat configSettings.ini |tr a-z A-Z >>/tmp/configSettings.ini


_scriptConfigs=$(readlink -f configSettings.ini)

source <(grep = <(grep -A5 '\[section-arrange\]' $_scriptConfigs | sed 's/ *= */=/g'))


memory_card=("D1" "D2")

reg='^[0-9]{7}$'
           
echo "$(tput setaf 1)PROCESSING: $(tput sgr 0)"$@
echo ""


function validate(){

if [[ ! ($startjulianday =~ $reg && $endjulianday =~ $reg) ]]
  then
    zenity   --info  --title  "Info dialog"  --text "Incomplete digits for start or end julian day"
  exit 0
fi

if [ ${#arr_stat[@]} != ${#arr_station[@]} ]
  then
    zenity   --info  --title  "Info dialog"  --text "Number of Das and station mismatch"
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

source <(grep = <(grep -A2 '\[files-arrange\]' $_scriptConfigs | sed 's/ *= */=/g'))

for ((k=$startjulianday; k<=$endjulianday; k++))
  do
    numberOfStations=0
    while [ $numberOfStations -lt ${#arr_stat[@]} ]
      do
        station=${arr_station[numberOfStations]}
        das=${arr_stat[numberOfStations]}
        numberOfStations=`expr $numberOfStations + 1`
      for twoCards in {0..1}
        do
          memory=${memory_card[twoCards]}
########################################################################################
#The user is allowed to change this patr of the code
########################################################################################      
          rawdir="$input/$datafolder/"$station/$memory/$k/$das 
          newdir="$output/"$k/$station
########################################################################################          
        function copyData(){
          
          if [ -d $rawdir"/$MemoryCard" ]; then
            if [ ! -d $newdir ]; then
              mkdir -p $newdir
            fi

            echo ""
            echo "$(tput setaf 1)Wait !! Files copying$(tput sgr 0).........||............||..........................."
            cp -r $rawdir"/$MemoryCard" $newdir"/." 
            echo "$rawdir"/$MemoryCard" $(tput setaf 1)--->$(tput sgr 0) $newdir"
          else 
            echo "Check if file exist" >/dev/null
          fi
          }
          MemoryCard=0
          while [ $MemoryCard -lt ${#memory_card[@]} ]
            do
              copyData
              MemoryCard=`expr $MemoryCard + 1`    
          done 
          
      done
    done
done
