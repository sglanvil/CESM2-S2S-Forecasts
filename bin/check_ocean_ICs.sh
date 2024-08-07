#!/bin/bash

dir=/global/cfs/cdirs/mp9/E3SMv2.1-S2S/cycle6_daily-restarts_MONDAYS/

for iyear in {1999..2020}; do
	count=$(ls ${dir}/${iyear}/rest | wc -l)
	echo ${iyear} ${count}
done


