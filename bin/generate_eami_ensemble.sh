#!/bin/bash
# sglanvil | July 24, 2024
# location: /global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/E3SM-Realtime-Forecast/bin
source /global/common/software/e3sm/anaconda_envs/load_latest_e3sm_unified_pm-cpu.sh

# ---------- DO THIS AT TOP OF FORECAST RUN SCRIPT, BEFORE LOOPING THROUGH MEMBERS ----------
ensembleSize=11 
numbers=()
seen=()
for ((i = 0; i < $(( ensembleSize/2 )); i++)); do
	rand_num=$(( RANDOM % 999 + 1 ))
	formatted_num=$(printf "%03d" "$rand_num")
	while [[ " ${seen[@]} " =~ " $formatted_num " ]]; do
	# ----- create a new number if it is not unique -----
	rand_num=$(( RANDOM % 999 + 1 ))
	formatted_num=$(printf "%03d" "$rand_num")
	done
	numbers+=("$formatted_num")
	seen+=("$formatted_num")
done
echo "${numbers[@]}" > eamic_2012-05-01.1-10.txt
# ----------------------------------------------------------------------------------

echo "${numbers[@]}"
echo
original_file=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/v21.LR.SMYLE_IC.2012-05.01/2012-05-01/v21.LR.SMYLE_IC.2012-05.01.eam.i.2012-05-01-00000.nc
for ((i=1; i<=ensembleSize; i++)); do
        mbr=$(printf "%03d" $i)
	echo
	echo $mbr
	if [[ "$mbr" == "001" ]]; then
		# use original file
		echo "mbr: 001, use original file"
		echo ${original_file}
		continue
	fi
	mbr_num=$((10#$mbr))  # Convert to number to handle leading zeros
	if (( mbr_num % 2 == 0 )); then
		# mbr is even, use (mbr - 2) / 2
		inx=$(( (mbr_num - 2) / 2 ))
		weight=0.15
	else
		# mbr is odd, use (mbr - 3) / 2
		inx=$(( (mbr_num - 3) / 2 ))
		weight=-0.15
	fi
	echo "mbr: $mbr, inx: $inx, weight: $weight"
	pert_file=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/S2S_perts_DIFF/05/v2.LR.historical_daily-cami_0241.eam.i.M05.diff.${numbers[$inx]}.nc	
	echo ${pert_file}
	final_file=/global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/E3SM-Realtime-Forecast/bin/StageIC/pert.${mbr}/v21.LR.SMYLE_IC.pert.eam.i.2012-05-01-tmp.nc
	mkdir -p $(dirname ${final_file})
	ncflint -O -C -v time_bnds,lev,ilev,hyai,hybi,hyam,hybm,U,V,T,Q,PS -w ${weight},1.0 ${pert_file} ${original_file} ${final_file}
	ncrename -d ncol_d,ncol ${final_file}
	# 1. grab elm.r and mosart.r
	# 2. grab mpaso.rst mpassi.rst (do year conversion and ncrename xtime)
done



