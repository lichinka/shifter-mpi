FROM python:3.4-slim 

RUN apt-get update                          && \
    apt-get install -y file             \
                       libmpich-dev     \
                       make             \
                       mpich2           \
                       openssh-server   \
                       wget             \
                    --no-install-recommends
# user and locale configuration
RUN useradd -m docker                                               && \
    cp /usr/share/zoneinfo/Europe/Zurich /etc/localtime

WORKDIR /home/docker
ENV     HOME /home/docker

# install OSU Micro-Benchmarks
RUN wget -q -O osu.tar.gz \
         http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.3.tar.gz && \
    tar xvzf osu.tar.gz                                  && \
    cd osu-micro-benchmarks-5.3                          && \
    ./configure --prefix=${HOME} CC=$( which mpicc ) CXX=$( which mpicxx ) && \
    make                                                 && \
    make install

# SSH configuration
ADD  ssh/id_rsa.pub .ssh/authorized_keys
RUN  chmod 700  $HOME/.ssh                       && \
     chmod 600  $HOME/.ssh/authorized_keys       && \
     mkdir      /var/run/sshd                    && \
     chmod 0755 /var/run/sshd                    && \
     cd /home/docker                             && \
     chown -R docker:docker .

WORKDIR /home/docker/libexec/osu-micro-benchmarks/mpi/pt2pt

CMD ["mpiexec", "-n", "2", "-bind-to", "core", "./osu_bw"]
