#!/bin/bash

### TO BE CONFIGURED BY TESTER ###
NUMA_NODE=0
#The following parameters stand for log2 of number of records in database
#Final plot will show on x-axis the number of records in DB comprised between [MIN;MAX] 
MIN_ORDER_RECORD=17
MAX_ORDER_RECORD=23

### HARDCODED - DO NOT TOUCH ###
EXP=10
OPORDER=27
OPERATIONCOUNT=$(echo 2^${OPORDER} | bc -l)
EXP_DIR="/results/exp${EXP}"
YCSB_DIR=/root/go-ycsb
YCSB_BIN=${YCSB_DIR}/bin/go-ycsb
WORKLOAD_PATH=${YCSB_DIR}/workloads/workloadf

rm -rf ${EXP_DIR}
mkdir -p ${EXP_DIR}

for i in $(seq ${MIN_ORDER_RECORD} ${MAX_ORDER_RECORD}); do
	ORDER=$i
	RECORDCOUNT=$(echo 2^${ORDER} | bc -l)
	RECORDCOUNT2=$(echo $RECORDCOUNT - 100 | bc -l)
	echo $RECORDCOUNT $RECORDCOUNT2 $OPERATIONCOUNT

	VAR=$(echo "(30/(2^${ORDER}*2.4/1024/1024))*100" | bc -l)
	VARINT=$(echo "$VAR / 1" | bc)
	echo "GOGC = $VARINT"

	rm -f /pmem0/coucou

	numactl -N ${NUMA_NODE} -- ${YCSB_BIN} load hpredis -p recordcount=${RECORDCOUNT} -p threadcount=24 -p insertorder=ordered | tee ${EXP_DIR}/data_hpredis_load_rec${ORDER}_op${OPORDER}

	GOGC=${VARINT} numactl -N ${NUMA_NODE} --preferred=0 ${YCSB_BIN} run hpredis -P ${WORKLOAD_PATH} -p recordcount=${RECORDCOUNT2} -p operationcount=${OPERATIONCOUNT} -p threadcount=10 -p insertorder=ordered | tee ${EXP_DIR}/data_hpredis_run_rec${ORDER}_op${OPORDER}
done

/parse.sh ${OPORDER} ${MIN_ORDER_RECORD} ${MAX_ORDER_RECORD}

gnuplot /plot.pl 
