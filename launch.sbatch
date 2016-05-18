#!/bin/bash -l
#
#========================================
# DESCRIPTION
#========================================
# The script runs an OSU MPI bandwidth benchmark from a Shifter container
#
#========================================
# SLURM VARIABLES (APPLICATION SPECIFIC)
#========================================
#SBATCH --job-name="shifter-mpi"
#SBATCH --nodes=2-2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --image=docker:lichinka/shifter-mpi:0.3
#
#========================================
# MODULE SETUP
#========================================
if [ -z "$( module list 2>&1 | grep PrgEnv-gnu )" ]; then
    module swap PrgEnv-cray PrgEnv-gnu;
fi
module load cray-mpich/7.3.2;
module load shifter;
#
#========================================
# RUNTIME SETUP
#========================================
JOB_LIBDIR="$( pwd )/.shifter-${SLURM_JOBID}"
JOB_SYSDIR="${CRAY_MPICH2_DIR}/lib /opt/cray/pmi/default/lib64 /opt/cray/ugni/default/lib64 /opt/cray/udreg/default/lib64 /opt/cray/xpmem/default/lib64 /opt/cray/alps/default/lib64 /opt/cray/wlm_detect/default/lib64/"

echo -n "Checking system directories ... "
for d in ${JOB_SYSDIR}; do
    if [ ! -d ${d} ]; then
        echo "<${d}> does not exist"
        exit 1
    fi
done
echo "done"

echo -n "Gathering required libraries ... "
mkdir ${JOB_LIBDIR}
for d in ${JOB_SYSDIR}; do
    rsync -a ${d}/* ${JOB_LIBDIR}/
done
ln -s ${JOB_LIBDIR}/libmpl.so.0.0.0 ${JOB_LIBDIR}/libmpl.so.1
echo "done"

#
#========================================
# RUN
#========================================
srun shifter --volume=${JOB_LIBDIR}:/usr/local/shifter/lib /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw

#
#========================================
# CLEAN UP
#========================================
echo -n "Cleaning up ... "
rm -r ${JOB_LIBDIR}
echo "done"
