#!/bin/bash

DATE=2004-03-29 # specify monday start date (the INCLUDED monday)
while [ "${DATE}" != 2014-01-06 ]; do # specify monday end date (the EXCLUDED monday)
        echo ${DATE}
	for mbr in {001..011}; do
		ARCHIVE_DIR=$SCRATCH/v21.LR.S2Ssmbb/v21.LR.S2Ssmbb.${DATE}.001/archive.${mbr}
		CASE_DIR=$SCRATCH/v21.LR.S2Ssmbb/v21.LR.S2Ssmbb.${DATE}.001/case_scripts.${mbr}
		RUN_DIR=$SCRATCH/v21.LR.S2Ssmbb/v21.LR.S2Ssmbb.${DATE}.001/run.${mbr}
		if [[ ! -f "${CASE_DIR}/CaseStatus" ]]; then
			echo "Warning: CaseStatus file is missing. Skipping ${mbr}."
			continue
		fi
		lastStatus=$(tail -n 2 "${CASE_DIR}/CaseStatus" | head -n 1)
		if [[ ! "${lastStatus}" == *"st_archive success"* ]]; then			
                        cd ${CASE_DIR}
			sed -i '/<directive> --reservation=e3sm_s2s_one_year<\/directive>/d' env_batch.xml
                        sed -i '/#SBATCH  --reservation=e3sm_s2s_one_year/d' .case.run
                        sed -i '/#SBATCH  --reservation=e3sm_s2s_one_year/d' .case.run.sh
                        sed -i '/#SBATCH  --reservation=e3sm_s2s_one_year/d' case.st_archive
			if [[ "${lastStatus}" == *"case.run success"* ]]; then
                                echo "${mbr}: need to submit archive"
                                #cd ${CASE_DIR}
                                #./case.st_archive > /dev/null 2>&1
			else
				echo "${mbr}: need to submit run"
				cd ${CASE_DIR}
				./xmlchange JOB_WALLCLOCK_TIME=01:00:00 --subgroup case.st_archive
				./xmlchange JOB_QUEUE=overrun --force
				sed -i '/      <directive> --exclusive <\/directive>/a\      <directive> --time-min=01:00:00 <\/directive>' env_batch.xml
				./case.submit > /dev/null 2>&1
				sleep 1s
			fi

#			elif grep -F "ERROR: sum of areas on globe does not equal 4*pi" ${RUN_DIR}/*log* > /dev/null 2>&1; then
#				echo "${mbr}: ATMOS problem"
#			elif grep -F "ERROR: sum of wt_nat_patch not 1.0 at" ${RUN_DIR}/*log* > /dev/null 2>&1; then
#				echo "${mbr}: LAND problem"
#			elif grep -F "DUE TO TIME LIMIT" ${RUN_DIR}/*log*  > /dev/null 2>&1; then
#				echo "${mbr}: WALLCLOCK problem"
#			elif [[ ! -f "${RUN_DIR}/*log*" ]]; then
#				echo "${mbr}: NO LOG FILES (never ran)"
#			else
#				echo "${mbr}: unknown problem"
#			fi	
		fi
	done
	DATE=$(date -I -d "${DATE} + 7 day")
done


