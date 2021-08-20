# go-pmem artifact

How to run this artifact ?

## Build

```
sudo docker build .
```

## Run

`MIN_ORDER` and `MAX_ORDER` stand for log2 of number of records in database. Final plot will show on x-axis the number of records in DB comprised between [MIN;MAX]. By default MIN_ORDER=17 and MAX_ORDER=26 but this can be modifed for quicker execution time
`NUMA_NODE` is the NUMA node on which the script is run.

```
mkdir -p volume
sudo docker run --privileged -v "$(pwd)"/volume:/results --mount type=bind,source=/pmem0,target=/pmem0 -e MIN_ORDER=17 -e MAX_ORDER=26 -e NUMA_NODE=0 -it <container ID>
```

## View

Plots are in `volume` directory
