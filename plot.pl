set terminal png

set output '/results/runtime.png'
set title "YCSB runtime for workload=F,threadcount=10,operationcount=2^{27}"
set xlabel "number of records"
set ylabel "completion time (s)"
set boxwidth 0.5
set style fill solid
set key outside
set yrange [0:]
plot "/data.dat" using 3:xtic(2) with boxes lc rgb 'grey' title "runtime", '' using 4:xtic(2) with boxes lc rgb 'blue' title "gc pause time"

set output '/results/gc_pause.png'
set title "YCSB GC pause time for workload=F,threadcount=10,operationcount=2^{27}"
set xlabel "number of records"
set ylabel "GC pause time (s)"
set boxwidth 0.5
set style fill solid
set key outside
set yrange [0:]
plot "/data.dat" using 4:xtic(2) with boxes lc rgb 'blue' title "gc pause time"

set output '/results/operations_latencies.png'
set title "YCSB operation latency for workload=F,threadcount=10,operationcount=2^{27}"
set xlabel "number of records"
set ylabel "latency (µs)"
set style fill solid
set key outside
set yrange [0:]
plot "/data.dat" using 7:xtic(2) with histogram lc rgb 'grey' title "read", '' using 8:xtic(2) with histogram lc rgb 'blue' title "read-modify-write", '' using 9:xtic(2) with histogram lc rgb 'red' title "update"

set output '/results/gc_time.png'
set title "YCSB GC time for workload=F,threadcount=10,operationcount=2^{27}"
set xlabel "number of records"
set ylabel "GC total time"
set style fill solid
set key outside
set yrange [0:]
plot "/data.dat" using 10:xtic(2) with histogram lc rgb 'grey' title "gcTotalTime", '' using 11:xtic(2) with histogram lc rgb 'blue' title "TotalCPUTime"

set output '/results/num_gc.png'
set title 'number of GC'
set xlabel 'log2 of number of records'
set ylabel 'number of GC'
set style fill solid
set key outside
set yrange [0:]
plot "/data.dat" using 12:xtic(2) with histogram lc rgb 'grey' title "number of GC"

