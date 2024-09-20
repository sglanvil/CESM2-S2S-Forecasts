#!/bin/bash

caseDir=/pscratch/sd/s/sglanvil/v21.LR.S2Ssmbb/TEST_RUNS/v21.LR.S2Ssmbb.2000-01-03.001/case_scripts.001/

cd ${caseDir}	
sed -i '/#SBATCH  --constraint=cpu/a #SBATCH  --reservation=e3sm_s2s_one_year' .case.run
sed -i '/#SBATCH  --constraint=cpu/a #SBATCH  --reservation=e3sm_s2s_one_year' .case.run.sh
sed -i '/#SBATCH  --constraint=cpu/a #SBATCH  --reservation=e3sm_s2s_one_year' case.st_archive

