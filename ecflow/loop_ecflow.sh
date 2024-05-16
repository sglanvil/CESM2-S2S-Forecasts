#!/bin/bash
# sglanvil, 09feb2024

cd /glade/u/home/ssfcst/cesm2cam6_land0.5/CESM2-Realtime-Forecast/ecflow
export ECF_PORT=35254
export ECF_HOST=derecho2
export CESM_WORKFLOW=cesm2cam6_land0.5
export PROJECT=CESM0021

d=2023-01-02 # specify monday start date (the INCLUDED monday)
while [ "$d" != 2023-09-04 ]; do # specify monday end date (the EXCLUDED monday)
	year=$(date -d "$d" +%Y)
	month=$(date -d "$d" +%m)
	day=$(date -d "$d" +%d)
	echo ${d}
	echo ${year}_${month}_${day}
	python workflow.py --date ${d}
	python cesm2cam6_land0.5_${year}_${month}_${day}/client.py
	echo	
	d=$(date -I -d "$d + 7 day")
done

