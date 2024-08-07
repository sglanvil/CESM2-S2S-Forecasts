#!/bin/bash

for iyear in {1999..2020}; do
	nohup bash extract_ocean_ICs.sh ${iyear} > out_${iyear} 2>&1 &
done


