#!/bin/bash

DATE=2000-02-07

for mbr in {001..011}; do
	echo ${mbr}
	ARCHIVE_DIR=$SCRATCH/v21.LR.S2Ssmbb/v21.LR.S2Ssmbb.${DATE}.001/archive.${mbr}
	CASE_DIR=$SCRATCH/v21.LR.S2Ssmbb/v21.LR.S2Ssmbb.${DATE}.001/case_scripts.${mbr}
	RUN_DIR=$SCRATCH/v21.LR.S2Ssmbb/v21.LR.S2Ssmbb.${DATE}.001/run.${mbr}

	file_date=$(tail -n 2 ${CASE_DIR}/CaseStatus | head -n 1 | awk '{print $1}')
	today_date=$(date +"%Y-%m-%d")
	if [ "$file_date" == "$today_date" ]; then
		echo "The date in the CaseStatus matches today's date. You probably already resubmitted."
		continue
	fi

	if [ ! -d ${ARCHIVE_DIR} ]; then
		echo ${DATE}, member ${mbr} does not exist
		cd ${CASE_DIR}
		./case.submit
		sleep 5s
	fi
done

