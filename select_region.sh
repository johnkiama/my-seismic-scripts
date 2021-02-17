awk "{print NF}" < 201701.csv | uniq

# selecting region of interest

#echo $1 #latmin
#echo $2 #latmax
#echo $3 #lonmin
#echo $4 #lonmax
#echo $5 #input_file
#echo $6 #out_file

awk -F "\t" '{
 
  if(($9 >= 0.5 && $9 <= 0.7) && ($10 >= 36.000 && $10 <= 36.4)) { print } 

}' 201701.csv


#awk '{if(($9 >= 0.5 && $9 <= 0.7) && ($10 >= 36.000 && $10 <= 36.9)) { print } }' 201701.csv >> $6

