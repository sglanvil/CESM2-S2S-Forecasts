#!/bin/bash
# sglanvil | August 1, 2024
# location: /global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/E3SM-Realtime-Forecast/bin/

inputYear=$1
destDir=/global/cfs/cdirs/mp9/E3SMv2.1-S2S/cycle6_daily-restarts_MONDAYS/${inputYear}
mkdir -p ${destDir}
cd ${destDir}
rm -r ${destDir}/zstash

start_date=$(date -I -d "${inputYear}-01-01")
end_date=$(date -I -d "$(( inputYear + 1 ))-01-01")
while [ $(date -d "$start_date" +%u) -ne 1 ]; do
        start_date=$(date -I -d "$start_date + 1 day")
done
while [ $(date -d "$end_date" +%u) -ne 1 ]; do
        end_date=$(date -I -d "$end_date + 1 day")
done

echo
echo ${start_date} ${end_date}
pwd
echo

source /global/common/software/e3sm/anaconda_envs/load_latest_e3sm_unified_pm-cpu.sh
d=${start_date} # specify monday start date (the INCLUDED monday)
while [ "$d" != ${end_date} ]; do # specify monday end date (the EXCLUDED monday)
        year=$(date -d "$d" +%Y)
        month=$(date -d "$d" +%m)
        day=$(date -d "$d" +%d)
        echo ${d}
	oyear=$(printf "%04d" $(( year - 1957 )))
	echo ${oyear}-${month}-${day}

	FILE_COUNT=$(ls "${destDir}/rest/${oyear}-${month}-${day}-00000/"*.rst.* 2>/dev/null | wc -l)
	if [ "$FILE_COUNT" -lt 2 ]; then
		echo file does not exist
		if [ $oyear -ge 31 ] && [ $oyear -le 49 ]; then
			zstash extract --hpss=/home/l/lvroekel/E3SMv2/20240603_EC30to60_cycle6_daily_restarts_anvil_rsts_31_50 *mpaso.rst.${oyear}-${month}-${day}_00000.nc
			zstash extract --hpss=/home/l/lvroekel/E3SMv2/20240603_EC30to60_cycle6_daily_restarts_anvil_rsts_31_50 *mpassi.rst.${oyear}-${month}-${day}_00000.nc
		fi
		if [ $oyear -ge 50 ] && [ $oyear -le 67 ]; then
			zstash extract --hpss=/home/l/lvroekel/E3SMv2/20240603_EC30to60_cycle6_daily_restarts_anvil_rsts_51_67 *mpaso.rst.${oyear}-${month}-${day}_00000.nc
			zstash extract --hpss=/home/l/lvroekel/E3SMv2/20240603_EC30to60_cycle6_daily_restarts_anvil_rsts_51_67 *mpassi.rst.${oyear}-${month}-${day}_00000.nc
		fi
	fi
	echo
        d=$(date -I -d "$d + 7 day")
done

echo
echo "Totally Done"
