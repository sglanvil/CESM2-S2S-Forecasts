#!/bin/bash
# sglanvil | July 23, 2024

DATE=2012-05-01

YEAR=$(echo $DATE | cut -d'-' -f1)
MONTH=$(echo $DATE | cut -d'-' -f2)
DAY=$(echo $DATE | cut -d'-' -f3)
if [ $YEAR -lt 2014 ] || ( [ $YEAR -eq 2014 ] && [ $MONTH -lt 11 ] ); then
	COMPSET=WCYCL20TR
else
	COMPSET=WCYCLSSP370
fi
RESOLUTION=ne30pg2_EC30to60E2r2
MACHINE=pm-cpu
PROJECT=mp9
SOURCE_CODE=/global/cfs/cdirs/mp9/e3sm_tags/E3SMv2.1/cime/scripts/
mkdir -p ${SCRATCH}/v21.LR.S2Ssmbb/
CASE_BUILD_DIR=${SCRATCH}/v21.LR.S2Ssmbb/exeroot/bld/
NAMELISTS_DIR=/global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/E3SM-Realtime-Forecast/bin/namelists/
SOURCEMODS_DIR=/global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/E3SM-Realtime-Forecast/bin/sourceMods/

for mbr in {001..011}; do
	RUN_REFDIR=/global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/E3SM-Realtime-Forecast/bin/StageIC/
	RUN_REFCASE=v21.LR.SMYLE_IC.${YEAR}-${MONTH}.01
	MAIN_CASE_NAME=v21.LR.S2Ssmbb.${YEAR}-${MONTH}-${DAY}.001
	CASE_NAME=v21.LR.S2Ssmbb.${YEAR}-${MONTH}-${DAY}.${mbr}
	MAIN_CASE_ROOT=${SCRATCH}/v21.LR.S2Ssmbb/${MAIN_CASE_NAME}/
	CASE_ARCHIVE_DIR=${MAIN_CASE_ROOT}/archive.${mbr}/
	CASE_SCRIPTS_DIR=${MAIN_CASE_ROOT}/case_scripts.${mbr}/
	CASE_RUN_DIR=${MAIN_CASE_ROOT}/run.${mbr}/

	# ------------------ CREATE NEWCASE ------------------ 
	cd ${SOURCE_CODE}
	./create_newcase --compset ${COMPSET} --res ${RESOLUTION} --case ${CASE_NAME} \
		--project ${PROJECT} --machine ${MACHINE} --output-root ${MAIN_CASE_ROOT} \
		--script-root ${CASE_SCRIPTS_DIR} --handle-preexisting-dirs u 
	cd ${CASE_SCRIPTS_DIR}

	# ---------------------------- CASE SETUP, COPY NAMELISTS, COPY SOURCE MODS, COPY ENV_MACH ----------------------------
	if [ -d ${CASE_BUILD_DIR} ]; then
		./xmlchange EXEROOT=${CASE_BUILD_DIR}
	fi
	./xmlchange RUNDIR=${CASE_RUN_DIR}
	./xmlchange DOUT_S_ROOT=${CASE_ARCHIVE_DIR}
	cp ${NAMELISTS_DIR}/user_nl* .
	./case.setup --reset
	cp /global/u2/n/nanr/CESM_tools/e3sm/v2/scripts/v2.SMYLE/env_mach/env_mach_specific.xml ${CASE_SCRIPTS_DIR}/
	cp -r ${SOURCEMODS_DIR}/* ${CASE_SCRIPTS_DIR}/SourceMods/

	# ---------------------------- PRESTAGE IC FILES ----------------------------
	cp ${RUN_REFDIR}/* ${CASE_RUN_DIR}/

	# ---------------------------- BUILD CASE ----------------------------
	if [ -d ${CASE_BUILD_DIR} ]; then
		./xmlchange BUILD_COMPLETE=TRUE
	else
		./case.build
		sleep 5s
		# CREATE and COPY the EXEROOT on the very FIRST (and ONLY) build (literally, happens only once)
		bldDir=$(find ${SCRATCH}/v21.LR.S2Ssmbb/ -d -name "bld")
		exeDir=$(dirname ${bldDir})
		cp -r ${exeDir} ${SCRATCH}/v21.LR.S2Ssmbb/exeroot
		sleep 5s
	fi
	./preview_namelists

	# ---------------------------- XML CHANGES ----------------------------
	./xmlchange RUN_STARTDATE=${DATE}
	./xmlchange STOP_OPTION=ndays
	./xmlchange STOP_N=45
	./xmlchange BUDGETS=TRUE
	./xmlchange RUN_TYPE=hybrid
	./xmlchange CONTINUE_RUN=FALSE
	./xmlchange GET_REFCASE=FALSE
	./xmlchange RUN_REFDIR=${RUN_REFDIR}
	./xmlchange RUN_REFCASE=${RUN_REFCASE}
	./xmlchange RUN_REFDATE=${DATE}
	./xmlchange DOUT_S=TRUE
	./xmlchange JOB_WALLCLOCK_TIME=01:00:00 --subgroup case.run

	# ---------------------------- SUBMIT RUN ----------------------------
	./case.submit
done

# DONE: add output variables (SourceMod)
# DONE: organize fincl variables (user_nl) to match CESM
# DONE: make if statement for BUILD_COMPLETE bit
# make the generate eami, rename bits



