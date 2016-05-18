FROM python:3.4-slim 

RUN apt-get update                          && \
    apt-get install -y file             \
                       g++              \
                       gcc              \
                       gfortran         \
                       make             \
                       wget             \
                    --no-install-recommends
# user and locale configuration
RUN useradd -m docker                                   && \
    cp /usr/share/zoneinfo/Europe/Zurich /etc/localtime

WORKDIR /home/docker
ENV     HOME /home/docker

# system-specific libraries
ADD shifter_libs.tgz /usr/local
RUN printf "# Shifter specific configuration\n/usr/local/shifter/lib\n" > /etc/ld.so.conf.d/shifter.conf
RUN ldconfig

# install OSU Micro-Benchmarks
RUN wget -q -O osu.tar.gz \
         http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.3.tar.gz && \
    tar xvzf osu.tar.gz                                && \
    cd osu-micro-benchmarks-5.3                        && \
    ./configure --prefix=/usr/local CC=$( which gcc ) CFLAGS="-D_FORTIFY_SOURCE=2 -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wl,-z,relro -I/usr/local/shifter/include" LDFLAGS="-L/usr/local/shifter/lib -lmpich -lopa -lmpl -lrt -lpthread" && \
    make                                               && \
    make install

WORKDIR /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt

CMD ["mpiexec", "-n", "2", "-bind-to", "core", "./osu_bw"]
