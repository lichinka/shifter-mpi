#!/bin/bash -l
#
#========================================
# DESCRIPTION
#========================================
# The script runs an OSU MPI bandwidth
# benchmark from a Shifter container
#
#========================================
# SLURM VARIABLES (APPLICATION SPECIFIC)
#========================================
#SBATCH --job-name="shifter-mpi"
#SBATCH --nodes=2-2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --partition=bigmem
#
#========================================
# MODULE SETUP
#========================================
if [ -z "$( module list 2>&1 | grep PrgEnv-gnu )" ]; then
    module swap PrgEnv-cray PrgEnv-gnu;
fi
module load shifter/20160422;
module unload cray-mpich;
module load cray-mpich-abi;
#
#========================================
# RUNTIME SETUP
#========================================
JOB_LIBDIR="${SCRATCH}/.shifter-${SLURM_JOBID}"
JOB_SYSDIR="${CRAY_LD_LIBRARY_PATH}:/opt/cray/wlm_detect/default/lib64/"

echo -n "Checking system directories ... "
for d in $( echo "${JOB_SYSDIR}" | tr ':' ' ' ); do
    if [ ! -d ${d} ]; then
        echo "<${d}> does not exist"
        exit 1
    fi
done
echo "done"

echo -n "Gathering required libraries ... "
mkdir ${JOB_LIBDIR}
for d in $( echo "${JOB_SYSDIR}" | tr ':' ' ' ); do
    rsync -a ${d}/* ${JOB_LIBDIR}/
done
echo "done"

#
#========================================
# RUN
#========================================
export LD_LIBRARY_PATH=${JOB_LIBDIR}
srun -vvv ${SCRATCH}/osu-bench/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw

#
#========================================
# CLEAN UP
#========================================
echo -n "Cleaning up ... "
rm -r ${JOB_LIBDIR}
echo "done"
