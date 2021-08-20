FROM debian:bullseye

VOLUME ["/results"]

RUN apt update && apt install -y git golang make
RUN git clone https://gitlab.inf.telecom-sudparis.eu/go-pmem/go-pmem.git /root/go-pmem && cd /root/go-pmem/src && ./make.bash
RUN git clone https://gitlab.inf.telecom-sudparis.eu/go-pmem/go-ycsb.git /root/go-ycsb && \
    cd /root/go-ycsb && make

RUN apt install -y gawk gnuplot numactl bc
ADD entrypoint.sh .
ADD parse.sh .
ADD plot.pl .
ADD styles.inc .

ENV MIN_ORDER=$MIN_ORDER
ENV MIN_ORDER=$MAX_ORDER
ENV NUMA_NODE=$NUMA_NODE

ENTRYPOINT /entrypoint.sh 
