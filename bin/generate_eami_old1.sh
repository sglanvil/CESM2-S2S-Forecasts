#!/bin/bash
# sglanvil | July 24, 2024
# location: /global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/E3SM-Realtime-Forecast/bin
source /global/common/software/e3sm/anaconda_envs/load_latest_e3sm_unified_pm-cpu.sh

pertsNeeded=12 # has to be an even number
numbers=()
seen=()
for ((i = 0; i < $(( pertsNeeded/2 )); i++)); do
	echo $i
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

original_file=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/v21.LR.SMYLE_IC.2012-05.01/2012-05-01/v21.LR.SMYLE_IC.2012-05.01.eam.i.2012-05-01-00000.nc
echo "${numbers[@]}"
for ((i = 0; i < $(( pertsNeeded/2 )); i++)); do
	pert_file=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/S2S_perts_DIFF/05/v2.LR.historical_daily-cami_0241.eam.i.M05.diff.${numbers[i]}.nc
	echo ${pert_file}
	pert1=$(printf "%02d" $(( i*2 + 1 )))
	pert2=$(printf "%02d" $(( i*2 + 2 )))
	final_file1=/global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/E3SM-Realtime-Forecast/bin/StageIC/pert.${pert1}/v21.LR.SMYLE_IC.pert.eam.i.2012-05-01-tmp.nc
	final_file2=/global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/E3SM-Realtime-Forecast/bin/StageIC/pert.${pert2}/v21.LR.SMYLE_IC.pert.eam.i.2012-05-01-tmp.nc
	mkdir -p $(dirname ${final_file1}) 
	mkdir -p $(dirname ${final_file2})
	ncflint -O -C -v time_bnds,lev,ilev,hyai,hybi,hyam,hybm,U,V,T,Q,PS -w 0.15,1.0 ${pert_file} ${original_file} ${final_file1}
	ncflint -O -C -v time_bnds,lev,ilev,hyai,hybi,hyam,hybm,U,V,T,Q,PS -w -0.15,1.0 ${pert_file} ${original_file} ${final_file2}
	ncrename -d ncol_d,ncol ${final_file1}
	ncrename -d ncol_d,ncol ${final_file2}
	echo
done

# 1. grab the land IC
# 2. grab the ocean IC (year conversion AND ncrename xtime the mpasso and mpassi files)
	# ncrename -v xtime,xtime.orig 



