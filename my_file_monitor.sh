#!/bin/bash
#script that identifies if changes have been done to a
#file and logs to the log-user-changes.txt file

modification_year=`date -r user-file |awk '{print $6}'`
modification_time=`date -r user-file |awk '{print $4}'`



if [ ! -f $(readlink -f logmd5.txt) ]; then
#  touch logmd5.txt
  md5sum user-file | awk '{print $1}'>logmd5.txt
fi

FILE1=$(md5sum user-file | awk '{print $1}')
FILE2=`cat logmd5.txt`
#FILE2=`cat logmd5.txt | tail -1` 
if [[ $FILE1 == $FILE2 ]]
then
        echo "File not changed"
#        md5sum user-file | awk '{print $1}'>>logmd5.txt
else     
        echo "File changed on $modification_year at $modification_time" >>log-user-changes.txt
        md5sum user-file | awk '{print $1}'>logmd5.txt

fi

