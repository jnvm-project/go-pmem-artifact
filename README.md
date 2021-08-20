# go-pmem artifact

How to run this artifact ?

## Modify configuration parameters

Edit "TO BE CONFIGURED BY TESTER" section of `entrypoint.sh`.

## Build

```
sudo docker build .
```

## Run

```
mkdir -p volume
sudo docker run --privileged -v "$(pwd)"/volume:/results --mount type=bind,source=/pmem0,target=/pmem0 -it <CONTAINER_ID>
```

## View

Plots are in `volume` directory
