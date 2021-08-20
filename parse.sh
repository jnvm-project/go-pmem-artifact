#/bin/bash

if [ $# -ne 1 ]; then
  echo "Pass filename as single argument"
  exit 1
fi


filename=$1

convert() {
  declare $(echo $1 | awk '/m/{match($0,"([^ ]+)m([^ ]+)s",a); print "MIN="a[1]; print "SEC="a[2]} !/m/{match($0,"([^ ]+)s",a); print "MIN=0"; print "SEC="a[1]}')
  #strip=$(echo $1 | cut -d'm' -d's' -f1)
  #minutes=$(echo $strip | cut -d'm' -f1)
  #seconds=$(echo $strip | cut -d'm' -f2)
  #echo $minutes *60 + $seconds | bc -l
  echo $MIN *60 + $SEC | bc -l
}

get_runtime() {
  runtime=$(grep "Run finished" $filename | awk '{ print $4 }')
  echo $(convert $runtime)
}

get_recordcount() {
  recordcount=$(grep recordcount $filename | cut -d'=' -d'"' -f4)
  accur=$(echo "l($recordcount+100)/l(2)" | bc -l)
  echo "$accur / 1" | bc
}

get_gcrun() {
  gcrun=$(grep "^End:" $filename | awk -F'=|,|ns' '{ print $3 }')
  echo $gcrun  / 10^9 | bc -l
}

instime() {
  echo 0
}

gcins() {
  echo 0
}

readavg() {
  read=$(grep "READ " $filename | tail -n1 | awk -F',| ' '{ print $15 }')
  echo $read
}

rmwavg() {
  rmw=$(grep "READ_MODIFY_WRITE" $filename | tail -n1 | awk -F',| ' '{ print $13 }')
  echo $rmw
}

updateavg() {
  update=$(grep "UPDATE" $filename | tail -n1 | awk -F',| ' '{ print $13 }')
  echo $update
}

totalCPU() {
  totBegin=$(grep "^WarmupEnd:" $filename | awk -F'=| ' '{ print $14 }')
  totEnd=$(grep "^End:" $filename | awk -F'=| ' '{ print $14 }')
  echo $totEnd - $totBegin | bc -l
}

gcTotalTime() {
  gctotBegin=$(grep "^WarmupEnd:" $filename | awk -F'=| ' '{ print $12 }')
  gctotEnd=$(grep "^End:" $filename | awk -F'=| ' '{ print $12 }')
  echo $gctotEnd - $gctotBegin | bc -l
}

numGC() {
  numGC=$(grep "^End:" $filename | awk -F '=| ' '{print $4}')
  echo $numGC
}

#get_recordcount
#get_runtime
#get_gcrun
#instime
#gcins
#readavg
#rmwavg
#updateavg
#gcTotalTime
#totalCPU
echo -e "1\t$(get_recordcount)\t$(get_runtime)\t$(get_gcrun)\t$(instime)\t$(gcins)\t$(readavg)\t$(rmwavg)\t$(updateavg)\t$(gcTotalTime)\t$(totalCPU)\t$(numGC)"

