#!/bin/bash
# sglanvil | August 1, 2024
# location: /global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/E3SM-Realtime-Forecast/bin/

srcDir=/pscratch/sd/n/nanr/v21.LR.SMYLE/v21.LR.I20TRELM_CRUNCEP-daily/archive/rest/
destDir=/global/cfs/cdirs/mp9/E3SMv2.1-S2S/v21.LR.I20TRELM_CRUNCEP-daily/

d=1999-01-04 # specify monday start date (the INCLUDED monday)
while [ "$d" != 2021-01-04 ]; do # specify monday end date (the EXCLUDED monday)
        year=$(date -d "$d" +%Y)
        month=$(date -d "$d" +%m)
        day=$(date -d "$d" +%d)
	echo ${d}
	if ls ${srcDir}/${d}-00000/*elm.r.* 1> /dev/null 2>&1; then
		cp ${srcDir}/${d}-00000/*.elm.r.* ${destDir}/
		cp ${srcDir}/${d}-00000/*.mosart.r.* ${destDir}/
	else
		echo "File does not exist: ${d}"
	fi
        d=$(date -I -d "$d + 7 day")
done

