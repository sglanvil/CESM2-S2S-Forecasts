#!/bin/bash

inputYear=2013
start_date=$(date -I -d "${inputYear}-01-01")
end_date=$(date -I -d "$(( inputYear + 1 ))-01-01")
while [ $(date -d "$start_date" +%u) -ne 1 ]; do
        start_date=$(date -I -d "$start_date + 1 day")
done
while [ $(date -d "$end_date" +%u) -ne 1 ]; do
        end_date=$(date -I -d "$end_date + 1 day")
done
echo ${start_date} ${end_date}
echo

d=${start_date} # specify monday start date (the INCLUDED monday)
while [ "$d" != ${end_date} ]; do # specify monday end date (the EXCLUDED monday)
#d=2004-05-03 # specify monday start date (the INCLUDED monday)
#while [ "$d" != 2005-01-03 ]; do # specify monday end date (the EXCLUDED monday)
        year=$(date -d "$d" +%Y)
        month=$(date -d "$d" +%m)
        day=$(date -d "$d" +%d)
        echo $d
	bash runS2S.sh "$d" > out_${d} 2>&1 &
	echo
	d=$(date -I -d "$d + 7 day")
done

echo "Done with date loop."

