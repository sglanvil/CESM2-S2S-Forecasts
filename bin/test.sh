#!/bin/bash


year=2020
start_date=$(date -d "${year}-01-01")
end_date=$(date -d "$(( year + 1 ))-01-01")

while [ $(date -d "$start_date" +%u) -ne 1 ]; do
	start_date=$(date -I -d "$start_date + 1 day")
done
while [ $(date -d "$end_date" +%u) -ne 1 ]; do
	end_date=$(date -I -d "$end_date + 1 day")
done

echo ${start_date}
echo ${end_date}




