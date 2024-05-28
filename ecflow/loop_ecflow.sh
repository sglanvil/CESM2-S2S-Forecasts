#!/bin/bash
# sglanvil, 09feb2024

cd /glade/u/home/ssfcst/cesm2cam6climoLND/CESM2-Realtime-Forecast/ecflow
export ECF_PORT=35254
export ECF_HOST=derecho2
export CESM_WORKFLOW=cesm2cam6climoLND
export PROJECT=CESM0021

d=2022-05-30 # specify monday start date (the INCLUDED monday)
while [ "$d" != 2022-09-05 ]; do # specify monday end date (the EXCLUDED monday)
	year=$(date -d "$d" +%Y)
	month=$(date -d "$d" +%m)
	day=$(date -d "$d" +%d)
	echo ${d}
	echo ${year}_${month}_${day}
	python workflow.py --date ${d}
	python cesm2cam6climoLND_${year}_${month}_${day}/client.py
	echo	
	d=$(date -I -d "$d + 7 day")
done

