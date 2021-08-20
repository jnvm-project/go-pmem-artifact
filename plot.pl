set terminal png
set output '/results/runtime.png'

set style fill solid border -1
set boxwidth 0.75
load "/styles.inc"

set xlabel "Persistent dataset size (GB)"
set ylabel "Time (min)"
set style fill solid
#set key left top
set key outside
set tics nomirror
set border 3
set yrange [0:]
set ytics 0,20,200
set style arrow 1 nohead
set style data histogram
set style histogram rowstacked

plot \
'/results/stats.dat' index 1 using 3:xtic(2) ls 6 t sprintf("CPU compute time") ,\
'' index 0 using 3 ls 5 t sprintf("CPU GC time"),\
'' index 2 using ($1-17):($3):(0.35) lc 'black' with xerror title sprintf("completion time"),\
