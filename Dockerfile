FROM python:3.4-slim 

RUN apt-get update                          && \
    apt-get install -y libmpich-dev      \
                        make             \
                        mpich2           \
                        wget             \
                    --no-install-recommends

# install OSU Micro-Benchmarks
WORKDIR /usr/local/src

RUN wget -q -O osu.tar.gz \
         http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.3.tar.gz && \
    tar xvzf osu.tar.gz                                  && \
    cd osu-micro-benchmarks-5.3                          && \
    ./configure --prefix=/usr/local CC=$( which mpicc ) CXX=$( which mpicxx ) && \
    make                                                 && \
    make install

WORKDIR /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt

CMD ["mpiexec", "-n", "2", "-bind-to", "core", "./osu_bw"]
