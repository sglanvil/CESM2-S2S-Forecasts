#!/bin/bash

dir=/pscratch/sd/n/nanr/ERA5_init/CATALYST_init/

d=1999-01-04 # specify monday start date (the INCLUDED monday)
while [ "$d" != 2021-01-04 ]; do # specify monday end date (the EXCLUDED monday)
        year=$(date -d "$d" +%Y)
        month=$(date -d "$d" +%m)
        day=$(date -d "$d" +%d)
	if ! ls ${dir}/eami.HICCUP-ERA5-CATALYST.${d}.ne30np4.L72.c20240803.nc > /dev/null 2>&1; then
		echo ${d}
	fi
	d=$(date -I -d "$d + 7 day")
done


