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

source <(grep = <(grep -A4 '\[section-tomsd\]' $_scriptConfigs | sed 's/ *= */=/g'))


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

if [ ${#arr_stat[@]} != ${#arr_station[@]} ]
  then
    zenity   --info  --title  "Info dialog"  --text "Number of Das and station mismatch"
  exit 0
fi



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
    while [ $numberOfStations -lt ${#arr_stat[@]} ]
      do
        station=${arr_station[numberOfStations]}
        das=${arr_stat[numberOfStations]}
        numberOfStations=`expr $numberOfStations + 1`
    
        source <(grep = <(grep -A2 '\[files-tomsd\]' $_scriptConfigs | sed 's/ *= */=/g'))

        in_dir=$input/$k/$station/"/1"
        out_dir=$output/$k/$station"/"
          
      if [ -d $in_dir ]; then
        cd $in_dir
        for i in `find -type f`
          do
            rt_mseed -B512 $i 
        done

        #echo $out_dir

        if [ ! -d $out_dir ]; then
          mkdir -p $out_dir
        fi
        #echo in_dir $out_dir

        mv *_1_?.msd $out_dir

        cd $out_dir
        #echo 'pwd'

        for f in `ls *_1_1.msd `; do
	  mseedmod -S $station -C HHZ -N PS -L 00 $f
	done
	for f in `ls *_1_2.msd `; do
	  mseedmod -S $station -C HHN -N PS -L 00 $f
	done
	for f in `ls *_1_3.msd `; do
	  mseedmod -S $station -C HHE -N PS -L 00 $f
        done
      fi
    
  done
echo "Finished Converting Data To msd" 
done
