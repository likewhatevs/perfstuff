FROM fedora

ARG VER=1.0
RUN dnf install -y wget gcc make stress-ng awk bc
RUN wget "https://git.kernel.org/pub/scm/linux/kernel/git/mason/schbench.git/snapshot/schbench-${VER}.tar.gz"
RUN tar --strip-components=1 -xvf "schbench-${VER}.tar.gz"
RUN make
ENV PATH="/:$PATH"
COPY noisy-workload.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh

