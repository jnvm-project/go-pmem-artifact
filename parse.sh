#!/bin/bash

OPORDER=$1
MIN_ORDER=$2
MAX_ORDER=$3

DATAFILE=/results/data.dat
STATFILE=/results/stats.dat
BASEDIR=/results/exp10

convert() {
  declare $(echo $1 | awk '/m/{match($0,"([^ ]+)m([^ ]+)s",a); print "MIN="a[1]; print "SEC="a[2]} !/m/{match($0,"([^ ]+)s",a); print "MIN=0"; print "SEC="a[1]}')
  #strip=$(echo $1 | cut -d'm' -d's' -f1)
  #minutes=$(echo $strip | cut -d'm' -f1)
  #seconds=$(echo $strip | cut -d'm' -f2)
  #echo $minutes *60 + $seconds | bc -l
  echo $MIN *60 + $SEC | bc -l
}

get_runtime() {
  filename=$1
  runtime=$(grep "Run finished" $filename | awk '{ print $4 }')
  echo "$(convert $runtime) /60" | bc -l
}

gcTotalTime() {
  filename=$1
  gctotBegin=$(grep "^WarmupEnd:" $filename | awk -F'=| ' '{ print $12 }')
  gctotEnd=$(grep "^End:" $filename | awk -F'=| ' '{ print $12 }')
  LANG=C printf "%.5f\n" "$(echo "($gctotEnd - $gctotBegin) / (60*10^9)" | bc -l)"
}

totalcpu() {
  filename=$1
  totBegin=$(grep "^WarmupEnd:" $filename | awk -F'=| ' '{ print $14 }')
  totEnd=$(grep "^End:" $filename | awk -F'=| ' '{ print $14 }')
  totTime=$(echo "($totEnd - $totBegin) / (60*10^9)" | bc -l)
  LANG=C printf "%.5f\n" "$(echo "$totTime - $(gcTotalTime $filename)" | bc -l)"
}

get_recordsize() {
  LANG=C printf "%.2f\n" "$(echo "2^$i*2.37 / 1024 /1024" | bc -l)"
}

numGC() {
  filename=$1
  numGC=$(grep "^End:" $filename | awk -F '=| ' '{print $4}')
  echo $numGC
}

#gcCPUTime
echo "#gc CPU Time" > $DATAFILE
echo "#gc CPU Time" > $STATFILE
for i in $(seq ${MIN_ORDER} ${MAX_ORDER}); do
  line="$i\t$(get_recordsize $i)\t"
  str="$i\t$(get_recordsize $i)\t"
  file="${BASEDIR}/data_hpredis_run_rec${i}_op${OPORDER}"
  if [ -f "$file" ]; then
    str+="$( gcTotalTime $file )"
    str+='\t'
  fi
  echo -e $str >> $DATAFILE
  line+=$(echo -e $str | awk '{sum = 0; for (i = 3; i <= NF; i++) sum += $i; sum /= (NF-2); print sum}')
  echo -e $line >> $STATFILE
done


#Total Cpu Time
echo -e "\n\n#Total CPU Time" >> $DATAFILE
echo -e "\n\n#Total CPU Time" >> $STATFILE
for i in $(seq ${MIN_ORDER} ${MAX_ORDER}); do
  line="$i\t$(get_recordsize $i)\t"
  str="$i\t$(get_recordsize $i)\t"
  file="${BASEDIR}/data_hpredis_run_rec${i}_op${OPORDER}"
  if [ -f "$file" ]; then
    str+="$( totalcpu $file )"
    str+='\t'
  fi
  echo -e $str >> $DATAFILE
  line+=$(echo -e $str | awk '{sum = 0; for (i = 3; i <= NF; i++) sum += $i; sum /= (NF-2); print sum}')
  echo -e $line >> $STATFILE
done

#runtime
echo -e "\n\n#Runtime" >> $DATAFILE
echo -e "\n\n#Runtime" >> $STATFILE
for i in $(seq ${MIN_ORDER} ${MAX_ORDER}); do
  line="$i\t$(get_recordsize $i)\t"
  str="$i\t$(get_recordsize $i)\t"
  file="${BASEDIR}/data_hpredis_run_rec${i}_op${OPORDER}"
  if [ -f "$file" ]; then
    str+="$( get_runtime $file )"
    str+='\t'
  fi
  echo -e $str >> $DATAFILE
  line+=$(echo -e $str | awk '{sum = 0; for (i = 3; i <= NF; i++) sum += $i; sum /= (NF-2); print sum}')
  echo -e $line >> $STATFILE
done

#nb collections
echo -e "\n\n#NB Collections" >> $DATAFILE
echo -e "\n\n#NB Collections" >> $STATFILE
for i in $(seq ${MIN_ORDER} ${MAX_ORDER}); do
  line="$i\t$(get_recordsize $i)\t"
  str="$i\t$(get_recordsize $i)\t"
  file="${BASEDIR}/data_hpredis_run_rec${i}_op${OPORDER}"
  if [ -f "$file" ]; then
    str+="$( numGC $file )"
    str+='\t'
  fi
  echo -e $str >> $DATAFILE
  line+=$(echo -e $str | awk '{sum = 0; for (i = 3; i <= NF; i++) sum += $i; sum /= (NF-2); print sum}')
  echo -e $line >> $STATFILE
done
