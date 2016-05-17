#!/bin/bash

set -e

MPI_HOST=/opt/mpich
MPI_CONT=/usr/lib/x86_64-linux-gnu

docker run --rm=true \
           --volume=${MPI_HOST}/lib/libmpich.so:${MPI_CONT}/libmpich.so.12 \
           --volume=${MPI_HOST}/lib/libopa.so:${MPI_CONT}/libopa.so.1      \
           --volume=${MPI_HOST}/lib/libmpl.so:${MPI_CONT}/libmpl.so.1      \
           shifter-mpi:0.1                                                 \
           /home/docker/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw
