#!/bin/bash -l

#SBATCH --job-name="shifter-mpi"
#SBATCH --nodes=2-2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --image=docker:lichinka/shifter-mpi:0.2

JOB_LIBDIR="$( pwd )/.shifter-${SLURM_JOBID}"
JOB_SYSDIR="/opt/cray/wlm_detect/default/lib64 /opt/cray/mpt/default/gni/mpich-gnu/49/lib /opt/cray/pmi/default/lib64 /opt/cray/ugni/default/lib64 /opt/cray/udreg/default/lib64 /opt/cray/xpmem/default/lib64 /opt/cray/alps/default/lib64 /opt/gcc/4.9.3/snos/lib64"

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
ln -s ${JOB_LIBDIR}/libmpich_gnu_49.so ${JOB_LIBDIR}/libmpl.so.1
cp libopa.* ${JOB_LIBDIR}
echo "done"

srun shifter --volume=${JOB_LIBDIR}:/usr/lib/x86_64-linux-gnu /home/docker/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw

#echo -n "Cleaning up ... "
#rm -r ${JOB_LIBDIR}
#echo "done"
#
#srun shifter --volume=$( pwd )/.mpi_libs:/usr/lib/x86_64-linux-gnu      \
#             /home/docker/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw
