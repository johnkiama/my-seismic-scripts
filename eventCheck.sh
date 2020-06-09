#!/bin/bash

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

_scriptConfigs=$(readlink -f configSettings.ini)

source <(grep = <(grep -A4 '\[CheckEvent\]' $_scriptConfigs | sed 's/ *= */=/g'))

for ((u=$startjulianday; u<=$endjulianday; u++))
  do
  grep "GDC$year*" $playback_out_dir/PS_PLAYBACK_$year/ps.$year.$u.xml | echo "Event for ps.$year.$u.xml is: `wc -l`" 
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
done
