#!/bin/bash

set -e

docker run \
       --rm=true \
       --volume=/cm/shared/apps/mvapich2/gcc/64/2.2b/lib/libmpich.so:/usr/lib/x86_64-linux-gnu/libmpich.so.12 \
       --volume=/cm/shared/apps/mvapich2/gcc/64/2.2b/lib/libopa.so:/usr/lib/x86_64-linux-gnu/libopa.so.1 \
       --volume=/cm/shared/apps/mvapich2/gcc/64/2.2b/lib/libmpl.so:/usr/lib/x86_64-linux-gnu/libmpl.so.1 \
       --volume=/lib64/libxml2.so.2:/usr/lib/libxml2.so.2                                                \
       --volume=/lib64/libibmad.so.5:/usr/lib/libibmad.so.5                                              \
       --volume=/lib64/librdmacm.so.1:/usr/lib/librdmacm.so.1                                            \
       --volume=/lib64/libibumad.so.3:/usr/lib/libibumad.so.3                                            \
       --volume=/lib64/libibverbs.so.1:/usr/lib/libibverbs.so.1                                          \
       --volume=/lib64/libnl.so.1:/usr/lib/libnl.so.1                                                    \
       --volume=/lib64/libmlx5-rdmav2.so:/usr/lib/libmlx5-rdmav2.so                                      \
       --volume=/lib64/libmlx4-rdmav2.so:/usr/lib/libmlx4-rdmav2.so                                      \
       --volume=/etc/libibverbs.d:/etc/libibverbs.d                                                      \
       shifter-mpi:0.1
