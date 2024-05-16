#!/bin/bash
# sglanvil, 09feb2024
# submit 2011-2020, Nov-Mar Mondays, 11 members

cd /glade/u/home/ssfcst/cesm2cam6_DARTatm/CESM2-Realtime-Forecast/ecflow
export ECF_PORT=35254
export ECF_HOST=derecho4
export CESM_WORKFLOW=cesm2cam6_DARTatm
export PROJECT=CESM0020

d=2018-01-01 # specify monday start date (the INCLUDED monday)
while [ "$d" != 2021-01-04 ]; do # specify monday end date (the EXCLUDED monday)
	year=$(date -d "$d" +%Y)
	month=$(date -d "$d" +%m)
	day=$(date -d "$d" +%d)
	if (( ${month#0} < 04 || ${month#0} > 10 )); then
		echo ${d}
		echo ${year}_${month}_${day}
		python workflow.py --date ${d}
		python cesm2cam6_DARTatm_${year}_${month}_${day}/client.py
	fi
	echo	
	d=$(date -I -d "$d + 7 day")
done

