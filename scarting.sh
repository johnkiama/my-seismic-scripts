#!/bin/bash
################################################################
#Developed By:J Kiama,Gdc,Kenya
################################################################

arr_month=("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
arr_num=(01 02 03 04 05 06 07 08 09 10 11 12)

function checkMonth(){
for i in {0..11}
  do
    month=${arr_month[i]}
    numeral=${arr_num[i]}
  if [ "$month" == "$m" ]
    then
      m=$numeral
  fi
done
}

echo "$(tput setaf 4)YOU ARE RUNNING GDC SEISMIC DATA SCART SCRIPT$(tput sgr 0)"
echo ""

_scriptConfigs=$(readlink -f configSettings.ini)

source <(grep = <(grep -A3 '\[section-scart\]' $_scriptConfigs | sed 's/ *= */=/g'))

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


for ((y=$startjulianday; y<=$endjulianday; y++))
  do
  
    echo "date -d '$year-01-01 `expr $y - 1` days'">.dat.sh 

    sh .dat.sh | xargs echo | awk '{print $3}' |while read l;do echo "Please wait processing day ...$y... might take a while.........||..........."
    sh .dat.sh | awk '{print $2}' |while read m;do echo "Grab a cup of Kenyan tea........................||......................................."
    rm .dat.sh

   checkMonth

   sleep 2

source <(grep = <(grep -A3 '\[files-scart\]' $_scriptConfigs | sed 's/ *= */=/g'))

rawdir="$scart_out_dir/"PS_SCART_$year
#rawdir="scart_out_dir"
if [ ! -d $rawdir ]
  then
    mkdir -p $rawdir
fi

archdir="$scart_inp_dir"

echo "scart -dsvt '$year-$m-$l 00:00:00 ~ $year-$m-$l 23:59:59' $archdir > $rawdir/mseed.sorted.$year.$y" > .scarted.sh | sh .scarted.sh

rm .scarted.sh

echo "Finished Scarting Day ...$y..."
done
done
done
